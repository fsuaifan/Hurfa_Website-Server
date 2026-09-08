--
-- PostgreSQL database dump
--

\restrict 4dKlpNWAjlpT8lPfb55OLzCvbUCVnQcQHShgUw5DdoUGepI6SF7uWRxA0HIROTs

-- Dumped from database version 16.15 (Ubuntu 16.15-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.15 (Ubuntu 16.15-0ubuntu0.24.04.1)

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

ALTER TABLE IF EXISTS ONLY public.products DROP CONSTRAINT IF EXISTS products_category_id_fkey;
ALTER TABLE IF EXISTS ONLY public.products DROP CONSTRAINT IF EXISTS products_category_id2_fkey;
ALTER TABLE IF EXISTS ONLY public.kitchens DROP CONSTRAINT IF EXISTS kitchens_kitchentypeid_fkey;
ALTER TABLE IF EXISTS ONLY public.carts DROP CONSTRAINT IF EXISTS carts_user_email_fkey;
ALTER TABLE IF EXISTS ONLY public.carts DROP CONSTRAINT IF EXISTS carts_product_id_fkey;
DROP INDEX IF EXISTS public.idx_products_category_id2;
DROP INDEX IF EXISTS public.idx_products_category_id;
DROP INDEX IF EXISTS public.idx_kitchens_kitchentypeid;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_email_key;
ALTER TABLE IF EXISTS ONLY public.products DROP CONSTRAINT IF EXISTS products_pkey;
ALTER TABLE IF EXISTS ONLY public.premium_collection DROP CONSTRAINT IF EXISTS premium_collection_pkey;
ALTER TABLE IF EXISTS ONLY public.precollection DROP CONSTRAINT IF EXISTS precollection_pkey;
ALTER TABLE IF EXISTS ONLY public.orders DROP CONSTRAINT IF EXISTS orders_pkey;
ALTER TABLE IF EXISTS ONLY public.kitchentype DROP CONSTRAINT IF EXISTS kitchentype_pkey;
ALTER TABLE IF EXISTS ONLY public.kitchens DROP CONSTRAINT IF EXISTS kitchens_pkey;
ALTER TABLE IF EXISTS ONLY public.clients DROP CONSTRAINT IF EXISTS clients_pkey;
ALTER TABLE IF EXISTS ONLY public.clients DROP CONSTRAINT IF EXISTS clients_email_key;
ALTER TABLE IF EXISTS ONLY public.categories DROP CONSTRAINT IF EXISTS categories_pkey;
ALTER TABLE IF EXISTS ONLY public.categories DROP CONSTRAINT IF EXISTS categories_name_key;
ALTER TABLE IF EXISTS ONLY public.carts DROP CONSTRAINT IF EXISTS carts_pkey;
ALTER TABLE IF EXISTS ONLY public.bedrooms DROP CONSTRAINT IF EXISTS bedrooms_pkey;
ALTER TABLE IF EXISTS ONLY public.admin_users DROP CONSTRAINT IF EXISTS admin_users_username_key;
ALTER TABLE IF EXISTS ONLY public.admin_users DROP CONSTRAINT IF EXISTS admin_users_pkey;
ALTER TABLE IF EXISTS public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.products ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.premium_collection ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.precollection ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.orders ALTER COLUMN orderid DROP DEFAULT;
ALTER TABLE IF EXISTS public.kitchentype ALTER COLUMN kitchentypeid DROP DEFAULT;
ALTER TABLE IF EXISTS public.kitchens ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.clients ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.categories ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.carts ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.bedrooms ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.admin_users ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.users_id_seq;
DROP TABLE IF EXISTS public.users;
DROP SEQUENCE IF EXISTS public.products_id_seq;
DROP TABLE IF EXISTS public.products;
DROP SEQUENCE IF EXISTS public.premium_collection_id_seq;
DROP TABLE IF EXISTS public.premium_collection;
DROP SEQUENCE IF EXISTS public.precollection_id_seq;
DROP TABLE IF EXISTS public.precollection;
DROP SEQUENCE IF EXISTS public.orders_orderid_seq;
DROP TABLE IF EXISTS public.orders;
DROP SEQUENCE IF EXISTS public.kitchentype_kitchentypeid_seq;
DROP TABLE IF EXISTS public.kitchentype;
DROP SEQUENCE IF EXISTS public.kitchens_id_seq;
DROP TABLE IF EXISTS public.kitchens;
DROP SEQUENCE IF EXISTS public.clients_id_seq;
DROP TABLE IF EXISTS public.clients;
DROP SEQUENCE IF EXISTS public.categories_id_seq;
DROP TABLE IF EXISTS public.categories;
DROP SEQUENCE IF EXISTS public.carts_id_seq;
DROP TABLE IF EXISTS public.carts;
DROP SEQUENCE IF EXISTS public.bedrooms_id_seq;
DROP TABLE IF EXISTS public.bedrooms;
DROP SEQUENCE IF EXISTS public.admin_users_id_seq;
DROP TABLE IF EXISTS public.admin_users;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: fahdsuaifan
--

CREATE TABLE public.admin_users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.admin_users OWNER TO fahdsuaifan;

--
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: fahdsuaifan
--

CREATE SEQUENCE public.admin_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admin_users_id_seq OWNER TO fahdsuaifan;

--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fahdsuaifan
--

ALTER SEQUENCE public.admin_users_id_seq OWNED BY public.admin_users.id;


--
-- Name: bedrooms; Type: TABLE; Schema: public; Owner: fahdsuaifan
--

CREATE TABLE public.bedrooms (
    id integer NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    "desc" text,
    arabic_nam character varying(255) DEFAULT NULL::character varying,
    arabic_desc text,
    img character varying(255) DEFAULT NULL::character varying,
    img2 character varying(255) DEFAULT NULL::character varying,
    img3 character varying(255) DEFAULT NULL::character varying,
    price numeric(10,2) DEFAULT NULL::numeric,
    price2 numeric(10,2) DEFAULT NULL::numeric,
    isvisible boolean DEFAULT true,
    sale_price numeric(10,2) DEFAULT NULL::numeric,
    sale_price2 integer DEFAULT 0 NOT NULL,
    sort_order integer DEFAULT 0,
    stock_status character varying(50) DEFAULT 'In Stock'::character varying
);


ALTER TABLE public.bedrooms OWNER TO fahdsuaifan;

--
-- Name: bedrooms_id_seq; Type: SEQUENCE; Schema: public; Owner: fahdsuaifan
--

CREATE SEQUENCE public.bedrooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bedrooms_id_seq OWNER TO fahdsuaifan;

--
-- Name: bedrooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fahdsuaifan
--

ALTER SEQUENCE public.bedrooms_id_seq OWNED BY public.bedrooms.id;


--
-- Name: carts; Type: TABLE; Schema: public; Owner: fahdsuaifan
--

CREATE TABLE public.carts (
    id integer NOT NULL,
    user_email character varying(255),
    product_id integer,
    quantity integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.carts OWNER TO fahdsuaifan;

--
-- Name: carts_id_seq; Type: SEQUENCE; Schema: public; Owner: fahdsuaifan
--

CREATE SEQUENCE public.carts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.carts_id_seq OWNER TO fahdsuaifan;

--
-- Name: carts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fahdsuaifan
--

ALTER SEQUENCE public.carts_id_seq OWNED BY public.carts.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: fahdsuaifan
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    arabic_name character varying(50) NOT NULL
);


ALTER TABLE public.categories OWNER TO fahdsuaifan;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: fahdsuaifan
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_id_seq OWNER TO fahdsuaifan;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fahdsuaifan
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: clients; Type: TABLE; Schema: public; Owner: fahdsuaifan
--

CREATE TABLE public.clients (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(50),
    city character varying(100),
    total_orders integer DEFAULT 0 NOT NULL,
    total_spent numeric(10,2) DEFAULT 0.00 NOT NULL,
    status character varying(50) DEFAULT 'Active'::character varying NOT NULL,
    last_active character varying(50) DEFAULT 'Just now'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.clients OWNER TO fahdsuaifan;

--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: fahdsuaifan
--

CREATE SEQUENCE public.clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clients_id_seq OWNER TO fahdsuaifan;

--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fahdsuaifan
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- Name: kitchens; Type: TABLE; Schema: public; Owner: fahdsuaifan
--

CREATE TABLE public.kitchens (
    id integer NOT NULL,
    mainimg character varying(255) DEFAULT NULL::character varying,
    varimg character varying(255) DEFAULT NULL::character varying,
    kitchentypeid integer,
    isvisible boolean DEFAULT true NOT NULL
);


ALTER TABLE public.kitchens OWNER TO fahdsuaifan;

--
-- Name: kitchens_id_seq; Type: SEQUENCE; Schema: public; Owner: fahdsuaifan
--

CREATE SEQUENCE public.kitchens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.kitchens_id_seq OWNER TO fahdsuaifan;

--
-- Name: kitchens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fahdsuaifan
--

ALTER SEQUENCE public.kitchens_id_seq OWNED BY public.kitchens.id;


--
-- Name: kitchentype; Type: TABLE; Schema: public; Owner: fahdsuaifan
--

CREATE TABLE public.kitchentype (
    kitchentypeid integer NOT NULL,
    kitchenname character varying(255) DEFAULT NULL::character varying,
    "desc" text,
    img character varying(255) DEFAULT NULL::character varying,
    isvisible boolean DEFAULT true NOT NULL
);


ALTER TABLE public.kitchentype OWNER TO fahdsuaifan;

--
-- Name: kitchentype_kitchentypeid_seq; Type: SEQUENCE; Schema: public; Owner: fahdsuaifan
--

CREATE SEQUENCE public.kitchentype_kitchentypeid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.kitchentype_kitchentypeid_seq OWNER TO fahdsuaifan;

--
-- Name: kitchentype_kitchentypeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fahdsuaifan
--

ALTER SEQUENCE public.kitchentype_kitchentypeid_seq OWNED BY public.kitchentype.kitchentypeid;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: fahdsuaifan
--

CREATE TABLE public.orders (
    orderid integer NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    email character varying(255) DEFAULT NULL::character varying,
    phone character varying(20) DEFAULT NULL::character varying,
    items_list text,
    total_price numeric(10,2) DEFAULT NULL::numeric,
    order_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    order_code character varying(50),
    delivery_address text,
    status character varying(50) DEFAULT 'In Production'::character varying
);


ALTER TABLE public.orders OWNER TO fahdsuaifan;

--
-- Name: orders_orderid_seq; Type: SEQUENCE; Schema: public; Owner: fahdsuaifan
--

CREATE SEQUENCE public.orders_orderid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_orderid_seq OWNER TO fahdsuaifan;

--
-- Name: orders_orderid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fahdsuaifan
--

ALTER SEQUENCE public.orders_orderid_seq OWNED BY public.orders.orderid;


--
-- Name: precollection; Type: TABLE; Schema: public; Owner: fahdsuaifan
--

CREATE TABLE public.precollection (
    id integer NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    "desc" text,
    img1 bytea,
    img2 bytea,
    img3 bytea,
    img4 bytea,
    price numeric(10,2) DEFAULT NULL::numeric,
    isvisible boolean DEFAULT true,
    sort_order integer DEFAULT 0
);


ALTER TABLE public.precollection OWNER TO fahdsuaifan;

--
-- Name: precollection_id_seq; Type: SEQUENCE; Schema: public; Owner: fahdsuaifan
--

CREATE SEQUENCE public.precollection_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.precollection_id_seq OWNER TO fahdsuaifan;

--
-- Name: precollection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fahdsuaifan
--

ALTER SEQUENCE public.precollection_id_seq OWNED BY public.precollection.id;


--
-- Name: premium_collection; Type: TABLE; Schema: public; Owner: fahdsuaifan
--

CREATE TABLE public.premium_collection (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    price numeric(10,2) NOT NULL,
    "desc" text,
    main_img character varying(255) DEFAULT NULL::character varying,
    img1 character varying(255) DEFAULT NULL::character varying,
    img2 character varying(255) DEFAULT NULL::character varying,
    img3 character varying(255) DEFAULT NULL::character varying,
    img4 character varying(255) DEFAULT NULL::character varying,
    sale_price numeric(10,2) DEFAULT NULL::numeric
);


ALTER TABLE public.premium_collection OWNER TO fahdsuaifan;

--
-- Name: premium_collection_id_seq; Type: SEQUENCE; Schema: public; Owner: fahdsuaifan
--

CREATE SEQUENCE public.premium_collection_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.premium_collection_id_seq OWNER TO fahdsuaifan;

--
-- Name: premium_collection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fahdsuaifan
--

ALTER SEQUENCE public.premium_collection_id_seq OWNED BY public.premium_collection.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: fahdsuaifan
--

CREATE TABLE public.products (
    id integer NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    desc1 text,
    arabic_nam character varying(255) DEFAULT NULL::character varying,
    arabic_desc text,
    img character varying(255) DEFAULT NULL::character varying,
    price numeric(10,2) DEFAULT NULL::numeric,
    isvisible boolean DEFAULT true,
    category_id integer,
    category_id2 integer,
    sale_price numeric(10,2) DEFAULT NULL::numeric,
    sort_order integer DEFAULT 0,
    material text,
    dimensions text,
    stock_status character varying(50) DEFAULT 'Active'::character varying
);


ALTER TABLE public.products OWNER TO fahdsuaifan;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: fahdsuaifan
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_id_seq OWNER TO fahdsuaifan;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fahdsuaifan
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: fahdsuaifan
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    phone character varying(50),
    role character varying(50) DEFAULT 'customer'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.users OWNER TO fahdsuaifan;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: fahdsuaifan
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO fahdsuaifan;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fahdsuaifan
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: admin_users id; Type: DEFAULT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.admin_users ALTER COLUMN id SET DEFAULT nextval('public.admin_users_id_seq'::regclass);


--
-- Name: bedrooms id; Type: DEFAULT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.bedrooms ALTER COLUMN id SET DEFAULT nextval('public.bedrooms_id_seq'::regclass);


--
-- Name: carts id; Type: DEFAULT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.carts ALTER COLUMN id SET DEFAULT nextval('public.carts_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- Name: kitchens id; Type: DEFAULT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.kitchens ALTER COLUMN id SET DEFAULT nextval('public.kitchens_id_seq'::regclass);


--
-- Name: kitchentype kitchentypeid; Type: DEFAULT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.kitchentype ALTER COLUMN kitchentypeid SET DEFAULT nextval('public.kitchentype_kitchentypeid_seq'::regclass);


--
-- Name: orders orderid; Type: DEFAULT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.orders ALTER COLUMN orderid SET DEFAULT nextval('public.orders_orderid_seq'::regclass);


--
-- Name: precollection id; Type: DEFAULT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.precollection ALTER COLUMN id SET DEFAULT nextval('public.precollection_id_seq'::regclass);


--
-- Name: premium_collection id; Type: DEFAULT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.premium_collection ALTER COLUMN id SET DEFAULT nextval('public.premium_collection_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: admin_users; Type: TABLE DATA; Schema: public; Owner: fahdsuaifan
--

COPY public.admin_users (id, username, password, created_at) FROM stdin;
1	admin	12345	2026-05-13 19:02:08
\.


--
-- Data for Name: bedrooms; Type: TABLE DATA; Schema: public; Owner: fahdsuaifan
--

COPY public.bedrooms (id, name, "desc", arabic_nam, arabic_desc, img, img2, img3, price, price2, isvisible, sale_price, sale_price2, sort_order, stock_status) FROM stdin;
5	Signature - Barah Bedroom	King Bed, Two Nightstands & Vanity Table. (Swedish Pine Wood-EUR Coat)	اختصاص - غرفة براح	تخت ماستر, كمودينة عدد 2, تسريحة. (خشب سويد طبيعي-دهان اروبي)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Sanam_lq-is0WSy.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Barah_Vanity_GdkbD1J4qD.png	\N	1600.00	\N	t	1440.00	0	9	In Stock
6	Signature - Rawas Bedroom	Queen/King Bed, Two Nightstands, Dresser & Vanity Table. (TRK/EUR MFC-Upholstery)	اختصاص - غرفة رواس	تخت ماستر, كمودينة عدد 2, وحدة تخزين, تسريحة. (خشب مضعوط تركي أو اروبي-تنجيد)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Rawas_II_J2llqj_AWB.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Rawas_Vanity_and_Dresser_L1OzeBv0BC.png	\N	1450.00	1250.00	t	1305.00	1125	6	In Stock
7	Prestige - Rafif Bedroom	King Bed, Two Nightstands & Vanity Table. (Beech Wood-HMR-EUR Coat)	سُموّ - غرفة رفيف	تخت ماستر, كمودينة عدد 2, تسريحة. (خشب زان طبيعي-خشب مقاوم للرطوبة-دهان اروبي)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Rafif_oh8K5ZgsyB.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Rafif_Vanity_MAWvKWBf1.png	\N	2150.00	\N	t	\N	0	12	In Stock
8	Signature - Tayf Bedroom	King Bed, Two Nightstands, Dresser & Vanity Table. (TRK/EUR MFC-Upholstery-Latte Wood)	اختصاص - غرفة طيف	تخت ماستر, كمودينة عدد 2, وحدة تخزين, تسريحة. (خشب مضعوط تركي أو اروبي-تنجيد-خشب لاتية)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Tayf_PmjQ7YC-q7.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Tayf_Vanity_and_Dresser_jJ_Sna1jq.png	\N	1600.00	1400.00	t	1440.00	1260	7	In Stock
9	Signature - Aram Bedroom	King Bed, Two Nightstands, Dresser & Vanity Table. (TRK/EUR MFC)	اختصاص - غرفة أرام	تخت ماستر, كمودينة عدد 2, وحدة تخزين, تسريحة. (خشب مضغوط تركي و اروبي)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/86047aa7-93e9-479c-8daf-cd70a8b413df_oSWpuKCJa.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/6c39d4ce-ebe4-4e16-bde6-42963ad36f3a_QCdyaaIaO.png	\N	1400.00	1200.00	t	1260.00	1080	5	In Stock
10	Signature - Aziz 001 Bedroom	King Bed, Two Nightstands, Dresser & Vanity Table. (TRK/EUR MFC-Upholstery)	اختصاص - غرفة غزيز	تخت ماستر, كمودينة عدد 2, وحدة تخزين, تسريحة. (خشب مضعوط تركي أو اروبي-تنجيد)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/6aaf1c92-1d80-4c3d-bbf2-832e4f83cff0_7a5p8zwvM.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Aziz_Vanity_and_Dresser_kZGSg-iMS.png	\N	1450.00	1250.00	t	1305.00	1125	8	In Stock
12	Signature - Aziz 002 Bedroom	Double Bed, a Nightstand, Dresser & Vanity Table. (TRK/EUR MFC-Upholstery)	اختصاص - غرفة عزيز	تخت مفرد ونصف, كمودينة, وحدة تخزين, تسريحة. (خشب مضغوط تركي أو اروبي-تنجيد)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Aziz_9lT9m08Qj.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Aziz_Vanity_and_Dresser_kfEd0zDWF.png	\N	1300.00	1100.00	t	1105.00	935	28	In Stock
14	Prestige - Montessori	Two Single Beds, Stairs/Drawers, Slide & Play Area. (Swedish Pine Wood-Latte Wood-TRK/EUR MFC)	سُموّ - غرفة مونتيسوري	تخت مفرد عدد 2, درج مع جوارير, زحليقة أطفال, منطقه لعب علوية. (خشب سويد طبيعي-خشب لاتية-خشب مضغوط تركي أو اروبي)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/12e19b77-11c0-469a-b3eb-636c839f9b14_I9o8hU2YO.png	\N	\N	1900.00	\N	t	\N	0	13	In Stock
15	Signature - Surur Bedroom	Two Single Beds, a Nightstand, Dresser & Vanity Table. (TRK/EUR MFC-Upholstery-Latte Wood)	اختصاص - غرفة سرور	تخت مفرد عدد 2, كمودينة, وحدة تخزين, تسريحة. (خشب مضغوط تركي أو اروبي-تنجيد-خشب لاتية)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/62a0191e-2b49-4f24-92bf-a07c5a9bdabe_tn6dhgXws.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Surur_Vanity___Drawer_Chest_5olIdOB4q.png	\N	1800.00	1600.00	t	1530.00	1360	26	In Stock
27	Essentials - Mihad 001 Bedroom/Wardrobe	King Bed, Two Nightstands, Dresser, Vanity Table & Wardrobe six doors. (Latte Wood-Upholstery) 	أساس - غرفة نوم مهاد/خزانة 001	تخت ماستر, كمودينة عدد 2, وحدة تخزين, تسريحة, خزانة ست درف. (خشب لاتية-تنجيد)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/84be98f1-f179-43a9-97d8-55c131cf3434_YRM6S6oJk.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/new2_KOkGRfJuB.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/new_MvjGGs1eB.png	1440.00	\N	t	1200.00	0	14	In Stock
28	Essentials - Mihad 002 Bedroom/Wardrobe	King Bed, Two Nightstands, Dresser, Wardrobe & Vanity Table. (Latte Wood-Upholstery) 	أساس - غرفة نوم مهاد/خزانة 002	تخت ماستر, كمودينة عدد 2, وحدة تخزين, تسريحة, خزانة ست درف. (خشب لاتية-تنجيد)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/84be98f1-f179-43a9-97d8-55c131cf3434_C_HbTTu7v.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/new2_uz2vNpqay.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/new_fFrPDrjl1.png	1440.00	\N	t	1200.00	0	15	In Stock
29	Essentials - Mihad 003 Bedroom/Wardrobe	King Bed, Two Nightstands, Dresser, Wardrobe & Vanity Table. (Latte Wood-Upholstery) 	أساس - غرفة نوم مهاد/خزانة 003	تخت ماستر, كمودينة عدد 2, وحدة تخزين, تسريحة, خزانة ست درف. (خشب لاتية-تنجيد)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/84be98f1-f179-43a9-97d8-55c131cf3434_XbGFXdnC3.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/new2_belpMW-Ll.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/new_bwtqJ6emI.png	1440.00	\N	t	1200.00	0	16	In Stock
25	Essentials - Mihad 003 Bedroom	King Bed, Two Nightstands, Dresser & Vanity Table. (Latte Wood-Upholstery) 	أساس - غرفة نوم مهاد 003	تخت ماستر, كمودينة عدد 2, وحدة تخزين, تسريحة. (خشب لاتيه-تنجيد)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/84be98f1-f179-43a9-97d8-55c131cf3434_wMOiXkfzmN.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/40735fed-84e3-46e8-8b6b-db45980ed287_aysyj2fEI.png	\N	1140.00	\N	t	900.00	0	2	In Stock
23	Essentials - Mihad 002 Bedroom	King Bed, Two Nightstands, Dresser & Vanity Table. (Latte Wood-Upholstery) 	أساس - غرفة نوم مهاد 002	تخت ماستر, كمودينة عدد 2, وحدة تخزين, تسريحة. (خشب لاتيه-تنجيد)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/84be98f1-f179-43a9-97d8-55c131cf3434_gaQYQLFz7.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/40735fed-84e3-46e8-8b6b-db45980ed287_DMCRL5-5f.png	\N	1140.00	\N	t	900.00	0	1	In Stock
30	Signature - Aram Bedroom/Wardrobe	King Bed, Two Nightstands, Dresser, Vanity Table & Wardrobe. (TRK/EUR MFC)	اختصاص - غرفة أرام/خزانة	تخت ماستر, كمودينة عدد 2, وحدة تخزين, تسريحة, خزانة ست درف. (خشب مضغوط تركي و اروبي)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/86047aa7-93e9-479c-8daf-cd70a8b413df_SekBQYi31.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Tayf_Wardrobe_c2-Yfd2GI.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/6c39d4ce-ebe4-4e16-bde6-42963ad36f3a_XDV8jqI1z.png	1900.00	1700.00	t	1615.00	1445	19	In Stock
31	Signature - Rawas Bedroom/Wardrobe	Queen/King Bed, Two Nightstands, Dresser, Vanity Table & Wardrobe. (TRK/EUR MFC-Upholstery)	اختصاص - غرفة رواس/خزانة	تخت ماستر, كمودينة عدد 2, وحدة تخزين, تسريحة, خزانة ست درف. (خشب مضعوط تركي أو اروبي-تنجيد)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Rawas_II_-Tt9p3mwzD.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Rawas_se7GVgeLyD.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Rawas_Vanity_and_Dresser_uBZ8eKqixh.png	2000.00	1800.00	t	1700.00	1530	20	In Stock
32	Signature - Tayf Bedroom/Wardrobe	King Bed, Two Nightstands, Dresser, Vanity Table & Wardrobe. (TRK/EUR MFC-Upholstery-Latte Wood)	اختصاص - غرفة طيف/خزانة	تخت ماستر, كمودينة عدد 2, وحدة تخزين, تسريحة, خزانة ست درف. (خشب مضعوط تركي أو اروبي-تنجيد-خشب لاتية)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Tayf_4iPZv6iGf.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Tayf_Wardrobe_rWFpo35wu.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Tayf_Vanity_and_Dresser_SnsISjGHZ.png	2150.00	1950.00	t	1825.00	1655	21	In Stock
33	Signature - Aziz 001 Bedroom/Wardrobe	Queen/King Bed, Two Nightstands, Dresser, Vanity Table & Wardrobe. (TRK/EUR MFC-Upholstery)	اختصاص - غرفة غزيز/خزانة	تخت ماستر, كمودينة عدد 2, وحدة تخزين, تسريحة, خزانة ست درف. (خشب مضعوط تركي أو اروبي-تنجيد)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/6aaf1c92-1d80-4c3d-bbf2-832e4f83cff0_b-OoSGWB0.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Barah_2b9EIpZZF.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Aziz_Vanity_and_Dresser_9ieKQeBDm.png	2000.00	1800.00	t	1700.00	1530	22	In Stock
34	Signature - Barah Bedroom/Wardrobe	King Bed, Two Nightstands, Vanity Table & Wardrobe. (Swedish Pine Wood-Latte Wood-EUR Coat)	اختصاص - غرفة براح/خزانة	تخت ماستر, كمودينة عدد 2, تسريحة, خزانة ست درف. (خشب سويد طبيعي-دهان اروبي-خشب لاتية)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Sanam_nj6YJkWC0.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/new2_lkVy63cRHa.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Barah_Vanity_h3oylfOuB.png	2150.00	\N	t	1825.00	0	23	In Stock
35	Prestige - Rafif Bedroom/Wardrobe	King Bed, Two Nightstands, Vanity Table & Wardrobe. (Beech Wood-HMR-EUR Coat)	سُموّ - غرفة رفيف/خزانة	تخت ماستر, كمودينة عدد 2, تسريحة, خزانة ست درف (خشب زان طبيعي-خشب مقاوم للرطوبة-دهان اروبي)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Rafif_EgTwUuXRLm.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Rafif_Wardrobe_UDqOGRB00.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Rafif_Vanity_hD0qZJG2pt.png	2950.00	\N	t	\N	0	24	In Stock
36	Essentials - Mihad 004 Bedroom	King Bed, Two Nightstands, Dresser & Vanity Table. (Latte Wood-Upholstery) 	أساس - غرفة نوم مهاد 004	تخت ماستر, كمودينة عدد 2, وحدة تخزين, تسريحة. (خشب لاتيه-تنجيد)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/8535303a-55bf-445d-9238-cec9566b148a_kFgRlTVNa.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/new_tUpxy3gqS.png	\N	1140.00	\N	t	900.00	0	3	In Stock
37	Essentials - Mihad 005 Bedroom	King Bed, Two Nightstands, Dresser & Vanity Table. (Latte Wood-Upholstery) 	أساس - غرفة نوم مهاد 005	تخت ماستر, كمودينة عدد 2, وحدة تخزين, تسريحة. (خشب لاتيه-تنجيد)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/4b6d8558-6f62-449e-ba1f-d7a6fed4f5c8_oE4g_XJpT.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/new_iIz0ovHD0.png	\N	1140.00	\N	t	900.00	0	4	In Stock
38	Prestige - Montessori Bedroom/Wardrobe	Two Single Beds, Stairs/Drawers, Slide, Play Area & Wardrobe. (Swedish Pine Wood-Latte Wood-TRK/EUR MFC)	سُموّ - غرفة مونتيسوري/خزانة	تخت مفرد عدد 2, درج مع جوارير, زحليقة أطفال, منطقه لعب علوية, خزانة ست درف. (خشب سويد طبيعي-خشب لاتية-خشب مضغوط تركي أو اروبي)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/12e19b77-11c0-469a-b3eb-636c839f9b14_O9aG5BWvj6.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Rawas_Wardrobe_sqkDwFgfX.png	\N	2500.00	\N	t	\N	0	25	In Stock
39	Essentials - Mihad 004 Bedroom/Wardrobe	King Bed, Two Nightstands, Dresser, Wardrobe & Vanity Table. (Latte Wood-Upholstery) 	أساس - غرفة نوم مهاد/خزانة 004	تخت ماستر, كمودينة عدد 2, وحدة تخزين, تسريحة, خزانة ست درف. (خشب لاتية-تنجيد)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/8535303a-55bf-445d-9238-cec9566b148a_79OLiDyUs.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/new2_dSMl_UOgA.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/new_nJem3iLFX.png	1440.00	\N	t	1200.00	0	17	In Stock
40	Essentials - Mihad 005 Bedroom/Wardrobe	King Bed, Two Nightstands, Dresser, Wardrobe & Vanity Table. (Latte Wood-Upholstery) 	أساس - غرفة نوم مهاد/خزانة 005	تخت ماستر, كمودينة عدد 2, وحدة تخزين, تسريحة, خزانة ست درف. (خشب لاتية-تنجيد)\n	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/4b6d8558-6f62-449e-ba1f-d7a6fed4f5c8_ReP3DBhBG.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/new2_ScKPdZoFO.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/new_iLimRYitQ.png	1440.00	\N	t	1200.00	0	18	In Stock
41	Signature - Surur Bedroom/Wardrobe	Two Single Beds, a Nightstand, Dresser, Vanity Table & Wardrobe. (TRK/EUR MFC-Upholstery-Latte Wood)	اختصاص - غرفة سرور/خزانة	تخت مفرد عدد 2, كمودينة, وحدة تخزين, تسريحة, خزانة أربع درف. (خشب مضغوط تركي أو اروبي-تنجيد-خشب لاتية)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Surur_Bed_wopAvGkxy.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Surur_-E-LaMn9T.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Surur_Vanity___Drawer_Chest_FVqgaIbM4.png	2400.00	2200.00	t	2040.00	1870	27	In Stock
42	Signature - Aziz 002 Bedroom/Wardrobe	Double Bed, a Nightstand, Dresser, Vanity Table & Wardrobe. (TRK/EUR MFC-Upholstery)	اختصاص - غرفة عزيز/خزانة	تخت مفرد ونصف, كمودينة, وحدة تخزين, تسريحة, خزانة ثلاث درف. (خشب مضغوط تركي أو اروبي-تنجيد)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Aziz_vVvNmDuYd.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Aziz_Wardrobe_reNySkxIM.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Aziz_Vanity_and_Dresser_N6lYhxpT_.png	1900.00	1700.00	t	1615.00	1445	60	In Stock
22	Essentials - Mihad 001 Bedroom	King Bed, Two Nightstands, Dresser & Vanity Table. (Latte Wood-Upholstery) 	أساس - غرفة نوم مهاد 001	تخت ماستر, كمودينة عدد 2, وحدة تخزين, تسريحة. (خشب لاتيه-تنجيد)	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/84be98f1-f179-43a9-97d8-55c131cf3434_GL1aWYT5o.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/40735fed-84e3-46e8-8b6b-db45980ed287_-YJ3_Wedy.png	\N	1140.00	\N	t	900.00	0	0	In Stock
\.


--
-- Data for Name: carts; Type: TABLE DATA; Schema: public; Owner: fahdsuaifan
--

COPY public.carts (id, user_email, product_id, quantity, created_at) FROM stdin;
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: fahdsuaifan
--

COPY public.categories (id, name, arabic_name) FROM stdin;
1	Living Room Tables	طاولات غرف معيشة
2	TV Units	وحد تلفاز
3	Consoles	كونسول
4	Commercial Offices	مكاتب
9	Wardrobe	خزائن
11	Additions	الاضافات
12	Essentials	أساس
13	Signature	اختصاص
14	Prestige	سُموّ
15	Kitchens	مطابخ
16	Bedrooms	غرف نوم
17	Living Room	غرف معيشة
\.


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: fahdsuaifan
--

COPY public.clients (id, name, email, phone, city, total_orders, total_spent, status, last_active, created_at) FROM stdin;
12	Fahd Suaifan	fahasuaifan@outlook.com	07 8259 8543	Amman	1	210.00	Active	Just now	2026-09-08 17:33:11.451773
\.


--
-- Data for Name: kitchens; Type: TABLE DATA; Schema: public; Owner: fahdsuaifan
--

COPY public.kitchens (id, mainimg, varimg, kitchentypeid, isvisible) FROM stdin;
1	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit1V1.png?updatedAt=1779196666778	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kitchen%201/kit1V1.png?updatedAt=1779196657826	1	t
2	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit1V2.png?updatedAt=1779196666702	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kitchen%201/kit1V2.png?updatedAt=1779196657790	1	t
3	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit1V3.png?updatedAt=1779196667585	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kitchen%201/kit1V3.png?updatedAt=1779196657686	1	t
4	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit1V4.png?updatedAt=1779196667034	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kitchen%201/kit1V4.png?updatedAt=1779196657878	1	t
5	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit1V5.png?updatedAt=1779196666832	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kitchen%201/kit1V6.png?updatedAt=1779196658176	1	t
6	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit1V6.png?updatedAt=1779196666603	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kitchen%201/kit1V5.png?updatedAt=1779196657731	1	t
7	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit2V1.jpg?updatedAt=1779196664533	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kitchen%201/kit2V1.png?updatedAt=1779196657714	2	t
8	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit2V2.jpg?updatedAt=1779196664677	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kitchen%201/kit2V2.png?updatedAt=1779196657750	2	t
9	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit2V3.jpg?updatedAt=1779196664241	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kitchen%201/kit2V4.png?updatedAt=1779196657834	2	t
10	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit2V4.jpg?updatedAt=1779196664445	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kitchen%201/kit2V3.png?updatedAt=1779196657836	2	t
11	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit2V5.jpg?updatedAt=1779196664490	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kitchen%201/kit2V5.png?updatedAt=1779196657967	2	t
12	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit2V6.jpg?updatedAt=1779196664264	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kitchen%201/kit2V6.png?updatedAt=1779196657563	2	t
14	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit3V1.jpg?updatedAt=1779196664052	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kitchen%201/Kit3V1.png?updatedAt=1779196657596	3	t
15	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit3V2.jpg?updatedAt=1779196663930	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kitchen%201/Kit3V2.png?updatedAt=1779196657818	3	t
16	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit3V3.jpg?updatedAt=1779196663918	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kitchen%201/Kit3V3.png?updatedAt=1779196657739	3	t
17	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit3V4.jpg?updatedAt=1779196664060	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kitchen%201/Kit3V6.png?updatedAt=1779196657824	3	t
18	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit3V5.jpg?updatedAt=1779196664094	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kitchen%201/Kit3V5.png?updatedAt=1779196657996	3	t
19	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit3V6.jpg?updatedAt=1779196664137	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kitchen%201/Kit3V4.png?updatedAt=1779196657963	3	t
\.


--
-- Data for Name: kitchentype; Type: TABLE DATA; Schema: public; Owner: fahdsuaifan
--

COPY public.kitchentype (kitchentypeid, kitchenname, "desc", img, isvisible) FROM stdin;
1	contemporary		https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit1V1.png	t
2	chic	\N	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit2V6.jpg?updatedAt=1779196664264	t
3	Organic Modern	\N	https://ik.imagekit.io/6dghafkgmq/Kitchens/Kit3V4.jpg?updatedAt=1779196664060	t
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: fahdsuaifan
--

COPY public.orders (orderid, name, email, phone, items_list, total_price, order_date, order_code, delivery_address, status) FROM stdin;
110	Fahd Suaifan	fahasuaifan@outlook.com	07 8259 8543	Prestige - Oud Coffee Table (x1)	210.00	2026-09-08 17:33:11.442648	ORD-2026-533	Amman, Jordan	In Production
\.


--
-- Data for Name: precollection; Type: TABLE DATA; Schema: public; Owner: fahdsuaifan
--

COPY public.precollection (id, name, "desc", img1, img2, img3, img4, price, isvisible, sort_order) FROM stdin;
\.


--
-- Data for Name: premium_collection; Type: TABLE DATA; Schema: public; Owner: fahdsuaifan
--

COPY public.premium_collection (id, name, price, "desc", main_img, img1, img2, img3, img4, sale_price) FROM stdin;
3	Oud Collection	1000.00	\N	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Oud-Collection_aTGeaBHXu.jpg	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Oud_Console_-2Eo3JJw6.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Oud_Coffee_Table_4A_Ldx-d-.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Oud_Side_Table_wYsgPAV0d.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Oud_Service_Table_5ybt_7dBo.png	900.00
6	Wesal Collection	1500.00	\N	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Wesal-Collection_3upHWSfVL.jpg	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Wesal_-_Console_uz_iR0FjW.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Wesal_Coffee_Table_QxqjsudS-.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Wesal_Side_Tables_p_0o3QP-d.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Wesal_-_TV_Unit_Fb8mOuaUip.png	1350.00
7	Cont-Siq Collection	750.00	\N	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Cont-Siq-Collection_IKU4Y5R0s.jpg	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Contemporary_Siq_Console_dD8RgtOXB.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Contemporary_Siq_Coffee_Table_Dmsku1Jmc.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Contemporary_Siq_Side_Table_p0Fh7Umj8.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Contemporary_Siq_TV_Unit_Short_4lhcD651H.jpg	695.00
8	Siq Collection	550.00	\N	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Siq-Collection_xeNv7OaEg.jpg	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Siq_Console_yNuCwtUVA.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Siq_Coffee_Table_ahNTUqS6B.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Siq_Side_Table_l63NsEbdI.png	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Siq_TV_Unit_VjlpDNtfA.png	440.00
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: fahdsuaifan
--

COPY public.products (id, name, desc1, arabic_nam, arabic_desc, img, price, isvisible, category_id, category_id2, sale_price, sort_order, material, dimensions, stock_status) FROM stdin;
19	Signature - Cont-Siq Coffee Table	160cmx58cmx40cm - MFC Wood 	اختصاص - سيق معاصر طاولة وسطية	160سم,58سم,40سم - خشب مضغوط	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Contemporary_Siq_Coffee_Table_ojV-qv8jY.png	180.00	t	1	13	160.00	7	\N	\N	Active
20	Signature - Cont-Siq Side Table	40cmx40cmx39cm - MFC Wood	اختصاص - سيق معاصر طاولة جانبية	40سم,40سم,39سم - خشب مضغوط	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Contemporary_Siq_Side_Table_kKLxQ7kHu.png	80.00	t	1	13	70.00	8	\N	\N	Active
25	Essentials - Siq Console	(160x42x85.5)CM - MDF Wood	أساس - سيق كونسول	160سم,42سم,85سم - م.د.ف	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Siq_Console_GT43VZyISA.png	180.00	t	3	12	150.00	12	\N	\N	Active
26	Signature - Cont-Siq Console	160cmx42cmx87.5cm - TRK/EUR MFC 	اختصاص - سيق معاصر كونسول	160سم,42سم,87سم - مضغوط تركي أو اروبي	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Contemporary_Siq_Console_bED90j8ge.png	235.00	t	3	13	210.00	13	\N	\N	Active
36	Signature - Barah Console	140cmx42cmx78cm - Swedish Pine Wood-EUR Coat	اختصاص - باراح كونسول	140سم,42سم,78سم - خشب سويد و دهان اروبي	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/ChatGPT_Image_Jan_14__2026__02_30_01_PM_wcBCllmgA.png	350.00	t	3	13	330.00	16	\N	\N	Active
31	Essentials - Siq TV Unit	160cmx40cmx40cm - MDF Wood 	أساس - سيق وحدة تلفاز	160سم,40سم,40سم - م.د.ف	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Siq_TV_Unit_BuxwFwr5X.png	140.00	t	2	12	120.00	17	\N	\N	Active
29	Signature - Cont-Siq TV Uint Short	160cmx40cmx49.5cm - TRK/EUR MFC	اختصاص - سيق معاصر وحدة تلفاز	160سم,40سم,49سم - مضغوط تركي أو اروبي	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Contemporary_Siq_TV_Unit_Short_1__VmTAZ4AbG.png	220.00	t	2	13	195.00	18	\N	\N	Active
30	Signature - Cont-Siq TV Uint Tall	198cmx40cmx50cm - TRK/EUR MFC 	اختصاص - سيق معاصر وحدة تلفاز	198سم,40سمو50سم - مضغوط تركي أو اروبي	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Contemporary_Siq_TV_Unit_Tall_1__sbnH36P4Q.png	250.00	t	2	\N	225.00	19	\N	\N	Active
40	Signature - Japandi-Siq TV Unit (Last Piece)	180cmx42cmx51.5cm - EUR MFC 	اختصاص - جباندي سيق وحدة تلفاز (أخر قطعة)	180سم,42سم,51سم - خشب مضغوط اروبي	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Japandi_Wesal_TV_Unit_j1UUAl6Fq.png	210.00	t	2	13	90.00	20	\N	\N	Active
41	Signature - Boho-Siq TV Unit	185.5cmx40cmx41.5cm - TRK/EUR MFC 	اختصاص - بوهو وحدة تلفاز	185سم,40سم,41سم - مضغوط تركي أو اروبي	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Boho_Siq_TV_Unit_KgHfRmdTQF.png	222.00	t	2	13	200.00	21	\N	\N	Active
42	Organic Siq Tv Unit	180cmx40cmx46cm - EUR MFC-Solid Wood-EUR Coat	\N	\N	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Organic_Siq_TV_Unit_UIINlDl5i.png	220.00	f	2	\N	120.00	22	\N	\N	Low Stock
37	Executive Desk	180cmx80cmx72cm-TRK/EUR MFC	\N	\N	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Ex_Desk_HUGZXAJYzw.png	450.00	t	4	\N	405.00	27	\N	\N	Active
38	Executive Desk Two	160cmx80cmx72cm-TRK/EUR MFC	\N	\N	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Ex_Desk_V7D39XYa5.png	400.00	t	4	\N	360.00	28	\N	\N	Active
39	Meeting Table	\N	\N	\N	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Meeting_Table_DN1-wdQeU.png	450.00	t	4	\N	405.00	29	\N	\N	Active
44	Wardrobe TRK-(160x260x60) cm	TRK MFC-Samet Hinges	خزانة خشب تركي-(160x260x60) سم	خشب مضغوط تركي-فصالات سمت	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Rawas_Wardrobe_B7vxPQZ0F.png	700.00	t	13	9	595.00	33	\N	\N	Active
43	Wardrobe TRK-(200x260x60) cm	TRK MFC-Samet Hinges	خزانة خشب تركي-(200x260x60) سم	خشب مضغوط تركي-فصالات سمت	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/7befa96c-4220-4651-b67d-5a9754b0a267_R19WwfhM3_.png	750.00	t	13	9	635.00	34	\N	\N	Active
45	Wardrobe TRK-(240x260x60) cm	TRK MFC-Samet Hinges	خزانة خشب تركي-(240x260x60) سم	خشب مضغوط تركي-فصالات سمت	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/6e04ee38-c04c-4a81-b117-eaa3cd3b9454_f7Mp1xyVt.png	850.00	t	13	9	720.00	35	\N	\N	Active
46	Wardrobe EUR-(160x260x60) cm\t	EUR MFC-Samet Hinges	خزانة خشب أروبي-(160x260x60) سم	خشب مضغوط أروبي-فصالات سمت	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Rawas_Wardrobe_AQLD1g1Hy.png	800.00	t	14	9	680.00	39	\N	\N	Active
47	Wardrobe EUR-(200x260x60) cm\t	EUR MFC-Samet Hinges	خزانة خشب أروبي-(200x260x60) سم	خشب مضغوط أروبي-فصالات سمت	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/7befa96c-4220-4651-b67d-5a9754b0a267_wOIw0lvzx.png	850.00	t	14	9	720.00	40	\N	\N	Active
48	Wardrobe EUR-(240x260x60) cm\t	EUR MFC-Samet Hinges	خزانة خشب أروبي-(240x260x60) سم	خشب مضغوط أروبي-فصالات سمت	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/6e04ee38-c04c-4a81-b117-eaa3cd3b9454__fylQtdsE.png	950.00	t	14	9	800.00	41	\N	\N	Active
50	Wardrobe Latte-(240x220x60) cm\t	Latte Wood-Samet Hinges	خزانة لاتية - (240x220x60) سم	خشب لاتية-فصالات سمي	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/new2_RY_ppkQQh.png	600.00	t	12	9	500.00	47	\N	\N	Active
53	Hanging Nightstand	Addition - 45cm width, one drawer	كمودينة معلقة	إضافة - عرض 45سم, درج واحد	\N	45.00	t	11	\N	\N	49	\N	\N	Active
54	Shelves	Addition 	رف	إضافة	\N	25.00	t	11	\N	\N	50	\N	\N	Active
55	Wardrobe Glass Door	Addition	باب زجاج للخزائن	إضافة	\N	95.00	t	11	\N	\N	51	\N	\N	Active
56	Drawer Unit (Wardrobe)	Addition - three drawers. 	وحدة أدراج خزانة	إضافة - ثلاث ادراج	\N	115.00	t	11	\N	\N	52	\N	\N	Active
57	Wall Mirror	Addition - 80cmx80cm	مرآة حائط	إضافة - 85سم ب 85سم	\N	75.00	t	11	\N	\N	53	\N	\N	Active
58	Wardrobe Door Mirror	Addition	مرآة باب الخزانة	إضافة	\N	60.00	t	\N	\N	\N	54	\N	\N	Active
18	Essentials - Siq Side Table	40cmx40cmx39cm - MDF Wood	أساس - سيق طاولة جانبية 	40سم,40سم,39سم - خشب م.د.ف	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Siq_Side_Table_ngh0GH1PE.png	65.00	t	1	12	55.00	6	\N	\N	Active
16	Prestige - Oud Service Table	25cmx25cmx50cm - Oak Veneer-HRM Wood-EUR Coat	سُموّ - عود طاولة ضيافة	15سم,25سم,50سم - قشرة بلوط و خشب مقاوم للرطوبة و دهان اروبي	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Oud_Service_Table_2rmaUXujI.png	95.00	t	1	14	90.00	4	Bouclé Fabric & Solid Oak	220cm x 95cm x 78cm	Active
22	Prestige - Wesal Side Table	39cmx50cm - Quartz-Beech Wood-EUR Coat\n	سُموّ - وصال طاولة جانبية	39سم,50سم - كوارتز و خشب زان و دهان اروبي	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Wesal_Side_Tables_4OqIDMMqp.png	235.00	t	1	14	220.00	10	Natural Walnut & Linen Upholstery	200cm x 180cm x 110cm	Active
23	Prestige - Oud Console	160cmx42.5cmx83.5cm - Oak Veneer-HMR Wood-EUR Coat	سُموّ - عود كونسول	160سم,42سم,83سم - قشرة بلوط و خشب مقاوم للرطوبة و دهان اروبي	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Oud_Console_hwOGLNCA7.png	560.00	t	3	14	530.00	11	Bouclé Fabric & Solid Oak	220cm x 95cm x 78cm	Active
27	Prestige - Wesal Console	180cmx43.5cmx83.5cm - HMR Wood-EUR Coat	سُموّ - وصال كونسول	180سم,43سم,83سم - خشب مقاوم للرطوبة و دهان اروبي	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Wesal_-_Console_RS2mPZqP6.png	460.00	t	3	14	435.00	14	Natural Walnut & Linen Upholstery	200cm x 180cm x 110cm	Active
28	Prestige - Boho-Wesal Console	160cmx42cmx84cm - TRK/EUR MFC-Rattan-EUR Coat	سُموّ - بوهو وصال كونسول	160سم,42سم,84سم- مضغوط تركي و اروبي و رتان و دهان اروبي	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Boho_Wesal_Console_YH36LG7J0.png	515.00	t	3	14	490.00	15	Natural Walnut & Linen Upholstery	200cm x 180cm x 110cm	Active
32	Signature - Wesal TV Unit	160cmx42.5cmx60cm - TRK/EUR MFC 	اختصاص - وصال وحدة تلفاز	160سم,42سم,60سم - مضغوط تركي أو اروبي	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Wesal_-_TV_Unit_8RLIF6aSd.png	220.00	t	2	13	200.00	23	Natural Walnut & Linen Upholstery	200cm x 180cm x 110cm	Active
33	Prestige - Boho-Wesal TV Unit	160cmx42.5cmx60cm - TRK/EUR MFC-Rattan-Coated EUR 	سُموّ - بوهو وصال وحدة تلفاز	160سم,42سم,60سم - مضغوط تركي أو اروبي و رتان و دهان اروبي	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Boho_Wesal_TV_Unit__-PIjzfnh.png	350.00	t	2	14	330.00	24	Natural Walnut & Linen Upholstery	200cm x 180cm x 110cm	Active
34	Japandi-Wesal TV Unit	\N	\N	\N	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Japandi_Wesal_TV_Unit_xMU5ECkPT.png	210.00	f	2	\N	115.00	25	Natural Walnut & Linen Upholstery	200cm x 180cm x 110cm	Active
35	Signature - Cont-Wesal TV Unit (Last Piece)	140cmx42cmx40cm-EUR MFC	اختصاص - وصال معاصر وحدة تلفاز (أخر قطعة)	140سم,42سم,40سم - خشب مضغوط اروبي	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Contemporary_Wesal_TV_Unit_GiDatBeD0.png	210.00	t	2	13	90.00	26	Natural Walnut & Linen Upholstery	200cm x 180cm x 110cm	Active
65	Wardrobe TRK-(40x260x60) cm	TRK MFC-Samet Hinges	خزانة خشب تركي-(40x260x60) سم	خشب مضغوط تركي-فصالات سمت	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/804b5d80-f1bc-4b4d-8908-54d29e91849b_VBTWlaHhA7.png	250.00	t	13	9	210.00	30	\N	\N	Active
64	Wardrobe TRK-(80x260x60) cm	TRK MFC-Samet Hinges	خزانة خشب تركي-(80x260x60) سم	خشب مضغوط تركي-فصالات سمت	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/fbf05ac4-0b46-4a2c-90cb-6b591a47ba6e_j0ikBgA7i.png	400.00	t	13	9	340.00	31	\N	\N	Active
63	Wardrobe TRK-(120x260x60) cm\t	TRK MFC-Samet Hinges	خزانة خشب تركي-(120x260x60) سم	خشب مضغوط تركي-فصالات سمت	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/7bd885a9-04fe-49a2-be9a-e0472195afed_4lHISJNuWu.png	600.00	t	13	9	510.00	32	\N	\N	Active
68	Wardrobe EUR-(40x260x60) cm	EUR MFC-Samet Hinges	خزانة خشب أروبي-(40x260x60) سم	خشب مضغوط أروبي-فصالات سمت	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/804b5d80-f1bc-4b4d-8908-54d29e91849b_wT8IAL_ki.png	350.00	t	14	9	295.00	36	\N	\N	Active
67	Wardrobe EUR-(80x260x60) cm	EUR MFC-Samet Hinges	خزانة خشب أروبي-(80x260x60) سم	خشب مضغوط أروبي-فصالات سمت	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/fbf05ac4-0b46-4a2c-90cb-6b591a47ba6e_KdKobz_vo.png	500.00	t	14	9	425.00	37	\N	\N	Active
66	Wardrobe EUR-(120x260x60) cm	EUR MFC-Samet Hinges	خزانة خشب أروبي-(120x260x60) سم	خشب مضغوط أروبي-فصالات سمت	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/7bd885a9-04fe-49a2-be9a-e0472195afed_AE56qO6Xv5.png	700.00	t	14	9	595.00	38	\N	\N	Active
70	Wardrobe Latte-(40x220x60) cm	Latte Wood-Samet Hinges	خزانة لاتية - (40x220x60) سم	خشب لاتية-فصالات سمي	\N	250.00	t	12	9	210.00	42	\N	\N	Active
69	Wardrobe Latte-(80x220x60) cm	Latte Wood-Samet Hinges	خزانة لاتية - (80x220x60) سم	خشب لاتية-فصالات سمي	\N	300.00	t	12	9	255.00	43	\N	\N	Active
62	Wardrobe Latte-(120x220x60) cm	Latte Wood-Samet Hinges	خزانة لاتية - (120x220x60) سم	خشب لاتية-فصالات سمي	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/3-doors_Ce0hUXGC2r.png	450.00	t	12	9	380.00	44	\N	\N	Active
61	Wardrobe Latte-(160x220x60) cm	Latte Wood-Samet Hinges	خزانة لاتية - (160x220x60) سم	خشب لاتية-فصالات سمي	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/4-doors_TjLQTZMO6.png	500.00	t	12	9	425.00	45	\N	\N	Active
60	Wardrobe Latte-(200x220x60) cm	Latte Wood-Samet Hinges	خزانة لاتية - (200x220x60) سم	خشب لاتية-فصالات سمي	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/5-doors_X-TH9QCKQ.png	550.00	t	12	9	465.00	46	\N	\N	Active
59	Wardrobe LED	Addition - For each space	انارة داخل الخزائن	إضافة - لكل فراغ	\N	125.00	t	11	\N	\N	55	\N	\N	Active
15	Prestige - Oud Side Table	50cmx50cmx50cm - Oak Veneer-HRM Wood-EUR Coat	سُموّ - عود طاولة جانبية	55سم,50سم,50سم - قشرة بلوط و خشب مقاوم للرطوبة و دهان اروبي	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Oud_Side_Table_v4e_a8HlY.png	125.00	t	1	14	115.00	3	Bouclé Fabric & Solid Oak	220cm x 95cm x 78cm	Active
14	Prestige - Oud Coffee Table	100cmx100cmx32.5cm - Oak Veneer-HMR Wood-EUR Coat	سُموّ - عود طاولة وسطية	100سم,100سم,32سم - قشرة بلوط و خشب مقاوم للرطوبة و دهان اروبي	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Oud_Coffee_Table_phjnkd5wB.png	225.00	t	1	14	210.00	1	Bouclé Fabric & Solid Oak	220cm x 95cm x 78cm	Active
72	Hurfa Custom Oak Desk	\N	\N	\N	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Wesal-Collection_n299cVlM5.jpg?updatedAt=1787138960280	550.00	t	17	\N	\N	2	Solid White Oak	160x80x75cm	Active
17	Essentials - Siq Coffee Table	160cmx58cmx40cm - MDF Wood 	أساس - سيق طاولة وسطية	160سم,58سم,40سم - خشب م.د.ف	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Siq_Coffee_Table_3WZdR8TY2.png	120.00	t	1	12	100.00	5	\N	\N	Active
21	Prestige - Wesal Coffee Table	143.5cmx62.5cmx35cm - Beech Wood-EUR MFC-EUR Coat	سُموّ - وصال طاولة وسطية	143سم,62سم,35سم - خشب زان و خشب مضغوط أروبي و دهان اروبي	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Wesal_Coffee_Table_muHYZD8cL.png	365.00	t	1	14	345.00	9	Natural Walnut & Linen Upholstery	200cm x 180cm x 110cm	Active
49	Wardrobe-(200x260x60) cm\t	Beech Wood-HMR Wood-EUR Coat-Samet Hinges	خزانة - (60x260x200) سم	خشب زان طبيعي - خشب مقاوم للرطوبة - دهان اروبي - فصالات سمت	https://ik.imagekit.io/6dghafkgmq/hurfa_catalog/Rafif_Wardrobe_ltn_JWNmn.png	1400.00	t	14	9	1330.00	48	\N	\N	Active
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: fahdsuaifan
--

COPY public.users (id, name, email, password, phone, role, created_at) FROM stdin;
2	Sarah Al-Ahmad	sarah@example.com	$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	+962 7 9111 2222	customer	2026-09-02 18:31:28.367747
4	Fahd Suaifan	fsuaifan@gmail.com	123456	\N	customer	2026-09-08 15:06:46.796185
1	Studio Administrator	admin@hurfa.com	12345	+962 7 9000 0000	admin	2026-09-02 18:31:28.367747
5	Fahd Suaifan	fahasuaifan@outlook.com	123456	07 8259 8543	customer	2026-09-08 17:32:53.805193
6	Fahd Suaifan	23110340@htu.edu.jo	123456	07 8259 8543	customer	2026-09-08 21:26:26.019213
\.


--
-- Name: admin_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fahdsuaifan
--

SELECT pg_catalog.setval('public.admin_users_id_seq', 2, true);


--
-- Name: bedrooms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fahdsuaifan
--

SELECT pg_catalog.setval('public.bedrooms_id_seq', 42, true);


--
-- Name: carts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fahdsuaifan
--

SELECT pg_catalog.setval('public.carts_id_seq', 1, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fahdsuaifan
--

SELECT pg_catalog.setval('public.categories_id_seq', 16, true);


--
-- Name: clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fahdsuaifan
--

SELECT pg_catalog.setval('public.clients_id_seq', 12, true);


--
-- Name: kitchens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fahdsuaifan
--

SELECT pg_catalog.setval('public.kitchens_id_seq', 19, true);


--
-- Name: kitchentype_kitchentypeid_seq; Type: SEQUENCE SET; Schema: public; Owner: fahdsuaifan
--

SELECT pg_catalog.setval('public.kitchentype_kitchentypeid_seq', 3, true);


--
-- Name: orders_orderid_seq; Type: SEQUENCE SET; Schema: public; Owner: fahdsuaifan
--

SELECT pg_catalog.setval('public.orders_orderid_seq', 110, true);


--
-- Name: precollection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fahdsuaifan
--

SELECT pg_catalog.setval('public.precollection_id_seq', 1, false);


--
-- Name: premium_collection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fahdsuaifan
--

SELECT pg_catalog.setval('public.premium_collection_id_seq', 8, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fahdsuaifan
--

SELECT pg_catalog.setval('public.products_id_seq', 73, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fahdsuaifan
--

SELECT pg_catalog.setval('public.users_id_seq', 6, true);


--
-- Name: admin_users admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: admin_users admin_users_username_key; Type: CONSTRAINT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.admin_users
    ADD CONSTRAINT admin_users_username_key UNIQUE (username);


--
-- Name: bedrooms bedrooms_pkey; Type: CONSTRAINT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.bedrooms
    ADD CONSTRAINT bedrooms_pkey PRIMARY KEY (id);


--
-- Name: carts carts_pkey; Type: CONSTRAINT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (id);


--
-- Name: categories categories_name_key; Type: CONSTRAINT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: clients clients_email_key; Type: CONSTRAINT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_email_key UNIQUE (email);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: kitchens kitchens_pkey; Type: CONSTRAINT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.kitchens
    ADD CONSTRAINT kitchens_pkey PRIMARY KEY (id);


--
-- Name: kitchentype kitchentype_pkey; Type: CONSTRAINT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.kitchentype
    ADD CONSTRAINT kitchentype_pkey PRIMARY KEY (kitchentypeid);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (orderid);


--
-- Name: precollection precollection_pkey; Type: CONSTRAINT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.precollection
    ADD CONSTRAINT precollection_pkey PRIMARY KEY (id);


--
-- Name: premium_collection premium_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.premium_collection
    ADD CONSTRAINT premium_collection_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_kitchens_kitchentypeid; Type: INDEX; Schema: public; Owner: fahdsuaifan
--

CREATE INDEX idx_kitchens_kitchentypeid ON public.kitchens USING btree (kitchentypeid);


--
-- Name: idx_products_category_id; Type: INDEX; Schema: public; Owner: fahdsuaifan
--

CREATE INDEX idx_products_category_id ON public.products USING btree (category_id);


--
-- Name: idx_products_category_id2; Type: INDEX; Schema: public; Owner: fahdsuaifan
--

CREATE INDEX idx_products_category_id2 ON public.products USING btree (category_id2);


--
-- Name: carts carts_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: carts carts_user_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_user_email_fkey FOREIGN KEY (user_email) REFERENCES public.users(email) ON DELETE CASCADE;


--
-- Name: kitchens kitchens_kitchentypeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.kitchens
    ADD CONSTRAINT kitchens_kitchentypeid_fkey FOREIGN KEY (kitchentypeid) REFERENCES public.kitchentype(kitchentypeid) ON DELETE SET NULL;


--
-- Name: products products_category_id2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id2_fkey FOREIGN KEY (category_id2) REFERENCES public.categories(id) ON DELETE SET NULL;


--
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fahdsuaifan
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict 4dKlpNWAjlpT8lPfb55OLzCvbUCVnQcQHShgUw5DdoUGepI6SF7uWRxA0HIROTs

