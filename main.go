package main

import (
	"database/sql"
	"net/http"
	"os"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

import _ "github.com/go-sql-driver/mysql"

var db *sql.DB

func main() {

	e := echo.New()

	e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	e.GET("/live", func(c echo.Context) error {
		var err error
		db, err = sql.Open("mysql",os.Getenv("DB_URL") )
		if err != nil {
			return c.HTML(http.StatusOK, "Running")
		}

	
	
		pingErr := db.Ping()
		if pingErr != nil {
			return c.HTML(http.StatusOK, "Running")
		}
		db.Close()
		return c.HTML(http.StatusOK, "Well done")
	})

	httpPort := os.Getenv("PORT")
	

	e.Logger.Fatal(e.Start(":" + httpPort))
}