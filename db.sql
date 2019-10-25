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

ALTER TABLE ONLY public.transactions DROP CONSTRAINT transactions_user_uuid_fkey;
ALTER TABLE ONLY public.transactions DROP CONSTRAINT transactions_stock_uuid_fkey;
ALTER TABLE ONLY public.transactions DROP CONSTRAINT transactions_stock_price_uuid_fkey;
ALTER TABLE ONLY public.stock_price DROP CONSTRAINT stock_price_stock_uuid_fkey;
ALTER TABLE ONLY public.holdings DROP CONSTRAINT holdings_user_uuid_fkey;
ALTER TABLE ONLY public.holdings DROP CONSTRAINT holdings_stock_uuid_fkey;
ALTER TABLE ONLY public.future_values DROP CONSTRAINT future_values_stock_uuid_fkey;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
ALTER TABLE ONLY public.transactions DROP CONSTRAINT transactions_pkey;
ALTER TABLE ONLY public.stocks DROP CONSTRAINT stocks_pkey;
ALTER TABLE ONLY public.stock_price DROP CONSTRAINT stock_price_pkey;
ALTER TABLE ONLY public.params DROP CONSTRAINT params_pkey;
ALTER TABLE ONLY public.exchange_rate DROP CONSTRAINT exchange_rate_pkey;
DROP TABLE public.users;
DROP TABLE public.transactions;
DROP TABLE public.stocks;
DROP TABLE public.stock_price;
DROP TABLE public.params;
DROP TABLE public.holdings;
DROP TABLE public.future_values;
DROP TABLE public.exchange_rate;
DROP EXTENSION "uuid-ossp";
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
-- Name: future_values; Type: TABLE; Schema: public; Owner: gustavo
--

CREATE TABLE public.future_values (
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    stock_uuid uuid NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    new_price numeric NOT NULL,
    has_new boolean DEFAULT false NOT NULL,
    new_text text,
    delay integer DEFAULT 0 NOT NULL,
    sent boolean DEFAULT false NOT NULL
);


ALTER TABLE public.future_values OWNER TO gustavo;

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
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
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
-- Data for Name: future_values; Type: TABLE DATA; Schema: public; Owner: gustavo
--

COPY public.future_values (uuid, stock_uuid, "timestamp", new_price, has_new, new_text, delay, sent) FROM stdin;
87497ba6-04cf-4d16-a167-264f52e47e52	b65ad095-d3d3-4281-9765-0c724afba7af	2019-01-04 00:00:00	10.94	f	\N	0	t
901d1fac-1e18-429b-86ea-08e5ae006dd9	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-01-11 00:00:00	9.899	f	\N	0	t
ce6cecc6-26da-481f-a840-0d966fc88d2d	08976987-dd81-414e-9789-4ab9d173a238	2019-01-04 00:00:00	21.3	f	\N	0	t
ef60cb77-6463-45ef-ab1e-fd80479d4271	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2018-12-24 00:00:00	49.26	t	Wall Street cierra con fuertes pérdidas en la peor víspera de Navidad de su historia. Wall Street cerró el 24 de diciembre con fuerte pérdidas. Sus tres principales índices Dow Jones, S&P500, y NASDAQ experimentaron pérdidas de -2.91%, -2.71% y -2.21%, respectivamente. Según analistas, hay temor a la desaceleración de la economía mundial y a la inestabilidad política derivada del tercer día consecutivo del cierre de la Administración de los EE.UU.	0	t
a5b2adf3-4f7a-4720-ad42-b90233413a9b	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-02-01 00:00:00	164.5476	f	\N	0	t
ff80f74a-bd9b-4efc-aaf9-f24f3cd962c5	5aef4508-b970-4a28-bd12-1b19015f584f	2019-02-15 00:00:00	417.97	f	\N	0	t
aad1a13c-ad62-4224-bfcc-6d23f44cdac5	f3579400-2263-474d-92b8-b03e2c434915	2019-02-08 00:00:00	23.05	f	\N	0	t
d3e3512e-37fd-4eb7-9146-bfe992513493	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-02-15 00:00:00	1.86	f	\N	0	t
e25ed136-a86c-48b1-b00e-717065369e12	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-01-11 00:00:00	1640.56	f	\N	0	t
2b926123-21cd-4147-9b39-e71d69df179e	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-02-22 00:00:00	40.74	f	\N	0	t
aec74603-7778-401d-b851-a0e3fd0c3366	08976987-dd81-414e-9789-4ab9d173a238	2019-02-15 00:00:00	22.43	f	\N	0	t
7daf8e92-6d14-4576-afd3-64c68e9669ab	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-02-22 00:00:00	1.85	f	\N	0	t
5c641a16-135b-4c27-a984-f283fbe15215	b65ad095-d3d3-4281-9765-0c724afba7af	2019-02-22 00:00:00	11.1	f	\N	0	t
89aa336b-3dce-41a0-85c1-66779bf81e90	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-03-08 00:00:00	5.056	f	\N	0	t
875c2659-f6c0-4701-8f92-8459e9c0fc38	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-03-08 00:00:00	2.78	f	\N	0	t
b2211ea4-9850-4b53-8e59-948d4e3b2225	4a4061ee-3175-477f-b598-7104ed81818e	2019-04-26 00:00:00	235.14	f	\N	0	f
44fa88df-8dc7-4660-bb94-580e431b6437	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-04-12 00:00:00	2.66	f	\N	0	f
c197dfc7-3b2b-4d76-a99b-9c3fb60ce8a7	08976987-dd81-414e-9789-4ab9d173a238	2019-04-05 00:00:00	22.43	f	\N	0	f
76194faa-b5f5-438b-ba50-cc44ef41ebf2	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-04-05 00:00:00	65.55	f	\N	0	f
d62c67dc-9424-481e-b581-19a6c7ca9a02	5aef4508-b970-4a28-bd12-1b19015f584f	2019-04-19 00:00:00	380.07	f	\N	0	f
6e0259e2-22e2-4ed5-ab43-afa39cd0d859	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-04-19 00:00:00	89.2	f	\N	0	f
bf151847-4802-46b8-ab89-78755f5ee4dd	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-04-12 00:00:00	0.6	f	\N	0	f
c06964ff-a896-47fa-992f-21656f84f4d8	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-04-26 00:00:00	31.2169	f	\N	0	f
58f4c566-11dd-4cf7-a9c3-90ea7afad693	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-04-26 00:00:00	202.7459	f	\N	0	f
24b09c9a-3e2b-4dd3-a484-defcbf565457	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-05-03 00:00:00	85.7	f	\N	0	f
63a91b61-14d4-47c7-83c5-42ab4b06d81d	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-05-07 00:00:00	30.4826	f	\N	0	f
f58a8d7d-80f4-480a-bfb6-67717fba224e	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-08-30 00:00:00	84.5	f	\N	0	f
7c7ce329-8fa4-4594-8961-ce81f436d2c6	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-09-05 00:00:00	2.33	f	\N	0	f
32ae4c7a-954e-409b-9671-af7b5c84a922	b65ad095-d3d3-4281-9765-0c724afba7af	2019-10-04 00:00:00	24	t	La compañía Sempra Energy anunció la venta de su participación del 83,6% de Luz del Sur S.A.A. a la empresa China Yangtze Power International Co., Limited (CYP). El valor de venta fue de 3.590 millones de dólares en efectivo.	0	f
1425d182-4522-421e-90c5-147ed85a209e	3854af87-a18e-4509-be17-6145a85578b6	2019-09-20 00:00:00	126.97	f	\N	0	f
1a4b6419-6e03-455f-97fc-88710b44b376	3854af87-a18e-4509-be17-6145a85578b6	2019-09-27 00:00:00	120.77	f	\N	0	f
e770f81b-dcc6-49d7-a75f-bb0dc5642968	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-04-26 00:00:00	101.53	f	\N	0	f
6805c2ca-61b3-49da-8104-56c2e1c50f8a	110c6254-9596-4e36-a939-8f7a2d557a35	2019-05-24 00:00:00	181.06	f	\N	0	f
527db0fd-08b8-42a0-9174-62b9e0df6de4	5aef4508-b970-4a28-bd12-1b19015f584f	2019-01-18 00:00:00	364.73	f	\N	0	t
f773572f-7e0b-4608-ba4a-2e232c1fda37	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-01-18 00:00:00	97.73	f	\N	0	t
5d183b2f-1ed8-43c0-8c4b-696f5c753669	f3579400-2263-474d-92b8-b03e2c434915	2019-01-31 00:00:00	24.41	t	AMD obtuvo un beneficio neto atribuido de 337 millones de dólares, lo cual representó un gran crecimiento frente a los 33 millones que registró en la misma fecha hace 12 meses. Estas noticias significarán un gran avance para la industria tecnológica.	0	t
bfc4e89d-0505-4d3d-b2ca-a114d481f8b8	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-02-22 00:00:00	363.02	f	\N	0	t
49303e2b-846c-4870-9472-903925f1b8e2	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-03-13 00:00:00	2.86	f	\N	0	t
db9daf40-a977-481b-a160-530debf4a40c	5aef4508-b970-4a28-bd12-1b19015f584f	2019-07-19 00:00:00	377.36	f	\N	0	f
a84437eb-3e5b-4009-b6ce-136f6392f988	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-03-01 00:00:00	357.32	f	\N	0	f
5e80b633-28ae-44e4-a0a2-f87123623d68	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-03-22 00:00:00	53.26	f	\N	0	f
73df22c8-3f86-44a5-b38d-0d6fd22f9329	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-03-15 00:00:00	184.7042	f	\N	0	f
c43dc340-8f75-4b3c-a840-3ce78a1b62d4	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-03-29 00:00:00	2.347	f	\N	0	f
47c8706c-48b3-41e4-99d4-da360c965eb2	c2db4b85-9098-4110-9761-fbd6a846707c	2019-03-29 00:00:00	42.47	f	\N	0	f
30619746-0f55-4e8a-9a66-85db5809a9ce	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-03-29 00:00:00	2.73	f	\N	0	f
8bc508c5-e521-4981-84fc-ea4df5b729c9	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-03-22 00:00:00	0.66	f	\N	0	f
93ba1551-a7b1-40f5-bcfb-657cea0f6a61	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-03-18 00:00:00	65.19	t	Citigroup es reconocido como el banco número uno en México, liderando el mercado en emisión de tarjetas. Asimismo fue nombrado el mejor proveedor de divisas y mercado de capital. "También estamos orgullosos de ser el banco más comprometido con México, sirviendo a las comunidades donde operamos en todo el país”, dijo Corbat.	0	f
d7570f11-830b-4744-9d98-682edc28278a	c2db4b85-9098-4110-9761-fbd6a846707c	2019-07-26 00:00:00	43.09	f	\N	0	f
db26c832-cfb6-4ce7-bd3d-47ba6a409ee8	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-08-23 00:00:00	131.67	f	\N	0	f
17d647cc-e32f-4bec-b16b-f6064bf95c3d	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-09-13 00:00:00	5	f	\N	0	f
e071aa4a-fe52-4726-925d-c848dce66a7a	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-08-30 00:00:00	1.67	f	\N	0	f
d12294bc-44cb-49bd-becc-93e059497f96	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-09-06 00:00:00	65.97	f	\N	0	f
486347ac-abb3-42eb-92b6-7088cbd71e9b	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-03-29 00:00:00	0.62	f	\N	0	f
aeb9bf04-5324-46c1-8e2c-1e59ab78d5ba	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-04-09 00:00:00	2.38	f	\N	0	f
af633570-2d47-4fa4-8a5a-4907bd4ae638	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-03-29 00:00:00	97.53	f	\N	0	f
811ce110-9102-44ae-8a08-1167366fd5fc	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-04-05 00:00:00	136.18	f	\N	0	f
ab8a2a5e-b6d7-4d4f-a77e-0337a2f92a57	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-04-12 00:00:00	5.322	f	\N	0	f
46fcea0d-2107-4860-8785-21503c08ada3	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-04-12 00:00:00	10.858	f	\N	0	f
d21d31c6-acc1-4023-bd1f-3aea12b04858	5aef4508-b970-4a28-bd12-1b19015f584f	2019-04-12 00:00:00	379.64	f	\N	0	f
9b71fa30-bc21-4d77-ae47-d6f1dcead6e2	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-04-05 00:00:00	98.83	f	\N	0	f
1268a8bc-0c5d-4eeb-96a6-7805ba679f5f	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-04-19 00:00:00	48.64	f	\N	0	f
ecf1a751-d183-4397-8cfc-8f3408480f61	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-04-12 00:00:00	56.42	f	\N	0	f
b557d309-1320-427f-8834-569b58ff7a34	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-03-29 00:00:00	62.22	f	\N	0	f
13b87174-815b-428f-8ae4-e87148df1bec	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-03-01 00:00:00	1671.73	f	\N	0	f
b6ab97a4-c8eb-488c-b088-1b10b5b062da	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-04-19 00:00:00	2.20	f	\N	0	f
65bd37b7-d429-4806-ac28-761321e7fdf5	c2db4b85-9098-4110-9761-fbd6a846707c	2019-05-03 00:00:00	41.39	t	La farmacéutica Pfizer anunció hoy que en el primer trimestre del año su beneficio neto fue de 3.884 millones de dólares (unos 3.462 millones de euros) un 9 % más que en el mismo período de 2018, cuando fueron de 3.561 millones (unos 3,174 millones de euros), con lo que supera las expectativas de los analistas.	0	f
d60835d4-cd13-4932-9a44-eed640628c74	4a4061ee-3175-477f-b598-7104ed81818e	2019-06-21 00:00:00	221.86	f	\N	0	f
638a4c11-892e-48ef-91b0-988c81d65207	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-06-21 00:00:00	37.3525	f	\N	0	f
cf907b06-0114-44aa-bf90-90cd937b5b53	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-06-21 00:00:00	142.09	f	\N	0	f
52d77f49-15e5-4934-91c6-6e6fcebca632	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-06-28 00:00:00	10.330	f	\N	0	f
aef63a1a-537f-467e-a200-13cc59a13ace	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-01-11 00:00:00	129.75	f	\N	0	t
74d911b1-f38a-4896-885a-7fa488023f0d	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-01-11 00:00:00	2.413	f	\N	0	t
2c5a144c-22a4-423e-bea3-d7eabcfd76c0	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-01-11 00:00:00	2.60	f	\N	0	t
1ca4b6ba-e99e-45d6-992e-975a489e8fa8	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-01-25 00:00:00	155.8914	f	\N	0	t
1c8c28e3-b513-4b58-ab9b-402fc49cd191	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-02-15 00:00:00	5.15	f	\N	0	t
5274e4c0-f477-4578-b111-189cb3e63a96	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-02-08 00:00:00	169.1137	f	\N	0	t
02016cd0-a71b-4f9d-a1f9-aa5b994ca65d	b65ad095-d3d3-4281-9765-0c724afba7af	2019-03-01 00:00:00	12.1	f	\N	0	t
0f8a7ed2-bac2-4f94-bd36-eab9c5cc9e92	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-03-15 00:00:00	114.96	f	\N	0	t
0ff716a6-f5ee-4d12-84d4-2d3efd84c769	4a4061ee-3175-477f-b598-7104ed81818e	2019-03-29 00:00:00	279.86	f	\N	0	t
0115146e-26e2-4f2c-a2c7-a6c6e24da0b0	08976987-dd81-414e-9789-4ab9d173a238	2019-03-08 00:00:00	22.37	f	\N	0	t
38bb1fdb-23b5-4855-be8b-67a3d4bba725	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-07-05 00:00:00	38.279	f	\N	0	f
b1554093-b0a0-4983-931f-0801167a6648	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-06-28 00:00:00	83.95	f	\N	0	f
4341d0c4-ebc8-48aa-a381-c60127eecb7c	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-07-05 00:00:00	86.82	f	\N	0	f
5ce57804-3018-4f1b-892a-3a2ff03bd862	08976987-dd81-414e-9789-4ab9d173a238	2019-03-22 00:00:00	22.78	f	\N	0	f
57dae15c-a762-404c-8ad6-5d9df68f3d90	f3579400-2263-474d-92b8-b03e2c434915	2019-03-22 00:00:00	26.37	f	\N	0	f
8c5649dd-cf24-4df4-ab7b-553abcfbc1ff	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-04-25 00:00:00	2.328	t	El cierre de la carretera a Las Bambas sumadas a la incertidumbre y rechazo por parte de los pobladores, ha causado que los proyectos mineros Quellaveco y Mina Justa sean detenidos temporalmente. Para el ultimo trimestre del año 2018 y el primero del 2019 la accion se mantenia en alce. El caso de Las Bambas afecta las expectativas para otros proyectos del sector.	0	f
20fb24ef-8d86-4071-aae5-e947862cf168	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-04-26 00:00:00	2.45	f	\N	0	f
a1c45b78-91a2-4b65-a84a-64de1453f643	3854af87-a18e-4509-be17-6145a85578b6	2019-06-28 00:00:00	140.29	f	\N	0	f
56215f8c-f117-459a-8045-ea9dea46ebe6	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-04-19 00:00:00	202.3093	f	\N	0	f
966bb112-7b6a-44ef-b2b9-31aece6308c8	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-05-10 00:00:00	2.48	f	\N	0	f
cf712cc7-0960-4684-a8b0-dca99db7c58e	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-04-12 00:00:00	351.14	f	\N	0	f
a6f0e62e-10a1-4fb8-b93a-6327f77d148f	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-08-01 00:00:00	10.010	f	\N	0	f
4bc55bc3-56c5-48e3-91d6-d8942106f3a2	5aef4508-b970-4a28-bd12-1b19015f584f	2019-08-02 00:00:00	339.56	f	\N	0	f
9a06c5ad-9aa5-4182-9ed0-43750ed3bcd1	08976987-dd81-414e-9789-4ab9d173a238	2019-08-02 00:00:00	27.77	f	\N	0	f
98721a15-244a-4194-809a-86d1cf87776e	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-07-30 00:00:00	112.06	f	\N	0	f
a063b630-0432-41cf-963e-7a7f6622fc9b	3854af87-a18e-4509-be17-6145a85578b6	2019-07-05 00:00:00	142.01	f	\N	0	f
7ef750ae-1f08-40a5-b55c-cdebfc7efb25	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-08-02 00:00:00	203.2478	f	\N	0	f
b9fa8a0d-5992-431c-811e-e81875e0e476	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-08-02 00:00:00	10.150	t	El consumo masivo en el peru registro ventas por 828 millones con un crecimiento del 22.1% respecto al año anterior. Alicorp se sumo al alza con un incremento del 16% elevando sus acciones de un dia a otro.  Gracias a la compra de Intradevco, Fino y Sao (aceites)	0	f
7f8aa61f-30c0-4742-a56c-1730f26db58e	3854af87-a18e-4509-be17-6145a85578b6	2019-07-12 00:00:00	142.55	f	\N	0	f
0a97f7ef-1e40-4afd-ac92-de73d361c1d4	3854af87-a18e-4509-be17-6145a85578b6	2019-07-19 00:00:00	137.73	f	\N	0	f
2a9f77b5-b13b-4a62-bb16-f22684513a40	b65ad095-d3d3-4281-9765-0c724afba7af	2019-08-23 00:00:00	15	f	\N	0	f
ab87939c-c75b-491e-97a4-e38e9b958b81	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-08-23 00:00:00	0.41	f	\N	0	f
f9204a3e-9dad-40d1-9707-79f7241dacac	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-04-26 00:00:00	0.55	f	\N	0	f
f31a63c8-89dc-441e-a14b-ca78fd1be268	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-01-04 00:00:00	127.83	f	\N	0	t
fcf10e6a-85d3-42f2-b84c-f6df1d3da66a	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-01-04 00:00:00	2.28	f	\N	0	t
c4fa2b7d-e312-4df7-8534-39b38a1cf459	f3579400-2263-474d-92b8-b03e2c434915	2018-12-28 00:00:00	17.82	f	\N	0	t
e13d281c-2571-41ee-9fb2-1ff1b0be0c8f	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-01-04 00:00:00	5.039	f	\N	0	t
b29e5799-27f3-47a6-b46a-f9fc83a4763a	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-01-18 00:00:00	4.987	f	\N	0	t
5f9a1fd8-2e4d-403d-901e-1dcfe35d77be	08976987-dd81-414e-9789-4ab9d173a238	2019-01-11 00:00:00	21.08	f	\N	0	t
0aa45e1b-bfc0-40a6-bff7-562c62397cb4	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-02-06 00:00:00	5.579	t	El tipo de cambio cerró a la baja este miércoles por tercera sesión consecutiva debido a ofertas de dólares de bancos con posiciones altas y de inversionistas extranjeros, que fueron absorbidas en parte por empresas locales.	0	t
427f33aa-4b32-4561-a5b8-8683be3f8829	b65ad095-d3d3-4281-9765-0c724afba7af	2019-02-15 00:00:00	11.25	f	\N	0	t
dcac31a9-9c6b-4db0-a40d-03103ebd44ae	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-03-01 00:00:00	2.70	f	\N	0	t
1b70009f-65ab-4cdc-b90d-502265fe99cb	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-02-15 00:00:00	356.87	f	\N	0	t
9694e55c-026e-407b-bf79-2704d75f48d2	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-03-01 00:00:00	0.67	f	\N	0	t
3ea262f7-9e50-4a64-b898-bc7e86e4e32f	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-05-17 00:00:00	2.38	f	\N	0	f
3359c494-49cd-4aa4-9cbe-11f0b39cc4d6	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-05-10 00:00:00	2.60	f	\N	0	f
1f9848fa-481c-4267-8d43-4db9a7baa528	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-05-03 00:00:00	210.1393	f	\N	0	f
d7f421d9-2aac-4126-abb1-edbff86f5830	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-05-03 00:00:00	0.54	f	\N	0	f
3af21b8a-0fa4-4b8f-bc04-ef66b1417353	08976987-dd81-414e-9789-4ab9d173a238	2019-05-03 00:00:00	20.29	f	\N	0	f
ba430a3b-26f2-456b-b36d-a043ffc64430	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-06-07 00:00:00	10.550	f	\N	0	f
1ce6a20d-c0b9-4776-8214-1df9a19f3eb6	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-06-07 00:00:00	35.5391	t	La cotización del oro sube por octava sesión consecutiva y toca brevemente los 1348 $ la onza, un máximo no visto desde finales de abril de 2018.\nLa debilidad del mercado laboral de Estados Unidos parece haber reforzado la probabilidad de recortes en la tasa de la Fed, deprimiendo al dólar e impulsando al precio del oro.	0	f
11ef5358-8f0a-47b1-97c7-260e483a47b6	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-06-14 00:00:00	41.38	f	\N	0	f
f03c9a4d-45cf-4022-b686-c1173acb61a7	08976987-dd81-414e-9789-4ab9d173a238	2019-07-05 00:00:00	25.39	f	\N	0	f
3d957b38-9692-4f8d-ba9a-534c3bdd4b0b	b65ad095-d3d3-4281-9765-0c724afba7af	2019-09-13 00:00:00	16.5	f	\N	0	f
4c422a0b-ed2b-4d18-a6b8-cbbf5fb41bc3	f3579400-2263-474d-92b8-b03e2c434915	2019-09-20 00:00:00	30.05	f	\N	0	f
3392a179-e416-4b0a-b11d-cb6f349470f3	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-03-29 00:00:00	139.79	f	\N	0	f
f657e3fc-910a-4ee7-92ad-eb2af5174543	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-03-29 00:00:00	35.4936	f	\N	0	f
15e3c36b-230e-49ea-badc-28d9ccf32274	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-04-05 00:00:00	2.70	f	\N	0	f
bc961290-3204-4e41-8e29-011f5352c3a2	c2db4b85-9098-4110-9761-fbd6a846707c	2019-04-05 00:00:00	42.99	f	\N	0	f
bcccb68f-f7e0-432d-b93b-284d9a115270	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-03-15 00:00:00	361.46	f	\N	0	f
2fa3f195-c16e-484a-b539-de87476c24cf	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-08-09 00:00:00	1.82	f	\N	0	f
0d766b32-f5fe-43b2-a11c-75dc8d7bbf9f	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-08-09 00:00:00	200.99	f	\N	0	f
78e5deea-2a38-4312-9a44-fcb6512addec	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-09-20 00:00:00	116.98	f	\N	0	f
3dd16e98-5c6f-47c4-8fda-e3f599aaa98e	b65ad095-d3d3-4281-9765-0c724afba7af	2019-09-20 00:00:00	16.25	f	\N	0	f
e45e5054-7fce-4ba2-8a9c-3e4b2e4ea0b9	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-09-27 00:00:00	69.46	f	\N	0	f
7a2afa19-185e-4e0c-874e-13b71c0b8560	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-10-07 00:00:00	1.98	f	\N	0	f
2a71729a-455e-40ee-90ab-ed2a8c472ab4	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-09-27 00:00:00	38.4	f	\N	0	f
7b9aa7d2-85a8-429c-923d-56bac79f483a	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-09-27 00:00:00	129.96	f	\N	0	f
c6aa5d22-a240-44fe-a07d-817708e5400e	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-09-27 00:00:00	118.45	f	\N	0	f
459e5d74-998b-4653-b760-d6efecbd0d11	f3579400-2263-474d-92b8-b03e2c434915	2019-03-29 00:00:00	25.52	f	\N	0	f
9fda1fd9-3f2e-4f85-aca0-ec2f486486ab	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-03-29 00:00:00	188.5051	f	\N	0	f
b43b653a-e947-452e-aeca-b69ac590d0a9	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-03-22 00:00:00	361.01	f	\N	0	f
b185cde3-24c3-47ad-b411-83b64b5d1af1	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-01-04 00:00:00	0.69	f	\N	0	t
c88a600b-269b-415a-a4db-571b2f12efbc	3854af87-a18e-4509-be17-6145a85578b6	2018-12-14 00:00:00	107.66	f	\N	0	t
50275458-9b5f-4497-ac19-aece5d7a50f5	b65ad095-d3d3-4281-9765-0c724afba7af	2019-01-11 00:00:00	10.9	f	\N	0	t
5a5906a1-972a-4bc3-bf19-c30128990df5	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-03-01 00:00:00	87.16	f	\N	0	t
f5dbb541-afbc-4bb0-be24-9ce50f5eb6a7	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-03-22 00:00:00	2.356	f	\N	0	f
98d0e610-499f-4e0c-9bb1-ae4cf297ae8e	b65ad095-d3d3-4281-9765-0c724afba7af	2019-04-05 00:00:00	12.2	f	\N	0	f
552f152f-ecdf-45a1-bb08-dac86e86f15f	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-04-12 00:00:00	135.98	f	\N	0	f
0eebe151-d418-4340-aa73-06c6b02456f9	c2db4b85-9098-4110-9761-fbd6a846707c	2019-04-26 00:00:00	39.97	f	\N	0	f
aa2dd964-ce26-41af-bf20-ab8b6d86b056	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-05-17 00:00:00	2.45	f	\N	0	f
8d56e194-61ea-4b4a-9bc7-8d1e277a64a9	4a4061ee-3175-477f-b598-7104ed81818e	2019-05-31 00:00:00	185.16	f	\N	0	f
b4e68e45-bf71-4e17-92bd-4b5c7c302832	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-05-31 00:00:00	5.15	f	\N	0	f
9f00a741-ceb6-454c-b2b7-6e3f29627186	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-04-26 00:00:00	1950.63	f	\N	0	f
fc2f5506-8089-4ab5-a8f0-8eed436ce9cd	f3579400-2263-474d-92b8-b03e2c434915	2019-06-10 00:00:00	32.41	f	\N	0	f
627cda0d-42e7-4d08-9f5e-2ddaa73351eb	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-06-21 00:00:00	2.15	f	\N	0	f
c72f7174-d8ab-4bd0-98c2-e86cfd86c871	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-07-05 00:00:00	5.2	f	\N	0	f
c937aad0-d60e-4944-bfdc-664e291578b7	f3579400-2263-474d-92b8-b03e2c434915	2019-07-05 00:00:00	31.5	f	\N	0	f
06fc36d1-5c2a-4b42-bbb1-086fc6983d7e	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-07-05 00:00:00	1.98	f	\N	0	f
cf3bf66c-71e0-435e-8d3c-687670f55065	b65ad095-d3d3-4281-9765-0c724afba7af	2019-07-05 00:00:00	14.07	f	\N	0	f
1ea90e33-2e7d-40ce-80fe-0300f461eaec	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-07-05 00:00:00	203.457	f	\N	0	f
fbd8c16f-6ff3-427a-bfc6-f0dd97ecaee1	f3579400-2263-474d-92b8-b03e2c434915	2019-07-12 00:00:00	33.21	f	\N	0	f
f78ffe52-d314-40eb-b1d3-30bdba71f897	110c6254-9596-4e36-a939-8f7a2d557a35	2019-03-29 00:00:00	166.69	f	\N	0	f
cc76c9d1-1e1a-41a4-9e4d-62e792071b7c	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-03-08 00:00:00	349.6	f	\N	0	f
f0e801d7-6291-43eb-8086-2a32666cea13	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-03-29 00:00:00	111.03	f	\N	0	f
ef860aed-05e5-4250-a289-791c717423a2	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-02-15 00:00:00	1607.95	f	\N	0	f
0edadb8e-d2fd-48be-a64b-181f0922f57d	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-10-07 00:00:00	57.22	f	\N	0	f
acd02cb0-4ffa-4eb3-953f-7486e3381369	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-07-26 00:00:00	2.23	t	Prensentación de estados financieros a la bolsa de valores de Lima. Ha mostrado resultados crecientes en el ultimo trimestre. En Andrean Daily Report, la recomendación de inversion en Peú para esta fecha fue la compra de de acciones de la empresa Ferreyros.	0	f
dd90b805-138e-473e-a512-b9df026540e0	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-08-16 00:00:00	38.4385	f	\N	0	f
e154cc2a-a99e-41df-9e67-38e94ef68374	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-08-14 00:00:00	1.62	f	\N	0	f
c2af1cff-9d5a-42c7-a4aa-00627d72c9dc	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-08-30 00:00:00	2.05	f	\N	0	f
a37e7dbc-77d1-4ea0-980c-d8d3482010aa	b65ad095-d3d3-4281-9765-0c724afba7af	2019-08-16 00:00:00	14.5	f	\N	0	f
27482ca2-80fe-430c-96af-a3a816ff3d02	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-08-23 00:00:00	127.73	f	\N	0	f
c35a8289-109f-4a1c-8362-78d9ce16eadf	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-08-23 00:00:00	110.83	f	\N	0	f
73fd700d-ba01-414c-888f-e775ceaeefa1	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-04-12 00:00:00	130.06	f	\N	0	f
6365dd4f-57db-4d96-a223-7553cf30a92a	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-08-30 00:00:00	128.36	f	\N	0	f
e415e24a-ef49-4d84-ba43-8f8fd84c4e48	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-09-11 00:00:00	66.30	t	Ambarella anunció resultados de ganancias de 56.4 millones de dólares, sobrepasando las estimaciones en 4.37 millones de dólares con un incremento secuencial de 20%.	0	f
0b256cc7-2f97-4a89-a247-2faddef823e0	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-01-04 00:00:00	9.782	f	\N	0	t
79bed6e0-1fbd-4a76-9f6e-fe7b0b6649d7	07618a28-45f0-4f9a-bf47-7e55e517ce21	2018-12-14 00:00:00	233.88	t	Wall Street cierra con fuertes pérdidas en la peor víspera de Navidad de su historia. Wall Street cerró el 24 de diciembre con fuerte pérdidas. Sus tres principales índices Dow Jones, S&P500, y NASDAQ experimentaron pérdidas de -2.91%, -2.71% y -2.21%, respectivamente. Según analistas, hay temor a la desaceleración de la economía mundial y a la inestabilidad política derivada del tercer día consecutivo del cierre de la Administración de los EE.UU.	0	t
442d67fd-17f3-45f6-bb72-25dfcbe1f621	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-01-18 00:00:00	80.45	f	\N	0	t
ba95e502-7817-4856-ae6f-895c2f0b5efa	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-01-25 00:00:00	128.23	f	\N	0	t
97301784-b545-45ca-a741-2ad170bfa2b3	07618a28-45f0-4f9a-bf47-7e55e517ce21	2018-12-17 00:00:00	337.59	f	\N	0	t
5f33e9ab-9e4d-49f4-b310-f4ef059a3d60	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-02-15 00:00:00	64.27	f	\N	0	t
93649231-6f50-476b-87db-5e511f397107	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-03-22 00:00:00	34.2334	f	\N	0	f
6683286c-c29f-471c-bf6b-8fe09e56e95a	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-02-08 00:00:00	1588.22	f	\N	0	f
580513c6-0440-40d5-8503-8c0ff1475fbf	110c6254-9596-4e36-a939-8f7a2d557a35	2019-03-15 00:00:00	165.98	f	\N	0	f
c9aafb4b-44aa-4986-90fe-eb2445957a35	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-03-07 00:00:00	61.9	f	\N	0	f
b7ab6610-3af2-4035-9c7e-3f0c59996e31	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-04-23 00:00:00	5.03	t	El primer trimestre del año fue de muy lento crecimiento del PBI total, el cual habría alcanzado una expansión ligeramente por debajo de 2.5%, según estimaciones del Banco de Crédito del Perú (BCP).	0	f
53782f1b-e6dc-4f2b-b143-d5eea3998927	110c6254-9596-4e36-a939-8f7a2d557a35	2019-05-10 00:00:00	188.34	f	\N	0	f
fff19873-03b4-421a-959b-e4faf33019a6	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-05-17 00:00:00	44.89	f	\N	0	f
139db1f6-3050-4733-8ba1-60953fecb28c	b65ad095-d3d3-4281-9765-0c724afba7af	2019-05-10 00:00:00	12	f	\N	0	f
ada98955-743c-4198-b90b-ba60e1566487	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-05-24 00:00:00	178.2926	f	\N	0	f
49eda7ba-fc2b-47fd-8d23-150c260b2790	110c6254-9596-4e36-a939-8f7a2d557a35	2019-06-03 00:00:00	164.15	t	Amazon, Facebook, Apple y Google serán investigadas por el gobierno estadounidense. Facebook en particular estará bajo la lupa de la Comisión Federal del Comercio por su enorme poder de mercado que se podría llegar a considerar una forma de monopolio. La compañía ha recibido muchas críticas últimamente, alegando que demasiado poder de parte de la empresa es perjudicial para los usuarios y competidores.	0	f
709606da-82b2-425d-91b1-f932ca08bff7	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-06-14 00:00:00	35.7982	f	\N	0	f
589f1b21-82bf-4b5c-8b54-850427893de8	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-05-03 00:00:00	1962.46	f	\N	0	f
bccdd844-3097-48c4-9a41-83be104934a5	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-06-07 00:00:00	65.69	f	\N	0	f
50bbfcb4-b4d9-4de3-b3f4-8e5faa15e046	f3579400-2263-474d-92b8-b03e2c434915	2019-06-21 00:00:00	29.1	f	\N	0	f
45f3ec78-78ec-4d57-b1d0-7ecb8de4c787	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-06-21 00:00:00	85.75	f	\N	0	f
68d2e717-d3db-432d-ac6f-023bfc503f09	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-06-21 00:00:00	111.13	f	\N	0	f
7e1160e3-d37f-4ceb-9287-1f06f4a0958c	4a4061ee-3175-477f-b598-7104ed81818e	2019-07-12 00:00:00	245.08	f	\N	0	f
5a738cfd-f2c8-4d9b-abf4-ffd628be444d	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-07-05 00:00:00	2.27	f	\N	0	f
e38ee27f-8707-4e83-8ca5-7ff4c56ac5fc	5aef4508-b970-4a28-bd12-1b19015f584f	2019-06-28 00:00:00	364.01	f	\N	0	f
b34bd4ab-d8fd-48cf-9c70-4108629b3f21	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-07-12 00:00:00	39.2754	f	\N	0	f
96cd1f58-7c2a-47ea-b40a-cf476c0aa17b	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-04-12 00:00:00	67.42	f	\N	0	f
91703a0f-6faa-48a3-9ab0-547c54cd7b7b	5aef4508-b970-4a28-bd12-1b19015f584f	2019-01-04 00:00:00	327.08	f	\N	0	t
0ecb804a-1911-4e0d-b868-a293f7ff4fca	110c6254-9596-4e36-a939-8f7a2d557a35	2018-12-21 00:00:00	124.95	f	\N	0	t
9036494d-4994-4abf-b410-9de0ae29d14c	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2018-12-28 00:00:00	92.13	f	\N	0	t
a7967056-bb9a-4486-9327-3a5a8a74511e	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-02-01 00:00:00	38.17	f	\N	0	t
d4feccf8-47cc-4609-a9a0-ec64af94a67e	3854af87-a18e-4509-be17-6145a85578b6	2019-02-01 00:00:00	114.57	f	\N	0	t
1d51f231-895f-46c9-8775-8182e214edf1	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-05-03 00:00:00	2.45	f	\N	0	f
a049f45c-f10f-40e0-bd02-155c03e6abb3	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-05-10 00:00:00	83.95	f	\N	0	f
a95bc9a6-2ba1-4eea-b8b8-7827fae374ca	08976987-dd81-414e-9789-4ab9d173a238	2019-05-10 00:00:00	20.28	f	\N	0	f
da9844c7-601c-4d96-9888-ae899f8a1b5b	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-05-31 00:00:00	174.4073	f	\N	0	f
40323844-3485-47d1-a12b-ce73a72f367b	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-06-14 00:00:00	5.26	f	\N	0	f
9e1d4f2a-aa9e-455f-a79c-aa71af4ce8b4	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-06-07 00:00:00	38.96	f	\N	0	f
6e69e789-b7e1-4b53-aff6-722a38498650	5aef4508-b970-4a28-bd12-1b19015f584f	2019-06-14 00:00:00	347.16	f	\N	0	f
b52eaada-0217-447e-8238-c49c8c1b6e32	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-06-14 00:00:00	83.44	f	\N	0	f
9413ba56-26a2-45aa-81d8-26ceb720e1ed	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-05-31 00:00:00	343.28	f	\N	0	f
2b870713-b81d-45ed-bd3f-7c06ba7ff59a	b65ad095-d3d3-4281-9765-0c724afba7af	2019-06-14 00:00:00	12.51	f	\N	0	f
e0bc0e66-fbb0-47d5-b0d7-cdedf943f612	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-06-21 00:00:00	140.23	f	\N	0	f
3f88704c-5050-4fe5-bbbf-4b3a60816c2b	5aef4508-b970-4a28-bd12-1b19015f584f	2019-06-21 00:00:00	371.84	f	\N	0	f
9f21be2f-4590-418e-8a51-11dfdbc72b88	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-06-14 00:00:00	67.48	f	\N	0	f
4698ab7e-b428-4a56-9b32-4904fb5b55c1	f3579400-2263-474d-92b8-b03e2c434915	2019-06-28 00:00:00	30.37	f	\N	0	f
2ea9b1aa-e8bb-4c2d-9be4-e4779e4d9a08	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-06-07 00:00:00	360.87	f	\N	0	f
ebd5f134-b88b-4d81-89aa-acbbc9d3d707	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-06-28 00:00:00	2.44	f	\N	0	f
ee45183f-0138-4f11-8888-d6a1757ee95c	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-07-05 00:00:00	142.45	f	\N	0	f
57331e55-bf20-4edc-ae98-3159d518d623	c2db4b85-9098-4110-9761-fbd6a846707c	2019-07-05 00:00:00	43.92	f	\N	0	f
2c6c0082-3719-4a9c-b468-5e2926085e97	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-07-12 00:00:00	2.42	f	\N	0	f
6f073768-e97b-4268-9794-c561bb5171a9	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-07-26 00:00:00	5.2	f	\N	0	f
e79f67e2-dc87-43cc-9233-d607d1109efe	5aef4508-b970-4a28-bd12-1b19015f584f	2019-07-12 00:00:00	365.33	f	\N	0	f
3f8bf1b7-9d87-4f89-9c07-b35f2f3ad6a1	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-07-05 00:00:00	0.55	f	\N	0	f
4b2fecf3-6b17-4831-b079-25c7f0ebe1ee	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-08-02 00:00:00	5.1	f	\N	0	f
8143b15d-3fc8-4fbd-991e-211d1b3420be	c2db4b85-9098-4110-9761-fbd6a846707c	2019-07-19 00:00:00	42.77	f	\N	0	f
3438e00b-e2b5-4c9d-af9c-20ffe7f0fa3e	110c6254-9596-4e36-a939-8f7a2d557a35	2019-07-19 00:00:00	198.36	f	\N	0	f
1bbbd437-c715-4687-9b04-492aa181217d	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-07-26 00:00:00	206.9537	f	\N	0	f
185b25df-b933-43c5-82df-6dbf4628f45d	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-07-12 00:00:00	373.25	f	\N	0	f
35a04082-bb9c-473a-a35b-100a4d4a7f0a	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-07-30 00:00:00	50.43	f	\N	0	f
134acda7-6f07-4f95-8265-5ff7f4bf27a1	5aef4508-b970-4a28-bd12-1b19015f584f	2019-10-04 00:00:00	375.7	f	\N	0	f
8a65f12a-e649-4017-9ef1-8425dceb60f2	c2db4b85-9098-4110-9761-fbd6a846707c	2019-08-09 00:00:00	36.35	f	\N	0	f
3ada1f70-ebf6-4549-a09f-358e0748234e	c2db4b85-9098-4110-9761-fbd6a846707c	2019-08-16 00:00:00	34.65	f	\N	0	f
ddde13ce-cd9c-4799-8cb3-2540226240d1	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-08-28 00:00:00	4.9	t	Oro se mantiene cerca de máximo de seis años por temores a desaceleración económica\nEn la jornada previa los inversores compraron activos considerados como refugio, entre los que se encuentra el oro, ante la incertidumbre por la guerra comercial	0	f
a1ad395c-7455-46b4-8b35-08785b6ef7f1	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-08-30 00:00:00	2.32	f	\N	0	f
97b6acef-4bbb-47e4-8cd9-7c9dac851034	110c6254-9596-4e36-a939-8f7a2d557a35	2019-09-06 00:00:00	187.49	f	\N	0	f
d3cca020-d8a5-4d53-bc57-0856927a2c98	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-09-27 00:00:00	50.78	f	\N	0	f
97d40c3e-cae7-41e5-bf8b-647821e93f8b	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-01-04 00:00:00	1.80	f	\N	0	t
2fd7903f-cfc5-49f1-b0d6-bdef7efbc36f	b65ad095-d3d3-4281-9765-0c724afba7af	2019-01-25 00:00:00	10.8	f	\N	0	t
b42d39ea-f052-4cb0-9ebc-1314cf1b50a4	b65ad095-d3d3-4281-9765-0c724afba7af	2019-02-01 00:00:00	10.8	f	\N	0	t
7b4bfe2b-e2c1-492d-ae21-24551d87735b	08976987-dd81-414e-9789-4ab9d173a238	2019-02-01 00:00:00	22.57	f	\N	0	t
67f0efc3-76f7-478e-87a6-19812616d275	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-02-15 00:00:00	32.8493	f	\N	0	t
04551ff2-deff-4ddf-ac22-42bec697c228	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-02-22 00:00:00	52.49	f	\N	0	t
f7b63852-f37b-42d5-ade4-d8a93f33ffe8	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-03-25 00:00:00	107.79	t	Disney cierra compra de activos de Twenty-First Century Fox por US$ 71,000 millones. Los inversionistas sienten cierta incertidumbre acerca de qué sinergias utilizará Disney luego de esta fusión.	0	f
6677d56d-20e8-403c-9348-a5f826576321	b65ad095-d3d3-4281-9765-0c724afba7af	2019-04-12 00:00:00	12	f	\N	0	f
d594a594-8f8c-48dd-8be1-7adc3bdc8323	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-04-19 00:00:00	137.52	f	\N	0	f
a67486ee-90b2-4dc7-919c-1f56eab7f83d	3854af87-a18e-4509-be17-6145a85578b6	2019-04-05 00:00:00	134.06	f	\N	0	f
c026f143-43dc-4936-8c7d-4c9265fd74f5	110c6254-9596-4e36-a939-8f7a2d557a35	2019-07-26 00:00:00	199.75	f	\N	0	f
5fd2938e-89be-43a3-b637-a0a65ceb7bbb	4a4061ee-3175-477f-b598-7104ed81818e	2019-08-30 00:00:00	225.61	f	\N	0	f
9c7bc367-00dd-49b0-b8c5-dafae8f0b4cc	110c6254-9596-4e36-a939-8f7a2d557a35	2019-02-15 00:00:00	162.5	f	\N	0	t
f9534ddb-44ab-4ae5-82b7-83fb59391415	5aef4508-b970-4a28-bd12-1b19015f584f	2019-05-10 00:00:00	354.67	f	\N	0	f
aed5a617-1152-4466-8e14-8a173d87a180	f3579400-2263-474d-92b8-b03e2c434915	2019-08-16 00:00:00	31.18	f	\N	0	f
61059a7a-6d8a-46b2-9ec0-5388d364e0cc	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-03-01 00:00:00	33.4224	f	\N	0	t
0cafda21-0528-4dc2-acf5-3b72c7953960	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-02-01 00:00:00	1626.23	f	\N	0	t
d13a7103-c52a-45d4-9272-eb7b99a10070	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-08-23 00:00:00	2.03	f	\N	0	f
f8d80572-0d5e-46c2-9d40-60249477a686	08976987-dd81-414e-9789-4ab9d173a238	2019-08-08 00:00:00	29.77	t	Dado que los futuros de oro residen en los niveles más altos en seis años, las mineras de oro y los fondos negociados en bolsa relacionados se están beneficiando. VanEck Gold Miners se ve beneficiado en 13% solo este mes, lo que lleva su ganancia anual a alrededor del 36% más de lo esperado.	0	f
190caad6-3e65-4df0-84eb-71c677174e98	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-10-04 00:00:00	58.09	f	\N	0	f
090f9f5f-b9be-4a4b-865e-13d001e99d00	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-09-27 00:00:00	0.465	f	\N	0	f
f255fbaf-f4b8-4bee-b348-308dc2ce98ac	4a4061ee-3175-477f-b598-7104ed81818e	2019-09-06 00:00:00	227.45	f	\N	0	f
6592a2bf-bf15-4a1e-a402-97f8e786da12	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-05-17 00:00:00	10.500	f	\N	0	f
c1e0819e-b2f5-4a82-8578-c094b6224885	110c6254-9596-4e36-a939-8f7a2d557a35	2019-08-23 00:00:00	177.75	f	\N	0	f
380cdfba-2554-44e3-b71b-6f36ecea4cdb	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-09-06 00:00:00	5.05	f	\N	0	f
fb5dc70f-d9e6-4024-a0c2-c901d1acc12b	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-08-02 00:00:00	318.83	f	\N	0	f
4085d868-0e89-4827-8fb9-f317db396b24	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-05-17 00:00:00	138.61	f	\N	0	f
9d81d8a9-5eda-47f4-a9cd-82c08c1fd9db	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-05-24 00:00:00	44.57	f	\N	0	f
e71e802a-740e-4540-bb69-bc50f13175c9	3854af87-a18e-4509-be17-6145a85578b6	2019-07-26 00:00:00	140.27	f	\N	0	f
db358373-0ec5-401a-88ad-c20f2e9b2138	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-08-27 00:00:00	43.73	f	\N	0	f
ca6b17ee-afcb-4626-81bf-7165f90d240e	110c6254-9596-4e36-a939-8f7a2d557a35	2019-08-30 00:00:00	185.67	f	\N	0	f
c001d874-2bc9-48d0-849c-445a001805fa	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-06-07 00:00:00	106.06	f	\N	0	f
2d80a79a-fc94-4a81-b059-f1c25f05bd4d	c2db4b85-9098-4110-9761-fbd6a846707c	2019-06-21 00:00:00	43.67	f	\N	0	f
2152164a-b843-4cf2-9a0e-50f456393d89	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-06-28 00:00:00	2.26	f	\N	0	f
8a273c1e-6833-481e-aa41-cc6cac4f010a	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-06-21 00:00:00	10.440	f	\N	0	f
ab6b1916-a3c0-4fa3-9b70-503e2d4837b6	3854af87-a18e-4509-be17-6145a85578b6	2019-06-07 00:00:00	132.52	f	\N	0	f
307ae520-f369-4b95-aad5-03af10b684a9	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-06-28 00:00:00	367.32	f	\N	0	f
cd4aa27f-447f-48e9-b38a-ced0685dafeb	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-07-19 00:00:00	1.90	f	\N	0	f
be13829d-bada-4413-870e-a9dde2d39277	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-08-23 00:00:00	291.44	f	\N	0	f
e07fd885-2def-4cfd-a30b-4a4eb37a3839	c2db4b85-9098-4110-9761-fbd6a846707c	2019-09-20 00:00:00	36.69	f	\N	0	f
9f12cdba-5fe3-4d5e-abd0-0d80377fd30c	5aef4508-b970-4a28-bd12-1b19015f584f	2019-09-27 00:00:00	382.86	f	\N	0	f
0486ea00-d077-4505-aa53-d21b45e64687	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-09-27 00:00:00	2.13	f	\N	0	f
a9f01e48-4b51-40f4-9656-31ffe44f0fd0	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-09-20 00:00:00	86.68	f	\N	0	f
3fe1b085-f447-4666-9142-a678b645a98d	c2db4b85-9098-4110-9761-fbd6a846707c	2019-02-22 00:00:00	42.96	f	\N	0	t
dae0305f-0bd9-4a3d-b367-b85e5adce2e0	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-02-15 00:00:00	0.72	f	\N	0	t
62e05925-eac7-462e-8825-4a0abfa1d1d9	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-02-22 00:00:00	2.66	f	\N	0	t
6c2988e9-bdd5-4017-9325-a51afd82897b	3854af87-a18e-4509-be17-6145a85578b6	2019-01-25 00:00:00	109.85	f	\N	0	t
6dcc4065-0838-4ee7-bed8-ead4c86ad1e8	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-02-22 00:00:00	64.14	f	\N	0	t
4b777229-a10c-4fc0-980f-1048b11737be	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-03-08 00:00:00	84.8	f	\N	0	t
5c31b838-b17e-4e2f-a62b-17415822a296	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-03-08 00:00:00	52.48	f	\N	0	t
f0cb50ca-87c5-4fdd-a795-4effaab555b3	3854af87-a18e-4509-be17-6145a85578b6	2019-02-15 00:00:00	121.05	f	\N	0	t
621496d5-aae8-46bd-8cc6-0a06028d8b7c	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-10-04 00:00:00	50.92	f	\N	0	f
18a0efa7-31b9-4d63-aad6-71a5dcdf5cd6	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-07-26 00:00:00	49.59	f	\N	0	f
8ffe9196-62fa-4e3d-834a-ca900920c646	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-03-22 00:00:00	98.28	f	\N	0	f
35def2ef-db0c-4679-b8cf-3e23309fc76e	c2db4b85-9098-4110-9761-fbd6a846707c	2019-04-19 00:00:00	39.38	f	\N	0	f
5c84c5c1-8eb3-4897-8dc6-62d85be05701	4a4061ee-3175-477f-b598-7104ed81818e	2019-05-10 00:00:00	239.52	f	\N	0	f
001956f8-8e5f-4f85-b860-bb81bc96c44d	5aef4508-b970-4a28-bd12-1b19015f584f	2019-04-26 00:00:00	380.79	f	\N	0	f
b0e95f80-ef6f-4410-ba02-381b9a856667	08976987-dd81-414e-9789-4ab9d173a238	2019-07-26 00:00:00	27.28	f	\N	0	f
06085e74-56ed-41ff-bc36-2d99d9dca006	f3579400-2263-474d-92b8-b03e2c434915	2019-08-05 00:00:00	29.44	f	\N	0	f
9270bca1-1b33-404e-be7b-ee4fd737631b	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-08-02 00:00:00	2.35	f	\N	0	f
eceef567-1687-4584-955f-8360509850ea	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-07-26 00:00:00	113.02	f	\N	0	f
cb8add4b-f663-449f-99fb-5a9dfee5155a	5aef4508-b970-4a28-bd12-1b19015f584f	2019-08-09 00:00:00	337.55	f	\N	0	f
9791c85b-888b-46b7-9d39-bfe1330dcc67	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-08-16 00:00:00	2.08	f	\N	0	f
3c6f64eb-3cfa-4797-8d19-a3adbd9d793c	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-08-16 00:00:00	135.2	f	\N	0	f
13f9bbb5-5146-405d-912c-7ad2b16e0dd2	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-08-16 00:00:00	46.5	f	\N	0	f
f1637fdb-d863-40cb-8cbd-9cf90c9936df	110c6254-9596-4e36-a939-8f7a2d557a35	2019-08-16 00:00:00	183.7	f	\N	0	f
8bb4f59c-bd9d-430a-8dde-b17a737c354c	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-08-16 00:00:00	2.35	f	\N	0	f
f80ebe8f-5130-4ae1-b0c7-a81cba76ef5a	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-08-02 00:00:00	0.475	f	\N	0	f
476f7fbb-2d32-497c-9abe-1eedea407c26	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-08-16 00:00:00	45.63	f	\N	0	f
8d8c18aa-72b4-4207-8854-6ff4c12029f9	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-07-05 00:00:00	1942.91	f	\N	0	f
7ac1fc07-3167-4f6f-8d62-af721b465d37	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-05-03 00:00:00	51.13	f	\N	0	f
e0b163bd-9147-4d2e-83b0-ee1035945c46	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-04-26 00:00:00	88.31	f	\N	0	f
4d8875e4-44a6-4b9e-93c1-5bbaf1896ea5	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-05-31 00:00:00	62.15	f	\N	0	f
3d5650ef-b5d4-4a10-b7c4-dedcf43493ce	c2db4b85-9098-4110-9761-fbd6a846707c	2019-06-07 00:00:00	42.92	f	\N	0	f
9f40f71a-d2d0-4dd1-a437-726c53dc8dd7	3854af87-a18e-4509-be17-6145a85578b6	2019-05-03 00:00:00	140.14	t	Marriot  desafia a empresas como Airbnb ingresando al negocio de alquiler de departamentos turísticos en Estados Unidos. Marriot persigue la ambiciosa meta de poder convertirse en la primera cadena en crear una plataforma online de alquiler de pisos para turistas en el creciente mercado estadounidense. Por otro lado, el plan de expansión de Marriot continua, pues hace poco lanzó un proyecto para incorporar a su portafolio 1700  hoteles hasta 2021.	0	f
2a8a7cf0-732e-4f4e-8f1a-a53a028a870a	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-06-07 00:00:00	83.41	f	\N	0	f
68e74c8f-3ac8-4add-b088-07cf217920dc	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-06-07 00:00:00	189.4303	f	\N	0	f
0fa86a07-2765-4a04-8970-7b365ec4ef6a	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-06-21 00:00:00	2.45	f	\N	0	f
4cd27b2e-f899-41ae-8063-3c59d6803fa4	4a4061ee-3175-477f-b598-7104ed81818e	2019-07-26 00:00:00	228.04	f	\N	0	f
516a77a2-f280-4bc5-b80c-8a1a74276a8d	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-07-12 00:00:00	114.6	f	\N	0	f
176bae30-19d6-4f56-979b-91ea29d003e4	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-08-09 00:00:00	0.48	f	\N	0	f
32e20ef0-f049-4d67-987a-8b36cce9aef7	c2db4b85-9098-4110-9761-fbd6a846707c	2019-08-23 00:00:00	34.34	f	\N	0	f
95f3c62c-6fdc-4dea-80f2-9585bd79382d	c2db4b85-9098-4110-9761-fbd6a846707c	2019-03-22 00:00:00	41.85	f	\N	0	f
3d21d664-23a4-4870-aead-dbae4f9d2085	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-03-22 00:00:00	136.91	f	\N	0	f
85da6a77-ea4d-468f-a602-990c7c2c43eb	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-04-12 00:00:00	86.24	f	\N	0	f
5bd9d7e4-673e-498c-b755-e306f50d2c28	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-03-29 00:00:00	356.56	f	\N	0	f
616e5158-f152-4a42-981d-4efb71d64bcd	c2db4b85-9098-4110-9761-fbd6a846707c	2019-03-01 00:00:00	43.36	f	\N	0	t
541882db-0ee8-427e-b40d-e11b7d1ab47b	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-02-21 00:00:00	0.66	t	Se anuncia que las acciones de Volcán serán excluidas de los índices FTSE. Por otro lado, las inversiones mineras en un 13.4%.	0	t
4c88e97c-2e04-49de-a6b1-86f0bb6acfc0	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-08-30 00:00:00	39.7437	f	\N	0	f
476c2fa3-a4d1-43cf-a7be-636278f2c01e	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-09-06 00:00:00	2.1	f	\N	0	f
164f5259-8f6c-412d-8146-d24c89e04616	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-04-19 00:00:00	2.63	f	\N	0	f
86cf6722-325a-4242-a39d-3a6530a99be8	b65ad095-d3d3-4281-9765-0c724afba7af	2019-04-19 00:00:00	11.9	f	\N	0	f
c43cd8d2-d579-439a-944a-bb529f546cb9	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-04-26 00:00:00	2.20	f	\N	0	f
fe3dec63-7962-448b-a7bd-b124c180776f	110c6254-9596-4e36-a939-8f7a2d557a35	2019-04-26 00:00:00	191.49	f	\N	0	f
6a5fda36-e64a-42e9-9fe7-021083080892	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-03-15 00:00:00	1712.36	f	\N	0	f
0d6778db-4bec-4b63-b4cc-1f5df170c904	08976987-dd81-414e-9789-4ab9d173a238	2019-04-26 00:00:00	21.3	f	\N	0	f
9512116b-7c93-44e7-9bd2-ee0bd508f718	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-04-26 00:00:00	69.51	f	\N	0	f
2b410ce5-c627-4834-89d7-92aae73abbe5	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-05-08 00:00:00	2.60	t	La Asociación UNACEM inauguró el proyecto de  “Aula Interactiva para la capacitación en salud y seguridad en el trabajo", la nueva aula aportará en la disminución de riesgos laborales, al capacitar al personal en eventuales accidentes de forma real. UNACEM contribuye a la meta de los Objetivos de Desarrollo Sostenible (ODS)	0	f
f234d16e-b5d5-4f39-a66a-4c292b31403c	c2db4b85-9098-4110-9761-fbd6a846707c	2019-05-17 00:00:00	41.47	f	\N	0	f
13dbff97-669d-4fd9-9a29-bb49ce765d73	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-06-07 00:00:00	138.04	f	\N	0	f
79bf06fc-c923-4bb5-b734-70827f080912	08976987-dd81-414e-9789-4ab9d173a238	2019-06-07 00:00:00	22.89	f	\N	0	f
619681d4-b2d2-44d7-8655-77b22037f07f	c2db4b85-9098-4110-9761-fbd6a846707c	2019-06-14 00:00:00	42.76	f	\N	0	f
c476d87a-8a3a-4e7f-abd2-efe59ce8e002	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-06-07 00:00:00	1804.03	f	\N	0	f
205ff5a3-afce-49df-a26a-30f84f43f293	5aef4508-b970-4a28-bd12-1b19015f584f	2019-08-16 00:00:00	330.45	f	\N	0	f
eddbb41e-9a21-43d0-ba77-9fd058afb2a3	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-08-05 00:00:00	105.82	t	Una tienda de Walmart es víctima de dos tiroteos en EE.UU. dejando un número de 22 muertos. Pese a este suceso, la empresa se niega a dejar de vender armas, pues alega que gran parte de su público objetivo son los tiradores y cazadores deportivos. El mercado se siente preocupado acerca de cómo esto afectará el futuro de la empresa.	0	f
cc1ff3ca-865e-4c7c-9245-78f5c301e5ad	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-08-15 00:00:00	61.32	t	Los analistas de Citigroup rebaja el precio objetivo de varios bancos dentro de la industria española tales como CaixaBnak, Sabadell y Bankia. Los bancos registran mínimos en lo que va del año.	0	f
29a06bce-27ac-4ebb-8ad1-ec99e1cd1b94	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-08-16 00:00:00	80.28	f	\N	0	f
f5461107-c12c-4cef-bc08-b99e761742d4	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-08-16 00:00:00	131.36	f	\N	0	f
7f4dab64-e6a9-4b9b-91f3-726ec669b63c	f3579400-2263-474d-92b8-b03e2c434915	2019-09-27 00:00:00	28.72	f	\N	0	f
0c20da38-6b88-45e8-804b-d933d109a511	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-09-19 00:00:00	9.300	t	Alicorp vende 505,844 acciones representativas de Credicorp;  para reducir su deuda financiera. Esto repercute en el valor total del capital social de la empresa. Ademas de las deudas por las compras de las empresas compradas en este año, y los margenes negativos de ciertas  	0	f
6e887f23-b32a-460b-a706-8403819a34bd	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-09-27 00:00:00	9.300	f	\N	0	f
fc768361-8294-4ea5-9de7-4d06bc960206	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-09-13 00:00:00	294.15	f	\N	0	f
0ce4e09a-1220-43eb-9a71-9ba1d318a1c4	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-10-04 00:00:00	68.18	f	\N	0	f
8eb078ff-0394-411d-96f4-9d4c4612be46	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-03-29 00:00:00	43.2	f	\N	0	f
2989fdf4-f625-4a69-8681-bd3b49ae9db1	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-07-26 00:00:00	130.73	f	\N	0	f
5c8345f8-8a38-4846-941d-f08a8b0a3982	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-04-05 00:00:00	55.6	f	\N	0	f
0ca5ee52-5b59-4791-b014-85493ca4ab1d	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-03-29 00:00:00	5.236	f	\N	0	f
b5c3888c-65c5-44f4-a4d2-2e6bb15c9b79	4a4061ee-3175-477f-b598-7104ed81818e	2019-05-03 00:00:00	255.03	f	\N	0	f
776280b2-9452-4074-a98a-ca5289acde89	c2db4b85-9098-4110-9761-fbd6a846707c	2019-08-02 00:00:00	38.00	t	La Superintendencia de Industria y Comercio sancionó al laboratorio Pfizer por incumplir las normas de la Superintendencia de Salud al superar los topes máximos de precios establecidos para algunos medicamentos en valores que en algunos casos superaron seis veces lo reglamentario.	0	f
d3cec634-99a8-460a-b095-7dff456a8190	4a4061ee-3175-477f-b598-7104ed81818e	2019-08-23 00:00:00	211.4	f	\N	0	f
906f1ffd-e13a-4965-aa8e-facc01c4f1a1	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-08-09 00:00:00	45.98	f	\N	0	f
bf1e54c7-be67-410c-948d-acf36283f44a	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2018-12-28 00:00:00	0.71	f	\N	0	t
a551b824-f5bf-40f7-863c-b9dd1bfa8e93	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-03-01 00:00:00	1.93	f	\N	0	t
1e0969c6-1d0e-4645-bb8a-3207ca66a3a9	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-08-09 00:00:00	132.04	f	\N	0	f
44136cae-9b5e-46b8-9de3-4ed298305459	5aef4508-b970-4a28-bd12-1b19015f584f	2019-03-22 00:00:00	362.17	f	\N	0	f
83b7a20e-2e85-4d7c-8a3e-4a0020b21a03	4a4061ee-3175-477f-b598-7104ed81818e	2019-04-05 00:00:00	274.96	f	\N	0	f
e6cb0a3a-10f8-4bb6-99db-a0dbac49977c	f3579400-2263-474d-92b8-b03e2c434915	2019-04-26 00:00:00	27.88	f	\N	0	f
3735e9be-46d8-4730-9a5f-0cf613b14cbe	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-05-03 00:00:00	102.08	f	\N	0	f
7fedcbf9-7481-4b09-ba91-34ff55cd6556	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-08-09 00:00:00	9.700	f	\N	0	f
5eefe2f9-424c-412a-9de5-9ad8025c5c02	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-08-23 00:00:00	1.70	f	\N	0	f
cf1b43fe-a175-4630-bd4b-ca5c3928b3d0	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-08-16 00:00:00	112.99	f	\N	0	f
844684d3-3164-4dbf-84e2-589f9a745053	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-09-03 00:00:00	205.7	t	Debido a la guerra comercial entre Estados Unidos y China, y el anuncio de nuevos aranceles a productos de importación chinos, existe un incertidumble acerca de las medidas a tomar por Apple. No se sabe si afrontará los nuevos aranceles de 15% que se impondrán en diciembre, o si eleverá el precio de sus productos.	0	f
05afa1ea-24ba-42e2-97b6-02e927558d71	c2db4b85-9098-4110-9761-fbd6a846707c	2019-09-27 00:00:00	36.22	f	\N	0	f
56d46aa8-e276-4dd8-8b1d-7f32a4fbc764	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-05-24 00:00:00	5.064	f	\N	0	f
4bef0061-3c8b-433e-88c0-aa0a43a9104b	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-05-17 00:00:00	84.57	f	\N	0	f
03541c6e-11e6-459b-8936-9d1f7cef76c1	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-05-31 00:00:00	132.04	f	\N	0	f
f1acfb56-0368-4f19-8dff-6191e355fd13	110c6254-9596-4e36-a939-8f7a2d557a35	2019-06-21 00:00:00	191.14	f	\N	0	f
a21129ec-51b8-4d72-81e8-80a15f44a175	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-06-21 00:00:00	198.0276	f	\N	0	f
ab228855-c682-455b-8073-3d8a25aa3dfe	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-06-28 00:00:00	38.3289	f	\N	0	f
52ecf24e-3338-4511-a717-a84558469fb7	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-06-28 00:00:00	44.13	f	\N	0	f
ead2ea13-79b3-46c0-9325-0b0379dfc525	110c6254-9596-4e36-a939-8f7a2d557a35	2019-07-12 00:00:00	204.87	f	\N	0	f
89379548-5fa8-479f-9d11-010ebc55c90e	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-07-05 00:00:00	111.98	f	\N	0	f
dd5c0ae5-0c50-4190-bc54-e1787214f4b2	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-07-12 00:00:00	1.95	f	\N	0	f
4d15757c-fde0-4bbf-8083-e223ec1d25bb	f3579400-2263-474d-92b8-b03e2c434915	2019-07-19 00:00:00	32.51	f	\N	0	f
a629c4f7-0d3e-4789-814d-25e5d2f41cb9	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-06-14 00:00:00	1869.67	f	\N	0	f
7a8504c9-bfe4-429c-91f8-ce9c107b0595	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-07-26 00:00:00	2.40	f	\N	0	f
b57df432-fbbb-441b-bc14-28bb6c327c0a	3854af87-a18e-4509-be17-6145a85578b6	2019-06-21 00:00:00	137.07	f	\N	0	f
c0c8881c-1951-4368-a0d2-b8655812092c	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-07-29 00:00:00	146.39	t	Disney superó su meta de recaudación de ingresos del 2019 5 meses antes de acabar el año. Se logró obtener una suma de 7.670 millones de dólares, y eso se debe a películas tales como Avengers, Aladdin, El Rey León y Toy Story. Se espera que con el estreno de Frozen 2 y Star Wars se mantenga esta racha hacia la alza.	0	f
293924fe-81ed-4bd9-9c84-4c42ae2f32a0	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-07-26 00:00:00	87.54	f	\N	0	f
602b29ea-052e-4417-8742-300b6e9d3854	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-10-03 00:00:00	128.2905	f	\N	0	f
fbe6b1a9-13b7-4fb5-8104-4fb385f80e70	b65ad095-d3d3-4281-9765-0c724afba7af	2019-04-26 00:00:00	12	t	Las ventas de la compañía ascendieron a PEN 855.0 MM, superiores en 7.3% con respecto al 1T18. Esta mejora estuvo relacionada, principalmente, con el aumento del precio promedio de energía en 7.2% y a los mayores ingresos por distribución de energía. 	0	f
7e44f40a-2a74-48fa-9f72-d50db337d784	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-10-04 00:00:00	9.010	f	\N	0	f
76dcb6b3-4bf9-4bf0-a916-f695e16bf08a	3854af87-a18e-4509-be17-6145a85578b6	2019-04-26 00:00:00	136.45	f	\N	0	f
e6841b87-6443-48d4-be88-96409e018961	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-05-24 00:00:00	31.6733	f	\N	0	f
3591205b-369d-4d9a-aa3f-650078b778bf	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-05-24 00:00:00	138.85	f	\N	0	f
5752ed97-c637-4a16-bcb6-899b82f2d5e5	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-08-02 00:00:00	1.86	f	\N	0	f
da1ead75-1d10-4a23-9848-de98e17152c6	b65ad095-d3d3-4281-9765-0c724afba7af	2019-08-09 00:00:00	14.32	f	\N	0	f
540010c0-1c44-457e-bb2d-2cadc688fd8f	f3579400-2263-474d-92b8-b03e2c434915	2019-08-23 00:00:00	29.54	f	\N	0	f
23ab879f-17bf-49df-8ce9-ad86990a599f	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-03-08 00:00:00	40.62	f	\N	0	t
9a505a2f-78b6-44a4-a1cc-168b845d30bd	08976987-dd81-414e-9789-4ab9d173a238	2019-03-01 00:00:00	21.7	f	\N	0	t
ada40953-a438-4df9-b60b-761dbe26615d	4a4061ee-3175-477f-b598-7104ed81818e	2019-03-22 00:00:00	264.53	f	\N	0	t
bf4fe444-5797-45c2-a747-c1c5c41c7853	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-08-23 00:00:00	39.1558	f	\N	0	f
bd3132a9-072e-471e-b32e-0203a7d8da8a	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-09-13 00:00:00	52.54	f	\N	0	f
03e736fe-745c-462b-858b-616151bf98af	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-09-13 00:00:00	87.32	f	\N	0	f
75b95f28-bcea-4eab-ac82-930b790ef479	5aef4508-b970-4a28-bd12-1b19015f584f	2019-05-24 00:00:00	354.9	f	\N	0	f
abf1a7c6-6e01-4702-981c-1e689dcc2d90	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-09-20 00:00:00	69.35	f	\N	0	f
70640f7d-a6db-45fb-a46a-5678626bee44	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-03-15 00:00:00	98.42	f	\N	0	f
ec38d3a0-16a7-4af9-b7e4-bc3c6003cb32	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-05-24 00:00:00	82.16	f	\N	0	f
132e2a4f-bd1d-4b8a-a656-7697931c88ec	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-05-31 00:00:00	2.00	f	\N	0	f
6e46e616-96ef-4675-9821-6ba06202bcbf	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-06-14 00:00:00	2.22	f	\N	0	f
7edfe21c-d16d-45b6-bc75-d8809bfe36bc	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-06-14 00:00:00	46.19	f	\N	0	f
aef2107c-acba-4653-a7dc-7cedcef3e184	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-06-28 00:00:00	2.00	t	Cambio negativo en la BVL, a comparación de su contraparte internacional en la Bolsa de valores NY. Se da inicio a la colaboración eficaz para el caso de corrupción de la empresa Odebrech. Ademas de una clara mancha de imagen.	0	f
fe98a98a-b86b-4d2d-bef8-15a2f8e015d4	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-07-24 00:00:00	2.11	f	\N	0	f
ac9d9f7d-51e0-41db-baf6-7fab64bc790f	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-07-12 00:00:00	46.27	f	\N	0	f
345d24b4-81bb-443e-8421-e2cf28f723ca	08976987-dd81-414e-9789-4ab9d173a238	2019-09-24 00:00:00	29.49	f	\N	0	f
dfa5015f-3dd9-477a-b821-4feb0c30b64f	b65ad095-d3d3-4281-9765-0c724afba7af	2019-09-27 00:00:00	16.3	f	\N	0	f
58647029-c52e-43b4-9e1a-b4650ce38acd	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-09-27 00:00:00	218.82	f	\N	0	f
28292342-72af-48bd-9433-9874a6c4385d	4a4061ee-3175-477f-b598-7104ed81818e	2019-08-09 00:00:00	235.01	f	\N	0	f
d56e95d9-2219-471d-9589-a6d658e3ccfb	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-08-09 00:00:00	2.15	f	\N	0	f
64820b3c-6e8b-4627-aea9-7d0e978dd57a	4a4061ee-3175-477f-b598-7104ed81818e	2019-09-10 00:00:00	235.54	f	\N	0	f
e1eb78b6-cb8a-4e99-bb6b-de7066cf3b0c	08976987-dd81-414e-9789-4ab9d173a238	2019-08-23 00:00:00	29.64	f	\N	0	f
0f9ddc86-5de7-44de-99f9-aab0c5cf5d5e	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-09-20 00:00:00	2.20	t	Entra al indice de sostinibilidad de Dow Jones, en la cual 58 empresas listadas en la bolsa de la alianza del pacífico son participes. La cual reconoce su esfuerzo por el desarrollo sostenible, tanto económicamente como ambiental y social.	0	f
f0f704b5-1a6f-4dd5-811f-4379722080f8	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-03-21 00:00:00	88.01	t	Nike cuadriplica su beneficio en 9 meses hasta 3.040 millones de dólares, esto gracias a una menor presión fiscal y a su estrategia de venta directa al consumidor. Las ganancias por acción fueron de 1,87 dólares, frente a los 48 centavos que logró en los mismos nueve meses del ejercicio anterior, en los que sus beneficos ascendieron a 796 millones de dólares.	0	f
93308a2a-e2e8-4e51-b556-7ee88b47adf4	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-03-22 00:00:00	1764.77	f	\N	0	f
b46b1d7b-0110-49ff-83d4-5d1bd59e5dfa	b65ad095-d3d3-4281-9765-0c724afba7af	2019-05-17 00:00:00	12.12	t	Las ventas de la compañía ascendieron a PEN 855.0 MM, superiores en 7.3% con respecto al 1T18. Esta mejora estuvo relacionada, principalmente, con el aumento del precio promedio de energía en 7.2% y a los mayores ingresos por distribución de energía. 	0	f
45760abe-3cc5-4f49-add7-a8ec8f706e53	3854af87-a18e-4509-be17-6145a85578b6	2019-06-14 00:00:00	133.68	f	\N	0	f
d40c8e24-99fd-4228-93f3-318b84e0906d	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-07-19 00:00:00	2.40	f	\N	0	f
93e4c581-383b-4b8a-a46a-2936d58a9256	110c6254-9596-4e36-a939-8f7a2d557a35	2019-09-27 00:00:00	177.1	f	\N	0	f
ccc6d5e2-0156-4d87-88a1-939eee461ea7	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-09-06 00:00:00	290.17	f	\N	0	f
b28d7a15-2722-4ce9-adb0-e3039d801110	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-09-27 00:00:00	128.6	f	\N	0	f
955fc481-3a6c-42c8-9af1-3f5781e4cfce	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-08-30 00:00:00	1776.29	f	\N	0	f
05accbaf-13c4-4824-bf9e-b9bb914b619e	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-10-04 00:00:00	2.02	f	\N	0	f
da92f655-45d8-4070-b2d3-c71ba5cd6629	c2db4b85-9098-4110-9761-fbd6a846707c	2019-01-11 00:00:00	42.88	f	\N	0	t
9ef4f62d-ee28-44c8-b7aa-8d08506d83bd	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-01-11 00:00:00	2.05	t	CONCAR S.A. es uyna empresa subcidiaria de Graña Y Montero. Es encargada de un Proyecto Especial de Infraestructura de Transportes Nacional (Provías Nacional), entidad que forma parte del Ministerio de Transportes y Comunicaciones (MTC). El proyecto demandará una inversión de S/ 32.4 millones 	0	t
3ebb9491-1a89-4350-b180-e4ab36416a7d	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2018-12-03 00:00:00	1772.36	t	Apple y Microsoft retroceden como líderes en el sector tecnológico. Así, Amazon se convirtió en la compañía más valiosa de Wall Street con una capitalización de mercado de 865 000 millones de dólares. Al mismo tiempo, las expectativas de los inversores mejoraron después de que Estados Unidos y China acordaran una tregua temporal en su disputa comercial en curso.	0	t
7dd9cc62-e6c7-41ec-ab09-c9eb6737f3ab	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-01-11 00:00:00	94.84	f	\N	0	t
3c9114b5-8539-4730-b705-7b123735d376	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-01-18 00:00:00	49.19	f	\N	0	t
454176c1-19b9-45db-9beb-76ad84148b44	4a4061ee-3175-477f-b598-7104ed81818e	2019-01-25 00:00:00	297.04	f	\N	0	t
a38be04a-fb22-414c-bc78-f8329186d55a	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-01-18 00:00:00	2.00	f	\N	0	t
ffc2c68f-58aa-46ea-9403-4902d477c9d5	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-01-25 00:00:00	111.09	f	\N	0	t
2ec0b758-4008-45d1-9c60-99c98f750e1d	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-01-11 00:00:00	56.69	f	\N	0	t
3b614a8e-e72f-4545-b3f2-fbe3f02ba7e6	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-02-01 00:00:00	2.451	f	\N	0	t
1f82af7c-30d4-4dcb-8ca1-3acfed1f77a6	5aef4508-b970-4a28-bd12-1b19015f584f	2019-02-01 00:00:00	387.43	f	\N	0	t
d6e7124f-9d89-403c-9bb4-bc032a60d1a9	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-01-18 00:00:00	63.12	f	\N	0	t
b6cf4f06-2bab-4b2d-b7fe-1d9550895770	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-07-16 00:00:00	5.4	f	\N	0	f
b3c7ec79-085c-49ca-bcd2-7046704ca08f	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-08-23 00:00:00	44.96	f	\N	0	f
54306ec6-417e-4faf-87a7-6041c5ea63d4	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-08-30 00:00:00	114.26	f	\N	0	f
22524de2-8cab-40e3-a1f7-e99c99cc47f7	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-09-06 00:00:00	38.5182	f	\N	0	f
ad283366-a0f4-452a-b044-71ccd0b4fced	b65ad095-d3d3-4281-9765-0c724afba7af	2019-08-30 00:00:00	15	f	\N	0	f
d341ad49-c2db-4d81-bc26-2cc9c8923195	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-09-13 00:00:00	218.75	f	\N	0	f
36395a53-5fed-4fb4-a953-f11aba83f6fa	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-09-20 00:00:00	132.27	f	\N	0	f
73c85dd6-5122-48f9-8f32-d549d4d18e73	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-09-27 00:00:00	2.13	f	\N	0	f
ea5da380-17c9-4f12-913a-9df93dd93adf	5aef4508-b970-4a28-bd12-1b19015f584f	2019-09-20 00:00:00	379.39	f	\N	0	f
c135438f-d823-43bb-baa8-2cde66068716	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-08-23 00:00:00	1749.62	f	\N	0	f
fc6bc004-1436-49d8-b7c4-4dac294d992c	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-09-20 00:00:00	0.448	f	\N	0	f
30a678eb-b9f6-4ac0-8a78-7b8fb522b09c	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-09-27 00:00:00	92.31	f	\N	0	f
7d6c3253-1f6c-4205-a43b-5d6001e2e769	c2db4b85-9098-4110-9761-fbd6a846707c	2019-10-04 00:00:00	35.93	f	\N	0	f
0cd2c4db-873f-4762-b177-71ae4be23e36	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-09-20 00:00:00	131.65	f	\N	0	f
322e9d9c-8cea-4d41-9289-9965a57c614f	110c6254-9596-4e36-a939-8f7a2d557a35	2019-10-04 00:00:00	180.45	f	\N	0	f
8dfe62d8-3eda-4094-91f9-715d3b8223da	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-03-22 00:00:00	2.12	f	\N	0	f
84cc2609-6855-4068-b9bf-2f79d4788ab5	3854af87-a18e-4509-be17-6145a85578b6	2018-12-07 00:00:00	111.25	f	\N	0	t
34f9f09c-f6b0-43e5-98b4-2d379944e28a	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-01-04 00:00:00	93.44	f	\N	0	t
46db3a88-e095-4711-bd06-a9f0985bc508	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-01-11 00:00:00	5.047	f	\N	0	t
bd69365d-f234-41b2-9388-e8004790da5d	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-01-18 00:00:00	31.3965	f	\N	0	t
967f9fc8-709c-42a8-84fd-c3626585c83d	07618a28-45f0-4f9a-bf47-7e55e517ce21	2018-12-18 00:00:00	353.19	t	Netflix duplica sus beneficios en 2018 y llega a 1.211 millones de dólares. Además, la compañía cierra el año con 138 millones de suscriptores en todo el mundo, experimentando un crecimiento de más de 20 millones de clientes en el mercado internacional.	0	t
16fedea3-f8e4-44e9-9668-02d561ffef93	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-02-15 00:00:00	51.66	f	\N	0	t
26b7c79c-d145-483b-b6c1-0091b6933b1d	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-02-22 00:00:00	11.014	f	\N	0	t
eb0c941c-641e-4d4f-ac5b-de40915b047d	f3579400-2263-474d-92b8-b03e2c434915	2019-02-15 00:00:00	23.68	f	\N	0	t
d50fe9c9-c629-4b61-867d-4395a6fbff44	f3579400-2263-474d-92b8-b03e2c434915	2019-03-08 00:00:00	22.01	f	\N	0	t
a9aa5240-2c17-4091-bffc-e4d2acda697c	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-04-26 00:00:00	49.52	f	\N	0	f
4dbf1ece-5697-4298-95ca-ddeaf5b34f4e	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-04-19 00:00:00	58.49	f	\N	0	f
ef2d66d9-dc53-43fc-b042-1209eb899bd1	08976987-dd81-414e-9789-4ab9d173a238	2019-04-12 00:00:00	22.21	f	\N	0	f
8da57b94-f048-496e-aa66-56bd0629141e	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-05-03 00:00:00	5.193	f	\N	0	f
97984c48-023f-4642-a4a2-e52f60f54cbb	b65ad095-d3d3-4281-9765-0c724afba7af	2019-07-19 00:00:00	14.15	f	\N	0	f
8a78022e-9536-4e8a-b810-3f1dae455aaa	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-07-12 00:00:00	0.53	f	\N	0	f
baff0755-1a73-4d5f-890a-62b369abb124	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-05-03 00:00:00	2.28	f	\N	0	f
b2b3caf3-5265-45cb-a562-10a29a93a86c	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-07-26 00:00:00	37.1432	f	\N	0	f
4bac9fb7-d45b-484c-8fb8-5ae236376b72	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-08-16 00:00:00	5.1	f	\N	0	f
df339688-b120-40a4-b493-da9d11844386	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-08-23 00:00:00	61.95	f	\N	0	f
cf2b898b-aeed-4709-8c21-e7f3e1bb7ec6	4a4061ee-3175-477f-b598-7104ed81818e	2019-09-27 00:00:00	242.13	f	\N	0	f
98a58593-5015-4568-ba21-28ebb6bbdf97	c2db4b85-9098-4110-9761-fbd6a846707c	2019-09-13 00:00:00	36.91	f	\N	0	f
5a52e052-9d6b-4119-ac06-9de339701858	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-09-13 00:00:00	1.69	f	\N	0	f
b321a4e7-a6dd-41fd-b0cb-927676565b9e	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-09-27 00:00:00	62.11	f	\N	0	f
1cf28ad0-aa94-42cf-a387-0719f79f33ba	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-05-10 00:00:00	5.219	f	\N	0	f
435af092-a2a9-42be-b17a-076f617d26f0	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-05-17 00:00:00	45.42	f	\N	0	f
b57152b5-f745-433f-aad7-66c4e5677ba1	b65ad095-d3d3-4281-9765-0c724afba7af	2019-05-03 00:00:00	11.89	f	\N	0	f
8fb1b948-c694-4b0f-a34b-dd89c0e111e4	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-06-07 00:00:00	138.55	f	\N	0	f
484e34ec-e168-42aa-8be6-633d68ffcf37	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-03-15 00:00:00	0.63	f	\N	0	f
2fc4f805-5ff1-426a-a5a4-e73de3c110d7	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-06-14 00:00:00	192.0105	f	\N	0	f
5e86c449-3ef5-4ea1-b881-07babed964d2	08976987-dd81-414e-9789-4ab9d173a238	2019-06-21 00:00:00	25.21	f	\N	0	f
208faccd-19a4-458e-80f3-58db2569c706	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-06-14 00:00:00	339.73	f	\N	0	f
1ca3fcad-3456-4af5-a6f2-616a8c32a8ba	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-07-05 00:00:00	10.280	f	\N	0	f
57032f62-5ac2-4200-b8be-40ae2886604a	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-01-25 00:00:00	47.04	t	Los resultados presentados por Intel no convencieron a los inversores en Wall Street, y las acciones de la compañía se dejaban un 7,21% hasta los 46,15 dólares por título en las operaciones electrónicas posteriores al cierre	0	t
766ffa32-b7c9-4714-a7aa-8529bdba8d3a	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-01-25 00:00:00	0.75	f	\N	0	t
0506e779-d506-49c1-9a06-fe314c5891de	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-02-01 00:00:00	111.3	f	\N	0	t
2f30db1f-7ae5-4e12-baab-87dd6f9561aa	08976987-dd81-414e-9789-4ab9d173a238	2019-01-25 00:00:00	21.18	f	\N	0	t
efda9d26-0f27-4542-b07b-8655411c97b4	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-02-01 00:00:00	2.00	f	\N	0	t
b9fa58a0-40a3-425f-9c69-eebc3a359aa4	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-02-01 00:00:00	0.75	f	\N	0	t
466f581b-a0bf-42b0-87f8-7a157a9eb92b	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-02-08 00:00:00	2.461	f	\N	0	t
a59e1ce4-6bb2-4bee-b0bc-73634f1c49e8	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-02-15 00:00:00	2.527	t	FerreyCorp, gracias a su desempaño y logros relacionado a áreas como sostenibilidad ambiental, social y buen gobierno corporativo. El banco peruano BBVV, le concedio su primer préstamo de USD70M a tres año. Convirtiendo este préstamo como el primero de su tipo en Sudamérica. 	0	t
13951fbf-d4d4-4b76-8329-7897b4e567ad	110c6254-9596-4e36-a939-8f7a2d557a35	2019-04-12 00:00:00	179.1	f	\N	0	f
1cd28125-5024-4fd1-9995-1ec0c1a8f26a	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-02-15 00:00:00	169.1237	f	\N	0	t
1460bed7-731b-48f1-8b88-63f3b998e5f7	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-04-19 00:00:00	32.7847	f	\N	0	f
800037bc-e35e-43cd-9bb1-ce8e2b35ad55	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-09-20 00:00:00	5.09	f	\N	0	f
f2c4f3cf-88f1-42f6-b002-8ae53f3c419b	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-09-06 00:00:00	50.92	t	Las primeras unidades FPGA de Intel a 10nm (un tipo de chiplet altamente programable y escalable), los Agilex, han comenzado enviarse a clientes tan destacados como Microsoft, Silicon o Mantaro Networks. Estos FPGA se pueden utilizar para redes, análisis de datos, 5G y computación avanzada.	0	f
b818256d-7da3-4894-8981-ca08777f621e	4a4061ee-3175-477f-b598-7104ed81818e	2019-10-04 00:00:00	231.43	f	\N	0	f
896d4d32-9ec8-42c1-8e54-bb49883133ff	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-01-25 00:00:00	1670.57	f	\N	0	t
e73637ae-0359-4a46-9549-335ffb3fc72f	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-05-10 00:00:00	48.31	f	\N	0	f
e28f48f8-1646-423f-9270-447767892441	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-05-10 00:00:00	2.10	f	\N	0	f
4c93939f-6487-4f7b-ab80-e71f9246e551	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-05-09 00:00:00	29.6987	f	\N	0	f
b57c8fb0-6d3c-47b1-bee3-0c04e205ea27	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-05-10 00:00:00	139.05	f	\N	0	f
b3f1e4d5-54e3-44cb-bb53-36d13e777e7c	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-06-07 00:00:00	2.43	f	\N	0	f
b8af6c2a-ce33-4b72-9821-999cd192465f	110c6254-9596-4e36-a939-8f7a2d557a35	2019-06-28 00:00:00	193	f	\N	0	f
6cf38ae7-2803-4285-88da-091f38952df3	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-05-17 00:00:00	1869	f	\N	0	f
9fec8fc9-e519-400c-9986-cdbcfe4681d3	c2db4b85-9098-4110-9761-fbd6a846707c	2019-06-28 00:00:00	43.32	f	\N	0	f
2b102c74-b243-45ba-816f-86f65de05ec3	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-06-21 00:00:00	0.52	f	\N	0	f
9412bc92-e431-4557-85e7-a3eb12647bcc	08976987-dd81-414e-9789-4ab9d173a238	2019-06-28 00:00:00	25.56	f	\N	0	f
871655e8-c292-4bd0-bf7d-33e4ebb36612	4a4061ee-3175-477f-b598-7104ed81818e	2019-07-19 00:00:00	258.18	f	\N	0	f
ce98b783-8c04-4884-a048-6ea81e78ec77	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-02-15 00:00:00	2.68	f	\N	0	t
7952dc14-30ed-42d1-b22c-c87126194822	110c6254-9596-4e36-a939-8f7a2d557a35	2019-02-22 00:00:00	161.89	f	\N	0	t
a215d9be-958b-4a73-894a-074b2ac165b6	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-03-01 00:00:00	64.47	f	\N	0	t
fb52bbbd-e7cd-4833-a054-720a87f39e92	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-03-08 00:00:00	97.59	f	\N	0	f
27fc3e01-66ac-4126-838e-b91e396679fe	b65ad095-d3d3-4281-9765-0c724afba7af	2019-03-15 00:00:00	12.09	f	\N	0	f
42887a5a-300e-45f1-a7ba-16908d84359f	08976987-dd81-414e-9789-4ab9d173a238	2019-03-15 00:00:00	22.3	f	\N	0	f
f174bd93-0274-4d47-8a24-10f8541d7a2f	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-03-22 00:00:00	10.907	f	\N	0	f
4606e903-2c6f-41f7-90c1-5a9187c8aaa8	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-03-29 00:00:00	10.613	f	\N	0	f
bcb410df-f9a4-41fa-a728-5a0b44509f68	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-03-21 00:00:00	196.303	t	Apple apuesta por el lanzamiento de servicios. El primerio concerniente a la plataforma de streaming Apple TV, la cual pretende competir contra plataformas como Neflix, HBO y Amazon Prime. Asimismo, anunció un servicio de sucripción a noticias por menos de 10 dólares al mes y el lanzamiento de los nuevos AirPods. Por otro lado, los analistas de Citigroup elevaron el precio objetivo en  50 dólares hasta 220 dólares. Se prevee un aumento en la repartición de dividendos	0	f
b51e2179-2235-4584-b60e-a5e4c0123a85	5aef4508-b970-4a28-bd12-1b19015f584f	2019-05-17 00:00:00	355.02	f	\N	0	f
e87b77d2-497c-43ea-a557-b10c386db01d	4a4061ee-3175-477f-b598-7104ed81818e	2019-06-14 00:00:00	214.92	f	\N	0	f
50678c15-3a25-459a-92d9-f914f5ff60e6	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-05-31 00:00:00	44.04	f	\N	0	f
eef4a285-6f4c-4133-9a04-f8c35491b193	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-04-19 00:00:00	1861.69	f	\N	0	f
93b1affc-6140-4bfc-b774-5ef7c108baea	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-05-31 00:00:00	37.91	f	\N	0	f
93cf0e5c-1c6a-43fe-b0e6-0e9af927cdf4	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-05-23 00:00:00	0.41	t	La compañía minera Volcan tuvo un primer trimestre desafiante por un contexto de menores precios de los metales, mayores costos por depreciación y amortización, y una menor ley de minerales por un cambio en su proceso de extracción. La empresa proyecta una recuperación de sus operaciones para el resto del año; sin embargo, su apalancamiento actual y su alta volatilidad del precio de algunos minerales por la guerra comercial —específicamente el zinc— podrían poner en riesgo los resultados de la empresa en el corto plazo.	0	f
8aa5855a-a0f2-4011-a5a4-8257eb427c74	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-06-21 00:00:00	5.16	f	\N	0	f
bb92b976-1098-4890-be61-ed3ca9e0e85e	08976987-dd81-414e-9789-4ab9d173a238	2019-06-14 00:00:00	23.33	f	\N	0	f
7a3f5607-385c-4955-a6e9-995d46afc247	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-07-12 00:00:00	89.12	f	\N	0	f
20af8c28-b55b-483d-a18c-74bb9f4141c8	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-07-19 00:00:00	201.8232	f	\N	0	f
0a9639d6-2512-4f22-a29a-4f310829fabc	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-07-23 00:00:00	307.3	t	Las consecuencias de la competencia potencial en el negocio de streaming (de parte de plataformas como Disney + y Amazon) amenazan a Netflix, que antes se había posicionado como el líder en el sector. Esto se reflejó en un menor número de suscriptores que el que se había esperado (2.1 millones menos). Los consumidores se están retirando, entre otros motivos, porque las películas de Disney y Warner muy pronto ya no se encontrarán disponibles en la plataforma. Analistas argumentan que Netflix tendría que bajar sus precios de suscripción para volver a ganar más clientes.	0	f
2c1c85cb-12f7-45f4-8f87-620b7d366627	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-08-23 00:00:00	2.29	f	\N	0	f
8a47cea5-c154-42a3-961f-963e9ddf9b6e	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-09-13 00:00:00	138.02	f	\N	0	f
bca56b0a-15ab-451f-ab4d-92cf680d7042	f3579400-2263-474d-92b8-b03e2c434915	2019-09-13 00:00:00	30.69	f	\N	0	f
16653b6e-2552-48da-a023-09b306829685	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-02-08 00:00:00	62.01	f	\N	0	t
c617bb7a-ed41-4189-9cb0-d0658907a741	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-03-01 00:00:00	11.053	f	\N	0	t
b0dec041-90df-450b-b0b9-a6277f96ce27	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-03-01 00:00:00	40.02	f	\N	0	t
2b73a9d1-5f5f-4dfd-a457-4be095b1fa2a	f3579400-2263-474d-92b8-b03e2c434915	2019-02-22 00:00:00	24.36	f	\N	0	t
dcc1ed6a-f5d4-40c8-bcc3-030339f78a3b	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-03-01 00:00:00	53.3	f	\N	0	t
96c0f331-ec64-46a6-bea7-0db57b9fb054	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-01-18 00:00:00	1696.2	f	\N	0	t
3d02f63f-79df-45fd-96c0-7298044f78a8	4a4061ee-3175-477f-b598-7104ed81818e	2019-12-28 00:00:00	333.87	f	\N	0	f
c9ff2fe3-c9e0-48b4-b7dd-97c0c42628cc	08976987-dd81-414e-9789-4ab9d173a238	2019-09-30 00:00:00	26.71	t	El precio del oro cayó a causa del fortalecimiento del dólar estadounidense y por una alza general en el rendimiento de las principales bolsas de Wall Street.	0	f
4fd70bc8-1163-4eb4-8bf2-429b0f3cd66a	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-10-03 00:00:00	92.22	f	\N	0	f
71e3b021-1248-4e1d-b28b-2fb70bec4ef1	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-05-03 00:00:00	385.03	f	\N	0	f
36bf9be7-667e-4eec-bdc6-5ec4d97b8e6e	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-05-24 00:00:00	1.95	f	\N	0	f
62226ada-8160-419e-9027-8dc90612f1d1	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-10-04 00:00:00	0.45	f	\N	0	f
206f18c5-7f0f-4e9f-a6e0-0dc519472cc1	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-03-08 00:00:00	2.06	f	\N	0	t
090f3cc5-bb92-49f3-8472-716cbfce8b9e	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-03-01 00:00:00	97.93	f	\N	0	t
0ca64708-a9ad-4594-9483-776e80f773af	c2db4b85-9098-4110-9761-fbd6a846707c	2019-03-15 00:00:00	41.78	f	\N	0	t
8fca3bb2-c61e-4930-b629-de0ae344b8a6	08976987-dd81-414e-9789-4ab9d173a238	2019-07-19 00:00:00	27.98	f	\N	0	f
98a7c2f2-ea04-4868-a796-c9dfb3abacd2	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-07-05 00:00:00	380.55	f	\N	0	f
7c1b121f-ae5d-467a-a191-7902f0e3029b	f3579400-2263-474d-92b8-b03e2c434915	2019-07-26 00:00:00	34.02	f	\N	0	f
43bc600c-955e-4e69-837f-1e87685e0f3d	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-05-24 00:00:00	10.450	f	\N	0	f
873d63b6-f87a-480d-baaa-02de83d3e377	08976987-dd81-414e-9789-4ab9d173a238	2019-05-24 00:00:00	20.57	f	\N	0	f
905fcf70-8da3-49d7-a366-2ce44bbb72eb	4a4061ee-3175-477f-b598-7104ed81818e	2019-07-05 00:00:00	233.1	f	\N	0	f
d4ed7175-1f43-4b09-9de2-42f65afb17de	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-06-28 00:00:00	139.64	f	\N	0	f
da5e62b5-0c99-4f45-a485-2a92093c8624	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-08-02 00:00:00	2.15	f	\N	0	f
b2136053-7fb5-46f4-8afa-4131b7e680ad	b65ad095-d3d3-4281-9765-0c724afba7af	2019-06-21 00:00:00	13.17	f	\N	0	f
261f0869-10b6-4281-b2d2-a9e6f87f97b9	3854af87-a18e-4509-be17-6145a85578b6	2019-05-31 00:00:00	124.84	f	\N	0	f
118eea12-bcb9-4b5d-8b9d-cf39647c6668	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-08-02 00:00:00	48.68	f	\N	0	f
0c06b9fd-8ab8-4d57-95ba-85daa282e5ab	5aef4508-b970-4a28-bd12-1b19015f584f	2019-07-05 00:00:00	355.86	f	\N	0	f
65bfc0ee-28f4-41f5-bf5f-34bbbc32742f	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-08-02 00:00:00	36.7746	f	\N	0	f
f1495a7e-171b-4068-89d3-4f9989e9680a	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-08-02 00:00:00	67.61	f	\N	0	f
97717f59-e0a3-49d4-8ac0-ba6da38f928f	4a4061ee-3175-477f-b598-7104ed81818e	2019-08-16 00:00:00	219.94	f	\N	0	f
4786e7de-69f6-4d54-b5c0-e6678bd6e1ae	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-08-02 00:00:00	81.14	f	\N	0	f
fcbc0da1-417a-4bdd-ab82-2888ad2af508	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-08-09 00:00:00	2.30	f	\N	0	f
a97be6b3-878e-4ecf-a8a1-43ad7328f5ba	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-06-28 00:00:00	1893.63	f	\N	0	f
369e36ff-d307-47a4-b82d-8df08628ad6c	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-09-06 00:00:00	139.55	f	\N	0	f
a40fd217-4c39-4a26-9eb0-711a51d7a306	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-08-02 00:00:00	1823.24	f	\N	0	f
a3b70e58-3f78-4b02-b746-39e2d5ea1360	08976987-dd81-414e-9789-4ab9d173a238	2019-08-29 00:00:00	29.86	f	\N	0	f
9b0192dc-d913-4473-a013-d3dfc94a8561	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-08-30 00:00:00	0.449	f	\N	0	f
61f3217a-17cc-4918-a7ed-9fe134c74507	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-09-20 00:00:00	2.11	f	\N	0	f
aaa79d4f-2972-4128-a619-39ac7027b0ce	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-09-06 00:00:00	9.400	f	\N	0	f
206483b6-ac02-41d1-a215-0112090c9309	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-08-09 00:00:00	1807.58	f	\N	0	f
ff1a98b8-1a4f-458d-8fda-762a8e73d8e0	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-09-06 00:00:00	0.465	f	\N	0	f
bfb4f900-f59b-4099-b748-0b41fff727ab	f3579400-2263-474d-92b8-b03e2c434915	2019-03-01 00:00:00	23.68	f	\N	0	t
8b576f95-94ad-4476-be84-ca0ecd539719	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-04-26 00:00:00	52.43	f	\N	0	f
9a5244c9-35f6-4bff-949d-41c0157d3963	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-05-10 00:00:00	46.2	t	Intel, el mayor fabricante de circuitos integrados, contrajo sus ganancias trimestrales, luego de registrar un crecimiento nulo en sus ventas, con respecto a las obtenidas un año antes.	0	f
dcac5c46-15fd-4876-93ff-9151abb7b35d	5aef4508-b970-4a28-bd12-1b19015f584f	2019-03-15 00:00:00	378.99	t	El 737 Max, el modelo más popular de Boeing, se ha convertido en el epicentro de un seísmo que amenaza con doblar la columna vertebral del negocio de aviación civil del fabricante aeronáutico estadounidense y poner contra las cuerdas los planes de muchas aerolíneas.	0	t
ffc99857-bd14-483a-be59-dd6159a2ef67	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-05-24 00:00:00	2.25	f	\N	0	f
74a57bc6-4a4c-4ed8-9b6f-6195aa4c15ae	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-05-31 00:00:00	2.17	f	\N	0	f
67767df4-45d1-4f2f-b3c9-ecb48dedeac2	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-05-24 00:00:00	2.49	f	\N	0	f
4c1f5522-ecd1-4bd5-8643-9e5947c6f5ff	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-06-07 00:00:00	2.2	f	\N	0	f
60aa23ea-fe1e-4fb5-bcf7-a52752cbea6e	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-05-31 00:00:00	101.44	f	\N	0	f
5eb53ab6-7b43-47b1-b7fc-855b872cce13	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-06-14 00:00:00	141.65	f	\N	0	f
5cf7bcc1-e080-4947-8dfe-e84073973d21	b65ad095-d3d3-4281-9765-0c724afba7af	2019-01-18 00:00:00	10.8	f	\N	0	t
3910317a-7383-4f98-a2ec-5f68857f0c16	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-01-25 00:00:00	2.01	f	\N	0	t
bc139ca7-db24-412b-8d3b-119dd34e180e	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-01-25 00:00:00	32.7702	f	\N	0	t
6a5941c8-31e6-4d2a-bbb6-496c2578dea7	07618a28-45f0-4f9a-bf47-7e55e517ce21	2018-12-16 00:00:00	297.57	f	\N	0	t
ef9ede6b-4b7e-4f1f-a7f1-d40b3e6b9f78	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-01-18 00:00:00	154.9625	f	\N	0	t
81107f62-7aea-4365-8623-e087a1cec357	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-02-04 00:00:00	11.210	t	Alicorp Compra la empresa Intradevco, dueña de Sapolio, Aval y Dento(Empresas de cuidados del hogar). Siendo dueña de 99.78% de sus acciones. Esto fortalecera la presencia internacial de la compraña en Latinoamerica.	0	t
8654b4b0-d418-428a-b924-1854cb203f16	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-02-01 00:00:00	63.67	f	\N	0	t
b0c88cea-e1c7-4f26-bc29-a9d0096271e5	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-04-05 00:00:00	2.394	f	\N	0	f
9e41c700-a7d2-4291-920d-197c8de87d62	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-04-19 00:00:00	5.322	f	\N	0	f
e3b8d494-5a3c-4345-bcf8-9a55e35d5c2d	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-04-26 00:00:00	140.39	f	\N	0	f
26651983-471e-4c5d-bbfb-564e9787c442	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-08-09 00:00:00	308.93	f	\N	0	f
7b83e3d5-401a-4cd9-ae54-70906bf96fca	5aef4508-b970-4a28-bd12-1b19015f584f	2019-08-30 00:00:00	364.09	f	\N	0	f
68d83806-f3fb-4758-92b1-f031b18bf062	f3579400-2263-474d-92b8-b03e2c434915	2019-09-06 00:00:00	30.56	f	\N	0	f
fcddcd99-2a0f-41b3-8167-0dcd79e3a57e	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-09-06 00:00:00	1.67	f	\N	0	f
c3ad2aae-569b-457c-8b96-dff5c790e627	c2db4b85-9098-4110-9761-fbd6a846707c	2019-09-06 00:00:00	36.5	f	\N	0	f
df042733-5dcb-4e1e-9a0b-e88c434af832	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-01-11 00:00:00	0.7	f	\N	0	t
cf742298-21d0-40d0-8741-30507cbdf9d4	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-01-18 00:00:00	130.69	f	\N	0	t
c62dbf20-2030-486c-b4b8-03374eea3379	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-01-18 00:00:00	2.375	f	\N	0	t
a41575b4-146c-4dd5-b825-d8bede014b2c	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-01-18 00:00:00	111.04	f	\N	0	t
b76c3c99-3320-47c9-bda4-276f9898a7c4	5aef4508-b970-4a28-bd12-1b19015f584f	2019-01-25 00:00:00	364.2	f	\N	0	t
54ba6a38-4f07-4f2e-8838-eeeaba75eb5d	110c6254-9596-4e36-a939-8f7a2d557a35	2019-02-01 00:00:00	165.71	f	\N	0	t
c6aa1aa8-b63a-492b-8353-4ae026bb5964	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-02-08 00:00:00	1.90	f	\N	0	t
108e030e-1c8d-4980-bcac-33d3b91eb7ed	f3579400-2263-474d-92b8-b03e2c434915	2019-02-01 00:00:00	24.51	f	\N	0	t
74b31cc4-8585-4529-9b31-fc2c2124d2e5	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2018-12-28 00:00:00	1478.02	f	\N	0	t
ae9722ce-0382-4755-969f-623a59e5ca3d	b65ad095-d3d3-4281-9765-0c724afba7af	2019-02-08 00:00:00	11	f	\N	0	t
ef5d9f38-f0aa-4d6a-8954-572d8a380609	08976987-dd81-414e-9789-4ab9d173a238	2019-02-08 00:00:00	22.34	f	\N	0	t
8da31556-c4a6-4e5e-ad43-e81477bfcd8d	4a4061ee-3175-477f-b598-7104ed81818e	2019-04-19 00:00:00	273.26	f	\N	0	f
13968fcb-802f-4f2a-9d61-8d3287affe41	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-04-12 00:00:00	35.9698	f	\N	0	f
808a377c-cb10-4add-b13e-fe2643a1495d	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-02-22 00:00:00	36.0512	f	\N	0	t
bdeb1c7f-7962-4ad4-bc9c-0300537ca519	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-03-15 00:00:00	10.946	f	\N	0	t
9dc3fd3c-9e3e-47f6-98a7-914da920d100	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-05-03 00:00:00	10.710	f	\N	0	f
026f9d0d-90d5-4a1a-ae52-6014ea52d2c6	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-05-03 00:00:00	51.75	f	\N	0	f
317feeaf-bab9-4eeb-9826-d9b4dd6be3d1	110c6254-9596-4e36-a939-8f7a2d557a35	2019-05-17 00:00:00	185.3	f	\N	0	f
a2ff9a35-a180-4772-a0c3-fa8c4bfc669a	110c6254-9596-4e36-a939-8f7a2d557a35	2019-08-02 00:00:00	189.02	f	\N	0	f
a3157bfe-1178-4eae-b723-68add11013b0	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-05-10 00:00:00	101.91	f	\N	0	f
10f7b501-0b8c-4d4f-b1a5-60921227db18	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-05-17 00:00:00	30.681	f	\N	0	f
e000433f-2620-419b-aeaf-981823abd8bc	110c6254-9596-4e36-a939-8f7a2d557a35	2019-03-08 00:00:00	169.6	f	\N	0	t
9e120aff-95f9-4c15-a9e9-3afbb8bcf82e	f3579400-2263-474d-92b8-b03e2c434915	2019-03-15 00:00:00	23.29	f	\N	0	f
3edd91f6-9705-4664-b238-a3bb690f9ca2	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-01-11 00:00:00	34.47	t	Newmont anuncia la compra de su rival canadiense Goldcorp por 10,000 millones de dólares. Con esta fusión la compañía se convertirá en el líder mundial en producción de metales preciosos, desplazando a la canadiense Barrick Gold. Según los términos del acuerdo, Newmont ofrece el 32,80% de una de sus acciones por cada acción de Goldcorp.\n\nLos accionistas de Newmont poseerán aproximadamente el 65% del capital de la nueva estructura, en comparación con el 35% de Goldcorp. 	0	t
c397d243-4fbc-4265-802d-74d0d1a96c5d	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-01-04 00:00:00	55.13	f	\N	0	t
6a0d9006-8bfe-4385-bde8-3c6bea47f724	07618a28-45f0-4f9a-bf47-7e55e517ce21	2018-12-15 00:00:00	256.08	f	\N	0	t
f11ae1bb-927e-41d5-a739-eff19291e39f	08976987-dd81-414e-9789-4ab9d173a238	2019-01-18 00:00:00	20.31	f	\N	0	t
10a03125-9b87-4767-b948-f194b5965b08	f3579400-2263-474d-92b8-b03e2c434915	2019-01-29 00:00:00	19.25	f	\N	0	t
2802c457-01d6-40b5-a4bf-51ccf6d9117c	110c6254-9596-4e36-a939-8f7a2d557a35	2019-01-11 00:00:00	143.8	f	\N	0	t
2b8daf32-7022-4607-b9ff-671eb3f78349	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-02-08 00:00:00	347.57	f	\N	0	t
29ac8a75-7bcb-4180-9239-e3269a01da90	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-03-15 00:00:00	5.159	f	\N	0	t
98ffd1e7-f075-4998-ac08-7c5e82121871	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-03-01 00:00:00	173.639	f	\N	0	t
e35713c9-2a8a-458e-8b3d-eb21a6d676df	b65ad095-d3d3-4281-9765-0c724afba7af	2019-03-08 00:00:00	12.3	f	\N	0	t
0c272cc8-3de2-4ea2-8c24-26b335686ca8	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-07-05 00:00:00	44.5	f	\N	0	f
5bca7700-7a74-4c98-936f-9c6fe5e958c7	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-06-28 00:00:00	110.49	f	\N	0	f
77e469c2-ad91-4d86-838a-e7e28b9b98f7	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-07-12 00:00:00	144.88	f	\N	0	f
322d7e96-809f-49f0-bb1f-d8c55aa477e5	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-07-19 00:00:00	50.27	f	\N	0	f
aee573ab-fb39-48cf-b7de-397ab84d4b00	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-07-19 00:00:00	130.31	f	\N	0	f
a269f5ef-1c02-4eee-a307-3a89d18e91b1	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-08-02 00:00:00	131.07	f	\N	0	f
31a52d69-6fb3-4740-acb7-e83ece9b9998	b65ad095-d3d3-4281-9765-0c724afba7af	2019-08-02 00:00:00	14.32	f	\N	0	f
ef7e1e6f-bd50-404d-9318-a1f84fef5da0	110c6254-9596-4e36-a939-8f7a2d557a35	2019-08-09 00:00:00	187.85	f	\N	0	f
bde72d49-21d9-496a-9588-54d065341c59	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-08-09 00:00:00	66.05	f	\N	0	f
3d2ab914-b3d7-42dc-bb77-8e6269f0209e	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-07-15 00:00:00	366.6	f	\N	0	f
3aad69b0-a5ad-4de1-91f8-d3680bb98687	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2018-11-30 00:00:00	1690.17	f	\N	0	t
ff7ff775-c451-4421-a5f1-a9e7452c3437	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-01-04 00:00:00	47.22	f	\N	0	t
960ab563-b488-4686-b6c8-7407034baf29	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-01-04 00:00:00	74.65	f	\N	0	t
c312f01e-3133-4ac9-8699-131e5aa342ee	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-01-04 00:00:00	2.58	f	\N	0	t
2c20e631-18fd-4ce1-ab13-50c49ffedc44	4a4061ee-3175-477f-b598-7104ed81818e	2019-01-03 00:00:00	300.36	f	\N	0	t
3785ed9d-e062-45fb-ab79-fd629ccbe23c	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-01-04 00:00:00	109.61	f	\N	0	t
0afa4fe9-4f1f-4bf2-98e8-f7b4136828bc	c2db4b85-9098-4110-9761-fbd6a846707c	2019-01-04 00:00:00	43	f	\N	0	t
ae894ff9-71bd-42f4-831e-2941f55526da	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2018-12-19 00:00:00	31.7128	f	\N	0	t
fe538928-bcc9-49af-a32b-edb248e42c2c	b65ad095-d3d3-4281-9765-0c724afba7af	2018-12-28 00:00:00	10.95	f	\N	0	t
71e1e8d2-963e-4c9e-ad1a-95ef4d8f98aa	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-03-22 00:00:00	60.98	f	\N	0	f
25f4d0f9-41bf-4e83-b2d7-bac67d1b2db6	b65ad095-d3d3-4281-9765-0c724afba7af	2019-06-28 00:00:00	13.77	f	\N	0	f
210b9608-c2fd-4448-b23f-97f26f8f6520	110c6254-9596-4e36-a939-8f7a2d557a35	2019-07-05 00:00:00	196.4	f	\N	0	f
d53ed681-c30b-4080-965b-92e8e5ee21f0	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-06-28 00:00:00	197.1709	f	\N	0	f
9f2cb0bb-9336-4de1-b01f-e23a298393ab	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-05-24 00:00:00	1823.28	f	\N	0	f
0255df35-e70f-4be7-b01d-c8e97e1332ca	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-06-28 00:00:00	0.52	f	\N	0	f
31270ae5-7844-42a3-9e0e-b3fe55fc511d	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-07-05 00:00:00	140.57	f	\N	0	f
aa79d0f9-1fbb-435b-a731-835c3d6d30a5	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2018-12-03 00:00:00	65.16	f	\N	0	t
86e4d386-5b50-4ad9-b218-cef40b929abc	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-02-01 00:00:00	134.2	t	Johnson & Johnson, el mayor fabricante de productos para el cuidado de la salud en el mundo, estaría intentando adquirir Auris Health Inc., en un acuerdo que traería tecnología de robótica quirúrgica de vanguardia.	0	t
94548751-447a-4fbb-8b50-e67cdce65c0d	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-02-22 00:00:00	5.219	f	\N	0	t
947543bc-f447-4d69-a00c-fa560f639c32	4a4061ee-3175-477f-b598-7104ed81818e	2019-01-17 00:00:00	347.31	t	Tesla inicia la construcción de la primera fábrica en China. El pueblo asiático recibió al CEO Elon Musk con gran entusiasmo. Se tienen grandes expectativas acerca de los futuros resultados de la compañía en el gigante asiático.	0	t
0286b7c9-a9cd-4de7-81d8-c3e01cc2ef8e	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-02-08 00:00:00	33.4422	f	\N	0	t
dda5efea-a53d-4cb0-82d3-a5a82a44406d	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-02-19 00:00:00	102.20	t	Walmart reporta su mejor trimestre en una decada. Las ventas para las tiendas en EE.UU. Subieron 4.2% en el trimestre que terminó el 31 de enero y que incluye la Navidad. Además, las ventas online subieron 43%, impulsadas por la expansión de los servicios de retiro y entrega de productos comprados por internet y por un mayor surtido del sitio web.	0	t
b38a7213-c7bb-4cab-9c75-a205f320d905	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-04-05 00:00:00	44.88	f	\N	0	f
2f539853-7700-43a7-a90c-a2fb2fbd4350	3854af87-a18e-4509-be17-6145a85578b6	2019-03-01 00:00:00	124.45	f	\N	0	f
febba485-1792-43e9-bc6d-7aefff2f3698	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-04-05 00:00:00	5.408	f	\N	0	f
6b62de36-2111-4d72-8499-534f1f54b0e3	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-07-26 00:00:00	0.53	f	\N	0	f
ca3e3423-5883-451c-b18b-15c9a3ea6cdd	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-08-23 00:00:00	9.450	f	\N	0	f
2b219e19-4f77-474c-922b-12a580dda05c	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-08-30 00:00:00	137.26	f	\N	0	f
224a15b9-6404-42bb-917f-0e8b9e7972b8	b65ad095-d3d3-4281-9765-0c724afba7af	2019-03-22 00:00:00	12.24	f	\N	0	f
ea0256b8-3168-4c51-bb16-0dfd6fd4caa8	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-06-07 00:00:00	46.03	f	\N	0	f
f17b6f4a-27d1-46cf-9e41-7d2d97fe71fb	f3579400-2263-474d-92b8-b03e2c434915	2019-06-14 00:00:00	33.23	t	AMD presentó la tercera generación de sus proecsadores Ryzen con un modelo de 12 núcleos. Este nuevo producto mejora hasta en un 15 por ciento las instrucciones de media por ciclo (IPC) de la generación anterior de Zen. Con esta nueva edición AMD le hace la guerra a los productos de Intel	0	f
aa631799-16b9-4030-8979-3388403c290e	4a4061ee-3175-477f-b598-7104ed81818e	2019-02-01 00:00:00	312.21	f	\N	0	t
e3fa22fc-5224-4b60-89a5-d105ec44be1a	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2018-12-21 00:00:00	1377.45	f	\N	0	t
1e7591be-fb31-425f-a1f2-eb2b5483bf8d	c2db4b85-9098-4110-9761-fbd6a846707c	2019-02-01 00:00:00	42.88	t	La compañía farmacéutica estadounidense Pfizer obtuvo un beneficio neto atribuible de 11.153 millones de dólares (9.765 millones de euros) en 2018, lo que supone reducir en un 47,6% las ganancias del grupo, que en diciembre de 2017 perdió la exclusividad de la patente de Viagra.	0	t
4aab1164-7254-40e3-acc3-c5fe4707d552	5aef4508-b970-4a28-bd12-1b19015f584f	2019-02-08 00:00:00	404.91	f	\N	0	t
5d183336-6e95-476c-8d49-be32707f6f3d	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-02-08 00:00:00	111.51	f	\N	0	t
4f393266-ea58-408d-80a0-f9bf1cf1cf2e	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-02-08 00:00:00	0.73	f	\N	0	t
0f6759a9-9e15-4c4a-bf0b-bccefd6bd1e0	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-05-10 00:00:00	134.04	f	\N	0	f
69539d90-83e9-4082-b63f-39a8ea0d854a	c2db4b85-9098-4110-9761-fbd6a846707c	2019-02-15 00:00:00	42.4	f	\N	0	t
a49d6fa3-c82f-4b66-8f89-37cf360a8cfe	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-05-10 00:00:00	10.850	f	\N	0	f
aa2abb6c-229f-44d5-9035-bab50c62c0b9	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-02-01 00:00:00	339.85	f	\N	0	t
b8bfc7cd-f949-4a50-b8b7-6418037604ca	5aef4508-b970-4a28-bd12-1b19015f584f	2019-02-22 00:00:00	424.05	f	\N	0	t
24a42b91-69de-4782-8db9-785b70437335	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-07-12 00:00:00	49.92	f	\N	0	f
4b4e8b9b-1c55-4fb0-8ada-fd31e82a88c5	c2db4b85-9098-4110-9761-fbd6a846707c	2019-08-30 00:00:00	35.55	f	\N	0	f
864f8896-b435-4726-9b15-5e6bdf7968cb	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-08-30 00:00:00	47.41	f	\N	0	f
bc627749-bcd2-4f25-9d0f-ee45b3bc6152	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-08-23 00:00:00	202.64	f	\N	0	f
60de2d5a-ea2f-4ba8-87df-9a106ffb443c	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-12-28 00:00:00	5.022	f	\N	0	f
f7ff5eec-6f9b-4298-beaf-9b5115c59805	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-02-22 00:00:00	136.6	f	\N	0	t
610f44a8-0be6-4d94-a531-00e204d46255	5aef4508-b970-4a28-bd12-1b19015f584f	2019-03-01 00:00:00	440.62	f	\N	0	t
97fe1727-1e70-4697-84ad-5e7702ae492b	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-03-08 00:00:00	171.5947	f	\N	0	t
b820b49d-c196-4b84-993d-e780f3e2f290	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-02-08 00:00:00	37.47	f	\N	0	t
11fac50d-5e20-4d10-8ed3-af693a9c6897	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-01-04 00:00:00	1575.39	f	\N	0	t
327316eb-f69a-4ee6-8477-d17a7fddbf54	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-03-15 00:00:00	2.328	f	\N	0	t
547d95ba-b057-486c-a6ef-83ccce83fa4a	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-03-08 00:00:00	0.65	f	\N	0	t
eb20c124-ac2c-452e-848c-747aa20747de	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-03-15 00:00:00	32.8839	f	\N	0	t
7ce63b55-8812-45fd-8501-275059462610	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-03-29 00:00:00	84.21	f	\N	0	f
a1d9dfef-3156-419a-a816-05edb4544521	c2db4b85-9098-4110-9761-fbd6a846707c	2019-04-12 00:00:00	41.71	f	\N	0	f
5a11b9c8-16f0-4c96-9d07-46f478c136d5	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-05-17 00:00:00	65.07	f	\N	0	f
465f62ad-5fcc-4244-ad4d-87d447daaed0	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-05-24 00:00:00	38.24	f	\N	0	f
ac07966d-bae7-4ec1-9ddb-072be30f7b3c	4a4061ee-3175-477f-b598-7104ed81818e	2019-09-20 00:00:00	247.1	t	Tesla anuncia el mes de presentación de su nuevo modelo pickup, producto que ha generado muchas expectativas desde hace meses.	0	f
65f7023c-f0b8-481d-b4f6-75c8d0c7fdb7	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-09-12 00:00:00	2.18	f	\N	0	f
e9af824a-502e-4d2e-acc8-ca3fa48d0645	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-09-13 00:00:00	70.39	f	\N	0	f
528ca48b-8c40-4df0-a312-87129be46f89	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-09-20 00:00:00	63.76	f	\N	0	f
25477657-9e3a-4807-952a-5e9c5dcca6bf	3854af87-a18e-4509-be17-6145a85578b6	2019-02-22 00:00:00	128.84	f	\N	0	f
9c803ac5-cc86-4986-b22c-e708ca4e938e	07618a28-45f0-4f9a-bf47-7e55e517ce21	2018-12-13 00:00:00	276.02	f	\N	0	t
475b04f1-74c9-44d6-af9b-349b1941d175	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-01-11 00:00:00	37.85	f	\N	0	t
225cd9c2-528a-4c89-bacc-27937974e49b	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-01-11 00:00:00	48.93	f	\N	0	t
d72cc3fd-7d86-4136-89e3-d685313e6e1a	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2018-12-24 00:00:00	1343.96	t	Wall Street cierra con fuertes pérdidas en la peor víspera de Navidad de su historia. Wall Street cerró el 24 de diciembre con fuerte pérdidas. Sus tres principales índices Dow Jones, S&P500, y NASDAQ experimentaron pérdidas de -2.91%, -2.71% y -2.21%, respectivamente. Según analistas, hay temor a la desaceleración de la economía mundial y a la inestabilidad política derivada del tercer día consecutivo del cierre de la Administración de los EE.UU.	0	t
bead1b4c-1a2d-4191-bc88-e81ef36ac8ff	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-02-08 00:00:00	2.73	f	\N	0	t
5216b97f-5e04-475d-81d8-1c682f0a39a0	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-02-22 00:00:00	2.432	f	\N	0	t
697e5047-3cc2-4232-84d6-487645bbb159	4a4061ee-3175-477f-b598-7104ed81818e	2019-03-08 00:00:00	284.14	f	\N	0	t
dce1facd-d3a0-46c7-a412-8a225a91c986	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-03-01 00:00:00	138.35	f	\N	0	t
01d8488b-c760-41c9-8486-c34671c143b7	08976987-dd81-414e-9789-4ab9d173a238	2019-02-22 00:00:00	23.06	f	\N	0	t
0dd5f9aa-7074-4fd5-87e5-47d96dc752ee	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-03-01 00:00:00	114.01	f	\N	0	t
69843037-bfca-483f-93e9-ad65c231b1fa	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-02-22 00:00:00	99.55	f	\N	0	t
a8b93963-2a9d-404d-b945-6b969150501f	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-03-20 00:00:00	2.68	t	Inician un proyecto de inversion para la preservación del patriminio cultural en Lomas, lo cual requirio una inversión de capital social. La baja en sus acciones fue, la posible perpetración a una de sus plantas lo cual demuestra una falta de seguridad.	0	f
ffde8ade-9be8-4549-8852-cf7779c89a42	3854af87-a18e-4509-be17-6145a85578b6	2019-03-22 00:00:00	124.5	f	\N	0	f
1e285732-ebc1-40f9-890f-acb39a4e29f5	110c6254-9596-4e36-a939-8f7a2d557a35	2019-05-03 00:00:00	195.47	t	Facebook prepara su moneda virtual para comprar en su plataforma. Según, The Wall Street Journal, Facebook está contratando a diversas compañías comerciales y financieras que le permitan lanzar un sistema de pagos en monedas virutales para fomentar tanto la compra de servicios como transferencias de usuarios. La compañía busca una moneda virtual que no pierda valor, con lo que estaría trabajando con diferentes entidades para lograr apuntalar el valor de la moneda para protegerla de los cambios bruscos de los precios observados en bitcoins y otras criptomonedas.	0	f
21e3038c-7911-4b87-807e-c9f29ecca2bb	c2db4b85-9098-4110-9761-fbd6a846707c	2019-05-10 00:00:00	40.72	f	\N	0	f
70f90b0b-3134-4890-b20c-a1e635e26b07	3854af87-a18e-4509-be17-6145a85578b6	2019-04-19 00:00:00	134.41	f	\N	0	f
594be03b-6775-44e2-8abd-6d6e14f045bf	4a4061ee-3175-477f-b598-7104ed81818e	2019-06-03 00:00:00	178.97	t	Tesla experimenta su peor momento en el año con un descenso del 43% en el precio de su acción desde enero. Así, la compañía pierde 4,900 millones de dólares, ante el creciente esceptisismo de Wall Street sobre la demanda de vehículos eléctricos de la compañía.	0	f
f01039e6-81f2-4b67-bb75-f5aceaebfd96	5aef4508-b970-4a28-bd12-1b19015f584f	2019-07-26 00:00:00	345	f	\N	0	f
1c9e9d10-3bcc-4de3-89b9-15eb0c7d8b52	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-01-18 00:00:00	36.33	f	\N	0	t
c3d2986c-8531-4d3f-b47f-a2b1c7f65216	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-01-18 00:00:00	2.60	f	\N	0	t
6ef7fbe3-eab6-45df-91ea-1e597ebd6c7a	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-01-25 00:00:00	80.61	f	\N	0	t
8154cd5d-3f94-4fae-8ec6-b5bdbf8ecf71	3854af87-a18e-4509-be17-6145a85578b6	2018-12-28 00:00:00	107.24	f	\N	0	t
b7d10e5b-0dc4-42f3-8b69-11f8d236a400	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-01-25 00:00:00	38.42	f	\N	0	t
da043f74-0874-4ba7-b152-4c340c6564e2	c2db4b85-9098-4110-9761-fbd6a846707c	2019-01-25 00:00:00	40.64	f	\N	0	t
4819ceb8-537e-4846-81f0-677ffc1915f9	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-01-25 00:00:00	2.413	f	\N	0	t
e0961bb2-65c5-427c-abbc-6fcadaa12281	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-01-25 00:00:00	10.320	f	\N	0	t
f1ce0773-958d-4649-976d-90a866dbfd2f	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-02-01 00:00:00	33.4422	f	\N	0	t
2e604ac0-709d-40c3-9623-de4e47b840f6	3854af87-a18e-4509-be17-6145a85578b6	2019-01-03 00:00:00	101.74	t	Marriot revela ser victima de ciberataques. 500 millones de pasajeros quedaron expuestos a piratas informáticos, quienes han duplicado tarjetas de créditos, saqueados cuentas de programas de lealtad y montado esquemas complejos para engañas a los empleados para que descarguen softwares maliciosos. De esta manera el sector hotelero se ha ganado la dudosa reputación de ser un lugar acogedor para faenas.	0	t
225e82f9-b80d-4af2-a01b-114e3804d759	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-02-22 00:00:00	171.6543	f	\N	0	t
b6f7da74-8e09-4e7a-b4b7-4843a37c0d70	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-03-15 00:00:00	2.02	f	\N	0	t
41054b0c-ce4f-4f7b-a3d7-425d827dfe51	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-03-15 00:00:00	43.75	f	\N	0	t
71fe1b88-d7a8-442d-9fc8-bde0a47f529a	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-04-12 00:00:00	2.51	f	\N	0	f
de8dd259-19c6-48c0-90d7-be1579544099	f3579400-2263-474d-92b8-b03e2c434915	2019-04-05 00:00:00	28.98	f	\N	0	f
99f5ae40-0a6e-4ca5-a00f-b2c1cfbe4f34	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-04-26 00:00:00	10.700	f	\N	0	f
30d1a1b8-e3e6-4cce-bdb5-302fd777cffa	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-05-10 00:00:00	0.51	f	\N	0	f
e632e5e1-3fcd-44ad-93f0-188863e881ca	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-05-17 00:00:00	188.2846	f	\N	0	f
948650cd-e094-4060-a56b-0716ea0f4b7e	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-05-24 00:00:00	64.39	f	\N	0	f
0cfe18af-2bca-4b00-afca-1eca136d1a64	110c6254-9596-4e36-a939-8f7a2d557a35	2019-05-31 00:00:00	177.47	f	\N	0	f
6bf7eb93-7f72-4dd6-8b38-04944518e083	b65ad095-d3d3-4281-9765-0c724afba7af	2019-05-24 00:00:00	12.07	f	\N	0	f
5dd9b113-54bd-44b3-bcb9-790df73a23ec	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-06-21 00:00:00	2.2	f	\N	0	f
e39140ad-b3d4-4ba9-8d5e-746a7ed12314	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-06-14 00:00:00	2.45	f	\N	0	f
0482c3b8-ef5c-45d8-afb3-be703533b4ef	4a4061ee-3175-477f-b598-7104ed81818e	2019-06-28 00:00:00	223.46	f	\N	0	f
e2f575d4-7808-4d2c-a405-a1d6cb3c44f1	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-06-14 00:00:00	140.09	f	\N	0	f
adc028af-9bfb-483f-bdb5-73401635a008	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-06-28 00:00:00	47.87	f	\N	0	f
c6cc3db0-69a5-4844-a83c-6e7f3d8fcfe4	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-08-29 00:00:00	209.01	f	\N	0	f
0c4f249d-327a-496b-ad33-99b1d4b76f8a	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-09-13 00:00:00	117.43	t	Las ventas de Walmart crecen 7.4% en el mes de agosto. El crecimiento es el mejor que registra en lo que va del año, ya que en los meses anteriores, las ventas oscilaron entre 3.6% en julio a 7.1% de abril.	0	f
ca4f7275-fa4d-4081-b80b-d478dc34114f	4a4061ee-3175-477f-b598-7104ed81818e	2019-10-07 00:00:00	237.72	f	\N	0	f
7a0fa07f-1cfb-4c59-81cb-7ee0cd9d4691	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-08-16 00:00:00	206.5	f	\N	0	f
4374e4ff-a698-4d93-89c4-7315cacf3f83	f3579400-2263-474d-92b8-b03e2c434915	2019-08-30 00:00:00	31.45	f	\N	0	f
8175e698-bb8f-4c35-8679-f2412562d39b	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-08-16 00:00:00	1792.57	f	\N	0	f
858c1e98-9edf-4799-903d-48e2319341d2	08976987-dd81-414e-9789-4ab9d173a238	2019-03-29 00:00:00	22.42	f	\N	0	f
f76b3a98-a9fe-44bf-b717-9eaa766d31a4	b65ad095-d3d3-4281-9765-0c724afba7af	2019-03-29 00:00:00	11.9	f	\N	0	f
1abfff38-2626-4976-b629-a85302286803	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-04-05 00:00:00	85.4	f	\N	0	f
da32746e-1774-4f45-aa23-2957332befca	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-04-05 00:00:00	115	f	\N	0	f
88c0759e-458d-4b6b-9e7b-471422c96656	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-04-19 00:00:00	10.760	f	\N	0	f
247b3f9c-8557-4f71-a5a4-b34877e69e5b	3854af87-a18e-4509-be17-6145a85578b6	2019-04-12 00:00:00	134.65	f	\N	0	f
9d5ed82a-f2dc-4bbc-963b-11ee6c2a4fb6	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-07-12 00:00:00	10.700	f	\N	0	f
b5f8ac62-b11d-453d-8706-7e4cd57e141a	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-05-31 00:00:00	1775.07	f	\N	0	f
b0276e2e-40e4-4408-b660-7f2eff1dfd77	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-07-19 00:00:00	39.1459	f	\N	0	f
bbb5f65b-db5e-460e-b4f0-39e65d6f8a6c	b65ad095-d3d3-4281-9765-0c724afba7af	2019-07-12 00:00:00	14.35	f	\N	0	f
a5c76f00-eb6d-4ed6-8580-0b04b6445c93	f3579400-2263-474d-92b8-b03e2c434915	2019-01-04 00:00:00	19	f	\N	0	t
7b49a65b-b5ea-4d17-bdba-e3f143f42903	110c6254-9596-4e36-a939-8f7a2d557a35	2018-12-24 00:00:00	133.2	t	Wall Street cierra con fuertes pérdidas en la peor víspera de Navidad de su historia. Wall Street cerró el 24 de diciembre con fuerte pérdidas. Sus tres principales índices Dow Jones, S&P500, y NASDAQ experimentaron pérdidas de -2.91%, -2.71% y -2.21%, respectivamente. Según analistas, hay temor a la desaceleración de la economía mundial y a la inestabilidad política derivada del tercer día consecutivo del cierre de la Administración de los EE.UU.	0	t
90ed1bec-79cb-4429-a6e6-6af87a832819	c2db4b85-9098-4110-9761-fbd6a846707c	2019-01-18 00:00:00	42.53	f	\N	0	t
f828abf5-a71b-46ce-9972-9f1fe6af3d2d	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-01-18 00:00:00	9.938	f	\N	0	t
4d507014-c4a0-4216-8ad7-ff4e7df89483	4a4061ee-3175-477f-b598-7104ed81818e	2019-02-08 00:00:00	305.8	f	\N	0	t
398f8adf-b123-48d5-8ad5-ae4e93786c7b	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-02-15 00:00:00	136.38	f	\N	0	t
a81bb45a-7231-4c34-9cd0-303170902b71	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-02-08 00:00:00	95.58	f	\N	0	t
79ad98f5-e4a2-40c8-b436-def03979e2f4	110c6254-9596-4e36-a939-8f7a2d557a35	2019-02-08 00:00:00	167.33	f	\N	0	t
dd412a09-d2e1-4bbc-b617-1aa274a9d747	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-01-25 00:00:00	338.05	f	\N	0	t
6739700b-2b3c-4470-a101-17d8caa33ca3	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-02-22 00:00:00	115.25	f	\N	0	t
0bb9fccf-c36e-4cd0-922e-61b44a65be1c	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-03-08 00:00:00	1620.8	f	\N	0	f
fa2d97d4-64c0-4dcd-902e-4e227004c0e2	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-04-19 00:00:00	0.58	f	\N	0	f
4cdf390c-c8fc-4c15-9a04-58a97a342480	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-04-19 00:00:00	103.18	f	\N	0	f
db67c836-6eb5-49f6-abd5-2b687ad7acec	4a4061ee-3175-477f-b598-7104ed81818e	2019-05-17 00:00:00	211.03	f	\N	0	f
1d318072-512d-4e37-a130-155691f2a469	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-05-17 00:00:00	5.15	f	\N	0	f
0fb8bdf8-0892-431f-b31a-1ab891920c1b	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-03-29 00:00:00	1780.75	f	\N	0	f
57439672-6bd2-44e0-a82f-b82e9220af1f	4a4061ee-3175-477f-b598-7104ed81818e	2019-05-24 00:00:00	190.63	f	\N	0	f
a5ecd4bf-6e93-456c-b998-6519476ea3bd	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-05-17 00:00:00	135.04	f	\N	0	f
e95356b3-3a14-4e4d-8ce3-6a0ee58f5d2c	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-05-10 00:00:00	196.4337	f	\N	0	f
66fa4f23-8cc4-4a82-bd86-bd9e70390627	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-04-26 00:00:00	374.85	f	\N	0	f
76324400-0b63-4997-ba1c-8891664bef2d	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-04-05 00:00:00	1837.28	f	\N	0	f
d3c7ba38-98ab-4f16-a0bc-bc61b66d866d	f3579400-2263-474d-92b8-b03e2c434915	2019-05-17 00:00:00	27.5	f	\N	0	f
65e108cf-6374-4b51-a344-a2507c72b36a	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-07-19 00:00:00	86.55	f	\N	0	f
121b206a-4506-45c3-9ff8-975ffa32c581	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-08-16 00:00:00	302.8	f	\N	0	f
2960ecb1-ed6a-4919-b46f-db07f229d52c	5aef4508-b970-4a28-bd12-1b19015f584f	2019-09-06 00:00:00	363	f	\N	0	f
ccd740c3-4668-4d4d-ac28-05cc551bbcb7	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-09-13 00:00:00	38.62	f	\N	0	f
fed3fd9f-6693-4f62-8cde-fa5d6dbe23d7	5aef4508-b970-4a28-bd12-1b19015f584f	2019-09-13 00:00:00	379.76	f	\N	0	f
565a38e1-7703-477b-98b3-a1995edfe2d1	110c6254-9596-4e36-a939-8f7a2d557a35	2019-09-13 00:00:00	187.19	f	\N	0	f
8859550b-f89c-4cea-979a-45e781df3824	b65ad095-d3d3-4281-9765-0c724afba7af	2019-09-06 00:00:00	16.8	f	\N	0	f
81fb8b04-f79f-4b43-9274-8224a08f8359	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-09-20 00:00:00	50.72	f	\N	0	f
b4b6f8e4-0e47-4fd6-bab3-578802debc70	110c6254-9596-4e36-a939-8f7a2d557a35	2019-09-20 00:00:00	189.93	f	\N	0	f
d10ab805-fef0-4c07-b03c-e18b588914fc	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-09-13 00:00:00	0.475	f	\N	0	f
2f797454-c31c-4965-858a-9384e423e9ae	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-09-30 00:00:00	62.835	f	\N	0	f
e78ed79d-74ec-47fc-a892-ae6fff1ef506	5aef4508-b970-4a28-bd12-1b19015f584f	2019-01-11 00:00:00	352.9	t	Boeing y Embraer recibieron la aprobación de la Administración del presidente brasileño, Jair Bolsonaro, para dos sociedades conjuntas que darían al fabricante de Estados Unidos control sobre el tercer mayor fabricante de aviones del mundo	0	t
9eac5f58-52f1-424a-9b8f-596f63c74358	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-01-18 00:00:00	0.74	f	\N	0	t
c2050a58-261d-493c-9564-b210186887c3	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-03-15 00:00:00	86.8	f	\N	0	t
8a3a9c3d-6fc5-4d6a-b453-b3cfddf08e8c	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-03-15 00:00:00	54.33	f	\N	0	t
b2c3492c-307f-4c55-8c0d-0109fde82562	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-03-15 00:00:00	137.6	f	\N	0	t
724637d8-acb2-4c4f-9287-0fc88a8b20c8	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-03-29 00:00:00	53.7	f	\N	0	f
f1dce3e2-28b6-4d43-9796-efaf654ef2d4	5aef4508-b970-4a28-bd12-1b19015f584f	2019-03-29 00:00:00	381.42	f	\N	0	f
a971923b-4049-497c-b6ae-e59873df392b	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-07-26 00:00:00	51.59	f	\N	0	f
e08c34e4-c90f-461f-92a6-8a2f3e3bf1fd	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-08-30 00:00:00	64.35	f	\N	0	f
4c5f0c8b-2d2a-4155-bf45-ec337c8f5f7e	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-09-06 00:00:00	128.21	f	\N	0	f
3cffd9fb-164a-4dba-9268-33de938607d9	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-09-27 00:00:00	5.14	f	\N	0	f
bc30df7e-05ed-4346-8278-76c1e62d020d	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-09-13 00:00:00	130.78	f	\N	0	f
d1fb279f-0868-42d9-9f85-9a674f8adc6e	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-10-03 00:00:00	5.16	f	\N	0	f
36129d25-89c7-4782-93aa-b48f260df0f1	4a4061ee-3175-477f-b598-7104ed81818e	2019-04-12 00:00:00	267.7	f	\N	0	f
44d89142-f1fe-4824-a33e-ce410f729b8d	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-03-29 00:00:00	2.25	f	\N	0	f
27438d73-8030-486e-b90a-243d2efae73c	c2db4b85-9098-4110-9761-fbd6a846707c	2019-05-31 00:00:00	41.52	f	\N	0	f
eabfe570-7e8a-41f5-9895-66d780dc2ad9	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-07-12 00:00:00	71.77	f	\N	0	f
537874eb-dfdd-4a2a-b745-b1efcc83b0d8	c2db4b85-9098-4110-9761-fbd6a846707c	2019-07-12 00:00:00	42.4	f	\N	0	f
07a3c7ea-d1a4-4588-be80-45face258e65	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-07-19 00:00:00	10.750	f	\N	0	f
168de665-2e51-4d4b-9b67-d55fc4570de1	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-07-19 00:00:00	139.85	f	\N	0	f
f125ca6c-027e-45e7-ab46-bde0fa0a9fed	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-07-12 00:00:00	202.5305	f	\N	0	f
79ad1ae9-3141-4eff-b2bf-ea0968385f40	08976987-dd81-414e-9789-4ab9d173a238	2019-07-12 00:00:00	26.21	f	\N	0	f
c315cb84-2146-4940-b641-1799d96f2fa8	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-01-03 00:00:00	140.5058	t	Tim Cook, CEO de Apple anunció menores ingresos en el cuarto trimestre del 2018 (merma de entre 5% y 7%) . Esto se vio causado por un menor nivel de ventas en China. La desaceleración de este país y un tendencia mundial hacia la baja contribuyeron a este suceso. Desde el pico registrado en octubre los ingresos de Apple cayeron en 32%	0	t
55c4dbc4-42e0-43aa-95d9-2ead4d76c794	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2018-12-14 00:00:00	1591.91	f	\N	0	t
dfd247e2-524d-45cc-91a0-d18498b995dd	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-03-01 00:00:00	2.356	f	\N	0	t
f5afe75e-743f-4d8d-9453-045487f24729	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-04-05 00:00:00	365.49	f	\N	0	f
00500a98-a915-4bf9-881f-613d25782f39	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-07-19 00:00:00	0.53	f	\N	0	f
eef90ebc-1d83-4d64-bd40-8d1c87f69825	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-06-21 00:00:00	1911.3	f	\N	0	f
cd70ddb1-f7b8-4814-bb6a-574b27975f05	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-08-09 00:00:00	138.52	f	\N	0	f
4b823c2d-cee6-46b3-9a8a-b701ad1213b6	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-08-26 00:00:00	5.05	f	\N	0	f
9c847129-1ef3-4f1f-8836-659ccd644b2a	f3579400-2263-474d-92b8-b03e2c434915	2019-08-09 00:00:00	27.99	t	Inversionistas de Wall Street sienten incertidumbre ante las crecientes tensiones comerciales entre China y Estados Unidos. El viernes pasado Donald Trump amenazó al gigante asiático con la posibilidad de la imposición de nuevos aranceles a productos chinos por 300,000 millones de dólares. Esta noticia afecta sobretodo a la industria tecnológica, quien mantiene relaciones continuas con el continente asiático.	0	f
064a79a0-cb30-4784-8a43-a588f4559aa8	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-09-13 00:00:00	2.11	f	\N	0	f
0b0ce610-47dc-49ae-bf22-b41b36e6fd66	3854af87-a18e-4509-be17-6145a85578b6	2019-08-18 00:00:00	130.57	t	Ya casi acabando el verano en el hemisferio norte, la industria hotelera repartirá los dividendos entre los accionistas, mostrando los frutos cosechados. Hay buenas expectativas al respecto. La compañía estadounidense ha confirmado que abonará el 30 de septiembre un dividendo de 0,48 dólares. En total, el consenso espera que su rentabilidad por dividendo alcance el 1,5% este ejercicio gracias a los cuatro pagos anuales que realiza. Además, en lo que va de año Marriott sube en bolsa más del 20%	0	f
03282c51-8372-41ea-a6dd-f9967e391b38	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-01-25 00:00:00	2.60	f	\N	0	t
9b74e50b-da22-46f1-b05d-677a29f4542f	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-02-01 00:00:00	2.70	f	\N	0	t
3f741267-713d-4278-846d-362a6543cdb1	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-03-08 00:00:00	10.956	f	\N	0	t
46cb9b63-bde6-4630-a853-ceebb367128f	3854af87-a18e-4509-be17-6145a85578b6	2019-02-08 00:00:00	115.48	f	\N	0	t
3966be89-021c-4596-88d8-80532222a2fc	5aef4508-b970-4a28-bd12-1b19015f584f	2019-03-08 00:00:00	422.54	f	\N	0	t
79cc2a1a-729b-414e-b4ce-303119a1ceca	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-03-08 00:00:00	138.06	f	\N	0	t
5fd76896-03d5-4e6d-965e-e3d72749f66b	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-03-08 00:00:00	33.4495	f	\N	0	t
6ddd0d62-916f-4777-8f95-80b99ed6fdd8	110c6254-9596-4e36-a939-8f7a2d557a35	2019-03-01 00:00:00	162.28	f	\N	0	t
ee7395c9-fb64-4d72-a3b6-2f8a38538569	5aef4508-b970-4a28-bd12-1b19015f584f	2019-05-03 00:00:00	376.46	f	\N	0	f
c9a95bab-a13e-4a24-ac23-878edb401f97	f3579400-2263-474d-92b8-b03e2c434915	2019-05-03 00:00:00	28.22	f	\N	0	f
76a2e2d3-b4ee-4985-b42a-59298a74bb5a	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-05-03 00:00:00	142.01	f	\N	0	f
6197d7dd-c6d1-4c28-b751-cd248c174ac7	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-05-31 00:00:00	10.640	f	\N	0	f
84d8f116-e471-43f5-a9a8-7ce7a0722f6b	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-05-10 00:00:00	361.04	f	\N	0	f
4ec234d7-6fc6-4fb2-baa4-5a009fdcfdec	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-07-26 00:00:00	72.16	f	\N	0	f
5f21835c-50c8-4b93-8b6f-d4a9ed6dba01	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-07-19 00:00:00	113.9	f	\N	0	f
edb2b603-7074-4435-981f-ad3c4338dbfb	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-07-26 00:00:00	1.85	f	\N	0	f
4e8faf61-a06e-4995-be17-c74972c3c361	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-07-12 00:00:00	2011	f	\N	0	f
d7b8056b-5904-462b-849b-e672df6ad374	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-09-20 00:00:00	1.63	f	\N	0	f
7993feee-436a-4aae-b59e-087663c80d47	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-09-20 00:00:00	39.84	f	\N	0	f
25151676-abad-4121-8b56-c9af60e073c8	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-10-04 00:00:00	1.53	f	\N	0	f
8ddb481b-35e9-458d-a7e9-9e1e4b076c0d	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-08-30 00:00:00	293.75	f	\N	0	f
dac1f8fb-761c-4b91-ac2d-ab02f6934864	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-09-27 00:00:00	1.65	f	\N	0	f
e663ad22-5273-4e8c-bc6c-e3518ea5ded9	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-05-31 00:00:00	32.8343	f	\N	0	f
8c1cb979-a8e1-4bec-8bd3-f40913af09a9	b65ad095-d3d3-4281-9765-0c724afba7af	2019-06-07 00:00:00	12.37	f	\N	0	f
9d22ccd1-95be-4345-bfd1-e32e3f21b5c3	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-06-14 00:00:00	2.14	f	\N	0	f
6cf1e60e-fa2a-419f-9044-803b0eb71766	110c6254-9596-4e36-a939-8f7a2d557a35	2019-06-14 00:00:00	181.33	f	\N	0	f
c0b0868a-3fbb-42c0-974c-155780a9cd78	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-06-28 00:00:00	5.3	f	\N	0	f
7fac6c8a-1cac-403d-bf7e-98377f7b4350	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-06-21 00:00:00	44.45	f	\N	0	f
94a32899-a1f6-4939-abf8-f523687bb883	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-07-19 00:00:00	70.92	f	\N	0	f
54a818be-e86f-4238-8a1e-083a17de5003	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-01-11 00:00:00	76.04	f	\N	0	t
b14a5c6d-b43f-4522-b2d1-b940f0c08d0c	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-01-11 00:00:00	112.65	f	\N	0	t
a86adbae-7413-467a-a7ad-a51849210976	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-04-26 00:00:00	139.92	t	Se estrena Avengers Endgame y las expectativas sobre las ganancias son muy buenas. De acuerdo a estimaciones, Disney podría recaudar más de 20 mil millones de dólares, rompiendo sus propios records de taquilla.	0	f
a0b8dbe3-6e0b-40de-a071-ed65496f7fbd	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-05-03 00:00:00	134.33	f	\N	0	f
5e7bb63f-633d-406e-b066-9ce4ea796d29	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-10-04 00:00:00	133.66	f	\N	0	f
c51c822c-1db5-40dc-8552-e462336daaf8	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-07-26 00:00:00	10.900	f	\N	0	f
90f865ac-0299-4f0c-b44c-963da8883777	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-07-19 00:00:00	1964.52	f	\N	0	f
50d82c3c-e49a-4d5c-8842-539a6ee3a74f	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-08-30 00:00:00	9.500	f	\N	0	f
bd807df7-bcb3-4ece-9ca3-897d95fe03f9	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-09-20 00:00:00	217.73	f	\N	0	f
c193294e-4775-4119-b5b6-0db4a6370c2e	5aef4508-b970-4a28-bd12-1b19015f584f	2019-05-31 00:00:00	341.61	f	\N	0	f
0071d09e-1fe0-4c76-824d-0a30fc4a03f2	5aef4508-b970-4a28-bd12-1b19015f584f	2019-06-07 00:00:00	353.7	f	\N	0	f
893d1967-6686-40ca-81e9-2846c8dea8f9	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-06-14 00:00:00	10.590	f	\N	0	f
1f4c25f7-7ec8-49f0-80df-40f147ec29f6	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-06-10 00:00:00	0.59	t	De acuerdo a un informe del Minsur, la producción peruana de cobre, plomo, estaño y molibdeno aumentó en abril, ya que las mineras incrementaron la explotación por segundo mes.  Los volúmenes explotados de plomo se incrementaron un 20,4% a 26.841t, los de molibdeno en un 12,8% a 2.370t, y los de estaño en un 4,4% a 1.667t.	0	f
98f8be11-d4fd-4832-8b2b-c3f23513c284	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-07-19 00:00:00	48.22	f	\N	0	f
44ff3d95-2bcf-4944-808a-a5ea06c5377c	4a4061ee-3175-477f-b598-7104ed81818e	2019-08-02 00:00:00	234.34	f	\N	0	f
b687222c-5438-4ce0-8e52-c3f53dbe697c	467304cf-f8f5-43bd-ba30-6498f8f84d80	2018-12-28 00:00:00	154.3795	f	\N	0	t
65003adc-7069-49f0-931f-9958a732a189	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-01-04 00:00:00	36.11	f	\N	0	t
a14cda3a-834b-4c0e-beb4-6e073ec54b1d	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-01-25 00:00:00	5.022	f	\N	0	t
44296203-2719-4b15-968c-0c0bd7f2bb8f	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-02-01 00:00:00	11.053	f	\N	0	t
d78e480f-02a1-4ccb-86dd-c1b26962378f	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-02-01 00:00:00	81.51	f	\N	0	t
c2eadb00-ec95-4896-a8a7-e4f604b6c7aa	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-01-25 00:00:00	96.94	f	\N	0	t
08da87dc-f4e8-46d2-bdf6-8565caee444b	3854af87-a18e-4509-be17-6145a85578b6	2019-01-11 00:00:00	109.42	f	\N	0	t
28da01a7-fc32-453e-9c4b-58b2ba1d60ac	c2db4b85-9098-4110-9761-fbd6a846707c	2019-02-08 00:00:00	42.23	f	\N	0	t
98c25c6b-b73b-42d9-bc26-c289a32324e9	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-02-08 00:00:00	132.4	f	\N	0	t
8dfda3c3-0e4d-4fa1-9dcb-61f429f3640f	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-01-25 00:00:00	64.02	f	\N	0	t
bea65368-1821-4d5b-b325-0f9993e3bfa2	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-02-15 00:00:00	39.53	f	\N	0	t
51d63913-93b1-4f1c-abc7-3bcbfba90793	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-02-15 00:00:00	112.59	f	\N	0	t
cc191bbd-5352-41c7-ab7e-cc4c4a073ee9	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-02-15 00:00:00	85.38	f	\N	0	t
d438f259-0803-4d48-8021-bd73a1514a04	3854af87-a18e-4509-be17-6145a85578b6	2019-01-18 00:00:00	109.05	f	\N	0	t
e6b4e277-c34d-4c6f-8741-139b83da3650	4a4061ee-3175-477f-b598-7104ed81818e	2019-02-22 00:00:00	294.71	f	\N	0	t
ff81cfea-9e5c-4e4a-bcd9-d0fbee2d789d	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-02-15 00:00:00	11.102	f	\N	0	t
e82b77c6-a40b-4088-9dbf-e424f15525be	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-03-01 00:00:00	5.15	f	\N	0	t
fe50c4fc-c3a9-4e64-9f03-70b3797e9339	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-02-22 00:00:00	84.76	f	\N	0	t
0e7fd4f1-f4e7-4b6b-afdb-075af77f3760	c2db4b85-9098-4110-9761-fbd6a846707c	2019-03-08 00:00:00	40.89	f	\N	0	t
e969804c-5881-4990-b136-870cff2d6844	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-03-08 00:00:00	113.81	f	\N	0	t
133e48df-b712-4425-b112-3e811ba6b493	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-03-08 00:00:00	2.318	f	\N	0	t
252d5f2c-e05e-4ebd-9b7c-31ca80f36c2d	08976987-dd81-414e-9789-4ab9d173a238	2018-12-28 00:00:00	20.6	f	\N	0	t
b7fe1bf1-c097-46de-91cb-817da930f87b	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-04-05 00:00:00	195.5015	f	\N	0	f
0ed108b1-9d0f-41e6-9c94-8df04c419dad	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-04-12 00:00:00	197.3572	f	\N	0	f
356defc8-379e-4547-a574-05f0027b8647	3854af87-a18e-4509-be17-6145a85578b6	2019-08-02 00:00:00	135.98	f	\N	0	f
5b29e2b6-d2cf-4dfc-8d92-256de82884e0	3854af87-a18e-4509-be17-6145a85578b6	2019-08-15 00:00:00	128.82	f	\N	0	f
8412c480-fb99-492f-87f3-b44ae6b26357	3854af87-a18e-4509-be17-6145a85578b6	2019-08-23 00:00:00	125.1	f	\N	0	f
b889f1e1-2ac4-48c4-b7d8-1288ed960f57	3854af87-a18e-4509-be17-6145a85578b6	2019-08-30 00:00:00	126.06	f	\N	0	f
c18fc917-94ba-4ef2-bb03-81be6864afba	3854af87-a18e-4509-be17-6145a85578b6	2019-09-06 00:00:00	129.43	f	\N	0	f
515ae98d-57c0-47a8-8140-5d3d9bb03e3a	08976987-dd81-414e-9789-4ab9d173a238	2019-04-19 00:00:00	21.34	f	\N	0	f
c2d32ac3-decc-4d10-854c-b3e95d81172b	f3579400-2263-474d-92b8-b03e2c434915	2019-05-10 00:00:00	27.96	f	\N	0	f
13ff6470-6078-4ecb-8776-1eed42e3deb3	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-05-17 00:00:00	1.95	f	\N	0	f
e2186a41-7fd9-4d9d-9589-97b278272936	3854af87-a18e-4509-be17-6145a85578b6	2018-12-21 00:00:00	102.88	f	\N	0	t
787ccb64-e0bb-4285-9f14-c4a7e9685861	f3579400-2263-474d-92b8-b03e2c434915	2019-01-11 00:00:00	20.27	f	\N	0	t
8d5e9dde-27af-4cb3-a91a-382e8a56c222	467304cf-f8f5-43bd-ba30-6498f8f84d80	2019-01-11 00:00:00	150.4862	f	\N	0	t
f8a09d11-586e-41d3-8d04-2cc295f6f045	110c6254-9596-4e36-a939-8f7a2d557a35	2019-01-04 00:00:00	137.95	f	\N	0	t
188303a2-7b99-47b4-8a3c-71cce5d389dc	5aef4508-b970-4a28-bd12-1b19015f584f	2019-04-05 00:00:00	391.93	f	\N	0	f
f8b8b9a2-27bc-44d7-b2ed-bbc8cc083983	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-04-05 00:00:00	36.2179	f	\N	0	f
0363c768-9723-4241-b8c8-aa73c7a4e5ba	110c6254-9596-4e36-a939-8f7a2d557a35	2019-04-05 00:00:00	175.72	f	\N	0	f
5e18f7ab-0fa4-497d-9323-da1d37799759	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-04-12 00:00:00	2.20	f	\N	0	f
e974fda0-7a18-413c-98bb-119f0024e178	f3579400-2263-474d-92b8-b03e2c434915	2019-04-12 00:00:00	27.85	f	\N	0	f
268b33ba-fb49-49cc-bec0-9625c6cd06bc	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-04-16 00:00:00	129.90	f	\N	0	f
8a6bc059-29ef-4482-a9d2-9a26abb71556	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-04-12 00:00:00	101.56	f	\N	0	f
7dd759c2-08c1-4c10-bd0a-96db55b356b4	4a4061ee-3175-477f-b598-7104ed81818e	2019-02-15 00:00:00	307.88	f	\N	0	t
c710088a-a91c-4c1d-91aa-1150a939e412	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-08-09 00:00:00	5.2	f	\N	0	f
b6ca2691-c497-4932-8ea5-d6546d6f44a0	b65ad095-d3d3-4281-9765-0c724afba7af	2019-07-26 00:00:00	14.3	f	\N	0	f
78711b5a-7fd1-4d3c-83b0-b46ceb3bf5b0	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-05-17 00:00:00	100.86	f	\N	0	f
9f994e76-80db-4105-8576-6910c2674852	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-08-02 00:00:00	141.71	f	\N	0	f
2192ddba-8d11-4c23-8cd8-65db720ac620	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-05-24 00:00:00	102.67	f	\N	0	f
84662caf-acb4-48cb-ac66-4e3e37ed7744	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-07-05 00:00:00	71.4	f	\N	0	f
1a4800ff-569d-4308-a14c-ecd182799e3c	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-08-23 00:00:00	44.65	f	\N	0	f
6f14bf11-db56-40af-b499-3209a9ca864f	08976987-dd81-414e-9789-4ab9d173a238	2019-08-16 00:00:00	28.28	f	\N	0	f
0f4a7eff-393f-425c-af5e-eddeb55976ff	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-08-16 00:00:00	9.650	f	\N	0	f
3616644b-c00f-4125-a42f-d82b35fa146b	5aef4508-b970-4a28-bd12-1b19015f584f	2019-08-23 00:00:00	356.01	t	La fuerte revalorización de los títulos de Boeing, que han sumado un 4,5% al cierre hasta rozar los 355 dólares gracias a una buena recomendación de un analista, que asegura que la Administración Federal de Aviación dará el ok a la compañía para volver a poner en marcha el 737 MAX en cuatro o seis semanas.	0	f
b4f70fc7-4c6a-4faa-ae65-5c42292d593d	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-08-23 00:00:00	80.44	f	\N	0	f
0fd10e1b-e16b-4690-afc9-7ca402329164	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-08-16 00:00:00	0.461	f	\N	0	f
75da4928-41db-4432-95f0-d477ec80411e	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-09-06 00:00:00	88.69	f	\N	0	f
a1d7233a-5d70-411e-ab57-8848951aebb0	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-02-01 00:00:00	48.73	f	\N	0	t
ba8c741d-3812-44eb-887c-499af31878e3	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-02-08 00:00:00	48.84	f	\N	0	t
c8bddebb-5955-4aba-a999-853c7d7310d6	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	2019-08-07 00:00:00	39.2056	t	Ayer, la sacudida de los mercados provocó otro repunte en los precios del metal precioso para conducirlo por primera vez desde abril de 2013 por encima de los 1.500 dólares por onza.\nEl oro ha sido el principal ganador de las tensiones comerciales y el resto de focos de incertidumbre que traen de cabeza a los inversores. Frente al comportamiento plano o negativo de las principales bolsas, el rey de los activos refugio se ha revalorizado en 2019 un 17,46%, su mejor año desde 2010.\n	0	f
e0d13fc1-d49e-450e-b084-1d9363e80340	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-09-13 00:00:00	9.400	f	\N	0	f
1a09bafd-3083-4266-8f43-c88072edcfe1	ceff2d74-1923-4f0c-ac4a-c6041c51e915	2019-04-05 00:00:00	10.907	f	\N	0	f
2272f632-8e52-44eb-a547-d00b18e229af	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-02-22 00:00:00	1631.56	f	\N	0	f
baad52df-ed6b-44ef-b679-79cb404ce38c	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-04-12 00:00:00	47.69	f	\N	0	f
7745ecd9-ca31-488d-9ac6-bcacea97aa84	3854af87-a18e-4509-be17-6145a85578b6	2019-03-08 00:00:00	120.7	f	\N	0	f
eb6fa8b8-ab1a-4d92-a7fd-e6a99ff21f56	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-02-08 00:00:00	82.36	f	\N	0	t
455d43e5-d071-4afd-8544-0cc2a86dfd9b	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-02-01 00:00:00	93.86	f	\N	0	t
fba13ec7-d4c5-4b87-aca8-8ed951c99184	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-04-05 00:00:00	0.62	f	\N	0	f
c9eb8100-ac0e-46c7-ab84-43e6d9014c9d	3854af87-a18e-4509-be17-6145a85578b6	2019-03-15 00:00:00	122.32	f	\N	0	f
d003bab9-87d0-4881-b74f-67dd667308e2	f49439a8-0dea-4da8-99fb-48228f297c3a	2019-06-07 00:00:00	2.15	t	Compra de acciones en la Bolsa de New York por parte Artisan Partners, Newfoundland Capital, Renaissance Technologies y Karp Capital también adquirieron nuevas participaciones en la constructora peruana. El mismo día se revela pago de sobornos relacionadas al "Club de Construcción".	0	f
d2b0b523-07fb-43ca-b9a1-e9bc738bef38	f3579400-2263-474d-92b8-b03e2c434915	2019-10-04 00:00:00	29.01	f	\N	0	f
1eb4568e-b10d-49f9-ae3a-4aecaa634f17	110c6254-9596-4e36-a939-8f7a2d557a35	2019-04-19 00:00:00	178.28	f	\N	0	f
4021b969-7410-4409-b130-decf15ea3fc9	3854af87-a18e-4509-be17-6145a85578b6	2019-03-29 00:00:00	125.09	f	\N	0	f
be9994b6-2105-467f-9a53-672542caae0f	f3579400-2263-474d-92b8-b03e2c434915	2019-05-31 00:00:00	27.41	f	\N	0	f
62e4b7a5-7716-4d78-9ba6-9f2b1c4b1b99	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-05-17 00:00:00	354.45	f	\N	0	f
f3e7a535-95d5-4066-a3d1-bd0b421209b0	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-05-31 00:00:00	77.14	t	La guerra comercial entre Estados Unidos y China vuelve a generar incertidumbre en los mercados. Hay mucho en juego, ya que el rápido crecimiento del mercado de consumo de China es una prioridad para los gigantes de Estados Unidos que buscan crecer en una economía global en desaceleración. China es un mercado cada vez más importante para Nike, que patrocina la Maratón de Shanghai y la mejor liga de fútbol china. En el trimestre finalizado en febrero, los ingresos de Nike en China aumentaron 24%, el 19º trimestre consecutivo de ganancias de dos dígitos.	0	f
9665f23d-8e53-462c-af26-b0017cdfa42a	3854af87-a18e-4509-be17-6145a85578b6	2019-05-10 00:00:00	131.71	f	\N	0	f
d52d8e47-66e4-49d6-b29a-55fe69063607	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-05-31 00:00:00	0.48	f	\N	0	f
a3eecfcc-52d0-4575-afe2-497483bd893a	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-05-24 00:00:00	354.39	f	\N	0	f
a6afb3ed-a797-443c-9b70-d90cff3e3049	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-06-21 00:00:00	47.46	f	\N	0	f
cf596cb7-af6b-4b17-92ea-1c337cd7ca7e	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-06-04 00:00:00	0.465	f	\N	0	f
4dd0f906-2290-4a87-a63c-9d70b26b8908	3854af87-a18e-4509-be17-6145a85578b6	2019-05-17 00:00:00	130.91	f	\N	0	f
3b511cd3-7ed8-44c8-a83b-4ba6e2ded57e	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-06-28 00:00:00	70.03	f	\N	0	f
352c96a8-6ef1-461e-b92e-a559696dd59e	fc7d7181-cbed-48b6-8c51-8ddc427058cf	2019-07-05 00:00:00	48.08	f	\N	0	f
494ae5c4-34cc-4047-9413-a7b9b9f2e0a6	8b028276-f7fb-43af-b48e-8b57a1e73fef	2019-08-05 00:00:00	78.97	t	Boca, equipo deportivo argentino, rompetá contrato con Nike después de 24 años a partir de enero del 2020 y pasará a vestir a sus jugadores con Adidas.	0	f
f8c8338f-b14d-46af-a4b5-ba0190eef7c4	08976987-dd81-414e-9789-4ab9d173a238	2019-09-04 00:00:00	30.95	t	Las tensiones por la guerra comercial entre Estados Unidos y China y preocupan a los inversores. Recientemente se publicó un informe con datos que muestran una contracción sorpresa en el sector manufacturero de EE.UU.  Los compradores de acciones buscan refugiarse en activos más seguros como el oro. 	0	f
db065ab2-102a-48a1-8303-57a1ddb9d10c	3854af87-a18e-4509-be17-6145a85578b6	2019-09-13 00:00:00	133.99	f	\N	0	f
1bcf2f63-e27c-49fb-b472-5204cc4942ac	b65ad095-d3d3-4281-9765-0c724afba7af	2019-05-31 00:00:00	12.4	f	\N	0	f
3da8d8e2-0964-494f-9cff-c5e5dcbae7fd	08976987-dd81-414e-9789-4ab9d173a238	2019-05-31 00:00:00	21.59	f	\N	0	f
e1fb1bfe-d265-4742-aa80-452b8643d896	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-05-31 00:00:00	131.15	t	Johnson & Johnson, condenado a pagar 325 millones de dólares a una mujer con cáncer por sus polvos de talco.	0	f
7b28699e-128a-427d-a10c-a354394ed845	3854af87-a18e-4509-be17-6145a85578b6	2019-05-24 00:00:00	125	f	\N	0	f
11efb376-5861-4b11-a55f-0085d05c4abb	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-06-28 00:00:00	139.28	f	\N	0	f
c0831f06-cf61-405a-bc59-fb0a7b8d8e47	110c6254-9596-4e36-a939-8f7a2d557a35	2019-01-18 00:00:00	150.04	f	\N	0	t
d5274c28-35ad-4436-b92d-4a1de058d610	4a4061ee-3175-477f-b598-7104ed81818e	2019-03-15 00:00:00	275.43	f	\N	0	t
72bdafed-c91e-4ed8-9457-e7298bf9e6b7	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-03-22 00:00:00	5.236	f	\N	0	t
3cafaab4-7b84-4f3f-a298-e02eaa2202d7	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-05-03 00:00:00	70.67	f	\N	0	f
b73d3518-ca29-431c-a769-0fdeca98c826	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-04-19 00:00:00	360.35	f	\N	0	f
1f5fcef3-4757-4255-bb52-31231c38e854	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	2019-05-10 00:00:00	67.9	f	\N	0	f
515d0010-0a86-401f-ba9b-6d37bad1f8ea	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-09-06 00:00:00	114.73	f	\N	0	f
0a830199-7bba-42b0-983e-8a66e81c9cfa	08976987-dd81-414e-9789-4ab9d173a238	2019-09-13 00:00:00	26.64	f	\N	0	f
71778959-142b-499d-8d41-dd0a68cfa9de	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-05-23 00:00:00	37.21	t	Ambarella perdió casi una cuarta parte de su valor en los últimos 12 meses debido a las preocupaciones sobre sus ventas de caída, los márgenes de contratación y la competencia de los más grandes. Fabricantes de chips. La decisión de la administración Trump de prohibir el uso de cámaras de seguridad de Hikvision y Dahua, dos de los principales clientes de Ambarella, exacerbó el dolor el año pasado.	0	f
f7724cd2-e1b8-4e45-aedc-b058ac793f3b	08976987-dd81-414e-9789-4ab9d173a238	2019-05-17 00:00:00	20.75	f	\N	0	f
a9adc01f-535c-4082-964e-3877b8d42d0e	f3579400-2263-474d-92b8-b03e2c434915	2019-05-24 00:00:00	26.44	f	\N	0	f
dae51bed-4753-451d-9015-7b3288ec4cd1	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-04-12 00:00:00	1843.06	f	\N	0	f
930b60df-5c9f-4871-be93-f950de2c46e5	5f6b531e-1aba-48c2-a03d-85e06ae97f55	2019-05-10 00:00:00	1889.98	f	\N	0	f
f720a158-55a3-47d4-b7bc-b79713d0ee63	c5825b70-4e7a-4d5d-b558-e7f4f355d157	2019-06-14 00:00:00	109.07	f	\N	0	f
6739c0ae-9dc9-4c50-b43a-109f9fccb8db	92b65539-4cb1-4c64-986f-bf6b083a67a8	2019-07-12 00:00:00	2.27	f	\N	0	f
517fb89d-f847-4589-8e50-aea6d520c66b	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-07-05 00:00:00	2.40	f	\N	0	f
f9e553a5-e779-4762-9ec9-2cdd03501035	07618a28-45f0-4f9a-bf47-7e55e517ce21	2019-06-21 00:00:00	369.21	f	\N	0	f
7188503b-7aa2-4beb-8a0b-71eff7c62fcf	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	2019-07-12 00:00:00	134.3	t	El Departamento de Justicia de Estados Unidos adelantará una investigación criminal sobre si Johnson & Johnson mintió al público sobre los posibles riesgos de cáncer de su talco en polvo.	0	f
be91b40a-6b16-42a4-b379-2bc313e2c128	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	2019-08-05 00:00:00	45.32	t	Inversionistas de Wall Street sienten incertidumbre ante las crecientes tensiones comerciales entre China y Estados Unidos. El viernes pasado Donald Trump amenazó al gigante asiático con la posibilidad de la imposición de nuevos aranceles a productos chinos por 300,000 millones de dólares. Esta noticia afecta sobretodo a la industria tecnológica, quien mantiene relaciones continuas con el continente asiático.	0	f
d3409b3f-0e94-421f-ad16-9853bb4a6e46	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	2019-05-24 00:00:00	132.79	f	\N	0	f
acec75e4-0b1b-4d05-9093-2bb30d149e4c	c2db4b85-9098-4110-9761-fbd6a846707c	2019-05-24 00:00:00	41.95	f	\N	0	f
522b41e9-4657-46d6-94e0-38c27ada484b	5177b729-77ec-41a2-8bd7-9ffd611e4c57	2019-05-15 00:00:00	0.51	f	\N	0	f
ed6a8bb7-5020-4abf-9d63-c6d3920c1142	e68b3b18-5c45-4290-988c-92105ccdeb0d	2019-06-07 00:00:00	5.27	f	\N	0	f
7e002c55-9c16-4f89-a0bb-d6b897b9a218	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2019-05-31 00:00:00	2.48	f	\N	0	f
\.


--
-- Data for Name: holdings; Type: TABLE DATA; Schema: public; Owner: gustavo
--

COPY public.holdings (stock_uuid, user_uuid, quantity) FROM stdin;
\.


--
-- Data for Name: params; Type: TABLE DATA; Schema: public; Owner: gustavo
--

COPY public.params (uuid, name, type, value) FROM stdin;
844cc7b8-5f70-4bf4-95d6-7a122fdb38d5	exchange_rate	decimal	3.35
9bbfedc0-5c25-4c4b-bafb-e1aeb02fc844	comission	decimal	0.008
6151b3d7-8a1a-4447-bc01-7e68d4c26322	status	string	UNSTARTED
\.


--
-- Data for Name: stock_price; Type: TABLE DATA; Schema: public; Owner: gustavo
--

COPY public.stock_price (uuid, stock_uuid, close_price, "timestamp", change_price, change_percent) FROM stdin;
d7e4e2b1-f0e8-442a-b44c-5b5d2e786640	5aef4508-b970-4a28-bd12-1b19015f584f	327.08	2019-01-04 00:00:00	0.0	0.0
be036ef3-248f-44af-a353-c69da88d29aa	e68b3b18-5c45-4290-988c-92105ccdeb0d	5.039	2019-01-04 00:00:00	0.0	0.0
08b78276-eaa0-4e49-af50-0d46672bc847	8b028276-f7fb-43af-b48e-8b57a1e73fef	74.65	2019-01-04 00:00:00	0.0	0.0
75b33ab7-446e-4b8f-84e4-1f0a12889ef0	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	109.61	2019-01-04 00:00:00	0.0	0.0
48e056bb-4419-489e-9747-53695ddba722	c5825b70-4e7a-4d5d-b558-e7f4f355d157	92.13	2018-12-28 00:00:00	0.0	0.0
5b983b43-1357-4994-b9e4-3285d9bd3980	5177b729-77ec-41a2-8bd7-9ffd611e4c57	0.71	2018-12-28 00:00:00	0.0	0.0
1dbb10c0-c878-457e-aabf-3c2398dae7d5	f3579400-2263-474d-92b8-b03e2c434915	17.82	2018-12-28 00:00:00	0.0	0.0
020b25cd-f7c4-4039-8a6e-b20288fe43cc	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	127.83	2019-01-04 00:00:00	0.0	0.0
82f97b0e-f0a8-40b3-ba14-aa6164ed6fe5	ceff2d74-1923-4f0c-ac4a-c6041c51e915	9.782	2019-01-04 00:00:00	0.0	0.0
54c6418b-2b66-4869-bfc0-b5c7f978bc58	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	31.7128	2018-12-19 00:00:00	0.0	0.0
7474c6e2-77ac-4b6f-9bd8-ffbd8561f340	07618a28-45f0-4f9a-bf47-7e55e517ce21	276.02	2018-12-13 00:00:00	0.0	0.0
782ec5fc-87ce-4820-acd8-b73c3ea4f18e	3854af87-a18e-4509-be17-6145a85578b6	111.25	2018-12-07 00:00:00	0.0	0.0
7a7f0f62-baff-4b6e-9407-8102da853204	92b65539-4cb1-4c64-986f-bf6b083a67a8	2.28	2019-01-04 00:00:00	0.0	0.0
9469a3d0-44f1-40bc-aec5-1a34234a3e28	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	36.11	2019-01-04 00:00:00	0.0	0.0
fb325f5b-2c29-48cc-9f4c-38d6ee600002	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	65.16	2018-12-03 00:00:00	0.0	0.0
5d9bcd05-9b2c-412e-bff1-6039faf96ff0	f49439a8-0dea-4da8-99fb-48228f297c3a	1.80	2019-01-04 00:00:00	0.0	0.0
cd52de9b-690b-4cd0-a2ee-a4c2fc62706e	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2.58	2019-01-04 00:00:00	0.0	0.0
e071ed07-1eb0-4669-bea1-a122b54edcf5	c2db4b85-9098-4110-9761-fbd6a846707c	43	2019-01-04 00:00:00	0.0	0.0
263c175b-8f02-4afb-94bf-bed1397ea861	fc7d7181-cbed-48b6-8c51-8ddc427058cf	47.22	2019-01-04 00:00:00	0.0	0.0
e7bd7d64-bc78-4f35-8533-118122cdb3d9	b65ad095-d3d3-4281-9765-0c724afba7af	10.95	2018-12-28 00:00:00	0.0	0.0
0bd0ea37-58c5-427a-a291-7770f1c9e73f	4a4061ee-3175-477f-b598-7104ed81818e	300.36	2019-01-03 00:00:00	0.0	0.0
021d5e15-852c-41c3-b90f-352335042b9e	110c6254-9596-4e36-a939-8f7a2d557a35	124.95	2018-12-21 00:00:00	0.0	0.0
ddd11f6e-a35a-4921-a7ce-18e4028b2242	5f6b531e-1aba-48c2-a03d-85e06ae97f55	1690.17	2018-11-30 00:00:00	0.0	0.0
dd609a9b-bb7c-43da-b740-a33ed5c8326b	08976987-dd81-414e-9789-4ab9d173a238	20.6	2018-12-28 00:00:00	0.0	0.0
aa0e3ea2-f8e5-40d6-969a-3b135e8ee397	467304cf-f8f5-43bd-ba30-6498f8f84d80	154.3795	2018-12-28 00:00:00	0.0	0.0
488c9860-2140-4b0b-a565-db57875f277a	5f6b531e-1aba-48c2-a03d-85e06ae97f55	1690.17	2019-10-24 23:11:55	0.00	0.00
63158805-271c-47b2-ae23-e4f21afcc1d4	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	65.16	2019-10-24 23:11:55	0.00	0.00
b50d63cc-fab3-4c75-9423-ed5482f058bc	3854af87-a18e-4509-be17-6145a85578b6	111.25	2019-10-24 23:11:55	0.00	0.00
655c0f2a-bf2c-4c71-b1db-4baf11c4553d	07618a28-45f0-4f9a-bf47-7e55e517ce21	276.02	2019-10-24 23:11:55	0.00	0.00
604d597a-6850-4a84-8689-56cb15cc9bad	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	31.71	2019-10-24 23:11:55	0.00	0.00
2f3b3c04-455b-40f6-884c-0159f0b02f99	110c6254-9596-4e36-a939-8f7a2d557a35	124.95	2019-10-24 23:11:55	0.00	0.00
8f0a2269-e246-40f6-a2d1-00a6cb37eea4	b65ad095-d3d3-4281-9765-0c724afba7af	10.95	2019-10-24 23:11:55	0.00	0.00
e3a6e794-ea74-47d7-99cf-abce9ebb2734	f3579400-2263-474d-92b8-b03e2c434915	17.82	2019-10-24 23:11:55	0.00	0.00
078f9b7c-6277-4f7e-8caa-09e155b325d1	5177b729-77ec-41a2-8bd7-9ffd611e4c57	0.71	2019-10-24 23:11:55	0.00	0.00
ab3a4da8-6009-4ede-8bdf-d67e45da952a	c5825b70-4e7a-4d5d-b558-e7f4f355d157	92.13	2019-10-24 23:11:55	0.00	0.00
4405e010-53c4-4d91-a35b-30bc57b84653	467304cf-f8f5-43bd-ba30-6498f8f84d80	154.38	2019-10-24 23:11:55	0.00	0.00
26637c8c-9b9b-4e8f-966e-7bd7b8b394ea	08976987-dd81-414e-9789-4ab9d173a238	20.60	2019-10-24 23:11:55	0.00	0.00
9694186d-e6ae-492f-8b59-f87ebae1ed79	4a4061ee-3175-477f-b598-7104ed81818e	300.36	2019-10-24 23:11:55	0.00	0.00
dba92772-e265-45e9-83e2-d1763b9661cf	fc7d7181-cbed-48b6-8c51-8ddc427058cf	47.22	2019-10-24 23:11:55	0.00	0.00
ac1e8f7d-cff2-4114-9547-e89c5ab187bb	92b65539-4cb1-4c64-986f-bf6b083a67a8	2.28	2019-10-24 23:11:55	0.00	0.00
5cbda52e-8edd-4218-baa2-93f9c9c0d7d0	e68b3b18-5c45-4290-988c-92105ccdeb0d	5.04	2019-10-24 23:11:55	0.00	0.00
06911bdc-96a9-4d0a-b51b-bb97eebced53	ceff2d74-1923-4f0c-ac4a-c6041c51e915	9.78	2019-10-24 23:11:55	0.00	0.00
e580d8e1-a770-4672-af25-e9955e745c5c	5aef4508-b970-4a28-bd12-1b19015f584f	327.08	2019-10-24 23:11:55	0.00	0.00
3fe9af81-e1d8-4c05-8fd9-0c0aaf2ecd13	f49439a8-0dea-4da8-99fb-48228f297c3a	1.80	2019-10-24 23:11:55	0.00	0.00
719408d3-2fbb-4ca6-b333-9d8fcfdc271c	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	127.83	2019-10-24 23:11:55	0.00	0.00
d7a3516d-4d5c-459a-8de1-a6bdaedd06df	8b028276-f7fb-43af-b48e-8b57a1e73fef	74.65	2019-10-24 23:11:55	0.00	0.00
9bb80bc3-1589-49de-87d6-bc04d8b076b9	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2.58	2019-10-24 23:11:55	0.00	0.00
c50c2ed6-6428-4e6a-818e-23b5e30dd27b	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	109.61	2019-10-24 23:11:55	0.00	0.00
792c3dd4-1508-4f60-968a-ffaa846622e6	c2db4b85-9098-4110-9761-fbd6a846707c	43.00	2019-10-24 23:11:55	0.00	0.00
f946ff81-9691-4a19-b91a-8e33d0bab6a4	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	36.11	2019-10-24 23:11:55	0.00	0.00
790bd476-5134-40a9-921f-67d8307cc63a	3854af87-a18e-4509-be17-6145a85578b6	107.66	2019-10-24 23:11:58	-3.59	-3.33
0b8c7eb6-e1a7-45dc-8f7d-fb94284903be	b65ad095-d3d3-4281-9765-0c724afba7af	10.94	2019-10-24 23:11:58	-0.01	-0.09
d0277ee9-3008-470e-b188-a40a9739703b	08976987-dd81-414e-9789-4ab9d173a238	21.30	2019-10-24 23:11:58	0.70	3.29
717eaef4-03f5-41fb-a046-0a6ef3683275	5177b729-77ec-41a2-8bd7-9ffd611e4c57	0.69	2019-10-24 23:11:58	-0.02	-2.90
a00d6e8a-403e-44e5-ae62-e9a36647fd3b	c5825b70-4e7a-4d5d-b558-e7f4f355d157	93.44	2019-10-24 23:11:58	1.31	1.40
9ec48def-a2ad-4862-8e54-22bb6eca8100	f3579400-2263-474d-92b8-b03e2c434915	19.00	2019-10-24 23:11:58	1.18	6.21
11ea6aa0-0df2-4fc0-aa2a-42a5cb11b2d2	c2db4b85-9098-4110-9761-fbd6a846707c	42.88	2019-10-24 23:11:58	-0.12	-0.28
0351fb24-b076-41d5-bff8-8cd817a07906	92b65539-4cb1-4c64-986f-bf6b083a67a8	2.41	2019-10-24 23:11:58	0.13	5.51
52864cde-d217-4632-a49c-eeca6391829c	8b028276-f7fb-43af-b48e-8b57a1e73fef	76.04	2019-10-24 23:11:58	1.39	1.83
67c6057d-d52c-42c9-ae80-e066fd76b760	e68b3b18-5c45-4290-988c-92105ccdeb0d	5.05	2019-10-24 23:11:58	0.01	0.14
3330a9c9-e8c4-4ea8-b470-33da58385944	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	37.85	2019-10-24 23:11:58	1.74	4.60
4e8edaf2-7645-43aa-a213-ff74401a1e12	fc7d7181-cbed-48b6-8c51-8ddc427058cf	48.93	2019-10-24 23:11:58	1.71	3.49
b3b703ce-a4eb-4e49-a48a-40f91a6e7674	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	112.65	2019-10-24 23:11:58	3.04	2.70
b1a3ac22-bb88-4448-8d6a-ae773753cc45	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	129.75	2019-10-24 23:11:58	1.92	1.48
b4402e26-bb19-4970-a558-87c4bde08f63	ceff2d74-1923-4f0c-ac4a-c6041c51e915	9.90	2019-10-24 23:11:58	0.12	1.20
cc7b6df1-9c35-4dc4-bfca-9d6a725c867a	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2.60	2019-10-24 23:11:58	0.02	0.77
58ad36da-1485-425f-9329-744aa90865a4	5f6b531e-1aba-48c2-a03d-85e06ae97f55	1772.36	2019-10-24 23:11:58	82.19	4.64
867446a4-5a3a-4acd-9211-e204b0eed9b4	07618a28-45f0-4f9a-bf47-7e55e517ce21	233.88	2019-10-24 23:11:58	-42.14	-18.02
4d4de314-23a6-46eb-b4f0-57c59b1a0eac	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	49.26	2019-10-24 23:11:58	-15.90	-32.28
236d71d7-d15a-47a4-8499-4a470daf52d2	110c6254-9596-4e36-a939-8f7a2d557a35	133.20	2019-10-24 23:11:58	8.25	6.19
b46105e1-9ce4-4dd1-90fe-fc4670023fca	467304cf-f8f5-43bd-ba30-6498f8f84d80	140.51	2019-10-24 23:11:58	-13.87	-9.87
a82759e6-40f8-4ee2-910f-4aa813f02636	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	34.47	2019-10-24 23:11:58	2.76	8.01
90846779-5ad2-414c-abab-b71481d8e178	f49439a8-0dea-4da8-99fb-48228f297c3a	2.05	2019-10-24 23:11:58	0.25	12.20
bf224d43-69df-4de3-a8f8-e4ad0aa02ab0	5aef4508-b970-4a28-bd12-1b19015f584f	352.90	2019-10-24 23:11:58	25.82	7.32
e5a33021-4c7e-43ff-8fc7-12e1ea650c75	4a4061ee-3175-477f-b598-7104ed81818e	347.31	2019-10-24 23:11:58	46.95	13.52
9b92b450-aff5-420a-9a09-2207250ffe5f	5f6b531e-1aba-48c2-a03d-85e06ae97f55	1591.91	2019-10-24 23:12:00	-180.45	-11.34
d266eccc-ad02-47e1-a23a-b850bbc25489	07618a28-45f0-4f9a-bf47-7e55e517ce21	256.08	2019-10-24 23:12:00	22.20	8.67
95ef1de6-b5ea-4d08-b643-b9a2d2efd8c3	3854af87-a18e-4509-be17-6145a85578b6	102.88	2019-10-24 23:12:00	-4.78	-4.65
8c5531fc-b441-4213-b30d-2dd4b340a246	110c6254-9596-4e36-a939-8f7a2d557a35	137.95	2019-10-24 23:12:00	4.75	3.44
3fd06c78-5aee-44fe-9a13-2df639833e38	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	55.13	2019-10-24 23:12:00	5.87	10.65
ca4f5974-3ce4-4591-9462-ace92c5f61ed	08976987-dd81-414e-9789-4ab9d173a238	21.08	2019-10-24 23:12:00	-0.22	-1.04
01f1f816-a24a-4300-bc1f-1c1244da2cd0	467304cf-f8f5-43bd-ba30-6498f8f84d80	150.49	2019-10-24 23:12:00	9.98	6.63
37abc7cc-440a-4b4d-b0d8-bb123106b40f	c5825b70-4e7a-4d5d-b558-e7f4f355d157	94.84	2019-10-24 23:12:00	1.40	1.48
46927704-af4f-45cf-b62d-95a2ec7a1cec	5177b729-77ec-41a2-8bd7-9ffd611e4c57	0.70	2019-10-24 23:12:00	0.01	1.43
b8420fa5-b3af-48aa-90b5-c997dc462aef	b65ad095-d3d3-4281-9765-0c724afba7af	10.90	2019-10-24 23:12:00	-0.04	-0.37
e6a45077-436f-4ec9-abf2-bdd0eed6f251	f3579400-2263-474d-92b8-b03e2c434915	20.27	2019-10-24 23:12:00	1.27	6.27
205529fa-d367-4d2b-80d2-5878c942dda4	c2db4b85-9098-4110-9761-fbd6a846707c	42.53	2019-10-24 23:12:00	-0.35	-0.82
37325a53-1465-444a-8aeb-2f8677e2173e	ceff2d74-1923-4f0c-ac4a-c6041c51e915	9.94	2019-10-24 23:12:00	0.04	0.38
281c95b4-61c6-4598-80a5-9333d31f9116	92b65539-4cb1-4c64-986f-bf6b083a67a8	2.38	2019-10-24 23:12:00	-0.04	-1.47
e596157b-18b1-4b1d-90f4-d03f9dc5c591	e68b3b18-5c45-4290-988c-92105ccdeb0d	4.99	2019-10-24 23:12:00	-0.06	-1.26
ace260e3-f907-414a-816d-504da99ce124	8b028276-f7fb-43af-b48e-8b57a1e73fef	80.45	2019-10-24 23:12:00	4.41	5.48
c7511701-d0dc-4aa3-b177-68a280b4ea16	fc7d7181-cbed-48b6-8c51-8ddc427058cf	49.19	2019-10-24 23:12:00	0.26	0.53
3fe4fa4d-4fc6-4763-9a29-628c4fa73fe5	f49439a8-0dea-4da8-99fb-48228f297c3a	2.00	2019-10-24 23:12:00	-0.05	-2.50
1cfcea01-e5ab-4b76-8913-bb68fe3a1240	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	31.40	2019-10-24 23:12:00	-3.07	-9.79
0aaa30ba-481d-48fd-80b8-a2d229dfcf60	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	130.69	2019-10-24 23:12:00	0.94	0.72
b4ea6d2b-9b25-4117-bd07-446305168793	5aef4508-b970-4a28-bd12-1b19015f584f	364.73	2019-10-24 23:12:00	11.83	3.24
1069daf9-0e26-4417-a721-7f5c2fd60627	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	111.04	2019-10-24 23:12:00	-1.61	-1.45
20a56be6-3cd6-48a4-8797-f6398846bcf1	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	36.33	2019-10-24 23:12:00	-1.52	-4.18
ec4bba9e-2276-439a-934a-524d212e83d6	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2.60	2019-10-24 23:12:00	0.00	0.00
f29c4f1a-db8f-4cab-b9bf-165f6a801f60	4a4061ee-3175-477f-b598-7104ed81818e	297.04	2019-10-24 23:12:00	-50.27	-16.92
b1d8d498-f222-4d37-bcfb-4e44fc56b1e2	07618a28-45f0-4f9a-bf47-7e55e517ce21	297.57	2019-10-24 23:12:01	41.49	13.94
b290bbac-6550-410a-9a81-c7416023dab2	5f6b531e-1aba-48c2-a03d-85e06ae97f55	1377.45	2019-10-24 23:12:01	-214.46	-15.57
9512e8f1-aced-4b9c-b1b9-d27c322cccf1	3854af87-a18e-4509-be17-6145a85578b6	107.24	2019-10-24 23:12:01	4.36	4.07
c1acd351-d798-4ea0-aa20-4a94c3a8e559	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	56.69	2019-10-24 23:12:01	1.56	2.75
943563db-b7d7-4804-97f6-1ee740b5aab8	110c6254-9596-4e36-a939-8f7a2d557a35	143.80	2019-10-24 23:12:01	5.85	4.07
e2482f93-c922-420f-a58c-7588135d17b0	08976987-dd81-414e-9789-4ab9d173a238	20.31	2019-10-24 23:12:01	-0.77	-3.79
adf9acde-d3b1-4b67-8833-ab07e400a351	5177b729-77ec-41a2-8bd7-9ffd611e4c57	0.74	2019-10-24 23:12:01	0.04	5.41
ae533db3-1397-4c59-af85-5803e210430c	b65ad095-d3d3-4281-9765-0c724afba7af	10.80	2019-10-24 23:12:01	-0.10	-0.93
76e7436d-a0dc-4275-99e3-5ce96193b3f6	467304cf-f8f5-43bd-ba30-6498f8f84d80	154.96	2019-10-24 23:12:01	4.47	2.89
076b9f07-1b0b-40b9-bc31-b822addb42e8	c5825b70-4e7a-4d5d-b558-e7f4f355d157	97.73	2019-10-24 23:12:01	2.89	2.96
e73246ff-2b99-4ce5-baaf-98e6dc96926b	92b65539-4cb1-4c64-986f-bf6b083a67a8	2.41	2019-10-24 23:12:01	0.03	1.37
dc326cdf-d90a-44f4-9949-a8e562446b0d	ceff2d74-1923-4f0c-ac4a-c6041c51e915	10.32	2019-10-24 23:12:01	0.38	3.68
643ec83e-7e37-48d8-adb4-1796283b9f89	e68b3b18-5c45-4290-988c-92105ccdeb0d	5.02	2019-10-24 23:12:01	0.03	0.64
805703c3-d212-40d1-b89c-c02b5bdb0484	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	128.23	2019-10-24 23:12:01	-2.46	-1.92
97305caf-0347-4312-9da5-72267e8a2bc7	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	111.09	2019-10-24 23:12:01	0.05	0.05
568c24ae-8de2-4925-bbd5-d540de6d8052	f49439a8-0dea-4da8-99fb-48228f297c3a	2.01	2019-10-24 23:12:01	0.01	0.50
185ccc84-4672-41e6-8787-7ac8220d09de	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	32.77	2019-10-24 23:12:01	1.37	4.18
6feb644d-1d2d-4fa3-a69b-bb5414076e8e	5aef4508-b970-4a28-bd12-1b19015f584f	364.20	2019-10-24 23:12:01	-0.53	-0.15
8ad0fa49-7748-4d90-af72-b7ebf9076acd	8b028276-f7fb-43af-b48e-8b57a1e73fef	80.61	2019-10-24 23:12:01	0.16	0.20
18c42635-6f5f-491c-bb57-e9e8c101505d	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	38.42	2019-10-24 23:12:01	2.09	5.44
2d374a89-c241-462f-a48c-05ff56792490	c2db4b85-9098-4110-9761-fbd6a846707c	40.64	2019-10-24 23:12:01	-1.89	-4.65
d34c8715-65ae-4de4-bbf9-99bb6eff0b47	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2.60	2019-10-24 23:12:01	0.00	0.00
f62f87ef-6530-4afe-87c8-7fdfd7187d7f	f3579400-2263-474d-92b8-b03e2c434915	19.25	2019-10-24 23:12:01	-1.02	-5.30
92cf296a-83a6-49f6-97c1-c8609603e177	4a4061ee-3175-477f-b598-7104ed81818e	312.21	2019-10-24 23:12:01	15.17	4.86
b814f77d-b8c3-4875-ac15-19029240cb1c	fc7d7181-cbed-48b6-8c51-8ddc427058cf	47.04	2019-10-24 23:12:01	-2.15	-4.57
9c96ed53-31f4-4bdf-a756-17247125ac9b	07618a28-45f0-4f9a-bf47-7e55e517ce21	337.59	2019-10-24 23:12:03	40.02	11.85
704760f2-4b73-4741-8bfe-ac7edbc18e1d	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	63.12	2019-10-24 23:12:03	6.43	10.19
0e2f30e8-37bf-4d31-8e86-fdddd72fa1ab	110c6254-9596-4e36-a939-8f7a2d557a35	150.04	2019-10-24 23:12:03	6.24	4.16
c5b610c5-9022-445a-87c9-9cca34103f8f	5177b729-77ec-41a2-8bd7-9ffd611e4c57	0.75	2019-10-24 23:12:03	0.01	1.33
a602fad6-d812-4196-b1cd-da91cb8dc5d2	467304cf-f8f5-43bd-ba30-6498f8f84d80	155.89	2019-10-24 23:12:03	0.93	0.60
39db61dc-23cd-40bb-b039-000187dc033d	c5825b70-4e7a-4d5d-b558-e7f4f355d157	96.94	2019-10-24 23:12:03	-0.79	-0.81
9bc6d224-2845-4e75-a733-c511d896c030	b65ad095-d3d3-4281-9765-0c724afba7af	10.80	2019-10-24 23:12:03	0.00	0.00
635d7c45-81c4-43dd-ac4c-0c87ed39b817	08976987-dd81-414e-9789-4ab9d173a238	21.18	2019-10-24 23:12:03	0.87	4.11
e22c5d7c-7895-405a-b60e-fd5d02dcd90f	fc7d7181-cbed-48b6-8c51-8ddc427058cf	48.73	2019-10-24 23:12:03	1.69	3.47
4a75cc9e-5b7e-4847-b3c8-a9bf2e7f9f89	f49439a8-0dea-4da8-99fb-48228f297c3a	2.00	2019-10-24 23:12:03	-0.01	-0.50
cab49047-8086-4f49-b0b7-9f8f96a78aa1	5aef4508-b970-4a28-bd12-1b19015f584f	387.43	2019-10-24 23:12:03	23.23	6.00
654e3ef4-0990-4d8a-b637-cadb919c33ba	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	33.44	2019-10-24 23:12:03	0.67	2.01
38e3e805-26d1-4928-b529-ff950b92d932	92b65539-4cb1-4c64-986f-bf6b083a67a8	2.45	2019-10-24 23:12:03	0.04	1.67
3b5c792c-41b8-4ac4-942c-b9c59770af84	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	111.30	2019-10-24 23:12:03	0.21	0.19
7c8767dd-8be1-4155-bc6b-b222510de1e7	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2.70	2019-10-24 23:12:03	0.10	3.70
474acc9e-6fe2-439c-84a3-d2bcdd553844	ceff2d74-1923-4f0c-ac4a-c6041c51e915	11.05	2019-10-24 23:12:03	0.73	6.63
d8332c38-e052-40bd-be69-1579692e0962	8b028276-f7fb-43af-b48e-8b57a1e73fef	81.51	2019-10-24 23:12:03	0.90	1.10
1701c385-3b0c-4597-a5f0-1af3988be2b2	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	38.17	2019-10-24 23:12:03	-0.25	-0.65
6bbe5bc3-5f61-43de-bca1-5e662844a83f	4a4061ee-3175-477f-b598-7104ed81818e	305.80	2019-10-24 23:12:03	-6.41	-2.10
6c5a6c3f-6d13-43c2-8575-9858ccffd287	5f6b531e-1aba-48c2-a03d-85e06ae97f55	1343.96	2019-10-24 23:12:03	-33.49	-2.49
d2f4093b-c9d5-45c9-9634-fbaac88ce940	3854af87-a18e-4509-be17-6145a85578b6	101.74	2019-10-24 23:12:03	-5.50	-5.41
842a95c6-92f0-49aa-9b93-303ad5ad2ef3	f3579400-2263-474d-92b8-b03e2c434915	24.41	2019-10-24 23:12:03	5.16	21.14
8d014800-9644-4ea3-8b79-d3d236b86193	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	134.20	2019-10-24 23:12:03	5.97	4.45
87cb0826-4486-4b35-b20a-5856f6edfe3f	c2db4b85-9098-4110-9761-fbd6a846707c	42.88	2019-10-24 23:12:03	2.24	5.22
aefe5f23-e1b8-4319-bccd-312294d98faa	e68b3b18-5c45-4290-988c-92105ccdeb0d	5.58	2019-10-24 23:12:03	0.56	10.02
c5ad4815-d9fb-48e5-ab35-e67d6c5b468d	5f6b531e-1aba-48c2-a03d-85e06ae97f55	1478.02	2019-10-24 23:12:05	134.06	9.07
ea417f27-8b30-429f-b731-bd0c4cf16a2e	3854af87-a18e-4509-be17-6145a85578b6	109.42	2019-10-24 23:12:05	7.68	7.02
c6c1f88b-7b26-4fb5-a4b1-1e804c19bfc1	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	64.02	2019-10-24 23:12:05	0.90	1.41
b4dd3efe-e907-476b-bece-9a3a8a2a398c	110c6254-9596-4e36-a939-8f7a2d557a35	165.71	2019-10-24 23:12:05	15.67	9.46
faeaff53-51f9-4b2d-9ee3-fc4704a174e0	467304cf-f8f5-43bd-ba30-6498f8f84d80	164.55	2019-10-24 23:12:05	8.66	5.26
09ce1c8c-b5e1-43ab-84c4-8b48755d65b8	b65ad095-d3d3-4281-9765-0c724afba7af	10.80	2019-10-24 23:12:05	0.00	0.00
2dd64e6c-cce4-4fe6-a60d-41316aac4f6c	08976987-dd81-414e-9789-4ab9d173a238	22.57	2019-10-24 23:12:05	1.39	6.16
5213dd32-9fb6-49b9-8bd8-0b5430cf1777	5177b729-77ec-41a2-8bd7-9ffd611e4c57	0.75	2019-10-24 23:12:05	0.00	0.00
bb4b1ae9-4df3-47c3-bbea-0a4e87669788	f3579400-2263-474d-92b8-b03e2c434915	24.51	2019-10-24 23:12:05	0.10	0.41
7cbd780e-2a72-4ec0-904a-08971c7e7db1	c5825b70-4e7a-4d5d-b558-e7f4f355d157	93.86	2019-10-24 23:12:05	-3.08	-3.28
7122d8ca-18bf-4be9-952e-c42a199a59d8	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	33.44	2019-10-24 23:12:05	0.00	0.01
5442ac0b-0eb6-492d-847c-eac6aa4f6e0e	5aef4508-b970-4a28-bd12-1b19015f584f	404.91	2019-10-24 23:12:05	17.48	4.32
8c7920ef-f333-4a03-a7f4-28e14e6ec4ed	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	111.51	2019-10-24 23:12:05	0.21	0.19
2f559b3a-faab-4f2c-b9fb-bc590b17a561	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	37.47	2019-10-24 23:12:05	-0.70	-1.87
2fd6bc14-23f9-4ad9-950e-cf60445dd65f	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2.73	2019-10-24 23:12:05	0.03	1.10
dc3bd172-3382-4bf8-837a-c7fc792a5cb0	92b65539-4cb1-4c64-986f-bf6b083a67a8	2.46	2019-10-24 23:12:05	0.01	0.45
c69a3c36-c51e-4160-91e7-238d3c521aa6	c2db4b85-9098-4110-9761-fbd6a846707c	42.23	2019-10-24 23:12:05	-0.65	-1.54
5c933bd6-98b4-4dd6-af2a-86ecf414a1d1	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	132.40	2019-10-24 23:12:05	-1.80	-1.36
9a87fc84-1023-4a43-93ab-349493fc2b31	8b028276-f7fb-43af-b48e-8b57a1e73fef	82.36	2019-10-24 23:12:05	0.85	1.03
5256119f-1bf4-46b7-820d-eeab64fb63a4	fc7d7181-cbed-48b6-8c51-8ddc427058cf	48.84	2019-10-24 23:12:05	0.11	0.23
2b66f665-7932-4bfe-9727-7cea1251fc9a	f49439a8-0dea-4da8-99fb-48228f297c3a	1.90	2019-10-24 23:12:05	-0.10	-5.26
c2c2baf3-eacf-47c4-a5d4-52a7aeeb34c4	4a4061ee-3175-477f-b598-7104ed81818e	307.88	2019-10-24 23:12:05	2.08	0.68
5d83f227-7b3f-418e-a977-0b77fd18e279	e68b3b18-5c45-4290-988c-92105ccdeb0d	5.15	2019-10-24 23:12:05	-0.43	-8.35
de02fc6b-db10-4d2d-affd-fea99e7825f9	07618a28-45f0-4f9a-bf47-7e55e517ce21	353.19	2019-10-24 23:12:05	15.60	4.42
440a6582-52e1-4a92-8efc-593fdc604ea9	ceff2d74-1923-4f0c-ac4a-c6041c51e915	11.21	2019-10-24 23:12:05	0.16	1.43
4892b7e0-6177-4282-8c79-3dc1e46ff4b5	5f6b531e-1aba-48c2-a03d-85e06ae97f55	1575.39	2019-10-24 23:12:06	97.37	6.18
0f9ea2a9-4e5e-419e-8b0b-0f369c876673	3854af87-a18e-4509-be17-6145a85578b6	109.05	2019-10-24 23:12:06	-0.37	-0.34
278c8a19-4252-4bea-8414-6c005155cf39	07618a28-45f0-4f9a-bf47-7e55e517ce21	338.05	2019-10-24 23:12:06	-15.14	-4.48
1ee92a8f-ec74-42d1-aff6-d9a38710bc04	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	63.67	2019-10-24 23:12:06	-0.35	-0.55
23b020dd-0217-4f08-befc-f552b16c6a61	c5825b70-4e7a-4d5d-b558-e7f4f355d157	95.58	2019-10-24 23:12:06	1.72	1.80
7663fc0d-5d3c-4bae-8c90-0ed1acba28eb	110c6254-9596-4e36-a939-8f7a2d557a35	167.33	2019-10-24 23:12:06	1.62	0.97
ea87ed52-51c0-4a3e-8c6a-86f46ff78e50	b65ad095-d3d3-4281-9765-0c724afba7af	11.00	2019-10-24 23:12:06	0.20	1.82
c3f33fb8-57fe-4fd7-8ad5-58bd6a316a55	08976987-dd81-414e-9789-4ab9d173a238	22.34	2019-10-24 23:12:06	-0.23	-1.03
81df1e03-c037-4d26-ac75-ae7989b55306	5177b729-77ec-41a2-8bd7-9ffd611e4c57	0.73	2019-10-24 23:12:06	-0.02	-2.74
1a5b0d26-3ca0-4a85-9498-be3ed4c5ced0	f3579400-2263-474d-92b8-b03e2c434915	23.05	2019-10-24 23:12:06	-1.46	-6.33
40d77a23-06cc-4780-b235-62f9d696577a	467304cf-f8f5-43bd-ba30-6498f8f84d80	169.11	2019-10-24 23:12:06	4.56	2.70
82d7d84e-b2ae-4446-90d4-2b0c31cf9a8d	ceff2d74-1923-4f0c-ac4a-c6041c51e915	11.10	2019-10-24 23:12:06	-0.11	-0.97
dd635a64-81f7-42b7-ad56-e2504c763eb4	f49439a8-0dea-4da8-99fb-48228f297c3a	1.86	2019-10-24 23:12:06	-0.04	-2.15
2827b6a2-66c1-48cb-88e8-8ac1f64e1d8b	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	32.85	2019-10-24 23:12:06	-0.59	-1.80
21fe673e-4d3a-4e81-be54-eec7537a9114	fc7d7181-cbed-48b6-8c51-8ddc427058cf	51.66	2019-10-24 23:12:06	2.82	5.46
4b676c17-c033-4611-88ca-4b70495caf46	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2.68	2019-10-24 23:12:06	-0.05	-1.87
787d4eb4-2f05-477e-b868-d42cd39a7d23	c2db4b85-9098-4110-9761-fbd6a846707c	42.40	2019-10-24 23:12:06	0.17	0.40
e2d876ca-8de0-47a1-8bbf-6eac6bca5510	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	136.38	2019-10-24 23:12:06	3.98	2.92
60cbb50e-5848-46cf-9aa5-2b432c792e05	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	39.53	2019-10-24 23:12:06	2.06	5.21
a2ce8289-76f7-4aaf-96ac-8f734d0e6701	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	112.59	2019-10-24 23:12:06	1.08	0.96
19c2a041-0866-46bd-8a4d-8767b788fbc4	8b028276-f7fb-43af-b48e-8b57a1e73fef	85.38	2019-10-24 23:12:06	3.02	3.54
ce5cb3ee-cb92-4c66-90bf-1b7b3d9735f8	5aef4508-b970-4a28-bd12-1b19015f584f	417.97	2019-10-24 23:12:06	13.06	3.12
076077ee-d173-45ac-ad85-834a6e92b736	4a4061ee-3175-477f-b598-7104ed81818e	294.71	2019-10-24 23:12:06	-13.17	-4.47
fbd5e5c9-8fd0-48e0-bbeb-c3cbc61f8594	e68b3b18-5c45-4290-988c-92105ccdeb0d	5.22	2019-10-24 23:12:06	0.07	1.32
a380bcd6-47d3-4bb5-9dd0-9e8886931727	92b65539-4cb1-4c64-986f-bf6b083a67a8	2.53	2019-10-24 23:12:06	0.07	2.65
050accf8-7a8c-4134-a8c3-3c4da64a3e43	5f6b531e-1aba-48c2-a03d-85e06ae97f55	1640.56	2019-10-24 23:15:00	65.17	3.97
0a65f5b9-6f22-4b4d-9d67-ce229d24a650	3854af87-a18e-4509-be17-6145a85578b6	109.85	2019-10-24 23:15:00	0.80	0.73
ac67e100-c679-4f6a-8b0a-d0689feed52e	07618a28-45f0-4f9a-bf47-7e55e517ce21	339.85	2019-10-24 23:15:00	1.80	0.53
c85d5b31-2401-48e8-b23b-2e73eb404e94	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	62.01	2019-10-24 23:15:00	-1.66	-2.68
7dc0909f-2731-4ef3-81c1-7023c1eb853c	5177b729-77ec-41a2-8bd7-9ffd611e4c57	0.72	2019-10-24 23:15:00	-0.01	-1.39
bff6da74-edb7-4e35-a5bf-96e0d78482fe	f3579400-2263-474d-92b8-b03e2c434915	23.68	2019-10-24 23:15:00	0.63	2.66
1d1a5bde-1236-422b-8b6a-747d55e96cc5	08976987-dd81-414e-9789-4ab9d173a238	22.43	2019-10-24 23:15:00	0.09	0.40
717aff66-76a0-4be1-b7a6-588c6bb62ea4	b65ad095-d3d3-4281-9765-0c724afba7af	11.25	2019-10-24 23:15:00	0.25	2.22
1767e48d-95a4-4f91-9118-0c984782562a	110c6254-9596-4e36-a939-8f7a2d557a35	162.50	2019-10-24 23:15:00	-4.83	-2.97
bb4c3c1c-defc-406c-bdb9-8b0339d5b3d8	467304cf-f8f5-43bd-ba30-6498f8f84d80	169.12	2019-10-24 23:15:00	0.01	0.01
ce83a517-0079-4bf9-9475-00bfed27b0bc	ceff2d74-1923-4f0c-ac4a-c6041c51e915	11.01	2019-10-24 23:15:00	-0.09	-0.78
25750cdc-7b95-4164-b876-187d19409b9a	fc7d7181-cbed-48b6-8c51-8ddc427058cf	52.49	2019-10-24 23:15:00	0.83	1.58
5053f1ac-2687-47f3-bcd8-29b156c899b1	8b028276-f7fb-43af-b48e-8b57a1e73fef	84.76	2019-10-24 23:15:00	-0.62	-0.73
1648aec3-509c-41ac-a322-2bc2bcb0e280	f49439a8-0dea-4da8-99fb-48228f297c3a	1.85	2019-10-24 23:15:00	-0.01	-0.54
925836a9-c8a3-4a08-8ab3-842c6b700e8b	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	36.05	2019-10-24 23:15:00	3.20	8.88
7ab45755-70f2-484c-8213-efdfb4925606	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	40.74	2019-10-24 23:15:00	1.21	2.97
1ae8b5a9-7d3f-4bfb-bb88-de97f1f72fba	5aef4508-b970-4a28-bd12-1b19015f584f	424.05	2019-10-24 23:15:00	6.08	1.43
e1655dd2-d40b-4261-9168-b71f9c85f1dd	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	136.60	2019-10-24 23:15:00	0.22	0.16
6fb2218f-cf38-41eb-bf20-e73897741adb	92b65539-4cb1-4c64-986f-bf6b083a67a8	2.43	2019-10-24 23:15:00	-0.10	-4.03
a1a5be45-6353-464f-a130-5cf0c14e0118	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2.66	2019-10-24 23:15:00	-0.02	-0.75
fb12cd64-f70c-49ae-9723-a14aa51a4f3a	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	115.25	2019-10-24 23:15:00	2.66	2.31
b0a6607b-8d90-4af6-9cef-ccf8bb8ece10	c2db4b85-9098-4110-9761-fbd6a846707c	42.96	2019-10-24 23:15:00	0.56	1.30
6c0bd383-9c9d-40ee-875b-bc0f66dca903	e68b3b18-5c45-4290-988c-92105ccdeb0d	5.15	2019-10-24 23:15:00	-0.07	-1.36
4ec6d3a9-3b53-4266-8efa-040574d9850b	4a4061ee-3175-477f-b598-7104ed81818e	284.14	2019-10-24 23:15:00	-10.57	-3.72
8e5a04c7-baca-4b23-a929-75fea7904a55	5f6b531e-1aba-48c2-a03d-85e06ae97f55	1696.20	2019-10-24 23:21:00	55.64	3.28
5ebd6e48-34b2-4a4c-8d1c-76c3294702a7	3854af87-a18e-4509-be17-6145a85578b6	114.57	2019-10-24 23:21:00	4.72	4.12
017f6134-6f3b-44b0-b733-0455b0c93321	07618a28-45f0-4f9a-bf47-7e55e517ce21	347.57	2019-10-24 23:21:00	7.72	2.22
3abaa065-9353-4bd4-9f3b-efa4c9483eaa	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	64.27	2019-10-24 23:21:00	2.26	3.52
325be8ce-2bd9-46b9-b167-322ab1a7d5c5	110c6254-9596-4e36-a939-8f7a2d557a35	161.89	2019-10-24 23:21:00	-0.61	-0.38
d9c6eac8-abf3-4e46-82c1-15d1c6bfe879	b65ad095-d3d3-4281-9765-0c724afba7af	11.10	2019-10-24 23:21:00	-0.15	-1.35
7c5d003d-ea22-4fa8-bd05-b217bbcad572	f3579400-2263-474d-92b8-b03e2c434915	24.36	2019-10-24 23:21:00	0.68	2.79
c47efa4f-89d9-4151-8b88-5f9e82481e48	08976987-dd81-414e-9789-4ab9d173a238	23.06	2019-10-24 23:21:00	0.63	2.73
c28eb2ee-ed9e-40a6-ba76-3ddea8f7bbb5	467304cf-f8f5-43bd-ba30-6498f8f84d80	171.65	2019-10-24 23:21:00	2.53	1.48
d5c9a9f6-4d56-46ef-87c2-912c6e8a437b	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	40.02	2019-10-24 23:21:00	-0.72	-1.80
5aca2eb6-43c7-4a37-a078-3f717b8b8ba3	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2.70	2019-10-24 23:21:00	0.04	1.48
50b8cb1c-0fe1-4fae-933b-7d3a09305218	8b028276-f7fb-43af-b48e-8b57a1e73fef	87.16	2019-10-24 23:21:00	2.40	2.75
8d636287-0f3d-4a58-8828-628b8199c8b0	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	33.42	2019-10-24 23:21:00	-2.63	-7.86
9d2de6db-93cf-4877-b147-9d6099782e4f	c2db4b85-9098-4110-9761-fbd6a846707c	43.36	2019-10-24 23:21:00	0.40	0.92
be15cfab-f7ea-4e6e-a6ab-a1b0edeb3902	f49439a8-0dea-4da8-99fb-48228f297c3a	1.93	2019-10-24 23:21:00	0.08	4.15
33e89e36-aa8f-4d2a-8857-fd5ebed3057d	ceff2d74-1923-4f0c-ac4a-c6041c51e915	11.05	2019-10-24 23:21:00	0.04	0.39
c5373602-a9f1-4743-91b7-3fe37b52a453	fc7d7181-cbed-48b6-8c51-8ddc427058cf	53.30	2019-10-24 23:21:00	0.81	1.52
0cfc704b-f847-43aa-9c15-c3dfaba0de7c	5aef4508-b970-4a28-bd12-1b19015f584f	440.62	2019-10-24 23:21:00	16.57	3.76
24e3ccfb-e843-4e96-84f8-a675d50ece28	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	138.35	2019-10-24 23:21:00	1.75	1.26
5533dd33-0602-4255-a1f3-f4765828c5de	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	114.01	2019-10-24 23:21:00	-1.24	-1.09
2285bd2f-b0dc-4ee8-b650-f0a9d40d3eb4	92b65539-4cb1-4c64-986f-bf6b083a67a8	2.36	2019-10-24 23:21:00	-0.07	-3.14
bb69e8a3-7c9d-4257-905f-a8fd5cbb7f7f	e68b3b18-5c45-4290-988c-92105ccdeb0d	5.06	2019-10-24 23:21:00	-0.09	-1.86
edc74f12-246e-499b-8440-4ff685ec40fc	4a4061ee-3175-477f-b598-7104ed81818e	275.43	2019-10-24 23:21:00	-8.71	-3.16
6bda6f40-8cc2-4268-86dc-f69bfdfff1f2	c5825b70-4e7a-4d5d-b558-e7f4f355d157	102.20	2019-10-24 23:21:00	6.62	6.48
b84a6945-879a-4a72-a58b-36d200155435	5177b729-77ec-41a2-8bd7-9ffd611e4c57	0.66	2019-10-24 23:21:00	-0.06	-9.09
55e84063-bf03-474e-9865-2509a2239646	5f6b531e-1aba-48c2-a03d-85e06ae97f55	1670.57	2019-10-24 23:24:00	-25.63	-1.53
f6a34594-43f5-48b0-ad6c-3c678524244e	3854af87-a18e-4509-be17-6145a85578b6	115.48	2019-10-24 23:24:00	0.91	0.79
f47257ec-d18a-44d8-a6ce-386e9913e53e	07618a28-45f0-4f9a-bf47-7e55e517ce21	356.87	2019-10-24 23:24:00	9.30	2.61
433c887e-7d1e-4b09-8a53-fc7c19fff6e3	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	64.14	2019-10-24 23:24:00	-0.13	-0.20
dd115a5c-c408-496c-b4d8-e8fc560eed32	c5825b70-4e7a-4d5d-b558-e7f4f355d157	99.55	2019-10-24 23:24:00	-2.65	-2.66
c639433c-9767-4988-9059-9a72f812116d	b65ad095-d3d3-4281-9765-0c724afba7af	12.10	2019-10-24 23:24:00	1.00	8.26
7ecf0fbb-db82-41af-b512-331ec0864192	467304cf-f8f5-43bd-ba30-6498f8f84d80	173.64	2019-10-24 23:24:00	1.99	1.15
08e83e81-7cf4-4ec3-ad51-ad8cb69df19d	5177b729-77ec-41a2-8bd7-9ffd611e4c57	0.67	2019-10-24 23:24:00	0.01	1.49
140a462d-d638-473b-a2f1-793d53c73340	08976987-dd81-414e-9789-4ab9d173a238	21.70	2019-10-24 23:24:00	-1.36	-6.27
14d3502f-72c8-4203-b5b8-7532355ec19f	110c6254-9596-4e36-a939-8f7a2d557a35	162.28	2019-10-24 23:24:00	0.39	0.24
1ebc39de-0f8e-4bd4-84e8-e45b2a837785	f3579400-2263-474d-92b8-b03e2c434915	23.68	2019-10-24 23:24:00	-0.68	-2.87
5aa43d7d-5d03-4014-9638-969f4fe67a1b	92b65539-4cb1-4c64-986f-bf6b083a67a8	2.32	2019-10-24 23:24:00	-0.04	-1.81
36f4cb01-2ff1-47a2-b3de-bc09f8f65bf1	8b028276-f7fb-43af-b48e-8b57a1e73fef	84.80	2019-10-24 23:24:00	-2.36	-2.78
b6079594-3978-4365-90da-d6e554039984	fc7d7181-cbed-48b6-8c51-8ddc427058cf	52.48	2019-10-24 23:24:00	-0.82	-1.56
129bea8f-69c1-47d7-bf15-71186fc29fe1	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	40.62	2019-10-24 23:24:00	0.60	1.48
dbe09964-93f8-4d4d-974b-dcfb68df42ff	f49439a8-0dea-4da8-99fb-48228f297c3a	2.06	2019-10-24 23:24:00	0.13	6.31
d558f9fb-37a0-4d78-ab48-d39c21687329	ceff2d74-1923-4f0c-ac4a-c6041c51e915	10.96	2019-10-24 23:24:00	-0.09	-0.86
4190336a-4393-4cd7-b100-768f1db73937	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	113.81	2019-10-24 23:24:00	-0.20	-0.18
d2e1e5cd-b5d6-4cd5-bfc9-eb7dd89feaff	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2.78	2019-10-24 23:24:00	0.08	2.88
71f9eef4-61d5-423c-abbc-93990a922298	5aef4508-b970-4a28-bd12-1b19015f584f	422.54	2019-10-24 23:24:00	-18.08	-4.28
7d12013f-3909-4878-979d-c1a51754f5ba	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	138.06	2019-10-24 23:24:00	-0.29	-0.21
af366d55-b5f6-45da-9f70-20e5cf8994a1	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	33.45	2019-10-24 23:24:00	0.03	0.09
2f932b8e-68ab-4dd4-9558-a1dbc0547c06	c2db4b85-9098-4110-9761-fbd6a846707c	40.89	2019-10-24 23:24:00	-2.47	-6.04
6d62ee16-348c-4490-b4ef-f563e1bc5682	e68b3b18-5c45-4290-988c-92105ccdeb0d	5.16	2019-10-24 23:24:00	0.10	1.92
23e5a10c-ca9b-47ba-b498-a6c414b3eccc	4a4061ee-3175-477f-b598-7104ed81818e	264.53	2019-10-24 23:24:00	-10.90	-4.12
4b7c1d8f-f0c6-4936-a908-4c33c070aa74	5f6b531e-1aba-48c2-a03d-85e06ae97f55	1626.23	2019-10-24 23:27:00	-44.34	-2.73
ff6a5af5-97dd-4a0c-b44f-2ce144ce7461	3854af87-a18e-4509-be17-6145a85578b6	121.05	2019-10-24 23:27:00	5.57	4.60
ead22203-cdca-4f64-9cfc-9016a3df8103	07618a28-45f0-4f9a-bf47-7e55e517ce21	363.02	2019-10-24 23:27:00	6.15	1.69
3f5f14d1-5540-409f-8a85-8bbebd907d9f	936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	64.47	2019-10-24 23:27:00	0.33	0.51
1ff9ddcd-cf3e-44f0-9e70-c1b664d2114b	c5825b70-4e7a-4d5d-b558-e7f4f355d157	97.93	2019-10-24 23:27:00	-1.62	-1.65
dbe93353-d212-429d-be85-6b6f7549a532	b65ad095-d3d3-4281-9765-0c724afba7af	12.30	2019-10-24 23:27:00	0.20	1.63
2b84d9cb-a0b7-4e38-8a12-ad6073430468	110c6254-9596-4e36-a939-8f7a2d557a35	169.60	2019-10-24 23:27:00	7.32	4.32
2acc20cb-f81e-4c9e-a25e-cc3e530556e7	f3579400-2263-474d-92b8-b03e2c434915	22.01	2019-10-24 23:27:00	-1.67	-7.59
5edb919f-0594-46f1-9585-40e7b97e3945	5177b729-77ec-41a2-8bd7-9ffd611e4c57	0.65	2019-10-24 23:27:00	-0.02	-3.08
456666d4-b594-4784-b507-8c8d97a6f02c	08976987-dd81-414e-9789-4ab9d173a238	22.37	2019-10-24 23:27:00	0.67	3.00
6e100316-022e-4e09-a5f8-b564d0b9c208	467304cf-f8f5-43bd-ba30-6498f8f84d80	171.59	2019-10-24 23:27:00	-2.05	-1.19
d4141a31-bc9b-4ff7-8789-818e5b0c46d3	11f668e0-e7f3-4fdd-8859-94c445dd7bdc	2.86	2019-10-24 23:27:00	0.08	2.80
8258c180-ab3d-4b77-ac66-71b28e58c7a6	ceff2d74-1923-4f0c-ac4a-c6041c51e915	10.95	2019-10-24 23:27:00	-0.01	-0.13
f17b6bd7-d47e-46bc-b51e-77256344c95c	4cccb10f-be02-4ff7-a3e4-7266392c3c9f	114.96	2019-10-24 23:27:00	1.15	1.00
538736b3-0a42-456f-8b44-e52950b50a10	c2db4b85-9098-4110-9761-fbd6a846707c	41.78	2019-10-24 23:27:00	0.89	2.13
8a7dbfda-038b-4f84-a81c-251210a6006d	92b65539-4cb1-4c64-986f-bf6b083a67a8	2.33	2019-10-24 23:27:00	0.01	0.34
cbea5b45-2019-4eee-8fcb-f2f007b95b74	fc7d7181-cbed-48b6-8c51-8ddc427058cf	54.33	2019-10-24 23:27:00	1.85	3.41
0d65c787-1e31-42ce-92e8-71274735c266	c6b2067b-d2d3-4c50-ab46-a2623cec6af6	137.60	2019-10-24 23:27:00	-0.46	-0.33
b2155653-9a6a-49d1-8d58-13453ed64b82	2cea0d31-d0f3-4d92-ad96-dcde3c04e762	32.88	2019-10-24 23:27:00	-0.57	-1.72
af2131a8-b64a-48b4-8211-4aaf9c879c6c	f49439a8-0dea-4da8-99fb-48228f297c3a	2.02	2019-10-24 23:27:00	-0.04	-1.98
6ea65a3f-6884-40e2-b35c-c89800d85f6e	5f1c3ff9-5582-4fa6-a78f-3f84d8967055	43.75	2019-10-24 23:27:00	3.13	7.15
99898331-30e8-48e1-80c4-7aaec132d67a	8b028276-f7fb-43af-b48e-8b57a1e73fef	86.80	2019-10-24 23:27:00	2.00	2.30
f51cd17f-7239-4623-b249-fc47eaceb729	e68b3b18-5c45-4290-988c-92105ccdeb0d	5.24	2019-10-24 23:27:00	0.08	1.45
7dfd4fbb-cae2-42a0-a373-0cfe32360857	4a4061ee-3175-477f-b598-7104ed81818e	279.86	2019-10-24 23:27:00	15.33	5.48
7e46c305-2a08-48bc-a028-4e20dc2b79dd	5aef4508-b970-4a28-bd12-1b19015f584f	378.99	2019-10-24 23:27:00	-43.55	-11.49
\.


--
-- Data for Name: stocks; Type: TABLE DATA; Schema: public; Owner: gustavo
--

COPY public.stocks (uuid, name, description, companyname, quantity, currency, companylogo) FROM stdin;
11f668e0-e7f3-4fdd-8859-94c445dd7bdc	UNACEMC1 PE		Unión Andina de Cementos	1000000	PEN	https://www.indsab.com.pe/wp-content/uploads/Unacem.jpg
2cea0d31-d0f3-4d92-ad96-dcde3c04e762	NEM US		Newmond Goldcorp	1000000	USD	https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Newmont_Goldcorp_Corporation_logo.svg/640px-Newmont_Goldcorp_Corporation_logo.svg.png
3854af87-a18e-4509-be17-6145a85578b6	MAR US		Marriot	1000000	USD	https://delos.com/wp-content/uploads/2018/12/marriott-logo-1.png
467304cf-f8f5-43bd-ba30-6498f8f84d80	AAPL US		Apple	1000000	USD	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHfyk8G_SN0iWKtJAcBY6rUiHc3oD5haaise1Dqnc3LG7En8E2
4cccb10f-be02-4ff7-a3e4-7266392c3c9f	DIS US		Disney	1000000	USD	https://1000logos.net/wp-content/uploads/2017/05/Walt-Disney-logo.png
5177b729-77ec-41a2-8bd7-9ffd611e4c57	VOLCABC1 PE		Volcan	1000000	PEN	http://www.totalperunegocios.com.pe/images/6.png
4a4061ee-3175-477f-b598-7104ed81818e	TSLA US		Tesla	1000000	USD	https://i.ya-webdesign.com/images/tesla-vector-silver-18.png
5aef4508-b970-4a28-bd12-1b19015f584f	BA US		Boeing	1000000	USD	https://www.boeing.ca/resources/images/boeing_logo.png
08976987-dd81-414e-9789-4ab9d173a238	GDX US		Vaneck Gold MSNR 	1000000	USD	https://www.asx.com.au/asx/1/image/logo/GDX?image_size=L&v=1523495343000
5f1c3ff9-5582-4fa6-a78f-3f84d8967055	AMBA US		Ambarella	1000000	USD	https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Ambarella_Logo.svg/1200px-Ambarella_Logo.svg.png
5f6b531e-1aba-48c2-a03d-85e06ae97f55	AMZN US		Amazon	1000000	USD	http://media.corporate-ir.net/media_files/IROL/17/176060/Oct18/Amazon%20logo.PNG
07618a28-45f0-4f9a-bf47-7e55e517ce21	NFLX US		Netflix	1000000	USD	https://www.userlogos.org/files/netflix-n-logo-png.png
8b028276-f7fb-43af-b48e-8b57a1e73fef	NKE US		Nike	1000000	USD	http://logok.org/wp-content/uploads/2014/03/Nike-logo-orange.png
110c6254-9596-4e36-a939-8f7a2d557a35	FB US		Facebook	1000000	USD	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZ_Ts0P4Sn-D6KLjiHamwL10HWoPqLq8eracEkh3d8Yd6P4AaC
92b65539-4cb1-4c64-986f-bf6b083a67a8	FERREYC1 PE		FerreyCorp	1000000	PEN	https://www.motored.com.pe/wp-content/uploads/2018/09/logo-05.png
936ca53d-a16f-4a55-bf77-5f3b41d7f7e8	C US		Citigroup	1000000	USD	https://purepng.com/public/uploads/large/purepng.com-citigroup-logologobrand-logoiconslogos-251519939758irpbp.png
b65ad095-d3d3-4281-9765-0c724afba7af	LUSURC1 PE		Luz del Sur	1000000	PEN	https://upload.wikimedia.org/wikipedia/en/thumb/9/9a/Luz_del_Sur.svg/1280px-Luz_del_Sur.svg.png
c2db4b85-9098-4110-9761-fbd6a846707c	PFE US		Pfizer	1000000	USD	https://seeklogo.com/images/P/pfizer-logo-BFB44C86FE-seeklogo.com.png
c5825b70-4e7a-4d5d-b558-e7f4f355d157	WMT US		Walmart	1000000	USD	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTumSv9JspA73eqypVh_L2SrnK9D7L_ktbD9-fwnkW1xjmqc4lsA
c6b2067b-d2d3-4c50-ab46-a2623cec6af6	JNJ US		Johnson & Johnson	1000000	USD	https://www.logolynx.com/images/logolynx/13/13b424984ae120a1e613846e5bd0744d.png
ceff2d74-1923-4f0c-ac4a-c6041c51e915	ALICORC1 PE		Alicorp	1000000	PEN	https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Alicorp.svg/640px-Alicorp.svg.png
e68b3b18-5c45-4290-988c-92105ccdeb0d	CREDITC1 PE		Banco de Crédito del Perú	1000000	PEN	https://vignette.wikia.nocookie.net/logopedia-peru/images/b/b4/1280px-BCP.svg.png/revision/latest?cb=20180930153701&path-prefix=es
f3579400-2263-474d-92b8-b03e2c434915	AMD US		Advanced Micro Devices	1000000	USD	http://developer.amd.com/wordpress/media/2013/12/53863A_AMD_E_Blk_RGB.png
f49439a8-0dea-4da8-99fb-48228f297c3a	GRAMONC1 PE		Graña y Montero	1000000	PEN	http://www.granaymontero.com.pe/resources/images/logos/logo.png
fc7d7181-cbed-48b6-8c51-8ddc427058cf	INTC US		Intel	1000000	USD	https://1000logos.net/wp-content/uploads/2017/02/Current-Intel-Symbol.png
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: gustavo
--

COPY public.transactions (uuid, status, stock_uuid, stock_price_uuid, user_uuid, created_at, updated_at, is_sell, is_buy, comission, quantity, comission_rate, total) FROM stdin;
a9fb211e-2d46-4643-9b0a-53a9a3cb9d7b	COMPLETED	467304cf-f8f5-43bd-ba30-6498f8f84d80	6e100316-022e-4e09-a5f8-b564d0b9c208	b85ec3a8-0353-4500-aaa6-5fa7cf10a0f4	2019-10-25 04:27:02.117715	2019-10-25 04:27:02.117715	f	t	168.84	123	0.008	21274.41
d192881c-fb99-49a2-98c6-e4a692fdffe8	COMPLETED	467304cf-f8f5-43bd-ba30-6498f8f84d80	6e100316-022e-4e09-a5f8-b564d0b9c208	b85ec3a8-0353-4500-aaa6-5fa7cf10a0f4	2019-10-25 04:27:11.714032	2019-10-25 04:27:11.714032	t	f	168.84	123	0.008	20936.73
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: gustavo
--

COPY public.users (uuid, username, password, admin, balance) FROM stdin;
ec690dab-8e92-4815-a032-4d514c3eda14	936701529	123456	f	28422.5
98ffbdad-feee-4430-bba3-0b15e2a7872e	980773168	123456	f	38335.3600000000006
d0b1d798-1e7a-4af4-8792-a53a416ae596	998784390	123456	f	50000
f5d5cc0e-75d7-4524-b02c-fd7541be72b3	986893555	123456	f	50000
0f85a791-f1f2-469b-8ea4-ffe46de207da	983443651	123456	f	47971.1500000000015
48839b04-0784-499b-9f74-3c519b236dba	945051654	123456	f	50000
149510b1-ab5d-407e-a275-d78772b1bd16	giovani	2573	f	50000
b85ec3a8-0353-4500-aaa6-5fa7cf10a0f4	anja	2573	f	9878777.72000000067
\.


--
-- Name: exchange_rate exchange_rate_pkey; Type: CONSTRAINT; Schema: public; Owner: gustavo
--

ALTER TABLE ONLY public.exchange_rate
    ADD CONSTRAINT exchange_rate_pkey PRIMARY KEY (uuid);


--
-- Name: params params_pkey; Type: CONSTRAINT; Schema: public; Owner: gustavo
--

ALTER TABLE ONLY public.params
    ADD CONSTRAINT params_pkey PRIMARY KEY (uuid);


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
-- Name: future_values future_values_stock_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gustavo
--

ALTER TABLE ONLY public.future_values
    ADD CONSTRAINT future_values_stock_uuid_fkey FOREIGN KEY (stock_uuid) REFERENCES public.stocks(uuid);


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

