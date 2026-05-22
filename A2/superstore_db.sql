--
-- PostgreSQL database dump
--

\restrict OcEUM1a7MIkNplIaSbdV6B6QfxXBf8gzRAWfZfigMucaNzVQ0fYqWKocZlB3GOE

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    category_id integer NOT NULL,
    category_name character varying(50) NOT NULL
);


ALTER TABLE public.category OWNER TO postgres;

--
-- Name: category_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.category ALTER COLUMN category_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.category_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: city; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.city (
    city_id integer NOT NULL,
    city_name character varying(100) NOT NULL,
    state_id integer NOT NULL
);


ALTER TABLE public.city OWNER TO postgres;

--
-- Name: city_city_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.city ALTER COLUMN city_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.city_city_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: country; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.country (
    country_id integer NOT NULL,
    country_name character varying(100) NOT NULL
);


ALTER TABLE public.country OWNER TO postgres;

--
-- Name: country_country_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.country ALTER COLUMN country_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.country_country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    customer_id character varying(10) NOT NULL,
    customer_name character varying(100) NOT NULL,
    segment_id integer NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- Name: order_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_item (
    order_item_id integer NOT NULL,
    order_id character varying(20) NOT NULL,
    product_id character varying(20) NOT NULL,
    quantity integer NOT NULL,
    sales numeric(10,2) NOT NULL,
    profit numeric(10,2) NOT NULL,
    unit_price numeric(10,2) GENERATED ALWAYS AS ((sales / (quantity)::numeric)) STORED,
    CONSTRAINT chk_quantity_positive CHECK ((quantity > 0)),
    CONSTRAINT chk_sales_non_negative CHECK ((sales >= (0)::numeric))
);


ALTER TABLE public.order_item OWNER TO postgres;

--
-- Name: order_item_order_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.order_item ALTER COLUMN order_item_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.order_item_order_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    order_id character varying(20) NOT NULL,
    order_date date NOT NULL,
    ship_date date NOT NULL,
    customer_id character varying(10) NOT NULL,
    ship_mode_id integer NOT NULL,
    city_id integer NOT NULL,
    days_to_ship integer GENERATED ALWAYS AS ((ship_date - order_date)) STORED,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_order_date_not_future CHECK ((order_date <= CURRENT_DATE)),
    CONSTRAINT chk_ship_date_after_order CHECK ((ship_date >= order_date))
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product (
    product_id character varying(20) NOT NULL,
    product_name character varying(255) NOT NULL,
    sub_category_id integer NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    CONSTRAINT chk_product_id_format CHECK (((product_id)::text ~ '^[A-Z]{3}-[A-Z]{2}-[0-9]+$'::text))
);


ALTER TABLE public.product OWNER TO postgres;

--
-- Name: region; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.region (
    region_id integer NOT NULL,
    region_name character varying(50) NOT NULL,
    CONSTRAINT chk_region_name_valid CHECK (((region_name)::text = ANY ((ARRAY['South'::character varying, 'East'::character varying, 'West'::character varying, 'Central'::character varying])::text[])))
);


ALTER TABLE public.region OWNER TO postgres;

--
-- Name: region_region_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.region ALTER COLUMN region_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.region_region_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: segment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.segment (
    segment_id integer NOT NULL,
    segment_name character varying(50) NOT NULL,
    CONSTRAINT chk_segment_name_valid CHECK (((segment_name)::text = ANY ((ARRAY['Consumer'::character varying, 'Corporate'::character varying, 'Home Office'::character varying])::text[])))
);


ALTER TABLE public.segment OWNER TO postgres;

--
-- Name: segment_segment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.segment ALTER COLUMN segment_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.segment_segment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ship_mode; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ship_mode (
    ship_mode_id integer NOT NULL,
    ship_mode_name character varying(50) NOT NULL,
    CONSTRAINT chk_ship_mode_name_valid CHECK (((ship_mode_name)::text = ANY ((ARRAY['Standard Class'::character varying, 'Second Class'::character varying, 'First Class'::character varying, 'Same Day'::character varying])::text[])))
);


ALTER TABLE public.ship_mode OWNER TO postgres;

--
-- Name: ship_mode_ship_mode_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.ship_mode ALTER COLUMN ship_mode_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ship_mode_ship_mode_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: state; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.state (
    state_id integer NOT NULL,
    state_name character varying(50) NOT NULL,
    country_id integer NOT NULL,
    region_id integer NOT NULL
);


ALTER TABLE public.state OWNER TO postgres;

--
-- Name: state_state_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.state ALTER COLUMN state_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.state_state_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: sub_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sub_category (
    sub_category_id integer NOT NULL,
    sub_category_name character varying(50) NOT NULL,
    category_id integer NOT NULL
);


ALTER TABLE public.sub_category OWNER TO postgres;

--
-- Name: sub_category_sub_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.sub_category ALTER COLUMN sub_category_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.sub_category_sub_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.category OVERRIDING SYSTEM VALUE VALUES (1, 'Furniture');
INSERT INTO public.category OVERRIDING SYSTEM VALUE VALUES (2, 'Office Supplies');
INSERT INTO public.category OVERRIDING SYSTEM VALUE VALUES (3, 'Technology');


--
-- Data for Name: city; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (1, 'Houston', 1);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (2, 'Franklin', 17);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (3, 'Plainfield', 3);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (4, 'Vancouver', 21);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (5, 'Salinas', 18);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (6, 'Troy', 36);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (7, 'Norman', 27);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (8, 'Sierra Vista', 37);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (9, 'Chicago', 28);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (10, 'Lakeville', 7);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (11, 'Dallas', 1);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (12, 'Louisville', 15);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (13, 'Las Vegas', 33);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (14, 'New Brunswick', 3);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (15, 'Hesperia', 18);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (16, 'Aurora', 19);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (17, 'Phoenix', 37);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (18, 'Evanston', 28);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (19, 'Oceanside', 36);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (20, 'Urbandale', 34);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (21, 'Los Angeles', 18);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (22, 'Gladstone', 2);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (23, 'Portland', 13);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (24, 'Tyler', 1);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (25, 'Parker', 19);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (26, 'San Antonio', 1);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (27, 'San Francisco', 18);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (28, 'Tucson', 37);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (29, 'Westfield', 3);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (30, 'New York City', 36);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (31, 'Mission Viejo', 18);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (32, 'Austin', 1);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (33, 'Lancaster', 18);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (34, 'Arvada', 19);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (35, 'Mesa', 37);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (36, 'Franklin', 24);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (37, 'Wilmington', 31);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (38, 'Harlingen', 1);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (39, 'Edmond', 27);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (40, 'Atlanta', 9);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (41, 'Grove City', 20);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (42, 'Columbia', 11);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (43, 'Decatur', 26);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (44, 'Costa Mesa', 18);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (45, 'Morristown', 3);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (46, 'Tamarac', 29);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (47, 'Monroe', 4);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (48, 'Green Bay', 17);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (49, 'Independence', 2);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (50, 'Dover', 31);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (51, 'Salem', 13);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (52, 'Rochester', 7);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (53, 'Cincinnati', 20);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (54, 'San Diego', 18);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (55, 'Lawrence', 24);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (56, 'Marysville', 21);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (57, 'Fremont', 30);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (58, 'Des Moines', 34);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (59, 'Decatur', 28);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (60, 'Newark', 20);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (61, 'Great Falls', 35);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (62, 'Rochester Hills', 32);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (63, 'Canton', 32);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (64, 'Eagan', 7);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (65, 'Hialeah', 29);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (66, 'Santa Clara', 18);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (67, 'Scottsdale', 37);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (68, 'Richardson', 1);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (69, 'Auburn', 36);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (70, 'Palm Coast', 29);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (71, 'Franklin', 11);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (72, 'Naperville', 28);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (73, 'Denver', 19);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (74, 'Springfield', 5);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (75, 'Minneapolis', 7);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (76, 'Roseville', 18);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (77, 'Quincy', 28);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (78, 'Vallejo', 18);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (79, 'Santa Ana', 18);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (80, 'Warwick', 8);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (81, 'Lorain', 20);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (82, 'Fort Worth', 1);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (83, 'Columbus', 9);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (84, 'Inglewood', 18);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (85, 'Anaheim', 18);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (86, 'Jackson', 32);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (87, 'Saginaw', 32);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (88, 'Whittier', 18);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (89, 'Grand Prairie', 1);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (90, 'Aurora', 28);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (91, 'Arlington', 5);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (92, 'Montgomery', 26);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (93, 'Fairfield', 16);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (94, 'Akron', 20);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (95, 'Columbus', 20);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (96, 'Carlsbad', 25);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (97, 'Melbourne', 29);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (98, 'Memphis', 11);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (99, 'Detroit', 32);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (100, 'Tampa', 29);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (101, 'Concord', 12);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (102, 'Concord', 14);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (103, 'Jacksonville', 29);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (104, 'Asheville', 12);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (105, 'Saint Paul', 7);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (106, 'Amarillo', 1);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (107, 'Richmond', 15);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (108, 'Lakeland', 29);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (109, 'Seattle', 21);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (110, 'Cleveland', 20);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (111, 'Jackson', 6);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (112, 'Murfreesboro', 11);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (113, 'Charlotte', 12);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (114, 'Columbus', 22);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (115, 'Philadelphia', 23);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (116, 'Trenton', 32);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (117, 'Gastonia', 12);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (118, 'Manchester', 16);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (119, 'Burlington', 12);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (120, 'Florence', 15);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (121, 'Columbia', 10);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (122, 'Belleville', 3);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (123, 'Miami', 29);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (124, 'Henderson', 15);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (125, 'Chapel Hill', 12);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (126, 'Huntington Beach', 18);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (127, 'Lowell', 24);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (128, 'Mount Vernon', 36);
INSERT INTO public.city OVERRIDING SYSTEM VALUE VALUES (129, 'Pasadena', 1);


--
-- Data for Name: country; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.country OVERRIDING SYSTEM VALUE VALUES (1, 'United States');


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.customer VALUES ('AA-10375', 'Allen Armold', 1, true);
INSERT INTO public.customer VALUES ('AA-10480', 'Andrew Allen', 1, true);
INSERT INTO public.customer VALUES ('AB-10060', 'Adam Bellavance', 3, true);
INSERT INTO public.customer VALUES ('AD-10180', 'Alan Dominguez', 3, true);
INSERT INTO public.customer VALUES ('AG-10495', 'Andrew Gjertsen', 2, true);
INSERT INTO public.customer VALUES ('AG-10675', 'Anna Gayman', 1, true);
INSERT INTO public.customer VALUES ('AH-10195', 'Alan Haines', 2, true);
INSERT INTO public.customer VALUES ('AJ-10795', 'Anthony Johnson', 2, true);
INSERT INTO public.customer VALUES ('AM-10360', 'Alice McCarthy', 2, true);
INSERT INTO public.customer VALUES ('AP-10915', 'Arthur Prichep', 1, true);
INSERT INTO public.customer VALUES ('AR-10405', 'Allen Rosenblatt', 2, true);
INSERT INTO public.customer VALUES ('AR-10825', 'Anthony Rawles', 2, true);
INSERT INTO public.customer VALUES ('AS-10135', 'Adrian Shami', 3, true);
INSERT INTO public.customer VALUES ('AS-10285', 'Alejandro Savely', 2, true);
INSERT INTO public.customer VALUES ('AT-10735', 'Annie Thurman', 1, true);
INSERT INTO public.customer VALUES ('BB-10990', 'Barry Blumstein', 2, true);
INSERT INTO public.customer VALUES ('BB-11545', 'Brenda Bowman', 2, true);
INSERT INTO public.customer VALUES ('BD-11320', 'Bill Donatelli', 1, true);
INSERT INTO public.customer VALUES ('BD-11605', 'Brian Dahlen', 1, true);
INSERT INTO public.customer VALUES ('BF-11020', 'Barry Franzsisch', 2, true);
INSERT INTO public.customer VALUES ('BN-11515', 'Bradley Nguyen', 1, true);
INSERT INTO public.customer VALUES ('BP-11185', 'Ben Peterman', 2, true);
INSERT INTO public.customer VALUES ('BV-11245', 'Benjamin Venier', 2, true);
INSERT INTO public.customer VALUES ('CA-12310', 'Christine Abelman', 2, true);
INSERT INTO public.customer VALUES ('CB-12535', 'Claudia Bergmann', 2, true);
INSERT INTO public.customer VALUES ('CC-12430', 'Chuck Clark', 3, true);
INSERT INTO public.customer VALUES ('CC-12550', 'Clay Cheatham', 1, true);
INSERT INTO public.customer VALUES ('CC-12670', 'Craig Carreira', 1, true);
INSERT INTO public.customer VALUES ('CD-11980', 'Carol Darley', 1, true);
INSERT INTO public.customer VALUES ('CG-12520', 'Claire Gute', 1, true);
INSERT INTO public.customer VALUES ('CJ-12010', 'Caroline Jumper', 1, true);
INSERT INTO public.customer VALUES ('CK-12205', 'Chloris Kastensmidt', 1, true);
INSERT INTO public.customer VALUES ('CK-12595', 'Clytie Kelty', 1, true);
INSERT INTO public.customer VALUES ('CL-12565', 'Clay Ludtke', 1, true);
INSERT INTO public.customer VALUES ('CP-12340', 'Christine Phan', 2, true);
INSERT INTO public.customer VALUES ('CR-12730', 'Craig Reiter', 1, true);
INSERT INTO public.customer VALUES ('CS-11950', 'Carlos Soltero', 1, true);
INSERT INTO public.customer VALUES ('CS-12400', 'Christopher Schild', 3, true);
INSERT INTO public.customer VALUES ('CV-12805', 'Cynthia Voltz', 2, true);
INSERT INTO public.customer VALUES ('DB-13060', 'Dave Brooks', 1, true);
INSERT INTO public.customer VALUES ('DB-13120', 'David Bremer', 2, true);
INSERT INTO public.customer VALUES ('DB-13210', 'Dean Braden', 1, true);
INSERT INTO public.customer VALUES ('DJ-13510', 'Don Jones', 2, true);
INSERT INTO public.customer VALUES ('DJ-13630', 'Doug Jacobs', 1, true);
INSERT INTO public.customer VALUES ('DK-13225', 'Dean Katz', 2, true);
INSERT INTO public.customer VALUES ('DL-13315', 'Delfina Latchford', 1, true);
INSERT INTO public.customer VALUES ('Dl-13600', 'Dorris liebe', 2, true);
INSERT INTO public.customer VALUES ('DP-13105', 'Dave Poirier', 2, true);
INSERT INTO public.customer VALUES ('DS-13030', 'Darrin Sayre', 3, true);
INSERT INTO public.customer VALUES ('DS-13180', 'David Smith', 2, true);
INSERT INTO public.customer VALUES ('DV-13045', 'Darrin Van Huff', 2, true);
INSERT INTO public.customer VALUES ('DV-13465', 'Dianna Vittorini', 1, true);
INSERT INTO public.customer VALUES ('DW-13585', 'Dorothy Wardle', 2, true);
INSERT INTO public.customer VALUES ('EB-13705', 'Ed Braxton', 2, true);
INSERT INTO public.customer VALUES ('EB-13840', 'Ellis Ballard', 2, true);
INSERT INTO public.customer VALUES ('EG-13900', 'Emily Grady', 1, true);
INSERT INTO public.customer VALUES ('EH-13945', 'Eric Hoffmann', 1, true);
INSERT INTO public.customer VALUES ('EH-14125', 'Eugene Hildebrand', 3, true);
INSERT INTO public.customer VALUES ('EM-14095', 'Eudokia Martin', 2, true);
INSERT INTO public.customer VALUES ('EP-13915', 'Emily Phan', 1, true);
INSERT INTO public.customer VALUES ('ER-13855', 'Elpida Rittenbach', 2, true);
INSERT INTO public.customer VALUES ('ES-14080', 'Erin Smith', 2, true);
INSERT INTO public.customer VALUES ('FH-14365', 'Fred Hopkins', 2, true);
INSERT INTO public.customer VALUES ('FM-14380', 'Fred McMath', 1, true);
INSERT INTO public.customer VALUES ('FP-14320', 'Frank Preis', 1, true);
INSERT INTO public.customer VALUES ('GA-14725', 'Guy Armstrong', 1, true);
INSERT INTO public.customer VALUES ('GD-14590', 'Giulietta Dortch', 2, true);
INSERT INTO public.customer VALUES ('GH-14485', 'Gene Hale', 2, true);
INSERT INTO public.customer VALUES ('GK-14620', 'Grace Kelly', 2, true);
INSERT INTO public.customer VALUES ('GM-14440', 'Gary McGarr', 1, true);
INSERT INTO public.customer VALUES ('GM-14455', 'Gary Mitchum', 3, true);
INSERT INTO public.customer VALUES ('GT-14635', 'Grant Thornton', 2, true);
INSERT INTO public.customer VALUES ('GT-14710', 'Greg Tran', 1, true);
INSERT INTO public.customer VALUES ('GT-14755', 'Guy Thornton', 1, true);
INSERT INTO public.customer VALUES ('GZ-14470', 'Gary Zandusky', 1, true);
INSERT INTO public.customer VALUES ('HK-14890', 'Heather Kirkland', 2, true);
INSERT INTO public.customer VALUES ('HM-14980', 'Henry MacAllister', 1, true);
INSERT INTO public.customer VALUES ('HW-14935', 'Helen Wasserman', 2, true);
INSERT INTO public.customer VALUES ('IM-15070', 'Irene Maddox', 1, true);
INSERT INTO public.customer VALUES ('JB-15400', 'Jennifer Braxton', 2, true);
INSERT INTO public.customer VALUES ('JC-15340', 'Jasper Cacioppo', 1, true);
INSERT INTO public.customer VALUES ('JC-16105', 'Julie Creighton', 2, true);
INSERT INTO public.customer VALUES ('JD-15895', 'Jonathan Doherty', 2, true);
INSERT INTO public.customer VALUES ('JD-16150', 'Justin Deggeller', 2, true);
INSERT INTO public.customer VALUES ('JE-15475', 'Jeremy Ellison', 1, true);
INSERT INTO public.customer VALUES ('JE-15745', 'Joel Eaton', 1, true);
INSERT INTO public.customer VALUES ('JE-16165', 'Justin Ellison', 2, true);
INSERT INTO public.customer VALUES ('JF-15355', 'Jay Fein', 1, true);
INSERT INTO public.customer VALUES ('JF-15415', 'Jennifer Ferguson', 1, true);
INSERT INTO public.customer VALUES ('JG-15805', 'John Grady', 2, true);
INSERT INTO public.customer VALUES ('JH-15910', 'Jonathan Howell', 1, true);
INSERT INTO public.customer VALUES ('JH-15985', 'Joseph Holt', 1, true);
INSERT INTO public.customer VALUES ('JK-15730', 'Joe Kamberova', 1, true);
INSERT INTO public.customer VALUES ('JL-15175', 'James Lanier', 3, true);
INSERT INTO public.customer VALUES ('JL-15505', 'Jeremy Lonsdale', 1, true);
INSERT INTO public.customer VALUES ('JL-15835', 'John Lee', 1, true);
INSERT INTO public.customer VALUES ('JL-15850', 'John Lucas', 1, true);
INSERT INTO public.customer VALUES ('JM-15250', 'Janet Martin', 1, true);
INSERT INTO public.customer VALUES ('JM-15265', 'Janet Molinari', 2, true);
INSERT INTO public.customer VALUES ('JS-15685', 'Jim Sink', 2, true);
INSERT INTO public.customer VALUES ('KB-16585', 'Ken Black', 2, true);
INSERT INTO public.customer VALUES ('KB-16600', 'Ken Brennan', 2, true);
INSERT INTO public.customer VALUES ('KC-16540', 'Kelly Collister', 1, true);
INSERT INTO public.customer VALUES ('KC-16675', 'Kimberly Carter', 2, true);
INSERT INTO public.customer VALUES ('KD-16270', 'Karen Daniels', 1, true);
INSERT INTO public.customer VALUES ('KD-16345', 'Katherine Ducich', 1, true);
INSERT INTO public.customer VALUES ('KH-16510', 'Keith Herrera', 1, true);
INSERT INTO public.customer VALUES ('KH-16630', 'Ken Heidel', 2, true);
INSERT INTO public.customer VALUES ('KH-16690', 'Kristen Hastings', 2, true);
INSERT INTO public.customer VALUES ('KL-16645', 'Ken Lonsdale', 1, true);
INSERT INTO public.customer VALUES ('KW-16435', 'Katrina Willman', 1, true);
INSERT INTO public.customer VALUES ('LC-16885', 'Lena Creighton', 1, true);
INSERT INTO public.customer VALUES ('LC-16930', 'Linda Cazamias', 2, true);
INSERT INTO public.customer VALUES ('LC-17140', 'Logan Currie', 1, true);
INSERT INTO public.customer VALUES ('LE-16810', 'Laurel Elliston', 1, true);
INSERT INTO public.customer VALUES ('LF-17185', 'Luke Foster', 1, true);
INSERT INTO public.customer VALUES ('LH-16900', 'Lena Hernandez', 1, true);
INSERT INTO public.customer VALUES ('LH-17155', 'Logan Haushalter', 1, true);
INSERT INTO public.customer VALUES ('LP-17080', 'Liz Pelletier', 1, true);
INSERT INTO public.customer VALUES ('LS-16945', 'Linda Southworth', 2, true);
INSERT INTO public.customer VALUES ('LS-16975', 'Lindsay Shagiari', 3, true);
INSERT INTO public.customer VALUES ('LS-17245', 'Lynn Smith', 1, true);
INSERT INTO public.customer VALUES ('MA-17560', 'Matt Abelman', 3, true);
INSERT INTO public.customer VALUES ('MB-17305', 'Maria Bertelson', 1, true);
INSERT INTO public.customer VALUES ('MC-17605', 'Matt Connell', 2, true);
INSERT INTO public.customer VALUES ('MC-18130', 'Mike Caudle', 2, true);
INSERT INTO public.customer VALUES ('ME-17725', 'Max Engle', 1, true);
INSERT INTO public.customer VALUES ('MJ-17740', 'Max Jones', 1, true);
INSERT INTO public.customer VALUES ('MK-17905', 'Michael Kennedy', 2, true);
INSERT INTO public.customer VALUES ('MM-18280', 'Muhammed MacIntyre', 2, true);
INSERT INTO public.customer VALUES ('MO-17800', 'Meg O''Connel', 3, true);
INSERT INTO public.customer VALUES ('MP-17965', 'Michael Paige', 2, true);
INSERT INTO public.customer VALUES ('MT-18070', 'Michelle Tran', 3, true);
INSERT INTO public.customer VALUES ('MV-18190', 'Mike Vittorini', 1, true);
INSERT INTO public.customer VALUES ('MY-17380', 'Maribeth Yedwab', 2, true);
INSERT INTO public.customer VALUES ('NB-18655', 'Nona Balk', 2, true);
INSERT INTO public.customer VALUES ('NF-18385', 'Natalie Fritzler', 1, true);
INSERT INTO public.customer VALUES ('NG-18355', 'Nat Gilpin', 2, true);
INSERT INTO public.customer VALUES ('NP-18670', 'Nora Paige', 1, true);
INSERT INTO public.customer VALUES ('NZ-18565', 'Nick Zandusky', 3, true);
INSERT INTO public.customer VALUES ('ON-18715', 'Odella Nelson', 2, true);
INSERT INTO public.customer VALUES ('OT-18730', 'Olvera Toch', 1, true);
INSERT INTO public.customer VALUES ('PB-19105', 'Peter Bhler', 1, true);
INSERT INTO public.customer VALUES ('PB-19150', 'Philip Brown', 1, true);
INSERT INTO public.customer VALUES ('PG-18895', 'Paul Gonzalez', 1, true);
INSERT INTO public.customer VALUES ('PH-18790', 'Patricia Hirasaki', 3, true);
INSERT INTO public.customer VALUES ('PJ-19015', 'Pauline Johnson', 1, true);
INSERT INTO public.customer VALUES ('PK-18910', 'Paul Knutson', 3, true);
INSERT INTO public.customer VALUES ('PK-19075', 'Pete Kriz', 1, true);
INSERT INTO public.customer VALUES ('PN-18775', 'Parhena Norris', 3, true);
INSERT INTO public.customer VALUES ('PO-18850', 'Patrick O''Brill', 1, true);
INSERT INTO public.customer VALUES ('PO-18865', 'Patrick O''Donnell', 1, true);
INSERT INTO public.customer VALUES ('PO-19180', 'Philisse Overcash', 3, true);
INSERT INTO public.customer VALUES ('RA-19285', 'Ralph Arnett', 1, true);
INSERT INTO public.customer VALUES ('RA-19885', 'Ruben Ausman', 2, true);
INSERT INTO public.customer VALUES ('RB-19360', 'Raymond Buch', 1, true);
INSERT INTO public.customer VALUES ('RB-19465', 'Rick Bensley', 3, true);
INSERT INTO public.customer VALUES ('RB-19570', 'Rob Beeghly', 1, true);
INSERT INTO public.customer VALUES ('RB-19705', 'Roger Barcio', 3, true);
INSERT INTO public.customer VALUES ('RB-19795', 'Ross Baird', 3, true);
INSERT INTO public.customer VALUES ('RC-19825', 'Roy Collins', 1, true);
INSERT INTO public.customer VALUES ('RC-19960', 'Ryan Crowe', 1, true);
INSERT INTO public.customer VALUES ('RD-19810', 'Ross DeVincentis', 3, true);
INSERT INTO public.customer VALUES ('RD-19900', 'Ruben Dartt', 1, true);
INSERT INTO public.customer VALUES ('RF-19735', 'Roland Fjeld', 1, true);
INSERT INTO public.customer VALUES ('RF-19840', 'Roy Franzsisch', 1, true);
INSERT INTO public.customer VALUES ('RH-19495', 'Rick Hansen', 1, true);
INSERT INTO public.customer VALUES ('RL-19615', 'Rob Lucas', 1, true);
INSERT INTO public.customer VALUES ('RO-19780', 'Rose O''Brian', 1, true);
INSERT INTO public.customer VALUES ('RS-19765', 'Roland Schwarz', 2, true);
INSERT INTO public.customer VALUES ('SC-20095', 'Sanjit Chand', 1, true);
INSERT INTO public.customer VALUES ('SC-20305', 'Sean Christensen', 1, true);
INSERT INTO public.customer VALUES ('SC-20695', 'Steve Chapman', 2, true);
INSERT INTO public.customer VALUES ('SC-20725', 'Steven Cartwright', 1, true);
INSERT INTO public.customer VALUES ('SC-20770', 'Stewart Carmichael', 2, true);
INSERT INTO public.customer VALUES ('SF-20065', 'Sandra Flanagan', 1, true);
INSERT INTO public.customer VALUES ('SF-20200', 'Sarah Foster', 1, true);
INSERT INTO public.customer VALUES ('SG-20080', 'Sandra Glassco', 1, true);
INSERT INTO public.customer VALUES ('SH-19975', 'Sally Hughsby', 2, true);
INSERT INTO public.customer VALUES ('SH-20395', 'Shahid Hopkins', 1, true);
INSERT INTO public.customer VALUES ('SJ-20125', 'Sanjit Jacobs', 3, true);
INSERT INTO public.customer VALUES ('SJ-20500', 'Shirley Jackson', 1, true);
INSERT INTO public.customer VALUES ('SK-19990', 'Sally Knutson', 1, true);
INSERT INTO public.customer VALUES ('SP-20545', 'Sibella Parks', 2, true);
INSERT INTO public.customer VALUES ('SP-20860', 'Sung Pak', 2, true);
INSERT INTO public.customer VALUES ('SR-20740', 'Steven Roelle', 3, true);
INSERT INTO public.customer VALUES ('SS-20140', 'Saphhira Shifley', 2, true);
INSERT INTO public.customer VALUES ('SS-20590', 'Sonia Sunley', 1, true);
INSERT INTO public.customer VALUES ('SS-20875', 'Sung Shariari', 1, true);
INSERT INTO public.customer VALUES ('TB-21055', 'Ted Butterfield', 1, true);
INSERT INTO public.customer VALUES ('TB-21520', 'Tracy Blumstein', 1, true);
INSERT INTO public.customer VALUES ('TB-21595', 'Troy Blackwell', 1, true);
INSERT INTO public.customer VALUES ('TD-20995', 'Tamara Dahlen', 1, true);
INSERT INTO public.customer VALUES ('TH-21235', 'Tiffany House', 2, true);
INSERT INTO public.customer VALUES ('TN-21040', 'Tanja Norvell', 3, true);
INSERT INTO public.customer VALUES ('TP-21130', 'Theone Pippenger', 1, true);
INSERT INTO public.customer VALUES ('TR-21325', 'Toby Ritter', 1, true);
INSERT INTO public.customer VALUES ('TS-21610', 'Troy Staebel', 1, true);
INSERT INTO public.customer VALUES ('TT-21070', 'Ted Trevino', 1, true);
INSERT INTO public.customer VALUES ('TW-21025', 'Tamara Willingham', 3, true);
INSERT INTO public.customer VALUES ('VB-21745', 'Victoria Brennan', 2, true);
INSERT INTO public.customer VALUES ('VD-21670', 'Valerie Dominguez', 1, true);
INSERT INTO public.customer VALUES ('VM-21685', 'Valerie Mitchum', 3, true);
INSERT INTO public.customer VALUES ('VP-21730', 'Victor Preis', 3, true);
INSERT INTO public.customer VALUES ('YC-21895', 'Yoseph Carroll', 2, true);
INSERT INTO public.customer VALUES ('ZC-21910', 'Zuschuss Carroll', 1, true);


--
-- Data for Name: order_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (1, 'CA-2019-100153', 'TEC-AC-10001772', 4, 63.88, 24.91, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (2, 'CA-2019-100790', 'OFF-ST-10000689', 5, 704.25, 84.51, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (3, 'CA-2019-100790', 'OFF-AR-10003045', 5, 14.70, 6.62, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (4, 'CA-2019-101343', 'OFF-ST-10003479', 2, 77.88, 3.89, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (5, 'CA-2019-103730', 'TEC-PH-10003875', 7, 68.04, 19.73, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (6, 'CA-2019-103730', 'OFF-ST-10000777', 6, 226.56, 63.44, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (7, 'CA-2019-103730', 'OFF-EN-10002500', 9, 115.02, 51.76, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (8, 'CA-2019-103730', 'OFF-BI-10003910', 4, 30.84, 13.88, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (9, 'CA-2019-103730', 'FUR-FU-10002157', 3, 47.04, 18.35, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (10, 'CA-2019-103891', 'TEC-PH-10000149', 6, 95.76, 7.18, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (11, 'CA-2019-103947', 'OFF-FA-10003112', 5, 31.56, 9.86, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (12, 'CA-2019-103947', 'OFF-AP-10002350', 2, 30.14, 3.01, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (13, 'CA-2019-105018', 'OFF-BI-10001890', 2, 7.16, 3.44, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (14, 'CA-2019-105256', 'TEC-PH-10001530', 5, 1363.96, 85.25, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (15, 'CA-2019-105816', 'TEC-PH-10002447', 5, 1029.95, 298.69, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (16, 'CA-2019-105816', 'OFF-FA-10000304', 7, 15.26, 6.26, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (17, 'CA-2019-106075', 'OFF-BI-10004654', 1, 4.62, 1.73, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (18, 'CA-2019-106341', 'OFF-AR-10002053', 3, 7.15, 0.72, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (19, 'CA-2019-108987', 'TEC-AC-10000158', 2, 57.58, 0.72, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (20, 'CA-2019-108987', 'OFF-ST-10001580', 3, 35.95, 3.60, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (21, 'CA-2019-108987', 'OFF-ST-10000934', 4, 131.14, -32.78, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (22, 'CA-2019-108987', 'FUR-BO-10004834', 4, 2396.27, -317.15, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (23, 'CA-2019-109806', 'TEC-PH-10004093', 2, 73.58, 8.28, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (24, 'CA-2019-109806', 'OFF-PA-10000304', 1, 6.48, 3.11, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (25, 'CA-2019-109806', 'OFF-AR-10004930', 3, 20.10, 6.63, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (26, 'CA-2019-109869', 'OFF-SU-10003505', 2, 185.38, -34.76, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (27, 'CA-2019-109869', 'OFF-BI-10000315', 5, 28.49, -20.89, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (28, 'CA-2019-109869', 'OFF-AP-10002578', 2, 78.27, 5.87, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (29, 'CA-2019-109869', 'FUR-TA-10001889', 6, 1272.63, -814.48, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (30, 'CA-2019-109869', 'FUR-FU-10000023', 5, 23.56, 7.07, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (31, 'CA-2019-110366', 'FUR-FU-10004848', 2, 82.80, 10.35, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (32, 'CA-2019-110499', 'TEC-CO-10002095', 3, 1199.98, 374.99, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (33, 'CA-2019-110772', 'TEC-AC-10002001', 2, 255.98, 54.40, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (34, 'CA-2019-110772', 'OFF-LA-10004689', 8, 18.50, 6.24, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (35, 'CA-2019-110772', 'OFF-FA-10002983', 7, 19.10, 6.68, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (36, 'CA-2019-110772', 'FUR-BO-10004709', 3, 86.97, -48.70, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (37, 'CA-2019-111010', 'OFF-FA-10003472', 6, 7.56, 0.30, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (38, 'CA-2019-111682', 'TEC-AC-10002167', 2, 30.00, 3.30, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (39, 'CA-2019-111682', 'OFF-ST-10000604', 6, 208.56, 52.14, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (40, 'CA-2019-111682', 'OFF-PA-10001569', 5, 32.40, 15.55, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (41, 'CA-2019-111682', 'OFF-PA-10000587', 2, 14.56, 6.99, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (42, 'CA-2019-111682', 'OFF-BI-10001460', 4, 48.48, 16.36, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (43, 'CA-2019-111682', 'OFF-AR-10001868', 1, 1.68, 0.84, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (44, 'CA-2019-111682', 'FUR-CH-10003968', 5, 319.41, 7.10, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (45, 'CA-2019-112697', 'OFF-SU-10000646', 5, 961.48, -204.31, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (46, 'CA-2019-112697', 'OFF-BI-10000778', 7, 254.06, -169.37, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (47, 'CA-2019-112697', 'OFF-AP-10002684', 2, 194.53, 24.32, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (48, 'CA-2019-112942', 'OFF-PA-10004092', 3, 146.82, 73.41, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (49, 'CA-2019-113243', 'OFF-PA-10003441', 5, 32.40, 15.55, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (50, 'CA-2019-113243', 'OFF-LA-10001297', 2, 20.70, 9.94, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (51, 'CA-2019-113243', 'FUR-TA-10004256', 4, 1335.68, -217.05, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (52, 'CA-2019-113747', 'OFF-AR-10003373', 6, 185.88, 50.19, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (53, 'CA-2019-113817', 'OFF-BI-10004002', 2, 27.68, 9.69, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (54, 'CA-2019-114104', 'TEC-PH-10004536', 7, 944.93, 236.23, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (55, 'CA-2019-114104', 'OFF-LA-10002475', 2, 14.62, 6.87, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (56, 'CA-2019-114489', 'TEC-PH-10001448', 3, 149.97, 6.00, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (57, 'CA-2019-114489', 'TEC-PH-10000215', 11, 384.45, 103.80, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (58, 'CA-2019-114489', 'OFF-BI-10002735', 5, 171.55, 80.63, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (59, 'CA-2019-114489', 'FUR-CH-10000454', 8, 1951.84, 585.55, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (60, 'CA-2019-114713', 'OFF-SU-10004664', 7, 45.58, 5.13, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (61, 'CA-2019-115504', 'OFF-PA-10003953', 2, 12.96, 6.22, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (62, 'CA-2019-115756', 'OFF-ST-10003058', 3, 70.95, 20.58, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (63, 'CA-2019-115756', 'OFF-ST-10000060', 3, 194.94, 23.39, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (64, 'CA-2019-115756', 'OFF-PA-10002222', 4, 91.36, 42.03, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (65, 'CA-2019-115756', 'OFF-LA-10001317', 7, 22.05, 10.58, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (66, 'CA-2019-115756', 'FUR-FU-10000246', 1, 12.22, 3.67, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (67, 'CA-2019-115756', 'FUR-CH-10002372', 3, 242.94, 29.15, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (68, 'CA-2019-115917', 'OFF-BI-10004728', 4, 15.42, 5.01, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (69, 'CA-2019-115917', 'FUR-FU-10000576', 5, 1049.20, 272.79, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (70, 'CA-2019-116736', 'TEC-AC-10003628', 1, 29.99, 13.20, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (71, 'CA-2019-116736', 'TEC-AC-10002049', 3, 371.97, 66.95, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (72, 'CA-2019-116736', 'FUR-FU-10004017', 3, 322.59, 64.52, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (73, 'CA-2019-117590', 'TEC-PH-10004977', 7, 1097.54, 123.47, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (74, 'CA-2019-117590', 'FUR-FU-10003664', 5, 190.92, -147.96, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (75, 'CA-2019-118255', 'TEC-AC-10000171', 2, 45.98, 19.77, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (76, 'CA-2019-118255', 'OFF-BI-10003291', 2, 17.46, 8.21, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (77, 'CA-2019-119823', 'OFF-PA-10000482', 2, 75.88, 35.66, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (78, 'CA-2019-120200', 'OFF-SU-10004115', 2, 11.63, 1.02, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (79, 'CA-2019-121223', 'TEC-PH-10004667', 9, 728.95, -157.94, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (80, 'CA-2019-121223', 'OFF-PA-10001204', 2, 8.45, 2.64, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (81, 'CA-2019-121755', 'TEC-AC-10003027', 3, 90.57, 11.77, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (82, 'CA-2019-121755', 'OFF-BI-10001634', 2, 11.65, 4.22, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (83, 'CA-2019-123274', 'OFF-ST-10000736', 3, 242.94, 9.72, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (84, 'CA-2019-123274', 'FUR-FU-10004090', 2, 44.46, 14.67, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (85, 'CA-2019-123666', 'OFF-ST-10001522', 5, 459.95, 18.40, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (86, 'CA-2019-125318', 'TEC-PH-10001433', 4, 328.22, 28.72, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (87, 'CA-2019-126158', 'OFF-BI-10002498', 8, 119.62, 40.37, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (88, 'CA-2019-126158', 'FUR-FU-10004864', 4, 255.76, 81.84, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (89, 'CA-2019-126158', 'FUR-FU-10000073', 9, 69.30, 22.87, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (90, 'CA-2019-126158', 'FUR-CH-10002602', 2, 241.57, 18.12, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (91, 'CA-2019-126613', 'OFF-ST-10001325', 2, 16.77, 1.47, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (92, 'CA-2019-127208', 'OFF-BI-10002309', 3, 16.74, 8.04, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (93, 'CA-2019-127208', 'OFF-AP-10002118', 1, 208.16, 56.20, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (94, 'CA-2019-127250', 'OFF-AR-10003394', 3, 8.82, 2.38, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (95, 'CA-2019-127369', 'OFF-ST-10003306', 5, 714.30, 207.15, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (96, 'CA-2019-128867', 'OFF-BI-10003981', 6, 27.24, 13.35, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (97, 'CA-2019-128867', 'OFF-AR-10000380', 2, 75.96, 22.79, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (98, 'CA-2019-129714', 'TEC-AC-10000290', 1, 6.79, 2.31, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (99, 'CA-2019-129714', 'OFF-PA-10001970', 2, 24.56, 11.54, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (100, 'CA-2019-129714', 'OFF-PA-10001970', 4, 49.12, 23.09, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (101, 'CA-2019-129714', 'OFF-BI-10004995', 4, 4355.17, 1415.43, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (102, 'CA-2019-129714', 'OFF-BI-10002160', 1, 3.05, 1.07, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (103, 'CA-2019-129903', 'OFF-PA-10004040', 4, 23.92, 11.72, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (104, 'CA-2019-130001', 'OFF-PA-10002666', 5, 36.24, 11.33, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (105, 'CA-2019-130162', 'TEC-PH-10002563', 3, 302.38, 22.68, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (106, 'CA-2019-130162', 'OFF-ST-10001328', 6, 93.06, 26.06, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (107, 'CA-2019-132661', 'OFF-PA-10000482', 10, 379.40, 178.32, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (108, 'CA-2019-134362', 'OFF-LA-10004853', 4, 15.94, 5.18, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (109, 'CA-2019-134474', 'TEC-PH-10002923', 2, 59.18, 5.18, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (110, 'CA-2019-134474', 'TEC-AC-10001714', 6, 191.47, 40.69, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (111, 'CA-2019-134474', 'OFF-AR-10003958', 2, 5.25, 0.59, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (112, 'CA-2019-134775', 'OFF-PA-10004734', 7, 50.96, 25.48, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (113, 'CA-2019-134775', 'OFF-BI-10002225', 3, 49.54, 17.34, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (114, 'CA-2019-136133', 'OFF-AP-10000576', 9, 355.32, 99.49, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (115, 'CA-2019-136406', 'FUR-CH-10002024', 2, 1121.57, 0.00, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (116, 'CA-2019-136924', 'TEC-PH-10002262', 8, 380.86, 38.09, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (117, 'CA-2019-137239', 'OFF-EN-10002230', 2, 134.29, 45.32, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (118, 'CA-2019-137239', 'OFF-BI-10002827', 2, 3.32, -2.65, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (119, 'CA-2019-137239', 'OFF-AP-10002439', 2, 113.55, 8.52, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (120, 'CA-2019-137330', 'OFF-AR-10000246', 7, 19.46, 5.06, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (121, 'CA-2019-137330', 'OFF-AP-10001492', 7, 60.34, 15.69, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (122, 'CA-2019-138520', 'OFF-PA-10002713', 5, 34.40, 15.82, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (123, 'CA-2019-138520', 'OFF-EN-10001137', 2, 8.26, 3.80, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (124, 'CA-2019-138520', 'OFF-AR-10002399', 4, 17.04, 6.99, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (125, 'CA-2019-138520', 'FUR-BO-10002268', 6, 388.70, -4.86, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (126, 'CA-2019-138688', 'OFF-LA-10000240', 2, 14.62, 6.87, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (127, 'CA-2019-140928', 'FUR-TA-10001095', 4, 383.44, -167.32, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (128, 'CA-2019-142335', 'OFF-ST-10000036', 3, 296.37, 80.02, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (129, 'CA-2019-142335', 'FUR-TA-10000198', 3, 1652.94, 231.41, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (130, 'CA-2019-142545', 'OFF-ST-10002756', 8, 1082.48, 10.82, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (131, 'CA-2019-142545', 'OFF-PA-10004243', 3, 56.91, 27.32, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (132, 'CA-2019-142545', 'OFF-PA-10002105', 5, 32.40, 15.55, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (133, 'CA-2019-142545', 'OFF-BI-10002706', 1, 14.28, 6.57, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (134, 'CA-2019-142545', 'FUR-FU-10001861', 4, 77.60, 38.02, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (135, 'CA-2019-142902', 'OFF-LA-10000634', 3, 6.26, 2.04, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (136, 'CA-2019-142902', 'FUR-FU-10001918', 4, 15.14, 3.59, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (137, 'CA-2019-142902', 'FUR-FU-10001756', 1, 15.23, 1.71, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (138, 'CA-2019-142902', 'FUR-CH-10004086', 2, 466.77, 52.51, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (139, 'CA-2019-143308', 'OFF-FA-10000621', 3, 10.74, 5.26, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (140, 'CA-2019-145583', 'OFF-SU-10001218', 6, 65.88, 18.45, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (141, 'CA-2019-145583', 'OFF-PA-10001804', 3, 20.04, 9.62, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (142, 'CA-2019-145583', 'OFF-PA-10001736', 1, 35.44, 16.66, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (143, 'CA-2019-145583', 'OFF-FA-10002988', 2, 4.02, 1.97, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (144, 'CA-2019-145583', 'OFF-BI-10004781', 3, 76.18, 26.66, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (145, 'CA-2019-145583', 'OFF-AR-10001149', 4, 11.52, 3.46, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (146, 'CA-2019-145583', 'FUR-FU-10001706', 14, 43.12, 20.70, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (147, 'CA-2019-145625', 'TEC-AC-10003832', 13, 3347.37, 636.00, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (148, 'CA-2019-145625', 'OFF-PA-10004569', 1, 7.61, 3.58, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (149, 'CA-2019-146941', 'OFF-ST-10001228', 6, 80.58, 22.56, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (150, 'CA-2019-146941', 'OFF-EN-10003296', 4, 361.92, 162.86, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (151, 'CA-2019-147067', 'FUR-FU-10000732', 3, 18.84, 6.03, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (152, 'CA-2019-147375', 'TEC-MA-10002937', 3, 1007.98, 43.20, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (153, 'CA-2019-147375', 'OFF-PA-10001970', 7, 313.49, 113.64, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (154, 'CA-2019-148796', 'FUR-CH-10004886', 5, 383.80, 38.38, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (155, 'CA-2019-149223', 'OFF-AP-10000358', 6, 77.88, 22.59, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (156, 'CA-2019-149370', 'OFF-PA-10003651', 1, 5.34, 1.87, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (157, 'CA-2019-150889', 'TEC-PH-10000004', 1, 11.99, 0.90, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (158, 'CA-2019-152156', 'FUR-CH-10000454', 3, 731.94, 219.58, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (159, 'CA-2019-152156', 'FUR-BO-10001798', 2, 261.96, 41.91, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (160, 'CA-2019-152534', 'OFF-PA-10001870', 6, 38.88, 18.66, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (161, 'CA-2019-152534', 'OFF-AR-10002335', 2, 5.16, 1.34, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (162, 'CA-2019-152632', 'FUR-FU-10002671', 3, 40.20, 19.30, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (163, 'CA-2019-154508', 'OFF-EN-10001990', 5, 28.40, 13.35, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (164, 'CA-2019-154739', 'FUR-CH-10002965', 2, 321.57, 28.14, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (165, 'CA-2019-155516', 'OFF-SU-10001225', 2, 7.36, 0.15, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (166, 'CA-2019-155516', 'OFF-ST-10002406', 7, 104.79, 29.34, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (167, 'CA-2019-155516', 'OFF-BI-10002412', 4, 23.20, 10.44, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (168, 'CA-2019-155516', 'FUR-BO-10002545', 4, 1043.92, 271.42, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (169, 'CA-2019-157000', 'OFF-ST-10001328', 3, 37.22, 3.72, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (170, 'CA-2019-157000', 'OFF-PA-10001950', 3, 20.02, 6.26, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (171, 'CA-2019-157245', 'FUR-CH-10003746', 2, 641.96, 179.75, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (172, 'CA-2019-157749', 'TEC-PH-10000011', 2, 31.98, 11.19, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (173, 'CA-2019-157749', 'OFF-PA-10003349', 5, 25.92, 9.40, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (174, 'CA-2019-157749', 'OFF-AR-10004685', 2, 7.41, 1.20, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (175, 'CA-2019-157749', 'FUR-TA-10002607', 5, 177.23, -120.51, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (176, 'CA-2019-157749', 'FUR-FU-10004351', 3, 11.69, -4.68, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (177, 'CA-2019-157749', 'FUR-FU-10002505', 3, 4.04, -2.83, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (178, 'CA-2019-157749', 'FUR-FU-10000576', 5, 419.68, -356.73, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (179, 'CA-2019-158099', 'TEC-PH-10002496', 3, 280.78, -46.80, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (180, 'CA-2019-158099', 'OFF-BI-10000545', 5, 1141.47, -760.98, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (181, 'CA-2019-158568', 'TEC-AC-10001767', 3, 95.98, -10.80, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (182, 'CA-2019-158568', 'OFF-PA-10003256', 7, 64.62, 22.62, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (183, 'CA-2019-158568', 'OFF-BI-10002609', 3, 1.79, -3.04, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (184, 'CA-2019-158834', 'TEC-PH-10001254', 2, 203.18, 15.24, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (185, 'CA-2019-158834', 'OFF-AP-10000326', 5, 157.92, 17.77, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (186, 'CA-2019-159695', 'OFF-ST-10003442', 7, 158.37, 13.86, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (187, 'CA-2019-160745', 'TEC-PH-10003273', 3, 302.38, 22.68, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (188, 'CA-2019-160745', 'TEC-AC-10001142', 4, 316.00, 31.60, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (189, 'CA-2019-160745', 'FUR-FU-10001935', 4, 14.80, 6.07, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (190, 'CA-2019-161389', 'OFF-BI-10003656', 3, 407.98, 132.59, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (191, 'CA-2019-161669', 'OFF-SU-10002503', 2, 11.36, 3.29, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (192, 'CA-2019-161669', 'OFF-LA-10004093', 2, 14.62, 6.87, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (193, 'CA-2019-161669', 'OFF-BI-10001636', 4, 26.98, 8.77, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (194, 'CA-2019-161669', 'OFF-BI-10001294', 4, 37.44, 11.70, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (195, 'CA-2019-161816', 'TEC-PH-10003012', 3, 369.58, 41.58, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (196, 'CA-2019-161816', 'OFF-LA-10004345', 4, 15.71, 5.70, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (197, 'CA-2019-162138', 'TEC-AC-10001908', 1, 99.99, 35.00, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (198, 'CA-2019-162138', 'OFF-BI-10004593', 6, 251.52, 81.74, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (199, 'CA-2019-162733', 'OFF-PA-10002751', 1, 5.98, 2.69, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (200, 'CA-2019-163755', 'FUR-FU-10003394', 3, 209.88, 35.68, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (201, 'CA-2019-164511', 'OFF-ST-10004507', 4, 68.60, 18.52, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (202, 'CA-2019-164511', 'OFF-ST-10002583', 2, 64.96, 2.60, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (203, 'CA-2019-164511', 'OFF-BI-10003305', 3, 14.35, 4.66, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (204, 'CA-2019-165316', 'TEC-MA-10004002', 1, 265.48, -111.50, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (205, 'CA-2019-165316', 'OFF-AR-10002956', 2, 35.22, 2.64, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (206, 'CA-2019-165316', 'OFF-AP-10003266', 2, 23.70, 6.52, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (207, 'CA-2019-166674', 'TEC-PH-10002365', 4, 35.12, 9.13, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (208, 'CA-2019-166674', 'OFF-ST-10001469', 3, 161.94, 9.72, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (209, 'CA-2019-166674', 'OFF-AR-10004974', 3, 9.84, 2.85, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (210, 'CA-2019-166674', 'OFF-AR-10003156', 3, 30.48, 7.92, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (211, 'CA-2019-166674', 'OFF-AR-10001953', 6, 263.88, 71.25, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (212, 'CA-2019-166674', 'OFF-AR-10000588', 3, 59.52, 15.48, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (213, 'CA-2019-168753', 'TEC-PH-10000984', 5, 979.95, 274.39, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (214, 'CA-2019-168753', 'OFF-BI-10002557', 5, 22.75, 11.38, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (215, 'CA-2019-169166', 'TEC-AC-10000991', 2, 93.98, 13.16, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (216, 'CA-2019-169194', 'TEC-PH-10003988', 2, 21.80, 6.10, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (217, 'CA-2019-169194', 'TEC-AC-10002167', 3, 45.00, 4.95, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (218, 'CA-2020-100650', 'OFF-ST-10001780', 2, 1295.78, 310.99, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (219, 'CA-2020-101434', 'TEC-AC-10002402', 3, 239.97, 71.99, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (220, 'CA-2020-101434', 'OFF-LA-10003223', 2, 9.82, 4.81, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (221, 'CA-2020-101798', 'TEC-AC-10001998', 2, 39.98, 13.59, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (222, 'CA-2020-101798', 'OFF-BI-10000050', 4, 23.36, 7.88, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (223, 'CA-2020-101945', 'OFF-FA-10004248', 3, 10.82, 2.57, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (224, 'CA-2020-102946', 'OFF-BI-10004492', 3, 75.79, 25.58, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (225, 'CA-2020-104220', 'TEC-PH-10004614', 3, 207.00, 51.75, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (226, 'CA-2020-104220', 'OFF-BI-10003910', 1, 7.71, 3.47, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (227, 'CA-2020-104220', 'OFF-BI-10001036', 2, 18.28, 9.14, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (228, 'CA-2020-104220', 'OFF-BI-10000301', 5, 32.35, 16.18, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (229, 'CA-2020-104220', 'OFF-AR-10004648', 2, 40.30, 10.88, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (230, 'CA-2020-104220', 'FUR-FU-10002597', 7, 34.58, 14.52, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (231, 'CA-2020-104745', 'OFF-ST-10002205', 3, 53.42, 4.67, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (232, 'CA-2020-104745', 'OFF-PA-10002036', 5, 25.92, 9.40, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (233, 'CA-2020-105074', 'OFF-PA-10002666', 3, 21.74, 6.80, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (234, 'CA-2020-105809', 'TEC-PH-10001580', 2, 215.97, 18.90, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (235, 'CA-2020-105809', 'FUR-FU-10004090', 1, 22.23, 7.34, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (236, 'CA-2020-106103', 'TEC-AC-10003832', 4, 132.52, 54.33, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (237, 'CA-2020-106180', 'OFF-PA-10004327', 3, 143.70, 68.98, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (238, 'CA-2020-106180', 'OFF-EN-10004030', 3, 10.86, 5.10, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (239, 'CA-2020-106180', 'OFF-AR-10000940', 3, 8.82, 2.38, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (240, 'CA-2020-107503', 'FUR-FU-10003878', 4, 48.90, 8.56, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (241, 'CA-2020-107720', 'OFF-ST-10001414', 3, 46.26, 12.03, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (242, 'CA-2020-107727', 'OFF-PA-10000249', 3, 29.47, 9.95, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (243, 'CA-2020-108329', 'TEC-PH-10001918', 4, 444.77, 44.48, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (244, 'CA-2020-108910', 'FUR-FU-10002253', 3, 103.06, 24.48, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (245, 'CA-2020-110478', 'OFF-EN-10000483', 1, 15.25, 7.02, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (246, 'CA-2020-110478', 'OFF-AR-10001573', 4, 9.32, 2.70, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (247, 'CA-2020-111178', 'OFF-AR-10001954', 5, 19.56, 1.71, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (248, 'CA-2020-112774', 'FUR-FU-10003039', 1, 34.50, 6.04, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (249, 'CA-2020-113558', 'FUR-FU-10001756', 3, 45.70, 5.14, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (250, 'CA-2020-113558', 'FUR-CH-10003379', 3, 683.95, 42.75, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (251, 'CA-2020-114412', 'OFF-PA-10002365', 3, 15.55, 5.44, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (252, 'CA-2020-114440', 'OFF-PA-10004675', 3, 19.05, 8.76, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (253, 'CA-2020-114552', 'FUR-FU-10002960', 3, 15.07, 4.14, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (254, 'CA-2020-114636', 'OFF-PA-10001790', 5, 192.16, 67.26, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (255, 'CA-2020-117240', 'OFF-BI-10000848', 3, 13.13, 4.27, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (256, 'CA-2020-117457', 'TEC-CO-10004115', 3, 1199.98, 434.99, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (257, 'CA-2020-117457', 'TEC-AC-10000158', 5, 179.95, 37.79, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (258, 'CA-2020-117457', 'OFF-PA-10003724', 5, 27.15, 13.30, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (259, 'CA-2020-117457', 'OFF-PA-10002893', 1, 9.68, 4.65, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (260, 'CA-2020-117457', 'OFF-PA-10001970', 1, 55.98, 27.43, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (261, 'CA-2020-117457', 'OFF-LA-10003766', 9, 28.35, 13.61, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (262, 'CA-2020-117457', 'FUR-TA-10002041', 7, 1004.02, -112.95, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (263, 'CA-2020-117457', 'FUR-CH-10003956', 2, 113.57, -18.45, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (264, 'CA-2020-117457', 'FUR-BO-10001972', 13, 1336.83, 31.45, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (265, 'CA-2020-117933', 'OFF-AP-10004249', 3, 35.91, 9.70, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (266, 'CA-2020-117947', 'TEC-PH-10002538', 1, 37.91, 10.99, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (267, 'CA-2020-117947', 'OFF-BI-10002824', 9, 107.42, 33.57, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (268, 'CA-2020-117947', 'FUR-FU-10003849', 2, 40.48, 15.79, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (269, 'CA-2020-117947', 'FUR-FU-10000521', 3, 88.02, 27.29, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (270, 'CA-2020-117947', 'FUR-FU-10000010', 2, 9.94, 3.08, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (271, 'CA-2020-118136', 'OFF-PA-10002615', 2, 8.82, 4.06, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (272, 'CA-2020-118136', 'OFF-AR-10001427', 1, 5.98, 1.55, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (273, 'CA-2020-118640', 'OFF-ST-10002974', 2, 69.71, 8.71, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (274, 'CA-2020-118640', 'FUR-FU-10001475', 1, 8.79, -5.71, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (275, 'CA-2020-118731', 'OFF-BI-10000069', 7, 84.06, 27.32, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (276, 'CA-2020-118731', 'FUR-FU-10003347', 3, 42.60, 16.61, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (277, 'CA-2020-119004', 'TEC-PH-10002844', 1, 27.99, 2.10, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (278, 'CA-2020-119004', 'TEC-AC-10003499', 8, 74.11, 17.60, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (279, 'CA-2020-119004', 'OFF-AR-10000390', 1, 3.30, 1.07, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (280, 'CA-2020-120999', 'TEC-PH-10004093', 4, 147.17, 16.56, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (281, 'CA-2020-122105', 'OFF-AR-10004344', 8, 95.92, 25.90, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (282, 'CA-2020-125388', 'OFF-ST-10000918', 3, 32.70, 8.50, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (283, 'CA-2020-125388', 'FUR-FU-10004712', 4, 56.56, 14.71, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (284, 'CA-2020-126046', 'OFF-LA-10004484', 3, 12.39, 5.70, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (285, 'CA-2020-126074', 'OFF-BI-10003638', 3, 58.05, 26.70, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (286, 'CA-2020-126074', 'OFF-BI-10000546', 1, 2.88, 1.41, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (287, 'CA-2020-126074', 'OFF-AR-10003478', 7, 56.98, 22.79, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (288, 'CA-2020-126074', 'FUR-FU-10003577', 11, 157.74, 56.79, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (289, 'CA-2020-126382', 'FUR-FU-10002960', 7, 35.17, 9.67, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (290, 'CA-2020-126774', 'OFF-AR-10002804', 1, 4.89, 2.00, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (291, 'CA-2020-126956', 'OFF-SU-10000381', 4, 37.24, 10.80, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (292, 'CA-2020-126956', 'OFF-FA-10002280', 7, 35.00, 16.80, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (293, 'CA-2020-126956', 'OFF-EN-10004459', 2, 15.28, 7.49, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (294, 'CA-2020-127432', 'TEC-CO-10003236', 5, 2999.95, 1379.98, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (295, 'CA-2020-127432', 'OFF-ST-10004507', 3, 51.45, 13.89, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (296, 'CA-2020-127432', 'OFF-ST-10004459', 3, 1126.02, 56.30, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (297, 'CA-2020-127432', 'OFF-PA-10001667', 2, 11.96, 5.38, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (298, 'CA-2020-129462', 'TEC-PH-10002085', 1, 65.99, 17.16, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (299, 'CA-2020-129462', 'TEC-PH-10001557', 2, 191.98, 51.83, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (300, 'CA-2020-129462', 'OFF-AP-10003884', 3, 180.66, 50.58, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (301, 'CA-2020-129462', 'FUR-CH-10000665', 2, 301.96, 90.59, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (302, 'CA-2020-129567', 'OFF-BI-10000014', 2, 17.46, 5.89, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (303, 'CA-2020-130043', 'OFF-PA-10002230', 8, 31.87, 11.55, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (304, 'CA-2020-130351', 'TEC-AC-10003832', 3, 99.39, 40.75, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (305, 'CA-2020-130351', 'OFF-PA-10002137', 5, 38.90, 17.51, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (306, 'CA-2020-130351', 'OFF-AP-10004532', 3, 61.44, 16.59, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (307, 'CA-2020-131954', 'TEC-AC-10003610', 3, 179.97, 86.39, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (308, 'CA-2020-131954', 'OFF-ST-10000736', 3, 242.94, 9.72, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (309, 'CA-2020-131954', 'OFF-BI-10003982', 6, 99.70, 33.65, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (310, 'CA-2020-131954', 'OFF-BI-10003291', 4, 27.94, 9.43, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (311, 'CA-2020-131954', 'OFF-BI-10000138', 5, 18.72, 6.55, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (312, 'CA-2020-131954', 'FUR-BO-10001619', 1, 84.98, 18.70, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (313, 'CA-2020-132682', 'TEC-PH-10004042', 3, 381.58, 28.62, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (314, 'CA-2020-132682', 'OFF-SU-10004231', 3, 23.76, 2.08, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (315, 'CA-2020-132682', 'OFF-PA-10000474', 3, 85.06, 28.71, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (316, 'CA-2020-132976', 'OFF-ST-10000876', 6, 59.71, 5.97, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (317, 'CA-2020-132976', 'OFF-PA-10004470', 4, 18.18, 5.91, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (318, 'CA-2020-132976', 'OFF-PA-10000673', 2, 11.65, 4.08, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (319, 'CA-2020-132976', 'OFF-LA-10002043', 3, 24.84, 8.69, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (320, 'CA-2020-133333', 'OFF-PA-10002377', 4, 22.72, 10.22, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (321, 'CA-2020-133431', 'OFF-PA-10002615', 3, 13.23, 6.09, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (322, 'CA-2020-133431', 'OFF-BI-10000605', 5, 15.24, 5.14, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (323, 'CA-2020-134306', 'OFF-PA-10000249', 2, 24.56, 11.54, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (324, 'CA-2020-134306', 'OFF-AR-10004027', 3, 7.56, 3.10, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (325, 'CA-2020-134306', 'OFF-AR-10001374', 2, 12.96, 4.15, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (326, 'CA-2020-134978', 'OFF-BI-10003274', 5, 15.92, 5.37, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (327, 'CA-2020-135307', 'TEC-AC-10002399', 2, 38.04, 12.17, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (328, 'CA-2020-135307', 'FUR-FU-10001290', 3, 126.30, 40.42, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (329, 'CA-2020-135783', 'FUR-FU-10000794', 2, 18.28, 6.22, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (330, 'CA-2020-135860', 'TEC-PH-10001700', 2, 131.98, 35.63, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (331, 'CA-2020-135860', 'OFF-ST-10001522', 1, 91.99, 3.68, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (332, 'CA-2020-135860', 'OFF-ST-10000642', 4, 83.92, 5.87, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (333, 'CA-2020-135860', 'OFF-FA-10000134', 9, 52.29, 16.21, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (334, 'CA-2020-135860', 'OFF-BI-10003274', 4, 15.92, 7.48, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (335, 'CA-2020-136826', 'OFF-AR-10003602', 3, 14.02, 4.73, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (336, 'CA-2020-137099', 'TEC-PH-10002496', 3, 374.38, 46.80, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (337, 'CA-2020-138611', 'TEC-PH-10000011', 10, 119.94, 15.99, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (338, 'CA-2020-138611', 'OFF-BI-10002949', 2, 3.65, -2.80, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (339, 'CA-2020-139619', 'OFF-ST-10003282', 2, 95.62, 9.56, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (340, 'CA-2020-140088', 'FUR-CH-10000863', 2, 301.96, 33.22, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (341, 'CA-2020-140844', 'TEC-AC-10001101', 8, 103.12, 10.31, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (342, 'CA-2020-140844', 'OFF-PA-10003892', 2, 97.82, 45.98, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (343, 'CA-2020-140963', 'TEC-PH-10001924', 5, 279.96, 17.50, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (344, 'CA-2020-140963', 'OFF-LA-10003923', 2, 29.60, 14.80, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (345, 'CA-2020-140963', 'FUR-BO-10001337', 5, 514.17, -30.25, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (346, 'CA-2020-142636', 'OFF-PA-10000157', 7, 139.86, 65.73, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (347, 'CA-2020-142636', 'FUR-CH-10001891', 4, 307.14, 26.87, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (348, 'CA-2020-143686', 'TEC-AC-10001838', 7, 1399.93, 601.97, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (349, 'CA-2020-143686', 'FUR-FU-10000794', 2, 18.28, 6.22, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (350, 'CA-2020-144113', 'TEC-PH-10002170', 1, 55.99, 5.60, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (351, 'CA-2020-144113', 'OFF-EN-10001141', 2, 17.57, 6.37, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (352, 'CA-2020-144694', 'TEC-AC-10002857', 3, 17.88, 2.46, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (353, 'CA-2020-144694', 'OFF-LA-10003930', 3, 235.94, 85.53, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (354, 'CA-2020-144904', 'OFF-LA-10001158', 2, 20.70, 9.94, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (355, 'CA-2020-144904', 'OFF-AR-10003732', 2, 5.56, 1.45, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (356, 'CA-2020-144904', 'FUR-FU-10000023', 8, 47.12, 20.73, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (357, 'CA-2020-144904', 'FUR-CH-10000785', 3, 488.65, 86.87, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (358, 'CA-2020-145142', 'FUR-TA-10001857', 2, 210.98, 21.10, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (359, 'CA-2020-145233', 'TEC-PH-10004977', 3, 470.38, 52.92, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (360, 'CA-2020-145233', 'TEC-PH-10001254', 4, 406.37, 30.48, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (361, 'CA-2020-145233', 'TEC-PH-10000586', 2, 105.58, 9.24, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (362, 'CA-2020-145233', 'OFF-BI-10002764', 7, 6.78, -4.75, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (363, 'CA-2020-145233', 'OFF-AP-10000358', 3, 31.15, 3.50, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (364, 'CA-2020-146136', 'OFF-EN-10001219', 4, 24.45, 8.86, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (365, 'CA-2020-146780', 'FUR-FU-10001934', 2, 41.96, 10.91, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (366, 'CA-2020-147277', 'OFF-ST-10000142', 2, 665.41, 66.54, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (367, 'CA-2020-147277', 'FUR-TA-10001539', 2, 284.36, -75.83, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (368, 'CA-2020-149160', 'OFF-BI-10001543', 8, 287.92, 138.20, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (369, 'CA-2020-149160', 'FUR-FU-10003347', 2, 28.40, 11.08, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (370, 'CA-2020-151428', 'OFF-BI-10000546', 7, 20.16, 9.88, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (371, 'CA-2020-152275', 'OFF-AR-10000369', 6, 6.67, 0.50, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (372, 'CA-2020-153339', 'FUR-FU-10001967', 1, 15.99, 1.00, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (373, 'CA-2020-153787', 'OFF-AP-10001563', 2, 97.16, 28.18, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (374, 'CA-2020-154214', 'FUR-FU-10000206', 1, 2.91, 1.37, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (375, 'CA-2020-154816', 'OFF-PA-10003845', 1, 5.78, 2.83, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (376, 'CA-2020-154907', 'FUR-BO-10002824', 2, 205.33, -36.24, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (377, 'CA-2020-155376', 'OFF-AP-10001058', 3, 839.43, 218.25, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (378, 'CA-2020-155558', 'TEC-AC-10001998', 1, 19.99, 6.80, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (379, 'CA-2020-155558', 'OFF-LA-10000134', 2, 6.16, 2.96, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (380, 'CA-2020-155698', 'OFF-LA-10001158', 2, 20.70, 9.94, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (381, 'CA-2020-155698', 'OFF-AP-10001124', 8, 647.84, 168.44, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (382, 'CA-2020-155705', 'FUR-CH-10000015', 4, 866.40, 225.26, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (383, 'CA-2020-156951', 'OFF-PA-10004530', 8, 91.84, 45.00, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (384, 'CA-2020-156951', 'OFF-PA-10004451', 3, 19.44, 9.33, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (385, 'CA-2020-156951', 'OFF-BI-10001107', 7, 81.09, 27.37, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (386, 'CA-2020-156951', 'FUR-CH-10004997', 3, 451.15, 0.00, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (387, 'CA-2020-157252', 'FUR-CH-10003396', 3, 207.85, 2.31, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (388, 'CA-2020-157833', 'OFF-BI-10001721', 3, 51.31, 17.96, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (389, 'CA-2020-160514', 'OFF-PA-10002479', 2, 10.56, 4.75, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (390, 'CA-2020-161018', 'FUR-FU-10000629', 7, 96.53, 40.54, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (391, 'CA-2020-161480', 'FUR-BO-10004015', 2, 191.98, 4.80, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (392, 'CA-2020-161984', 'OFF-PA-10004569', 1, 7.61, 3.58, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (393, 'CA-2020-161984', 'OFF-FA-10000624', 2, 7.16, 3.58, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (394, 'CA-2020-162929', 'OFF-PA-10002986', 2, 13.36, 6.41, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (395, 'CA-2020-162929', 'OFF-BI-10000404', 6, 41.28, 13.93, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (396, 'CA-2020-163020', 'FUR-FU-10000221', 7, 35.56, 12.09, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (397, 'CA-2020-163139', 'TEC-AC-10000290', 3, 20.37, 6.93, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (398, 'CA-2020-163139', 'OFF-ST-10002790', 3, 221.55, 6.65, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (399, 'CA-2020-163139', 'OFF-BI-10003460', 5, 17.52, 6.13, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (400, 'CA-2020-163405', 'OFF-AR-10003811', 3, 6.63, 1.79, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (401, 'CA-2020-163405', 'OFF-AR-10001246', 2, 5.88, 1.71, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (402, 'CA-2020-165603', 'OFF-ST-10000798', 2, 49.96, 9.49, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (403, 'CA-2020-165603', 'OFF-PA-10002552', 2, 12.96, 6.22, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (404, 'CA-2020-167913', 'OFF-ST-10000585', 2, 330.40, 85.90, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (405, 'CA-2020-167913', 'OFF-LA-10002787', 7, 26.25, 12.60, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (406, 'CA-2020-169901', 'TEC-PH-10002293', 3, 47.98, 4.80, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (407, 'US-2019-100419', 'OFF-BI-10002194', 3, 4.79, -7.90, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (408, 'US-2019-100720', 'TEC-PH-10003963', 4, 494.38, -115.35, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (409, 'US-2019-100720', 'TEC-PH-10001425', 3, 143.98, -28.80, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (410, 'US-2019-100720', 'OFF-SU-10001574', 2, 5.84, 0.73, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (411, 'US-2019-105578', 'OFF-PA-10000357', 1, 32.79, 11.89, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (412, 'US-2019-105578', 'OFF-BI-10001670', 2, 22.62, -15.08, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (413, 'US-2019-105578', 'OFF-BI-10001658', 2, 14.95, -11.96, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (414, 'US-2019-105578', 'OFF-BI-10000831', 3, 2.38, -1.90, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (415, 'US-2019-105578', 'FUR-CH-10001215', 2, 801.57, 50.10, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (416, 'US-2019-120929', 'FUR-TA-10001857', 3, 189.88, -94.94, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (417, 'US-2019-123470', 'OFF-BI-10001989', 3, 18.88, -13.85, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (418, 'US-2019-123470', 'OFF-AP-10003287', 3, 122.33, 12.23, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (419, 'US-2019-123750', 'TEC-AC-10004659', 7, 408.74, 76.64, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (420, 'US-2019-123750', 'TEC-AC-10004659', 5, 291.96, 54.74, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (421, 'US-2019-123750', 'OFF-ST-10000617', 2, 4.77, -0.77, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (422, 'US-2019-123750', 'OFF-BI-10004584', 2, 189.59, -145.35, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (423, 'US-2019-125969', 'FUR-FU-10003773', 3, 238.56, 26.24, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (424, 'US-2019-125969', 'FUR-CH-10001146', 2, 81.42, -9.16, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (425, 'US-2019-134656', 'OFF-PA-10003039', 4, 99.14, 30.98, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (426, 'US-2019-135720', 'TEC-PH-10002103', 4, 300.77, 30.08, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (427, 'US-2019-135720', 'TEC-AC-10001267', 5, 119.80, 29.95, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (428, 'US-2019-135720', 'OFF-ST-10001963', 3, 243.38, -51.72, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (429, 'US-2019-137547', 'TEC-PH-10002365', 3, 21.07, 1.58, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (430, 'US-2019-139486', 'TEC-PH-10003555', 3, 55.18, -12.41, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (431, 'US-2019-139486', 'TEC-AC-10003832', 2, 66.26, 27.17, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (432, 'US-2019-141544', 'TEC-PH-10003645', 3, 290.90, -67.88, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (433, 'US-2019-141544', 'OFF-ST-10000675', 2, 54.22, 3.39, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (434, 'US-2019-141544', 'OFF-LA-10001074', 10, 100.24, 33.83, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (435, 'US-2019-141544', 'OFF-BI-10001524', 6, 37.76, -27.69, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (436, 'US-2019-141544', 'FUR-CH-10003312', 4, 786.74, -258.50, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (437, 'US-2019-146710', 'OFF-SU-10004498', 5, 51.52, -10.95, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (438, 'US-2019-146710', 'OFF-SU-10004261', 4, 55.17, 6.21, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (439, 'US-2019-146710', 'OFF-PA-10004971', 1, 4.62, 1.68, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (440, 'US-2019-146710', 'OFF-PA-10002615', 1, 3.53, 1.15, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (441, 'US-2019-150147', 'TEC-PH-10004614', 2, 82.80, -20.70, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (442, 'US-2019-150147', 'OFF-BI-10001982', 3, 4.90, -3.43, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (443, 'US-2019-150147', 'OFF-BI-10001153', 2, 20.72, -13.82, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (444, 'US-2019-150861', 'OFF-ST-10004634', 3, 33.63, 10.09, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (445, 'US-2019-150861', 'OFF-PA-10001954', 8, 182.72, 84.05, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (446, 'US-2019-150861', 'OFF-LA-10001317', 2, 6.30, 3.02, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (447, 'US-2019-150861', 'FUR-TA-10002228', 2, 400.03, -153.35, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (448, 'US-2019-150861', 'FUR-CH-10002965', 3, 542.65, 102.50, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (449, 'US-2019-156097', 'OFF-BI-10004654', 2, 2.31, -3.46, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (450, 'US-2019-156097', 'FUR-CH-10001215', 2, 701.37, -50.10, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (451, 'US-2019-156986', 'TEC-PH-10003800', 2, 84.78, -20.14, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (452, 'US-2019-156986', 'OFF-PA-10004101', 2, 10.37, 3.63, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (453, 'US-2019-156986', 'OFF-PA-10002005', 4, 20.74, 7.26, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (454, 'US-2019-156986', 'OFF-BI-10002498', 3, 16.82, -12.90, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (455, 'US-2019-157945', 'OFF-EN-10001415', 2, 8.93, 3.35, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (456, 'US-2019-157945', 'FUR-CH-10002331', 3, 747.56, -96.11, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (457, 'US-2020-100048', 'TEC-PH-10003012', 2, 307.98, 89.31, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (458, 'US-2020-100048', 'TEC-AC-10001606', 3, 299.97, 113.99, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (459, 'US-2020-100048', 'OFF-AP-10001154', 6, 281.34, 109.72, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (460, 'US-2020-100930', 'TEC-AC-10003832', 3, 617.98, -7.72, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (461, 'US-2020-100930', 'OFF-BI-10001679', 2, 5.33, -3.55, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (462, 'US-2020-100930', 'FUR-TA-10003473', 3, 620.61, -248.25, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (463, 'US-2020-100930', 'FUR-TA-10001705', 2, 233.86, -102.05, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (464, 'US-2020-100930', 'FUR-FU-10004017', 3, 258.07, 0.00, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (465, 'US-2020-106663', 'OFF-PA-10002377', 8, 36.35, 11.36, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (466, 'US-2020-106663', 'FUR-TA-10000688', 1, 108.93, -71.89, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (467, 'US-2020-106663', 'FUR-FU-10002759', 3, 23.98, -14.39, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (468, 'US-2020-107272', 'OFF-ST-10002974', 7, 243.99, 30.50, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (469, 'US-2020-107272', 'OFF-BI-10003274', 2, 2.39, -1.83, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (470, 'US-2020-109484', 'OFF-BI-10004738', 1, 5.68, -3.79, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (471, 'US-2020-116701', 'OFF-AP-10003217', 2, 66.28, -178.97, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (472, 'US-2020-118038', 'OFF-ST-10000615', 3, 27.24, 2.72, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (473, 'US-2020-118038', 'OFF-BI-10004182', 3, 1.25, -1.93, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (474, 'US-2020-118038', 'FUR-FU-10000260', 3, 9.71, -5.82, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (475, 'US-2020-119438', 'TEC-AC-10003614', 3, 27.82, 4.52, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (476, 'US-2020-119438', 'OFF-BI-10004632', 3, 182.99, -320.24, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (477, 'US-2020-119438', 'OFF-AP-10000804', 3, 2.69, -7.39, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (478, 'US-2020-119438', 'FUR-FU-10003553', 3, 82.52, -41.26, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (479, 'US-2020-119662', 'OFF-ST-10003656', 3, 230.38, -48.95, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (480, 'US-2020-122637', 'OFF-BI-10002429', 7, 42.62, -68.19, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (481, 'US-2020-124303', 'OFF-PA-10002749', 3, 16.06, 5.82, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (482, 'US-2020-124303', 'OFF-BI-10000343', 2, 2.95, -2.26, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (483, 'US-2020-127719', 'OFF-PA-10001934', 1, 6.48, 3.18, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (484, 'US-2020-129441', 'FUR-FU-10000448', 3, 47.94, 2.40, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (485, 'US-2020-134481', 'FUR-TA-10004915', 7, 1488.42, -297.68, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (486, 'US-2020-145366', 'OFF-ST-10004180', 1, 37.21, -7.44, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (487, 'US-2020-145366', 'OFF-EN-10004386', 3, 57.58, 21.59, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (488, 'US-2020-152366', 'OFF-AP-10002684', 4, 97.26, -243.16, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (489, 'US-2020-152380', 'FUR-TA-10002533', 3, 219.08, -131.45, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (490, 'US-2020-155299', 'OFF-AP-10002203', 2, 1.62, -4.47, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (491, 'US-2020-156083', 'OFF-PA-10001560', 2, 9.66, 3.26, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (492, 'US-2020-156909', 'FUR-CH-10002774', 2, 71.37, -1.02, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (493, 'US-2020-164147', 'TEC-PH-10002293', 5, 59.97, -11.99, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (494, 'US-2020-164147', 'OFF-PA-10002377', 2, 78.30, 29.36, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (495, 'US-2020-164147', 'OFF-FA-10002780', 9, 21.46, 6.97, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (496, 'US-2020-168116', 'TEC-MA-10004125', 4, 7999.98, -3839.99, DEFAULT);
INSERT INTO public.order_item OVERRIDING SYSTEM VALUE VALUES (497, 'US-2020-168116', 'OFF-AP-10002457', 2, 167.44, 14.65, DEFAULT);


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.orders VALUES ('CA-2019-100153', '2019-12-13', '2019-12-17', 'KH-16630', 4, 7, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-100790', '2019-06-26', '2019-07-02', 'JG-15805', 4, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-101343', '2019-07-17', '2019-07-22', 'RA-19885', 4, 21, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-103730', '2019-06-12', '2019-06-15', 'SC-20725', 1, 37, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-103891', '2019-07-12', '2019-07-19', 'KH-16690', 4, 21, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-103947', '2019-04-01', '2019-04-08', 'BB-10990', 4, 8, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-105018', '2019-11-28', '2019-12-02', 'SK-19990', 4, 93, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-105256', '2019-05-20', '2019-05-20', 'JK-15730', 2, 104, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-105816', '2019-12-11', '2019-12-17', 'JM-15265', 4, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-106075', '2019-09-18', '2019-09-23', 'HM-14980', 4, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-106341', '2019-10-20', '2019-10-23', 'LF-17185', 1, 60, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-108987', '2019-09-08', '2019-09-10', 'AG-10675', 3, 1, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-109806', '2019-09-17', '2019-09-22', 'JS-15685', 4, 21, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-109869', '2019-04-22', '2019-04-29', 'TN-21040', 4, 17, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-110366', '2019-09-05', '2019-09-07', 'JD-15895', 3, 115, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-110499', '2019-04-07', '2019-04-09', 'YC-21895', 1, 27, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-110772', '2019-11-20', '2019-11-24', 'NZ-18565', 3, 95, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-111010', '2019-01-22', '2019-01-28', 'PG-18895', 4, 45, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-111682', '2019-06-17', '2019-06-18', 'TB-21055', 1, 6, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-112697', '2019-12-18', '2019-12-20', 'AH-10195', 3, 46, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-112942', '2019-02-13', '2019-02-18', 'RD-19810', 4, 21, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-113243', '2019-06-10', '2019-06-15', 'OT-18730', 4, 21, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-113747', '2019-05-28', '2019-06-04', 'VD-21670', 4, 111, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-113817', '2019-11-07', '2019-11-11', 'MJ-17740', 4, 109, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-114104', '2019-11-20', '2019-11-24', 'NP-18670', 4, 39, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-114489', '2019-12-05', '2019-12-09', 'JE-16165', 4, 2, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-114713', '2019-07-07', '2019-07-12', 'SC-20695', 4, 65, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-115504', '2019-03-12', '2019-03-17', 'MC-18130', 4, 47, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-115756', '2019-09-05', '2019-09-07', 'PK-19075', 3, 99, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-115917', '2019-05-20', '2019-05-25', 'RB-19465', 4, 78, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-116736', '2019-01-17', '2019-01-21', 'CC-12430', 4, 102, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-117590', '2019-12-08', '2019-12-10', 'GH-14485', 1, 68, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-118255', '2019-03-11', '2019-03-13', 'ON-18715', 1, 64, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-119823', '2019-06-04', '2019-06-06', 'KD-16270', 1, 74, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-120200', '2019-07-14', '2019-07-16', 'TP-21130', 1, 115, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-121223', '2019-09-11', '2019-09-13', 'GD-14590', 3, 115, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-121755', '2019-01-16', '2019-01-20', 'EH-13945', 3, 21, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-123274', '2019-02-19', '2019-02-24', 'GT-14710', 4, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-123666', '2019-03-26', '2019-03-30', 'SP-20545', 4, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-125318', '2019-06-06', '2019-06-13', 'RC-19825', 4, 9, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-126158', '2019-07-25', '2019-07-31', 'SC-20095', 4, 44, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-126613', '2019-07-10', '2019-07-16', 'AA-10375', 4, 35, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-127208', '2019-06-12', '2019-06-15', 'SC-20770', 1, 43, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-127250', '2019-11-03', '2019-11-07', 'SF-20200', 4, 56, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-127369', '2019-06-06', '2019-06-07', 'DB-13060', 1, 127, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-128867', '2019-11-03', '2019-11-10', 'CL-12565', 4, 20, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-129714', '2019-09-01', '2019-09-03', 'AB-10060', 1, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-129903', '2019-12-01', '2019-12-04', 'GZ-14470', 3, 52, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-130001', '2019-04-23', '2019-04-28', 'HK-14890', 4, 113, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-130162', '2019-10-28', '2019-11-01', 'JH-15910', 4, 21, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-132661', '2019-10-23', '2019-10-29', 'SR-20740', 4, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-134362', '2019-09-29', '2019-10-02', 'LS-16945', 1, 115, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-134474', '2019-01-05', '2019-01-07', 'AJ-10795', 3, 103, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-134775', '2019-10-28', '2019-10-29', 'AS-10285', 1, 27, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-136133', '2019-08-18', '2019-08-23', 'HW-14935', 3, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-136406', '2019-04-15', '2019-04-17', 'BD-11320', 3, 27, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-136924', '2019-07-14', '2019-07-17', 'ES-14080', 1, 28, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-137239', '2019-08-22', '2019-08-28', 'CR-12730', 4, 95, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-137330', '2019-12-09', '2019-12-13', 'KB-16585', 4, 57, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-138520', '2019-04-08', '2019-04-13', 'JL-15505', 4, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-138688', '2019-06-12', '2019-06-16', 'DV-13045', 3, 21, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-140928', '2019-09-18', '2019-09-22', 'NB-18655', 4, 103, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-142335', '2019-12-15', '2019-12-19', 'MP-17965', 4, 99, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-142545', '2019-10-28', '2019-11-03', 'JD-15895', 4, 122, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-142902', '2019-09-12', '2019-09-14', 'BP-11185', 3, 34, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-143308', '2019-11-04', '2019-11-04', 'RC-19825', 2, 12, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-145583', '2019-10-13', '2019-10-19', 'LC-16885', 4, 76, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-145625', '2019-09-11', '2019-09-17', 'KC-16540', 4, 54, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-146941', '2019-12-10', '2019-12-13', 'DL-13315', 1, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-147067', '2019-12-18', '2019-12-22', 'JD-16150', 4, 75, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-147375', '2019-06-12', '2019-06-14', 'PO-19180', 3, 9, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-148796', '2019-04-14', '2019-04-18', 'PB-19150', 4, 21, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-149223', '2019-09-06', '2019-09-11', 'ER-13855', 4, 105, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-149370', '2019-09-15', '2019-09-19', 'DB-13210', 4, 115, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-150889', '2019-03-20', '2019-03-22', 'PB-19105', 3, 18, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-152156', '2019-11-08', '2019-11-11', 'CG-12520', 3, 124, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-152534', '2019-06-20', '2019-06-25', 'DP-13105', 3, 5, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-152632', '2019-10-27', '2019-11-02', 'JE-15475', 4, 6, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-154508', '2019-11-16', '2019-11-20', 'RD-19900', 4, 96, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-154739', '2019-12-10', '2019-12-15', 'LH-17155', 3, 27, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-155516', '2019-10-21', '2019-10-21', 'MK-17905', 2, 118, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-157000', '2019-07-16', '2019-07-22', 'AM-10360', 4, 89, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-157245', '2019-05-19', '2019-05-24', 'LE-16810', 4, 91, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-157749', '2019-06-04', '2019-06-09', 'KL-16645', 3, 9, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-158099', '2019-09-03', '2019-09-05', 'PK-18910', 1, 115, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-158568', '2019-08-29', '2019-09-02', 'RB-19465', 4, 9, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-158834', '2019-03-13', '2019-03-16', 'TW-21025', 1, 67, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-159695', '2019-04-05', '2019-04-10', 'GM-14455', 3, 1, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-160745', '2019-12-11', '2019-12-16', 'AR-10825', 3, 4, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-161389', '2019-12-05', '2019-12-10', 'IM-15070', 4, 109, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-161669', '2019-11-07', '2019-11-09', 'EM-14095', 1, 21, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-161816', '2019-04-28', '2019-05-01', 'NB-18655', 1, 11, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-162138', '2019-04-23', '2019-04-27', 'GK-14620', 4, 15, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-162733', '2019-05-11', '2019-05-12', 'TT-21070', 1, 21, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-163755', '2019-11-04', '2019-11-08', 'AS-10285', 3, 109, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-164511', '2019-11-19', '2019-11-24', 'DJ-13630', 4, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-165316', '2019-07-23', '2019-07-27', 'JB-15400', 4, 100, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-166674', '2019-04-01', '2019-04-03', 'RB-19360', 3, 69, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-168753', '2019-05-29', '2019-06-01', 'RL-19615', 3, 92, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-169166', '2019-05-09', '2019-05-14', 'SS-20590', 4, 109, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2019-169194', '2019-06-20', '2019-06-25', 'LH-16900', 4, 50, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-100650', '2020-06-29', '2020-07-03', 'DK-13225', 3, 85, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-101434', '2020-06-20', '2020-06-27', 'TR-21325', 4, 122, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-101798', '2020-12-11', '2020-12-15', 'MV-18190', 4, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-101945', '2020-11-24', '2020-11-28', 'GT-14710', 4, 1, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-102946', '2020-06-30', '2020-07-05', 'VP-21730', 4, 13, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-104220', '2020-01-30', '2020-02-05', 'BV-11245', 4, 58, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-104745', '2020-05-29', '2020-06-04', 'GT-14755', 4, 38, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-105074', '2020-06-24', '2020-06-29', 'MB-17305', 4, 94, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-105809', '2020-02-20', '2020-02-23', 'HW-14935', 1, 54, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-106103', '2020-06-10', '2020-06-15', 'SC-20305', 4, 62, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-106180', '2020-09-18', '2020-09-23', 'SH-19975', 4, 27, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-107503', '2020-01-01', '2020-01-06', 'GA-14725', 4, 81, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-107720', '2020-11-06', '2020-11-13', 'VM-21685', 4, 29, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-107727', '2020-10-19', '2020-10-23', 'MA-17560', 3, 1, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-108329', '2020-12-09', '2020-12-14', 'LE-16810', 4, 88, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-108910', '2020-09-24', '2020-09-29', 'KC-16540', 4, 60, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-110478', '2020-03-04', '2020-03-09', 'SP-20860', 4, 21, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-111178', '2020-06-15', '2020-06-22', 'TD-20995', 4, 77, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-112774', '2020-09-11', '2020-09-12', 'RC-19960', 1, 103, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-113558', '2020-10-21', '2020-10-26', 'PH-18790', 4, 108, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-114412', '2020-04-15', '2020-04-20', 'AA-10480', 4, 101, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-114440', '2020-09-14', '2020-09-17', 'TB-21520', 3, 86, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-114552', '2020-09-02', '2020-09-08', 'Dl-13600', 4, 110, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-114636', '2020-08-25', '2020-08-29', 'GA-14725', 4, 113, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-117240', '2020-07-23', '2020-07-28', 'CP-12340', 4, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-117457', '2020-12-08', '2020-12-12', 'KH-16510', 4, 27, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-117933', '2020-12-24', '2020-12-29', 'RF-19840', 4, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-117947', '2020-08-18', '2020-08-23', 'NG-18355', 3, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-118136', '2020-09-16', '2020-09-17', 'BB-10990', 1, 84, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-118640', '2020-07-20', '2020-07-26', 'CS-11950', 4, 9, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-118731', '2020-11-20', '2020-11-22', 'LP-17080', 3, 27, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-119004', '2020-11-23', '2020-11-28', 'JM-15250', 4, 113, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-120999', '2020-09-10', '2020-09-15', 'LC-16930', 4, 72, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-122105', '2020-06-24', '2020-06-28', 'CJ-12010', 4, 126, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-125388', '2020-10-19', '2020-10-23', 'MP-17965', 4, 55, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-126046', '2020-11-03', '2020-11-07', 'JC-16105', 4, 40, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-126074', '2020-10-02', '2020-10-06', 'RF-19735', 4, 116, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-126382', '2020-06-03', '2020-06-07', 'HK-14890', 4, 71, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-126774', '2020-04-15', '2020-04-17', 'SH-20395', 1, 91, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-126956', '2020-08-21', '2020-08-28', 'GT-14710', 4, 10, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-127432', '2020-01-22', '2020-01-27', 'AD-10180', 4, 61, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-129462', '2020-06-16', '2020-06-21', 'JE-15745', 3, 120, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-129567', '2020-03-17', '2020-03-21', 'CL-12565', 3, 33, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-130043', '2020-09-15', '2020-09-19', 'BB-11545', 4, 1, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-130351', '2020-12-05', '2020-12-08', 'RB-19570', 1, 114, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-131954', '2020-01-21', '2020-01-25', 'DS-13030', 4, 109, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-132682', '2020-06-08', '2020-06-10', 'TH-21235', 3, 11, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-132976', '2020-10-13', '2020-10-17', 'AG-10495', 4, 115, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-133333', '2020-09-18', '2020-09-22', 'BF-11020', 4, 48, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-133431', '2020-12-17', '2020-12-21', 'LC-17140', 4, 27, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-134306', '2020-07-08', '2020-07-12', 'TD-20995', 4, 127, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-134978', '2020-11-12', '2020-11-15', 'EB-13705', 3, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-135307', '2020-11-26', '2020-11-27', 'LS-17245', 1, 22, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-135783', '2020-04-22', '2020-04-24', 'GM-14440', 1, 27, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-135860', '2020-12-01', '2020-12-07', 'JH-15985', 4, 87, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-136826', '2020-06-16', '2020-06-20', 'CB-12535', 4, 125, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-137099', '2020-12-07', '2020-12-10', 'FP-14320', 1, 21, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-138611', '2020-11-14', '2020-11-17', 'CK-12595', 3, 41, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-139619', '2020-09-19', '2020-09-23', 'ES-14080', 4, 97, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-140088', '2020-05-28', '2020-05-30', 'PO-18865', 3, 121, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-140844', '2020-06-19', '2020-06-23', 'AR-10405', 4, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-140963', '2020-06-10', '2020-06-13', 'MT-18070', 1, 21, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-142636', '2020-11-03', '2020-11-07', 'KC-16675', 4, 109, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-143686', '2020-05-14', '2020-05-14', 'PJ-19015', 2, 79, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-144113', '2020-09-16', '2020-09-20', 'JF-15355', 4, 32, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-144694', '2020-09-24', '2020-09-26', 'BD-11605', 3, 123, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-144904', '2020-09-25', '2020-10-01', 'KW-16435', 4, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-145142', '2020-01-23', '2020-01-25', 'MC-17605', 1, 99, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-145233', '2020-12-01', '2020-12-05', 'DV-13465', 4, 73, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-146136', '2020-09-03', '2020-09-07', 'AP-10915', 4, 70, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-146780', '2020-12-25', '2020-12-30', 'CV-12805', 4, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-147277', '2020-10-20', '2020-10-24', 'EB-13705', 4, 94, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-149160', '2020-11-23', '2020-11-26', 'JM-15265', 3, 63, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-151428', '2020-09-21', '2020-09-26', 'RH-19495', 4, 52, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-152275', '2020-10-01', '2020-10-08', 'KH-16630', 4, 26, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-153339', '2020-11-03', '2020-11-05', 'DJ-13510', 3, 112, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-153787', '2020-05-19', '2020-05-23', 'AT-10735', 4, 109, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-154214', '2020-03-20', '2020-03-25', 'TB-21595', 3, 114, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-154816', '2020-11-06', '2020-11-10', 'VB-21745', 4, 107, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-154907', '2020-03-31', '2020-04-04', 'DS-13180', 4, 106, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-155376', '2020-12-22', '2020-12-27', 'SG-20080', 4, 49, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-155558', '2020-10-26', '2020-11-02', 'PG-18895', 4, 52, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-155698', '2020-03-08', '2020-03-11', 'VB-21745', 1, 83, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-155705', '2020-08-21', '2020-08-23', 'NF-18385', 3, 111, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-156951', '2020-10-01', '2020-10-08', 'EB-13840', 4, 109, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-157252', '2020-01-20', '2020-01-23', 'CV-12805', 3, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-157833', '2020-06-17', '2020-06-20', 'KD-16345', 1, 27, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-160514', '2020-11-12', '2020-11-16', 'DB-13120', 4, 66, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-161018', '2020-11-09', '2020-11-11', 'PN-18775', 3, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-161480', '2020-12-25', '2020-12-29', 'RA-19285', 4, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-161984', '2020-04-10', '2020-04-15', 'SJ-20125', 4, 14, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-162929', '2020-11-19', '2020-11-22', 'AS-10135', 1, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-163020', '2020-09-15', '2020-09-19', 'MO-17800', 4, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-163139', '2020-12-01', '2020-12-03', 'CC-12670', 3, 30, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-163405', '2020-12-21', '2020-12-25', 'BN-11515', 4, 21, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-165603', '2020-10-17', '2020-10-19', 'SS-20140', 3, 80, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-167913', '2020-07-30', '2020-08-03', 'JL-15835', 3, 31, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('CA-2020-169901', '2020-06-15', '2020-06-19', 'CC-12550', 4, 27, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2019-100419', '2019-12-16', '2019-12-20', 'CC-12670', 3, 9, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2019-100720', '2019-07-16', '2019-07-21', 'CK-12205', 4, 115, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2019-105578', '2019-05-30', '2019-06-04', 'MY-17380', 4, 25, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2019-120929', '2019-03-18', '2019-03-21', 'RO-19780', 3, 98, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2019-123470', '2019-08-15', '2019-08-21', 'ME-17725', 4, 16, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2019-123750', '2019-04-15', '2019-04-21', 'RB-19795', 4, 117, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2019-125969', '2019-11-06', '2019-11-10', 'LS-16975', 3, 21, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2019-134656', '2019-09-28', '2019-10-01', 'MM-18280', 1, 77, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2019-135720', '2019-12-11', '2019-12-13', 'FM-14380', 3, 16, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2019-137547', '2019-03-07', '2019-03-12', 'EB-13705', 4, 82, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2019-139486', '2019-05-21', '2019-05-23', 'LH-17155', 1, 21, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2019-141544', '2019-08-30', '2019-09-01', 'PO-18850', 1, 115, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2019-146710', '2019-08-27', '2019-09-01', 'SS-20875', 4, 11, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2019-150147', '2019-04-25', '2019-04-29', 'JL-15850', 3, 115, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2019-150861', '2019-12-03', '2019-12-06', 'EG-13900', 1, 19, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2019-156097', '2019-09-19', '2019-09-19', 'EH-14125', 2, 90, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2019-156986', '2019-03-20', '2019-03-24', 'ZC-21910', 4, 51, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2019-157945', '2019-09-26', '2019-10-01', 'NF-18385', 4, 59, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2020-100048', '2020-05-19', '2020-05-24', 'RS-19765', 4, 128, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2020-100930', '2020-04-07', '2020-04-12', 'CS-12400', 4, 100, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2020-106663', '2020-06-09', '2020-06-13', 'MO-17800', 4, 9, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2020-107272', '2020-11-05', '2020-11-12', 'TS-21610', 4, 17, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2020-109484', '2020-11-06', '2020-11-12', 'RB-19705', 4, 23, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2020-116701', '2020-12-17', '2020-12-21', 'LC-17140', 3, 11, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2020-118038', '2020-12-09', '2020-12-11', 'KB-16600', 1, 1, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2020-119438', '2020-03-18', '2020-03-23', 'CD-11980', 4, 24, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2020-119662', '2020-11-13', '2020-11-16', 'CS-12400', 1, 9, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2020-122637', '2020-09-03', '2020-09-08', 'EP-13915', 3, 9, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2020-124303', '2020-07-06', '2020-07-13', 'FH-14365', 4, 115, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2020-127719', '2020-07-21', '2020-07-25', 'TW-21025', 4, 3, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2020-129441', '2020-09-07', '2020-09-11', 'JC-15340', 4, 21, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2020-134481', '2020-08-27', '2020-09-01', 'AR-10405', 4, 36, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2020-145366', '2020-12-09', '2020-12-13', 'CA-12310', 4, 53, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2020-152366', '2020-04-21', '2020-04-25', 'SJ-20500', 3, 1, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2020-152380', '2020-11-19', '2020-11-23', 'JH-15910', 4, 9, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2020-155299', '2020-06-08', '2020-06-12', 'Dl-13600', 4, 129, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2020-156083', '2020-11-04', '2020-11-11', 'JL-15175', 4, 42, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2020-156909', '2020-07-16', '2020-07-18', 'SF-20065', 3, 115, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2020-164147', '2020-02-02', '2020-02-05', 'DW-13585', 1, 95, DEFAULT, '2026-05-04 19:00:15.92557');
INSERT INTO public.orders VALUES ('US-2020-168116', '2020-11-04', '2020-11-04', 'GT-14635', 2, 119, DEFAULT, '2026-05-04 19:00:15.92557');


--
-- Data for Name: product; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product VALUES ('FUR-BO-10001337', 'O''Sullivan Living Dimensions 2-Shelf Bookcases', 13, true);
INSERT INTO public.product VALUES ('FUR-BO-10001619', 'O''Sullivan Cherrywood Estates Traditional Bookcase', 13, true);
INSERT INTO public.product VALUES ('FUR-BO-10001798', 'Bush Somerset Collection Bookcase', 13, true);
INSERT INTO public.product VALUES ('FUR-BO-10001972', 'O''Sullivan 4-Shelf Bookcase in Odessa Pine', 13, true);
INSERT INTO public.product VALUES ('FUR-BO-10002268', 'Sauder Barrister Bookcases', 13, true);
INSERT INTO public.product VALUES ('FUR-BO-10002545', 'Atlantic Metals Mobile 3-Shelf Bookcases, Custom Colors', 13, true);
INSERT INTO public.product VALUES ('FUR-BO-10002824', 'Bush Mission Pointe Library', 13, true);
INSERT INTO public.product VALUES ('FUR-BO-10004015', 'Bush Andora Bookcase, Maple/Graphite Gray Finish', 13, true);
INSERT INTO public.product VALUES ('FUR-BO-10004709', 'Bush Westfield Collection Bookcases, Medium Cherry Finish', 13, true);
INSERT INTO public.product VALUES ('FUR-BO-10004834', 'Riverside Palais Royal Lawyers Bookcase, Royale Cherry Finish', 13, true);
INSERT INTO public.product VALUES ('FUR-CH-10000015', 'Hon Multipurpose Stacking Arm Chairs', 8, true);
INSERT INTO public.product VALUES ('FUR-CH-10000454', 'Hon Deluxe Fabric Upholstered Stacking Chairs, Rounded Back', 8, true);
INSERT INTO public.product VALUES ('FUR-CH-10000665', 'Global Airflow Leather Mesh Back Chair, Black', 8, true);
INSERT INTO public.product VALUES ('FUR-CH-10000785', 'Global Ergonomic Managers Chair', 8, true);
INSERT INTO public.product VALUES ('FUR-CH-10000863', 'Novimex Swivel Fabric Task Chair', 8, true);
INSERT INTO public.product VALUES ('FUR-CH-10001146', 'Global Task Chair, Black', 8, true);
INSERT INTO public.product VALUES ('FUR-CH-10001215', 'Global Troy Executive Leather Low-Back Tilter', 8, true);
INSERT INTO public.product VALUES ('FUR-CH-10001891', 'Global Deluxe Office Fabric Chairs', 8, true);
INSERT INTO public.product VALUES ('FUR-CH-10002024', 'HON 5400 Series Task Chairs for Big and Tall', 8, true);
INSERT INTO public.product VALUES ('FUR-CH-10002331', 'Hon 4700 Series Mobuis Mid-Back Task Chairs with Adjustable Arms', 8, true);
INSERT INTO public.product VALUES ('FUR-CH-10002372', 'Office Star - Ergonomically Designed Knee Chair', 8, true);
INSERT INTO public.product VALUES ('FUR-CH-10002602', 'DMI Arturo Collection Mission-style Design Wood Chair', 8, true);
INSERT INTO public.product VALUES ('FUR-CH-10002774', 'Global Deluxe Stacking Chair, Gray', 8, true);
INSERT INTO public.product VALUES ('FUR-CH-10002965', 'Global Leather Highback Executive Chair with Pneumatic Height Adjustment, Black', 8, true);
INSERT INTO public.product VALUES ('FUR-CH-10003312', 'Hon 2090 ?Pillow Soft? Series Mid Back Swivel/Tilt Chairs', 8, true);
INSERT INTO public.product VALUES ('FUR-CH-10003379', 'Global Commerce Series High-Back Swivel/Tilt Chairs', 8, true);
INSERT INTO public.product VALUES ('FUR-CH-10003396', 'Global Deluxe Steno Chair', 8, true);
INSERT INTO public.product VALUES ('FUR-CH-10003746', 'Hon 4070 Series Pagoda Round Back Stacking Chairs', 8, true);
INSERT INTO public.product VALUES ('FUR-CH-10003956', 'Novimex High-Tech Fabric Mesh Task Chair', 8, true);
INSERT INTO public.product VALUES ('FUR-CH-10003968', 'Novimex Turbo Task Chair', 8, true);
INSERT INTO public.product VALUES ('FUR-CH-10004086', 'Hon 4070 Series Pagoda Armless Upholstered Stacking Chairs', 8, true);
INSERT INTO public.product VALUES ('FUR-CH-10004886', 'Bevis Steel Folding Chairs', 8, true);
INSERT INTO public.product VALUES ('FUR-CH-10004997', 'Hon Every-Day Series Multi-Task Chairs', 8, true);
INSERT INTO public.product VALUES ('FUR-FU-10000010', 'DAX Value U-Channel Document Frames, Easel Back', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10000023', 'Eldon Wave Desk Accessories', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10000073', 'Deflect-O Glasstique Clear Desk Accessories', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10000206', 'GE General Purpose, Extra Long Life, Showcase & Floodlight Incandescent Bulbs', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10000221', 'Master Caster Door Stop, Brown', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10000246', 'Aluminum Document Frame', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10000260', '6" Cubicle Wall Clock, Black', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10000448', 'Tenex Chairmats For Use With Carpeted Floors', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10000521', 'Seth Thomas 14" Putty-Colored Wall Clock', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10000576', 'Luxo Professional Fluorescent Magnifier Lamp with Clamp-Mount Base', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10000629', '9-3/4 Diameter Round Wall Clock', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10000732', 'Eldon 200 Class Desk Accessories', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10000794', 'Eldon Stackable Tray, Side-Load, Legal, Smoke', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10001290', 'Executive Impressions Supervisor Wall Clock', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10001475', 'Contract Clock, 14", Brown', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10001706', 'Longer-Life Soft White Bulbs', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10001756', 'Eldon Expressions Desk Accessory, Wood Photo Frame, Mahogany', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10001861', 'Floodlight Indoor Halogen Bulbs, 1 Bulb per Pack, 60 Watts', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10001918', 'C-Line Cubicle Keepers Polyproplyene Holder With Velcro Backings', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10001934', 'Magnifier Swing Arm Lamp', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10001935', '3M Hangers With Command Adhesive', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10001967', 'Telescoping Adjustable Floor Lamp', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10002157', 'Artistic Insta-Plaque', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10002253', 'Howard Miller 13" Diameter Pewter Finish Round Wall Clock', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10002505', 'Eldon 100 Class Desk Accessories', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10002597', 'C-Line Magnetic Cubicle Keepers, Clear Polypropylene', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10002671', 'Electrix 20W Halogen Replacement Bulb for Zoom-In Desk Lamp', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10002759', '12-1/2 Diameter Round Wall Clock', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10002960', 'Eldon 200 Class Desk Accessories, Burgundy', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10003039', 'Howard Miller 11-1/2" Diameter Grantwood Wall Clock', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10003347', 'Coloredge Poster Frame', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10003394', 'Tenex "The Solids" Textured Chair Mats', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10003553', 'Howard Miller 13-1/2" Diameter Rosebrook Wall Clock', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10003577', 'Nu-Dell Leatherette Frames', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10003664', 'Electrix Architect''s Clamp-On Swing Arm Lamp, Black', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10003773', 'Eldon Cleatmat Plus Chair Mats for High Pile Carpets', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10003849', 'DAX Metal Frame, Desktop, Stepped-Edge', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10003878', 'Linden 10" Round Wall Clock, Black', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10004017', 'Tenex Contemporary Contur Chairmats for Low and Medium Pile Carpet, Computer, 39" x 49"', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10004090', 'Executive Impressions 14" Contract Wall Clock', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10004351', 'Staple-based wall hangings', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10004712', 'Westinghouse Mesh Shade Clip-On Gooseneck Lamp, Black', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10004848', 'Howard Miller 13-3/4" Diameter Brushed Chrome Round Wall Clock', 10, true);
INSERT INTO public.product VALUES ('FUR-FU-10004864', 'Howard Miller 14-1/2" Diameter Chrome Round Wall Clock', 10, true);
INSERT INTO public.product VALUES ('FUR-TA-10000198', 'Chromcraft Bull-Nose Wood Oval Conference Tables & Bases', 2, true);
INSERT INTO public.product VALUES ('FUR-TA-10000688', 'Chromcraft Bull-Nose Wood Round Conference Table Top, Wood Base', 2, true);
INSERT INTO public.product VALUES ('FUR-TA-10001095', 'Chromcraft Round Conference Tables', 2, true);
INSERT INTO public.product VALUES ('FUR-TA-10001539', 'Chromcraft Rectangular Conference Tables', 2, true);
INSERT INTO public.product VALUES ('FUR-TA-10001705', 'Bush Advantage Collection Round Conference Table', 2, true);
INSERT INTO public.product VALUES ('FUR-TA-10001857', 'Balt Solid Wood Rectangular Table', 2, true);
INSERT INTO public.product VALUES ('FUR-TA-10001889', 'Bush Advantage Collection Racetrack Conference Table', 2, true);
INSERT INTO public.product VALUES ('FUR-TA-10002041', 'Bevis Round Conference Table Top, X-Base', 2, true);
INSERT INTO public.product VALUES ('FUR-TA-10002228', 'Bevis Traditional Conference Table Top, Plinth Base', 2, true);
INSERT INTO public.product VALUES ('FUR-TA-10002533', 'BPI Conference Tables', 2, true);
INSERT INTO public.product VALUES ('FUR-TA-10002607', 'KI Conference Tables', 2, true);
INSERT INTO public.product VALUES ('FUR-TA-10003473', 'Bretford Rectangular Conference Table Tops', 2, true);
INSERT INTO public.product VALUES ('FUR-TA-10004256', 'Bretford ?Just In Time? Height-Adjustable Multi-Task Work Tables', 2, true);
INSERT INTO public.product VALUES ('FUR-TA-10004915', 'Office Impressions End Table, 20-1/2"H x 24"W x 20"D', 2, true);
INSERT INTO public.product VALUES ('OFF-AP-10000326', 'Belkin 7 Outlet SurgeMaster Surge Protector with Phone Protection', 14, true);
INSERT INTO public.product VALUES ('OFF-AP-10000358', 'Fellowes Basic Home/Office Series Surge Protectors', 14, true);
INSERT INTO public.product VALUES ('OFF-AP-10000576', 'Belkin 7 Outlet SurgeMaster II', 14, true);
INSERT INTO public.product VALUES ('OFF-AP-10000804', 'Hoover Portapower Portable Vacuum', 14, true);
INSERT INTO public.product VALUES ('OFF-AP-10001058', 'Sanyo 2.5 Cubic Foot Mid-Size Office Refrigerators', 14, true);
INSERT INTO public.product VALUES ('OFF-AP-10001124', 'Belkin 8 Outlet SurgeMaster II Gold Surge Protector with Phone Protection', 14, true);
INSERT INTO public.product VALUES ('OFF-AP-10001154', 'Bionaire Personal Warm Mist Humidifier/Vaporizer', 14, true);
INSERT INTO public.product VALUES ('OFF-AP-10001492', 'Acco Six-Outlet Power Strip, 4'' Cord Length', 14, true);
INSERT INTO public.product VALUES ('OFF-AP-10001563', 'Belkin Premiere Surge Master II 8-outlet surge protector', 14, true);
INSERT INTO public.product VALUES ('OFF-AP-10002118', '1.7 Cubic Foot Compact "Cube" Office Refrigerators', 14, true);
INSERT INTO public.product VALUES ('OFF-AP-10002203', 'Eureka Disposable Bags for Sanitaire Vibra Groomer I Upright Vac', 14, true);
INSERT INTO public.product VALUES ('OFF-AP-10002350', 'Belkin F9H710-06 7 Outlet SurgeMaster Surge Protector', 14, true);
INSERT INTO public.product VALUES ('OFF-AP-10002439', 'Tripp Lite Isotel 8 Ultra 8 Outlet Metal Surge', 14, true);
INSERT INTO public.product VALUES ('OFF-AP-10002457', 'Eureka The Boss Plus 12-Amp Hard Box Upright Vacuum, Red', 14, true);
INSERT INTO public.product VALUES ('OFF-AP-10002578', 'Fellowes Premier Superior Surge Suppressor, 10-Outlet, With Phone and Remote', 14, true);
INSERT INTO public.product VALUES ('OFF-AP-10002684', 'Acco 7-Outlet Masterpiece Power Center, Wihtout Fax/Phone Line Protection', 14, true);
INSERT INTO public.product VALUES ('OFF-AP-10003217', 'Eureka Sanitaire  Commercial Upright', 14, true);
INSERT INTO public.product VALUES ('OFF-AP-10003266', 'Holmes Replacement Filter for HEPA Air Cleaner, Large Room', 14, true);
INSERT INTO public.product VALUES ('OFF-AP-10003287', 'Tripp Lite TLP810NET Broadband Surge for Modem/Fax', 14, true);
INSERT INTO public.product VALUES ('OFF-AP-10003884', 'Fellowes Smart Surge Ten-Outlet Protector, Platinum', 14, true);
INSERT INTO public.product VALUES ('OFF-AP-10004249', 'Staple holder', 14, true);
INSERT INTO public.product VALUES ('OFF-AP-10004532', 'Kensington 6 Outlet Guardian Standard Surge Protector', 14, true);
INSERT INTO public.product VALUES ('OFF-AR-10000246', 'Newell 318', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10000369', 'Design Ebony Sketching Pencil', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10000380', 'Hunt PowerHouse Electric Pencil Sharpener, Blue', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10000390', 'Newell Chalk Holder', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10000588', 'Newell 345', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10000940', 'Newell 343', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10001149', 'Sanford Colorific Colored Pencils, 12/Box', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10001246', 'Newell 317', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10001374', 'BIC Brite Liner Highlighters, Chisel Tip', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10001427', 'Newell 330', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10001573', 'American Pencil', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10001868', 'Prang Dustless Chalk Sticks', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10001953', 'Boston 1645 Deluxe Heavier-Duty Electric Pencil Sharpener', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10001954', 'Newell 331', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10002053', 'Premium Writing Pencils, Soft, #2 by Central Association for the Blind', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10002335', 'DIXON Oriole Pencils', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10002399', 'Dixon Prang Watercolor Pencils, 10-Color Set with Brush', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10002804', 'Faber Castell Col-Erase Pencils', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10002956', 'Boston 16801 Nautilus Battery Pencil Sharpener', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10003045', 'Prang Colored Pencils', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10003156', '50 Colored Long Pencils', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10003373', 'Boston School Pro Electric Pencil Sharpener, 1670', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10003394', 'Newell 332', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10003478', 'Avery Hi-Liter EverBold Pen Style Fluorescent Highlighters, 4/Pack', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10003602', 'Quartet Omega Colored Chalk, 12/Pack', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10003732', 'Newell 333', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10003811', 'Newell 327', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10003958', 'Newell 337', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10004027', 'Binney & Smith inkTank Erasable Desk Highlighter, Chisel Tip, Yellow, 12/Box', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10004344', 'Bulldog Vacuum Base Pencil Sharpener', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10004648', 'Boston 19500 Mighty Mite Electric Pencil Sharpener', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10004685', 'Binney & Smith Crayola Metallic Colored Pencils, 8-Color Set', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10004930', 'Turquoise Lead Holder with Pocket Clip', 12, true);
INSERT INTO public.product VALUES ('OFF-AR-10004974', 'Newell 342', 12, true);
INSERT INTO public.product VALUES ('OFF-BI-10000014', 'Heavy-Duty E-Z-D Binders', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10000050', 'Angle-D Binders with Locking Rings, Label Holders', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10000069', 'GBC Prepunched Paper, 19-Hole, for Binding Systems, 24-lb', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10000138', 'Acco Translucent Poly Ring Binders', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10000301', 'GBC Instant Report Kit', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10000315', 'Poly Designer Cover & Back', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10000343', 'Pressboard Covers with Storage Hooks, 9 1/2" x 11", Light Blue', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10000404', 'Avery Printable Repositionable Plastic Tabs', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10000545', 'GBC Ibimaster 500 Manual ProClick Binding System', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10000546', 'Avery Durable Binders', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10000605', 'Acco Pressboard Covers with Storage Hooks, 9 1/2" x 11", Executive Red', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10000778', 'GBC VeloBinder Electric Binding Machine', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10000831', 'Storex Flexible Poly Binders with Double Pockets', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10000848', 'Angle-D Ring Binders', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10001036', 'Cardinal EasyOpen D-Ring Binders', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10001107', 'GBC White Gloss Covers, Plain Front', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10001153', 'Ibico Recycled Grain-Textured Covers', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10001294', 'Fellowes Binding Cases', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10001460', 'Plastic Binding Combs', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10001524', 'GBC Premium Transparent Covers with Diagonal Lined Pattern', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10001543', 'GBC VeloBinder Manual Binding System', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10001634', 'Wilson Jones Active Use Binders', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10001636', 'Ibico Plastic and Wire Spiral Binding Combs', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10001658', 'GBC Standard Therm-A-Bind Covers', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10001670', 'Vinyl Sectional Post Binders', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10001679', 'GBC Instant Index System for Binding Systems', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10001721', 'Trimflex Flexible Post Binders', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10001890', 'Avery Poly Binder Pockets', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10001922', 'Storex Dura Pro Binders', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10001982', 'Wilson Jones Custom Binder Spines & Labels', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10001989', 'Premium Transparent Presentation Covers by GBC', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10002160', 'Acco Hanging Data Binders', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10002194', 'Cardinal Hold-It CD Pocket', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10002225', 'Square Ring Data Binders, Rigid 75 Pt. Covers, 11" x 14-7/8"', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10002309', 'Avery Heavy-Duty EZD  Binder With Locking Rings', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10002412', 'Wilson Jones ?Snap? Scratch Pad Binder Tool for Ring Binders', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10002429', 'Premier Elliptical Ring Binder, Black', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10002498', 'Clear Mylar Reinforcing Strips', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10002557', 'Presstex Flexible Ring Binders', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10002609', 'Avery Hidden Tab Dividers for Binding Systems', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10002706', 'Avery Premier Heavy-Duty Binder with Round Locking Rings', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10002735', 'GBC Prestige Therm-A-Bind Covers', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10002764', 'Recycled Pressboard Report Cover with Reinforced Top Hinge', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10002824', 'Recycled Easel Ring Binders', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10002827', 'Avery Durable Poly Binders', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10002949', 'Prestige Round Ring Binders', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10003274', 'Avery Durable Slant Ring Binders, No Labels', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10003291', 'Wilson Jones Leather-Like Binders with DublLock Round Rings', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10003305', 'Avery Hanging File Binders', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10003460', 'Acco 3-Hole Punch', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10003638', 'GBC Durable Plastic Covers', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10003656', 'Fellowes PB200 Plastic Comb Binding Machine', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10003910', 'DXL Angle-View Binders with Locking Rings by Samsill', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10003981', 'Avery Durable Plastic 1" Binders', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10003982', 'Wilson Jones Century Plastic Molded Ring Binders', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10004002', 'Wilson Jones International Size A4 Ring Binders', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10004182', 'Economy Binders', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10004492', 'Tuf-Vin Binders', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10004584', 'GBC ProClick 150 Presentation Binding System', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10004593', 'Ibico Laser Imprintable Binding System Covers', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10004632', 'Ibico Hi-Tech Manual Binding System', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10004654', 'Avery Binding System Hidden Tab Executive Style Index Sets', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10004728', 'Wilson Jones Turn Tabs Binder Tool for Ring Binders', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10004738', 'Flexible Leather- Look Classic Collection Ring Binder', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10004781', 'GBC Wire Binding Strips', 16, true);
INSERT INTO public.product VALUES ('OFF-BI-10004995', 'GBC DocuBind P400 Electric Binding System', 16, true);
INSERT INTO public.product VALUES ('OFF-EN-10000483', 'White Envelopes, White Envelopes with Clear Poly Window', 15, true);
INSERT INTO public.product VALUES ('OFF-EN-10001137', '#10 Gummed Flap White Envelopes, 100/Box', 15, true);
INSERT INTO public.product VALUES ('OFF-EN-10001141', 'Manila Recycled Extra-Heavyweight Clasp Envelopes, 6" x 9"', 15, true);
INSERT INTO public.product VALUES ('OFF-EN-10001219', '#10- 4 1/8" x 9 1/2" Security-Tint Envelopes', 15, true);
INSERT INTO public.product VALUES ('OFF-EN-10001415', 'Staple envelope', 15, true);
INSERT INTO public.product VALUES ('OFF-EN-10001990', 'Staple envelope', 15, true);
INSERT INTO public.product VALUES ('OFF-EN-10002230', 'Airmail Envelopes', 15, true);
INSERT INTO public.product VALUES ('OFF-EN-10002500', 'Globe Weis Peel & Seel First Class Envelopes', 15, true);
INSERT INTO public.product VALUES ('OFF-EN-10003296', 'Tyvek Side-Opening Peel & Seel Expanding Envelopes', 15, true);
INSERT INTO public.product VALUES ('OFF-EN-10004030', 'Convenience Packs of Business Envelopes', 15, true);
INSERT INTO public.product VALUES ('OFF-EN-10004386', 'Recycled Interoffice Envelopes with String and Button Closure, 10 x 13', 15, true);
INSERT INTO public.product VALUES ('OFF-EN-10004459', 'Security-Tint Envelopes', 15, true);
INSERT INTO public.product VALUES ('OFF-FA-10000134', 'Advantus Push Pins, Aluminum Head', 9, true);
INSERT INTO public.product VALUES ('OFF-FA-10000304', 'Advantus Push Pins', 9, true);
INSERT INTO public.product VALUES ('OFF-FA-10000585', 'OIC Bulk Pack Metal Binder Clips', 9, true);
INSERT INTO public.product VALUES ('OFF-FA-10000621', 'OIC Colored Binder Clips, Assorted Sizes', 9, true);
INSERT INTO public.product VALUES ('OFF-FA-10000624', 'OIC Binder Clips', 9, true);
INSERT INTO public.product VALUES ('OFF-FA-10002280', 'Advantus Plastic Paper Clips', 9, true);
INSERT INTO public.product VALUES ('OFF-FA-10002780', 'Staples', 9, true);
INSERT INTO public.product VALUES ('OFF-FA-10002983', 'Advantus SlideClip Paper Clips', 9, true);
INSERT INTO public.product VALUES ('OFF-FA-10002988', 'Ideal Clamps', 9, true);
INSERT INTO public.product VALUES ('OFF-FA-10003112', 'Staples', 9, true);
INSERT INTO public.product VALUES ('OFF-FA-10003472', 'Bagged Rubber Bands', 9, true);
INSERT INTO public.product VALUES ('OFF-FA-10004248', 'Advantus T-Pin Paper Clips', 9, true);
INSERT INTO public.product VALUES ('OFF-LA-10000134', 'Avery 511', 1, true);
INSERT INTO public.product VALUES ('OFF-LA-10000240', 'Self-Adhesive Address Labels for Typewriters by Universal', 1, true);
INSERT INTO public.product VALUES ('OFF-LA-10000634', 'Avery 509', 1, true);
INSERT INTO public.product VALUES ('OFF-LA-10001074', 'Round Specialty Laser Printer Labels', 1, true);
INSERT INTO public.product VALUES ('OFF-LA-10001158', 'Avery Address/Shipping Labels for Typewriters, 4" x 2"', 1, true);
INSERT INTO public.product VALUES ('OFF-LA-10001297', 'Avery 473', 1, true);
INSERT INTO public.product VALUES ('OFF-LA-10001317', 'Avery 520', 1, true);
INSERT INTO public.product VALUES ('OFF-LA-10002043', 'Avery 489', 1, true);
INSERT INTO public.product VALUES ('OFF-LA-10002475', 'Avery 519', 1, true);
INSERT INTO public.product VALUES ('OFF-LA-10002787', 'Avery 480', 1, true);
INSERT INTO public.product VALUES ('OFF-LA-10003223', 'Avery 508', 1, true);
INSERT INTO public.product VALUES ('OFF-LA-10003766', 'Self-Adhesive Removable Labels', 1, true);
INSERT INTO public.product VALUES ('OFF-LA-10003923', 'Alphabetical Labels for Top Tab Filing', 1, true);
INSERT INTO public.product VALUES ('OFF-LA-10003930', 'Dot Matrix Printer Tape Reel Labels, White, 5000/Box', 1, true);
INSERT INTO public.product VALUES ('OFF-LA-10004093', 'Avery 486', 1, true);
INSERT INTO public.product VALUES ('OFF-LA-10004345', 'Avery 493', 1, true);
INSERT INTO public.product VALUES ('OFF-LA-10004484', 'Avery 476', 1, true);
INSERT INTO public.product VALUES ('OFF-LA-10004689', 'Avery 512', 1, true);
INSERT INTO public.product VALUES ('OFF-LA-10004853', 'Avery 483', 1, true);
INSERT INTO public.product VALUES ('OFF-PA-10000157', 'Xerox 191', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10000249', 'Easy-staple paper', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10000304', 'Xerox 1995', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10000357', 'White Dual Perf Computer Printout Paper, 2700 Sheets, 1 Part, Heavyweight, 20 lbs., 14 7/8 x 11', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10000474', 'Easy-staple paper', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10000482', 'Snap-A-Way Black Print Carbonless Ruled Speed Letter, Triplicate', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10000587', 'Array Parchment Paper, Assorted Colors', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10000673', 'Post-it ?Important Message? Note Pad, Neon Colors, 50 Sheets/Pad', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10001204', 'Xerox 1972', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10001560', 'Adams Telephone Message Books, 5 1/4? x 11?', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10001569', 'Xerox 232', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10001667', 'Great White Multi-Use Recycled Paper (20Lb. and 84 Bright)', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10001736', 'Xerox 1880', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10001790', 'Xerox 1910', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10001804', 'Xerox 195', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10001870', 'Xerox 202', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10001934', 'Xerox 1993', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10001950', 'Southworth 25% Cotton Antique Laid Paper & Envelopes', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10001954', 'Xerox 1964', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10001970', 'Xerox 1881', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10002005', 'Xerox 225', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10002036', 'Xerox 1930', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10002105', 'Xerox 223', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10002137', 'Southworth 100% Rsum Paper, 24lb.', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10002222', 'Xerox Color Copier Paper, 11" x 17", Ream', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10002230', 'Xerox 1897', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10002365', 'Xerox 1967', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10002377', 'Adams Telephone Message Book W/Dividers/Space For Phone Numbers, 5 1/4"X8 1/2", 200/Messages', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10002479', 'Xerox 4200 Series MultiUse Premium Copy Paper (20Lb. and 84 Bright)', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10002552', 'Xerox 1958', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10002615', 'Ampad Gold Fibre Wirebound Steno Books, 6" x 9", Gregg Ruled', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10002666', 'Southworth 25% Cotton Linen-Finish Paper & Envelopes', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10002713', 'Adams Phone Message Book, 200 Message Capacity, 8 1/16? x 11?', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10002749', 'Wirebound Message Books, 5-1/2 x 4 Forms, 2 or 4 Forms per Page', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10002751', 'Xerox 1920', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10002893', 'Wirebound Service Call Books, 5 1/2" x 4"', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10002986', 'Xerox 1898', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10003039', 'Xerox 1960', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10003256', 'Avery Personal Creations Heavyweight Cards', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10003349', 'Xerox 1957', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10003441', 'Xerox 226', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10003651', 'Xerox 1968', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10003724', 'Wirebound Message Book, 4 per Page', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10003845', 'Xerox 1987', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10003892', 'Xerox 1943', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10003953', 'Xerox 218', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10004040', 'Universal Premium White Copier/Laser Paper (20Lb. and 87 Bright)', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10004092', 'Tops Green Bar Computer Printout Paper', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10004101', 'Xerox 1894', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10004243', 'Xerox 1939', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10004327', 'Xerox 1911', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10004451', 'Xerox 222', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10004470', 'Adams Write n'' Stick Phone Message Book, 11" X 5 1/4", 200 Messages', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10004530', 'Personal Creations Ink Jet Cards and Labels', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10004569', 'Wirebound Message Books, Two 4 1/4" x 5" Forms per Page', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10004675', 'Telephone Message Books with Fax/Mobile Section, 5 1/2" x 3 3/16"', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10004734', 'Southworth Structures Collection', 6, true);
INSERT INTO public.product VALUES ('OFF-PA-10004971', 'Xerox 196', 6, true);
INSERT INTO public.product VALUES ('OFF-ST-10000036', 'Recycled Data-Pak for Archival Bound Computer Printouts, 12-1/2 x 12-1/2 x 16', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10000060', 'Fellowes Bankers Box Staxonsteel Drawer File/Stacking System', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10000142', 'Deluxe Rollaway Locking File with Drawer', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10000585', 'Economy Rollaway Files', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10000604', 'Home/Office Personal File Carts', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10000615', 'SimpliFile Personal File, Black Granite, 15w x 6-15/16d x 11-1/4h', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10000617', 'Woodgrain Magazine Files by Perma', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10000642', 'Tennsco Lockers, Gray', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10000675', 'File Shuttle II and Handi-File, Black', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10000689', 'Fellowes Strictly Business Drawer File, Letter/Legal Size', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10000736', 'Carina Double Wide Media Storage Towers in Natural & Black', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10000777', 'Companion Letter/Legal File, Black', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10000798', '2300 Heavy-Duty Transfer File Systems by Perma', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10000876', 'Eldon Simplefile Box Office', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10000918', 'Crate-A-Files', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10000934', 'Contico 72"H Heavy-Duty Storage System', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10001228', 'Fellowes Personal Hanging Folder Files, Navy', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10001325', 'Sterilite Officeware Hinged File Box', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10001328', 'Personal Filing Tote with Lid, Black/Gray', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10001414', 'Decoflex Hanging Personal Folder File', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10001469', 'Fellowes Bankers Box Recycled Super Stor/Drawer', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10001522', 'Gould Plastics 18-Pocket Panel Bin, 34w x 5-1/4d x 20-1/2h', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10001580', 'Super Decoflex Portable Personal File', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10001780', 'Tennsco 16-Compartment Lockers with Coat Rack', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10001963', 'Tennsco Regal Shelving Units', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10002205', 'File Shuttle I and Handi-File', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10002406', 'Pizazz Global Quick File', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10002583', 'Fellowes Neat Ideas Storage Cubes', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10002756', 'Tennsco Stur-D-Stor Boltless Shelving, 5 Shelves, 24" Deep, Sand', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10002790', 'Safco Industrial Shelving', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10002974', 'Trav-L-File Heavy-Duty Shuttle II, Black', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10003058', 'Eldon Mobile Mega Data Cart  Mega Stackable  Add-On Trays', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10003208', 'Adjustable Depth Letter/Legal Cart', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10003282', 'Advantus 10-Drawer Portable Organizer, Chrome Metal Frame, Smoke Drawers', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10003306', 'Letter Size Cart', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10003442', 'Eldon Portable Mobile Manager', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10003479', 'Eldon Base for stackable storage shelf, platinum', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10003656', 'Safco Industrial Wire Shelving', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10004180', 'Safco Commercial Shelving', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10004459', 'Tennsco Single-Tier Lockers', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10004507', 'Advantus Rolling Storage Box', 11, true);
INSERT INTO public.product VALUES ('OFF-ST-10004634', 'Personal Folder Holder, Ebony', 11, true);
INSERT INTO public.product VALUES ('OFF-SU-10000381', 'Acme Forged Steel Scissors with Black Enamel Handles', 3, true);
INSERT INTO public.product VALUES ('OFF-SU-10000646', 'Premier Automatic Letter Opener', 3, true);
INSERT INTO public.product VALUES ('OFF-SU-10001218', 'Fiskars Softgrip Scissors', 3, true);
INSERT INTO public.product VALUES ('OFF-SU-10001225', 'Staple remover', 3, true);
INSERT INTO public.product VALUES ('OFF-SU-10001574', 'Acme Value Line Scissors', 3, true);
INSERT INTO public.product VALUES ('OFF-SU-10002503', 'Acme Preferred Stainless Steel Scissors', 3, true);
INSERT INTO public.product VALUES ('OFF-SU-10003505', 'Premier Electric Letter Opener', 3, true);
INSERT INTO public.product VALUES ('OFF-SU-10004115', 'Acme Stainless Steel Office Snips', 3, true);
INSERT INTO public.product VALUES ('OFF-SU-10004231', 'Acme Tagit Stainless Steel Antibacterial Scissors', 3, true);
INSERT INTO public.product VALUES ('OFF-SU-10004261', 'Fiskars 8" Scissors, 2/Pack', 3, true);
INSERT INTO public.product VALUES ('OFF-SU-10004498', 'Martin-Yale Premier Letter Opener', 3, true);
INSERT INTO public.product VALUES ('OFF-SU-10004664', 'Acme Softgrip Scissors', 3, true);
INSERT INTO public.product VALUES ('TEC-AC-10000158', 'Sony 64GB Class 10 Micro SDHC R40 Memory Card', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10000171', 'Verbatim 25 GB 6x Blu-ray Single Layer Recordable Disc, 25/Pack', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10000290', 'Sabrent 4-Port USB 2.0 Hub', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10000991', 'Sony Micro Vault Click 8 GB USB 2.0 Flash Drive', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10001101', 'Sony 16GB Class 10 Micro SDHC R40 Memory Card', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10001142', 'First Data FD10 PIN Pad', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10001267', 'Imationÿ32GB Pocket Pro USB 3.0ÿFlash Driveÿ- 32 GB - Black - 1 P ...', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10001606', 'Logitech Wireless Performance Mouse MX for PC and Mac', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10001714', 'LogitechÿMX Performance Wireless Mouse', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10001767', 'SanDisk Ultra 64 GB MicroSDHC Class 10 Memory Card', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10001772', 'Memorex Mini Travel Drive 16 GB USB 2.0 Flash Drive', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10001838', 'Razer Tiamat Over Ear 7.1 Surround Sound PC Gaming Headset', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10001908', 'Logitech Wireless Headset h800', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10001998', 'LogitechÿLS21 Speaker System - PC Multimedia - 2.1-CH - Wired', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10002001', 'Logitech Wireless Gaming Headset G930', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10002049', 'Logitech G19 Programmable Gaming Keyboard', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10002167', 'Imationÿ8gb Micro Traveldrive Usb 2.0ÿFlash Drive', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10002399', 'SanDisk Cruzer 32 GB USB Flash Drive', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10002402', 'Razer Kraken PRO Over Ear PC and Music Headset', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10002857', 'Verbatim 25 GB 6x Blu-ray Single Layer Recordable Disc, 1/Pack', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10003027', 'Imationÿ8GB Mini TravelDrive USB 2.0ÿFlash Drive', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10003499', 'Memorex Mini Travel Drive 8 GB USB 2.0 Flash Drive', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10003610', 'LogitechÿIlluminated - Keyboard', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10003614', 'Verbatim 25 GB 6x Blu-ray Single Layer Recordable Disc, 10/Pack', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10003628', 'Logitech 910-002974 M325 Wireless Mouse for Web Scrolling', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10003832', 'Imationÿ16GB Mini TravelDrive USB 2.0ÿFlash Drive', 5, true);
INSERT INTO public.product VALUES ('TEC-AC-10004659', 'ImationÿSecure+ Hardware Encrypted USB 2.0ÿFlash Drive; 16GB', 5, true);
INSERT INTO public.product VALUES ('TEC-CO-10002095', 'Hewlett Packard 610 Color Digital Copier / Printer', 4, true);
INSERT INTO public.product VALUES ('TEC-CO-10003236', 'Canon Image Class D660 Copier', 4, true);
INSERT INTO public.product VALUES ('TEC-CO-10004115', 'Sharp AL-1530CS Digital Copier', 4, true);
INSERT INTO public.product VALUES ('TEC-MA-10002937', 'Canon Color ImageCLASS MF8580Cdw Wireless Laser All-In-One Printer, Copier, Scanner', 17, true);
INSERT INTO public.product VALUES ('TEC-MA-10004002', 'Zebra GX420t Direct Thermal/Thermal Transfer Printer', 17, true);
INSERT INTO public.product VALUES ('TEC-MA-10004125', 'Cubify CubeX 3D Printer Triple Head Print', 17, true);
INSERT INTO public.product VALUES ('TEC-PH-10000004', 'Belkin iPhone and iPad Lightning Cable', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10000011', 'PureGear Roll-On Screen Protector', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10000149', 'Cisco SPA525G2 IP Phone - Wireless', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10000215', 'Plantronics CordlessÿPhone Headsetÿwith In-line Volume - M214C', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10000347', 'Cush Cases Heavy Duty Rugged Cover Case for Samsung Galaxy S5 - Purple', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10000586', 'AT&T SB67148 SynJ', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10000984', 'Panasonic KX-TG9471B', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10001254', 'Jabra BIZ 2300 Duo QD Duo CordedÿHeadset', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10001425', 'Mophie Juice Pack Helium for iPhone', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10001433', 'Cisco Small Business SPA 502G VoIP phone', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10001448', 'Anker Astro 15000mAh USB Portable Charger', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10001530', 'Cisco Unified IP Phone 7945G VoIP phone', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10001557', 'Pyle PMP37LED', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10001580', 'Logitech Mobile Speakerphone P710e -ÿspeaker phone', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10001700', 'Panasonic KX-TG6844B Expandable Digital Cordless Telephone', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10001918', 'Nortel Business Series Terminal T7208 Digital phone', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10001924', 'iHome FM Clock Radio with Lightning Dock', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10002085', 'Clarity 53712', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10002103', 'Jabra SPEAK 410', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10002170', 'ClearSounds CSC500 Amplified Spirit Phone Corded phone', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10002262', 'LG Electronics Tone+ HBS-730 Bluetooth Headset', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10002293', 'Anker 36W 4-Port USB Wall Charger Travel Power Adapter for iPhone 5s 5c 5', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10002365', 'Belkin Grip Candy Sheer Case / Cover for iPhone 5 and 5S', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10002447', 'AT&T CL83451 4-Handset Telephone', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10002496', 'Cisco SPA301', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10002538', 'Grandstream GXP1160 VoIP phone', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10002563', 'Adtran 1202752G1', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10002844', 'Speck Products Candyshell Flip Case', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10002923', 'Logitech B530 USBÿHeadsetÿ-ÿheadsetÿ- Full size, Binaural', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10003012', 'Nortel Meridian M3904 Professional Digital phone', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10003273', 'AT&T TR1909W', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10003555', 'Motorola HK250 Universal Bluetooth Headset', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10003645', 'Aastra 57i VoIP phone', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10003800', 'i.Sound Portable Power - 8000 mAh', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10003875', 'KLD Oscar II Style Snap-on Ultra Thin Side Flip Synthetic Leather Cover Case for HTC One HTC M7', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10003963', 'GE 2-Jack Phone Line Splitter', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10003988', 'LF Elite 3D Dazzle Designer Hard Case Cover, Lf Stylus Pen and Wiper For Apple Iphone 5c Mini Lite', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10004042', 'ClearOne Communications CHAT 70 OCÿSpeaker Phone', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10004093', 'Panasonic Kx-TS550', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10004536', 'Avaya 5420 Digital phone', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10004614', 'AT&T 841000 Phone', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10004667', 'Cisco 8x8 Inc. 6753i IP Business Phone System', 7, true);
INSERT INTO public.product VALUES ('TEC-PH-10004977', 'GE 30524EE4', 7, true);


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.region OVERRIDING SYSTEM VALUE VALUES (1, 'Central');
INSERT INTO public.region OVERRIDING SYSTEM VALUE VALUES (2, 'East');
INSERT INTO public.region OVERRIDING SYSTEM VALUE VALUES (3, 'South');
INSERT INTO public.region OVERRIDING SYSTEM VALUE VALUES (4, 'West');


--
-- Data for Name: segment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.segment OVERRIDING SYSTEM VALUE VALUES (1, 'Consumer');
INSERT INTO public.segment OVERRIDING SYSTEM VALUE VALUES (2, 'Corporate');
INSERT INTO public.segment OVERRIDING SYSTEM VALUE VALUES (3, 'Home Office');


--
-- Data for Name: ship_mode; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ship_mode OVERRIDING SYSTEM VALUE VALUES (1, 'First Class');
INSERT INTO public.ship_mode OVERRIDING SYSTEM VALUE VALUES (2, 'Same Day');
INSERT INTO public.ship_mode OVERRIDING SYSTEM VALUE VALUES (3, 'Second Class');
INSERT INTO public.ship_mode OVERRIDING SYSTEM VALUE VALUES (4, 'Standard Class');


--
-- Data for Name: state; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (1, 'Texas', 1, 1);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (2, 'Missouri', 1, 1);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (3, 'New Jersey', 1, 2);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (4, 'Louisiana', 1, 3);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (5, 'Virginia', 1, 3);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (6, 'Mississippi', 1, 3);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (7, 'Minnesota', 1, 1);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (8, 'Rhode Island', 1, 2);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (9, 'Georgia', 1, 3);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (10, 'South Carolina', 1, 3);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (11, 'Tennessee', 1, 3);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (12, 'North Carolina', 1, 3);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (13, 'Oregon', 1, 4);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (14, 'New Hampshire', 1, 2);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (15, 'Kentucky', 1, 3);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (16, 'Connecticut', 1, 2);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (17, 'Wisconsin', 1, 1);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (18, 'California', 1, 4);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (19, 'Colorado', 1, 4);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (20, 'Ohio', 1, 2);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (21, 'Washington', 1, 4);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (22, 'Indiana', 1, 1);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (23, 'Pennsylvania', 1, 2);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (24, 'Massachusetts', 1, 2);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (25, 'New Mexico', 1, 4);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (26, 'Alabama', 1, 3);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (27, 'Oklahoma', 1, 1);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (28, 'Illinois', 1, 1);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (29, 'Florida', 1, 3);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (30, 'Nebraska', 1, 1);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (31, 'Delaware', 1, 2);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (32, 'Michigan', 1, 1);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (33, 'Nevada', 1, 4);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (34, 'Iowa', 1, 1);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (35, 'Montana', 1, 4);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (36, 'New York', 1, 2);
INSERT INTO public.state OVERRIDING SYSTEM VALUE VALUES (37, 'Arizona', 1, 4);


--
-- Data for Name: sub_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sub_category OVERRIDING SYSTEM VALUE VALUES (1, 'Labels', 2);
INSERT INTO public.sub_category OVERRIDING SYSTEM VALUE VALUES (2, 'Tables', 1);
INSERT INTO public.sub_category OVERRIDING SYSTEM VALUE VALUES (3, 'Supplies', 2);
INSERT INTO public.sub_category OVERRIDING SYSTEM VALUE VALUES (4, 'Copiers', 3);
INSERT INTO public.sub_category OVERRIDING SYSTEM VALUE VALUES (5, 'Accessories', 3);
INSERT INTO public.sub_category OVERRIDING SYSTEM VALUE VALUES (6, 'Paper', 2);
INSERT INTO public.sub_category OVERRIDING SYSTEM VALUE VALUES (7, 'Phones', 3);
INSERT INTO public.sub_category OVERRIDING SYSTEM VALUE VALUES (8, 'Chairs', 1);
INSERT INTO public.sub_category OVERRIDING SYSTEM VALUE VALUES (9, 'Fasteners', 2);
INSERT INTO public.sub_category OVERRIDING SYSTEM VALUE VALUES (10, 'Furnishings', 1);
INSERT INTO public.sub_category OVERRIDING SYSTEM VALUE VALUES (11, 'Storage', 2);
INSERT INTO public.sub_category OVERRIDING SYSTEM VALUE VALUES (12, 'Art', 2);
INSERT INTO public.sub_category OVERRIDING SYSTEM VALUE VALUES (13, 'Bookcases', 1);
INSERT INTO public.sub_category OVERRIDING SYSTEM VALUE VALUES (14, 'Appliances', 2);
INSERT INTO public.sub_category OVERRIDING SYSTEM VALUE VALUES (15, 'Envelopes', 2);
INSERT INTO public.sub_category OVERRIDING SYSTEM VALUE VALUES (16, 'Binders', 2);
INSERT INTO public.sub_category OVERRIDING SYSTEM VALUE VALUES (17, 'Machines', 3);


--
-- Name: category_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.category_category_id_seq', 3, true);


--
-- Name: city_city_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.city_city_id_seq', 129, true);


--
-- Name: country_country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.country_country_id_seq', 1, true);


--
-- Name: order_item_order_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_item_order_item_id_seq', 497, true);


--
-- Name: region_region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.region_region_id_seq', 4, true);


--
-- Name: segment_segment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.segment_segment_id_seq', 3, true);


--
-- Name: ship_mode_ship_mode_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ship_mode_ship_mode_id_seq', 4, true);


--
-- Name: state_state_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.state_state_id_seq', 37, true);


--
-- Name: sub_category_sub_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sub_category_sub_category_id_seq', 17, true);


--
-- Name: category category_category_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_category_name_key UNIQUE (category_name);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (category_id);


--
-- Name: city city_city_name_state_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.city
    ADD CONSTRAINT city_city_name_state_id_key UNIQUE (city_name, state_id);


--
-- Name: city city_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.city
    ADD CONSTRAINT city_pkey PRIMARY KEY (city_id);


--
-- Name: country country_country_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.country
    ADD CONSTRAINT country_country_name_key UNIQUE (country_name);


--
-- Name: country country_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.country
    ADD CONSTRAINT country_pkey PRIMARY KEY (country_id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);


--
-- Name: order_item order_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_pkey PRIMARY KEY (order_item_id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: product product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product_id);


--
-- Name: region region_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (region_id);


--
-- Name: region region_region_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_region_name_key UNIQUE (region_name);


--
-- Name: segment segment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.segment
    ADD CONSTRAINT segment_pkey PRIMARY KEY (segment_id);


--
-- Name: segment segment_segment_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.segment
    ADD CONSTRAINT segment_segment_name_key UNIQUE (segment_name);


--
-- Name: ship_mode ship_mode_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ship_mode
    ADD CONSTRAINT ship_mode_pkey PRIMARY KEY (ship_mode_id);


--
-- Name: ship_mode ship_mode_ship_mode_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ship_mode
    ADD CONSTRAINT ship_mode_ship_mode_name_key UNIQUE (ship_mode_name);


--
-- Name: state state_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.state
    ADD CONSTRAINT state_pkey PRIMARY KEY (state_id);


--
-- Name: state state_state_name_country_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.state
    ADD CONSTRAINT state_state_name_country_id_key UNIQUE (state_name, country_id);


--
-- Name: sub_category sub_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sub_category
    ADD CONSTRAINT sub_category_pkey PRIMARY KEY (sub_category_id);


--
-- Name: sub_category sub_category_sub_category_name_category_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sub_category
    ADD CONSTRAINT sub_category_sub_category_name_category_id_key UNIQUE (sub_category_name, category_id);


--
-- Name: city city_state_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.city
    ADD CONSTRAINT city_state_id_fkey FOREIGN KEY (state_id) REFERENCES public.state(state_id);


--
-- Name: customer customer_segment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_segment_id_fkey FOREIGN KEY (segment_id) REFERENCES public.segment(segment_id);


--
-- Name: order_item order_item_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- Name: order_item order_item_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_item
    ADD CONSTRAINT order_item_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(product_id);


--
-- Name: orders orders_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.city(city_id);


--
-- Name: orders orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- Name: orders orders_ship_mode_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_ship_mode_id_fkey FOREIGN KEY (ship_mode_id) REFERENCES public.ship_mode(ship_mode_id);


--
-- Name: product product_sub_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_sub_category_id_fkey FOREIGN KEY (sub_category_id) REFERENCES public.sub_category(sub_category_id);


--
-- Name: state state_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.state
    ADD CONSTRAINT state_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.country(country_id);


--
-- Name: state state_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.state
    ADD CONSTRAINT state_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.region(region_id);


--
-- Name: sub_category sub_category_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sub_category
    ADD CONSTRAINT sub_category_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.category(category_id);


--
-- PostgreSQL database dump complete
--

\unrestrict OcEUM1a7MIkNplIaSbdV6B6QfxXBf8gzRAWfZfigMucaNzVQ0fYqWKocZlB3GOE

