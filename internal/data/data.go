package data

import (
	"context"
	"credit-analytics-backend/internal/conf"
	"credit-analytics-backend/internal/data/db"
	"database/sql"
	"os"
	"path/filepath"
	"time"

	"github.com/go-kratos/kratos/v2/log"
	"github.com/google/wire"
	_ "github.com/lib/pq"
)

// ProviderSet is data providers.
var ProviderSet = wire.NewSet(NewData, NewApplicationRepo, NewApplicantRepo, NewGreeterRepo, NewReferenceRepo, NewSurveyRepo, NewFinancialRepo, NewDecisionRepo, NewStorageService)

// Data .
type Data struct {
	db    *db.Queries
	sqlDB *sql.DB
}

// NewData initializes the database connection with proper pool settings.
func NewData(c *conf.Data, logger log.Logger) (*Data, func(), error) {
	l := log.NewHelper(logger)

	d, err := sql.Open(c.Database.Driver, c.Database.Source)
	if err != nil {
		l.Errorf("failed opening connection to %s: %v", c.Database.Driver, err)
		return nil, nil, err
	}

	// Production-grade connection pool settings.
	// MaxOpenConns prevents exhausting the DB server connection limit.
	d.SetMaxOpenConns(25)
	d.SetMaxIdleConns(10)
	d.SetConnMaxLifetime(5 * time.Minute)
	d.SetConnMaxIdleTime(2 * time.Minute)

	// Ping database to ensure connection is valid
	if err := d.Ping(); err != nil {
		l.Errorf("failed pinging database: %v", err)
		return nil, nil, err
	}

	// Auto migration & Seeding — only runs when DB_AUTO_MIGRATE=true.
	// WARNING: seed_dummy.sql must use INSERT ... ON CONFLICT DO NOTHING to be idempotent.
	if os.Getenv("DB_AUTO_MIGRATE") == "true" {
		l.Info("Starting database migration & seeding...")

		schemaFiles := []string{
			"internal/data/schema/schema.sql",
			"internal/data/schema/seed_dummy.sql",
		}

		for _, file := range schemaFiles {
			path := file
			// Check if we are running in a container where paths might be different
			if _, err := os.Stat(path); os.IsNotExist(err) {
				path = filepath.Join("..", "..", file) // fallback for local dev
			}

			if content, err := os.ReadFile(path); err != nil {
				l.Warnf("failed to read schema file %s: %v", path, err)
				continue
			} else {
				l.Infof("Executing schema: %s", path)
				if _, err := d.Exec(string(content)); err != nil {
					l.Errorf("failed to execute schema %s: %v", path, err)
				} else {
					l.Infof("Successfully executed %s", path)
				}
			}
		}
	}

	cleanup := func() {
		l.Info("closing the data resources")
		d.Close()
	}

	return &Data{
		db:    db.New(d),
		sqlDB: d,
	}, cleanup, nil
}

// InTx wraps a function in a database transaction.
// Rolls back automatically if the function returns an error.
func (d *Data) InTx(ctx context.Context, fn func(queries *db.Queries) error) error {
	tx, err := d.sqlDB.BeginTx(ctx, nil)
	if err != nil {
		return err
	}

	q := d.db.WithTx(tx)
	err = fn(q)
	if err != nil {
		if rbErr := tx.Rollback(); rbErr != nil {
			return rbErr
		}
		return err
	}

	return tx.Commit()
}
