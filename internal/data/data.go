package data

import (
	"context"
	"credit-analytics-backend/internal/conf"
	"credit-analytics-backend/internal/data/db"
	"database/sql"
	"os"
	"path/filepath"

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

// NewData .
func NewData(c *conf.Data, logger log.Logger) (*Data, func(), error) {
	l := log.NewHelper(logger)

	d, err := sql.Open(c.Database.Driver, c.Database.Source)
	if err != nil {
		l.Errorf("failed opening connection to %s: %v", c.Database.Driver, err)
		return nil, nil, err
	}

	// Ping database to ensure connection is valid
	if err := d.Ping(); err != nil {
		l.Errorf("failed pinging database: %v", err)
		return nil, nil, err
	}

	// Auto migration & Seeding if DB_AUTO_MIGRATE=true
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

			content, err := os.ReadFile(path)
			if err != nil {
				l.Warnf("failed to read schema file %s: %v", path, err)
				continue
			}

			if _, err := d.Exec(string(content)); err != nil {
				l.Errorf("failed to execute schema %s: %v", path, err)
				// Continue to next file even if one fails
			} else {
				l.Infof("successfully executed %s", path)
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

// Transaction helper for SQLC
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
