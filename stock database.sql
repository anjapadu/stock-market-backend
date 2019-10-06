
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


CREATE TABLE users (
	uuid uuid not null primary key DEFAULT uuid_generate_v4(),
	username varchar(32) not null,
	password varchar(64) not null,
	admin boolean not null default false
);

insert into users (username, password, admin)  VALUES('admin', '2573198924', true);

CREATE TABLE exchange_rate(
	uuid uuid not null PRIMARY key DEFAULT uuid_generate_v4(),
	currency varchar(32) not null,
	rate decimal NOT NULL,
	created_at TIMESTAMP not null default now(),
	update_at TIMESTAMP not null DEFAULT now()
);


CREATE TABLE stocks (
	uuid uuid not null primary key DEFAULT uuid_generate_v4(),
	name varchar(128) not null,
	description varchar(256) null,
	companyName varchar(128) not null,
	quantity int not null DEFAULT 1000000,
	currency varchar(8) not null DEFAULT 'USD'
);


CREATE TABLE stock_price(
	uuid uuid not null primary key default uuid_generate_v4(),
	stock_uuid uuid NOT NULL REFERENCES stocks(uuid),
	close_price DECIMAL NOT NULL,
	timestamp TIMESTAMP not null default now(),
	change_price decimal not null default 0.0,
	change_percent decimal not null default 0.0
);

CREATE TABLE transactions (
	uuid uuid not null primary key default uuid_generate_v4(),
	status  varchar(16) not null,
	stock_price_uuid uuid not null references stock_price(uuid),
	created_at TIMESTAMP not null default now(),
	updated_at TIMESTAMP not null default now(),
	is_sell boolean not null default false,
	is_buy boolean not null default false
);

CREATE TABLE holdings (
	stock_uuid uuid not null REFERENCES stocks(uuid),
	user_uuid uuid not null REFERENCES users(uuid),
	quantity int not null	
);
