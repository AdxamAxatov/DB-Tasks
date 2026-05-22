--
-- PostgreSQL database dump
--

\restrict CeiPnqgpF9Q8kh7PmaHx0UjPtgb8nWM4KqC9QeNQvWY2l6hp8SvCt9fh1Wo7bFf

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
-- Name: dim_customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dim_customer (
    customer_id integer NOT NULL,
    customer_code character varying(10) NOT NULL,
    customer_name character varying(100) NOT NULL,
    segment_name character varying(50) NOT NULL,
    CONSTRAINT chk_segment_name_valid CHECK (((segment_name)::text = ANY ((ARRAY['Consumer'::character varying, 'Corporate'::character varying, 'Home Office'::character varying])::text[])))
);


ALTER TABLE public.dim_customer OWNER TO postgres;

--
-- Name: dim_customer_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.dim_customer ALTER COLUMN customer_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.dim_customer_customer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: dim_date; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dim_date (
    date_id integer NOT NULL,
    full_date date NOT NULL,
    year integer NOT NULL,
    quarter integer NOT NULL,
    month integer NOT NULL,
    month_name character varying(10) NOT NULL,
    day integer NOT NULL,
    day_of_week integer NOT NULL,
    day_name character varying(10) NOT NULL,
    is_weekend boolean NOT NULL
);


ALTER TABLE public.dim_date OWNER TO postgres;

--
-- Name: dim_location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dim_location (
    location_id integer NOT NULL,
    city_name character varying(100) NOT NULL,
    state_name character varying(50) NOT NULL,
    region_name character varying(50) NOT NULL,
    country_name character varying(100) NOT NULL,
    CONSTRAINT chk_region_name_valid CHECK (((region_name)::text = ANY ((ARRAY['South'::character varying, 'East'::character varying, 'West'::character varying, 'Central'::character varying])::text[])))
);


ALTER TABLE public.dim_location OWNER TO postgres;

--
-- Name: dim_location_location_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.dim_location ALTER COLUMN location_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.dim_location_location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: dim_product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dim_product (
    product_id integer NOT NULL,
    product_code character varying(20) NOT NULL,
    product_name character varying(255) NOT NULL,
    sub_category_name character varying(50) NOT NULL,
    category_name character varying(50) NOT NULL,
    CONSTRAINT chk_product_code_format CHECK (((product_code)::text ~ '^[A-Z]{3}-[A-Z]{2}-[0-9]+$'::text))
);


ALTER TABLE public.dim_product OWNER TO postgres;

--
-- Name: dim_product_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.dim_product ALTER COLUMN product_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.dim_product_product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: dim_ship_mode; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dim_ship_mode (
    ship_mode_id integer NOT NULL,
    ship_mode_name character varying(50) NOT NULL,
    CONSTRAINT chk_ship_mode_name_valid CHECK (((ship_mode_name)::text = ANY ((ARRAY['Standard Class'::character varying, 'Second Class'::character varying, 'First Class'::character varying, 'Same Day'::character varying])::text[])))
);


ALTER TABLE public.dim_ship_mode OWNER TO postgres;

--
-- Name: dim_ship_mode_ship_mode_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.dim_ship_mode ALTER COLUMN ship_mode_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.dim_ship_mode_ship_mode_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: fact_sales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fact_sales (
    sale_id integer NOT NULL,
    order_id character varying(20) NOT NULL,
    order_date_id integer NOT NULL,
    ship_date_id integer NOT NULL,
    customer_id integer NOT NULL,
    product_id integer NOT NULL,
    location_id integer NOT NULL,
    ship_mode_id integer NOT NULL,
    quantity integer NOT NULL,
    sales numeric(10,2) NOT NULL,
    profit numeric(10,2) NOT NULL,
    unit_price numeric(10,2) GENERATED ALWAYS AS ((sales / (quantity)::numeric)) STORED,
    days_to_ship integer NOT NULL,
    CONSTRAINT chk_days_to_ship_non_negative CHECK ((days_to_ship >= 0)),
    CONSTRAINT chk_quantity_positive CHECK ((quantity > 0)),
    CONSTRAINT chk_sales_non_negative CHECK ((sales >= (0)::numeric))
);


ALTER TABLE public.fact_sales OWNER TO postgres;

--
-- Name: fact_sales_sale_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.fact_sales ALTER COLUMN sale_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.fact_sales_sale_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: dim_customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (1, 'AA-10375', 'Allen Armold', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (2, 'AA-10480', 'Andrew Allen', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (3, 'AB-10060', 'Adam Bellavance', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (4, 'AD-10180', 'Alan Dominguez', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (5, 'AG-10495', 'Andrew Gjertsen', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (6, 'AG-10675', 'Anna Gayman', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (7, 'AH-10195', 'Alan Haines', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (8, 'AJ-10795', 'Anthony Johnson', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (9, 'AM-10360', 'Alice McCarthy', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (10, 'AP-10915', 'Arthur Prichep', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (11, 'AR-10405', 'Allen Rosenblatt', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (12, 'AR-10825', 'Anthony Rawles', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (13, 'AS-10135', 'Adrian Shami', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (14, 'AS-10285', 'Alejandro Savely', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (15, 'AT-10735', 'Annie Thurman', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (16, 'BB-10990', 'Barry Blumstein', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (17, 'BB-11545', 'Brenda Bowman', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (18, 'BD-11320', 'Bill Donatelli', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (19, 'BD-11605', 'Brian Dahlen', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (20, 'BF-11020', 'Barry Franzsisch', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (21, 'BN-11515', 'Bradley Nguyen', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (22, 'BP-11185', 'Ben Peterman', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (23, 'BV-11245', 'Benjamin Venier', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (24, 'CA-12310', 'Christine Abelman', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (25, 'CB-12535', 'Claudia Bergmann', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (26, 'CC-12430', 'Chuck Clark', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (27, 'CC-12550', 'Clay Cheatham', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (28, 'CC-12670', 'Craig Carreira', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (29, 'CD-11980', 'Carol Darley', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (30, 'CG-12520', 'Claire Gute', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (31, 'CJ-12010', 'Caroline Jumper', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (32, 'CK-12205', 'Chloris Kastensmidt', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (33, 'CK-12595', 'Clytie Kelty', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (34, 'CL-12565', 'Clay Ludtke', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (35, 'CP-12340', 'Christine Phan', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (36, 'CR-12730', 'Craig Reiter', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (37, 'CS-11950', 'Carlos Soltero', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (38, 'CS-12400', 'Christopher Schild', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (39, 'CV-12805', 'Cynthia Voltz', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (40, 'DB-13060', 'Dave Brooks', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (41, 'DB-13120', 'David Bremer', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (42, 'DB-13210', 'Dean Braden', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (43, 'DJ-13510', 'Don Jones', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (44, 'DJ-13630', 'Doug Jacobs', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (45, 'DK-13225', 'Dean Katz', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (46, 'DL-13315', 'Delfina Latchford', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (47, 'Dl-13600', 'Dorris liebe', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (48, 'DP-13105', 'Dave Poirier', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (49, 'DS-13030', 'Darrin Sayre', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (50, 'DS-13180', 'David Smith', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (51, 'DV-13045', 'Darrin Van Huff', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (52, 'DV-13465', 'Dianna Vittorini', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (53, 'DW-13585', 'Dorothy Wardle', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (54, 'EB-13705', 'Ed Braxton', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (55, 'EB-13840', 'Ellis Ballard', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (56, 'EG-13900', 'Emily Grady', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (57, 'EH-13945', 'Eric Hoffmann', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (58, 'EH-14125', 'Eugene Hildebrand', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (59, 'EM-14095', 'Eudokia Martin', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (60, 'EP-13915', 'Emily Phan', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (61, 'ER-13855', 'Elpida Rittenbach', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (62, 'ES-14080', 'Erin Smith', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (63, 'FH-14365', 'Fred Hopkins', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (64, 'FM-14380', 'Fred McMath', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (65, 'FP-14320', 'Frank Preis', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (66, 'GA-14725', 'Guy Armstrong', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (67, 'GD-14590', 'Giulietta Dortch', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (68, 'GH-14485', 'Gene Hale', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (69, 'GK-14620', 'Grace Kelly', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (70, 'GM-14440', 'Gary McGarr', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (71, 'GM-14455', 'Gary Mitchum', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (72, 'GT-14635', 'Grant Thornton', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (73, 'GT-14710', 'Greg Tran', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (74, 'GT-14755', 'Guy Thornton', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (75, 'GZ-14470', 'Gary Zandusky', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (76, 'HK-14890', 'Heather Kirkland', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (77, 'HM-14980', 'Henry MacAllister', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (78, 'HW-14935', 'Helen Wasserman', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (79, 'IM-15070', 'Irene Maddox', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (80, 'JB-15400', 'Jennifer Braxton', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (81, 'JC-15340', 'Jasper Cacioppo', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (82, 'JC-16105', 'Julie Creighton', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (83, 'JD-15895', 'Jonathan Doherty', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (84, 'JD-16150', 'Justin Deggeller', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (85, 'JE-15475', 'Jeremy Ellison', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (86, 'JE-15745', 'Joel Eaton', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (87, 'JE-16165', 'Justin Ellison', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (88, 'JF-15355', 'Jay Fein', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (89, 'JF-15415', 'Jennifer Ferguson', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (90, 'JG-15805', 'John Grady', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (91, 'JH-15910', 'Jonathan Howell', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (92, 'JH-15985', 'Joseph Holt', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (93, 'JK-15730', 'Joe Kamberova', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (94, 'JL-15175', 'James Lanier', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (95, 'JL-15505', 'Jeremy Lonsdale', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (96, 'JL-15835', 'John Lee', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (97, 'JL-15850', 'John Lucas', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (98, 'JM-15250', 'Janet Martin', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (99, 'JM-15265', 'Janet Molinari', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (100, 'JS-15685', 'Jim Sink', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (101, 'KB-16585', 'Ken Black', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (102, 'KB-16600', 'Ken Brennan', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (103, 'KC-16540', 'Kelly Collister', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (104, 'KC-16675', 'Kimberly Carter', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (105, 'KD-16270', 'Karen Daniels', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (106, 'KD-16345', 'Katherine Ducich', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (107, 'KH-16510', 'Keith Herrera', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (108, 'KH-16630', 'Ken Heidel', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (109, 'KH-16690', 'Kristen Hastings', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (110, 'KL-16645', 'Ken Lonsdale', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (111, 'KW-16435', 'Katrina Willman', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (112, 'LC-16885', 'Lena Creighton', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (113, 'LC-16930', 'Linda Cazamias', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (114, 'LC-17140', 'Logan Currie', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (115, 'LE-16810', 'Laurel Elliston', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (116, 'LF-17185', 'Luke Foster', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (117, 'LH-16900', 'Lena Hernandez', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (118, 'LH-17155', 'Logan Haushalter', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (119, 'LP-17080', 'Liz Pelletier', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (120, 'LS-16945', 'Linda Southworth', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (121, 'LS-16975', 'Lindsay Shagiari', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (122, 'LS-17245', 'Lynn Smith', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (123, 'MA-17560', 'Matt Abelman', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (124, 'MB-17305', 'Maria Bertelson', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (125, 'MC-17605', 'Matt Connell', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (126, 'MC-18130', 'Mike Caudle', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (127, 'ME-17725', 'Max Engle', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (128, 'MJ-17740', 'Max Jones', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (129, 'MK-17905', 'Michael Kennedy', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (130, 'MM-18280', 'Muhammed MacIntyre', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (131, 'MO-17800', 'Meg O''Connel', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (132, 'MP-17965', 'Michael Paige', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (133, 'MT-18070', 'Michelle Tran', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (134, 'MV-18190', 'Mike Vittorini', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (135, 'MY-17380', 'Maribeth Yedwab', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (136, 'NB-18655', 'Nona Balk', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (137, 'NF-18385', 'Natalie Fritzler', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (138, 'NG-18355', 'Nat Gilpin', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (139, 'NP-18670', 'Nora Paige', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (140, 'NZ-18565', 'Nick Zandusky', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (141, 'ON-18715', 'Odella Nelson', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (142, 'OT-18730', 'Olvera Toch', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (143, 'PB-19105', 'Peter Bhler', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (144, 'PB-19150', 'Philip Brown', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (145, 'PG-18895', 'Paul Gonzalez', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (146, 'PH-18790', 'Patricia Hirasaki', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (147, 'PJ-19015', 'Pauline Johnson', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (148, 'PK-18910', 'Paul Knutson', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (149, 'PK-19075', 'Pete Kriz', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (150, 'PN-18775', 'Parhena Norris', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (151, 'PO-18850', 'Patrick O''Brill', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (152, 'PO-18865', 'Patrick O''Donnell', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (153, 'PO-19180', 'Philisse Overcash', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (154, 'RA-19285', 'Ralph Arnett', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (155, 'RA-19885', 'Ruben Ausman', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (156, 'RB-19360', 'Raymond Buch', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (157, 'RB-19465', 'Rick Bensley', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (158, 'RB-19570', 'Rob Beeghly', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (159, 'RB-19705', 'Roger Barcio', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (160, 'RB-19795', 'Ross Baird', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (161, 'RC-19825', 'Roy Collins', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (162, 'RC-19960', 'Ryan Crowe', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (163, 'RD-19810', 'Ross DeVincentis', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (164, 'RD-19900', 'Ruben Dartt', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (165, 'RF-19735', 'Roland Fjeld', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (166, 'RF-19840', 'Roy Franzsisch', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (167, 'RH-19495', 'Rick Hansen', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (168, 'RL-19615', 'Rob Lucas', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (169, 'RO-19780', 'Rose O''Brian', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (170, 'RS-19765', 'Roland Schwarz', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (171, 'SC-20095', 'Sanjit Chand', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (172, 'SC-20305', 'Sean Christensen', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (173, 'SC-20695', 'Steve Chapman', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (174, 'SC-20725', 'Steven Cartwright', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (175, 'SC-20770', 'Stewart Carmichael', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (176, 'SF-20065', 'Sandra Flanagan', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (177, 'SF-20200', 'Sarah Foster', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (178, 'SG-20080', 'Sandra Glassco', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (179, 'SH-19975', 'Sally Hughsby', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (180, 'SH-20395', 'Shahid Hopkins', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (181, 'SJ-20125', 'Sanjit Jacobs', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (182, 'SJ-20500', 'Shirley Jackson', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (183, 'SK-19990', 'Sally Knutson', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (184, 'SP-20545', 'Sibella Parks', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (185, 'SP-20860', 'Sung Pak', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (186, 'SR-20740', 'Steven Roelle', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (187, 'SS-20140', 'Saphhira Shifley', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (188, 'SS-20590', 'Sonia Sunley', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (189, 'SS-20875', 'Sung Shariari', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (190, 'TB-21055', 'Ted Butterfield', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (191, 'TB-21520', 'Tracy Blumstein', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (192, 'TB-21595', 'Troy Blackwell', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (193, 'TD-20995', 'Tamara Dahlen', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (194, 'TH-21235', 'Tiffany House', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (195, 'TN-21040', 'Tanja Norvell', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (196, 'TP-21130', 'Theone Pippenger', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (197, 'TR-21325', 'Toby Ritter', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (198, 'TS-21610', 'Troy Staebel', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (199, 'TT-21070', 'Ted Trevino', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (200, 'TW-21025', 'Tamara Willingham', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (201, 'VB-21745', 'Victoria Brennan', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (202, 'VD-21670', 'Valerie Dominguez', 'Consumer');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (203, 'VM-21685', 'Valerie Mitchum', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (204, 'VP-21730', 'Victor Preis', 'Home Office');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (205, 'YC-21895', 'Yoseph Carroll', 'Corporate');
INSERT INTO public.dim_customer OVERRIDING SYSTEM VALUE VALUES (206, 'ZC-21910', 'Zuschuss Carroll', 'Consumer');


--
-- Data for Name: dim_date; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.dim_date VALUES (20190105, '2019-01-05', 2019, 1, 1, 'January', 5, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190106, '2019-01-06', 2019, 1, 1, 'January', 6, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190107, '2019-01-07', 2019, 1, 1, 'January', 7, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190108, '2019-01-08', 2019, 1, 1, 'January', 8, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190109, '2019-01-09', 2019, 1, 1, 'January', 9, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190110, '2019-01-10', 2019, 1, 1, 'January', 10, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190111, '2019-01-11', 2019, 1, 1, 'January', 11, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190112, '2019-01-12', 2019, 1, 1, 'January', 12, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190113, '2019-01-13', 2019, 1, 1, 'January', 13, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190114, '2019-01-14', 2019, 1, 1, 'January', 14, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190115, '2019-01-15', 2019, 1, 1, 'January', 15, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190116, '2019-01-16', 2019, 1, 1, 'January', 16, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190117, '2019-01-17', 2019, 1, 1, 'January', 17, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190118, '2019-01-18', 2019, 1, 1, 'January', 18, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190119, '2019-01-19', 2019, 1, 1, 'January', 19, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190120, '2019-01-20', 2019, 1, 1, 'January', 20, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190121, '2019-01-21', 2019, 1, 1, 'January', 21, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190122, '2019-01-22', 2019, 1, 1, 'January', 22, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190123, '2019-01-23', 2019, 1, 1, 'January', 23, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190124, '2019-01-24', 2019, 1, 1, 'January', 24, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190125, '2019-01-25', 2019, 1, 1, 'January', 25, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190126, '2019-01-26', 2019, 1, 1, 'January', 26, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190127, '2019-01-27', 2019, 1, 1, 'January', 27, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190128, '2019-01-28', 2019, 1, 1, 'January', 28, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190129, '2019-01-29', 2019, 1, 1, 'January', 29, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190130, '2019-01-30', 2019, 1, 1, 'January', 30, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190131, '2019-01-31', 2019, 1, 1, 'January', 31, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190201, '2019-02-01', 2019, 1, 2, 'February', 1, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190202, '2019-02-02', 2019, 1, 2, 'February', 2, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190203, '2019-02-03', 2019, 1, 2, 'February', 3, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190204, '2019-02-04', 2019, 1, 2, 'February', 4, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190205, '2019-02-05', 2019, 1, 2, 'February', 5, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190206, '2019-02-06', 2019, 1, 2, 'February', 6, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190207, '2019-02-07', 2019, 1, 2, 'February', 7, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190208, '2019-02-08', 2019, 1, 2, 'February', 8, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190209, '2019-02-09', 2019, 1, 2, 'February', 9, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190210, '2019-02-10', 2019, 1, 2, 'February', 10, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190211, '2019-02-11', 2019, 1, 2, 'February', 11, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190212, '2019-02-12', 2019, 1, 2, 'February', 12, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190213, '2019-02-13', 2019, 1, 2, 'February', 13, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190214, '2019-02-14', 2019, 1, 2, 'February', 14, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190215, '2019-02-15', 2019, 1, 2, 'February', 15, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190216, '2019-02-16', 2019, 1, 2, 'February', 16, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190217, '2019-02-17', 2019, 1, 2, 'February', 17, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190218, '2019-02-18', 2019, 1, 2, 'February', 18, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190219, '2019-02-19', 2019, 1, 2, 'February', 19, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190220, '2019-02-20', 2019, 1, 2, 'February', 20, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190221, '2019-02-21', 2019, 1, 2, 'February', 21, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190222, '2019-02-22', 2019, 1, 2, 'February', 22, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190223, '2019-02-23', 2019, 1, 2, 'February', 23, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190224, '2019-02-24', 2019, 1, 2, 'February', 24, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190225, '2019-02-25', 2019, 1, 2, 'February', 25, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190226, '2019-02-26', 2019, 1, 2, 'February', 26, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190227, '2019-02-27', 2019, 1, 2, 'February', 27, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190228, '2019-02-28', 2019, 1, 2, 'February', 28, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190301, '2019-03-01', 2019, 1, 3, 'March', 1, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190302, '2019-03-02', 2019, 1, 3, 'March', 2, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190303, '2019-03-03', 2019, 1, 3, 'March', 3, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190304, '2019-03-04', 2019, 1, 3, 'March', 4, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190305, '2019-03-05', 2019, 1, 3, 'March', 5, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190306, '2019-03-06', 2019, 1, 3, 'March', 6, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190307, '2019-03-07', 2019, 1, 3, 'March', 7, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190308, '2019-03-08', 2019, 1, 3, 'March', 8, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190309, '2019-03-09', 2019, 1, 3, 'March', 9, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190310, '2019-03-10', 2019, 1, 3, 'March', 10, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190311, '2019-03-11', 2019, 1, 3, 'March', 11, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190312, '2019-03-12', 2019, 1, 3, 'March', 12, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190313, '2019-03-13', 2019, 1, 3, 'March', 13, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190314, '2019-03-14', 2019, 1, 3, 'March', 14, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190315, '2019-03-15', 2019, 1, 3, 'March', 15, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190316, '2019-03-16', 2019, 1, 3, 'March', 16, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190317, '2019-03-17', 2019, 1, 3, 'March', 17, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190318, '2019-03-18', 2019, 1, 3, 'March', 18, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190319, '2019-03-19', 2019, 1, 3, 'March', 19, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190320, '2019-03-20', 2019, 1, 3, 'March', 20, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190321, '2019-03-21', 2019, 1, 3, 'March', 21, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190322, '2019-03-22', 2019, 1, 3, 'March', 22, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190323, '2019-03-23', 2019, 1, 3, 'March', 23, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190324, '2019-03-24', 2019, 1, 3, 'March', 24, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190325, '2019-03-25', 2019, 1, 3, 'March', 25, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190326, '2019-03-26', 2019, 1, 3, 'March', 26, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190327, '2019-03-27', 2019, 1, 3, 'March', 27, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190328, '2019-03-28', 2019, 1, 3, 'March', 28, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190329, '2019-03-29', 2019, 1, 3, 'March', 29, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190330, '2019-03-30', 2019, 1, 3, 'March', 30, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190331, '2019-03-31', 2019, 1, 3, 'March', 31, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190401, '2019-04-01', 2019, 2, 4, 'April', 1, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190402, '2019-04-02', 2019, 2, 4, 'April', 2, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190403, '2019-04-03', 2019, 2, 4, 'April', 3, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190404, '2019-04-04', 2019, 2, 4, 'April', 4, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190405, '2019-04-05', 2019, 2, 4, 'April', 5, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190406, '2019-04-06', 2019, 2, 4, 'April', 6, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190407, '2019-04-07', 2019, 2, 4, 'April', 7, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190408, '2019-04-08', 2019, 2, 4, 'April', 8, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190409, '2019-04-09', 2019, 2, 4, 'April', 9, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190410, '2019-04-10', 2019, 2, 4, 'April', 10, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190411, '2019-04-11', 2019, 2, 4, 'April', 11, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190412, '2019-04-12', 2019, 2, 4, 'April', 12, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190413, '2019-04-13', 2019, 2, 4, 'April', 13, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190414, '2019-04-14', 2019, 2, 4, 'April', 14, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190415, '2019-04-15', 2019, 2, 4, 'April', 15, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190416, '2019-04-16', 2019, 2, 4, 'April', 16, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190417, '2019-04-17', 2019, 2, 4, 'April', 17, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190418, '2019-04-18', 2019, 2, 4, 'April', 18, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190419, '2019-04-19', 2019, 2, 4, 'April', 19, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190420, '2019-04-20', 2019, 2, 4, 'April', 20, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190421, '2019-04-21', 2019, 2, 4, 'April', 21, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190422, '2019-04-22', 2019, 2, 4, 'April', 22, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190423, '2019-04-23', 2019, 2, 4, 'April', 23, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190424, '2019-04-24', 2019, 2, 4, 'April', 24, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190425, '2019-04-25', 2019, 2, 4, 'April', 25, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190426, '2019-04-26', 2019, 2, 4, 'April', 26, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190427, '2019-04-27', 2019, 2, 4, 'April', 27, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190428, '2019-04-28', 2019, 2, 4, 'April', 28, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190429, '2019-04-29', 2019, 2, 4, 'April', 29, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190430, '2019-04-30', 2019, 2, 4, 'April', 30, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190501, '2019-05-01', 2019, 2, 5, 'May', 1, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190502, '2019-05-02', 2019, 2, 5, 'May', 2, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190503, '2019-05-03', 2019, 2, 5, 'May', 3, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190504, '2019-05-04', 2019, 2, 5, 'May', 4, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190505, '2019-05-05', 2019, 2, 5, 'May', 5, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190506, '2019-05-06', 2019, 2, 5, 'May', 6, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190507, '2019-05-07', 2019, 2, 5, 'May', 7, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190508, '2019-05-08', 2019, 2, 5, 'May', 8, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190509, '2019-05-09', 2019, 2, 5, 'May', 9, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190510, '2019-05-10', 2019, 2, 5, 'May', 10, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190511, '2019-05-11', 2019, 2, 5, 'May', 11, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190512, '2019-05-12', 2019, 2, 5, 'May', 12, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190513, '2019-05-13', 2019, 2, 5, 'May', 13, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190514, '2019-05-14', 2019, 2, 5, 'May', 14, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190515, '2019-05-15', 2019, 2, 5, 'May', 15, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190516, '2019-05-16', 2019, 2, 5, 'May', 16, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190517, '2019-05-17', 2019, 2, 5, 'May', 17, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190518, '2019-05-18', 2019, 2, 5, 'May', 18, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190519, '2019-05-19', 2019, 2, 5, 'May', 19, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190520, '2019-05-20', 2019, 2, 5, 'May', 20, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190521, '2019-05-21', 2019, 2, 5, 'May', 21, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190522, '2019-05-22', 2019, 2, 5, 'May', 22, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190523, '2019-05-23', 2019, 2, 5, 'May', 23, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190524, '2019-05-24', 2019, 2, 5, 'May', 24, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190525, '2019-05-25', 2019, 2, 5, 'May', 25, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190526, '2019-05-26', 2019, 2, 5, 'May', 26, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190527, '2019-05-27', 2019, 2, 5, 'May', 27, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190528, '2019-05-28', 2019, 2, 5, 'May', 28, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190529, '2019-05-29', 2019, 2, 5, 'May', 29, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190530, '2019-05-30', 2019, 2, 5, 'May', 30, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190531, '2019-05-31', 2019, 2, 5, 'May', 31, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190601, '2019-06-01', 2019, 2, 6, 'June', 1, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190602, '2019-06-02', 2019, 2, 6, 'June', 2, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190603, '2019-06-03', 2019, 2, 6, 'June', 3, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190604, '2019-06-04', 2019, 2, 6, 'June', 4, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190605, '2019-06-05', 2019, 2, 6, 'June', 5, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190606, '2019-06-06', 2019, 2, 6, 'June', 6, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190607, '2019-06-07', 2019, 2, 6, 'June', 7, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190608, '2019-06-08', 2019, 2, 6, 'June', 8, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190609, '2019-06-09', 2019, 2, 6, 'June', 9, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190610, '2019-06-10', 2019, 2, 6, 'June', 10, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190611, '2019-06-11', 2019, 2, 6, 'June', 11, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190612, '2019-06-12', 2019, 2, 6, 'June', 12, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190613, '2019-06-13', 2019, 2, 6, 'June', 13, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190614, '2019-06-14', 2019, 2, 6, 'June', 14, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190615, '2019-06-15', 2019, 2, 6, 'June', 15, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190616, '2019-06-16', 2019, 2, 6, 'June', 16, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190617, '2019-06-17', 2019, 2, 6, 'June', 17, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190618, '2019-06-18', 2019, 2, 6, 'June', 18, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190619, '2019-06-19', 2019, 2, 6, 'June', 19, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190620, '2019-06-20', 2019, 2, 6, 'June', 20, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190621, '2019-06-21', 2019, 2, 6, 'June', 21, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190622, '2019-06-22', 2019, 2, 6, 'June', 22, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190623, '2019-06-23', 2019, 2, 6, 'June', 23, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190624, '2019-06-24', 2019, 2, 6, 'June', 24, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190625, '2019-06-25', 2019, 2, 6, 'June', 25, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190626, '2019-06-26', 2019, 2, 6, 'June', 26, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190627, '2019-06-27', 2019, 2, 6, 'June', 27, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190628, '2019-06-28', 2019, 2, 6, 'June', 28, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190629, '2019-06-29', 2019, 2, 6, 'June', 29, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190630, '2019-06-30', 2019, 2, 6, 'June', 30, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190701, '2019-07-01', 2019, 3, 7, 'July', 1, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190702, '2019-07-02', 2019, 3, 7, 'July', 2, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190703, '2019-07-03', 2019, 3, 7, 'July', 3, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190704, '2019-07-04', 2019, 3, 7, 'July', 4, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190705, '2019-07-05', 2019, 3, 7, 'July', 5, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190706, '2019-07-06', 2019, 3, 7, 'July', 6, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190707, '2019-07-07', 2019, 3, 7, 'July', 7, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190708, '2019-07-08', 2019, 3, 7, 'July', 8, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190709, '2019-07-09', 2019, 3, 7, 'July', 9, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190710, '2019-07-10', 2019, 3, 7, 'July', 10, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190711, '2019-07-11', 2019, 3, 7, 'July', 11, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190712, '2019-07-12', 2019, 3, 7, 'July', 12, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190713, '2019-07-13', 2019, 3, 7, 'July', 13, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190714, '2019-07-14', 2019, 3, 7, 'July', 14, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190715, '2019-07-15', 2019, 3, 7, 'July', 15, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190716, '2019-07-16', 2019, 3, 7, 'July', 16, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190717, '2019-07-17', 2019, 3, 7, 'July', 17, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190718, '2019-07-18', 2019, 3, 7, 'July', 18, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190719, '2019-07-19', 2019, 3, 7, 'July', 19, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190720, '2019-07-20', 2019, 3, 7, 'July', 20, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190721, '2019-07-21', 2019, 3, 7, 'July', 21, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190722, '2019-07-22', 2019, 3, 7, 'July', 22, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190723, '2019-07-23', 2019, 3, 7, 'July', 23, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190724, '2019-07-24', 2019, 3, 7, 'July', 24, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190725, '2019-07-25', 2019, 3, 7, 'July', 25, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190726, '2019-07-26', 2019, 3, 7, 'July', 26, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190727, '2019-07-27', 2019, 3, 7, 'July', 27, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190728, '2019-07-28', 2019, 3, 7, 'July', 28, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190729, '2019-07-29', 2019, 3, 7, 'July', 29, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190730, '2019-07-30', 2019, 3, 7, 'July', 30, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190731, '2019-07-31', 2019, 3, 7, 'July', 31, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190801, '2019-08-01', 2019, 3, 8, 'August', 1, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190802, '2019-08-02', 2019, 3, 8, 'August', 2, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190803, '2019-08-03', 2019, 3, 8, 'August', 3, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190804, '2019-08-04', 2019, 3, 8, 'August', 4, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190805, '2019-08-05', 2019, 3, 8, 'August', 5, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190806, '2019-08-06', 2019, 3, 8, 'August', 6, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190807, '2019-08-07', 2019, 3, 8, 'August', 7, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190808, '2019-08-08', 2019, 3, 8, 'August', 8, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190809, '2019-08-09', 2019, 3, 8, 'August', 9, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190810, '2019-08-10', 2019, 3, 8, 'August', 10, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190811, '2019-08-11', 2019, 3, 8, 'August', 11, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190812, '2019-08-12', 2019, 3, 8, 'August', 12, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190813, '2019-08-13', 2019, 3, 8, 'August', 13, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190814, '2019-08-14', 2019, 3, 8, 'August', 14, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190815, '2019-08-15', 2019, 3, 8, 'August', 15, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190816, '2019-08-16', 2019, 3, 8, 'August', 16, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190817, '2019-08-17', 2019, 3, 8, 'August', 17, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190818, '2019-08-18', 2019, 3, 8, 'August', 18, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190819, '2019-08-19', 2019, 3, 8, 'August', 19, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190820, '2019-08-20', 2019, 3, 8, 'August', 20, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190821, '2019-08-21', 2019, 3, 8, 'August', 21, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190822, '2019-08-22', 2019, 3, 8, 'August', 22, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190823, '2019-08-23', 2019, 3, 8, 'August', 23, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190824, '2019-08-24', 2019, 3, 8, 'August', 24, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190825, '2019-08-25', 2019, 3, 8, 'August', 25, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190826, '2019-08-26', 2019, 3, 8, 'August', 26, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190827, '2019-08-27', 2019, 3, 8, 'August', 27, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190828, '2019-08-28', 2019, 3, 8, 'August', 28, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190829, '2019-08-29', 2019, 3, 8, 'August', 29, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190830, '2019-08-30', 2019, 3, 8, 'August', 30, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190831, '2019-08-31', 2019, 3, 8, 'August', 31, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190901, '2019-09-01', 2019, 3, 9, 'September', 1, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190902, '2019-09-02', 2019, 3, 9, 'September', 2, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190903, '2019-09-03', 2019, 3, 9, 'September', 3, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190904, '2019-09-04', 2019, 3, 9, 'September', 4, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190905, '2019-09-05', 2019, 3, 9, 'September', 5, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190906, '2019-09-06', 2019, 3, 9, 'September', 6, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190907, '2019-09-07', 2019, 3, 9, 'September', 7, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190908, '2019-09-08', 2019, 3, 9, 'September', 8, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190909, '2019-09-09', 2019, 3, 9, 'September', 9, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190910, '2019-09-10', 2019, 3, 9, 'September', 10, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190911, '2019-09-11', 2019, 3, 9, 'September', 11, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190912, '2019-09-12', 2019, 3, 9, 'September', 12, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190913, '2019-09-13', 2019, 3, 9, 'September', 13, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190914, '2019-09-14', 2019, 3, 9, 'September', 14, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190915, '2019-09-15', 2019, 3, 9, 'September', 15, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190916, '2019-09-16', 2019, 3, 9, 'September', 16, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190917, '2019-09-17', 2019, 3, 9, 'September', 17, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190918, '2019-09-18', 2019, 3, 9, 'September', 18, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190919, '2019-09-19', 2019, 3, 9, 'September', 19, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190920, '2019-09-20', 2019, 3, 9, 'September', 20, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190921, '2019-09-21', 2019, 3, 9, 'September', 21, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190922, '2019-09-22', 2019, 3, 9, 'September', 22, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190923, '2019-09-23', 2019, 3, 9, 'September', 23, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20190924, '2019-09-24', 2019, 3, 9, 'September', 24, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20190925, '2019-09-25', 2019, 3, 9, 'September', 25, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20190926, '2019-09-26', 2019, 3, 9, 'September', 26, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20190927, '2019-09-27', 2019, 3, 9, 'September', 27, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20190928, '2019-09-28', 2019, 3, 9, 'September', 28, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20190929, '2019-09-29', 2019, 3, 9, 'September', 29, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20190930, '2019-09-30', 2019, 3, 9, 'September', 30, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20191001, '2019-10-01', 2019, 4, 10, 'October', 1, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20191002, '2019-10-02', 2019, 4, 10, 'October', 2, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20191003, '2019-10-03', 2019, 4, 10, 'October', 3, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20191004, '2019-10-04', 2019, 4, 10, 'October', 4, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20191005, '2019-10-05', 2019, 4, 10, 'October', 5, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20191006, '2019-10-06', 2019, 4, 10, 'October', 6, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20191007, '2019-10-07', 2019, 4, 10, 'October', 7, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20191008, '2019-10-08', 2019, 4, 10, 'October', 8, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20191009, '2019-10-09', 2019, 4, 10, 'October', 9, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20191010, '2019-10-10', 2019, 4, 10, 'October', 10, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20191011, '2019-10-11', 2019, 4, 10, 'October', 11, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20191012, '2019-10-12', 2019, 4, 10, 'October', 12, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20191013, '2019-10-13', 2019, 4, 10, 'October', 13, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20191014, '2019-10-14', 2019, 4, 10, 'October', 14, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20191015, '2019-10-15', 2019, 4, 10, 'October', 15, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20191016, '2019-10-16', 2019, 4, 10, 'October', 16, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20191017, '2019-10-17', 2019, 4, 10, 'October', 17, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20191018, '2019-10-18', 2019, 4, 10, 'October', 18, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20191019, '2019-10-19', 2019, 4, 10, 'October', 19, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20191020, '2019-10-20', 2019, 4, 10, 'October', 20, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20191021, '2019-10-21', 2019, 4, 10, 'October', 21, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20191022, '2019-10-22', 2019, 4, 10, 'October', 22, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20191023, '2019-10-23', 2019, 4, 10, 'October', 23, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20191024, '2019-10-24', 2019, 4, 10, 'October', 24, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20191025, '2019-10-25', 2019, 4, 10, 'October', 25, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20191026, '2019-10-26', 2019, 4, 10, 'October', 26, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20191027, '2019-10-27', 2019, 4, 10, 'October', 27, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20191028, '2019-10-28', 2019, 4, 10, 'October', 28, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20191029, '2019-10-29', 2019, 4, 10, 'October', 29, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20191030, '2019-10-30', 2019, 4, 10, 'October', 30, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20191031, '2019-10-31', 2019, 4, 10, 'October', 31, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20191101, '2019-11-01', 2019, 4, 11, 'November', 1, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20191102, '2019-11-02', 2019, 4, 11, 'November', 2, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20191103, '2019-11-03', 2019, 4, 11, 'November', 3, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20191104, '2019-11-04', 2019, 4, 11, 'November', 4, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20191105, '2019-11-05', 2019, 4, 11, 'November', 5, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20191106, '2019-11-06', 2019, 4, 11, 'November', 6, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20191107, '2019-11-07', 2019, 4, 11, 'November', 7, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20191108, '2019-11-08', 2019, 4, 11, 'November', 8, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20191109, '2019-11-09', 2019, 4, 11, 'November', 9, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20191110, '2019-11-10', 2019, 4, 11, 'November', 10, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20191111, '2019-11-11', 2019, 4, 11, 'November', 11, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20191112, '2019-11-12', 2019, 4, 11, 'November', 12, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20191113, '2019-11-13', 2019, 4, 11, 'November', 13, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20191114, '2019-11-14', 2019, 4, 11, 'November', 14, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20191115, '2019-11-15', 2019, 4, 11, 'November', 15, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20191116, '2019-11-16', 2019, 4, 11, 'November', 16, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20191117, '2019-11-17', 2019, 4, 11, 'November', 17, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20191118, '2019-11-18', 2019, 4, 11, 'November', 18, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20191119, '2019-11-19', 2019, 4, 11, 'November', 19, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20191120, '2019-11-20', 2019, 4, 11, 'November', 20, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20191121, '2019-11-21', 2019, 4, 11, 'November', 21, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20191122, '2019-11-22', 2019, 4, 11, 'November', 22, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20191123, '2019-11-23', 2019, 4, 11, 'November', 23, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20191124, '2019-11-24', 2019, 4, 11, 'November', 24, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20191125, '2019-11-25', 2019, 4, 11, 'November', 25, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20191126, '2019-11-26', 2019, 4, 11, 'November', 26, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20191127, '2019-11-27', 2019, 4, 11, 'November', 27, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20191128, '2019-11-28', 2019, 4, 11, 'November', 28, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20191129, '2019-11-29', 2019, 4, 11, 'November', 29, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20191130, '2019-11-30', 2019, 4, 11, 'November', 30, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20191201, '2019-12-01', 2019, 4, 12, 'December', 1, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20191202, '2019-12-02', 2019, 4, 12, 'December', 2, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20191203, '2019-12-03', 2019, 4, 12, 'December', 3, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20191204, '2019-12-04', 2019, 4, 12, 'December', 4, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20191205, '2019-12-05', 2019, 4, 12, 'December', 5, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20191206, '2019-12-06', 2019, 4, 12, 'December', 6, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20191207, '2019-12-07', 2019, 4, 12, 'December', 7, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20191208, '2019-12-08', 2019, 4, 12, 'December', 8, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20191209, '2019-12-09', 2019, 4, 12, 'December', 9, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20191210, '2019-12-10', 2019, 4, 12, 'December', 10, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20191211, '2019-12-11', 2019, 4, 12, 'December', 11, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20191212, '2019-12-12', 2019, 4, 12, 'December', 12, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20191213, '2019-12-13', 2019, 4, 12, 'December', 13, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20191214, '2019-12-14', 2019, 4, 12, 'December', 14, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20191215, '2019-12-15', 2019, 4, 12, 'December', 15, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20191216, '2019-12-16', 2019, 4, 12, 'December', 16, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20191217, '2019-12-17', 2019, 4, 12, 'December', 17, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20191218, '2019-12-18', 2019, 4, 12, 'December', 18, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20191219, '2019-12-19', 2019, 4, 12, 'December', 19, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20191220, '2019-12-20', 2019, 4, 12, 'December', 20, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20191221, '2019-12-21', 2019, 4, 12, 'December', 21, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20191222, '2019-12-22', 2019, 4, 12, 'December', 22, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20191223, '2019-12-23', 2019, 4, 12, 'December', 23, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20191224, '2019-12-24', 2019, 4, 12, 'December', 24, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20191225, '2019-12-25', 2019, 4, 12, 'December', 25, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20191226, '2019-12-26', 2019, 4, 12, 'December', 26, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20191227, '2019-12-27', 2019, 4, 12, 'December', 27, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20191228, '2019-12-28', 2019, 4, 12, 'December', 28, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20191229, '2019-12-29', 2019, 4, 12, 'December', 29, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20191230, '2019-12-30', 2019, 4, 12, 'December', 30, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20191231, '2019-12-31', 2019, 4, 12, 'December', 31, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200101, '2020-01-01', 2020, 1, 1, 'January', 1, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200102, '2020-01-02', 2020, 1, 1, 'January', 2, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200103, '2020-01-03', 2020, 1, 1, 'January', 3, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200104, '2020-01-04', 2020, 1, 1, 'January', 4, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200105, '2020-01-05', 2020, 1, 1, 'January', 5, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200106, '2020-01-06', 2020, 1, 1, 'January', 6, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200107, '2020-01-07', 2020, 1, 1, 'January', 7, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200108, '2020-01-08', 2020, 1, 1, 'January', 8, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200109, '2020-01-09', 2020, 1, 1, 'January', 9, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200110, '2020-01-10', 2020, 1, 1, 'January', 10, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200111, '2020-01-11', 2020, 1, 1, 'January', 11, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200112, '2020-01-12', 2020, 1, 1, 'January', 12, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200113, '2020-01-13', 2020, 1, 1, 'January', 13, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200114, '2020-01-14', 2020, 1, 1, 'January', 14, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200115, '2020-01-15', 2020, 1, 1, 'January', 15, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200116, '2020-01-16', 2020, 1, 1, 'January', 16, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200117, '2020-01-17', 2020, 1, 1, 'January', 17, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200118, '2020-01-18', 2020, 1, 1, 'January', 18, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200119, '2020-01-19', 2020, 1, 1, 'January', 19, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200120, '2020-01-20', 2020, 1, 1, 'January', 20, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200121, '2020-01-21', 2020, 1, 1, 'January', 21, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200122, '2020-01-22', 2020, 1, 1, 'January', 22, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200123, '2020-01-23', 2020, 1, 1, 'January', 23, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200124, '2020-01-24', 2020, 1, 1, 'January', 24, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200125, '2020-01-25', 2020, 1, 1, 'January', 25, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200126, '2020-01-26', 2020, 1, 1, 'January', 26, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200127, '2020-01-27', 2020, 1, 1, 'January', 27, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200128, '2020-01-28', 2020, 1, 1, 'January', 28, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200129, '2020-01-29', 2020, 1, 1, 'January', 29, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200130, '2020-01-30', 2020, 1, 1, 'January', 30, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200131, '2020-01-31', 2020, 1, 1, 'January', 31, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200201, '2020-02-01', 2020, 1, 2, 'February', 1, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200202, '2020-02-02', 2020, 1, 2, 'February', 2, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200203, '2020-02-03', 2020, 1, 2, 'February', 3, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200204, '2020-02-04', 2020, 1, 2, 'February', 4, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200205, '2020-02-05', 2020, 1, 2, 'February', 5, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200206, '2020-02-06', 2020, 1, 2, 'February', 6, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200207, '2020-02-07', 2020, 1, 2, 'February', 7, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200208, '2020-02-08', 2020, 1, 2, 'February', 8, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200209, '2020-02-09', 2020, 1, 2, 'February', 9, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200210, '2020-02-10', 2020, 1, 2, 'February', 10, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200211, '2020-02-11', 2020, 1, 2, 'February', 11, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200212, '2020-02-12', 2020, 1, 2, 'February', 12, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200213, '2020-02-13', 2020, 1, 2, 'February', 13, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200214, '2020-02-14', 2020, 1, 2, 'February', 14, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200215, '2020-02-15', 2020, 1, 2, 'February', 15, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200216, '2020-02-16', 2020, 1, 2, 'February', 16, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200217, '2020-02-17', 2020, 1, 2, 'February', 17, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200218, '2020-02-18', 2020, 1, 2, 'February', 18, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200219, '2020-02-19', 2020, 1, 2, 'February', 19, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200220, '2020-02-20', 2020, 1, 2, 'February', 20, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200221, '2020-02-21', 2020, 1, 2, 'February', 21, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200222, '2020-02-22', 2020, 1, 2, 'February', 22, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200223, '2020-02-23', 2020, 1, 2, 'February', 23, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200224, '2020-02-24', 2020, 1, 2, 'February', 24, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200225, '2020-02-25', 2020, 1, 2, 'February', 25, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200226, '2020-02-26', 2020, 1, 2, 'February', 26, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200227, '2020-02-27', 2020, 1, 2, 'February', 27, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200228, '2020-02-28', 2020, 1, 2, 'February', 28, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200229, '2020-02-29', 2020, 1, 2, 'February', 29, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200301, '2020-03-01', 2020, 1, 3, 'March', 1, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200302, '2020-03-02', 2020, 1, 3, 'March', 2, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200303, '2020-03-03', 2020, 1, 3, 'March', 3, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200304, '2020-03-04', 2020, 1, 3, 'March', 4, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200305, '2020-03-05', 2020, 1, 3, 'March', 5, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200306, '2020-03-06', 2020, 1, 3, 'March', 6, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200307, '2020-03-07', 2020, 1, 3, 'March', 7, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200308, '2020-03-08', 2020, 1, 3, 'March', 8, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200309, '2020-03-09', 2020, 1, 3, 'March', 9, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200310, '2020-03-10', 2020, 1, 3, 'March', 10, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200311, '2020-03-11', 2020, 1, 3, 'March', 11, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200312, '2020-03-12', 2020, 1, 3, 'March', 12, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200313, '2020-03-13', 2020, 1, 3, 'March', 13, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200314, '2020-03-14', 2020, 1, 3, 'March', 14, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200315, '2020-03-15', 2020, 1, 3, 'March', 15, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200316, '2020-03-16', 2020, 1, 3, 'March', 16, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200317, '2020-03-17', 2020, 1, 3, 'March', 17, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200318, '2020-03-18', 2020, 1, 3, 'March', 18, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200319, '2020-03-19', 2020, 1, 3, 'March', 19, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200320, '2020-03-20', 2020, 1, 3, 'March', 20, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200321, '2020-03-21', 2020, 1, 3, 'March', 21, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200322, '2020-03-22', 2020, 1, 3, 'March', 22, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200323, '2020-03-23', 2020, 1, 3, 'March', 23, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200324, '2020-03-24', 2020, 1, 3, 'March', 24, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200325, '2020-03-25', 2020, 1, 3, 'March', 25, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200326, '2020-03-26', 2020, 1, 3, 'March', 26, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200327, '2020-03-27', 2020, 1, 3, 'March', 27, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200328, '2020-03-28', 2020, 1, 3, 'March', 28, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200329, '2020-03-29', 2020, 1, 3, 'March', 29, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200330, '2020-03-30', 2020, 1, 3, 'March', 30, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200331, '2020-03-31', 2020, 1, 3, 'March', 31, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200401, '2020-04-01', 2020, 2, 4, 'April', 1, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200402, '2020-04-02', 2020, 2, 4, 'April', 2, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200403, '2020-04-03', 2020, 2, 4, 'April', 3, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200404, '2020-04-04', 2020, 2, 4, 'April', 4, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200405, '2020-04-05', 2020, 2, 4, 'April', 5, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200406, '2020-04-06', 2020, 2, 4, 'April', 6, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200407, '2020-04-07', 2020, 2, 4, 'April', 7, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200408, '2020-04-08', 2020, 2, 4, 'April', 8, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200409, '2020-04-09', 2020, 2, 4, 'April', 9, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200410, '2020-04-10', 2020, 2, 4, 'April', 10, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200411, '2020-04-11', 2020, 2, 4, 'April', 11, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200412, '2020-04-12', 2020, 2, 4, 'April', 12, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200413, '2020-04-13', 2020, 2, 4, 'April', 13, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200414, '2020-04-14', 2020, 2, 4, 'April', 14, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200415, '2020-04-15', 2020, 2, 4, 'April', 15, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200416, '2020-04-16', 2020, 2, 4, 'April', 16, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200417, '2020-04-17', 2020, 2, 4, 'April', 17, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200418, '2020-04-18', 2020, 2, 4, 'April', 18, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200419, '2020-04-19', 2020, 2, 4, 'April', 19, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200420, '2020-04-20', 2020, 2, 4, 'April', 20, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200421, '2020-04-21', 2020, 2, 4, 'April', 21, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200422, '2020-04-22', 2020, 2, 4, 'April', 22, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200423, '2020-04-23', 2020, 2, 4, 'April', 23, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200424, '2020-04-24', 2020, 2, 4, 'April', 24, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200425, '2020-04-25', 2020, 2, 4, 'April', 25, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200426, '2020-04-26', 2020, 2, 4, 'April', 26, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200427, '2020-04-27', 2020, 2, 4, 'April', 27, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200428, '2020-04-28', 2020, 2, 4, 'April', 28, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200429, '2020-04-29', 2020, 2, 4, 'April', 29, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200430, '2020-04-30', 2020, 2, 4, 'April', 30, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200501, '2020-05-01', 2020, 2, 5, 'May', 1, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200502, '2020-05-02', 2020, 2, 5, 'May', 2, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200503, '2020-05-03', 2020, 2, 5, 'May', 3, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200504, '2020-05-04', 2020, 2, 5, 'May', 4, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200505, '2020-05-05', 2020, 2, 5, 'May', 5, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200506, '2020-05-06', 2020, 2, 5, 'May', 6, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200507, '2020-05-07', 2020, 2, 5, 'May', 7, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200508, '2020-05-08', 2020, 2, 5, 'May', 8, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200509, '2020-05-09', 2020, 2, 5, 'May', 9, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200510, '2020-05-10', 2020, 2, 5, 'May', 10, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200511, '2020-05-11', 2020, 2, 5, 'May', 11, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200512, '2020-05-12', 2020, 2, 5, 'May', 12, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200513, '2020-05-13', 2020, 2, 5, 'May', 13, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200514, '2020-05-14', 2020, 2, 5, 'May', 14, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200515, '2020-05-15', 2020, 2, 5, 'May', 15, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200516, '2020-05-16', 2020, 2, 5, 'May', 16, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200517, '2020-05-17', 2020, 2, 5, 'May', 17, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200518, '2020-05-18', 2020, 2, 5, 'May', 18, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200519, '2020-05-19', 2020, 2, 5, 'May', 19, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200520, '2020-05-20', 2020, 2, 5, 'May', 20, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200521, '2020-05-21', 2020, 2, 5, 'May', 21, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200522, '2020-05-22', 2020, 2, 5, 'May', 22, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200523, '2020-05-23', 2020, 2, 5, 'May', 23, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200524, '2020-05-24', 2020, 2, 5, 'May', 24, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200525, '2020-05-25', 2020, 2, 5, 'May', 25, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200526, '2020-05-26', 2020, 2, 5, 'May', 26, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200527, '2020-05-27', 2020, 2, 5, 'May', 27, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200528, '2020-05-28', 2020, 2, 5, 'May', 28, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200529, '2020-05-29', 2020, 2, 5, 'May', 29, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200530, '2020-05-30', 2020, 2, 5, 'May', 30, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200531, '2020-05-31', 2020, 2, 5, 'May', 31, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200601, '2020-06-01', 2020, 2, 6, 'June', 1, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200602, '2020-06-02', 2020, 2, 6, 'June', 2, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200603, '2020-06-03', 2020, 2, 6, 'June', 3, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200604, '2020-06-04', 2020, 2, 6, 'June', 4, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200605, '2020-06-05', 2020, 2, 6, 'June', 5, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200606, '2020-06-06', 2020, 2, 6, 'June', 6, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200607, '2020-06-07', 2020, 2, 6, 'June', 7, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200608, '2020-06-08', 2020, 2, 6, 'June', 8, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200609, '2020-06-09', 2020, 2, 6, 'June', 9, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200610, '2020-06-10', 2020, 2, 6, 'June', 10, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200611, '2020-06-11', 2020, 2, 6, 'June', 11, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200612, '2020-06-12', 2020, 2, 6, 'June', 12, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200613, '2020-06-13', 2020, 2, 6, 'June', 13, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200614, '2020-06-14', 2020, 2, 6, 'June', 14, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200615, '2020-06-15', 2020, 2, 6, 'June', 15, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200616, '2020-06-16', 2020, 2, 6, 'June', 16, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200617, '2020-06-17', 2020, 2, 6, 'June', 17, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200618, '2020-06-18', 2020, 2, 6, 'June', 18, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200619, '2020-06-19', 2020, 2, 6, 'June', 19, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200620, '2020-06-20', 2020, 2, 6, 'June', 20, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200621, '2020-06-21', 2020, 2, 6, 'June', 21, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200622, '2020-06-22', 2020, 2, 6, 'June', 22, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200623, '2020-06-23', 2020, 2, 6, 'June', 23, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200624, '2020-06-24', 2020, 2, 6, 'June', 24, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200625, '2020-06-25', 2020, 2, 6, 'June', 25, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200626, '2020-06-26', 2020, 2, 6, 'June', 26, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200627, '2020-06-27', 2020, 2, 6, 'June', 27, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200628, '2020-06-28', 2020, 2, 6, 'June', 28, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200629, '2020-06-29', 2020, 2, 6, 'June', 29, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200630, '2020-06-30', 2020, 2, 6, 'June', 30, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200701, '2020-07-01', 2020, 3, 7, 'July', 1, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200702, '2020-07-02', 2020, 3, 7, 'July', 2, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200703, '2020-07-03', 2020, 3, 7, 'July', 3, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200704, '2020-07-04', 2020, 3, 7, 'July', 4, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200705, '2020-07-05', 2020, 3, 7, 'July', 5, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200706, '2020-07-06', 2020, 3, 7, 'July', 6, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200707, '2020-07-07', 2020, 3, 7, 'July', 7, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200708, '2020-07-08', 2020, 3, 7, 'July', 8, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200709, '2020-07-09', 2020, 3, 7, 'July', 9, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200710, '2020-07-10', 2020, 3, 7, 'July', 10, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200711, '2020-07-11', 2020, 3, 7, 'July', 11, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200712, '2020-07-12', 2020, 3, 7, 'July', 12, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200713, '2020-07-13', 2020, 3, 7, 'July', 13, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200714, '2020-07-14', 2020, 3, 7, 'July', 14, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200715, '2020-07-15', 2020, 3, 7, 'July', 15, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200716, '2020-07-16', 2020, 3, 7, 'July', 16, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200717, '2020-07-17', 2020, 3, 7, 'July', 17, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200718, '2020-07-18', 2020, 3, 7, 'July', 18, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200719, '2020-07-19', 2020, 3, 7, 'July', 19, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200720, '2020-07-20', 2020, 3, 7, 'July', 20, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200721, '2020-07-21', 2020, 3, 7, 'July', 21, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200722, '2020-07-22', 2020, 3, 7, 'July', 22, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200723, '2020-07-23', 2020, 3, 7, 'July', 23, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200724, '2020-07-24', 2020, 3, 7, 'July', 24, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200725, '2020-07-25', 2020, 3, 7, 'July', 25, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200726, '2020-07-26', 2020, 3, 7, 'July', 26, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200727, '2020-07-27', 2020, 3, 7, 'July', 27, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200728, '2020-07-28', 2020, 3, 7, 'July', 28, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200729, '2020-07-29', 2020, 3, 7, 'July', 29, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200730, '2020-07-30', 2020, 3, 7, 'July', 30, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200731, '2020-07-31', 2020, 3, 7, 'July', 31, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200801, '2020-08-01', 2020, 3, 8, 'August', 1, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200802, '2020-08-02', 2020, 3, 8, 'August', 2, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200803, '2020-08-03', 2020, 3, 8, 'August', 3, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200804, '2020-08-04', 2020, 3, 8, 'August', 4, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200805, '2020-08-05', 2020, 3, 8, 'August', 5, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200806, '2020-08-06', 2020, 3, 8, 'August', 6, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200807, '2020-08-07', 2020, 3, 8, 'August', 7, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200808, '2020-08-08', 2020, 3, 8, 'August', 8, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200809, '2020-08-09', 2020, 3, 8, 'August', 9, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200810, '2020-08-10', 2020, 3, 8, 'August', 10, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200811, '2020-08-11', 2020, 3, 8, 'August', 11, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200812, '2020-08-12', 2020, 3, 8, 'August', 12, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200813, '2020-08-13', 2020, 3, 8, 'August', 13, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200814, '2020-08-14', 2020, 3, 8, 'August', 14, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200815, '2020-08-15', 2020, 3, 8, 'August', 15, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200816, '2020-08-16', 2020, 3, 8, 'August', 16, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200817, '2020-08-17', 2020, 3, 8, 'August', 17, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200818, '2020-08-18', 2020, 3, 8, 'August', 18, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200819, '2020-08-19', 2020, 3, 8, 'August', 19, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200820, '2020-08-20', 2020, 3, 8, 'August', 20, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200821, '2020-08-21', 2020, 3, 8, 'August', 21, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200822, '2020-08-22', 2020, 3, 8, 'August', 22, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200823, '2020-08-23', 2020, 3, 8, 'August', 23, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200824, '2020-08-24', 2020, 3, 8, 'August', 24, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200825, '2020-08-25', 2020, 3, 8, 'August', 25, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200826, '2020-08-26', 2020, 3, 8, 'August', 26, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200827, '2020-08-27', 2020, 3, 8, 'August', 27, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200828, '2020-08-28', 2020, 3, 8, 'August', 28, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200829, '2020-08-29', 2020, 3, 8, 'August', 29, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200830, '2020-08-30', 2020, 3, 8, 'August', 30, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200831, '2020-08-31', 2020, 3, 8, 'August', 31, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200901, '2020-09-01', 2020, 3, 9, 'September', 1, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200902, '2020-09-02', 2020, 3, 9, 'September', 2, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200903, '2020-09-03', 2020, 3, 9, 'September', 3, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200904, '2020-09-04', 2020, 3, 9, 'September', 4, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200905, '2020-09-05', 2020, 3, 9, 'September', 5, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200906, '2020-09-06', 2020, 3, 9, 'September', 6, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200907, '2020-09-07', 2020, 3, 9, 'September', 7, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200908, '2020-09-08', 2020, 3, 9, 'September', 8, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200909, '2020-09-09', 2020, 3, 9, 'September', 9, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200910, '2020-09-10', 2020, 3, 9, 'September', 10, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200911, '2020-09-11', 2020, 3, 9, 'September', 11, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200912, '2020-09-12', 2020, 3, 9, 'September', 12, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200913, '2020-09-13', 2020, 3, 9, 'September', 13, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200914, '2020-09-14', 2020, 3, 9, 'September', 14, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200915, '2020-09-15', 2020, 3, 9, 'September', 15, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200916, '2020-09-16', 2020, 3, 9, 'September', 16, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200917, '2020-09-17', 2020, 3, 9, 'September', 17, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200918, '2020-09-18', 2020, 3, 9, 'September', 18, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200919, '2020-09-19', 2020, 3, 9, 'September', 19, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200920, '2020-09-20', 2020, 3, 9, 'September', 20, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200921, '2020-09-21', 2020, 3, 9, 'September', 21, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200922, '2020-09-22', 2020, 3, 9, 'September', 22, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200923, '2020-09-23', 2020, 3, 9, 'September', 23, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20200924, '2020-09-24', 2020, 3, 9, 'September', 24, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20200925, '2020-09-25', 2020, 3, 9, 'September', 25, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20200926, '2020-09-26', 2020, 3, 9, 'September', 26, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20200927, '2020-09-27', 2020, 3, 9, 'September', 27, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20200928, '2020-09-28', 2020, 3, 9, 'September', 28, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20200929, '2020-09-29', 2020, 3, 9, 'September', 29, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20200930, '2020-09-30', 2020, 3, 9, 'September', 30, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20201001, '2020-10-01', 2020, 4, 10, 'October', 1, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20201002, '2020-10-02', 2020, 4, 10, 'October', 2, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20201003, '2020-10-03', 2020, 4, 10, 'October', 3, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20201004, '2020-10-04', 2020, 4, 10, 'October', 4, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20201005, '2020-10-05', 2020, 4, 10, 'October', 5, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20201006, '2020-10-06', 2020, 4, 10, 'October', 6, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20201007, '2020-10-07', 2020, 4, 10, 'October', 7, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20201008, '2020-10-08', 2020, 4, 10, 'October', 8, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20201009, '2020-10-09', 2020, 4, 10, 'October', 9, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20201010, '2020-10-10', 2020, 4, 10, 'October', 10, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20201011, '2020-10-11', 2020, 4, 10, 'October', 11, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20201012, '2020-10-12', 2020, 4, 10, 'October', 12, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20201013, '2020-10-13', 2020, 4, 10, 'October', 13, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20201014, '2020-10-14', 2020, 4, 10, 'October', 14, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20201015, '2020-10-15', 2020, 4, 10, 'October', 15, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20201016, '2020-10-16', 2020, 4, 10, 'October', 16, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20201017, '2020-10-17', 2020, 4, 10, 'October', 17, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20201018, '2020-10-18', 2020, 4, 10, 'October', 18, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20201019, '2020-10-19', 2020, 4, 10, 'October', 19, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20201020, '2020-10-20', 2020, 4, 10, 'October', 20, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20201021, '2020-10-21', 2020, 4, 10, 'October', 21, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20201022, '2020-10-22', 2020, 4, 10, 'October', 22, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20201023, '2020-10-23', 2020, 4, 10, 'October', 23, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20201024, '2020-10-24', 2020, 4, 10, 'October', 24, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20201025, '2020-10-25', 2020, 4, 10, 'October', 25, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20201026, '2020-10-26', 2020, 4, 10, 'October', 26, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20201027, '2020-10-27', 2020, 4, 10, 'October', 27, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20201028, '2020-10-28', 2020, 4, 10, 'October', 28, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20201029, '2020-10-29', 2020, 4, 10, 'October', 29, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20201030, '2020-10-30', 2020, 4, 10, 'October', 30, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20201031, '2020-10-31', 2020, 4, 10, 'October', 31, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20201101, '2020-11-01', 2020, 4, 11, 'November', 1, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20201102, '2020-11-02', 2020, 4, 11, 'November', 2, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20201103, '2020-11-03', 2020, 4, 11, 'November', 3, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20201104, '2020-11-04', 2020, 4, 11, 'November', 4, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20201105, '2020-11-05', 2020, 4, 11, 'November', 5, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20201106, '2020-11-06', 2020, 4, 11, 'November', 6, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20201107, '2020-11-07', 2020, 4, 11, 'November', 7, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20201108, '2020-11-08', 2020, 4, 11, 'November', 8, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20201109, '2020-11-09', 2020, 4, 11, 'November', 9, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20201110, '2020-11-10', 2020, 4, 11, 'November', 10, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20201111, '2020-11-11', 2020, 4, 11, 'November', 11, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20201112, '2020-11-12', 2020, 4, 11, 'November', 12, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20201113, '2020-11-13', 2020, 4, 11, 'November', 13, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20201114, '2020-11-14', 2020, 4, 11, 'November', 14, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20201115, '2020-11-15', 2020, 4, 11, 'November', 15, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20201116, '2020-11-16', 2020, 4, 11, 'November', 16, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20201117, '2020-11-17', 2020, 4, 11, 'November', 17, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20201118, '2020-11-18', 2020, 4, 11, 'November', 18, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20201119, '2020-11-19', 2020, 4, 11, 'November', 19, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20201120, '2020-11-20', 2020, 4, 11, 'November', 20, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20201121, '2020-11-21', 2020, 4, 11, 'November', 21, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20201122, '2020-11-22', 2020, 4, 11, 'November', 22, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20201123, '2020-11-23', 2020, 4, 11, 'November', 23, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20201124, '2020-11-24', 2020, 4, 11, 'November', 24, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20201125, '2020-11-25', 2020, 4, 11, 'November', 25, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20201126, '2020-11-26', 2020, 4, 11, 'November', 26, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20201127, '2020-11-27', 2020, 4, 11, 'November', 27, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20201128, '2020-11-28', 2020, 4, 11, 'November', 28, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20201129, '2020-11-29', 2020, 4, 11, 'November', 29, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20201130, '2020-11-30', 2020, 4, 11, 'November', 30, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20201201, '2020-12-01', 2020, 4, 12, 'December', 1, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20201202, '2020-12-02', 2020, 4, 12, 'December', 2, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20201203, '2020-12-03', 2020, 4, 12, 'December', 3, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20201204, '2020-12-04', 2020, 4, 12, 'December', 4, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20201205, '2020-12-05', 2020, 4, 12, 'December', 5, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20201206, '2020-12-06', 2020, 4, 12, 'December', 6, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20201207, '2020-12-07', 2020, 4, 12, 'December', 7, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20201208, '2020-12-08', 2020, 4, 12, 'December', 8, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20201209, '2020-12-09', 2020, 4, 12, 'December', 9, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20201210, '2020-12-10', 2020, 4, 12, 'December', 10, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20201211, '2020-12-11', 2020, 4, 12, 'December', 11, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20201212, '2020-12-12', 2020, 4, 12, 'December', 12, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20201213, '2020-12-13', 2020, 4, 12, 'December', 13, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20201214, '2020-12-14', 2020, 4, 12, 'December', 14, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20201215, '2020-12-15', 2020, 4, 12, 'December', 15, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20201216, '2020-12-16', 2020, 4, 12, 'December', 16, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20201217, '2020-12-17', 2020, 4, 12, 'December', 17, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20201218, '2020-12-18', 2020, 4, 12, 'December', 18, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20201219, '2020-12-19', 2020, 4, 12, 'December', 19, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20201220, '2020-12-20', 2020, 4, 12, 'December', 20, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20201221, '2020-12-21', 2020, 4, 12, 'December', 21, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20201222, '2020-12-22', 2020, 4, 12, 'December', 22, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20201223, '2020-12-23', 2020, 4, 12, 'December', 23, 3, 'Wednesday', false);
INSERT INTO public.dim_date VALUES (20201224, '2020-12-24', 2020, 4, 12, 'December', 24, 4, 'Thursday', false);
INSERT INTO public.dim_date VALUES (20201225, '2020-12-25', 2020, 4, 12, 'December', 25, 5, 'Friday', false);
INSERT INTO public.dim_date VALUES (20201226, '2020-12-26', 2020, 4, 12, 'December', 26, 6, 'Saturday', true);
INSERT INTO public.dim_date VALUES (20201227, '2020-12-27', 2020, 4, 12, 'December', 27, 0, 'Sunday', true);
INSERT INTO public.dim_date VALUES (20201228, '2020-12-28', 2020, 4, 12, 'December', 28, 1, 'Monday', false);
INSERT INTO public.dim_date VALUES (20201229, '2020-12-29', 2020, 4, 12, 'December', 29, 2, 'Tuesday', false);
INSERT INTO public.dim_date VALUES (20201230, '2020-12-30', 2020, 4, 12, 'December', 30, 3, 'Wednesday', false);


--
-- Data for Name: dim_location; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (1, 'Akron', 'Ohio', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (2, 'Amarillo', 'Texas', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (3, 'Anaheim', 'California', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (4, 'Arlington', 'Virginia', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (5, 'Arvada', 'Colorado', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (6, 'Asheville', 'North Carolina', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (7, 'Atlanta', 'Georgia', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (8, 'Auburn', 'New York', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (9, 'Aurora', 'Colorado', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (10, 'Aurora', 'Illinois', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (11, 'Austin', 'Texas', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (12, 'Belleville', 'New Jersey', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (13, 'Burlington', 'North Carolina', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (14, 'Canton', 'Michigan', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (15, 'Carlsbad', 'New Mexico', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (16, 'Chapel Hill', 'North Carolina', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (17, 'Charlotte', 'North Carolina', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (18, 'Chicago', 'Illinois', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (19, 'Cincinnati', 'Ohio', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (20, 'Cleveland', 'Ohio', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (21, 'Columbia', 'South Carolina', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (22, 'Columbia', 'Tennessee', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (23, 'Columbus', 'Georgia', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (24, 'Columbus', 'Indiana', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (25, 'Columbus', 'Ohio', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (26, 'Concord', 'New Hampshire', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (27, 'Concord', 'North Carolina', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (28, 'Costa Mesa', 'California', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (29, 'Dallas', 'Texas', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (30, 'Decatur', 'Alabama', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (31, 'Decatur', 'Illinois', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (32, 'Denver', 'Colorado', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (33, 'Des Moines', 'Iowa', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (34, 'Detroit', 'Michigan', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (35, 'Dover', 'Delaware', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (36, 'Eagan', 'Minnesota', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (37, 'Edmond', 'Oklahoma', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (38, 'Evanston', 'Illinois', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (39, 'Fairfield', 'Connecticut', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (40, 'Florence', 'Kentucky', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (41, 'Fort Worth', 'Texas', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (42, 'Franklin', 'Massachusetts', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (43, 'Franklin', 'Tennessee', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (44, 'Franklin', 'Wisconsin', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (45, 'Fremont', 'Nebraska', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (46, 'Gastonia', 'North Carolina', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (47, 'Gladstone', 'Missouri', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (48, 'Grand Prairie', 'Texas', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (49, 'Great Falls', 'Montana', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (50, 'Green Bay', 'Wisconsin', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (51, 'Grove City', 'Ohio', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (52, 'Harlingen', 'Texas', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (53, 'Henderson', 'Kentucky', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (54, 'Hesperia', 'California', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (55, 'Hialeah', 'Florida', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (56, 'Houston', 'Texas', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (57, 'Huntington Beach', 'California', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (58, 'Independence', 'Missouri', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (59, 'Inglewood', 'California', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (60, 'Jackson', 'Michigan', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (61, 'Jackson', 'Mississippi', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (62, 'Jacksonville', 'Florida', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (63, 'Lakeland', 'Florida', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (64, 'Lakeville', 'Minnesota', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (65, 'Lancaster', 'California', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (66, 'Las Vegas', 'Nevada', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (67, 'Lawrence', 'Massachusetts', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (68, 'Lorain', 'Ohio', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (69, 'Los Angeles', 'California', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (70, 'Louisville', 'Kentucky', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (71, 'Lowell', 'Massachusetts', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (72, 'Manchester', 'Connecticut', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (73, 'Marysville', 'Washington', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (74, 'Melbourne', 'Florida', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (75, 'Memphis', 'Tennessee', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (76, 'Mesa', 'Arizona', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (77, 'Miami', 'Florida', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (78, 'Minneapolis', 'Minnesota', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (79, 'Mission Viejo', 'California', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (80, 'Monroe', 'Louisiana', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (81, 'Montgomery', 'Alabama', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (82, 'Morristown', 'New Jersey', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (83, 'Mount Vernon', 'New York', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (84, 'Murfreesboro', 'Tennessee', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (85, 'Naperville', 'Illinois', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (86, 'New Brunswick', 'New Jersey', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (87, 'New York City', 'New York', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (88, 'Newark', 'Ohio', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (89, 'Norman', 'Oklahoma', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (90, 'Oceanside', 'New York', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (91, 'Palm Coast', 'Florida', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (92, 'Parker', 'Colorado', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (93, 'Pasadena', 'Texas', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (94, 'Philadelphia', 'Pennsylvania', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (95, 'Phoenix', 'Arizona', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (96, 'Plainfield', 'New Jersey', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (97, 'Portland', 'Oregon', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (98, 'Quincy', 'Illinois', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (99, 'Richardson', 'Texas', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (100, 'Richmond', 'Kentucky', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (101, 'Rochester', 'Minnesota', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (102, 'Rochester Hills', 'Michigan', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (103, 'Roseville', 'California', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (104, 'Saginaw', 'Michigan', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (105, 'Saint Paul', 'Minnesota', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (106, 'Salem', 'Oregon', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (107, 'Salinas', 'California', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (108, 'San Antonio', 'Texas', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (109, 'San Diego', 'California', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (110, 'San Francisco', 'California', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (111, 'Santa Ana', 'California', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (112, 'Santa Clara', 'California', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (113, 'Scottsdale', 'Arizona', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (114, 'Seattle', 'Washington', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (115, 'Sierra Vista', 'Arizona', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (116, 'Springfield', 'Virginia', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (117, 'Tamarac', 'Florida', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (118, 'Tampa', 'Florida', 'South', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (119, 'Trenton', 'Michigan', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (120, 'Troy', 'New York', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (121, 'Tucson', 'Arizona', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (122, 'Tyler', 'Texas', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (123, 'Urbandale', 'Iowa', 'Central', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (124, 'Vallejo', 'California', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (125, 'Vancouver', 'Washington', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (126, 'Warwick', 'Rhode Island', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (127, 'Westfield', 'New Jersey', 'East', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (128, 'Whittier', 'California', 'West', 'United States');
INSERT INTO public.dim_location OVERRIDING SYSTEM VALUE VALUES (129, 'Wilmington', 'Delaware', 'East', 'United States');


--
-- Data for Name: dim_product; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (1, 'FUR-BO-10001337', 'O''Sullivan Living Dimensions 2-Shelf Bookcases', 'Bookcases', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (2, 'FUR-BO-10001619', 'O''Sullivan Cherrywood Estates Traditional Bookcase', 'Bookcases', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (3, 'FUR-BO-10001798', 'Bush Somerset Collection Bookcase', 'Bookcases', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (4, 'FUR-BO-10001972', 'O''Sullivan 4-Shelf Bookcase in Odessa Pine', 'Bookcases', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (5, 'FUR-BO-10002268', 'Sauder Barrister Bookcases', 'Bookcases', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (6, 'FUR-BO-10002545', 'Atlantic Metals Mobile 3-Shelf Bookcases, Custom Colors', 'Bookcases', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (7, 'FUR-BO-10002824', 'Bush Mission Pointe Library', 'Bookcases', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (8, 'FUR-BO-10004015', 'Bush Andora Bookcase, Maple/Graphite Gray Finish', 'Bookcases', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (9, 'FUR-BO-10004709', 'Bush Westfield Collection Bookcases, Medium Cherry Finish', 'Bookcases', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (10, 'FUR-BO-10004834', 'Riverside Palais Royal Lawyers Bookcase, Royale Cherry Finish', 'Bookcases', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (11, 'FUR-CH-10000015', 'Hon Multipurpose Stacking Arm Chairs', 'Chairs', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (12, 'FUR-CH-10000454', 'Hon Deluxe Fabric Upholstered Stacking Chairs, Rounded Back', 'Chairs', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (13, 'FUR-CH-10000665', 'Global Airflow Leather Mesh Back Chair, Black', 'Chairs', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (14, 'FUR-CH-10000785', 'Global Ergonomic Managers Chair', 'Chairs', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (15, 'FUR-CH-10000863', 'Novimex Swivel Fabric Task Chair', 'Chairs', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (16, 'FUR-CH-10001146', 'Global Task Chair, Black', 'Chairs', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (17, 'FUR-CH-10001215', 'Global Troy Executive Leather Low-Back Tilter', 'Chairs', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (18, 'FUR-CH-10001891', 'Global Deluxe Office Fabric Chairs', 'Chairs', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (19, 'FUR-CH-10002024', 'HON 5400 Series Task Chairs for Big and Tall', 'Chairs', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (20, 'FUR-CH-10002331', 'Hon 4700 Series Mobuis Mid-Back Task Chairs with Adjustable Arms', 'Chairs', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (21, 'FUR-CH-10002372', 'Office Star - Ergonomically Designed Knee Chair', 'Chairs', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (22, 'FUR-CH-10002602', 'DMI Arturo Collection Mission-style Design Wood Chair', 'Chairs', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (23, 'FUR-CH-10002774', 'Global Deluxe Stacking Chair, Gray', 'Chairs', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (24, 'FUR-CH-10002965', 'Global Leather Highback Executive Chair with Pneumatic Height Adjustment, Black', 'Chairs', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (25, 'FUR-CH-10003312', 'Hon 2090 ?Pillow Soft? Series Mid Back Swivel/Tilt Chairs', 'Chairs', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (26, 'FUR-CH-10003379', 'Global Commerce Series High-Back Swivel/Tilt Chairs', 'Chairs', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (27, 'FUR-CH-10003396', 'Global Deluxe Steno Chair', 'Chairs', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (28, 'FUR-CH-10003746', 'Hon 4070 Series Pagoda Round Back Stacking Chairs', 'Chairs', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (29, 'FUR-CH-10003956', 'Novimex High-Tech Fabric Mesh Task Chair', 'Chairs', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (30, 'FUR-CH-10003968', 'Novimex Turbo Task Chair', 'Chairs', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (31, 'FUR-CH-10004086', 'Hon 4070 Series Pagoda Armless Upholstered Stacking Chairs', 'Chairs', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (32, 'FUR-CH-10004886', 'Bevis Steel Folding Chairs', 'Chairs', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (33, 'FUR-CH-10004997', 'Hon Every-Day Series Multi-Task Chairs', 'Chairs', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (34, 'FUR-FU-10000010', 'DAX Value U-Channel Document Frames, Easel Back', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (35, 'FUR-FU-10000023', 'Eldon Wave Desk Accessories', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (36, 'FUR-FU-10000073', 'Deflect-O Glasstique Clear Desk Accessories', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (37, 'FUR-FU-10000206', 'GE General Purpose, Extra Long Life, Showcase & Floodlight Incandescent Bulbs', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (38, 'FUR-FU-10000221', 'Master Caster Door Stop, Brown', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (39, 'FUR-FU-10000246', 'Aluminum Document Frame', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (40, 'FUR-FU-10000260', '6" Cubicle Wall Clock, Black', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (41, 'FUR-FU-10000448', 'Tenex Chairmats For Use With Carpeted Floors', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (42, 'FUR-FU-10000521', 'Seth Thomas 14" Putty-Colored Wall Clock', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (43, 'FUR-FU-10000576', 'Luxo Professional Fluorescent Magnifier Lamp with Clamp-Mount Base', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (44, 'FUR-FU-10000629', '9-3/4 Diameter Round Wall Clock', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (45, 'FUR-FU-10000732', 'Eldon 200 Class Desk Accessories', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (46, 'FUR-FU-10000794', 'Eldon Stackable Tray, Side-Load, Legal, Smoke', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (47, 'FUR-FU-10001290', 'Executive Impressions Supervisor Wall Clock', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (48, 'FUR-FU-10001475', 'Contract Clock, 14", Brown', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (49, 'FUR-FU-10001706', 'Longer-Life Soft White Bulbs', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (50, 'FUR-FU-10001756', 'Eldon Expressions Desk Accessory, Wood Photo Frame, Mahogany', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (51, 'FUR-FU-10001861', 'Floodlight Indoor Halogen Bulbs, 1 Bulb per Pack, 60 Watts', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (52, 'FUR-FU-10001918', 'C-Line Cubicle Keepers Polyproplyene Holder With Velcro Backings', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (53, 'FUR-FU-10001934', 'Magnifier Swing Arm Lamp', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (54, 'FUR-FU-10001935', '3M Hangers With Command Adhesive', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (55, 'FUR-FU-10001967', 'Telescoping Adjustable Floor Lamp', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (56, 'FUR-FU-10002157', 'Artistic Insta-Plaque', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (57, 'FUR-FU-10002253', 'Howard Miller 13" Diameter Pewter Finish Round Wall Clock', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (58, 'FUR-FU-10002505', 'Eldon 100 Class Desk Accessories', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (59, 'FUR-FU-10002597', 'C-Line Magnetic Cubicle Keepers, Clear Polypropylene', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (60, 'FUR-FU-10002671', 'Electrix 20W Halogen Replacement Bulb for Zoom-In Desk Lamp', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (61, 'FUR-FU-10002759', '12-1/2 Diameter Round Wall Clock', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (62, 'FUR-FU-10002960', 'Eldon 200 Class Desk Accessories, Burgundy', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (63, 'FUR-FU-10003039', 'Howard Miller 11-1/2" Diameter Grantwood Wall Clock', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (64, 'FUR-FU-10003347', 'Coloredge Poster Frame', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (65, 'FUR-FU-10003394', 'Tenex "The Solids" Textured Chair Mats', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (66, 'FUR-FU-10003553', 'Howard Miller 13-1/2" Diameter Rosebrook Wall Clock', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (67, 'FUR-FU-10003577', 'Nu-Dell Leatherette Frames', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (68, 'FUR-FU-10003664', 'Electrix Architect''s Clamp-On Swing Arm Lamp, Black', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (69, 'FUR-FU-10003773', 'Eldon Cleatmat Plus Chair Mats for High Pile Carpets', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (70, 'FUR-FU-10003849', 'DAX Metal Frame, Desktop, Stepped-Edge', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (71, 'FUR-FU-10003878', 'Linden 10" Round Wall Clock, Black', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (72, 'FUR-FU-10004017', 'Tenex Contemporary Contur Chairmats for Low and Medium Pile Carpet, Computer, 39" x 49"', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (73, 'FUR-FU-10004090', 'Executive Impressions 14" Contract Wall Clock', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (74, 'FUR-FU-10004351', 'Staple-based wall hangings', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (75, 'FUR-FU-10004712', 'Westinghouse Mesh Shade Clip-On Gooseneck Lamp, Black', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (76, 'FUR-FU-10004848', 'Howard Miller 13-3/4" Diameter Brushed Chrome Round Wall Clock', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (77, 'FUR-FU-10004864', 'Howard Miller 14-1/2" Diameter Chrome Round Wall Clock', 'Furnishings', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (78, 'FUR-TA-10000198', 'Chromcraft Bull-Nose Wood Oval Conference Tables & Bases', 'Tables', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (79, 'FUR-TA-10000688', 'Chromcraft Bull-Nose Wood Round Conference Table Top, Wood Base', 'Tables', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (80, 'FUR-TA-10001095', 'Chromcraft Round Conference Tables', 'Tables', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (81, 'FUR-TA-10001539', 'Chromcraft Rectangular Conference Tables', 'Tables', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (82, 'FUR-TA-10001705', 'Bush Advantage Collection Round Conference Table', 'Tables', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (83, 'FUR-TA-10001857', 'Balt Solid Wood Rectangular Table', 'Tables', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (84, 'FUR-TA-10001889', 'Bush Advantage Collection Racetrack Conference Table', 'Tables', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (85, 'FUR-TA-10002041', 'Bevis Round Conference Table Top, X-Base', 'Tables', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (86, 'FUR-TA-10002228', 'Bevis Traditional Conference Table Top, Plinth Base', 'Tables', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (87, 'FUR-TA-10002533', 'BPI Conference Tables', 'Tables', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (88, 'FUR-TA-10002607', 'KI Conference Tables', 'Tables', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (89, 'FUR-TA-10003473', 'Bretford Rectangular Conference Table Tops', 'Tables', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (90, 'FUR-TA-10004256', 'Bretford ?Just In Time? Height-Adjustable Multi-Task Work Tables', 'Tables', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (91, 'FUR-TA-10004915', 'Office Impressions End Table, 20-1/2"H x 24"W x 20"D', 'Tables', 'Furniture');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (92, 'OFF-AP-10000326', 'Belkin 7 Outlet SurgeMaster Surge Protector with Phone Protection', 'Appliances', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (93, 'OFF-AP-10000358', 'Fellowes Basic Home/Office Series Surge Protectors', 'Appliances', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (94, 'OFF-AP-10000576', 'Belkin 7 Outlet SurgeMaster II', 'Appliances', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (95, 'OFF-AP-10000804', 'Hoover Portapower Portable Vacuum', 'Appliances', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (96, 'OFF-AP-10001058', 'Sanyo 2.5 Cubic Foot Mid-Size Office Refrigerators', 'Appliances', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (97, 'OFF-AP-10001124', 'Belkin 8 Outlet SurgeMaster II Gold Surge Protector with Phone Protection', 'Appliances', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (98, 'OFF-AP-10001154', 'Bionaire Personal Warm Mist Humidifier/Vaporizer', 'Appliances', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (99, 'OFF-AP-10001492', 'Acco Six-Outlet Power Strip, 4'' Cord Length', 'Appliances', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (100, 'OFF-AP-10001563', 'Belkin Premiere Surge Master II 8-outlet surge protector', 'Appliances', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (101, 'OFF-AP-10002118', '1.7 Cubic Foot Compact "Cube" Office Refrigerators', 'Appliances', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (102, 'OFF-AP-10002203', 'Eureka Disposable Bags for Sanitaire Vibra Groomer I Upright Vac', 'Appliances', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (103, 'OFF-AP-10002350', 'Belkin F9H710-06 7 Outlet SurgeMaster Surge Protector', 'Appliances', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (104, 'OFF-AP-10002439', 'Tripp Lite Isotel 8 Ultra 8 Outlet Metal Surge', 'Appliances', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (105, 'OFF-AP-10002457', 'Eureka The Boss Plus 12-Amp Hard Box Upright Vacuum, Red', 'Appliances', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (106, 'OFF-AP-10002578', 'Fellowes Premier Superior Surge Suppressor, 10-Outlet, With Phone and Remote', 'Appliances', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (107, 'OFF-AP-10002684', 'Acco 7-Outlet Masterpiece Power Center, Wihtout Fax/Phone Line Protection', 'Appliances', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (108, 'OFF-AP-10003217', 'Eureka Sanitaire  Commercial Upright', 'Appliances', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (109, 'OFF-AP-10003266', 'Holmes Replacement Filter for HEPA Air Cleaner, Large Room', 'Appliances', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (110, 'OFF-AP-10003287', 'Tripp Lite TLP810NET Broadband Surge for Modem/Fax', 'Appliances', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (111, 'OFF-AP-10003884', 'Fellowes Smart Surge Ten-Outlet Protector, Platinum', 'Appliances', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (112, 'OFF-AP-10004249', 'Staple holder', 'Appliances', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (113, 'OFF-AP-10004532', 'Kensington 6 Outlet Guardian Standard Surge Protector', 'Appliances', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (114, 'OFF-AR-10000246', 'Newell 318', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (115, 'OFF-AR-10000369', 'Design Ebony Sketching Pencil', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (116, 'OFF-AR-10000380', 'Hunt PowerHouse Electric Pencil Sharpener, Blue', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (117, 'OFF-AR-10000390', 'Newell Chalk Holder', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (118, 'OFF-AR-10000588', 'Newell 345', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (119, 'OFF-AR-10000940', 'Newell 343', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (120, 'OFF-AR-10001149', 'Sanford Colorific Colored Pencils, 12/Box', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (121, 'OFF-AR-10001246', 'Newell 317', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (122, 'OFF-AR-10001374', 'BIC Brite Liner Highlighters, Chisel Tip', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (123, 'OFF-AR-10001427', 'Newell 330', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (124, 'OFF-AR-10001573', 'American Pencil', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (125, 'OFF-AR-10001868', 'Prang Dustless Chalk Sticks', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (126, 'OFF-AR-10001953', 'Boston 1645 Deluxe Heavier-Duty Electric Pencil Sharpener', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (127, 'OFF-AR-10001954', 'Newell 331', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (128, 'OFF-AR-10002053', 'Premium Writing Pencils, Soft, #2 by Central Association for the Blind', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (129, 'OFF-AR-10002335', 'DIXON Oriole Pencils', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (130, 'OFF-AR-10002399', 'Dixon Prang Watercolor Pencils, 10-Color Set with Brush', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (131, 'OFF-AR-10002804', 'Faber Castell Col-Erase Pencils', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (132, 'OFF-AR-10002956', 'Boston 16801 Nautilus Battery Pencil Sharpener', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (133, 'OFF-AR-10003045', 'Prang Colored Pencils', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (134, 'OFF-AR-10003156', '50 Colored Long Pencils', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (135, 'OFF-AR-10003373', 'Boston School Pro Electric Pencil Sharpener, 1670', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (136, 'OFF-AR-10003394', 'Newell 332', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (137, 'OFF-AR-10003478', 'Avery Hi-Liter EverBold Pen Style Fluorescent Highlighters, 4/Pack', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (138, 'OFF-AR-10003602', 'Quartet Omega Colored Chalk, 12/Pack', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (139, 'OFF-AR-10003732', 'Newell 333', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (140, 'OFF-AR-10003811', 'Newell 327', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (141, 'OFF-AR-10003958', 'Newell 337', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (142, 'OFF-AR-10004027', 'Binney & Smith inkTank Erasable Desk Highlighter, Chisel Tip, Yellow, 12/Box', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (143, 'OFF-AR-10004344', 'Bulldog Vacuum Base Pencil Sharpener', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (144, 'OFF-AR-10004648', 'Boston 19500 Mighty Mite Electric Pencil Sharpener', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (145, 'OFF-AR-10004685', 'Binney & Smith Crayola Metallic Colored Pencils, 8-Color Set', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (146, 'OFF-AR-10004930', 'Turquoise Lead Holder with Pocket Clip', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (147, 'OFF-AR-10004974', 'Newell 342', 'Art', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (148, 'OFF-BI-10000014', 'Heavy-Duty E-Z-D Binders', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (149, 'OFF-BI-10000050', 'Angle-D Binders with Locking Rings, Label Holders', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (150, 'OFF-BI-10000069', 'GBC Prepunched Paper, 19-Hole, for Binding Systems, 24-lb', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (151, 'OFF-BI-10000138', 'Acco Translucent Poly Ring Binders', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (152, 'OFF-BI-10000301', 'GBC Instant Report Kit', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (153, 'OFF-BI-10000315', 'Poly Designer Cover & Back', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (154, 'OFF-BI-10000343', 'Pressboard Covers with Storage Hooks, 9 1/2" x 11", Light Blue', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (155, 'OFF-BI-10000404', 'Avery Printable Repositionable Plastic Tabs', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (156, 'OFF-BI-10000545', 'GBC Ibimaster 500 Manual ProClick Binding System', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (157, 'OFF-BI-10000546', 'Avery Durable Binders', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (158, 'OFF-BI-10000605', 'Acco Pressboard Covers with Storage Hooks, 9 1/2" x 11", Executive Red', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (159, 'OFF-BI-10000778', 'GBC VeloBinder Electric Binding Machine', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (160, 'OFF-BI-10000831', 'Storex Flexible Poly Binders with Double Pockets', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (161, 'OFF-BI-10000848', 'Angle-D Ring Binders', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (162, 'OFF-BI-10001036', 'Cardinal EasyOpen D-Ring Binders', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (163, 'OFF-BI-10001107', 'GBC White Gloss Covers, Plain Front', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (164, 'OFF-BI-10001153', 'Ibico Recycled Grain-Textured Covers', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (165, 'OFF-BI-10001294', 'Fellowes Binding Cases', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (166, 'OFF-BI-10001460', 'Plastic Binding Combs', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (167, 'OFF-BI-10001524', 'GBC Premium Transparent Covers with Diagonal Lined Pattern', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (168, 'OFF-BI-10001543', 'GBC VeloBinder Manual Binding System', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (169, 'OFF-BI-10001634', 'Wilson Jones Active Use Binders', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (170, 'OFF-BI-10001636', 'Ibico Plastic and Wire Spiral Binding Combs', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (171, 'OFF-BI-10001658', 'GBC Standard Therm-A-Bind Covers', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (172, 'OFF-BI-10001670', 'Vinyl Sectional Post Binders', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (173, 'OFF-BI-10001679', 'GBC Instant Index System for Binding Systems', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (174, 'OFF-BI-10001721', 'Trimflex Flexible Post Binders', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (175, 'OFF-BI-10001890', 'Avery Poly Binder Pockets', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (176, 'OFF-BI-10001922', 'Storex Dura Pro Binders', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (177, 'OFF-BI-10001982', 'Wilson Jones Custom Binder Spines & Labels', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (178, 'OFF-BI-10001989', 'Premium Transparent Presentation Covers by GBC', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (179, 'OFF-BI-10002160', 'Acco Hanging Data Binders', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (180, 'OFF-BI-10002194', 'Cardinal Hold-It CD Pocket', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (181, 'OFF-BI-10002225', 'Square Ring Data Binders, Rigid 75 Pt. Covers, 11" x 14-7/8"', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (182, 'OFF-BI-10002309', 'Avery Heavy-Duty EZD  Binder With Locking Rings', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (183, 'OFF-BI-10002412', 'Wilson Jones ?Snap? Scratch Pad Binder Tool for Ring Binders', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (184, 'OFF-BI-10002429', 'Premier Elliptical Ring Binder, Black', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (185, 'OFF-BI-10002498', 'Clear Mylar Reinforcing Strips', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (186, 'OFF-BI-10002557', 'Presstex Flexible Ring Binders', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (187, 'OFF-BI-10002609', 'Avery Hidden Tab Dividers for Binding Systems', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (188, 'OFF-BI-10002706', 'Avery Premier Heavy-Duty Binder with Round Locking Rings', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (189, 'OFF-BI-10002735', 'GBC Prestige Therm-A-Bind Covers', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (190, 'OFF-BI-10002764', 'Recycled Pressboard Report Cover with Reinforced Top Hinge', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (191, 'OFF-BI-10002824', 'Recycled Easel Ring Binders', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (192, 'OFF-BI-10002827', 'Avery Durable Poly Binders', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (193, 'OFF-BI-10002949', 'Prestige Round Ring Binders', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (194, 'OFF-BI-10003274', 'Avery Durable Slant Ring Binders, No Labels', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (195, 'OFF-BI-10003291', 'Wilson Jones Leather-Like Binders with DublLock Round Rings', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (196, 'OFF-BI-10003305', 'Avery Hanging File Binders', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (197, 'OFF-BI-10003460', 'Acco 3-Hole Punch', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (198, 'OFF-BI-10003638', 'GBC Durable Plastic Covers', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (199, 'OFF-BI-10003656', 'Fellowes PB200 Plastic Comb Binding Machine', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (200, 'OFF-BI-10003910', 'DXL Angle-View Binders with Locking Rings by Samsill', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (201, 'OFF-BI-10003981', 'Avery Durable Plastic 1" Binders', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (202, 'OFF-BI-10003982', 'Wilson Jones Century Plastic Molded Ring Binders', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (203, 'OFF-BI-10004002', 'Wilson Jones International Size A4 Ring Binders', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (204, 'OFF-BI-10004182', 'Economy Binders', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (205, 'OFF-BI-10004492', 'Tuf-Vin Binders', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (206, 'OFF-BI-10004584', 'GBC ProClick 150 Presentation Binding System', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (207, 'OFF-BI-10004593', 'Ibico Laser Imprintable Binding System Covers', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (208, 'OFF-BI-10004632', 'Ibico Hi-Tech Manual Binding System', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (209, 'OFF-BI-10004654', 'Avery Binding System Hidden Tab Executive Style Index Sets', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (210, 'OFF-BI-10004728', 'Wilson Jones Turn Tabs Binder Tool for Ring Binders', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (211, 'OFF-BI-10004738', 'Flexible Leather- Look Classic Collection Ring Binder', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (212, 'OFF-BI-10004781', 'GBC Wire Binding Strips', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (213, 'OFF-BI-10004995', 'GBC DocuBind P400 Electric Binding System', 'Binders', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (214, 'OFF-EN-10000483', 'White Envelopes, White Envelopes with Clear Poly Window', 'Envelopes', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (215, 'OFF-EN-10001137', '#10 Gummed Flap White Envelopes, 100/Box', 'Envelopes', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (216, 'OFF-EN-10001141', 'Manila Recycled Extra-Heavyweight Clasp Envelopes, 6" x 9"', 'Envelopes', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (217, 'OFF-EN-10001219', '#10- 4 1/8" x 9 1/2" Security-Tint Envelopes', 'Envelopes', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (218, 'OFF-EN-10001415', 'Staple envelope', 'Envelopes', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (219, 'OFF-EN-10001990', 'Staple envelope', 'Envelopes', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (220, 'OFF-EN-10002230', 'Airmail Envelopes', 'Envelopes', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (221, 'OFF-EN-10002500', 'Globe Weis Peel & Seel First Class Envelopes', 'Envelopes', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (222, 'OFF-EN-10003296', 'Tyvek Side-Opening Peel & Seel Expanding Envelopes', 'Envelopes', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (223, 'OFF-EN-10004030', 'Convenience Packs of Business Envelopes', 'Envelopes', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (224, 'OFF-EN-10004386', 'Recycled Interoffice Envelopes with String and Button Closure, 10 x 13', 'Envelopes', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (225, 'OFF-EN-10004459', 'Security-Tint Envelopes', 'Envelopes', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (226, 'OFF-FA-10000134', 'Advantus Push Pins, Aluminum Head', 'Fasteners', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (227, 'OFF-FA-10000304', 'Advantus Push Pins', 'Fasteners', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (228, 'OFF-FA-10000585', 'OIC Bulk Pack Metal Binder Clips', 'Fasteners', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (229, 'OFF-FA-10000621', 'OIC Colored Binder Clips, Assorted Sizes', 'Fasteners', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (230, 'OFF-FA-10000624', 'OIC Binder Clips', 'Fasteners', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (231, 'OFF-FA-10002280', 'Advantus Plastic Paper Clips', 'Fasteners', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (232, 'OFF-FA-10002780', 'Staples', 'Fasteners', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (233, 'OFF-FA-10002983', 'Advantus SlideClip Paper Clips', 'Fasteners', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (234, 'OFF-FA-10002988', 'Ideal Clamps', 'Fasteners', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (235, 'OFF-FA-10003112', 'Staples', 'Fasteners', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (236, 'OFF-FA-10003472', 'Bagged Rubber Bands', 'Fasteners', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (237, 'OFF-FA-10004248', 'Advantus T-Pin Paper Clips', 'Fasteners', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (238, 'OFF-LA-10000134', 'Avery 511', 'Labels', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (239, 'OFF-LA-10000240', 'Self-Adhesive Address Labels for Typewriters by Universal', 'Labels', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (240, 'OFF-LA-10000634', 'Avery 509', 'Labels', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (241, 'OFF-LA-10001074', 'Round Specialty Laser Printer Labels', 'Labels', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (242, 'OFF-LA-10001158', 'Avery Address/Shipping Labels for Typewriters, 4" x 2"', 'Labels', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (243, 'OFF-LA-10001297', 'Avery 473', 'Labels', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (244, 'OFF-LA-10001317', 'Avery 520', 'Labels', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (245, 'OFF-LA-10002043', 'Avery 489', 'Labels', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (246, 'OFF-LA-10002475', 'Avery 519', 'Labels', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (247, 'OFF-LA-10002787', 'Avery 480', 'Labels', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (248, 'OFF-LA-10003223', 'Avery 508', 'Labels', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (249, 'OFF-LA-10003766', 'Self-Adhesive Removable Labels', 'Labels', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (250, 'OFF-LA-10003923', 'Alphabetical Labels for Top Tab Filing', 'Labels', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (251, 'OFF-LA-10003930', 'Dot Matrix Printer Tape Reel Labels, White, 5000/Box', 'Labels', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (252, 'OFF-LA-10004093', 'Avery 486', 'Labels', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (253, 'OFF-LA-10004345', 'Avery 493', 'Labels', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (254, 'OFF-LA-10004484', 'Avery 476', 'Labels', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (255, 'OFF-LA-10004689', 'Avery 512', 'Labels', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (256, 'OFF-LA-10004853', 'Avery 483', 'Labels', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (257, 'OFF-PA-10000157', 'Xerox 191', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (258, 'OFF-PA-10000249', 'Easy-staple paper', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (259, 'OFF-PA-10000304', 'Xerox 1995', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (260, 'OFF-PA-10000357', 'White Dual Perf Computer Printout Paper, 2700 Sheets, 1 Part, Heavyweight, 20 lbs., 14 7/8 x 11', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (261, 'OFF-PA-10000474', 'Easy-staple paper', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (262, 'OFF-PA-10000482', 'Snap-A-Way Black Print Carbonless Ruled Speed Letter, Triplicate', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (263, 'OFF-PA-10000587', 'Array Parchment Paper, Assorted Colors', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (264, 'OFF-PA-10000673', 'Post-it ?Important Message? Note Pad, Neon Colors, 50 Sheets/Pad', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (265, 'OFF-PA-10001204', 'Xerox 1972', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (266, 'OFF-PA-10001560', 'Adams Telephone Message Books, 5 1/4? x 11?', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (267, 'OFF-PA-10001569', 'Xerox 232', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (268, 'OFF-PA-10001667', 'Great White Multi-Use Recycled Paper (20Lb. and 84 Bright)', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (269, 'OFF-PA-10001736', 'Xerox 1880', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (270, 'OFF-PA-10001790', 'Xerox 1910', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (271, 'OFF-PA-10001804', 'Xerox 195', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (272, 'OFF-PA-10001870', 'Xerox 202', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (273, 'OFF-PA-10001934', 'Xerox 1993', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (274, 'OFF-PA-10001950', 'Southworth 25% Cotton Antique Laid Paper & Envelopes', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (275, 'OFF-PA-10001954', 'Xerox 1964', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (276, 'OFF-PA-10001970', 'Xerox 1881', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (277, 'OFF-PA-10002005', 'Xerox 225', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (278, 'OFF-PA-10002036', 'Xerox 1930', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (279, 'OFF-PA-10002105', 'Xerox 223', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (280, 'OFF-PA-10002137', 'Southworth 100% Rsum Paper, 24lb.', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (281, 'OFF-PA-10002222', 'Xerox Color Copier Paper, 11" x 17", Ream', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (282, 'OFF-PA-10002230', 'Xerox 1897', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (283, 'OFF-PA-10002365', 'Xerox 1967', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (284, 'OFF-PA-10002377', 'Adams Telephone Message Book W/Dividers/Space For Phone Numbers, 5 1/4"X8 1/2", 200/Messages', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (285, 'OFF-PA-10002479', 'Xerox 4200 Series MultiUse Premium Copy Paper (20Lb. and 84 Bright)', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (286, 'OFF-PA-10002552', 'Xerox 1958', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (287, 'OFF-PA-10002615', 'Ampad Gold Fibre Wirebound Steno Books, 6" x 9", Gregg Ruled', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (288, 'OFF-PA-10002666', 'Southworth 25% Cotton Linen-Finish Paper & Envelopes', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (289, 'OFF-PA-10002713', 'Adams Phone Message Book, 200 Message Capacity, 8 1/16? x 11?', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (290, 'OFF-PA-10002749', 'Wirebound Message Books, 5-1/2 x 4 Forms, 2 or 4 Forms per Page', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (291, 'OFF-PA-10002751', 'Xerox 1920', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (292, 'OFF-PA-10002893', 'Wirebound Service Call Books, 5 1/2" x 4"', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (293, 'OFF-PA-10002986', 'Xerox 1898', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (294, 'OFF-PA-10003039', 'Xerox 1960', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (295, 'OFF-PA-10003256', 'Avery Personal Creations Heavyweight Cards', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (296, 'OFF-PA-10003349', 'Xerox 1957', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (297, 'OFF-PA-10003441', 'Xerox 226', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (298, 'OFF-PA-10003651', 'Xerox 1968', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (299, 'OFF-PA-10003724', 'Wirebound Message Book, 4 per Page', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (300, 'OFF-PA-10003845', 'Xerox 1987', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (301, 'OFF-PA-10003892', 'Xerox 1943', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (302, 'OFF-PA-10003953', 'Xerox 218', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (303, 'OFF-PA-10004040', 'Universal Premium White Copier/Laser Paper (20Lb. and 87 Bright)', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (304, 'OFF-PA-10004092', 'Tops Green Bar Computer Printout Paper', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (305, 'OFF-PA-10004101', 'Xerox 1894', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (306, 'OFF-PA-10004243', 'Xerox 1939', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (307, 'OFF-PA-10004327', 'Xerox 1911', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (308, 'OFF-PA-10004451', 'Xerox 222', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (309, 'OFF-PA-10004470', 'Adams Write n'' Stick Phone Message Book, 11" X 5 1/4", 200 Messages', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (310, 'OFF-PA-10004530', 'Personal Creations Ink Jet Cards and Labels', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (311, 'OFF-PA-10004569', 'Wirebound Message Books, Two 4 1/4" x 5" Forms per Page', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (312, 'OFF-PA-10004675', 'Telephone Message Books with Fax/Mobile Section, 5 1/2" x 3 3/16"', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (313, 'OFF-PA-10004734', 'Southworth Structures Collection', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (314, 'OFF-PA-10004971', 'Xerox 196', 'Paper', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (315, 'OFF-ST-10000036', 'Recycled Data-Pak for Archival Bound Computer Printouts, 12-1/2 x 12-1/2 x 16', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (316, 'OFF-ST-10000060', 'Fellowes Bankers Box Staxonsteel Drawer File/Stacking System', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (317, 'OFF-ST-10000142', 'Deluxe Rollaway Locking File with Drawer', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (318, 'OFF-ST-10000585', 'Economy Rollaway Files', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (319, 'OFF-ST-10000604', 'Home/Office Personal File Carts', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (320, 'OFF-ST-10000615', 'SimpliFile Personal File, Black Granite, 15w x 6-15/16d x 11-1/4h', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (321, 'OFF-ST-10000617', 'Woodgrain Magazine Files by Perma', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (322, 'OFF-ST-10000642', 'Tennsco Lockers, Gray', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (323, 'OFF-ST-10000675', 'File Shuttle II and Handi-File, Black', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (324, 'OFF-ST-10000689', 'Fellowes Strictly Business Drawer File, Letter/Legal Size', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (325, 'OFF-ST-10000736', 'Carina Double Wide Media Storage Towers in Natural & Black', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (326, 'OFF-ST-10000777', 'Companion Letter/Legal File, Black', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (327, 'OFF-ST-10000798', '2300 Heavy-Duty Transfer File Systems by Perma', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (328, 'OFF-ST-10000876', 'Eldon Simplefile Box Office', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (329, 'OFF-ST-10000918', 'Crate-A-Files', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (330, 'OFF-ST-10000934', 'Contico 72"H Heavy-Duty Storage System', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (331, 'OFF-ST-10001228', 'Fellowes Personal Hanging Folder Files, Navy', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (332, 'OFF-ST-10001325', 'Sterilite Officeware Hinged File Box', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (333, 'OFF-ST-10001328', 'Personal Filing Tote with Lid, Black/Gray', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (334, 'OFF-ST-10001414', 'Decoflex Hanging Personal Folder File', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (335, 'OFF-ST-10001469', 'Fellowes Bankers Box Recycled Super Stor/Drawer', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (336, 'OFF-ST-10001522', 'Gould Plastics 18-Pocket Panel Bin, 34w x 5-1/4d x 20-1/2h', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (337, 'OFF-ST-10001580', 'Super Decoflex Portable Personal File', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (338, 'OFF-ST-10001780', 'Tennsco 16-Compartment Lockers with Coat Rack', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (339, 'OFF-ST-10001963', 'Tennsco Regal Shelving Units', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (340, 'OFF-ST-10002205', 'File Shuttle I and Handi-File', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (341, 'OFF-ST-10002406', 'Pizazz Global Quick File', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (342, 'OFF-ST-10002583', 'Fellowes Neat Ideas Storage Cubes', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (343, 'OFF-ST-10002756', 'Tennsco Stur-D-Stor Boltless Shelving, 5 Shelves, 24" Deep, Sand', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (344, 'OFF-ST-10002790', 'Safco Industrial Shelving', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (345, 'OFF-ST-10002974', 'Trav-L-File Heavy-Duty Shuttle II, Black', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (346, 'OFF-ST-10003058', 'Eldon Mobile Mega Data Cart  Mega Stackable  Add-On Trays', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (347, 'OFF-ST-10003208', 'Adjustable Depth Letter/Legal Cart', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (348, 'OFF-ST-10003282', 'Advantus 10-Drawer Portable Organizer, Chrome Metal Frame, Smoke Drawers', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (349, 'OFF-ST-10003306', 'Letter Size Cart', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (350, 'OFF-ST-10003442', 'Eldon Portable Mobile Manager', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (351, 'OFF-ST-10003479', 'Eldon Base for stackable storage shelf, platinum', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (352, 'OFF-ST-10003656', 'Safco Industrial Wire Shelving', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (353, 'OFF-ST-10004180', 'Safco Commercial Shelving', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (354, 'OFF-ST-10004459', 'Tennsco Single-Tier Lockers', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (355, 'OFF-ST-10004507', 'Advantus Rolling Storage Box', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (356, 'OFF-ST-10004634', 'Personal Folder Holder, Ebony', 'Storage', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (357, 'OFF-SU-10000381', 'Acme Forged Steel Scissors with Black Enamel Handles', 'Supplies', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (358, 'OFF-SU-10000646', 'Premier Automatic Letter Opener', 'Supplies', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (359, 'OFF-SU-10001218', 'Fiskars Softgrip Scissors', 'Supplies', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (360, 'OFF-SU-10001225', 'Staple remover', 'Supplies', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (361, 'OFF-SU-10001574', 'Acme Value Line Scissors', 'Supplies', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (362, 'OFF-SU-10002503', 'Acme Preferred Stainless Steel Scissors', 'Supplies', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (363, 'OFF-SU-10003505', 'Premier Electric Letter Opener', 'Supplies', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (364, 'OFF-SU-10004115', 'Acme Stainless Steel Office Snips', 'Supplies', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (365, 'OFF-SU-10004231', 'Acme Tagit Stainless Steel Antibacterial Scissors', 'Supplies', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (366, 'OFF-SU-10004261', 'Fiskars 8" Scissors, 2/Pack', 'Supplies', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (367, 'OFF-SU-10004498', 'Martin-Yale Premier Letter Opener', 'Supplies', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (368, 'OFF-SU-10004664', 'Acme Softgrip Scissors', 'Supplies', 'Office Supplies');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (369, 'TEC-AC-10000158', 'Sony 64GB Class 10 Micro SDHC R40 Memory Card', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (370, 'TEC-AC-10000171', 'Verbatim 25 GB 6x Blu-ray Single Layer Recordable Disc, 25/Pack', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (371, 'TEC-AC-10000290', 'Sabrent 4-Port USB 2.0 Hub', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (372, 'TEC-AC-10000991', 'Sony Micro Vault Click 8 GB USB 2.0 Flash Drive', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (373, 'TEC-AC-10001101', 'Sony 16GB Class 10 Micro SDHC R40 Memory Card', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (374, 'TEC-AC-10001142', 'First Data FD10 PIN Pad', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (375, 'TEC-AC-10001267', 'Imationÿ32GB Pocket Pro USB 3.0ÿFlash Driveÿ- 32 GB - Black - 1 P ...', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (376, 'TEC-AC-10001606', 'Logitech Wireless Performance Mouse MX for PC and Mac', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (377, 'TEC-AC-10001714', 'LogitechÿMX Performance Wireless Mouse', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (378, 'TEC-AC-10001767', 'SanDisk Ultra 64 GB MicroSDHC Class 10 Memory Card', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (379, 'TEC-AC-10001772', 'Memorex Mini Travel Drive 16 GB USB 2.0 Flash Drive', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (380, 'TEC-AC-10001838', 'Razer Tiamat Over Ear 7.1 Surround Sound PC Gaming Headset', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (381, 'TEC-AC-10001908', 'Logitech Wireless Headset h800', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (382, 'TEC-AC-10001998', 'LogitechÿLS21 Speaker System - PC Multimedia - 2.1-CH - Wired', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (383, 'TEC-AC-10002001', 'Logitech Wireless Gaming Headset G930', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (384, 'TEC-AC-10002049', 'Logitech G19 Programmable Gaming Keyboard', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (385, 'TEC-AC-10002167', 'Imationÿ8gb Micro Traveldrive Usb 2.0ÿFlash Drive', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (386, 'TEC-AC-10002399', 'SanDisk Cruzer 32 GB USB Flash Drive', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (387, 'TEC-AC-10002402', 'Razer Kraken PRO Over Ear PC and Music Headset', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (388, 'TEC-AC-10002857', 'Verbatim 25 GB 6x Blu-ray Single Layer Recordable Disc, 1/Pack', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (389, 'TEC-AC-10003027', 'Imationÿ8GB Mini TravelDrive USB 2.0ÿFlash Drive', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (390, 'TEC-AC-10003499', 'Memorex Mini Travel Drive 8 GB USB 2.0 Flash Drive', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (391, 'TEC-AC-10003610', 'LogitechÿIlluminated - Keyboard', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (392, 'TEC-AC-10003614', 'Verbatim 25 GB 6x Blu-ray Single Layer Recordable Disc, 10/Pack', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (393, 'TEC-AC-10003628', 'Logitech 910-002974 M325 Wireless Mouse for Web Scrolling', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (394, 'TEC-AC-10003832', 'Imationÿ16GB Mini TravelDrive USB 2.0ÿFlash Drive', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (395, 'TEC-AC-10004659', 'ImationÿSecure+ Hardware Encrypted USB 2.0ÿFlash Drive; 16GB', 'Accessories', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (396, 'TEC-CO-10002095', 'Hewlett Packard 610 Color Digital Copier / Printer', 'Copiers', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (397, 'TEC-CO-10003236', 'Canon Image Class D660 Copier', 'Copiers', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (398, 'TEC-CO-10004115', 'Sharp AL-1530CS Digital Copier', 'Copiers', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (399, 'TEC-MA-10002937', 'Canon Color ImageCLASS MF8580Cdw Wireless Laser All-In-One Printer, Copier, Scanner', 'Machines', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (400, 'TEC-MA-10004002', 'Zebra GX420t Direct Thermal/Thermal Transfer Printer', 'Machines', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (401, 'TEC-MA-10004125', 'Cubify CubeX 3D Printer Triple Head Print', 'Machines', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (402, 'TEC-PH-10000004', 'Belkin iPhone and iPad Lightning Cable', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (403, 'TEC-PH-10000011', 'PureGear Roll-On Screen Protector', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (404, 'TEC-PH-10000149', 'Cisco SPA525G2 IP Phone - Wireless', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (405, 'TEC-PH-10000215', 'Plantronics CordlessÿPhone Headsetÿwith In-line Volume - M214C', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (406, 'TEC-PH-10000347', 'Cush Cases Heavy Duty Rugged Cover Case for Samsung Galaxy S5 - Purple', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (407, 'TEC-PH-10000586', 'AT&T SB67148 SynJ', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (408, 'TEC-PH-10000984', 'Panasonic KX-TG9471B', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (409, 'TEC-PH-10001254', 'Jabra BIZ 2300 Duo QD Duo CordedÿHeadset', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (410, 'TEC-PH-10001425', 'Mophie Juice Pack Helium for iPhone', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (411, 'TEC-PH-10001433', 'Cisco Small Business SPA 502G VoIP phone', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (412, 'TEC-PH-10001448', 'Anker Astro 15000mAh USB Portable Charger', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (413, 'TEC-PH-10001530', 'Cisco Unified IP Phone 7945G VoIP phone', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (414, 'TEC-PH-10001557', 'Pyle PMP37LED', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (415, 'TEC-PH-10001580', 'Logitech Mobile Speakerphone P710e -ÿspeaker phone', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (416, 'TEC-PH-10001700', 'Panasonic KX-TG6844B Expandable Digital Cordless Telephone', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (417, 'TEC-PH-10001918', 'Nortel Business Series Terminal T7208 Digital phone', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (418, 'TEC-PH-10001924', 'iHome FM Clock Radio with Lightning Dock', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (419, 'TEC-PH-10002085', 'Clarity 53712', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (420, 'TEC-PH-10002103', 'Jabra SPEAK 410', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (421, 'TEC-PH-10002170', 'ClearSounds CSC500 Amplified Spirit Phone Corded phone', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (422, 'TEC-PH-10002262', 'LG Electronics Tone+ HBS-730 Bluetooth Headset', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (423, 'TEC-PH-10002293', 'Anker 36W 4-Port USB Wall Charger Travel Power Adapter for iPhone 5s 5c 5', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (424, 'TEC-PH-10002365', 'Belkin Grip Candy Sheer Case / Cover for iPhone 5 and 5S', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (425, 'TEC-PH-10002447', 'AT&T CL83451 4-Handset Telephone', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (426, 'TEC-PH-10002496', 'Cisco SPA301', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (427, 'TEC-PH-10002538', 'Grandstream GXP1160 VoIP phone', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (428, 'TEC-PH-10002563', 'Adtran 1202752G1', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (429, 'TEC-PH-10002844', 'Speck Products Candyshell Flip Case', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (430, 'TEC-PH-10002923', 'Logitech B530 USBÿHeadsetÿ-ÿheadsetÿ- Full size, Binaural', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (431, 'TEC-PH-10003012', 'Nortel Meridian M3904 Professional Digital phone', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (432, 'TEC-PH-10003273', 'AT&T TR1909W', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (433, 'TEC-PH-10003555', 'Motorola HK250 Universal Bluetooth Headset', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (434, 'TEC-PH-10003645', 'Aastra 57i VoIP phone', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (435, 'TEC-PH-10003800', 'i.Sound Portable Power - 8000 mAh', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (436, 'TEC-PH-10003875', 'KLD Oscar II Style Snap-on Ultra Thin Side Flip Synthetic Leather Cover Case for HTC One HTC M7', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (437, 'TEC-PH-10003963', 'GE 2-Jack Phone Line Splitter', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (438, 'TEC-PH-10003988', 'LF Elite 3D Dazzle Designer Hard Case Cover, Lf Stylus Pen and Wiper For Apple Iphone 5c Mini Lite', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (439, 'TEC-PH-10004042', 'ClearOne Communications CHAT 70 OCÿSpeaker Phone', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (440, 'TEC-PH-10004093', 'Panasonic Kx-TS550', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (441, 'TEC-PH-10004536', 'Avaya 5420 Digital phone', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (442, 'TEC-PH-10004614', 'AT&T 841000 Phone', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (443, 'TEC-PH-10004667', 'Cisco 8x8 Inc. 6753i IP Business Phone System', 'Phones', 'Technology');
INSERT INTO public.dim_product OVERRIDING SYSTEM VALUE VALUES (444, 'TEC-PH-10004977', 'GE 30524EE4', 'Phones', 'Technology');


--
-- Data for Name: dim_ship_mode; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.dim_ship_mode OVERRIDING SYSTEM VALUE VALUES (1, 'First Class');
INSERT INTO public.dim_ship_mode OVERRIDING SYSTEM VALUE VALUES (2, 'Same Day');
INSERT INTO public.dim_ship_mode OVERRIDING SYSTEM VALUE VALUES (3, 'Second Class');
INSERT INTO public.dim_ship_mode OVERRIDING SYSTEM VALUE VALUES (4, 'Standard Class');


--
-- Data for Name: fact_sales; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (1, 'CA-2019-152156', 20191108, 20191111, 30, 3, 53, 3, 2, 261.96, 41.91, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (2, 'CA-2019-152156', 20191108, 20191111, 30, 12, 53, 3, 3, 731.94, 219.58, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (3, 'CA-2019-138688', 20190612, 20190616, 51, 239, 69, 3, 2, 14.62, 6.87, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (4, 'CA-2020-114412', 20200415, 20200420, 2, 283, 27, 4, 3, 15.55, 5.44, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (5, 'CA-2019-161389', 20191205, 20191210, 79, 199, 114, 4, 3, 407.98, 132.59, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (6, 'CA-2019-137330', 20191209, 20191213, 101, 114, 45, 4, 7, 19.46, 5.06, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (7, 'CA-2019-137330', 20191209, 20191213, 101, 99, 45, 4, 7, 60.34, 15.69, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (8, 'US-2020-156909', 20200716, 20200718, 176, 23, 94, 3, 2, 71.37, -1.02, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (9, 'CA-2019-121755', 20190116, 20190120, 57, 169, 69, 3, 2, 11.65, 4.22, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (10, 'CA-2019-121755', 20190116, 20190120, 57, 389, 69, 3, 3, 90.57, 11.77, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (11, 'CA-2020-107727', 20201019, 20201023, 123, 258, 56, 3, 3, 29.47, 9.95, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (12, 'CA-2019-117590', 20191208, 20191210, 68, 444, 99, 1, 7, 1097.54, 123.47, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (13, 'CA-2019-117590', 20191208, 20191210, 68, 68, 99, 1, 5, 190.92, -147.96, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (14, 'CA-2020-120999', 20200910, 20200915, 113, 440, 85, 4, 4, 147.17, 16.56, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (15, 'CA-2019-101343', 20190717, 20190722, 155, 351, 69, 4, 2, 77.88, 3.89, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (16, 'CA-2020-139619', 20200919, 20200923, 62, 348, 74, 4, 2, 95.62, 9.56, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (17, 'CA-2019-118255', 20190311, 20190313, 141, 370, 36, 1, 2, 45.98, 19.77, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (18, 'CA-2019-118255', 20190311, 20190313, 141, 195, 36, 1, 2, 17.46, 8.21, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (19, 'CA-2019-169194', 20190620, 20190625, 117, 385, 35, 4, 3, 45.00, 4.95, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (20, 'CA-2019-169194', 20190620, 20190625, 117, 438, 35, 4, 2, 21.80, 6.10, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (21, 'CA-2019-105816', 20191211, 20191217, 99, 227, 87, 4, 7, 15.26, 6.26, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (22, 'CA-2019-105816', 20191211, 20191217, 99, 425, 87, 4, 5, 1029.95, 298.69, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (23, 'CA-2019-111682', 20190617, 20190618, 190, 319, 120, 1, 6, 208.56, 52.14, DEFAULT, 1);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (24, 'CA-2019-111682', 20190617, 20190618, 190, 267, 120, 1, 5, 32.40, 15.55, DEFAULT, 1);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (25, 'CA-2019-111682', 20190617, 20190618, 190, 30, 120, 1, 5, 319.41, 7.10, DEFAULT, 1);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (26, 'CA-2019-111682', 20190617, 20190618, 190, 263, 120, 1, 2, 14.56, 6.99, DEFAULT, 1);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (27, 'CA-2019-111682', 20190617, 20190618, 190, 385, 120, 1, 2, 30.00, 3.30, DEFAULT, 1);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (28, 'CA-2019-111682', 20190617, 20190618, 190, 166, 120, 1, 4, 48.48, 16.36, DEFAULT, 1);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (29, 'CA-2019-111682', 20190617, 20190618, 190, 125, 120, 1, 1, 1.68, 0.84, DEFAULT, 1);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (30, 'CA-2019-119823', 20190604, 20190606, 105, 262, 116, 1, 2, 75.88, 35.66, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (31, 'CA-2019-106075', 20190918, 20190923, 77, 209, 87, 4, 1, 4.62, 1.73, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (32, 'CA-2020-114440', 20200914, 20200917, 191, 312, 60, 3, 3, 19.05, 8.76, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (33, 'US-2020-118038', 20201209, 20201211, 102, 204, 56, 1, 3, 1.25, -1.93, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (34, 'US-2020-118038', 20201209, 20201211, 102, 40, 56, 1, 3, 9.71, -5.82, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (35, 'US-2020-118038', 20201209, 20201211, 102, 320, 56, 1, 3, 27.24, 2.72, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (36, 'CA-2019-127208', 20190612, 20190615, 175, 101, 30, 1, 1, 208.16, 56.20, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (37, 'CA-2019-127208', 20190612, 20190615, 175, 182, 30, 1, 3, 16.74, 8.04, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (38, 'US-2020-119662', 20201113, 20201116, 38, 352, 18, 1, 3, 230.38, -48.95, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (39, 'CA-2020-140088', 20200528, 20200530, 152, 15, 21, 3, 2, 301.96, 33.22, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (40, 'CA-2020-155558', 20201026, 20201102, 145, 382, 101, 4, 1, 19.99, 6.80, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (41, 'CA-2020-155558', 20201026, 20201102, 145, 238, 101, 4, 2, 6.16, 2.96, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (42, 'CA-2019-159695', 20190405, 20190410, 71, 350, 56, 3, 7, 158.37, 13.86, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (43, 'CA-2019-109806', 20190917, 20190922, 100, 146, 69, 4, 3, 20.10, 6.63, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (44, 'CA-2019-109806', 20190917, 20190922, 100, 440, 69, 4, 2, 73.58, 8.28, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (45, 'CA-2019-109806', 20190917, 20190922, 100, 259, 69, 4, 1, 6.48, 3.11, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (46, 'US-2020-109484', 20201106, 20201112, 159, 211, 97, 4, 1, 5.68, -3.79, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (47, 'CA-2020-161018', 20201109, 20201111, 150, 44, 87, 3, 7, 96.53, 40.54, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (48, 'CA-2020-157833', 20200617, 20200620, 106, 174, 110, 1, 3, 51.31, 17.96, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (49, 'CA-2019-149223', 20190906, 20190911, 61, 93, 105, 4, 6, 77.88, 22.59, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (50, 'CA-2019-158568', 20190829, 20190902, 157, 295, 18, 4, 7, 64.62, 22.62, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (51, 'CA-2019-158568', 20190829, 20190902, 157, 378, 18, 4, 3, 95.98, -10.80, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (52, 'CA-2019-158568', 20190829, 20190902, 157, 187, 18, 4, 3, 1.79, -3.04, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (53, 'CA-2019-129903', 20191201, 20191204, 75, 303, 101, 3, 4, 23.92, 11.72, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (54, 'CA-2020-119004', 20201123, 20201128, 98, 390, 17, 4, 8, 74.11, 17.60, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (55, 'CA-2020-119004', 20201123, 20201128, 98, 429, 17, 4, 1, 27.99, 2.10, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (56, 'CA-2020-119004', 20201123, 20201128, 98, 117, 17, 4, 1, 3.30, 1.07, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (57, 'CA-2020-146780', 20201225, 20201230, 39, 53, 87, 4, 2, 41.96, 10.91, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (58, 'CA-2019-128867', 20191103, 20191110, 34, 116, 123, 4, 2, 75.96, 22.79, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (59, 'CA-2019-128867', 20191103, 20191110, 34, 201, 123, 4, 6, 27.24, 13.35, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (60, 'CA-2019-103730', 20190612, 20190615, 174, 56, 129, 1, 3, 47.04, 18.35, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (61, 'CA-2019-103730', 20190612, 20190615, 174, 200, 129, 1, 4, 30.84, 13.88, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (62, 'CA-2019-103730', 20190612, 20190615, 174, 326, 129, 1, 6, 226.56, 63.44, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (63, 'CA-2019-103730', 20190612, 20190615, 174, 221, 129, 1, 9, 115.02, 51.76, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (64, 'CA-2019-103730', 20190612, 20190615, 174, 436, 129, 1, 7, 68.04, 19.73, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (65, 'US-2020-107272', 20201105, 20201112, 198, 194, 95, 4, 2, 2.39, -1.83, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (66, 'US-2020-107272', 20201105, 20201112, 198, 345, 95, 4, 7, 243.99, 30.50, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (67, 'US-2019-125969', 20191106, 20191110, 121, 16, 69, 3, 2, 81.42, -9.16, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (68, 'US-2019-125969', 20191106, 20191110, 121, 69, 69, 3, 3, 238.56, 26.24, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (69, 'US-2020-164147', 20200202, 20200205, 53, 423, 25, 1, 5, 59.97, -11.99, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (70, 'US-2020-164147', 20200202, 20200205, 53, 284, 25, 1, 2, 78.30, 29.36, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (71, 'US-2020-164147', 20200202, 20200205, 53, 232, 25, 1, 9, 21.46, 6.97, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (72, 'CA-2019-145583', 20191013, 20191019, 112, 271, 103, 4, 3, 20.04, 9.62, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (73, 'CA-2019-145583', 20191013, 20191019, 112, 269, 103, 4, 1, 35.44, 16.66, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (74, 'CA-2019-145583', 20191013, 20191019, 112, 120, 103, 4, 4, 11.52, 3.46, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (75, 'CA-2019-145583', 20191013, 20191019, 112, 234, 103, 4, 2, 4.02, 1.97, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (76, 'CA-2019-145583', 20191013, 20191019, 112, 212, 103, 4, 3, 76.18, 26.66, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (77, 'CA-2019-145583', 20191013, 20191019, 112, 359, 103, 4, 6, 65.88, 18.45, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (78, 'CA-2019-145583', 20191013, 20191019, 112, 49, 103, 4, 14, 43.12, 20.70, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (79, 'CA-2019-110366', 20190905, 20190907, 83, 76, 94, 3, 2, 82.80, 10.35, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (80, 'CA-2020-106180', 20200918, 20200923, 179, 119, 110, 4, 3, 8.82, 2.38, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (81, 'CA-2020-106180', 20200918, 20200923, 179, 223, 110, 4, 3, 10.86, 5.10, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (82, 'CA-2020-106180', 20200918, 20200923, 179, 307, 110, 4, 3, 143.70, 68.98, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (83, 'CA-2020-155376', 20201222, 20201227, 178, 96, 58, 4, 3, 839.43, 218.25, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (84, 'CA-2019-114489', 20191205, 20191209, 87, 405, 44, 4, 11, 384.45, 103.80, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (85, 'CA-2019-114489', 20191205, 20191209, 87, 412, 44, 4, 3, 149.97, 6.00, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (86, 'CA-2019-114489', 20191205, 20191209, 87, 12, 44, 4, 8, 1951.84, 585.55, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (87, 'CA-2019-114489', 20191205, 20191209, 87, 189, 44, 4, 5, 171.55, 80.63, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (88, 'CA-2019-158834', 20190313, 20190316, 200, 92, 113, 1, 5, 157.92, 17.77, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (89, 'CA-2019-158834', 20190313, 20190316, 200, 409, 113, 1, 2, 203.18, 15.24, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (90, 'CA-2019-114104', 20191120, 20191124, 139, 246, 37, 4, 2, 14.62, 6.87, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (91, 'CA-2019-114104', 20191120, 20191124, 139, 441, 37, 4, 7, 944.93, 236.23, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (92, 'CA-2019-162733', 20190511, 20190512, 199, 291, 69, 1, 1, 5.98, 2.69, DEFAULT, 1);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (93, 'CA-2019-154508', 20191116, 20191120, 164, 219, 15, 4, 5, 28.40, 13.35, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (94, 'CA-2019-113817', 20191107, 20191111, 128, 203, 114, 4, 2, 27.68, 9.69, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (95, 'US-2020-152366', 20200421, 20200425, 182, 107, 56, 3, 4, 97.26, -243.16, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (96, 'CA-2019-105018', 20191128, 20191202, 183, 175, 39, 4, 2, 7.16, 3.44, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (97, 'CA-2019-157000', 20190716, 20190722, 9, 333, 48, 4, 3, 37.22, 3.72, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (98, 'CA-2019-157000', 20190716, 20190722, 9, 274, 48, 4, 3, 20.02, 6.26, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (99, 'CA-2020-107720', 20201106, 20201113, 203, 334, 127, 4, 3, 46.26, 12.03, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (100, 'US-2020-124303', 20200706, 20200713, 63, 154, 94, 4, 2, 2.95, -2.26, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (101, 'US-2020-124303', 20200706, 20200713, 63, 290, 94, 4, 3, 16.06, 5.82, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (102, 'CA-2020-105074', 20200624, 20200629, 124, 288, 1, 4, 3, 21.74, 6.80, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (103, 'US-2020-116701', 20201217, 20201221, 114, 108, 29, 3, 2, 66.28, -178.97, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (104, 'CA-2020-126382', 20200603, 20200607, 76, 62, 43, 4, 7, 35.17, 9.67, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (105, 'CA-2020-108329', 20201209, 20201214, 115, 417, 128, 4, 4, 444.77, 44.48, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (106, 'CA-2020-135860', 20201201, 20201207, 92, 322, 104, 4, 4, 83.92, 5.87, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (107, 'CA-2020-135860', 20201201, 20201207, 92, 416, 104, 4, 2, 131.98, 35.63, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (108, 'CA-2020-135860', 20201201, 20201207, 92, 194, 104, 4, 4, 15.92, 7.48, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (109, 'CA-2020-135860', 20201201, 20201207, 92, 226, 104, 4, 9, 52.29, 16.21, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (110, 'CA-2020-135860', 20201201, 20201207, 92, 336, 104, 4, 1, 91.99, 3.68, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (111, 'CA-2019-130162', 20191028, 20191101, 91, 333, 69, 4, 6, 93.06, 26.06, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (112, 'CA-2019-130162', 20191028, 20191101, 91, 428, 69, 4, 3, 302.38, 22.68, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (113, 'US-2020-100930', 20200407, 20200412, 38, 82, 118, 4, 2, 233.86, -102.05, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (114, 'US-2020-100930', 20200407, 20200412, 38, 89, 118, 4, 3, 620.61, -248.25, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (115, 'US-2020-100930', 20200407, 20200412, 38, 173, 118, 4, 2, 5.33, -3.55, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (116, 'US-2020-100930', 20200407, 20200412, 38, 72, 118, 4, 3, 258.07, 0.00, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (117, 'US-2020-100930', 20200407, 20200412, 38, 394, 118, 4, 3, 617.98, -7.72, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (118, 'CA-2020-160514', 20201112, 20201116, 41, 285, 112, 4, 2, 10.56, 4.75, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (119, 'CA-2019-157749', 20190604, 20190609, 110, 296, 18, 3, 5, 25.92, 9.40, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (120, 'CA-2019-157749', 20190604, 20190609, 110, 43, 18, 3, 5, 419.68, -356.73, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (121, 'CA-2019-157749', 20190604, 20190609, 110, 74, 18, 3, 3, 11.69, -4.68, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (122, 'CA-2019-157749', 20190604, 20190609, 110, 403, 18, 3, 2, 31.98, 11.19, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (123, 'CA-2019-157749', 20190604, 20190609, 110, 88, 18, 3, 5, 177.23, -120.51, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (124, 'CA-2019-157749', 20190604, 20190609, 110, 58, 18, 3, 3, 4.04, -2.83, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (125, 'CA-2019-157749', 20190604, 20190609, 110, 145, 18, 3, 2, 7.41, 1.20, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (126, 'CA-2019-154739', 20191210, 20191215, 118, 24, 110, 3, 2, 321.57, 28.14, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (127, 'CA-2019-145625', 20190911, 20190917, 103, 311, 109, 4, 1, 7.61, 3.58, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (128, 'CA-2019-145625', 20190911, 20190917, 103, 394, 109, 4, 13, 3347.37, 636.00, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (129, 'CA-2019-146941', 20191210, 20191213, 46, 331, 87, 1, 6, 80.58, 22.56, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (130, 'CA-2019-146941', 20191210, 20191213, 46, 222, 87, 1, 4, 361.92, 162.86, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (131, 'CA-2020-163139', 20201201, 20201203, 28, 371, 87, 3, 3, 20.37, 6.93, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (132, 'CA-2020-163139', 20201201, 20201203, 28, 344, 87, 3, 3, 221.55, 6.65, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (133, 'CA-2020-163139', 20201201, 20201203, 28, 197, 87, 3, 5, 17.52, 6.13, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (134, 'US-2020-155299', 20200608, 20200612, 47, 102, 93, 4, 2, 1.62, -4.47, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (135, 'CA-2019-125318', 20190606, 20190613, 161, 411, 18, 4, 4, 328.22, 28.72, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (136, 'CA-2020-136826', 20200616, 20200620, 25, 138, 16, 4, 3, 14.02, 4.73, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (137, 'CA-2019-111010', 20190122, 20190128, 145, 236, 82, 4, 6, 7.56, 0.30, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (138, 'US-2020-145366', 20201209, 20201213, 24, 353, 19, 4, 1, 37.21, -7.44, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (139, 'US-2020-145366', 20201209, 20201213, 24, 224, 19, 4, 3, 57.58, 21.59, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (140, 'CA-2020-118136', 20200916, 20200917, 16, 287, 59, 1, 2, 8.82, 4.06, DEFAULT, 1);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (141, 'CA-2020-118136', 20200916, 20200917, 16, 123, 59, 1, 1, 5.98, 1.55, DEFAULT, 1);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (142, 'CA-2020-132976', 20201013, 20201017, 5, 264, 94, 4, 2, 11.65, 4.08, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (143, 'CA-2020-132976', 20201013, 20201017, 5, 309, 94, 4, 4, 18.18, 5.91, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (144, 'CA-2020-132976', 20201013, 20201017, 5, 328, 94, 4, 6, 59.71, 5.97, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (145, 'CA-2020-132976', 20201013, 20201017, 5, 245, 94, 4, 3, 24.84, 8.69, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (146, 'CA-2019-112697', 20191218, 20191220, 7, 159, 117, 3, 7, 254.06, -169.37, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (147, 'CA-2019-112697', 20191218, 20191220, 7, 107, 117, 3, 2, 194.53, 24.32, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (148, 'CA-2019-112697', 20191218, 20191220, 7, 358, 117, 3, 5, 961.48, -204.31, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (149, 'CA-2019-110772', 20191120, 20191124, 140, 233, 25, 3, 7, 19.10, 6.68, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (150, 'CA-2019-110772', 20191120, 20191124, 140, 255, 25, 3, 8, 18.50, 6.24, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (151, 'CA-2019-110772', 20191120, 20191124, 140, 383, 25, 3, 2, 255.98, 54.40, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (152, 'CA-2019-110772', 20191120, 20191124, 140, 9, 25, 3, 3, 86.97, -48.70, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (153, 'CA-2019-142545', 20191028, 20191103, 83, 279, 12, 4, 5, 32.40, 15.55, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (154, 'CA-2019-142545', 20191028, 20191103, 83, 343, 12, 4, 8, 1082.48, 10.82, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (155, 'CA-2019-142545', 20191028, 20191103, 83, 306, 12, 4, 3, 56.91, 27.32, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (156, 'CA-2019-142545', 20191028, 20191103, 83, 51, 12, 4, 4, 77.60, 38.02, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (157, 'CA-2019-142545', 20191028, 20191103, 83, 188, 12, 4, 1, 14.28, 6.57, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (158, 'US-2020-152380', 20201119, 20201123, 91, 87, 18, 4, 3, 219.08, -131.45, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (159, 'CA-2020-126774', 20200415, 20200417, 180, 131, 4, 1, 1, 4.89, 2.00, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (160, 'CA-2019-142902', 20190912, 20190914, 22, 52, 5, 3, 4, 15.14, 3.59, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (161, 'CA-2019-142902', 20190912, 20190914, 22, 31, 5, 3, 2, 466.77, 52.51, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (162, 'CA-2019-142902', 20190912, 20190914, 22, 50, 5, 3, 1, 15.23, 1.71, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (163, 'CA-2019-142902', 20190912, 20190914, 22, 240, 5, 3, 3, 6.26, 2.04, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (164, 'CA-2019-162138', 20190423, 20190427, 69, 207, 54, 4, 6, 251.52, 81.74, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (165, 'CA-2019-162138', 20190423, 20190427, 69, 381, 54, 4, 1, 99.99, 35.00, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (166, 'CA-2020-153339', 20201103, 20201105, 43, 55, 84, 3, 1, 15.99, 1.00, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (167, 'US-2019-141544', 20190830, 20190901, 151, 434, 94, 1, 3, 290.90, -67.88, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (168, 'US-2019-141544', 20190830, 20190901, 151, 323, 94, 1, 2, 54.22, 3.39, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (169, 'US-2019-141544', 20190830, 20190901, 151, 25, 94, 1, 4, 786.74, -258.50, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (170, 'US-2019-141544', 20190830, 20190901, 151, 241, 94, 1, 10, 100.24, 33.83, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (171, 'US-2019-141544', 20190830, 20190901, 151, 167, 94, 1, 6, 37.76, -27.69, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (172, 'US-2019-150147', 20190425, 20190429, 97, 442, 94, 3, 2, 82.80, -20.70, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (173, 'US-2019-150147', 20190425, 20190429, 97, 164, 94, 3, 2, 20.72, -13.82, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (174, 'US-2019-150147', 20190425, 20190429, 97, 177, 94, 3, 3, 4.90, -3.43, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (175, 'CA-2020-169901', 20200615, 20200619, 27, 423, 110, 4, 3, 47.98, 4.80, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (176, 'CA-2020-134306', 20200708, 20200712, 193, 142, 71, 4, 3, 7.56, 3.10, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (177, 'CA-2020-134306', 20200708, 20200712, 193, 258, 71, 4, 2, 24.56, 11.54, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (178, 'CA-2020-134306', 20200708, 20200712, 193, 122, 71, 4, 2, 12.96, 4.15, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (179, 'CA-2019-129714', 20190901, 20190903, 3, 371, 87, 1, 1, 6.79, 2.31, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (180, 'CA-2019-129714', 20190901, 20190903, 3, 276, 87, 1, 2, 24.56, 11.54, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (181, 'CA-2019-129714', 20190901, 20190903, 3, 179, 87, 1, 1, 3.05, 1.07, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (182, 'CA-2019-129714', 20190901, 20190903, 3, 276, 87, 1, 4, 49.12, 23.09, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (183, 'CA-2019-129714', 20190901, 20190903, 3, 213, 87, 1, 4, 4355.17, 1415.43, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (184, 'CA-2019-138520', 20190408, 20190413, 95, 5, 87, 4, 6, 388.70, -4.86, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (185, 'CA-2019-138520', 20190408, 20190413, 95, 215, 87, 4, 2, 8.26, 3.80, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (186, 'CA-2019-138520', 20190408, 20190413, 95, 130, 87, 4, 4, 17.04, 6.99, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (187, 'CA-2019-138520', 20190408, 20190413, 95, 289, 87, 4, 5, 34.40, 15.82, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (188, 'CA-2019-130001', 20190423, 20190428, 76, 288, 17, 4, 5, 36.24, 11.33, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (189, 'CA-2020-155698', 20200308, 20200311, 201, 97, 23, 1, 8, 647.84, 168.44, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (190, 'CA-2020-155698', 20200308, 20200311, 201, 242, 23, 1, 2, 20.70, 9.94, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (191, 'CA-2020-144904', 20200925, 20201001, 111, 242, 87, 4, 2, 20.70, 9.94, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (192, 'CA-2020-144904', 20200925, 20201001, 111, 14, 87, 4, 3, 488.65, 86.87, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (193, 'CA-2020-144904', 20200925, 20201001, 111, 139, 87, 4, 2, 5.56, 1.45, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (194, 'CA-2020-144904', 20200925, 20201001, 111, 35, 87, 4, 8, 47.12, 20.73, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (195, 'CA-2019-155516', 20191021, 20191021, 129, 183, 72, 2, 4, 23.20, 10.44, DEFAULT, 0);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (196, 'CA-2019-155516', 20191021, 20191021, 129, 360, 72, 2, 2, 7.36, 0.15, DEFAULT, 0);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (197, 'CA-2019-155516', 20191021, 20191021, 129, 341, 72, 2, 7, 104.79, 29.34, DEFAULT, 0);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (198, 'CA-2019-155516', 20191021, 20191021, 129, 6, 72, 2, 4, 1043.92, 271.42, DEFAULT, 0);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (199, 'CA-2020-104745', 20200529, 20200604, 74, 278, 52, 4, 5, 25.92, 9.40, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (200, 'CA-2020-104745', 20200529, 20200604, 74, 340, 52, 4, 3, 53.42, 4.67, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (201, 'US-2019-134656', 20190928, 20191001, 130, 294, 98, 1, 4, 99.14, 30.98, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (202, 'US-2020-134481', 20200827, 20200901, 11, 91, 42, 4, 7, 1488.42, -297.68, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (203, 'CA-2019-134775', 20191028, 20191029, 14, 313, 110, 1, 7, 50.96, 25.48, DEFAULT, 1);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (204, 'CA-2019-134775', 20191028, 20191029, 14, 181, 110, 1, 3, 49.54, 17.34, DEFAULT, 1);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (205, 'CA-2020-101798', 20201211, 20201215, 134, 149, 87, 4, 4, 23.36, 7.88, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (206, 'CA-2020-101798', 20201211, 20201215, 134, 382, 87, 4, 2, 39.98, 13.59, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (207, 'CA-2020-102946', 20200630, 20200705, 204, 205, 66, 4, 3, 75.79, 25.58, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (208, 'CA-2020-165603', 20201017, 20201019, 187, 327, 126, 3, 2, 49.96, 9.49, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (209, 'CA-2020-165603', 20201017, 20201019, 187, 286, 126, 3, 2, 12.96, 6.22, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (210, 'CA-2019-108987', 20190908, 20190910, 6, 337, 56, 3, 3, 35.95, 3.60, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (211, 'CA-2019-108987', 20190908, 20190910, 6, 10, 56, 3, 4, 2396.27, -317.15, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (212, 'CA-2019-108987', 20190908, 20190910, 6, 330, 56, 3, 4, 131.14, -32.78, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (213, 'CA-2019-108987', 20190908, 20190910, 6, 369, 56, 3, 2, 57.58, 0.72, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (214, 'CA-2020-117933', 20201224, 20201229, 166, 112, 87, 4, 3, 35.91, 9.70, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (215, 'CA-2020-117457', 20201208, 20201212, 107, 369, 110, 4, 5, 179.95, 37.79, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (216, 'CA-2020-117457', 20201208, 20201212, 107, 398, 110, 4, 3, 1199.98, 434.99, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (217, 'CA-2020-117457', 20201208, 20201212, 107, 299, 110, 4, 5, 27.15, 13.30, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (218, 'CA-2020-117457', 20201208, 20201212, 107, 85, 110, 4, 7, 1004.02, -112.95, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (219, 'CA-2020-117457', 20201208, 20201212, 107, 292, 110, 4, 1, 9.68, 4.65, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (220, 'CA-2020-117457', 20201208, 20201212, 107, 249, 110, 4, 9, 28.35, 13.61, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (221, 'CA-2020-117457', 20201208, 20201212, 107, 276, 110, 4, 1, 55.98, 27.43, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (222, 'CA-2020-117457', 20201208, 20201212, 107, 4, 110, 4, 13, 1336.83, 31.45, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (223, 'CA-2020-117457', 20201208, 20201212, 107, 29, 110, 4, 2, 113.57, -18.45, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (224, 'CA-2020-142636', 20201103, 20201107, 104, 257, 114, 4, 7, 139.86, 65.73, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (225, 'CA-2020-142636', 20201103, 20201107, 104, 18, 114, 4, 4, 307.14, 26.87, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (226, 'CA-2020-122105', 20200624, 20200628, 31, 143, 57, 4, 8, 95.92, 25.90, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (227, 'CA-2019-148796', 20190414, 20190418, 144, 32, 69, 4, 5, 383.80, 38.38, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (228, 'CA-2020-154816', 20201106, 20201110, 201, 300, 100, 4, 1, 5.78, 2.83, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (229, 'CA-2020-110478', 20200304, 20200309, 185, 124, 69, 4, 4, 9.32, 2.70, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (230, 'CA-2020-110478', 20200304, 20200309, 185, 214, 69, 4, 1, 15.25, 7.02, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (231, 'CA-2020-125388', 20201019, 20201023, 132, 75, 67, 4, 4, 56.56, 14.71, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (232, 'CA-2020-125388', 20201019, 20201023, 132, 329, 67, 4, 3, 32.70, 8.50, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (233, 'CA-2020-155705', 20200821, 20200823, 137, 11, 61, 3, 4, 866.40, 225.26, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (234, 'CA-2020-149160', 20201123, 20201126, 99, 64, 14, 3, 2, 28.40, 11.08, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (235, 'CA-2020-149160', 20201123, 20201126, 99, 168, 14, 3, 8, 287.92, 138.20, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (236, 'CA-2020-152275', 20201001, 20201008, 108, 115, 108, 4, 6, 6.67, 0.50, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (237, 'US-2019-123750', 20190415, 20190421, 160, 206, 46, 4, 2, 189.59, -145.35, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (238, 'US-2019-123750', 20190415, 20190421, 160, 395, 46, 4, 7, 408.74, 76.64, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (239, 'US-2019-123750', 20190415, 20190421, 160, 395, 46, 4, 5, 291.96, 54.74, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (240, 'US-2019-123750', 20190415, 20190421, 160, 321, 46, 4, 2, 4.77, -0.77, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (241, 'CA-2019-127369', 20190606, 20190607, 40, 349, 71, 1, 5, 714.30, 207.15, DEFAULT, 1);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (242, 'CA-2019-147375', 20190612, 20190614, 153, 399, 18, 3, 3, 1007.98, 43.20, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (243, 'CA-2019-147375', 20190612, 20190614, 153, 276, 18, 3, 7, 313.49, 113.64, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (244, 'CA-2020-130043', 20200915, 20200919, 17, 282, 56, 4, 8, 31.87, 11.55, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (245, 'CA-2020-157252', 20200120, 20200123, 39, 27, 87, 3, 3, 207.85, 2.31, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (246, 'CA-2019-115756', 20190905, 20190907, 149, 39, 34, 3, 1, 12.22, 3.67, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (247, 'CA-2019-115756', 20190905, 20190907, 149, 316, 34, 3, 3, 194.94, 23.39, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (248, 'CA-2019-115756', 20190905, 20190907, 149, 346, 34, 3, 3, 70.95, 20.58, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (249, 'CA-2019-115756', 20190905, 20190907, 149, 281, 34, 3, 4, 91.36, 42.03, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (250, 'CA-2019-115756', 20190905, 20190907, 149, 21, 34, 3, 3, 242.94, 29.15, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (251, 'CA-2019-115756', 20190905, 20190907, 149, 244, 34, 3, 7, 22.05, 10.58, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (252, 'CA-2020-154214', 20200320, 20200325, 192, 37, 24, 3, 1, 2.91, 1.37, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (253, 'CA-2019-166674', 20190401, 20190403, 156, 118, 8, 3, 3, 59.52, 15.48, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (254, 'CA-2019-166674', 20190401, 20190403, 156, 335, 8, 3, 3, 161.94, 9.72, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (255, 'CA-2019-166674', 20190401, 20190403, 156, 126, 8, 3, 6, 263.88, 71.25, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (256, 'CA-2019-166674', 20190401, 20190403, 156, 134, 8, 3, 3, 30.48, 7.92, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (257, 'CA-2019-166674', 20190401, 20190403, 156, 147, 8, 3, 3, 9.84, 2.85, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (258, 'CA-2019-166674', 20190401, 20190403, 156, 424, 8, 3, 4, 35.12, 9.13, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (259, 'CA-2020-147277', 20201020, 20201024, 54, 81, 1, 4, 2, 284.36, -75.83, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (260, 'CA-2020-147277', 20201020, 20201024, 54, 317, 1, 4, 2, 665.41, 66.54, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (261, 'CA-2019-100153', 20191213, 20191217, 108, 379, 89, 4, 4, 63.88, 24.91, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (262, 'US-2019-157945', 20190926, 20191001, 137, 20, 31, 4, 3, 747.56, -96.11, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (263, 'US-2019-157945', 20190926, 20191001, 137, 218, 31, 4, 2, 8.93, 3.35, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (264, 'CA-2019-109869', 20190422, 20190429, 195, 35, 95, 4, 5, 23.56, 7.07, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (265, 'CA-2019-109869', 20190422, 20190429, 195, 84, 95, 4, 6, 1272.63, -814.48, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (266, 'CA-2019-109869', 20190422, 20190429, 195, 153, 95, 4, 5, 28.49, -20.89, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (267, 'CA-2019-109869', 20190422, 20190429, 195, 363, 95, 4, 2, 185.38, -34.76, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (268, 'CA-2019-109869', 20190422, 20190429, 195, 106, 95, 4, 2, 78.27, 5.87, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (269, 'CA-2020-154907', 20200331, 20200404, 50, 7, 2, 4, 2, 205.33, -36.24, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (270, 'US-2019-100419', 20191216, 20191220, 28, 180, 18, 3, 3, 4.79, -7.90, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (271, 'CA-2019-103891', 20190712, 20190719, 109, 404, 69, 4, 6, 95.76, 7.18, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (272, 'CA-2019-152632', 20191027, 20191102, 85, 60, 120, 4, 3, 40.20, 19.30, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (273, 'CA-2019-100790', 20190626, 20190702, 90, 133, 87, 4, 5, 14.70, 6.62, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (274, 'CA-2019-100790', 20190626, 20190702, 90, 324, 87, 4, 5, 704.25, 84.51, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (275, 'CA-2020-140963', 20200610, 20200613, 133, 250, 69, 1, 2, 29.60, 14.80, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (276, 'CA-2020-140963', 20200610, 20200613, 133, 1, 69, 1, 5, 514.17, -30.25, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (277, 'CA-2020-140963', 20200610, 20200613, 133, 418, 69, 1, 5, 279.96, 17.50, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (278, 'CA-2019-169166', 20190509, 20190514, 188, 372, 114, 4, 2, 93.98, 13.16, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (279, 'US-2019-120929', 20190318, 20190321, 169, 83, 75, 3, 3, 189.88, -94.94, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (280, 'CA-2019-126158', 20190725, 20190731, 171, 185, 28, 4, 8, 119.62, 40.37, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (281, 'CA-2019-126158', 20190725, 20190731, 171, 77, 28, 4, 4, 255.76, 81.84, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (282, 'CA-2019-126158', 20190725, 20190731, 171, 22, 28, 4, 2, 241.57, 18.12, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (283, 'CA-2019-126158', 20190725, 20190731, 171, 36, 28, 4, 9, 69.30, 22.87, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (284, 'US-2019-105578', 20190530, 20190604, 135, 172, 92, 4, 2, 22.62, -15.08, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (285, 'US-2019-105578', 20190530, 20190604, 135, 171, 92, 4, 2, 14.95, -11.96, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (286, 'US-2019-105578', 20190530, 20190604, 135, 17, 92, 4, 2, 801.57, 50.10, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (287, 'US-2019-105578', 20190530, 20190604, 135, 160, 92, 4, 3, 2.38, -1.90, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (288, 'US-2019-105578', 20190530, 20190604, 135, 260, 92, 4, 1, 32.79, 11.89, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (289, 'CA-2020-134978', 20201112, 20201115, 54, 194, 87, 3, 5, 15.92, 5.37, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (290, 'CA-2020-135307', 20201126, 20201127, 122, 47, 47, 1, 3, 126.30, 40.42, DEFAULT, 1);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (291, 'CA-2020-135307', 20201126, 20201127, 122, 386, 47, 1, 2, 38.04, 12.17, DEFAULT, 1);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (292, 'CA-2019-106341', 20191020, 20191023, 116, 128, 88, 1, 3, 7.15, 0.72, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (293, 'CA-2020-163405', 20201221, 20201225, 21, 140, 69, 4, 3, 6.63, 1.79, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (294, 'CA-2020-163405', 20201221, 20201225, 21, 121, 69, 4, 2, 5.88, 1.71, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (295, 'CA-2020-127432', 20200122, 20200127, 4, 397, 49, 4, 5, 2999.95, 1379.98, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (296, 'CA-2020-127432', 20200122, 20200127, 4, 355, 49, 4, 3, 51.45, 13.89, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (297, 'CA-2020-127432', 20200122, 20200127, 4, 268, 49, 4, 2, 11.96, 5.38, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (298, 'CA-2020-127432', 20200122, 20200127, 4, 354, 49, 4, 3, 1126.02, 56.30, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (299, 'CA-2020-145142', 20200123, 20200125, 125, 83, 34, 1, 2, 210.98, 21.10, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (300, 'US-2019-139486', 20190521, 20190523, 118, 433, 69, 1, 3, 55.18, -12.41, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (301, 'US-2019-139486', 20190521, 20190523, 118, 394, 69, 1, 2, 66.26, 27.17, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (302, 'CA-2020-113558', 20201021, 20201026, 146, 26, 63, 4, 3, 683.95, 42.75, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (303, 'CA-2020-113558', 20201021, 20201026, 146, 50, 63, 4, 3, 45.70, 5.14, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (304, 'US-2020-129441', 20200907, 20200911, 81, 41, 69, 4, 3, 47.94, 2.40, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (305, 'CA-2019-168753', 20190529, 20190601, 168, 408, 81, 3, 5, 979.95, 274.39, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (306, 'CA-2019-168753', 20190529, 20190601, 168, 186, 81, 3, 5, 22.75, 11.38, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (307, 'CA-2019-126613', 20190710, 20190716, 1, 332, 76, 4, 2, 16.77, 1.47, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (308, 'US-2020-122637', 20200903, 20200908, 60, 184, 18, 3, 7, 42.62, -68.19, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (309, 'CA-2019-136924', 20190714, 20190717, 62, 422, 121, 1, 8, 380.86, 38.09, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (310, 'CA-2020-162929', 20201119, 20201122, 13, 155, 87, 1, 6, 41.28, 13.93, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (311, 'CA-2020-162929', 20201119, 20201122, 13, 293, 87, 1, 2, 13.36, 6.41, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (312, 'CA-2019-136406', 20190415, 20190417, 18, 19, 110, 3, 2, 1121.57, 0.00, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (313, 'CA-2020-112774', 20200911, 20200912, 162, 63, 62, 1, 1, 34.50, 6.04, DEFAULT, 1);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (314, 'CA-2020-101945', 20201124, 20201128, 73, 237, 56, 4, 3, 10.82, 2.57, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (315, 'CA-2020-100650', 20200629, 20200703, 45, 338, 3, 3, 2, 1295.78, 310.99, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (316, 'CA-2019-113243', 20190610, 20190615, 142, 243, 69, 4, 2, 20.70, 9.94, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (317, 'CA-2019-113243', 20190610, 20190615, 142, 90, 69, 4, 4, 1335.68, -217.05, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (318, 'CA-2019-113243', 20190610, 20190615, 142, 297, 69, 4, 5, 32.40, 15.55, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (319, 'CA-2020-118731', 20201120, 20201122, 119, 64, 110, 3, 3, 42.60, 16.61, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (320, 'CA-2020-118731', 20201120, 20201122, 119, 150, 110, 3, 7, 84.06, 27.32, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (321, 'CA-2020-137099', 20201207, 20201210, 65, 426, 69, 1, 3, 374.38, 46.80, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (322, 'CA-2020-156951', 20201001, 20201008, 55, 310, 114, 4, 8, 91.84, 45.00, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (323, 'CA-2020-156951', 20201001, 20201008, 55, 163, 114, 4, 7, 81.09, 27.37, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (324, 'CA-2020-156951', 20201001, 20201008, 55, 308, 114, 4, 3, 19.44, 9.33, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (325, 'CA-2020-156951', 20201001, 20201008, 55, 33, 114, 4, 3, 451.15, 0.00, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (326, 'CA-2019-127250', 20191103, 20191107, 177, 136, 73, 4, 3, 8.82, 2.38, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (327, 'CA-2020-118640', 20200720, 20200726, 37, 345, 18, 4, 2, 69.71, 8.71, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (328, 'CA-2020-118640', 20200720, 20200726, 37, 48, 18, 4, 1, 8.79, -5.71, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (329, 'CA-2020-145233', 20201201, 20201205, 52, 444, 32, 4, 3, 470.38, 52.92, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (330, 'CA-2020-145233', 20201201, 20201205, 52, 407, 32, 4, 2, 105.58, 9.24, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (331, 'CA-2020-145233', 20201201, 20201205, 52, 93, 32, 4, 3, 31.15, 3.50, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (332, 'CA-2020-145233', 20201201, 20201205, 52, 190, 32, 4, 7, 6.78, -4.75, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (333, 'CA-2020-145233', 20201201, 20201205, 52, 409, 32, 4, 4, 406.37, 30.48, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (334, 'US-2019-156986', 20190320, 20190324, 206, 435, 106, 4, 2, 84.78, -20.14, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (335, 'US-2019-156986', 20190320, 20190324, 206, 277, 106, 4, 4, 20.74, 7.26, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (336, 'US-2019-156986', 20190320, 20190324, 206, 185, 106, 4, 3, 16.82, -12.90, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (337, 'US-2019-156986', 20190320, 20190324, 206, 305, 106, 4, 2, 10.37, 3.63, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (338, 'CA-2019-120200', 20190714, 20190716, 196, 364, 94, 1, 2, 11.63, 1.02, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (339, 'US-2019-100720', 20190716, 20190721, 32, 410, 94, 4, 3, 143.98, -28.80, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (340, 'US-2019-100720', 20190716, 20190721, 32, 437, 94, 4, 4, 494.38, -115.35, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (341, 'US-2019-100720', 20190716, 20190721, 32, 361, 94, 4, 2, 5.84, 0.73, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (342, 'CA-2019-161816', 20190428, 20190501, 136, 431, 29, 1, 3, 369.58, 41.58, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (343, 'CA-2019-161816', 20190428, 20190501, 136, 253, 29, 1, 4, 15.71, 5.70, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (344, 'CA-2019-121223', 20190911, 20190913, 67, 265, 94, 3, 2, 8.45, 2.64, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (345, 'CA-2019-121223', 20190911, 20190913, 67, 443, 94, 3, 9, 728.95, -157.94, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (346, 'CA-2020-138611', 20201114, 20201117, 33, 403, 51, 3, 10, 119.94, 15.99, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (347, 'CA-2020-138611', 20201114, 20201117, 33, 193, 51, 3, 2, 3.65, -2.80, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (348, 'CA-2020-117947', 20200818, 20200823, 138, 70, 87, 3, 2, 40.48, 15.79, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (349, 'CA-2020-117947', 20200818, 20200823, 138, 34, 87, 3, 2, 9.94, 3.08, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (350, 'CA-2020-117947', 20200818, 20200823, 138, 191, 87, 3, 9, 107.42, 33.57, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (351, 'CA-2020-117947', 20200818, 20200823, 138, 427, 87, 3, 1, 37.91, 10.99, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (352, 'CA-2020-117947', 20200818, 20200823, 138, 42, 87, 3, 3, 88.02, 27.29, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (353, 'CA-2020-163020', 20200915, 20200919, 131, 38, 87, 4, 7, 35.56, 12.09, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (354, 'CA-2020-153787', 20200519, 20200523, 15, 100, 114, 4, 2, 97.16, 28.18, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (355, 'CA-2020-133431', 20201217, 20201221, 114, 158, 110, 4, 5, 15.24, 5.14, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (356, 'CA-2020-133431', 20201217, 20201221, 114, 287, 110, 4, 3, 13.23, 6.09, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (357, 'US-2019-135720', 20191211, 20191213, 64, 339, 9, 3, 3, 243.38, -51.72, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (358, 'US-2019-135720', 20191211, 20191213, 64, 375, 9, 3, 5, 119.80, 29.95, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (359, 'US-2019-135720', 20191211, 20191213, 64, 420, 9, 3, 4, 300.77, 30.08, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (360, 'CA-2020-144694', 20200924, 20200926, 19, 388, 77, 3, 3, 17.88, 2.46, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (361, 'CA-2020-144694', 20200924, 20200926, 19, 251, 77, 3, 3, 235.94, 85.53, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (362, 'US-2019-123470', 20190815, 20190821, 127, 178, 9, 4, 3, 18.88, -13.85, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (363, 'US-2019-123470', 20190815, 20190821, 127, 110, 9, 4, 3, 122.33, 12.23, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (364, 'CA-2019-115917', 20190520, 20190525, 157, 43, 124, 4, 5, 1049.20, 272.79, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (365, 'CA-2019-115917', 20190520, 20190525, 157, 210, 124, 4, 4, 15.42, 5.01, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (366, 'CA-2019-147067', 20191218, 20191222, 84, 45, 78, 4, 3, 18.84, 6.03, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (367, 'CA-2020-167913', 20200730, 20200803, 96, 318, 79, 3, 2, 330.40, 85.90, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (368, 'CA-2020-167913', 20200730, 20200803, 96, 247, 79, 3, 7, 26.25, 12.60, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (369, 'CA-2020-106103', 20200610, 20200615, 172, 394, 102, 4, 4, 132.52, 54.33, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (370, 'US-2020-127719', 20200721, 20200725, 200, 273, 96, 4, 1, 6.48, 3.18, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (371, 'CA-2019-103947', 20190401, 20190408, 16, 235, 115, 4, 5, 31.56, 9.86, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (372, 'CA-2019-103947', 20190401, 20190408, 16, 103, 115, 4, 2, 30.14, 3.01, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (373, 'CA-2019-160745', 20191211, 20191216, 12, 54, 125, 3, 4, 14.80, 6.07, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (374, 'CA-2019-160745', 20191211, 20191216, 12, 432, 125, 3, 3, 302.38, 22.68, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (375, 'CA-2019-160745', 20191211, 20191216, 12, 374, 125, 3, 4, 316.00, 31.60, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (376, 'CA-2019-132661', 20191023, 20191029, 186, 262, 87, 4, 10, 379.40, 178.32, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (377, 'CA-2020-140844', 20200619, 20200623, 11, 301, 87, 4, 2, 97.82, 45.98, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (378, 'CA-2020-140844', 20200619, 20200623, 11, 373, 87, 4, 8, 103.12, 10.31, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (379, 'CA-2019-137239', 20190822, 20190828, 36, 104, 25, 4, 2, 113.55, 8.52, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (380, 'CA-2019-137239', 20190822, 20190828, 36, 192, 25, 4, 2, 3.32, -2.65, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (381, 'CA-2019-137239', 20190822, 20190828, 36, 220, 25, 4, 2, 134.29, 45.32, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (382, 'US-2019-156097', 20190919, 20190919, 58, 17, 10, 2, 2, 701.37, -50.10, DEFAULT, 0);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (383, 'US-2019-156097', 20190919, 20190919, 58, 209, 10, 2, 2, 2.31, -3.46, DEFAULT, 0);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (384, 'CA-2019-123666', 20190326, 20190330, 184, 336, 87, 4, 5, 459.95, 18.40, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (385, 'CA-2019-143308', 20191104, 20191104, 161, 229, 70, 2, 3, 10.74, 5.26, DEFAULT, 0);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (386, 'CA-2020-132682', 20200608, 20200610, 194, 365, 29, 3, 3, 23.76, 2.08, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (387, 'CA-2020-132682', 20200608, 20200610, 194, 261, 29, 3, 3, 85.06, 28.71, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (388, 'CA-2020-132682', 20200608, 20200610, 194, 439, 29, 3, 3, 381.58, 28.62, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (389, 'US-2020-106663', 20200609, 20200613, 131, 61, 18, 4, 3, 23.98, -14.39, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (390, 'US-2020-106663', 20200609, 20200613, 131, 79, 18, 4, 1, 108.93, -71.89, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (391, 'US-2020-106663', 20200609, 20200613, 131, 284, 18, 4, 8, 36.35, 11.36, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (392, 'CA-2020-111178', 20200615, 20200622, 193, 127, 98, 4, 5, 19.56, 1.71, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (393, 'CA-2020-130351', 20201205, 20201208, 158, 113, 24, 1, 3, 61.44, 16.59, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (394, 'CA-2020-130351', 20201205, 20201208, 158, 280, 24, 1, 5, 38.90, 17.51, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (395, 'CA-2020-130351', 20201205, 20201208, 158, 394, 24, 1, 3, 99.39, 40.75, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (396, 'US-2020-119438', 20200318, 20200323, 29, 95, 122, 4, 3, 2.69, -7.39, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (397, 'US-2020-119438', 20200318, 20200323, 29, 392, 122, 4, 3, 27.82, 4.52, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (398, 'US-2020-119438', 20200318, 20200323, 29, 66, 122, 4, 3, 82.52, -41.26, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (399, 'US-2020-119438', 20200318, 20200323, 29, 208, 122, 4, 3, 182.99, -320.24, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (400, 'CA-2019-164511', 20191119, 20191124, 44, 196, 87, 4, 3, 14.35, 4.66, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (401, 'CA-2019-164511', 20191119, 20191124, 44, 342, 87, 4, 2, 64.96, 2.60, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (402, 'CA-2019-164511', 20191119, 20191124, 44, 355, 87, 4, 4, 68.60, 18.52, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (403, 'US-2020-168116', 20201104, 20201104, 72, 401, 13, 2, 4, 7999.98, -3839.99, DEFAULT, 0);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (404, 'US-2020-168116', 20201104, 20201104, 72, 105, 13, 2, 2, 167.44, 14.65, DEFAULT, 0);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (405, 'CA-2020-161480', 20201225, 20201229, 154, 8, 87, 4, 2, 191.98, 4.80, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (406, 'CA-2020-114552', 20200902, 20200908, 47, 62, 20, 4, 3, 15.07, 4.14, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (407, 'CA-2019-163755', 20191104, 20191108, 14, 65, 114, 3, 3, 209.88, 35.68, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (408, 'CA-2020-146136', 20200903, 20200907, 10, 217, 91, 4, 4, 24.45, 8.86, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (409, 'US-2020-100048', 20200519, 20200524, 170, 98, 83, 4, 6, 281.34, 109.72, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (410, 'US-2020-100048', 20200519, 20200524, 170, 431, 83, 4, 2, 307.98, 89.31, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (411, 'US-2020-100048', 20200519, 20200524, 170, 376, 83, 4, 3, 299.97, 113.99, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (412, 'CA-2020-108910', 20200924, 20200929, 103, 57, 88, 4, 3, 103.06, 24.48, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (413, 'CA-2019-112942', 20190213, 20190218, 163, 304, 69, 4, 3, 146.82, 73.41, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (414, 'CA-2019-142335', 20191215, 20191219, 132, 78, 34, 4, 3, 1652.94, 231.41, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (415, 'CA-2019-142335', 20191215, 20191219, 132, 315, 34, 4, 3, 296.37, 80.02, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (416, 'CA-2019-114713', 20190707, 20190712, 173, 368, 55, 4, 7, 45.58, 5.13, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (417, 'CA-2020-144113', 20200916, 20200920, 88, 216, 11, 4, 2, 17.57, 6.37, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (418, 'CA-2020-144113', 20200916, 20200920, 88, 421, 11, 4, 1, 55.99, 5.60, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (419, 'US-2019-150861', 20191203, 20191206, 56, 275, 90, 1, 8, 182.72, 84.05, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (420, 'US-2019-150861', 20191203, 20191206, 56, 86, 90, 1, 2, 400.03, -153.35, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (421, 'US-2019-150861', 20191203, 20191206, 56, 356, 90, 1, 3, 33.63, 10.09, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (422, 'US-2019-150861', 20191203, 20191206, 56, 24, 90, 1, 3, 542.65, 102.50, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (423, 'US-2019-150861', 20191203, 20191206, 56, 244, 90, 1, 2, 6.30, 3.02, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (424, 'CA-2020-131954', 20200121, 20200125, 49, 325, 114, 4, 3, 242.94, 9.72, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (425, 'CA-2020-131954', 20200121, 20200125, 49, 391, 114, 4, 3, 179.97, 86.39, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (426, 'CA-2020-131954', 20200121, 20200125, 49, 202, 114, 4, 6, 99.70, 33.65, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (427, 'CA-2020-131954', 20200121, 20200125, 49, 195, 114, 4, 4, 27.94, 9.43, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (428, 'CA-2020-131954', 20200121, 20200125, 49, 2, 114, 4, 1, 84.98, 18.70, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (429, 'CA-2020-131954', 20200121, 20200125, 49, 151, 114, 4, 5, 18.72, 6.55, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (430, 'US-2019-146710', 20190827, 20190901, 189, 367, 29, 4, 5, 51.52, -10.95, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (431, 'US-2019-146710', 20190827, 20190901, 189, 287, 29, 4, 1, 3.53, 1.15, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (432, 'US-2019-146710', 20190827, 20190901, 189, 314, 29, 4, 1, 4.62, 1.68, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (433, 'US-2019-146710', 20190827, 20190901, 189, 366, 29, 4, 4, 55.17, 6.21, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (434, 'CA-2019-150889', 20190320, 20190322, 143, 402, 38, 3, 1, 11.99, 0.90, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (435, 'CA-2020-126074', 20201002, 20201006, 165, 198, 119, 4, 3, 58.05, 26.70, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (436, 'CA-2020-126074', 20201002, 20201006, 165, 67, 119, 4, 11, 157.74, 56.79, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (437, 'CA-2020-126074', 20201002, 20201006, 165, 137, 119, 4, 7, 56.98, 22.79, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (438, 'CA-2020-126074', 20201002, 20201006, 165, 157, 119, 4, 1, 2.88, 1.41, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (439, 'CA-2019-110499', 20190407, 20190409, 205, 396, 110, 1, 3, 1199.98, 374.99, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (440, 'CA-2019-140928', 20190918, 20190922, 136, 80, 62, 4, 4, 383.44, -167.32, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (441, 'CA-2020-117240', 20200723, 20200728, 35, 161, 87, 4, 3, 13.13, 4.27, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (442, 'CA-2020-133333', 20200918, 20200922, 20, 284, 50, 4, 4, 22.72, 10.22, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (443, 'CA-2020-126046', 20201103, 20201107, 82, 254, 7, 4, 3, 12.39, 5.70, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (444, 'CA-2019-157245', 20190519, 20190524, 115, 28, 4, 4, 2, 641.96, 179.75, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (445, 'CA-2020-104220', 20200130, 20200205, 23, 162, 33, 4, 2, 18.28, 9.14, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (446, 'CA-2020-104220', 20200130, 20200205, 23, 442, 33, 4, 3, 207.00, 51.75, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (447, 'CA-2020-104220', 20200130, 20200205, 23, 152, 33, 4, 5, 32.35, 16.18, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (448, 'CA-2020-104220', 20200130, 20200205, 23, 200, 33, 4, 1, 7.71, 3.47, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (449, 'CA-2020-104220', 20200130, 20200205, 23, 144, 33, 4, 2, 40.30, 10.88, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (450, 'CA-2020-104220', 20200130, 20200205, 23, 59, 33, 4, 7, 34.58, 14.52, DEFAULT, 6);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (451, 'CA-2020-129567', 20200317, 20200321, 34, 148, 65, 3, 2, 17.46, 5.89, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (452, 'CA-2019-105256', 20190520, 20190520, 93, 413, 6, 2, 5, 1363.96, 85.25, DEFAULT, 0);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (453, 'CA-2020-151428', 20200921, 20200926, 167, 157, 101, 4, 7, 20.16, 9.88, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (454, 'CA-2020-105809', 20200220, 20200223, 78, 73, 109, 1, 1, 22.23, 7.34, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (455, 'CA-2020-105809', 20200220, 20200223, 78, 415, 109, 1, 2, 215.97, 18.90, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (456, 'CA-2019-136133', 20190818, 20190823, 78, 94, 87, 3, 9, 355.32, 99.49, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (457, 'CA-2019-115504', 20190312, 20190317, 126, 302, 80, 4, 2, 12.96, 6.22, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (458, 'CA-2020-135783', 20200422, 20200424, 70, 46, 110, 1, 2, 18.28, 6.22, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (459, 'CA-2020-143686', 20200514, 20200514, 147, 46, 111, 2, 2, 18.28, 6.22, DEFAULT, 0);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (460, 'CA-2020-143686', 20200514, 20200514, 147, 380, 111, 2, 7, 1399.93, 601.97, DEFAULT, 0);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (461, 'CA-2019-149370', 20190915, 20190919, 42, 298, 94, 4, 1, 5.34, 1.87, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (462, 'CA-2020-101434', 20200620, 20200627, 197, 387, 12, 4, 3, 239.97, 71.99, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (463, 'CA-2020-101434', 20200620, 20200627, 197, 248, 12, 4, 2, 9.82, 4.81, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (464, 'CA-2020-126956', 20200821, 20200828, 73, 231, 64, 4, 7, 35.00, 16.80, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (465, 'CA-2020-126956', 20200821, 20200828, 73, 357, 64, 4, 4, 37.24, 10.80, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (466, 'CA-2020-126956', 20200821, 20200828, 73, 225, 64, 4, 2, 15.28, 7.49, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (467, 'CA-2020-129462', 20200616, 20200621, 86, 13, 40, 3, 2, 301.96, 90.59, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (468, 'CA-2020-129462', 20200616, 20200621, 86, 111, 40, 3, 3, 180.66, 50.58, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (469, 'CA-2020-129462', 20200616, 20200621, 86, 414, 40, 3, 2, 191.98, 51.83, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (470, 'CA-2020-129462', 20200616, 20200621, 86, 419, 40, 3, 1, 65.99, 17.16, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (471, 'CA-2019-165316', 20190723, 20190727, 80, 132, 118, 4, 2, 35.22, 2.64, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (472, 'CA-2019-165316', 20190723, 20190727, 80, 109, 118, 4, 2, 23.70, 6.52, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (473, 'CA-2019-165316', 20190723, 20190727, 80, 400, 118, 4, 1, 265.48, -111.50, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (474, 'US-2020-156083', 20201104, 20201111, 94, 266, 22, 4, 2, 9.66, 3.26, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (475, 'US-2019-137547', 20190307, 20190312, 54, 424, 41, 4, 3, 21.07, 1.58, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (476, 'CA-2019-161669', 20191107, 20191109, 59, 165, 69, 1, 4, 37.44, 11.70, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (477, 'CA-2019-161669', 20191107, 20191109, 59, 170, 69, 1, 4, 26.98, 8.77, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (478, 'CA-2019-161669', 20191107, 20191109, 59, 362, 69, 1, 2, 11.36, 3.29, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (479, 'CA-2019-161669', 20191107, 20191109, 59, 252, 69, 1, 2, 14.62, 6.87, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (480, 'CA-2020-107503', 20200101, 20200106, 66, 71, 68, 4, 4, 48.90, 8.56, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (481, 'CA-2019-152534', 20190620, 20190625, 48, 129, 107, 3, 2, 5.16, 1.34, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (482, 'CA-2019-152534', 20190620, 20190625, 48, 272, 107, 3, 6, 38.88, 18.66, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (483, 'CA-2019-113747', 20190528, 20190604, 202, 135, 61, 4, 6, 185.88, 50.19, DEFAULT, 7);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (484, 'CA-2019-123274', 20190219, 20190224, 73, 73, 87, 4, 2, 44.46, 14.67, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (485, 'CA-2019-123274', 20190219, 20190224, 73, 325, 87, 4, 3, 242.94, 9.72, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (486, 'CA-2020-161984', 20200410, 20200415, 181, 311, 86, 4, 1, 7.61, 3.58, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (487, 'CA-2020-161984', 20200410, 20200415, 181, 230, 86, 4, 2, 7.16, 3.58, DEFAULT, 5);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (488, 'CA-2019-134474', 20190105, 20190107, 8, 377, 62, 3, 6, 191.47, 40.69, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (489, 'CA-2019-134474', 20190105, 20190107, 8, 141, 62, 3, 2, 5.25, 0.59, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (490, 'CA-2019-134474', 20190105, 20190107, 8, 430, 62, 3, 2, 59.18, 5.18, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (491, 'CA-2019-134362', 20190929, 20191002, 120, 256, 94, 1, 4, 15.94, 5.18, DEFAULT, 3);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (492, 'CA-2019-158099', 20190903, 20190905, 148, 156, 94, 1, 5, 1141.47, -760.98, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (493, 'CA-2019-158099', 20190903, 20190905, 148, 426, 94, 1, 3, 280.78, -46.80, DEFAULT, 2);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (494, 'CA-2020-114636', 20200825, 20200829, 66, 270, 17, 4, 5, 192.16, 67.26, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (495, 'CA-2019-116736', 20190117, 20190121, 26, 72, 26, 4, 3, 322.59, 64.52, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (496, 'CA-2019-116736', 20190117, 20190121, 26, 393, 26, 4, 1, 29.99, 13.20, DEFAULT, 4);
INSERT INTO public.fact_sales OVERRIDING SYSTEM VALUE VALUES (497, 'CA-2019-116736', 20190117, 20190121, 26, 384, 26, 4, 3, 371.97, 66.95, DEFAULT, 4);


--
-- Name: dim_customer_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dim_customer_customer_id_seq', 206, true);


--
-- Name: dim_location_location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dim_location_location_id_seq', 129, true);


--
-- Name: dim_product_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dim_product_product_id_seq', 444, true);


--
-- Name: dim_ship_mode_ship_mode_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dim_ship_mode_ship_mode_id_seq', 4, true);


--
-- Name: fact_sales_sale_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fact_sales_sale_id_seq', 497, true);


--
-- Name: dim_customer dim_customer_customer_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_customer
    ADD CONSTRAINT dim_customer_customer_code_key UNIQUE (customer_code);


--
-- Name: dim_customer dim_customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_customer
    ADD CONSTRAINT dim_customer_pkey PRIMARY KEY (customer_id);


--
-- Name: dim_date dim_date_full_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_date
    ADD CONSTRAINT dim_date_full_date_key UNIQUE (full_date);


--
-- Name: dim_date dim_date_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_date
    ADD CONSTRAINT dim_date_pkey PRIMARY KEY (date_id);


--
-- Name: dim_location dim_location_city_name_state_name_region_name_country_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_location
    ADD CONSTRAINT dim_location_city_name_state_name_region_name_country_name_key UNIQUE (city_name, state_name, region_name, country_name);


--
-- Name: dim_location dim_location_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_location
    ADD CONSTRAINT dim_location_pkey PRIMARY KEY (location_id);


--
-- Name: dim_product dim_product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_product
    ADD CONSTRAINT dim_product_pkey PRIMARY KEY (product_id);


--
-- Name: dim_product dim_product_product_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_product
    ADD CONSTRAINT dim_product_product_code_key UNIQUE (product_code);


--
-- Name: dim_ship_mode dim_ship_mode_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_ship_mode
    ADD CONSTRAINT dim_ship_mode_pkey PRIMARY KEY (ship_mode_id);


--
-- Name: dim_ship_mode dim_ship_mode_ship_mode_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_ship_mode
    ADD CONSTRAINT dim_ship_mode_ship_mode_name_key UNIQUE (ship_mode_name);


--
-- Name: fact_sales fact_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_sales
    ADD CONSTRAINT fact_sales_pkey PRIMARY KEY (sale_id);


--
-- Name: fact_sales fact_sales_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_sales
    ADD CONSTRAINT fact_sales_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.dim_customer(customer_id);


--
-- Name: fact_sales fact_sales_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_sales
    ADD CONSTRAINT fact_sales_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.dim_location(location_id);


--
-- Name: fact_sales fact_sales_order_date_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_sales
    ADD CONSTRAINT fact_sales_order_date_id_fkey FOREIGN KEY (order_date_id) REFERENCES public.dim_date(date_id);


--
-- Name: fact_sales fact_sales_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_sales
    ADD CONSTRAINT fact_sales_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.dim_product(product_id);


--
-- Name: fact_sales fact_sales_ship_date_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_sales
    ADD CONSTRAINT fact_sales_ship_date_id_fkey FOREIGN KEY (ship_date_id) REFERENCES public.dim_date(date_id);


--
-- Name: fact_sales fact_sales_ship_mode_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_sales
    ADD CONSTRAINT fact_sales_ship_mode_id_fkey FOREIGN KEY (ship_mode_id) REFERENCES public.dim_ship_mode(ship_mode_id);


--
-- PostgreSQL database dump complete
--

\unrestrict CeiPnqgpF9Q8kh7PmaHx0UjPtgb8nWM4KqC9QeNQvWY2l6hp8SvCt9fh1Wo7bFf

