--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Drop databases (except postgres and template1)
--

DROP DATABASE gustavo;
DROP DATABASE stockmkt;




--
-- Drop roles
--

DROP ROLE gustavo;
DROP ROLE postgres;


--
-- Roles
--

CREATE ROLE gustavo;
ALTER ROLE gustavo WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;






--
-- PostgreSQL database dump
--

-- Dumped from database version 11.4
-- Dumped by pg_dump version 11.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

UPDATE pg_catalog.pg_database SET datistemplate = false WHERE datname = 'template1';
DROP DATABASE template1;
--
-- Name: template1; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


ALTER DATABASE template1 OWNER TO postgres;

\connect template1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: template1; Type: DATABASE PROPERTIES; Schema: -; Owner: postgres
--

ALTER DATABASE template1 IS_TEMPLATE = true;


\connect template1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: ACL; Schema: -; Owner: postgres
--

REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 11.4
-- Dumped by pg_dump version 11.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: gustavo; Type: DATABASE; Schema: -; Owner: gustavo
--

CREATE DATABASE gustavo WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


ALTER DATABASE gustavo OWNER TO gustavo;

\connect gustavo

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 11.4
-- Dumped by pg_dump version 11.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE postgres;
--
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


ALTER DATABASE postgres OWNER TO postgres;

\connect postgres

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 11.4
-- Dumped by pg_dump version 11.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: stockmkt; Type: DATABASE; Schema: -; Owner: gustavo
--

CREATE DATABASE stockmkt WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


ALTER DATABASE stockmkt OWNER TO gustavo;

\connect stockmkt

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: exchange_rate; Type: TABLE; Schema: public; Owner: gustavo
--

CREATE TABLE public.exchange_rate (
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    currency character varying(32) NOT NULL,
    rate numeric NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    update_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.exchange_rate OWNER TO gustavo;

--
-- Name: holdings; Type: TABLE; Schema: public; Owner: gustavo
--

CREATE TABLE public.holdings (
    stock_uuid uuid NOT NULL,
    user_uuid uuid NOT NULL,
    quantity integer NOT NULL
);


ALTER TABLE public.holdings OWNER TO gustavo;

--
-- Name: params; Type: TABLE; Schema: public; Owner: gustavo
--

CREATE TABLE public.params (
    name character varying(32) NOT NULL,
    type character varying(32) NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.params OWNER TO gustavo;

--
-- Name: stock_price; Type: TABLE; Schema: public; Owner: gustavo
--

CREATE TABLE public.stock_price (
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    stock_uuid uuid NOT NULL,
    close_price numeric NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL,
    change_price numeric DEFAULT 0.0 NOT NULL,
    change_percent numeric DEFAULT 0.0 NOT NULL
);


ALTER TABLE public.stock_price OWNER TO gustavo;

--
-- Name: stocks; Type: TABLE; Schema: public; Owner: gustavo
--

CREATE TABLE public.stocks (
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(128) NOT NULL,
    description text,
    companyname character varying(128) NOT NULL,
    quantity integer DEFAULT 1000000 NOT NULL,
    currency character varying(8) DEFAULT 'USD'::character varying NOT NULL,
    companylogo character varying(512)
);


ALTER TABLE public.stocks OWNER TO gustavo;

--
-- Name: transactions; Type: TABLE; Schema: public; Owner: gustavo
--

CREATE TABLE public.transactions (
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    status character varying(16) NOT NULL,
    stock_uuid uuid NOT NULL,
    stock_price_uuid uuid NOT NULL,
    user_uuid uuid NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    is_sell boolean DEFAULT false NOT NULL,
    is_buy boolean DEFAULT false NOT NULL,
    comission numeric NOT NULL,
    quantity integer NOT NULL,
    comission_rate numeric NOT NULL,
    total numeric NOT NULL
);


ALTER TABLE public.transactions OWNER TO gustavo;

--
-- Name: users; Type: TABLE; Schema: public; Owner: gustavo
--

CREATE TABLE public.users (
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    username character varying(32) NOT NULL,
    password character varying(64) NOT NULL,
    admin boolean DEFAULT false NOT NULL,
    balance double precision DEFAULT 50000.0 NOT NULL
);


ALTER TABLE public.users OWNER TO gustavo;

--
-- Data for Name: exchange_rate; Type: TABLE DATA; Schema: public; Owner: gustavo
--

COPY public.exchange_rate (uuid, currency, rate, created_at, update_at) FROM stdin;
7fe05003-21e2-403a-97f2-70d2156c9bd0	SOL	3.33	2019-10-06 17:20:39.09215	2019-10-06 17:20:39.09215
\.


--
-- Data for Name: holdings; Type: TABLE DATA; Schema: public; Owner: gustavo
--

COPY public.holdings (stock_uuid, user_uuid, quantity) FROM stdin;
\.


--
-- Data for Name: params; Type: TABLE DATA; Schema: public; Owner: gustavo
--

COPY public.params (name, type, value) FROM stdin;
comission	decimal	0.008
\.


--
-- Data for Name: stock_price; Type: TABLE DATA; Schema: public; Owner: gustavo
--

COPY public.stock_price (uuid, stock_uuid, close_price, "timestamp", change_price, change_percent) FROM stdin;
79d7cce6-c2db-4f17-9df0-f1f624c3e96d	e44f0c5d-47b8-42f5-b44b-17208bc89929	250.6	2019-10-06 12:02:14.560206	-6.83	-2.653
\.


--
-- Data for Name: stocks; Type: TABLE DATA; Schema: public; Owner: gustavo
--

COPY public.stocks (uuid, name, description, companyname, quantity, currency, companylogo) FROM stdin;
e44f0c5d-47b8-42f5-b44b-17208bc89929	MSF	Some description or extra comments	Microsoft	1000000	USD	\N
24f6a919-03b8-458c-820b-1e60317f8b1c	ULTA	Ulta salon Cosméticos & Fragancias es un retailer Norte Americano de Cosméticos, productos de cuidado de piel, cuidado del cabello y cuenta con salones de belleza. La compañía ofrece productos de mas de 500 marcas de belleza en todas las categorías y puntos de precio. Adicionalmente Ulta ofrece un servicio completo en cada una de sus tiendas. Las tiendas están posicionadas en locales que tienen alto tráfico y cuenta con 20,000 productos de belleza.	Ulta	1000000	USD	\N
e52afb74-db70-4f26-b43a-13e753ae511d	AMD	Advanced Micro Devices diseña y produce micro procesadores y procesadores de bajo poder para la computadora y industrias de electrónicos. La mayoría de las ventas de esta compañía están en el mercado de computadoras via CPUs y GPUs. AMD adquirió procesadores gráficos y producen chipsets ATI en el 2006 en un esfuerzo de mejorar su posicionamiento en la cadena de PC. En el 2009, la compañía dejó de producir para formar parte del proyecto GlobalFoundries.	AMD	1000000	USD	\N
f9cf9497-664e-4766-83d6-4bfe9ca11c32	Apple	La compañía Apple diseña una gran cantidad de equípos electrónicos al consumidor, se incluye: smartphones (iPhone), tablets (iPad), PCs (Mac), relojes inteligentes (Apple Watch), y TV (Apple TV). El iPhone representa el producto bandera y que genera más ingreso. Adicionalmente, Apple ofrece a sus consumidores una variedad de servicios como Apple Music, iCloud, Apple Pay, entre otros. Los productos Apple operan con un software y semiconductores propios. Apple es reconocida por sus integraciones, hardware, software y equipos. Los productos Apple son distribuidos online a través de sus propias tiendas y representantes de la marca. Apple obtiene un 40% de sus ingresos de Norte America y el resto internacionalmente.	Apple	1000000	USD	\N
03a8bc4e-4700-4614-94b0-4c323ddb3bfd	Hershey	Hershey es la confitería que lidera el mercado en los Estados Unidos (cerca de $25 billones), controla cerca de un 45% del mercado de chocolates. Más aya de su nombre, la compañía se ha expandido en los últimos 85 años y ahora consiste en más de 80 marcas, incluye Reese’s, Kit Kat, Kisses y Ice Breakers. Los productos Hershey son vendidos en 80 países, con solo entre 10 y 15 porciento del total de las ventas provienen de mercados fuera de Estados Unidos. La compañía se ha aventado a oportunidades inorgánicas para extender su alcance más aya de lo que es confitería. Primero se empezó con palomitas de maíz listas para comer y después con marcas Piratas como Smart Puffs.	Hershey	1000000	USD	\N
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: gustavo
--

COPY public.transactions (uuid, status, stock_uuid, stock_price_uuid, user_uuid, created_at, updated_at, is_sell, is_buy, comission, quantity, comission_rate, total) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: gustavo
--

COPY public.users (uuid, username, password, admin, balance) FROM stdin;
b85ec3a8-0353-4500-aaa6-5fa7cf10a0f4	anja	2573	f	50000
\.


--
-- Name: exchange_rate exchange_rate_pkey; Type: CONSTRAINT; Schema: public; Owner: gustavo
--

ALTER TABLE ONLY public.exchange_rate
    ADD CONSTRAINT exchange_rate_pkey PRIMARY KEY (uuid);


--
-- Name: stock_price stock_price_pkey; Type: CONSTRAINT; Schema: public; Owner: gustavo
--

ALTER TABLE ONLY public.stock_price
    ADD CONSTRAINT stock_price_pkey PRIMARY KEY (uuid);


--
-- Name: stocks stocks_pkey; Type: CONSTRAINT; Schema: public; Owner: gustavo
--

ALTER TABLE ONLY public.stocks
    ADD CONSTRAINT stocks_pkey PRIMARY KEY (uuid);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: gustavo
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (uuid);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: gustavo
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (uuid);


--
-- Name: holdings holdings_stock_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gustavo
--

ALTER TABLE ONLY public.holdings
    ADD CONSTRAINT holdings_stock_uuid_fkey FOREIGN KEY (stock_uuid) REFERENCES public.stocks(uuid);


--
-- Name: holdings holdings_user_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gustavo
--

ALTER TABLE ONLY public.holdings
    ADD CONSTRAINT holdings_user_uuid_fkey FOREIGN KEY (user_uuid) REFERENCES public.users(uuid);


--
-- Name: stock_price stock_price_stock_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gustavo
--

ALTER TABLE ONLY public.stock_price
    ADD CONSTRAINT stock_price_stock_uuid_fkey FOREIGN KEY (stock_uuid) REFERENCES public.stocks(uuid);


--
-- Name: transactions transactions_stock_price_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gustavo
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_stock_price_uuid_fkey FOREIGN KEY (stock_price_uuid) REFERENCES public.stock_price(uuid);


--
-- Name: transactions transactions_stock_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gustavo
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_stock_uuid_fkey FOREIGN KEY (stock_uuid) REFERENCES public.stocks(uuid);


--
-- Name: transactions transactions_user_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gustavo
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_user_uuid_fkey FOREIGN KEY (user_uuid) REFERENCES public.users(uuid);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

