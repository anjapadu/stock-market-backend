FROM postgres


ADD ./StockMarketBack/db.sql /docker-entrypoint-initdb.d
