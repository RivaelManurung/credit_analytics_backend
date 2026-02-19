package data

import (
	"context"
	"credit-analytics-backend/internal/conf"
	"credit-analytics-backend/internal/data/db"
	"database/sql"

	"github.com/go-kratos/kratos/v2/log"
	"github.com/google/wire"
	_ "github.com/lib/pq"
)

// ProviderSet is data providers.
var ProviderSet = wire.NewSet(NewData, NewApplicationRepo, NewApplicantRepo, NewGreeterRepo)

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
