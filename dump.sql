--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0 (Debian 17.0-1.pgdg120+1)
-- Dumped by pg_dump version 17.0 (Debian 17.0-1.pgdg120+1)

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

--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: clustertype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.clustertype AS ENUM (
    'Major Cluster',
    'Additional Cluster',
    'Supporting Cluster',
    'None',
    'Widely Applicable Prerequisite'
);


ALTER TYPE public.clustertype OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: childstandards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.childstandards (
    childstandardid integer NOT NULL,
    parentstandardid integer,
    childstandardcode character varying(100) NOT NULL,
    childstandarddescription text NOT NULL
);


ALTER TABLE public.childstandards OWNER TO postgres;

--
-- Name: childstandards_childstandardid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.childstandards_childstandardid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.childstandards_childstandardid_seq OWNER TO postgres;

--
-- Name: childstandards_childstandardid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.childstandards_childstandardid_seq OWNED BY public.childstandards.childstandardid;


--
-- Name: clusters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clusters (
    clusterid integer NOT NULL,
    domainid integer,
    clustername text NOT NULL,
    clustertype public.clustertype
);


ALTER TABLE public.clusters OWNER TO postgres;

--
-- Name: clusters_clusterid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clusters_clusterid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clusters_clusterid_seq OWNER TO postgres;

--
-- Name: clusters_clusterid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clusters_clusterid_seq OWNED BY public.clusters.clusterid;


--
-- Name: domains; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.domains (
    domainid integer NOT NULL,
    gradeid integer,
    domain_abb text NOT NULL,
    domainname character varying(100) NOT NULL
);


ALTER TABLE public.domains OWNER TO postgres;

--
-- Name: domains_domainid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.domains_domainid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.domains_domainid_seq OWNER TO postgres;

--
-- Name: domains_domainid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.domains_domainid_seq OWNED BY public.domains.domainid;


--
-- Name: grades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grades (
    gradeid integer NOT NULL,
    gradename character varying(50) NOT NULL
);


ALTER TABLE public.grades OWNER TO postgres;

--
-- Name: grades_gradeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grades_gradeid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.grades_gradeid_seq OWNER TO postgres;

--
-- Name: grades_gradeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grades_gradeid_seq OWNED BY public.grades.gradeid;


--
-- Name: standarddependencies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.standarddependencies (
    standardid integer NOT NULL,
    prerequisitestandardid integer NOT NULL
);


ALTER TABLE public.standarddependencies OWNER TO postgres;

--
-- Name: standards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.standards (
    standardid integer NOT NULL,
    clusterid integer,
    standardcode character varying(100) NOT NULL,
    standarddescription text NOT NULL,
    stadid integer
);


ALTER TABLE public.standards OWNER TO postgres;

--
-- Name: standards_standardid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.standards_standardid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.standards_standardid_seq OWNER TO postgres;

--
-- Name: standards_standardid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.standards_standardid_seq OWNED BY public.standards.standardid;


--
-- Name: tempmatching; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tempmatching (
    tabid integer NOT NULL,
    stadid integer,
    standcode character varying(15)
);


ALTER TABLE public.tempmatching OWNER TO postgres;

--
-- Name: tempmatching_tabid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tempmatching_tabid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tempmatching_tabid_seq OWNER TO postgres;

--
-- Name: tempmatching_tabid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tempmatching_tabid_seq OWNED BY public.tempmatching.tabid;


--
-- Name: childstandards childstandardid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.childstandards ALTER COLUMN childstandardid SET DEFAULT nextval('public.childstandards_childstandardid_seq'::regclass);


--
-- Name: clusters clusterid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clusters ALTER COLUMN clusterid SET DEFAULT nextval('public.clusters_clusterid_seq'::regclass);


--
-- Name: domains domainid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.domains ALTER COLUMN domainid SET DEFAULT nextval('public.domains_domainid_seq'::regclass);


--
-- Name: grades gradeid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades ALTER COLUMN gradeid SET DEFAULT nextval('public.grades_gradeid_seq'::regclass);


--
-- Name: standards standardid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.standards ALTER COLUMN standardid SET DEFAULT nextval('public.standards_standardid_seq'::regclass);


--
-- Name: tempmatching tabid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tempmatching ALTER COLUMN tabid SET DEFAULT nextval('public.tempmatching_tabid_seq'::regclass);


--
-- Data for Name: childstandards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.childstandards (childstandardid, parentstandardid, childstandardcode, childstandarddescription) FROM stdin;
1	9	1.NBT.B.2.a	10 can be thought of as a bundle of ten ones — called a “ten.” b.
2	9	1.NBT.B.2.b	The numbers from 11 to 19 are composed of a ten and one, two, three, four, five, six, seven, eight, or nine ones.
3	9	1.NBT.B.2.c	The numbers 10, 20, 30, 40, 50, 60, 70, 80, 90 refer to one, two, three, four, five, six, seven, eight, or nine tens (and 0 ones).
4	35	2.NBT.A.1.a	100 can be thought of as a bundle of ten tens — called a “hundred.”
5	35	2.NBT.A.1.b	The numbers 100, 200, 300, 400, 500, 600, 700, 800, 900 refer to one, two, three, four, five, six, seven, eight, or nine hundreds (and 0 tens and 0 ones).
6	54	3.MD.C.5.a	A square with side length 1 unit, called “a unit square,” is said to have “one square unit” of area, and can be used to measure area.
7	54	3.MD.C.5.b	A plane figure which can be covered without gaps or overlaps by n unit squares is said to have an area of n square units.
8	56	3.MD.C.7.a	Find the area of a rectangle with whole-number side lengths by tiling it, and show that the area is the same as would be found by multiplying the side lengths.
9	56	3.MD.C.7.b	Multiply side lengths to find areas of rectangles with whole- number side lengths in the context of solving real world and mathematical problems, and represent whole-number products as rectangular areas in mathematical reasoning.
10	56	3.MD.C.7.c	Use tiling to show in a concrete case that the area of a rectangle with whole-number side lengths a and b + c is the sum of a × b and a × c. Use area models to represent the distributive property in mathematical reasoning.
11	56	3.MD.C.7.d	Recognize area as additive. Find areas of rectilinear figures by decomposing them into non-overlapping rectangles and adding the areas of the non-overlapping parts, applying this technique to solve real world problems.
12	62	3.NF.A.2.a	Represent a fraction 1/b on a number line diagram by defining the interval from 0 to 1 as the whole and partitioning it into b equal parts. Recognize that each part has size 1/b and that the endpoint of the part based at 0 locates the number 1/b on the number line.
13	62	3.NF.A.2.b	Represent a fraction a/b on a number line diagram by marking off a lengths 1/b from 0. Recognize that the resulting interval has size a/b and that its endpoint locates the number a/b on the number line.
14	63	3.NF.A.3.a	Understand two fractions as equivalent (equal) if they are the same size, or the same point on a number line.
15	63	3.NF.A.3.b	Recognize and generate simple equivalent fractions, e.g., 1/2 = 2/4, 4/6 = 2/3). Explain why the fractions are equivalent, e.g., by using a visual fraction model.
16	63	3.NF.A.3.c	Express whole numbers as fractions, and recognize fractions that are equivalent to whole numbers. Examples: Express 3 in the form 3 = 3/1; recognize that 6/1 = 6; locate 4/4 and 1 at the same point of a number line diagram.
17	63	3.NF.A.3.d	Compare two fractions with the same numerator or the same denominator by reasoning about their size. Recognize that comparisons are valid only when the two fractions refer to the same whole. Record the results of comparisons with the symbols >, =, or <, and justify the conclusions, e.g., by using a visual fraction model.
18	80	4.MD.C.5.a	An angle is measured with reference to a circle with its center at the common endpoint of the rays, by considering the fraction of the circular arc between the points where the two rays intersect the circle. An angle that turns through 1/360 of a circle is called a “one-degree angle,” and can be used to measure angles.
19	80	4.MD.C.5.b	An angle that turns through n one-degree angles is said to have an angle measure of n degrees.
20	91	4.NF.B.3.a	Understand addition and subtraction of fractions as joining and separating parts referring to the same whole.
21	91	4.NF.B.3.b	Decompose a fraction into a sum of fractions with the same denominator in more than one way, recording each decomposition by an equation. Justify decompositions, e.g., by using a visual fraction model. Examples: 3/8 = 1/8 + 1/8 + 1/8 ; 3/8 = 1/8 + 2/8 ; 2 1/8 = 1 + 1 + 1/8 = 8/8 + 8/8 + 1/8.
22	91	4.NF.B.3.c	Add and subtract mixed numbers with like denominators, e.g., by replacing each mixed number with an equivalent fraction, and/or by using properties of operations and the relationship between addition and subtraction.
23	91	4.NF.B.3.d	Solve word problems involving addition and subtraction of fractions referring to the same whole and having like denominators, e.g., by using visual fraction models and equations to represent the problem.
24	92	4.NF.B.4.a	Understand a fraction a/b as a multiple of 1/b. For example, use a visual fraction model to represent 5/4 as the product 5 × (1/4), recording the conclusion by the equation 5/4 = 5 × (1/4).
25	92	4.NF.B.4.b	Understand a multiple of a/b as a multiple of 1/b, and use this understanding to multiply a fraction by a whole number. For example, use a visual fraction model to express 3 × (2/5) as 6 × (1/5), recognizing this product as 6/5. (In general, n × (a/b) = (n × a)/b.)
26	92	4.NF.B.4.c	Solve word problems involving multiplication of a fraction by a whole number, e.g., by using visual fraction models and equations to represent the problem. For example, if each person at a party will eat 3/8 of a pound of roast beef, and there will be 5 people at the party, how many pounds of roast beef will be needed? Between what two whole numbers does your answer lie?
27	107	5.MD.C.3.a	A cube with side length 1 unit, called a “unit cube,” is said to have “one cubic unit” of volume, and can be used to measure volume.
28	107	5.MD.C.3.b	A solid figure which can be packed without gaps or overlaps using n unit cubes is said to have a volume of n cubic units.
29	109	5.MD.C.5.a	Find the volume of a right rectangular prism with whole-number side lengths by packing it with unit cubes, and show that the volume is the same as would be found by multiplying the edge lengths, equivalently by multiplying the height by the area of the base. Represent threefold whole-number products as volumes, e.g., to represent the associative property of multiplication.
30	109	5.MD.C.5.b	Apply the formulas V=l×w×handV=b×h for rectangular prisms to find volumes of right rectangular prisms with whole- number edge lengths in the context of solving real world and mathematical problems.
31	109	5.MD.C.5.c	Recognize volume as additive. Find volumes of solid figures composed of two non-overlapping right rectangular prisms by adding the volumes of the non-overlapping parts, applying this technique to solve real world problems.
32	112	5.NBT.A.3.a	Read and write decimals to thousandths using base-ten numerals, number names, and expanded form, e.g., 347.392 = 3 × 100 + 4 × 10 + 7 × 1 + 3 × (1/10) + 9 × (1/100) + 2 × (1/1000).
33	112	5.NBT.A.3.b	Compare two decimals to thousandths based on meanings of the digits in each place, using >, =, and < symbols to record the results of comparisons.
34	120	5.NF.B.4.a	Interpret the product (a/b) × q as a parts of a partition of q into b equal parts; equivalently, as the result of a sequence of operations a × q ÷ b. For example, use a visual fraction model to show (2/3) × 4 = 8/3, and create a story context for this equation. Do the same with (2/3) × (4/5) = 8/15. (In general, (a/b) × (c/d) = ac/bd.)
35	120	5.NF.B.4.b	Find the area of a rectangle with fractional side lengths by tiling it with unit squares of the appropriate unit fraction side lengths, and show that the area is the same as would be found by multiplying the side lengths. Multiply fractional side lengths to find areas of rectangles, and represent fraction products as rectangular areas.
36	121	5.NF.B.5.a	Comparing the size of a product to the size of one factor on the basis of the size of the other factor, without performing the indicated multiplication.
37	121	5.NF.B.5.b	Explaining why multiplying a given number by a fraction greater than 1 results in a product greater than the given number (recognizing multiplication by whole numbers greater than 1 as a familiar case); explaining why multiplying a given number by a fraction less than 1 results in a product smaller than the given number; and relating the principle of fraction equivalence a/b = (n×a)/(n×b) to the effect of multiplying a/b by 1.
38	123	5.NF.B.7.a	Interpret division of a unit fraction by a non-zero whole number, and compute such quotients. For example, create a story context for (1/3) ÷ 4, and use a visual fraction model to show the quotient. Use the relationship between multiplication and division to explain that (1/3) ÷ 4 = 1/12 because (1/12) × 4 = 1/3.
39	123	5.NF.B.7.b	Interpret division of a whole number by a unit fraction, and compute such quotients. For example, create a story context for 4 ÷ (1/5), and use a visual fraction model to show the quotient. Use the relationship between multiplication and division to explain that 4 ÷ (1/5) = 20 because 20 × (1/5) = 4.
40	123	5.NF.B.7.c	Solve real world problems involving division of unit fractions by non-zero whole numbers and division of whole numbers by unit fractions, e.g., by using visual fraction models and equations to represent the problem. For example, how much chocolate will each person get if 3 people share 1/2 lb of chocolate equally? How many 1/3-cup servings are in 2 cups of raisins?
41	128	6.EE.A.2.a	Write expressions that record operations with numbers and with letters standing for numbers. For example, express the calculation “Subtract y from 5” as 5 – y.
42	128	6.EE.A.2.b	Identify parts of an expression using mathematical terms (sum, term, product, factor, quotient, coefficient); view one or more parts of an expression as a single entity. For example, describe the expression 2 (8 + 7) as a product of two factors; view (8 + 7) as both a single entity and a sum of two terms.
43	128	6.EE.A.2.c	Evaluate expressions at specific values of their variables. Include expressions that arise from formulas used in real-world problems. Perform arithmetic operations, including those involving whole- number exponents, in the conventional order when there are no parentheses to specify a particular order (Order of Operations). For example, use the formulas V = s3 and A = 6 s2 to find the volume and surface area of a cube with sides of length s = 1/2.
44	145	6.NS.C.6.a	Recognize opposite signs of numbers as indicating locations on opposite sides of 0 on the number line; recognize that the opposite of the opposite of a number is the number itself, e.g., –(–3) = 3, and that 0 is its own opposite.
45	145	6.NS.C.6.b	Understand signs of numbers in ordered pairs as indicating locations in quadrants of the coordinate plane; recognize that when two ordered pairs differ only by signs, the locations of the points are related by reflections across one or both axes.
46	145	6.NS.C.6.c	Find and position integers and other rational numbers on a horizontal or vertical number line diagram; find and position pairs of integers and other rational numbers on a coordinate plane.
47	146	6.NS.C.7.a	Interpret statements of inequality as statements about the relative position of two numbers on a number line diagram. For example, interpret –3 > –7 as a statement that –3 is located to the right of –7 on a number line oriented from left to right.
48	146	6.NS.C.7.b	Write, interpret, and explain statements of order for rational numbers in real-world contexts. For example, write –3 oC > –7 oC to express the fact that –3 oC is warmer than –7 oC.
49	146	6.NS.C.7.c	Understand the absolute value of a rational number as its distance from 0 on the number line; interpret absolute value as magnitude for a positive or negative quantity in a real-world situation. For example, for an account balance of –30 dollars, write |–30| = 30 to describe the size of the debt in dollars.
50	146	6.NS.C.7.d	Distinguish comparisons of absolute value from statements about order. For example, recognize that an account balance less than –30 dollars represents a debt greater than 30 dollars.
51	150	6.RP.A.3.a	Make tables of equivalent ratios relating quantities with whole- number measurements, find missing values in the tables, and plot the pairs of values on the coordinate plane. Use tables to compare ratios.
52	150	6.RP.A.3.b	Solve unit rate problems including those involving unit pricing and constant speed. For example, if it took 7 hours to mow 4 lawns, then at that rate, how many lawns could be mowed in 35 hours? At what rate were lawns being mowed?
53	150	6.RP.A.3.c	Find a percent of a quantity as a rate per 100 (e.g., 30% of a quantity means 30/100 times the quantity); solve problems involving finding the whole, given a part and the percent.
54	150	6.RP.A.3.d	Use ratio reasoning to convert measurement units; manipulate and transform units appropriately when multiplying or dividing quantities.
55	155	6.SP.B.5.a	Reporting the number of observations.
56	155	6.SP.B.5.b	Describing the nature of the attribute under investigation, including how it was measured and its units of measurement.
57	155	6.SP.B.5.c	Giving quantitative measures of center (median and/or mean) and variability (interquartile range and/or mean absolute deviation), as well as describing any overall pattern and any striking deviations from the overall pattern with reference to the context in which the data were gathered.
58	155	6.SP.B.5.d	Relating the choice of measures of center and variability to the shape of the data distribution and the context in which the data were gathered.
59	159	7.EE.B.4.a	Solve word problems leading to equations of the form px + q = r and p(x + q) = r, where p, q, and r are specific rational numbers. Solve equations of these forms fluently. Compare an algebraic solution to an arithmetic solution, identifying the sequence of the operations used in each approach. For example, the perimeter of a rectangle is 54 cm. Its length is 6 cm. What is its width?
60	159	7.EE.B.4.b	Solve word problems leading to inequalities of the form px + q > r or px + q < r, where p, q, and r are specific rational numbers. Graph the solution set of the inequality and interpret it in the context of the problem. For example: As a salesperson, you are paid $50 per week plus $3 per sale. This week you want your pay to be at least $100. Write an inequality for the number of sales you need to make, and describe the solutions.
61	166	7.NS.A.1.a	Describe situations in which opposite quantities combine to make 0. For example, a hydrogen atom has 0 charge because its two constituents are oppositely charged.
62	166	7.NS.A.1.b	Understand p + q as the number located a distance |q| from p, in the positive or negative direction depending on whether q is positive or negative. Show that a number and its opposite have a sum of 0 (are additive inverses). Interpret sums of rational numbers by describing real-world contexts.
63	166	7.NS.A.1.c	Understand subtraction of rational numbers as adding the additive inverse, p – q = p + (–q). Show that the distance between two rational numbers on the number line is the absolute value of their difference, and apply this principle in real-world contexts.
64	166	7.NS.A.1.d	Apply properties of operations as strategies to add and subtract rational numbers.
65	167	7.NS.A.2.a	Understand that multiplication is extended from fractions to rational numbers by requiring that operations continue to satisfy the properties of operations, particularly the distributive property, leading to products such as (–1)(–1) = 1 and the rules for multiplying signed numbers. Interpret products of rational numbers by describing real-world contexts.
66	167	7.NS.A.2.b	Understand that integers can be divided, provided that the divisor is not zero, and every quotient of integers (with non-zero divisor) is a rational number. If p and q are integers, then –(p/q) = (–p)/q = p/(–q). Interpret quotients of rational numbers by describing real- world contexts.
67	167	7.NS.A.2.c	Apply properties of operations as strategies to multiply and divide rational numbers.
68	167	7.NS.A.2.d	Convert a rational number to a decimal using long division; know that the decimal form of a rational number terminates in 0s or eventually repeats.
69	170	7.RP.A.2.a	Decide whether two quantities are in a proportional relationship, e.g., by testing for equivalent ratios in a table or graphing on a coordinate plane and observing whether the graph is a straight line through the origin.
70	170	7.RP.A.2.b	Identify the constant of proportionality (unit rate) in tables, graphs, equations, diagrams, and verbal descriptions of proportional relationships.
71	170	7.RP.A.2.c	Represent proportional relationships by equations. For example, if total cost t is proportional to the number n of items purchased at a constant price p, the relationship between the total cost and the number of items can be expressed as t = pn.
72	170	7.RP.A.2.d	Explain what a point (x, y) on the graph of a proportional relationship means in terms of the situation, with special attention to the points (0, 0) and (1, r) where r is the unit rate.
73	178	7.SP.C.7.a	Develop a uniform probability model by assigning equal probability to all outcomes, and use the model to determine probabilities of events. For example, if a student is selected at random from a class, find the probability that Jane will be selected and the probability that a girl will be selected.
74	178	7.SP.C.7.b	Develop a probability model (which may not be uniform) by observing frequencies in data generated from a chance process. For example, find the approximate probability that a spinning penny will land heads up or that a tossed paper cup will land open-end down. Do the outcomes for the spinning penny appear to be equally likely based on the observed frequencies?
75	179	7.SP.C.8.a	Understand that, just as with simple events, the probability of a compound event is the fraction of outcomes in the sample space for which the compound event occurs.
76	179	7.SP.C.8.b	Represent sample spaces for compound events using methods such as organized lists, tables and tree diagrams. For an event described in everyday language (e.g., “rolling double sixes”), identify the outcomes in the sample space which compose the event.
77	179	7.SP.C.8.c	Design and use a simulation to generate frequencies for compound events. For example, use random digits as a simulation tool to approximate the answer to the question: If 40% of donors have type A blood, what is the probability that it will take at least 4 donors to find one with type A blood?
78	186	8.EE.C.7.a	Give examples of linear equations in one variable with one solution, infinitely many solutions, or no solutions. Show which of these possibilities is the case by successively transforming the given equation into simpler forms, until an equivalent equation of the form x = a, a = a, or a = b results (where a and b are different numbers).
79	186	8.EE.C.7.b	Solve linear equations with rational number coefficients, including equations whose solutions require expanding expressions using the distributive property and collecting like terms.
80	187	8.EE.C.8.a	Understand that solutions to a system of two linear equations in two variables correspond to points of intersection of their graphs, because points of intersection satisfy both equations simultaneously.
81	187	8.EE.C.8.b	Solve systems of two linear equations in two variables algebraically, and estimate solutions by graphing the equations. Solve simple cases by inspection. For example, 3x + 2y = 5 and 3x + 2y = 6 have no solution because 3x + 2y cannot simultaneously be 5 and 6.
82	187	8.EE.C.8.c	Solve real-world and mathematical problems leading to two linear equations in two variables. For example, given coordinates for two pairs of points, determine whether the line through the first pair of points intersects the line through the second pair.
83	193	8.G.A.1.a	Lines are taken to lines, and line segments to line segments of the same length.
84	193	8.G.A.1.b	Angles are taken to angles of the same measure.
85	193	8.G.A.1.c	Parallel lines are taken to parallel lines.
86	211	K.CC.B.4.a	When counting objects, say the number names in the standard order, pairing each object with one and only one number name and each number name with one and only one object.
87	211	K.CC.B.4.b	Understand that the last number name said tells the number of objects counted. The number of objects is the same regardless of their arrangement or the order in which they were counted.
88	211	K.CC.B.4.c	Understand that each successive number name refers to a quantity that is one larger.
\.


--
-- Data for Name: clusters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clusters (clusterid, domainid, clustername, clustertype) FROM stdin;
1	9	Reason With Shapes And Their Attributes.	Additional Cluster
2	8	Measure Lengths Indirectly And By Iterating Length Units.	Major Cluster
3	8	Tell And Write Time.	Additional Cluster
4	8	Represent And Interpret Data.	Supporting Cluster
5	7	Extend The Counting Sequence.	Major Cluster
6	7	Understand Place Value.	Major Cluster
7	7	Use Place Value Understanding And Properties Of Operations To Add And Subtract.	Major Cluster
8	6	Represent And Solve Problems Involving Addition And Subtraction.	Major Cluster
9	6	Understand And Apply Properties Of Operations And The Relationship Between Addition And Subtraction.	Major Cluster
10	6	Add And Subtract Within 20.	Major Cluster
11	6	Work With Addition And Subtraction Equations.	Major Cluster
12	13	Reason With Shapes And Their Attributes.	Additional Cluster
13	12	Measure And Estimate Lengths In Standard Units.	Major Cluster
14	12	Relate Addition And Subtraction To Length.	Major Cluster
15	12	Work With Time And Money.	Supporting Cluster
16	12	Represent And Interpret Data.	Supporting Cluster
17	11	Understand Place Value.	Major Cluster
18	11	Use Place Value Understanding And Properties Of Operations To Add And Subtract.	Major Cluster
19	10	Represent And Solve Problems Involving Addition And Subtraction.	Major Cluster
20	10	Add And Subtract Within 20.	Major Cluster
21	10	Work With Equal Groups Of Objects To Gain Foundations For Multiplication.	Supporting Cluster
22	18	Reason With Shapes And Their Attributes.	Supporting Cluster
23	17	Solve Problems Involving Measurement And Estimation Of Intervals Of Time, Liquid Volumes, And Masses Of Objects.	Major Cluster
24	17	Represent And Interpret Data.	Supporting Cluster
25	17	Geometric Measurement: Understand Concepts Of Area And Relate Area To Multiplication And To Addition.	Major Cluster
26	17	Geometric Measurement: Recognize Perimeter As An Attribute Of Plane Figures And Distinguish Between Linear And Area Measures.	Additional Cluster
27	15	Use Place Value Understanding And Properties Of Operations To Perform Multi-Digit Arithmetic.* *A range of algorithms may be used.	Additional Cluster
28	16	Develop Understanding Of Fractions As Numbers.	Major Cluster
29	14	Represent And Solve Problems Involving Multiplication And Division.	Major Cluster
30	14	Understand Properties Of Multiplication And The Relationship Between Multiplication And Division.	Major Cluster
31	14	Multiply And Divide Within 100.	Major Cluster
32	14	Solve Problems Involving The Four Operations, And Identify And Explain Patterns In Arithmetic.	Major Cluster
33	23	Draw And Identify Lines And Angles, And Classify Shapes By Properties Of Their Lines And Angles.	Additional Cluster
34	22	Solve Problems Involving Measurement And Conversion Of Measurements From A Larger Unit To A Smaller Unit.	Supporting Cluster
35	22	Represent And Interpret Data.	Supporting Cluster
36	22	Geometric Measurement: Understand Concepts Of Angle And Measure Angles.	Additional Cluster
37	20	Generalize Place Value Understanding For Multi-Digit Whole Numbers.	Major Cluster
38	20	Use Place Value Understanding And Properties Of Operations To Perform Multi-Digit Arithmetic.	Major Cluster
39	21	Extend Understanding Of Fraction Equivalence And Ordering.	Major Cluster
40	21	Build Fractions From Unit Fractions By Applying And Extending Previous Understandings Of Operations On Whole Numbers.	Major Cluster
41	21	Understand Decimal Notation For Fractions, And Compare Decimal Fractions.	Major Cluster
42	19	Use The Four Operations With Whole Numbers To Solve Problems.	Major Cluster
43	19	Gain Familiarity With Factors And Multiples.	Supporting Cluster
44	19	Generate And Analyze Patterns.	Additional Cluster
45	28	Graph Points On The Coordinate Plane To Solve Real-World And Mathematical Problems.	Additional Cluster
46	28	Classify Two-Dimensional Figures Into Categories Based On Their Properties.	Additional Cluster
47	27	Convert Like Measurement Units Within A Given Measurement System.	Supporting Cluster
48	27	Represent And Interpret Data.	Supporting Cluster
49	27	Geometric Measurement: Understand Concepts Of Volume And Relate Volume To Multiplication And To Addition.	Major Cluster
50	25	Understand The Place Value System.	Major Cluster
51	25	Perform Operations With Multi-Digit Whole Numbers And With Decimals To Hundredths.	Major Cluster
52	26	Use Equivalent Fractions As A Strategy To Add And Subtract Fractions.	Major Cluster
53	26	Apply And Extend Previous Understandings Of Multiplication And Division To Multiply And Divide Fractions.	Major Cluster
54	24	Write And Interpret Numerical Expressions.	Additional Cluster
55	24	Analyze Patterns And Relationships.	Additional Cluster
56	31	Apply And Extend Previous Understandings Of Arithmetic To Algebraic Expressions.	Major Cluster
57	31	Reason About And Solve One-Variable Equations And Inequalities.	Major Cluster
58	31	Represent And Analyze Quantitative Relationships Between Dependent And Independent Variables.	Major Cluster
59	32	Solve Real-World And Mathematical Problems Involving Area, Surface Area, And Volume.	Supporting Cluster
60	30	Apply And Extend Previous Understandings Of Multiplication And Division To Divide Fractions By Fractions.	Major Cluster
61	30	Compute Fluently With Multi-Digit Numbers And Find Common Factors And Multiples.	Additional Cluster
62	30	Apply And Extend Previous Understandings Of Numbers To The System Of Rational Numbers.	Major Cluster
63	29	Understand Ratio Concepts And Use Ratio Reasoning To Solve Problems.	Major Cluster
64	33	Develop Understanding Of Statistical Variability.	Additional Cluster
65	33	Summarize And Describe Distributions.	Additional Cluster
66	36	Use Properties Of Operations To Generate Equivalent Expressions.	Major Cluster
67	36	Solve Real-Life And Mathematical Problems Using Numerical And Algebraic Expressions And Equations.	Major Cluster
68	37	Draw, Construct, And Describe Geometrical Figures And Describe The Relationships Between Them.	Additional Cluster
69	37	Solve Real-Life And Mathematical Problems Involving Angle Measure, Area, Surface Area, And Volume.	Additional Cluster
70	35	Apply And Extend Previous Understandings Of Operations With Fractions To Add, Subtract, Multiply, And Divide Rational Numbers.	Major Cluster
71	34	Analyze Proportional Relationships And Use Them To Solve Real-World And Mathematical Problems.	Major Cluster
72	38	Use Random Sampling To Draw Inferences About A Population.	Supporting Cluster
73	38	Draw Informal Comparative Inferences About Two Populations.	Additional Cluster
74	38	Investigate Chance Processes And Develop, Use, And Evaluate Probability Models.	Supporting Cluster
75	40	Work With Radicals And Integer Exponents.	Major Cluster
76	40	Understand The Connections Between Proportional Relationships, Lines, And Linear Equations.	Major Cluster
77	40	Analyze And Solve Linear Equations And Pairs Of Simultaneous Linear Equations.	Major Cluster
78	41	Define, Evaluate, And Compare Functions.	Major Cluster
79	41	Use Functions To Model Relationships Between Quantities.	Major Cluster
80	42	Understand Congruence And Similarity Using Physical Models, Transparencies, Or Geometry Software.	Major Cluster
81	42	Understand And Apply The Pythagorean Theorem.	Major Cluster
82	42	Solve Real-World And Mathematical Problems Involving Volume Of Cylinders, Cones, And Spheres.	Additional Cluster
83	39	Know That There Are Numbers That Are Not Rational, And Approximate Them By Rational Numbers.	Supporting Cluster
84	43	Investigate Patterns Of Association In Bivariate Data.	Supporting Cluster
85	1	Know Number Names And The Count Sequence.	Major Cluster
86	1	Count To Tell The Number Of Objects.	Major Cluster
87	1	Compare Numbers.	Major Cluster
88	5	Identify And Describe Shapes (Squares, Circles, Triangles, Rectangles, Hexagons, Cubes, Cones, Cylinders, And Spheres).	Additional Cluster
89	5	Analyze, Compare, Create, And Compose Shapes.	Supporting Cluster
90	4	Describe And Compare Measurable Attributes.	Additional Cluster
91	4	Classify Objects And Count The Number Of Objects In Each Category.	Supporting Cluster
92	3	Work With Numbers 11–19 To Gain Foundations For Place Value.	Major Cluster
93	2	Understand Addition As Putting Together And Adding To, And Under- Stand Subtraction As Taking Apart And Taking From.	Major Cluster
94	48	Perform Arithmetic Operations On Polynomials	Widely Applicable Prerequisite
95	48	Understand The Relationship Between Zeros And Factors Of Polynomials	Widely Applicable Prerequisite
96	48	Use Polynomial Identities To Solve Problems	Widely Applicable Prerequisite
97	48	Rewrite Rational Expressions	Widely Applicable Prerequisite
98	52	Build A Function That Models A Relationship Between Two Quantities	None
99	52	Build New Functions From Existing Functions	None
100	57	Understand And Apply Theorems About Circles	None
101	57	Find Arc Lengths And Areas Of Sectors Of Circles	None
102	63	Understand Independence And Conditional Probability And Use Them To Interpret Data	None
103	63	Use The Rules Of Probability To Compute Probabilities Of Compound Events In A Uniform Probability Model	None
104	55	Experiment With Transformations In The Plane	Widely Applicable Prerequisite
105	55	Understand Congruence In Terms Of Rigid Motions	Widely Applicable Prerequisite
106	55	Prove Geometric Theorems	None
107	55	Make Geometric Constructions	None
108	49	Create Equations That Describe Numbers Or Relationships	Widely Applicable Prerequisite
109	58	Translate Between The Geometric Description And The Equation For A Conic Section	None
110	58	Use Coordinates To Prove Simple Geometric Theorems Algebraically	None
111	59	Explain Volume Formulas And Use Them To Solve Problems	None
112	59	Visualize Relationships Between Two-Dimensional And Three- Dimensional Objects	None
113	61	Summarize, Represent, And Interpret Data On A Single Count Or Measurement Variable	None
114	61	Summarize, Represent, And Interpret Data On Two Categorical And Quantitative Variables	None
115	61	Interpret Linear Models	None
116	51	Understand The Concept Of A Function And Use Function Notation	Widely Applicable Prerequisite
117	51	Interpret Functions That Arise In Applications In Terms Of The Context	Widely Applicable Prerequisite
118	51	Analyze Functions Using Different Representations	Widely Applicable Prerequisite
119	53	Construct And Compare Linear, Quadratic, And Exponential Models And Solve Problems	None
120	53	Interpret Expressions For Functions In Terms Of The Situation They Model	None
121	62	Understand And Evaluate Random Processes Underlying Statistical Experiments	None
122	62	Make Inferences And Justify Conclusions From Sample Surveys, Experiments, And Observational Studies	None
123	60	Apply Geometric Concepts In Modeling Situations	None
124	45	Reason Quantitatively And Use Units To Solve Problems.	Widely Applicable Prerequisite
125	50	Understand Solving Equations As A Process Of Reasoning And Explain The Reasoning	Widely Applicable Prerequisite
126	50	Solve Equations And Inequalities In One Variable	Widely Applicable Prerequisite
127	50	Solve Systems Of Equations	Widely Applicable Prerequisite
128	50	Represent And Solve Equations And Inequalities Graphically	Widely Applicable Prerequisite
129	47	Interpret The Structure Of Expressions	Widely Applicable Prerequisite
130	47	Write Expressions In Equivalent Forms To Solve Problems	Widely Applicable Prerequisite
131	56	Understand Similarity In Terms Of Similarity Transformations	Widely Applicable Prerequisite
132	56	Prove Theorems Involving Similarity	Widely Applicable Prerequisite
133	56	Define Trigonometric Ratios And Solve Problems Involving Right Triangles	None
134	56	Apply Trigonometry To General Triangles	None
135	46	Perform Arithmetic Operations With Complex Numbers.	None
136	46	Represent Complex Numbers And Their Operations On The Complex Plane.	None
137	46	Use Complex Numbers In Polynomial Identities And Equations.	None
138	44	Extend The Properties Of Exponents To Rational Exponents.	Widely Applicable Prerequisite
139	44	Use Properties Of Rational And Irrational Numbers.	Widely Applicable Prerequisite
140	54	Extend The Domain Of Trigonometric Functions Using The Unit Circle	None
141	54	Model Periodic Phenomena With Trigonometric Functions	None
142	54	Prove And Apply Trigonometric Identities	None
\.


--
-- Data for Name: domains; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.domains (domainid, gradeid, domain_abb, domainname) FROM stdin;
1	1	K.CC	Counting And Cardinality
2	1	K.OA	Operations And Algebraic Thinking
3	1	K.NBT	Number And Operations In Base Ten
4	1	K.MD	Measurement And Data
5	1	K.G	Geometry
6	2	1.OA	Operations And Algebraic Thinking
7	2	1.NBT	Number And Operations In Base Ten
8	2	1.MD	Measurement And Data
9	2	1.G	Geometry
10	3	2.OA	Operations And Algebraic Thinking
11	3	2.NBT	Number And Operations In Base Ten
12	3	2.MD	Measurement And Data
13	3	2.G	Geometry
14	4	3.OA	Operations And Algebraic Thinking
15	4	3.NBT	Number And Operations In Base Ten
16	4	3.NF	Number And Operations-Fractions
17	4	3.MD	Measurement And Data
18	4	3.G	Geometry
19	5	4.OA	Operations And Algebraic Thinking
20	5	4.NBT	Number And Operations In Base Ten
21	5	4.NF	Number And Operations-Fractions
22	5	4.MD	Measurement And Data
23	5	4.G	Geometry
24	6	5.OA	Operations And Algebraic Thinking
25	6	5.NBT	Number And Operations In Base Ten
26	6	5.NF	Number And Operations-Fractions
27	6	5.MD	Measurement And Data
28	6	5.G	Geometry
29	7	6.RP	Ratios And Proportional Relationships
30	7	6.NS	The Number System
31	7	6.EE	Expressions And Equations
32	7	6.G	Geometry
33	7	6.SP	Statistics And Probability
34	8	7.RP	Ratios And Proportional Relationships
35	8	7.NS	The Number System
36	8	7.EE	Expressions And Equations
37	8	7.G	Geometry
38	8	7.SP	Statistics And Probability
39	9	8.NS	The Number System
40	9	8.EE	Expressions And Equations
41	9	8.F	Functions
42	9	8.G	Geometry
43	9	8.SP	Statistics And Probability
44	10	HS.N-RN	The Real Number System
45	10	HS.N-Q	Quantities
46	10	HS.N-CN	The Complex Number System
47	11	HS.A-SSE	Seeing Structure In Expressions
48	11	HS.A-APR	Arithmetic With Polynomials And Rational Expressions
49	11	HS.A-CED	Creating Equations
50	11	HS.A-REI	Reasoning With Equations And Inequalities
51	12	HS.F-IF	Interpreting Functions
52	12	HS.F-BF	Building Functions
53	12	HS.F-LE	Linear, Quadratic, And Exponential Models
54	12	HS.F-TF	Trigonometric Functions
55	14	HS.G-CO	Congruence
56	14	HS.G-SRT	Similarity, Right Triangles, And Trigonometry
57	14	HS.G-C	Circles
58	14	HS.G-GPE	Expressing Geometric Properties With Equations
59	14	HS.G-GMD	Geometric Measurement And Dimension
60	14	HS.G-MG	Modeling With Geometry
61	15	HS.S-ID	Interpreting Categorical And Quantitative Data
62	15	HS.S-IC	Making Inferences And Justifying Conclusions
63	15	HS.S-CP	Conditional Probability And The Rules Of Probability
\.


--
-- Data for Name: grades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grades (gradeid, gradename) FROM stdin;
1	Kindergarten
2	Grade 1
3	Grade 2
4	Grade 3
5	Grade 4
6	Grade 5
7	Grade 6
8	Grade 7
9	Grade 8
10	High School: Numbers and Quantity
11	High School: Algebra
12	High School: Functions
13	High School: Modeling
14	High School: Geometry
15	High School: Statistics and Probability
\.


--
-- Data for Name: standarddependencies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.standarddependencies (standardid, prerequisitestandardid) FROM stdin;
309	136
328	196
247	179
338	349
245	170
258	256
299	298
302	294
334	332
254	251
351	332
307	175
262	161
270	269
237	298
312	183
239	317
305	303
269	191
281	201
299	268
245	328
258	255
305	172
291	188
284	285
308	305
323	319
303	172
263	164
335	332
302	324
235	325
330	329
310	169
270	324
261	260
290	204
237	191
308	155
330	264
286	152
357	332
245	163
286	284
347	180
309	165
333	264
315	186
260	259
284	175
274	321
344	339
350	245
265	263
272	200
276	187
321	184
267	266
230	180
285	155
289	205
294	291
319	187
334	199
316	315
355	294
276	185
282	162
348	347
300	192
252	246
308	307
320	270
337	334
320	319
233	325
268	181
319	321
275	200
349	202
328	327
320	321
309	163
319	318
329	197
278	200
288	191
268	324
330	198
281	309
260	194
308	306
309	201
279	201
351	291
326	325
284	153
256	255
287	207
323	187
236	325
302	299
271	324
299	191
288	206
324	128
357	199
264	262
345	325
298	192
311	163
299	237
247	246
280	279
296	294
281	280
311	201
242	263
302	191
323	321
326	230
298	190
284	152
311	160
320	272
331	329
236	230
256	188
335	136
259	195
251	179
262	260
255	80
297	189
312	150
272	321
270	323
249	207
269	187
251	247
256	291
266	161
304	178
273	200
292	291
298	268
345	339
306	303
280	282
258	193
339	156
358	332
284	283
283	154
331	262
257	256
263	260
320	187
269	321
284	174
333	332
268	159
317	315
230	156
251	246
290	207
352	199
263	197
270	319
243	266
280	201
297	291
295	291
294	192
279	163
309	281
236	167
265	264
340	339
246	179
324	157
321	187
347	181
234	325
257	259
269	324
243	263
244	266
321	185
275	272
259	327
240	180
312	310
322	321
271	186
306	173
329	328
299	302
285	152
315	131
350	255
323	159
285	284
248	246
281	279
318	187
273	321
249	287
264	263
259	258
332	170
256	193
332	329
321	131
241	328
312	169
325	156
298	191
296	191
284	155
320	275
274	200
268	317
298	237
239	291
336	334
270	187
327	195
311	165
264	197
317	186
271	317
259	194
197	196
127	99
123	69
173	172
138	147
127	111
133	131
149	148
185	197
183	182
64	46
19	14
147	102
119	65
179	171
28	27
98	85
70	68
121	125
31	6
165	139
164	82
192	188
218	215
52	71
62	30
54	25
109	68
122	77
87	70
30	33
133	117
74	73
85	58
53	62
48	22
82	80
185	184
189	185
101	102
71	51
116	86
5	4
91	21
142	115
78	57
123	120
214	213
19	16
205	204
40	41
96	66
120	56
8	208
80	73
129	143
92	64
156	130
123	61
17	226
168	142
103	74
198	181
133	120
178	171
120	123
122	123
171	150
76	97
39	44
134	146
78	56
121	120
119	64
84	83
228	227
140	69
196	194
79	91
57	54
122	65
58	35
47	20
61	26
25	51
105	77
114	116
159	134
18	211
142	114
170	150
115	110
135	133
44	13
91	61
222	221
44	14
54	2
86	83
27	25
129	125
182	180
43	42
203	202
44	32
181	168
87	59
110	95
189	170
89	63
125	124
128	127
181	202
69	66
109	108
123	92
190	188
113	85
208	211
10	9
120	122
186	206
65	64
121	119
110	83
159	168
206	205
172	176
67	70
62	61
201	181
224	227
174	152
157	156
60	35
19	227
14	226
44	12
56	68
64	69
217	216
152	106
43	41
150	149
92	61
29	44
119	120
122	96
220	217
149	123
88	83
153	151
56	54
66	64
200	199
223	222
150	133
13	9
111	116
216	215
106	123
174	140
112	110
131	128
131	133
102	62
39	13
119	121
61	24
181	198
140	123
168	166
208	209
163	136
93	89
134	131
202	181
121	97
56	56
66	67
42	35
135	126
137	109
44	11
45	19
77	98
147	145
51	61
177	176
108	107
62	53
88	70
220	216
190	185
175	173
35	36
26	27
93	91
41	42
167	120
71	66
172	151
116	111
86	59
66	69
116	117
212	211
12	13
159	159
37	35
77	94
42	43
206	191
191	206
29	28
114	86
68	65
39	12
76	70
219	215
181	131
113	110
70	71
116	120
155	154
206	186
77	92
215	217
129	16
11	19
36	46
139	136
106	118
177	171
202	167
145	144
92	97
71	57
10	214
199	198
167	119
97	66
116	110
72	46
77	93
187	185
130	143
160	136
91	89
111	114
88	59
119	97
182	111
57	71
68	64
39	11
71	56
146	145
77	76
85	83
14	19
155	153
215	216
112	84
15	14
21	14
73	80
16	17
156	129
167	166
91	91
3	2
133	140
61	62
95	94
165	137
130	125
14	21
119	69
11	9
170	169
118	117
91	77
200	138
122	64
80	74
126	100
229	227
92	66
189	184
4	222
169	149
178	177
24	23
159	133
145	62
136	120
115	116
102	101
170	159
40	35
34	44
155	152
148	126
135	150
192	190
129	130
83	35
63	62
110	94
218	217
174	120
22	1
7	223
25	5
107	54
187	131
197	194
35	9
128	126
74	80
129	68
148	76
91	17
95	90
183	180
65	69
98	71
143	99
123	122
19	18
98	77
56	71
59	17
51	25
78	67
60	68
129	128
186	156
76	51
46	36
87	68
191	170
105	76
160	170
61	51
39	45
73	48
90	89
121	122
217	215
49	61
96	64
103	48
192	189
75	2
196	195
154	155
91	79
110	93
218	216
81	80
30	29
128	125
69	65
114	111
122	120
205	191
142	116
195	193
106	79
44	29
7	15
192	191
150	150
16	226
106	122
87	60
185	170
51	71
55	23
132	128
181	203
175	174
132	133
122	121
33	30
213	211
209	211
121	96
56	55
159	132
170	149
118	90
115	114
141	115
91	62
166	145
138	102
186	159
72	68
67	66
125	121
220	215
156	157
109	107
88	87
121	89
69	64
114	110
120	119
213	212
134	145
91	44
19	229
130	16
167	140
148	121
166	146
188	170
104	103
159	170
7	14
120	92
24	3
115	86
209	208
117	89
190	189
158	168
227	226
32	44
150	135
166	144
29	30
145	101
147	138
195	138
216	217
182	183
150	148
211	213
183	158
9	8
88	69
121	77
2	220
198	199
187	159
226	225
89	97
26	25
180	127
117	91
168	167
71	70
193	164
191	192
223	213
43	17
19	228
42	41
116	123
184	185
191	205
198	165
13	12
211	211
119	96
46	20
136	78
122	97
38	35
1	219
153	152
133	150
193	161
66	65
191	190
12	9
19	226
105	116
142	141
82	21
143	125
168	98
111	110
100	72
101	62
151	106
114	87
121	65
88	68
131	134
149	119
189	188
219	217
115	88
41	35
34	7
79	53
113	112
148	97
70	67
116	115
204	147
43	16
171	170
59	42
211	208
185	160
112	95
130	68
9	224
133	132
1	218
184	170
64	47
41	43
172	152
77	91
70	69
130	128
119	77
211	209
17	16
121	64
87	83
71	44
71	52
91	16
194	193
219	216
133	135
55	54
154	106
150	102
166	117
19	17
85	84
202	203
165	136
116	114
97	76
98	88
130	129
203	181
179	178
212	213
44	34
63	61
44	39
21	20
59	41
182	97
99	70
149	97
68	56
109	78
\.


--
-- Data for Name: standards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.standards (standardid, clusterid, standardcode, standarddescription, stadid) FROM stdin;
235	97	HS.A-APR.D.6	Rewrite simple rational expressions in different forms; write a(x)b(x) in the form q(x)+r(x)b(x), where a(x), b(x), q(x), and r(x) are polynomials with the degree of r(x) less than the degree of b(x), using inspection, long division, or, for the more complicated examples, a computer algebra system.NO CHILD STANDARDS	501
239	99	HS.F-BF.B.4	Find inverse functions:***** Sub_children Standards *******	536
252	103	HS.S-CP.B.7	Apply the Addition Rule, P(A or B) = P(A) + P(B) – P(A and B), and interpret the answer in terms of the model.NO CHILD STANDARDS	658
233	96	HS.A-APR.C.4	Prove polynomial identities and use them to describe numerical relationships. For example, the polynomial identity (x2 + y2)2= (x2 - y2)2 + (2xy)2 can be used to generate Pythagorean triples.NO CHILD STANDARDS	499
250	102	HS.S-CP.A.5	Recognize and explain the concepts of conditional probability and independence in everyday language and everyday situations. For example, compare the chance of having lung cancer if you are a smoker with the chance of being a smoker if you have lung cancer.NO CHILD STANDARDS	656
248	102	HS.S-CP.A.3	Understand the conditional probability of A given B as P(A and B)/P(B), and interpret independence of A and B as saying that the conditional probability of A given B is the same as the probability of A, and the conditional probability of B given A is the same as the probability of B.NO CHILD STANDARDS	654
234	96	HS.A-APR.C.5	Know and apply the Binomial Theorem for the expansion of (x + y)n in powers of x and y for a positive integer n, where x and y are any numbers, with coefficients determined for example by Pascal’s Triangle.* *The Binomial Theorem can be proved by mathematical induction or by a combinatorial argument.	500
254	103	HS.S-CP.B.9	Use permutations and combinations to compute probabilities of compound events and solve problems.	660
257	104	HS.G-CO.A.3	Given a rectangle, parallelogram, trapezoid, or regular polygon, describe the rotations and reflections that carry it onto itself.NO CHILD STANDARDS	582
243	100	HS.G-C.A.3	Construct the inscribed and circumscribed circles of a triangle, and prove properties of angles for a quadrilateral inscribed in a circle.NO CHILD STANDARDS	577
241	100	HS.G-C.A.1	Prove that all circles are similar.NO CHILD STANDARDS	575
242	100	HS.G-C.A.2	Identify and describe relationships among inscribed angles, radii, and chords. Include the relationship between central, inscribed, and circumscribed angles; inscribed angles on a diameter are right angles; the radius of a circle is perpendicular to the tangent where the radius intersects the circle.NO CHILD STANDARDS	576
232	95	HS.A-APR.B.3	Identify zeros of polynomials when suitable factorizations are available, and use the zeros to construct a rough graph of the function defined by the polynomial.NO CHILD STANDARDS	498
238	99	HS.F-BF.B.3	Identify the effect on the graph of replacing f(x) by f(x) + k, k f(x), f(kx), and f(x + k) for specific values of k (both positive and negative); find the value of k given the graphs. Experiment with cases and illustrate an explanation of the effects on the graph using technology. Include recognizing even and odd functions from their graphs and algebraic expressions for them.NO CHILD STANDARDS	535
267	107	HS.G-CO.D.13	Construct an equilateral triangle, a square, and a regular hexagon inscribed in a circle.NO CHILD STANDARDS	592
277	110	HS.G-GPE.B.6	Find the point on a directed line segment between two given points that partitions the segment in a given ratio.NO CHILD STANDARDS	602
265	106	HS.G-CO.C.11	Prove theorems about parallelograms. Theorems include: opposite sides are congruent, opposite angles are congruent, the diagonals of a parallelogram bisect each other, and conversely, rectangles are parallelograms with congruent diagonals.NO CHILD STANDARDS	589
261	105	HS.G-CO.B.7	Use the definition of congruence in terms of rigid motions to show that two triangles are congruent if and only if corresponding pairs of sides and corresponding pairs of angles are congruent.NO CHILD STANDARDS	586
253	103	HS.S-CP.B.8	Apply the general Multiplication Rule in a uniform probability model, P(A and B) = P(A)P(B|A) = P(B)P(A|B), and interpret the answer in terms of the model.	659
244	100	HS.G-C.A.4	Construct a tangent line from a point outside a given circle to the circle.	578
231	95	HS.A-APR.B.2	Know and apply the Remainder Theorem: For a polynomial p(x) and a number a, the remainder on division by x – a is p(a), so p(a) = 0 if and only if (x – a) is a factor of p(x).NO CHILD STANDARDS	497
322	128	HS.A-REI.D.11	Explain why the x-coordinates of the points where the graphs of the equations y = f(x) and y = g(x) intersect are the solutions of the equation f(x) = g(x); find the solutions approximately, e.g., using technology to graph the functions, make tables of values, or find successive approximations. Include cases where f(x) and/or g(x) are linear, polynomial, rational, absolute value, exponential, and logarithmic functions.NO CHILD STANDARDS	519
273	109	HS.G-GPE.A.2	Derive the equation of a parabola given a focus and directrix.NO CHILD STANDARDS	598
249	102	HS.S-CP.A.4	Construct and interpret two-way frequency tables of data when two categories are associated with each object being classified. Use the two-way table as a sample space to decide if events are independent and to approximate conditional probabilities. For example, collect data from a random sample of students in your school on their favorite subject among math, science, and English. Estimate the probability that a randomly selected student from your school will favor science given that the student is in tenth grade. Do the same for other subjects and compare the results.NO CHILD STANDARDS	655
251	103	HS.S-CP.B.6	Find the conditional probability of A given B as the fraction of B’s outcomes that also belong to A, and interpret the answer in terms of the model.NO CHILD STANDARDS	657
255	104	HS.G-CO.A.1	Know precise definitions of angle, circle, perpendicular line, parallel line, and line segment, based on the undefined notions of point, line, distance along a line, and distance around a circular arc.NO CHILD STANDARDS	580
256	104	HS.G-CO.A.2	Represent transformations in the plane using, e.g., transparencies and geometry software; describe transformations as functions that take points in the plane as inputs and give other points as outputs. Compare transformations that preserve distance and angle to those that do not (e.g., translation versus horizontal stretch).NO CHILD STANDARDS	581
258	104	HS.G-CO.A.4	Develop definitions of rotations, reflections, and translations in terms of angles, circles, perpendicular lines, parallel lines, and line segments.NO CHILD STANDARDS	583
259	104	HS.G-CO.A.5	Given a geometric figure and a rotation, reflection, or translation, draw the transformed figure using, e.g., graph paper, tracing paper, or geometry software. Specify a sequence of transformations that will carry a given figure onto another.NO CHILD STANDARDS	584
260	105	HS.G-CO.B.6	Use geometric descriptions of rigid motions to transform figures and to predict the effect of a given rigid motion on a given figure; given two figures, use the definition of congruence in terms of rigid motions to decide if they are congruent.NO CHILD STANDARDS	585
262	105	HS.G-CO.B.8	Explain how the criteria for triangle congruence (ASA, SAS, and SSS) follow from the definition of congruence in terms of rigid motions.NO CHILD STANDARDS	587
313	124	HS.N-Q.A.2	Define appropriate quantities for the purpose of descriptive modeling.NO CHILD STANDARDS	630
295	117	HS.F-IF.B.5	Relate the domain of a function to its graph and, where applicable, to the quantitative relationship it describes. For example, if the function h(n) gives the number of person-hours it takes to assemble n engines in a factory, then the positive integers would be an appropriate domain for the function.NO CHILD STANDARDS	546
316	125	HS.A-REI.A.2	Solve simple rational and radical equations in one variable, and give examples showing how extraneous solutions may arise.NO CHILD STANDARDS	508
301	119	HS.F-LE.A.4	For exponential models, express as a logarithm the solution to abct =d where a,c,and d are numbers and the base b is 2,10, or e; evaluate the logarithm using technology.NO CHILD STANDARDS	564
314	124	HS.N-Q.A.3	Choose a level of accuracy appropriate to limitations on measurement when reporting quantities.NO CHILD STANDARDS	631
292	116	HS.F-IF.A.2	Use function notation, evaluate functions for inputs in their domains, and interpret statements that use function notation in terms of a context.NO CHILD STANDARDS	543
293	116	HS.F-IF.A.3	Recognize that sequences are functions, sometimes defined recursively, whose domain is a subset of the integers. For example, the Fibonacci sequence is defined recursively by f(0) = f(1) = 1, f(n+1) = f(n) + f(n-1) for n ≥ 1.NO CHILD STANDARDS	544
263	106	HS.G-CO.C.9	Prove theorems about lines and angles. Theorems include: vertical angles are congruent; when a transversal crosses parallel lines, alternate interior angles are congruent and corresponding angles are congruent; points on a perpendicular bisector of a line segment are exactly those equidistant from the segment’s endpoints.NO CHILD STANDARDS	590
264	106	HS.G-CO.C.10	Prove theorems about triangles. Theorems include: measures of interior angles of a triangle sum to 180°; base angles of isosceles triangles are congruent; the segment joining midpoints of two sides of a triangle is parallel to the third side and half the length; the medians of a triangle meet at a point.NO CHILD STANDARDS	588
266	107	HS.G-CO.D.12	Make formal geometric constructions with a variety of tools and methods (compass and straightedge, string, reflective devices, paper folding, dynamic geometric software, etc.). Copying a segment; copying an angle; bisecting a segment; bisecting an angle; constructing perpendicular lines, including the perpendicular bisector of a line segment; and constructing a line parallel to a given line through a point not on the line.NO CHILD STANDARDS	591
268	108	HS.A-CED.A.1	Create equations and inequalities in one variable and use them to solve problems. Include equations arising from linear and quadratic functions, and simple rational and exponential functions.NO CHILD STANDARDS	503
269	108	HS.A-CED.A.2	Create equations in two or more variables to represent relationships between quantities; graph equations on coordinate axes with labels and scales.NO CHILD STANDARDS	504
270	108	HS.A-CED.A.3	Represent constraints by equations or inequalities, and by systems of equations and/or inequalities, and interpret solutions as viable or non- viable options in a modeling context. For example, represent inequalities describing nutritional and cost constraints on combinations of different foods.NO CHILD STANDARDS	505
271	108	HS.A-CED.A.4	Rearrange formulas to highlight a quantity of interest, using the same reasoning as in solving equations. For example, rearrange Ohm’s law V = IR to highlight resistance R.NO CHILD STANDARDS	506
272	109	HS.G-GPE.A.1	Derive the equation of a circle of given center and radius using the Pythagorean Theorem; complete the square to find the center and radius of a circle given by an equation.NO CHILD STANDARDS	597
274	109	HS.G-GPE.A.3	Derive the equations of ellipses and hyperbolas given the foci, using the fact that the sum or difference of distances from the foci is constant.	599
343	136	HS.N-CN.B.6	Calculate the distance between numbers in the complex plane as the modulus of the difference, and the midpoint of a segment as the average of the numbers at its endpoints.	625
333	133	HS.G-SRT.C.7	Explain and use the relationship between the sine and cosine of complementary angles.NO CHILD STANDARDS	615
346	137	HS.N-CN.C.9	Know the Fundamental Theorem of Algebra; show that it is true for quadratic polynomials.	628
336	134	HS.G-SRT.D.10	Prove the Laws of Sines and Cosines and use them to solve problems.	617
342	136	HS.N-CN.B.5	Represent addition, subtraction, multiplication, and conjugation of complex numbers geometrically on the complex plane; use properties of this representation for computation. For example, (–1 + √3 i)3 = 8 because (–1 + √3 i) has modulus 2 and argument 120°.	624
340	135	HS.N-CN.A.3	Find the conjugate of a complex number; use conjugates to find moduli and quotients of complex numbers.	622
355	141	HS.F-TF.B.6	Understand that restricting a trigonometric function to a domain on which it is always increasing or always decreasing allows its inverse to be constructed.	571
345	137	HS.N-CN.C.8	Extend polynomial identities to the complex numbers. For example, rewrite x2 + 4 as (x + 2i)(x – 2i).	627
338	135	HS.N-CN.A.1	Know there is a complex number i such that i 2 = –1, and every complex number has the form a + bi with a and b real.NO CHILD STANDARDS	620
354	141	HS.F-TF.B.5	Choose trigonometric functions to model periodic phenomena with specified amplitude, frequency, and midline. NO CHILD STANDARDS	570
331	132	HS.G-SRT.B.5	Use congruence and similarity criteria for triangles to solve problems and to prove relationships in geometric figures.NO CHILD STANDARDS	613
353	140	HS.F-TF.A.4	Use the unit circle to explain symmetry (odd and even) and periodicity of trigonometric functions.	569
341	136	HS.N-CN.B.4	Represent complex numbers on the complex plane in rectangular and polar form (including real and imaginary numbers), and explain why the rectangular and polar forms of a given complex number represent the same number.	623
351	140	HS.F-TF.A.2	Explain how the unit circle in the coordinate plane enables the extension of trigonometric functions to all real numbers, interpreted as radian measures of angles traversed counterclockwise around the unit circle.NO CHILD STANDARDS	567
344	137	HS.N-CN.C.7	Solve quadratic equations with real coefficients that have complex solutions.NO CHILD STANDARDS	626
348	138	HS.N-RN.A.2	Rewrite expressions involving radicals and rational exponents using the properties of exponents.NO CHILD STANDARDS	633
326	130	HS.A-SSE.B.4	Derive the formula for the sum of a finite geometric series (when the common ratio is not 1), and use the formula to solve problems. For example, calculate mortgage payments.NO CHILD STANDARDS	529
350	140	HS.F-TF.A.1	Understand radian measure of an angle as the length of the arc on the unit circle subtended by the angle.NO CHILD STANDARDS	566
337	134	HS.G-SRT.D.11	Understand and apply the Law of Sines and the Law of Cosines to find uknown measurements in right and non-right triangles (e.g., surveying problems, resultant forces).	618
275	110	HS.G-GPE.B.4	Use coordinates to prove simple geometric theorems algebraically. For example, prove or disprove that a figure defined by four given points in the coordinate plane is a rectangle; prove or disprove that the point (1, √3) lies on the circle centered at the origin and containing the point (0, 2).NO CHILD STANDARDS	600
356	141	HS.F-TF.B.7	Use inverse functions to solve trigonometric equations that arise in modeling contexts; evaluate the solutions using technology, and interpret them in terms of the context.	572
358	142	HS.F-TF.C.9	Prove the addition and subtraction formulas for sine, cosine, and tangent and use them to solve problems.	574
276	110	HS.G-GPE.B.5	Prove the slope criteria for parallel and perpendicular lines and use them to solve geometric problems (e.g., find the equation of a line parallel or perpendicular to a given line that passes through a given point).NO CHILD STANDARDS	601
279	111	HS.G-GMD.A.1	Give an informal argument for the formulas for the circumference of a circle, area of a circle, volume of a cylinder, pyramid, and cone. Use dissection arguments, Cavalieri’s principle, and informal limit arguments.NO CHILD STANDARDS	593
280	111	HS.G-GMD.A.2	Give an informal argument using Cavalieri’s principle for the formulas for the volume of a sphere and other solid figures.	594
281	111	HS.G-GMD.A.3	Use volume formulas for cylinders, pyramids, cones, and spheres to solve problems.NO CHILD STANDARDS	595
282	112	HS.G-GMD.B.4	Identify the shapes of two-dimensional cross-sections of three- dimensional objects, and identify three-dimensional objects generated by rotations of two-dimensional objects.NO CHILD STANDARDS	596
283	113	HS.S-ID.A.1	Represent data with plots on the real number line (dot plots, histograms, and box plots).NO CHILD STANDARDS	667
284	113	HS.S-ID.A.2	Use statistics appropriate to the shape of the data distribution to compare center (median, mean) and spread (interquartile range, standard deviation) of two or more different data sets.NO CHILD STANDARDS	668
285	113	HS.S-ID.A.3	Interpret differences in shape, center, and spread in the context of the data sets, accounting for possible effects of extreme data points (outliers).NO CHILD STANDARDS	669
287	114	HS.S-ID.B.5	Summarize categorical data for two categories in two-way frequency tables. Interpret relative frequencies in the context of the data (including joint, marginal, and conditional relative frequencies). Recognize possible associations and trends in the data.NO CHILD STANDARDS	671
288	115	HS.S-ID.C.7	Interpret the slope (rate of change) and the intercept (constant term) of a linear model in the context of the data.NO CHILD STANDARDS	676
289	115	HS.S-ID.C.8	Compute (using technology) and interpret the correlation coefficient of a linear fit.NO CHILD STANDARDS	677
290	115	HS.S-ID.C.9	Distinguish between correlation and causation.NO CHILD STANDARDS	678
291	116	HS.F-IF.A.1	Understand that a function from one set (called the domain) to another set (called the range) assigns to each element of the domain exactly one element of the range. If f is a function and x is an element of its domain, then f(x) denotes the output of f corresponding to the input x. The graph of f is the graph of the equation y = f(x).NO CHILD STANDARDS	542
294	117	HS.F-IF.B.4	For a function that models a relationship between two quantities, interpret key features of graphs and tables in terms of the quantities, and sketch graphs showing key features given a verbal description of the relationship. Key features include: intercepts; intervals where the function is increasing, decreasing, positive, or negative; relative maximums and minimums; symmetries; end behavior; and periodicity.NO CHILD STANDARDS	545
296	117	HS.F-IF.B.6	Calculate and interpret the average rate of change of a function (presented symbolically or as a table) over a specified interval. Estimate the rate of change from a graph.NO CHILD STANDARDS	547
297	118	HS.F-IF.C.9	Compare properties of two functions each represented in a different way (algebraically, graphically, numerically in tables, or by verbal descriptions). For example, given a graph of one quadratic function and an algebraic expression for another, say which has the larger maximum.NO CHILD STANDARDS	557
298	119	HS.F-LE.A.1	Distinguish between situations that can be modeled with linear functions and with exponential functions:***** Sub_children Standards *******	558
299	119	HS.F-LE.A.2	Construct linear and exponential functions, including arithmetic and geometric sequences, given a graph, a description of a relationship, or two input-output pairs (include reading these from a table).NO CHILD STANDARDS	562
300	119	HS.F-LE.A.3	Observe using graphs and tables that a quantity increasing exponentially eventually exceeds a quantity increasing linearly, quadratically, or (more generally) as a polynomial function.NO CHILD STANDARDS	563
302	120	HS.F-LE.B.5	Interpret the parameters in a linear or exponential function in terms of a context.NO CHILD STANDARDS	565
303	121	HS.S-IC.A.1	Understand statistics as a process for making inferences about population parameters based on a random sample from that population.NO CHILD STANDARDS	661
304	121	HS.S-IC.A.2	Decide if a specified model is consistent with results from a given data-generating process, e.g., using simulation. For example, a model says a spinning coin falls heads up with probability 0.5. Would a result of 5 tails in a row cause you to question the model?NO CHILD STANDARDS	662
305	122	HS.S-IC.B.3	Recognize the purposes of and differences among sample surveys, experiments, and observational studies; explain how randomization relates to each.NO CHILD STANDARDS	699
306	122	HS.S-IC.B.4	Use data from a sample survey to estimate a population mean or proportion; develop a margin of error through the use of simulation models for random sampling.NO CHILD STANDARDS	664
307	122	HS.S-IC.B.5	Use data from a randomized experiment to compare two treatments; use simulations to decide if differences between parameters are significant.NO CHILD STANDARDS	665
308	122	HS.S-IC.B.6	Evaluate reports based on data.NO CHILD STANDARDS	666
309	123	HS.G-MG.A.1	Use geometric shapes, their measures, and their properties to describe objects (e.g., modeling a tree trunk or a human torso as a cylinder).NO CHILD STANDARDS	604
310	123	HS.G-MG.A.2	Apply concepts of density based on area and volume in modeling situations (e.g., persons per square mile, BTUs per cubic foot).NO CHILD STANDARDS	605
311	123	HS.G-MG.A.3	Apply geometric methods to solve design problems (e.g., designing an object or structure to satisfy physical constraints or minimize cost; working with typographic grid systems based on ratios).NO CHILD STANDARDS	606
312	124	HS.N-Q.A.1	Use units as a way to understand problems and to guide the solution of multi-step problems; choose and interpret units consistently in formulas; choose and interpret the scale and the origin in graphs and data displays.NO CHILD STANDARDS	629
315	125	HS.A-REI.A.1	Explain each step in solving a simple equation as following from the equality of numbers asserted at the previous step, starting from the assumption that the original equation has a solution. Construct a viable argument to justify a solution method.NO CHILD STANDARDS	507
317	126	HS.A-REI.B.3	Solve linear equations and inequalities in one variable, including equations with coefficients represented by letters.NO CHILD STANDARDS	509
318	127	HS.A-REI.C.5	Prove that, given a system of two equations in two variables, replacing one equation by the sum of that equation and a multiple of the other produces a system with the same solutions.NO CHILD STANDARDS	513
319	127	HS.A-REI.C.6	Solve systems of linear equations exactly and approximately (e.g., with graphs), focusing on pairs of linear equations in two variables.NO CHILD STANDARDS	514
320	127	HS.A-REI.C.7	Solve a simple system consisting of a linear equation and a quadratic equation in two variables algebraically and graphically. For example, find the points of intersection between the line y = –3x and the circle x2 + y2 = 3.NO CHILD STANDARDS	515
321	128	HS.A-REI.D.10	Understand that the graph of an equation in two variables is the set of all its solutions plotted in the coordinate plane, often forming a curve (which could be a line).NO CHILD STANDARDS	518
323	128	HS.A-REI.D.12	Graph the solutions to a linear inequality in two variables as a half- plane (excluding the boundary in the case of a strict inequality), and graph the solution set to a system of linear inequalities in two variables as the intersection of the corresponding half-planes.NO CHILD STANDARDS	520
324	129	HS.A-SSE.A.1	Interpret expressions that represent a quantity in terms of its context:***** Sub_children Standards *******	521
325	129	HS.A-SSE.A.2	Use the structure of an expression to identify ways to rewrite it. For example, see x4 – y4 as (x2)2 – (y2)2, thus recognizing it as a difference of squares that can be factored as (x2 – y2)(x2 + y2).NO CHILD STANDARDS	524
327	131	HS.G-SRT.A.1	Verify experimentally the properties of dilations given by a center and a scale factor:***** Sub_children Standards *******	607
27	13	2.MD.A.3	Estimate lengths using units of inches, feet, centimeters, and meters.	51
28	13	2.MD.A.4	Measure to determine how much longer one object is than another, expressing the length difference in terms of a standard length unit.	52
129	56	6.EE.A.3	Apply the properties of operations to generate equivalent expressions.	254
230	94	HS.A-APR.A.1	Understand that polynomials form a system analogous to the integers, namely, they are closed under the operations of addition, subtraction, and multiplication; add, subtract, and multiply polynomials.NO CHILD STANDARDS	496
236	97	HS.A-APR.D.7	Understand that rational expressions form a system analogous to the rational numbers, closed under addition, subtraction, multiplication, and division by a nonzero rational expression; add, subtract, multiply, and divide rational expressions.	502
237	98	HS.F-BF.A.2	Write arithmetic and geometric sequences both recursively and with an explicit formula, use them to model situations, and translate between the two forms.NO CHILD STANDARDS	534
240	99	HS.F-BF.B.5	Understand the inverse relationship between exponents and logarithms and use this relationship to solve problems involving logarithms and exponents.	541
245	101	HS.G-C.B.5	Derive using similarity the fact that the length of the arc intercepted by an angle is proportional to the radius, and define the radian measure of the angle as the constant of proportionality; derive the formula for the area of a sector.NO CHILD STANDARDS	579
246	102	HS.S-CP.A.1	Describe events as subsets of a sample space (the set of outcomes) using characteristics (or categories) of the outcomes, or as unions, intersections, or complements of other events (“or,” “and,” “not”).NO CHILD STANDARDS	652
247	102	HS.S-CP.A.2	Understand that two events A and B are independent if the probability of A and B occurring together is the product of their probabilities, and use this characterization to determine if they are independent.NO CHILD STANDARDS	653
286	113	HS.S-ID.A.4	Use the mean and standard deviation of a data set to fit it to a normal distribution and to estimate population percentages. Recognize that there are data sets for which such a procedure is not appropriate. Use calculators, spreadsheets, and tables to estimate areas under the normal curve.NO CHILD STANDARDS	670
278	110	HS.G-GPE.B.7	Use coordinates to compute perimeters of polygons and areas of triangles and rectangles, e.g., using the distance formula.NO CHILD STANDARDS	603
104	46	5.G.B.4	Classify two-dimensional figures in a hierarchy based on properties.	202
328	131	HS.G-SRT.A.2	Given two figures, use the definition of similarity in terms of similarity transformations to decide if they are similar; explain using similarity transformations the meaning of similarity for triangles as the equality of all corresponding pairs of angles and the proportionality of all corresponding pairs of sides.NO CHILD STANDARDS	610
329	131	HS.G-SRT.A.3	Use the properties of similarity transformations to establish the AA criterion for two triangles to be similar.NO CHILD STANDARDS	611
330	132	HS.G-SRT.B.4	Prove theorems about triangles. Theorems include: a line parallel to one side of a triangle divides the other two proportionally, and conversely; the Pythagorean Theorem proved using triangle similarity.NO CHILD STANDARDS	612
332	133	HS.G-SRT.C.6	Understand that by similarity, side ratios in right triangles are properties of the angles in the triangle, leading to definitions of trigonometric ratios for acute angles.NO CHILD STANDARDS	614
334	133	HS.G-SRT.C.8	Use trigonometric ratios and the Pythagorean Theorem to solve right triangles in applied problems.NO CHILD STANDARDS	616
335	134	HS.G-SRT.D.9	Derive the formula A = 1/2 ab sin(C) for the area of a triangle by drawing an auxiliary line from a vertex perpendicular to the opposite side.	619
339	135	HS.N-CN.A.2	Use the relation i 2 = –1 and the commutative, associative, and distributive properties to add, subtract, and multiply complex numbers.NO CHILD STANDARDS	621
347	138	HS.N-RN.A.1	Explain how the definition of the meaning of rational exponents follows from extending the properties of integer exponents to those values, allowing for a notation for radicals in terms of rational exponents. For example, we define 51/3 to be the cube root of 5 because we want (51/3)3= 5(1/3)3 to hold, so (51/3)3 must equal 5.NO CHILD STANDARDS	632
349	139	HS.N-RN.B.3	Explain why the sum or product of two rational numbers is rational; that the sum of a rational number and an irrational number is irrational; and that the product of a nonzero rational number and an irrational number is irrational.NO CHILD STANDARDS	634
352	140	HS.F-TF.A.3	Use special triangles to determine geometrically the values of sine, cosine, tangent for π/3, π/4 and π/6, and use the unit circle to express the values of sine, cosine, and tangent for π–x, π+x, and 2π–x in terms of their values for x, where x is any real number.	568
357	142	HS.F-TF.C.8	Prove the Pythagorean identity sin2(θ) + cos2(θ) = 1 and use it to find sin(θ), cos(θ), or tan(θ) given sin(θ), cos(θ), or tan(θ) and the quadrant of the angle.NO CHILD STANDARDS	573
359	94	HS.A-APR.A.1	Understand that polynomials form a system analogous to the integers, namely, they are closed under the operations of addition, subtraction, and multiplication; add, subtract, and multiply polynomials.NO CHILD STANDARDS	496
1	1	1.G.A.1	Distinguish between defining attributes (e.g., triangles are closed and three-sided) versus non-defining attributes (e.g., color, orientation, overall size); build and draw shapes to possess defining attributes.	6
2	1	1.G.A.2	Compose two-dimensional shapes (rectangles, squares, trapezoids, triangles, half-circles, and quarter-circles) or three-dimensional shapes (cubes, right rectangular prisms, right circular cones, and right circular cylinders) to create a composite shape, and compose new shapes from the composite shape.* *Students do not need to learn formal names such as “right rectangular prism.”	7
3	1	1.G.A.3	Partition circles and rectangles into two and four equal shares, describe the shares using the words halves, fourths, and quarters, and use the phrases half of, fourth of, and quarter of. Describe the whole as two of, or four of the shares. Understand for these examples that decomposing into more equal shares creates smaller shares.	8
4	2	1.MD.A.1	Order three objects by length; compare the lengths of two objects indirectly by using a third object.	9
5	2	1.MD.A.2	Express the length of an object as a whole number of length units, by laying multiple copies of a shorter object (the length unit) end to end; understand that the length measurement of an object is the number of same-size length units that span it with no gaps or overlaps. Limit to contexts where the object being measured is spanned by a whole number of length units with no gaps or overlaps.	11
6	3	1.MD.B.3	Tell and write time in hours and half-hours using analog and digital clocks.	12
7	4	1.MD.C.4	Organize, represent, and interpret data with up to three categories; ask and answer questions about the total number of data points, how many in each category, and how many more or less are in one category than in another.	13
8	5	1.NBT.A.1	Count to 120, starting at any number less than 120. In this range, read and write numerals and represent a number of objects with a written numeral.	16
9	6	1.NBT.B.2	Understand that the two digits of a two-digit number represent amounts of tens and ones. Understand the following as special cases:	17
10	6	1.NBT.B.3	Compare two two-digit numbers based on meanings of the tens and ones digits, recording the results of comparisons with the symbols >, =, and <.	21
11	7	1.NBT.C.4	Add within 100, including adding a two-digit number and a one-digit number, and adding a two-digit number and a multiple of 10, using concrete models or drawings and strategies based on place value, properties of operations, and/or the relationship between addition and subtraction; relate the strategy to a written method and explain the reasoning used. Understand that in adding two-digit numbers, one adds tens and tens, ones and ones; and sometimes it is necessary to compose a ten.	22
12	7	1.NBT.C.5	Given a two-digit number, mentally find 10 more or 10 less than the number, without having to count; explain the reasoning used.	23
13	7	1.NBT.C.6	Subtract multiples of 10 in the range 10-90 from multiples of 10 in the range 10-90 (positive or zero differences), using concrete models or drawings and strategies based on place value, properties of operations, and/or the relationship between addition and subtraction; relate the strategy to a written method and explain the reasoning used.	24
14	8	1.OA.A.1	Use addition and subtraction within 20 to solve word problems involving situations of adding to, taking from, putting together, taking apart, and comparing, with unknowns in all positions, e.g., by using objects, drawings, and equations with a symbol for the unknown number to represent the problem.* *See Glossary, Table 1.	33
15	8	1.OA.A.2	Solve word problems that call for addition of three whole numbers whose sum is less than or equal to 20, e.g., by using objects, drawings, and equations with a symbol for the unknown number to represent the problem.	34
16	9	1.OA.B.3	Apply properties of operations as strategies to add and subtract.* Examples: If 8 + 3 = 11 is known, then 3 + 8 = 11 is also known. (Commutative property of addition.) To add 2 + 6 + 4, the second two numbers can be added to make a ten, so 2 + 6 + 4 = 2 + 10 = 12. (Associative property of addition.) *Students need not use formal terms for these properties.	37
217	88	K.G.A.3	Identify shapes as two-dimensional (lying in a plane, “flat”) or three- dimensional (“solid”).	475
17	9	1.OA.B.4	Understand subtraction as an unknown-addend problem. For example, subtract 10 – 8 by finding the number that makes 10 when added to 8.	38
18	10	1.OA.C.5	Relate counting to addition and subtraction (e.g., by counting on 2 to add 2).	39
19	10	1.OA.C.6	Add and subtract within 20, demonstrating fluency for addition and subtraction within 10. Use strategies such as counting on; making ten (e.g., 8 + 6 = 8 + 2 + 4 = 10 + 4 = 14); decomposing a number leading to a ten (e.g., 13 – 4 = 13 – 3 – 1 = 10 – 1 = 9); using the relationship between addition and subtraction (e.g., knowing that 8 + 4 = 12, one knows 12 – 8 = 4); and creating equivalent but easier or known sums (e.g., adding 6 + 7 by creating the known equivalent 6 + 6 + 1 = 12 + 1 = 13).	41
20	11	1.OA.D.7	Understand the meaning of the equal sign, and determine if equations involving addition and subtraction are true or false. For example, which of the following equations are true and which are false? 6 = 6, 7 = 8 – 1, 5 + 2 = 2 + 5, 4 + 1 = 5 + 2.	44
21	11	1.OA.D.8	Determine the unknown whole number in an addition or subtraction equation relating three whole numbers. For example, determine the unknown number that makes the equation true in each of the equations 8 + ? = 11, 5 = ? – 3, 6 + 6 = ?.	45
22	12	2.G.A.1	Recognize and draw shapes having specified attributes, such as a given number of angles or a given number of equal faces.* Identify triangles, quadrilaterals, pentagons, hexagons, and cubes. *Sizes are compared directly or visually, not compared by measuring.	46
23	12	2.G.A.2	Partition a rectangle into rows and columns of same-size squares and count to find the total number of them.	47
24	12	2.G.A.3	Partition circles and rectangles into two, three, or four equal shares, describe the shares using the words halves, thirds, half of, a third of, etc., and describe the whole as two halves, three thirds, four fourths. Recognize that equal shares of identical wholes need not have the same shape.	48
25	13	2.MD.A.1	Measure the length of an object by selecting and using appropriate tools such as rulers, yardsticks, meter sticks, and measuring tapes.	49
26	13	2.MD.A.2	Measure the length of an object twice, using length units of different lengths for the two measurements; describe how the two measurements relate to the size of the unit chosen.	50
29	14	2.MD.B.5	Use addition and subtraction within 100 to solve word problems involving lengths that are given in the same units, e.g., by using drawings (such as drawings of rulers) and equations with a symbol for the unknown number to represent the problem.	53
30	14	2.MD.B.6	Represent whole numbers as lengths from 0 on a number line diagram with equally spaced points corresponding to the numbers 0, 1, 2, ..., and represent whole-number sums and differences within 100 on a number line diagram.	55
31	15	2.MD.C.7	Tell and write time from analog and digital clocks to the nearest five minutes, using a.m. and p.m.	56
32	15	2.MD.C.8	Solve word problems involving dollar bills, quarters, dimes, nickels, and pennies, using $ and ¢ symbols appropriately. Example: If you have 2 dimes and 3 pennies, how many cents do you have?	60
33	16	2.MD.D.9	Generate measurement data by measuring lengths of several objects to the nearest whole unit, or by making repeated measurements of the same object. Show the measurements by making a line plot, where the horizontal scale is marked off in whole-number units.	61
34	16	2.MD.D.10	Draw a picture graph and a bar graph (with single-unit scale) to represent a data set with up to four categories. Solve simple put- together, take-apart, and compare problems* using information presented in a bar graph. *See Glossary, Table 1	62
35	17	2.NBT.A.1	Understand that the three digits of a three-digit number represent amounts of hundreds, tens, and ones; e.g., 706 equals 7 hundreds, 0 tens, and 6 ones. Understand the following as special cases:	71
36	17	2.NBT.A.2	Count within 1000; skip-count by 5s, 10s, and 100s.	74
37	17	2.NBT.A.3	Read and write numbers to 1000 using base-ten numerals, number names, and expanded form.	75
38	17	2.NBT.A.4	Compare two three-digit numbers based on meanings of the hundreds, tens, and ones digits, using >, =, and < symbols to record the results of comparisons.	79
39	18	2.NBT.B.5	Fluently add and subtract within 100 using strategies based on place value, properties of operations, and/or the relationship between addition and subtraction.	80
40	18	2.NBT.B.6	Add up to four two-digit numbers using strategies based on place value and properties of operations.	81
41	18	2.NBT.B.7	Add and subtract within 1000, using concrete models or drawings and strategies based on place value, properties of operations, and/or the relationship between addition and subtraction; relate the strategy to a written method. Understand that in adding or subtracting three- digit numbers, one adds or subtracts hundreds and hundreds, tens and tens, ones and ones; and sometimes it is necessary to compose or decompose tens or hundreds.	82
42	18	2.NBT.B.8	Mentally add 10 or 100 to a given number 100–900, and mentally subtract 10 or 100 from a given number 100–900.	83
43	18	2.NBT.B.9	Explain why addition and subtraction strategies work, using place value and the properties of operations.* *Explanations may be supported by drawings or objects.	84
44	19	2.OA.A.1	Use addition and subtraction within 100 to solve one- and two-step word problems involving situations of adding to, taking from, putting together, taking apart, and comparing, with unknowns in all positions, e.g., by using drawings and equations with a symbol for the unknown number to represent the problem.* *See Glossary, Table 1	85
45	20	2.OA.B.2	Fluently add and subtract within 20 using mental strategies.* By end of Grade 2, know from memory all sums of two one-digit numbers. *See standard 1.OA.6 for a list of mental strategies.	87
46	21	2.OA.C.3	Determine whether a group of objects (up to 20) has an odd or even number of members, e.g., by pairing objects or counting them by 2s; write an equation to express an even number as a sum of two equal addends.	88
47	21	2.OA.C.4	Use addition to find the total number of objects arranged in rectangular arrays with up to 5 rows and up to 5 columns; write an equation to express the total as a sum of equal addends.	89
73	33	4.G.A.1	Draw points, lines, line segments, rays, angles (right, acute, obtuse), and perpendicular and parallel lines. Identify these in two-dimensional figures.	144
48	22	3.G.A.1	Understand that shapes in different categories (e.g., rhombuses, rectangles, and others) may share attributes (e.g., having four sides), and that the shared attributes can define a larger category (e.g., quadrilaterals). Recognize rhombuses, rectangles, and squares as examples of quadrilaterals, and draw examples of quadrilaterals that do not belong to any of these subcategories.	90
49	22	3.G.A.2	Partition shapes into parts with equal areas. Express the area of each part as a unit fraction of the whole. For example, partition a shape into 4 parts with equal area, and describe the area of each part as 1/4 of the area of the shape.	91
50	23	3.MD.A.1	Tell and write time to the nearest minute and measure time intervals in minutes. Solve word problems involving addition and subtraction of time intervals in minutes, e.g., by representing the problem on a number line diagram.	92
51	23	3.MD.A.2	Measure and estimate liquid volumes and masses of objects using standard units of grams (g), kilograms (kg), and liters (l).* Add, subtract, multiply, or divide to solve one-step word problems involving masses or volumes that are given in the same units, e.g., by using drawings (such as a beaker with a measurement scale) to represent the problem.** *Excludes compound units such as cm3 and finding the geometric volume of a container.**Excludes multiplicative comparison problems (problems involving notions of “times as much”; see Glossary, Table 2)	93
52	24	3.MD.B.3	Draw a scaled picture graph and a scaled bar graph to represent a data set with several categories. Solve one- and two-step “how many more” and “how many less” problems using information presented in scaled bar graphs. For example, draw a bar graph in which each square in the bar graph might represent 5 pets.	94
53	24	3.MD.B.4	Generate measurement data by measuring lengths using rulers marked with halves and fourths of an inch. Show the data by making a line plot, where the horizontal scale is marked off in appropriate units— whole numbers, halves, or quarters.	96
54	25	3.MD.C.5	Recognize area as an attribute of plane figures and understand concepts of area measurement.	97
55	25	3.MD.C.6	Measure areas by counting unit squares (square cm, square m, square in, square ft, and improvised units).	100
56	25	3.MD.C.7	Relate area to the operations of multiplication and addition.	101
57	26	3.MD.D.8	Solve real world and mathematical problems involving perimeters of polygons, including finding the perimeter given the side lengths, finding an unknown side length, and exhibiting rectangles with the same perimeter and different areas or with the same area and different perimeters.	106
58	27	3.NBT.A.1	Use place value understanding to round whole numbers to the nearest 10 or 100. *A range of algorithms may be used.	107
59	27	3.NBT.A.2	Fluently add and subtract within 1000 using strategies and algorithms based on place value, properties of operations, and/or the relationship between addition and subtraction. *A range of algorithms may be used.	108
60	27	3.NBT.A.3	Multiply one-digit whole numbers by multiples of 10 in the range 10–90 (e.g., 9 × 80, 5 × 60) using strategies based on place value and properties of operations. *A range of algorithms may be used.	110
61	28	3.NF.A.1	Understand a fraction 1/b as the quantity formed by 1 part when a whole is partitioned into b equal parts; understand a fraction a/b as the quantity formed by a parts of size 1/b. *Grade 3 expectations in this domain are limited to fractions with denominators 2, 3, 4, 6, and 8.	111
62	28	3.NF.A.2	Understand a fraction as a number on the number line; represent fractions on a number line diagram. *Grade 3 expectations in this domain are limited to fractions with denominators 2, 3, 4, 6, and 8.	117
63	28	3.NF.A.3	Explain equivalence of fractions in special cases, and compare fractions by reasoning about their size. *Grade 3 expectations in this domain are limited to fractions with denominators 2, 3, 4, 6, and 8.	122
64	29	3.OA.A.1	Interpret products of whole numbers, e.g., interpret 5 × 7 as the total number of objects in 5 groups of 7 objects each. For example, describe a context in which a total number of objects can be expressed as 5 × 7.	131
65	29	3.OA.A.2	Interpret whole-number quotients of whole numbers, e.g., interpret 56 ÷ 8 as the number of objects in each share when 56 objects are partitioned equally into 8 shares, or as a number of shares when 56 objects are partitioned into equal shares of 8 objects each. For example, describe a context in which a number of shares or a number of groups can be expressed as 56 ÷ 8.	132
66	29	3.OA.A.3	Use multiplication and division within 100 to solve word problems in situations involving equal groups, arrays, and measurement quantities, e.g., by using drawings and equations with a symbol for the unknown number to represent the problem.* *See Glossary, Table 2	134
67	29	3.OA.A.4	Determine the unknown whole number in a multiplication or division equation relating three whole numbers. For example, determine the unknown number that makes the equation true in each of the equations 8 × ? = 48, 5 = ? ÷ 3, 6 × 6 = ?.	135
68	30	3.OA.B.5	Apply properties of operations as strategies to multiply and divide.* Examples: If 6 × 4 = 24 is known, then 4 × 6 = 24 is also known. (Commutative property of multiplication.) 3 × 5 × 2 can be found by 3 × 5 = 15, then 15 × 2 = 30, or by 5 × 2 = 10, then 3 × 10 = 30. (Associative property of multiplication.) Knowing that 8 × 5 = 40 and 8 × 2 = 16, one can find 8 × 7 as 8 × (5 + 2) = (8 × 5) + (8 × 2) = 40 + 16 = 56. (Distributive property.) *Students need not use formal terms for these properties.	138
69	30	3.OA.B.6	Understand division as an unknown-factor problem. For example, find 32 ÷ 8 by finding the number that makes 32 when multiplied by 8.	139
70	31	3.OA.C.7	Fluently multiply and divide within 100, using strategies such as the relationship between multiplication and division (e.g., knowing that 8 × 5 = 40, one knows 40 ÷ 5 = 8) or properties of operations. By the end of Grade 3, know from memory all products of two one-digit numbers.	141
71	32	3.OA.D.8	Solve two-step word problems using the four operations. Represent these problems using equations with a letter standing for the unknown quantity. Assess the reasonableness of answers using mental computation and estimation strategies including rounding.* *This standard is limited to problems posed with whole numbers and having wholenumber answers; students should know how to perform operations in the conventional order when there are no parentheses to specify a particular order (Order of Operations).	142
72	32	3.OA.D.9	Identify arithmetic patterns (including patterns in the addition table or multiplication table), and explain them using properties of operations. For example, observe that 4 times a number is always even, and explain why 4 times a number can be decomposed into two equal addends.	143
74	33	4.G.A.2	Classify two-dimensional figures based on the presence or absence of parallel or perpendicular lines, or the presence or absence of angles of a specified size. Recognize right triangles as a category, and identify right triangles.	147
75	33	4.G.A.3	Recognize a line of symmetry for a two-dimensional figure as a line across the figure such that the figure can be folded along the line into matching parts. Identify line-symmetric figures and draw lines of symmetry.	148
76	34	4.MD.A.1	Know relative sizes of measurement units within one system of units including km, m, cm; kg, g; lb, oz.; l, ml; hr, min, sec. Within a single system of measurement, express measurements in a larger unit in terms of a smaller unit. Record measurement equivalents in a two- column table. For example, know that 1 ft is 12 times as long as 1 in. Express the length of a 4 ft snake as 48 in. Generate a conversion table for feet and inches listing the number pairs (1, 12), (2, 24), (3, 36), ...	149
77	34	4.MD.A.2	Use the four operations to solve word problems involving distances, intervals of time, liquid volumes, masses of objects, and money, including problems involving simple fractions or decimals, and problems that require expressing measurements given in a larger unit in terms of a smaller unit. Represent measurement quantities using diagrams such as number line diagrams that feature a measurement scale.	151
78	34	4.MD.A.3	Apply the area and perimeter formulas for rectangles in real world and mathematical problems. For example, find the width of a rectangular room given the area of the flooring and the length, by viewing the area formula as a multiplication equation with an unknown factor.	152
79	35	4.MD.B.4	Make a line plot to display a data set of measurements in fractions of a unit (1/2, 1/4, 1/8). Solve problems involving addition and subtraction of fractions by using information presented in line plots. For example, from a line plot find and interpret the difference in length between the longest and shortest specimens in an insect collection.	154
80	36	4.MD.C.5	Recognize angles as geometric shapes that are formed wherever two rays share a common endpoint, and understand concepts of angle measurement:	155
81	36	4.MD.C.6	Measure angles in whole-number degrees using a protractor. Sketch angles of specified measure.	158
82	36	4.MD.C.7	Recognize angle measure as additive. When an angle is decomposed into non-overlapping parts, the angle measure of the whole is the sum of the angle measures of the parts. Solve addition and subtraction problems to find unknown angles on a diagram in real world and mathematical problems, e.g., by using an equation with a symbol for the unknown angle measure.	159
154	65	6.SP.B.4	Display numerical data in plots on a number line, including dot plots, histograms, and box plots.	302
83	37	4.NBT.A.1	Recognize that in a multi-digit whole number, a digit in one place represents ten times what it represents in the place to its right. For example, recognize that 700 ÷ 70 = 10 by applying concepts of place value and division. *Grade 4 expectations in this domain are limited to whole numbers less than or equal to 1,000,000.	160
84	37	4.NBT.A.2	Read and write multi-digit whole numbers using base-ten numerals, number names, and expanded form. Compare two multi-digit numbers based on meanings of the digits in each place, using >, =, and < symbols to record the results of comparisons. *Grade 4 expectations in this domain are limited to whole numbers less than or equal to 1,000,000.	162
85	37	4.NBT.A.3	Use place value understanding to round multi-digit whole numbers to any place. *Grade 4 expectations in this domain are limited to whole numbers less than or equal to 1,000,000.	163
86	38	4.NBT.B.4	Fluently add and subtract multi-digit whole numbers using the standard algorithm. *Grade 4 expectations in this domain are limited to whole numbers less than or equal to 1,000,000.	165
87	38	4.NBT.B.5	Multiply a whole number of up to four digits by a one-digit whole number, and multiply two two-digit numbers, using strategies based on place value and the properties of operations. Illustrate and explain the calculation by using equations, rectangular arrays, and/or area models. *Grade 4 expectations in this domain are limited to whole numbers less than or equal to 1,000,000.	167
88	38	4.NBT.B.6	Find whole-number quotients and remainders with up to four-digit dividends and one-digit divisors, using strategies based on place value, the properties of operations, and/or the relationship between multiplication and division. Illustrate and explain the calculation by using equations, rectangular arrays, and/or area models. *Grade 4 expectations in this domain are limited to whole numbers less than or equal to 1,000,000.	168
89	39	4.NF.A.1	Explain why a fraction a/b is equivalent to a fraction (n × a)/(n × b) by using visual fraction models, with attention to how the number and size of the parts differ even though the two fractions themselves are the same size. Use this principle to recognize and generate equivalent fractions. *Grade 4 expectations in this domain are limited to fractions with denominators 2, 3, 4, 5, 6, 8, 10, 12, and 100.	170
90	39	4.NF.A.2	Compare two fractions with different numerators and different denominators, e.g., by creating common denominators or numerators, or by comparing to a benchmark fraction such as 1/2. Recognize that comparisons are valid only when the two fractions refer to the same whole. Record the results of comparisons with symbols >, =, or <, and justify the conclusions, e.g., by using a visual fraction model. *Grade 4 expectations in this domain are limited to fractions with denominators 2, 3, 4, 5, 6, 8, 10, 12, and 100.	172
91	40	4.NF.B.3	Understand a fraction a/b with a > 1 as a sum of fractions 1/b. *Grade 4 expectations in this domain are limited to fractions with denominators 2, 3, 4, 5, 6, 8, 10, 12, and 100.	174
92	40	4.NF.B.4	Apply and extend previous understandings of multiplication to multiply a fraction by a whole number. *Grade 4 expectations in this domain are limited to fractions with denominators 2, 3, 4, 5, 6, 8, 10, 12, and 100.	186
93	41	4.NF.C.5	Express a fraction with denominator 10 as an equivalent fraction with denominator 100, and use this technique to add two fractions with respective denominators 10 and 100.* For example, express 3/10 as 30/100, and add 3/10 + 4/100 = 34/100. *Students who can generate equivalent fractions can develop strategies for adding fractions with unlike denominators in general. But addition and subtraction with unlike denominators in general is not a requirement at this grade.**Grade 4 expectations in this domain are limited to fractions with denominators 2, 3, 4, 5, 6, 8, 10, 12, and 100.	190
94	41	4.NF.C.6	Use decimal notation for fractions with denominators 10 or 100. For example, rewrite 0.62 as 62/100; describe a length as 0.62 meters; locate 0.62 on a number line diagram. *Grade 4 expectations in this domain are limited to fractions with denominators 2, 3, 4, 5, 6, 8, 10, 12, and 100.	191
95	41	4.NF.C.7	Compare two decimals to hundredths by reasoning about their size. Recognize that comparisons are valid only when the two decimals refer to the same whole. Record the results of comparisons with the symbols >, =, or <, and justify the conclusions, e.g., by using a visual model. *Grade 4 expectations in this domain are limited to fractions with denominators 2, 3, 4, 5, 6, 8, 10, 12, and 100.	192
96	42	4.OA.A.1	Interpret a multiplication equation as a comparison, e.g., interpret 35 = 5 × 7 as a statement that 35 is 5 times as many as 7 and 7 times as many as 5. Represent verbal statements of multiplicative comparisons as multiplication equations.	193
97	42	4.OA.A.2	Multiply or divide to solve word problems involving multiplicative comparison, e.g., by using drawings and equations with a symbol for the unknown number to represent the problem, distinguishing multiplicative comparison from additive comparison.* *See Glossary, Table 2	194
98	42	4.OA.A.3	Solve multistep word problems posed with whole numbers and having whole-number answers using the four operations, including problems in which remainders must be interpreted. Represent these problems using equations with a letter standing for the unknown quantity. Assess the reasonableness of answers using mental computation and estimation strategies including rounding.	196
99	43	4.OA.B.4	Find all factor pairs for a whole number in the range 1–100. Recognize that a whole number is a multiple of each of its factors. Determine whether a given whole number in the range 1–100 is a multiple of a given one-digit number. Determine whether a given whole number in the range 1–100 is prime or composite.	197
100	44	4.OA.C.5	Generate a number or shape pattern that follows a given rule. Identify apparent features of the pattern that were not explicit in the rule itself. For example, given the rule “Add 3” and the starting number 1, generate terms in the resulting sequence and observe that the terms appear to alternate between odd and even numbers. Explain informally why the numbers will continue to alternate in this way.	198
101	45	5.G.A.1	Use a pair of perpendicular number lines, called axes, to define a coordinate system, with the intersection of the lines (the origin) arranged to coincide with the 0 on each line and a given point in the plane located by using an ordered pair of numbers, called its coordinates. Understand that the first number indicates how far to travel from the origin in the direction of one axis, and the second number indicates how far to travel in the direction of the second axis, with the convention that the names of the two axes and the coordinates correspond (e.g., x-axis and x-coordinate, y-axis and y-coordinate).	199
155	65	6.SP.B.5	Summarize numerical data sets in relation to their context, such as by:	303
102	45	5.G.A.2	Represent real world and mathematical problems by graphing points in the first quadrant of the coordinate plane, and interpret coordinate values of points in the context of the situation.	200
103	46	5.G.B.3	Understand that attributes belonging to a category of two- dimensional figures also belong to all subcategories of that category. For example, all rectangles have four right angles and squares are rectangles, so all squares have four right angles.	201
105	47	5.MD.A.1	Convert among different-sized standard measurement units within a given measurement system (e.g., convert 5 cm to 0.05 m), and use these conversions in solving multi-step, real world problems.	203
159	67	7.EE.B.4	Use variables to represent quantities in a real-world or mathematical problem, and construct simple equations and inequalities to solve problems by reasoning about the quantities.	311
106	48	5.MD.B.2	Make a line plot to display a data set of measurements in fractions of a unit (1/2, 1/4, 1/8). Use operations on fractions for this grade to solve problems involving information presented in line plots. For example, given different measurements of liquid in identical beakers, find the amount of liquid each beaker would contain if the total amount in all the beakers were redistributed equally.	204
107	49	5.MD.C.3	Recognize volume as an attribute of solid figures and understand concepts of volume measurement.	205
108	49	5.MD.C.4	Measure volumes by counting unit cubes, using cubic cm, cubic in, cubic ft, and improvised units.	208
109	49	5.MD.C.5	Relate volume to the operations of multiplication and addition and solve real world and mathematical problems involving volume.	209
110	50	5.NBT.A.1	Recognize that in a multi-digit number, a digit in one place represents 10 times as much as it represents in the place to its right and 1/10 of what it represents in the place to its left.	214
111	50	5.NBT.A.2	Explain patterns in the number of zeros of the product when multiplying a number by powers of 10, and explain patterns in the placement of the decimal point when a decimal is multiplied or divided by a power of 10. Use whole-number exponents to denote powers of 10.	215
112	50	5.NBT.A.3	Read, write, and compare decimals to thousandths.	216
113	50	5.NBT.A.4	Use place value understanding to round decimals to any place.	219
114	51	5.NBT.B.5	Fluently multiply multi-digit whole numbers using the standard algorithm.	220
115	51	5.NBT.B.6	Find whole-number quotients of whole numbers with up to four-digit dividends and two-digit divisors, using strategies based on place value, the properties of operations, and/or the relationship between multiplication and division. Illustrate and explain the calculation by using equations, rectangular arrays, and/or area models.	221
116	51	5.NBT.B.7	Add, subtract, multiply, and divide decimals to hundredths, using concrete models or drawings and strategies based on place value, properties of operations, and/or the relationship between addition and subtraction; relate the strategy to a written method and explain the reasoning used.	222
117	52	5.NF.A.1	Add and subtract fractions with unlike denominators (including mixed numbers) by replacing given fractions with equivalent fractions in such a way as to produce an equivalent sum or difference of fractions with like denominators. For example, 2/3 + 5/4 = 8/12 + 15/12 = 23/12. (In general, a/b + c/d = (ad + bc)/bd.)	224
118	52	5.NF.A.2	Solve word problems involving addition and subtraction of fractions referring to the same whole, including cases of unlike denominators, e.g., by using visual fraction models or equations to represent the problem. Use benchmark fractions and number sense of fractions to estimate mentally and assess the reasonableness of answers. For example, recognize an incorrect result 2/5 + 1/2 = 3/7, by observing that 3/7 < 1/2.	225
143	61	6.NS.B.4	Find the greatest common factor of two whole numbers less than or equal to 100 and the least common multiple of two whole numbers less than or equal to 12. Use the distributive property to express a sum of two whole numbers 1–100 with a common factor as a multiple of a sum of two whole numbers with no common factor. For example, express 36 + 8 as 4 (9 + 2).	275
119	53	5.NF.B.3	Interpret a fraction as division of the numerator by the denominator (a/b = a ÷ b). Solve word problems involving division of whole numbers leading to answers in the form of fractions or mixed numbers, e.g., by using visual fraction models or equations to represent the problem. For example, interpret 3/4 as the result of dividing 3 by 4, noting that 3/4 multiplied by 4 equals 3, and that when 3 wholes are shared equally among 4 people each person has a share of size 3/4. If 9 people want to share a 50-pound sack of rice equally by weight, how many pounds of rice should each person get? Between what two whole numbers does your answer lie?	227
120	53	5.NF.B.4	Apply and extend previous understandings of multiplication to multiply a fraction or whole number by a fraction.	228
121	53	5.NF.B.5	Interpret multiplication as scaling (resizing), by:	232
122	53	5.NF.B.6	Solve real world problems involving multiplication of fractions and mixed numbers, e.g., by using visual fraction models or equations to represent the problem.	239
123	53	5.NF.B.7	Apply and extend previous understandings of division to divide unit fractions by whole numbers and whole numbers by unit fractions.* *Students able to multiply fractions in general can develop strategies to divide fractions in general, by reasoning about the relationship between multiplication and division. But division of a fraction by a fraction is not a requirement at this grade.	240
124	54	5.OA.A.1	Use parentheses, brackets, or braces in numerical expressions, and evaluate expressions with these symbols.	244
125	54	5.OA.A.2	Write simple expressions that record calculations with numbers, and interpret numerical expressions without evaluating them. For example, express the calculation “add 8 and 7, then multiply by 2” as 2 × (8 + 7). Recognize that 3 × (18932 + 921) is three times as large as 18932 + 921, without having to calculate the indicated sum or product.	247
126	55	5.OA.B.3	Generate two numerical patterns using two given rules. Identify apparent relationships between corresponding terms. Form ordered pairs consisting of corresponding terms from the two patterns, and graph the ordered pairs on a coordinate plane. For example, given the rule “Add 3” and the starting number 0, and given the rule “Add 6” and the starting number 0, generate terms in the resulting sequences, and observe that the terms in one sequence are twice the corresponding terms in the other sequence. Explain informally why this is so.	248
127	56	6.EE.A.1	Write and evaluate numerical expressions involving whole-number exponents.	249
128	56	6.EE.A.2	Write, read, and evaluate expressions in which letters stand for numbers.	250
130	56	6.EE.A.4	Identify when two expressions are equivalent (i.e., when the two expressions name the same number regardless of which value is substituted into them). For example, the expressions y + y + y and 3y are equivalent because they name the same number regardless of which number y stands for.	255
131	57	6.EE.B.5	Understand solving an equation or inequality as a process of answering a question: which values from a specified set, if any, make the equation or inequality true? Use substitution to determine whether a given number in a specified set makes an equation or inequality true.	256
132	57	6.EE.B.6	Use variables to represent numbers and write expressions when solving a real-world or mathematical problem; understand that a variable can represent an unknown number, or, depending on the purpose at hand, any number in a specified set.	257
133	57	6.EE.B.7	Solve real-world and mathematical problems by writing and solving equations of the form x + p = q and px = q for cases in which p, q and x are all nonnegative rational numbers.	259
134	57	6.EE.B.8	Write an inequality of the form x > c or x < c to represent a constraint or condition in a real-world or mathematical problem. Recognize that inequalities of the form x > c or x < c have infinitely many solutions; represent solutions of such inequalities on number line diagrams.	260
135	58	6.EE.C.9	Use variables to represent two quantities in a real-world problem that change in relationship to one another; write an equation to express one quantity, thought of as the dependent variable, in terms of the other quantity, thought of as the independent variable. Analyze the relationship between the dependent and independent variables using graphs and tables, and relate these to the equation. For example, in a problem involving motion at constant speed, list and graph ordered pairs of distances and times, and write the equation d = 65t to represent the relationship between distance and time.	261
136	59	6.G.A.1	Find the area of right triangles, other triangles, special quadrilaterals, and polygons by composing into rectangles or decomposing into triangles and other shapes; apply these techniques in the context of solving real-world and mathematical problems.	263
137	59	6.G.A.2	Find the volume of a right rectangular prism with fractional edge lengths by packing it with unit cubes of the appropriate unit fraction edge lengths, and show that the volume is the same as would be found by multiplying the edge lengths of the prism. Apply the formulas V = l w h and V = b h to find volumes of right rectangular prisms with fractional edge lengths in the context of solving real-world and mathematical problems.	265
138	59	6.G.A.3	Draw polygons in the coordinate plane given coordinates for the vertices; use coordinates to find the length of a side joining points with the same first coordinate or the same second coordinate. Apply these techniques in the context of solving real-world and mathematical problems.	266
139	59	6.G.A.4	Represent three-dimensional figures using nets made up of rectangles and triangles, and use the nets to find the surface area of these figures. Apply these techniques in the context of solving real-world and mathematical problems.	267
140	60	6.NS.A.1	Interpret and compute quotients of fractions, and solve word problems involving division of fractions by fractions, e.g., by using visual fraction models and equations to represent the problem. For example, create a story context for (2/3) ÷ (3/4) and use a visual fraction model to show the quotient; use the relationship between multiplication and division to explain that (2/3) ÷ (3/4) = 8/9 because 3/4 of 8/9 is 2/3. (In general, (a/b) ÷ (c/d) = ad/bc.) How much chocolate will each person get if 3 people share 1/2 lb of chocolate equally? How many 3/4-cup servings are in 2/3 of a cup of yogurt? How wide is a rectangular strip of land with length 3/4 mi and area 1/2 square mi?	272
141	61	6.NS.B.2	Fluently divide multi-digit numbers using the standard algorithm.	273
142	61	6.NS.B.3	Fluently add, subtract, multiply, and divide multi-digit decimals using the standard algorithm for each operation.	274
228	93	K.OA.A.4	For any number from 1 to 9, find the number that makes 10 when added to the given number, e.g., by using objects or drawings, and record the answer with a drawing or equation.	494
229	93	K.OA.A.5	Fluently add and subtract within 5.	495
144	62	6.NS.C.5	Understand that positive and negative numbers are used together to describe quantities having opposite directions or values (e.g., temperature above/below zero, elevation above/below sea level, credits/debits, positive/negative electric charge); use positive and negative numbers to represent quantities in real-world contexts, explaining the meaning of 0 in each situation.	276
145	62	6.NS.C.6	Understand a rational number as a point on the number line. Extend number line diagrams and coordinate axes familiar from previous grades to represent points on the line and in the plane with negative number coordinates.	277
146	62	6.NS.C.7	Understand ordering and absolute value of rational numbers.	281
147	62	6.NS.C.8	Solve real-world and mathematical problems by graphing points in all four quadrants of the coordinate plane. Include use of coordinates and absolute value to find distances between points with the same first coordinate or the same second coordinate.	286
148	63	6.RP.A.1	Understand the concept of a ratio and use ratio language to describe a ratio relationship between two quantities. For example, “The ratio of wings to beaks in the bird house at the zoo was 2:1, because for every 2 wings there was 1 beak.” “For every vote candidate A received, candidate C received nearly three votes.”	288
149	63	6.RP.A.2	Understand the concept of a unit rate a/b associated with a ratio a:b with b ≠ 0, and use rate language in the context of a ratio relationship. For example, “This recipe has a ratio of 3 cups of flour to 4 cups of sugar, so there is 3/4 cup of flour for each cup of sugar.” “We paid \\$75 for 15 hamburgers, which is a rate of \\$5 per hamburger."* *Expectations for unit rates in this grade are limited to non-complex fractions.	291
150	63	6.RP.A.3	Use ratio and rate reasoning to solve real-world and mathematical problems, e.g., by reasoning about tables of equivalent ratios, tape diagrams, double number line diagrams, or equations.	294
151	64	6.SP.A.1	Recognize a statistical question as one that anticipates variability in the data related to the question and accounts for it in the answers. For example, “How old am I?” is not a statistical question, but “How old are the students in my school?” is a statistical question because one anticipates variability in students’ ages.	299
152	64	6.SP.A.2	Understand that a set of data collected to answer a statistical question has a distribution which can be described by its center, spread, and overall shape.	300
153	64	6.SP.A.3	Recognize that a measure of center for a numerical data set summarizes all of its values with a single number, while a measure of variation describes how its values vary with a single number.	301
156	66	7.EE.A.1	Apply properties of operations as strategies to add, subtract, factor, and expand linear expressions with rational coefficients.	308
157	66	7.EE.A.2	Understand that rewriting an expression in different forms in a problem context can shed light on the problem and how the quantities in it are related. For example, a + 0.05a = 1.05a means that “increase by 5%” is the same as “multiply by 1.05.”	309
158	67	7.EE.B.3	Solve multi-step real-life and mathematical problems posed with positive and negative rational numbers in any form (whole numbers, fractions, and decimals), using tools strategically. Apply properties of operations to calculate with numbers in any form; convert between forms as appropriate; and assess the reasonableness of answers using mental computation and estimation strategies. For example: If a woman making $25 an hour gets a 10% raise, she will make an additional 1/10 of her salary an hour, or $2.50, for a new salary of $27.50. If you want to place a towel bar 9 3/4 inches long in the center of a door that is 27 1/2 inches wide, you will need to place the bar about 9 inches from each edge; this estimate can be used as a check on the exact computation.	310
160	68	7.G.A.1	Solve problems involving scale drawings of geometric figures, including computing actual lengths and areas from a scale drawing and reproducing a scale drawing at a different scale.	316
161	68	7.G.A.2	Draw (freehand, with ruler and protractor, and with technology) geometric shapes with given conditions. Focus on constructing triangles from three measures of angles or sides, noticing when the conditions determine a unique triangle, more than one triangle, or no triangle.	317
162	68	7.G.A.3	Describe the two-dimensional figures that result from slicing three- dimensional figures, as in plane sections of right rectangular prisms and right rectangular pyramids.	318
163	69	7.G.B.4	Know the formulas for the area and circumference of a circle and use them to solve problems; give an informal derivation of the relationship between the circumference and area of a circle.	321
164	69	7.G.B.5	Use facts about supplementary, complementary, vertical, and adjacent angles in a multi-step problem to write and solve simple equations for an unknown angle in a figure.	322
165	69	7.G.B.6	Solve real-world and mathematical problems involving area, volume and surface area of two- and three-dimensional objects composed of triangles, quadrilaterals, polygons, cubes, and right prisms.	323
166	70	7.NS.A.1	Apply and extend previous understandings of addition and subtraction to add and subtract rational numbers; represent addition and subtraction on a horizontal or vertical number line diagram.	325
167	70	7.NS.A.2	Apply and extend previous understandings of multiplication and division and of fractions to multiply and divide rational numbers.	336
168	70	7.NS.A.3	Solve real-world and mathematical problems involving the four operations with rational numbers.* *Computations with rational numbers extend the rules for manipulating fractions to complex fractions.	349
169	71	7.RP.A.1	Compute unit rates associated with ratios of fractions, including ratios of lengths, areas and other quantities measured in like or different units. For example, if a person walks 1/2 mile in each 1/4 hour, compute the unit rate as the complex fraction 1/2/1/4 miles per hour, equivalently 2 miles per hour.	352
170	71	7.RP.A.2	Recognize and represent proportional relationships between quantities.	355
171	71	7.RP.A.3	Use proportional relationships to solve multistep ratio and percent problems. Examples: simple interest, tax, markups and markdowns, gratuities and commissions, fees, percent increase and decrease, percent error.	363
172	72	7.SP.A.1	Understand that statistics can be used to gain information about a population by examining a sample of the population; generalizations about a population from a sample are valid only if the sample is representative of that population. Understand that random sampling tends to produce representative samples and support valid inferences.	364
173	72	7.SP.A.2	Use data from a random sample to draw inferences about a population with an unknown characteristic of interest. Generate multiple samples (or simulated samples) of the same size to gauge the variation in estimates or predictions. For example, estimate the mean word length in a book by randomly sampling words from the book; predict the winner of a school election based on randomly sampled survey data. Gauge how far off the estimate or prediction might be.	366
174	73	7.SP.B.3	Informally assess the degree of visual overlap of two numerical data distributions with similar variabilities, measuring the difference between the centers by expressing it as a multiple of a measure of variability. For example, the mean height of players on the basketball team is 10 cm greater than the mean height of players on the soccer team, about twice the variability (mean absolute deviation) on either team; on a dot plot, the separation between the two distributions of heights is noticeable.	370
175	73	7.SP.B.4	Use measures of center and measures of variability for numerical data from random samples to draw informal comparative inferences about two populations. For example, decide whether the words in a chapter of a seventh-grade science book are generally longer than the words in a chapter of a fourth-grade science book.	371
176	74	7.SP.C.5	Understand that the probability of a chance event is a number between 0 and 1 that expresses the likelihood of the event occurring. Larger numbers indicate greater likelihood. A probability near 0 indicates an unlikely event, a probability around 1/2 indicates an event that is neither unlikely nor likely, and a probability near 1 indicates a likely event.	373
177	74	7.SP.C.6	Approximate the probability of a chance event by collecting data on the chance process that produces it and observing its long-run relative frequency, and predict the approximate relative frequency given the probability. For example, when rolling a number cube 600 times, predict that a 3 or 6 would be rolled roughly 200 times, but probably not exactly 200 times.	375
178	74	7.SP.C.7	Develop a probability model and use it to find probabilities of events. Compare probabilities from a model to observed frequencies; if the agreement is not good, explain possible sources of the discrepancy.	377
179	74	7.SP.C.8	Find probabilities of compound events using organized lists, tables, tree diagrams, and simulation.	384
180	75	8.EE.A.1	Know and apply the properties of integer exponents to generate equivalent numerical expressions. For example, 32 × 3–5 = 3–3 = 1/33 = 1/27.	394
181	75	8.EE.A.2	Use square root and cube root symbols to represent solutions to equations of the form x2 = p and x3 = p, where p is a positive rational number. Evaluate square roots of small perfect squares and cube roots of small perfect cubes. Know that √2 is irrational.	396
182	75	8.EE.A.3	Use numbers expressed in the form of a single digit times an integer power of 10 to estimate very large or very small quantities, and to express how many times as much one is than the other. For example, estimate the population of the United States as 3 × 108 and the population of the world as 7 × 109, and determine that the world population is more than 20 times larger.	397
183	75	8.EE.A.4	Perform operations with numbers expressed in scientific notation, including problems where both decimal and scientific notation are used. Use scientific notation and choose units of appropriate size for measurements of very large or very small quantities (e.g., use millimeters per year for seafloor spreading). Interpret scientific notation that has been generated by technology.	399
184	76	8.EE.B.5	Graph proportional relationships, interpreting the unit rate as the slope of the graph. Compare two different proportional relationships represented in different ways. For example, compare a distance-time graph to a distance-time equation to determine which of two moving objects has greater speed.	404
185	76	8.EE.B.6	Use similar triangles to explain why the slope m is the same between any two distinct points on a non-vertical line in the coordinate plane; derive the equation y = mx for a line through the origin and the equation y = mx + b for a line intercepting the vertical axis at b.	406
186	77	8.EE.C.7	Solve linear equations in one variable.	408
187	77	8.EE.C.8	Analyze and solve pairs of simultaneous linear equations.	411
188	78	8.F.A.1	Understand that a function is a rule that assigns to each input exactly one output. The graph of a function is the set of ordered pairs consisting of an input and the corresponding output.* *Function notation is not required in Grade 8.	417
189	78	8.F.A.2	Compare properties of two functions each represented in a different way (algebraically, graphically, numerically in tables, or by verbal descriptions). For example, given a linear function represented by a table of values and a linear function represented by an algebraic expression, determine which function has the greater rate of change.	418
190	78	8.F.A.3	Interpret the equation y = mx + b as defining a linear function, whose graph is a straight line; give examples of functions that are not linear. For example, the function A = s2 giving the area of a square as a function of its side length is not linear because its graph contains the points (1,1), (2,4) and (3,9), which are not on a straight line.	419
191	79	8.F.B.4	Construct a function to model a linear relationship between two quantities. Determine the rate of change and initial value of the function from a description of a relationship or from two (x, y) values, including reading these from a table or from a graph. Interpret the rate of change and initial value of a linear function in terms of the situation it models, and in terms of its graph or a table of values.	422
192	79	8.F.B.5	Describe qualitatively the functional relationship between two quantities by analyzing a graph (e.g., where the function is increasing or decreasing, linear or nonlinear). Sketch a graph that exhibits the qualitative features of a function that has been described verbally.	424
193	80	8.G.A.1	Verify experimentally the properties of rotations, reflections, and translations:	425
194	80	8.G.A.2	Understand that a two-dimensional figure is congruent to another if the second can be obtained from the first by a sequence of rotations, reflections, and translations; given two congruent figures, describe a sequence that exhibits the congruence between them.	429
195	80	8.G.A.3	Describe the effect of dilations, translations, rotations, and reflections on two-dimensional figures using coordinates.	431
196	80	8.G.A.4	Understand that a two-dimensional figure is similar to another if the second can be obtained from the first by a sequence of rotations, reflections, translations, and dilations; given two similar two- dimensional figures, describe a sequence that exhibits the similarity between them.	432
197	80	8.G.A.5	Use informal arguments to establish facts about the angle sum and exterior angle of triangles, about the angles created when parallel lines are cut by a transversal, and the angle-angle criterion for similarity of triangles. For example, arrange three copies of the same triangle so that the sum of the three angles appears to form a line, and give an argument in terms of transversals why this is so.	436
198	81	8.G.B.6	Explain a proof of the Pythagorean Theorem and its converse.	437
199	81	8.G.B.7	Apply the Pythagorean Theorem to determine unknown side lengths in right triangles in real-world and mathematical problems in two and three dimensions.	440
200	81	8.G.B.8	Apply the Pythagorean Theorem to find the distance between two points in a coordinate system.	441
201	82	8.G.C.9	Know the formulas for the volumes of cones, cylinders, and spheres and use them to solve real-world and mathematical problems.	442
202	83	8.NS.A.1	Know that numbers that are not rational are called irrational. Understand informally that every number has a decimal expansion; for rational numbers show that the decimal expansion repeats eventually, and convert a decimal expansion which repeats eventually into a rational number.	443
203	83	8.NS.A.2	Use rational approximations of irrational numbers to compare the size of irrational numbers, locate them approximately on a number line diagram, and estimate the value of expressions (e.g., √2). For example, by truncating the decimal expansion of √2, show that √2 is between 1 and 2, then between 1.4 and 1.5, and explain how to continue on to get better approximations.	445
204	84	8.SP.A.1	Construct and interpret scatter plots for bivariate measurement data to investigate patterns of association between two quantities. Describe patterns such as clustering, outliers, positive or negative association, linear association, and nonlinear association.	448
205	84	8.SP.A.2	Know that straight lines are widely used to model relationships between two quantitative variables. For scatter plots that suggest a linear association, informally fit a straight line, and informally assess the model fit by judging the closeness of the data points to the line.	451
206	84	8.SP.A.3	Use the equation of a linear model to solve problems in the context of bivariate measurement data, interpreting the slope and intercept. For example, in a linear model for a biology experiment, interpret a slope of 1.5 cm/hr as meaning that an additional hour of sunlight each day is associated with an additional 1.5 cm in mature plant height.	453
207	84	8.SP.A.4	Understand that patterns of association can also be seen in bivariate categorical data by displaying frequencies and relative frequencies in a two-way table. Construct and interpret a two-way table summarizing data on two categorical variables collected from the same subjects. Use relative frequencies calculated for rows or columns to describe possible association between the two variables. For example, collect data from students in your class on whether or not they have a curfew on school nights and whether or not they have assigned chores at home. Is there evidence that those who have a curfew also tend to have chores?	455
208	85	K.CC.A.1	Count to 100 by ones and by tens.	456
209	85	K.CC.A.2	Count forward beginning from a given number within the known sequence (instead of having to begin at 1).	460
210	85	K.CC.A.3	Write numbers from 0 to 20. Represent a number of objects with a written numeral 0-20 (with 0 representing a count of no objects).	464
211	86	K.CC.B.4	Understand the relationship between numbers and quantities; connect counting to cardinality.	466
212	86	K.CC.B.5	Count to answer “how many?” questions about as many as 20 things arranged in a line, a rectangular array, or a circle, or as many as 10 things in a scattered configuration; given a number from 1–20, count out that many objects.	470
213	87	K.CC.C.6	Identify whether the number of objects in one group is greater than, less than, or equal to the number of objects in another group, e.g., by using matching and counting strategies.* * Include groups with up to ten objects.	471
214	87	K.CC.C.7	Compare two numbers between 1 and 10 presented as written numerals.	472
215	88	K.G.A.1	Describe objects in the environment using names of shapes, and describe the relative positions of these objects using terms such as above, below, beside, in front of, behind, and next to.	473
216	88	K.G.A.2	Correctly name shapes regardless of their orientations or overall size.	474
218	89	K.G.B.4	Analyze and compare two- and three-dimensional shapes, in different sizes and orientations, using informal language to describe their similarities, differences, parts (e.g., number of sides and vertices/“corners”) and other attributes (e.g., having sides of equal length).	476
219	89	K.G.B.5	Model shapes in the world by building shapes from components (e.g., sticks and clay balls) and drawing shapes.	477
220	89	K.G.B.6	Compose simple shapes to form larger shapes. For example, “Can you join these two triangles with full sides touching to make a rectangle?”	478
221	90	K.MD.A.1	Describe measurable attributes of objects, such as length or weight. Describe several measurable attributes of a single object.	479
222	90	K.MD.A.2	Directly compare two objects with a measurable attribute in common, to see which object has “more of”/“less of” the attribute, and describe the difference. For example, directly compare the heights of two children and describe one child as taller/shorter.	483
223	91	K.MD.B.3	Classify objects into given categories; count the numbers of objects in each category and sort the categories by count.* *Limit category counts to be less than or equal to 10.	485
224	92	K.NBT.A.1	Compose and decompose numbers from 11 to 19 into ten ones and some further ones, e.g., by using objects or drawings, and record each composition or decomposition by a drawing or equation (e.g., 18 = 10 + 8); understand that these numbers are composed of ten ones and one, two, three, four, five, six, seven, eight, or nine ones.	486
225	93	K.OA.A.1	Represent addition and subtraction with objects, fingers, mental images, drawings*, sounds (e.g., claps), acting out situations, verbal explanations, expressions, or equations. *Drawings need not show details, but should show the mathematics in the problem. (This applies wherever drawings are mentioned in the Standards.)	487
226	93	K.OA.A.2	Solve addition and subtraction word problems, and add and subtract within 10, e.g., by using objects or drawings to represent the problem.	489
227	93	K.OA.A.3	Decompose numbers less than or equal to 10 into pairs in more than one way, e.g., by using objects or drawings, and record each decomposition by a drawing or equation (e.g., 5 = 2 + 3 and 5 = 4 + 1).	493
\.


--
-- Data for Name: tempmatching; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tempmatching (tabid, stadid, standcode) FROM stdin;
1	159	4.MD.C.7
2	257	6.EE.B.6
3	605	HS.G-MG.A.2
4	408	8.EE.C.7
5	211	5.MD.C.5.b
6	357	7.RP.A.2.b
7	259	6.EE.B.7
8	655	HS.S-CP.A.4
9	196	4.OA.A.3
10	504	HS.A-CED.A.2
11	599	HS.G-GPE.A.3
12	217	5.NBT.A.3.a
13	283	6.NS.C.7.b
14	440	8.G.B.7
15	191	4.NF.C.6
16	558	HS.F-LE.A.1
17	366	7.SP.A.2
18	174	4.NF.B.3
19	186	4.NF.B.4
20	311	7.EE.B.4
21	473	K.G.A.1
22	661	HS.S-IC.A.1
23	671	HS.S-ID.B.5
24	117	3.NF.A.2
25	547	HS.F-IF.B.6
26	616	HS.G-SRT.C.8
27	275	6.NS.B.4
28	610	HS.G-SRT.A.2
29	477	K.G.B.5
30	678	HS.S-ID.C.9
31	34	1.OA.A.2
32	247	5.OA.A.2
33	225	5.NF.A.2
34	347	7.NS.A.2.d
35	317	7.G.A.2
36	309	7.EE.A.2
37	418	8.F.A.2
38	222	5.NBT.B.7
39	590	HS.G-CO.C.9
40	568	HS.F-TF.A.3
41	60	2.MD.C.8
42	105	3.MD.C.7.d
43	281	6.NS.C.7
44	46	2.G.A.1
45	88	2.OA.C.3
46	82	2.NBT.B.7
47	375	7.SP.C.6
48	394	8.EE.A.1
49	102	3.MD.C.7.a
50	6	1.G.A.1
51	168	4.NBT.B.6
52	189	4.NF.B.4.c
53	464	K.CC.A.3
54	11	1.MD.A.2
55	20	1.NBT.B.2.c
56	272	6.NS.A.1
57	8	1.G.A.3
58	469	K.CC.B.4.c
59	531	HS.F-BF.A.1.a
60	466	K.CC.B.4
61	321	7.G.B.4
62	143	3.OA.D.9
63	339	7.NS.A.2.a
64	442	8.G.C.9
65	208	5.MD.C.4
66	224	5.NF.A.1
67	73	2.NBT.A.1.b
68	119	3.NF.A.2.a
69	448	8.SP.A.1
70	79	2.NBT.A.4
71	352	7.RP.A.1
72	526	HS.A-SSE.B.3.a
73	475	K.G.A.3
74	604	HS.G-MG.A.1
75	165	4.NBT.B.4
76	185	4.NF.B.3.d
77	436	8.G.A.5
78	371	7.SP.B.4
79	267	6.G.A.4
80	470	K.CC.B.5
81	206	5.MD.C.3.a
82	110	3.NBT.A.3
83	214	5.NBT.A.1
84	193	4.OA.A.1
85	250	6.EE.A.2
86	248	5.OA.B.3
87	485	K.MD.B.3
88	103	3.MD.C.7.b
89	89	2.OA.C.4
90	209	5.MD.C.5
91	580	HS.G-CO.A.1
92	227	5.NF.B.3
93	278	6.NS.C.6.a
94	428	8.G.A.1.c
95	468	K.CC.B.4.b
96	303	6.SP.B.5
97	388	7.SP.C.8.a
98	155	4.MD.C.5
99	163	4.NBT.A.3
100	192	4.NF.C.7
101	239	5.NF.B.6
102	396	8.EE.A.2
103	476	K.G.B.4
104	142	3.OA.D.8
105	304	6.SP.B.5.a
106	121	3.NF.A.2.b
107	84	2.NBT.B.9
108	50	2.MD.A.2
109	134	3.OA.A.3
110	307	6.SP.B.5.d
111	7	1.G.A.2
112	17	1.NBT.B.2
113	147	4.G.A.2
114	279	6.NS.C.6.b
115	254	6.EE.A.3
116	182	4.NF.B.3.c
117	296	6.RP.A.3.b
118	583	HS.G-CO.A.4
119	219	5.NBT.A.4
120	97	3.MD.C.5
121	664	HS.S-IC.B.4
122	621	HS.N-CN.A.2
123	48	2.G.A.3
124	242	5.NF.B.7.b
125	611	HS.G-SRT.A.3
126	443	8.NS.A.1
127	445	8.NS.A.2
128	356	7.RP.A.2.a
129	202	5.G.B.4
130	587	HS.G-CO.B.8
131	98	3.MD.C.5.a
132	255	6.EE.A.4
133	170	4.NF.A.1
134	632	HS.N-RN.A.1
135	541	HS.F-BF.B.5
136	478	K.G.B.6
137	172	4.NF.A.2
138	675	HS.S-ID.B.6.c
139	581	HS.G-CO.A.2
140	573	HS.F-TF.C.8
141	318	7.G.A.3
142	244	5.OA.A.1
143	358	7.RP.A.2.c
144	106	3.MD.D.8
145	151	4.MD.A.2
146	474	K.G.A.2
147	669	HS.S-ID.A.3
148	160	4.NBT.A.1
149	162	4.NBT.A.2
150	556	HS.F-IF.C.8.b
151	472	K.CC.C.7
152	149	4.MD.A.1
153	312	7.EE.B.4.a
154	71	2.NBT.A.1
155	23	1.NBT.C.5
156	364	7.SP.A.1
157	509	HS.A-REI.B.3
158	305	6.SP.B.5.b
159	342	7.NS.A.2.b
160	91	3.G.A.2
161	125	3.NF.A.3.b
162	427	8.G.A.1.b
163	138	3.OA.B.5
164	44	1.OA.D.7
165	39	1.OA.C.5
166	422	8.F.B.4
167	154	4.MD.B.4
168	579	HS.G-C.B.5
169	228	5.NF.B.4
170	234	5.NF.B.5.b
171	676	HS.S-ID.C.7
172	326	7.NS.A.1.a
173	148	4.G.A.3
174	456	K.CC.A.1
175	200	5.G.A.2
176	38	1.OA.B.4
177	316	7.G.A.1
178	282	6.NS.C.7.a
179	72	2.NBT.A.1.a
180	406	8.EE.B.6
181	212	5.MD.C.5.c
182	493	K.OA.A.3
183	207	5.MD.C.3.b
184	16	1.NBT.A.1
185	233	5.NF.B.5.a
186	487	K.OA.A.1
187	240	5.NF.B.7
188	33	1.OA.A.1
189	210	5.MD.C.5.a
190	425	8.G.A.1
191	600	HS.G-GPE.B.4
192	157	4.MD.C.5.b
193	393	7.SP.C.8.c
194	310	7.EE.B.3
195	419	8.F.A.3
196	486	K.NBT.A.1
197	291	6.RP.A.2
198	404	8.EE.B.5
199	471	K.CC.C.6
200	412	8.EE.C.8.a
201	216	5.NBT.A.3
202	158	4.MD.C.6
203	409	8.EE.C.7.a
204	62	2.MD.D.10
205	667	HS.S-ID.A.1
206	534	HS.F-BF.A.2
207	74	2.NBT.A.2
208	139	3.OA.B.6
209	201	5.G.B.3
210	135	3.OA.A.4
211	204	5.MD.B.2
212	323	7.G.B.6
213	677	HS.S-ID.C.8
214	280	6.NS.C.6.c
215	593	HS.G-GMD.A.1
216	251	6.EE.A.2.a
217	197	4.OA.B.4
218	93	3.MD.A.2
219	61	2.MD.D.9
220	221	5.NBT.B.6
221	502	HS.A-APR.D.7
222	298	6.RP.A.3.d
223	256	6.EE.B.5
224	619	HS.G-SRT.D.9
225	606	HS.G-MG.A.3
226	557	HS.F-IF.C.9
227	52	2.MD.A.4
228	252	6.EE.A.2.b
229	562	HS.F-LE.A.2
230	263	6.G.A.1
231	141	3.OA.C.7
232	595	HS.G-GMD.A.3
233	156	4.MD.C.5.a
234	437	8.G.B.6
235	229	5.NF.B.4.a
236	513	HS.A-REI.C.5
237	104	3.MD.C.7.c
238	614	HS.G-SRT.C.6
239	594	HS.G-GMD.A.2
240	56	2.MD.C.7
241	198	4.OA.C.5
242	220	5.NBT.B.5
243	699	HS.S-IC.B.3
244	205	5.MD.C.3
245	511	HS.A-REI.B.4.a
246	607	HS.G-SRT.A.1
247	507	HS.A-REI.A.1
248	53	2.MD.B.5
249	483	K.MD.A.2
250	128	3.NF.A.3.c
251	373	7.SP.C.5
252	455	8.SP.A.4
253	41	1.OA.C.6
254	653	HS.S-CP.A.2
255	467	K.CC.B.4.a
256	489	K.OA.A.2
257	596	HS.G-GMD.B.4
258	662	HS.S-IC.A.2
259	612	HS.G-SRT.B.4
260	295	6.RP.A.3.a
261	417	8.F.A.1
262	411	8.EE.C.8
263	306	6.SP.B.5.c
264	397	8.EE.A.3
265	355	7.RP.A.2
266	47	2.G.A.2
267	18	1.NBT.B.2.a
268	107	3.NBT.A.1
269	652	HS.S-CP.A.1
270	325	7.NS.A.1
271	382	7.SP.C.7.b
272	359	7.RP.A.2.d
273	518	HS.A-REI.D.10
274	265	6.G.A.2
275	94	3.MD.B.3
276	527	HS.A-SSE.B.3.b
277	187	4.NF.B.4.a
278	424	8.F.B.5
279	391	7.SP.C.8.b
280	55	2.MD.B.6
281	96	3.MD.B.4
282	322	7.G.B.5
283	83	2.NBT.B.8
284	294	6.RP.A.3
285	152	4.MD.A.3
286	101	3.MD.C.7
287	555	HS.F-IF.C.8.a
288	24	1.NBT.C.6
289	598	HS.G-GPE.A.2
290	218	5.NBT.A.3.b
291	451	8.SP.A.2
292	144	4.G.A.1
293	99	3.MD.C.5.b
294	588	HS.G-CO.C.10
295	37	1.OA.B.3
296	503	HS.A-CED.A.1
297	494	K.OA.A.4
298	49	2.MD.A.1
299	9	1.MD.A.1
300	199	5.G.A.1
301	668	HS.S-ID.A.2
302	545	HS.F-IF.B.4
303	380	7.SP.C.7.a
304	597	HS.G-GPE.A.1
305	167	4.NBT.B.5
306	111	3.NF.A.1
307	286	6.NS.C.8
308	75	2.NBT.A.3
309	266	6.G.A.3
310	528	HS.A-SSE.B.3.c
311	92	3.MD.A.1
312	414	8.EE.C.8.c
313	260	6.EE.B.8
314	308	7.EE.A.1
315	123	3.NF.A.3.a
316	515	HS.A-REI.C.7
317	90	3.G.A.1
318	108	3.NBT.A.2
319	253	6.EE.A.2.c
320	496	HS.A-APR.A.1
321	132	3.OA.A.2
322	349	7.NS.A.3
323	413	8.EE.C.8.b
324	495	K.OA.A.5
325	506	HS.A-CED.A.4
326	190	4.NF.C.5
327	542	HS.F-IF.A.1
328	80	2.NBT.B.5
329	336	7.NS.A.2
330	479	K.MD.A.1
331	441	8.G.B.8
332	176	4.NF.B.3.a
333	426	8.G.A.1.a
334	330	7.NS.A.1.c
335	601	HS.G-GPE.B.5
336	666	HS.S-IC.B.6
337	130	3.NF.A.3.d
338	313	7.EE.B.4.b
339	100	3.MD.C.6
340	432	8.G.A.4
341	299	6.SP.A.1
342	591	HS.G-CO.D.12
343	274	6.NS.B.3
344	333	7.NS.A.1.d
345	670	HS.S-ID.A.4
346	13	1.MD.C.4
347	377	7.SP.C.7
348	243	5.NF.B.7.c
349	460	K.CC.A.2
350	285	6.NS.C.7.d
351	603	HS.G-GPE.B.7
352	363	7.RP.A.3
353	370	7.SP.B.3
354	327	7.NS.A.1.b
355	179	4.NF.B.3.b
356	300	6.SP.A.2
357	585	HS.G-CO.B.6
358	563	HS.F-LE.A.3
359	288	6.RP.A.1
360	505	HS.A-CED.A.3
361	277	6.NS.C.6
362	276	6.NS.C.5
363	565	HS.F-LE.B.5
364	524	HS.A-SSE.A.2
365	12	1.MD.B.3
366	634	HS.N-RN.B.3
367	19	1.NBT.B.2.b
368	429	8.G.A.2
369	453	8.SP.A.3
370	674	HS.S-ID.B.6.b
371	131	3.OA.A.1
372	521	HS.A-SSE.A.1
373	297	6.RP.A.3.c
374	122	3.NF.A.3
375	384	7.SP.C.8
376	657	HS.S-CP.B.6
377	520	HS.A-REI.D.12
378	203	5.MD.A.1
379	301	6.SP.A.3
380	284	6.NS.C.7.c
381	215	5.NBT.A.2
382	87	2.OA.B.2
383	188	4.NF.B.4.b
384	273	6.NS.B.2
385	584	HS.G-CO.A.5
386	431	8.G.A.3
387	81	2.NBT.B.6
388	514	HS.A-REI.C.6
389	399	8.EE.A.4
390	410	8.EE.C.7.b
391	51	2.MD.A.3
392	232	5.NF.B.5
393	665	HS.S-IC.B.5
394	230	5.NF.B.4.b
395	21	1.NBT.B.3
396	629	HS.N-Q.A.1
397	85	2.OA.A.1
398	261	6.EE.C.9
399	22	1.NBT.C.4
400	45	1.OA.D.8
401	345	7.NS.A.2.c
402	249	6.EE.A.1
403	512	HS.A-REI.B.4.b
404	302	6.SP.B.4
405	194	4.OA.A.2
406	241	5.NF.B.7.a
407	625	HS.N-CN.B.6
408	630	HS.N-Q.A.2
409	615	HS.G-SRT.C.7
410	592	HS.G-CO.D.13
411	546	HS.F-IF.B.5
412	694	HS.F-LE.A.1.a
413	501	HS.A-APR.D.6
414	553	HS.F-IF.C.7.e
415	602	HS.G-GPE.B.6
416	697	HS.G-SRT.A.1.a
417	536	HS.F-BF.B.4
418	658	HS.S-CP.B.7
419	628	HS.N-CN.C.9
420	572	HS.F-TF.B.7
421	550	HS.F-IF.C.7.b
422	693	HS.F-BF.B.4.d
423	532	HS.F-BF.A.1.b
424	499	HS.A-APR.C.4
425	589	HS.G-CO.C.11
426	690	HS.F-BF.B.4.a
427	548	HS.F-IF.C.7
428	617	HS.G-SRT.D.10
429	549	HS.F-IF.C.7.a
430	656	HS.S-CP.A.5
431	692	HS.F-BF.B.4.c
432	695	HS.F-LE.A.1.b
433	508	HS.A-REI.A.2
434	624	HS.N-CN.B.5
435	622	HS.N-CN.A.3
436	698	HS.G-SRT.A.1.b
437	564	HS.F-LE.A.4
438	654	HS.S-CP.A.3
439	631	HS.N-Q.A.3
440	500	HS.A-APR.C.5
441	510	HS.A-REI.B.4
442	688	HS.A-SSE.A.1.a
443	689	HS.A-SSE.A.1.b
444	696	HS.F-LE.A.1.c
445	571	HS.F-TF.B.6
446	586	HS.G-CO.B.7
447	551	HS.F-IF.C.7.c
448	672	HS.S-ID.B.6
449	660	HS.S-CP.B.9
450	627	HS.N-CN.C.8
451	582	HS.G-CO.A.3
452	577	HS.G-C.A.3
453	620	HS.N-CN.A.1
454	575	HS.G-C.A.1
455	576	HS.G-C.A.2
456	498	HS.A-APR.B.3
457	570	HS.F-TF.B.5
458	613	HS.G-SRT.B.5
459	569	HS.F-TF.A.4
460	623	HS.N-CN.B.4
461	552	HS.F-IF.C.7.d
462	543	HS.F-IF.A.2
463	567	HS.F-TF.A.2
464	554	HS.F-IF.C.8
465	691	HS.F-BF.B.4.b
466	535	HS.F-BF.B.3
467	673	HS.S-ID.B.6.a
468	659	HS.S-CP.B.8
469	626	HS.N-CN.C.7
470	574	HS.F-TF.C.9
471	578	HS.G-C.A.4
472	633	HS.N-RN.A.2
473	497	HS.A-APR.B.2
474	544	HS.F-IF.A.3
475	529	HS.A-SSE.B.4
476	566	HS.F-TF.A.1
477	618	HS.G-SRT.D.11
478	530	HS.F-BF.A.1
479	519	HS.A-REI.D.11
480	525	HS.A-SSE.B.3
\.


--
-- Name: childstandards_childstandardid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.childstandards_childstandardid_seq', 88, true);


--
-- Name: clusters_clusterid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clusters_clusterid_seq', 142, true);


--
-- Name: domains_domainid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.domains_domainid_seq', 63, true);


--
-- Name: grades_gradeid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grades_gradeid_seq', 15, true);


--
-- Name: standards_standardid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.standards_standardid_seq', 1233, true);


--
-- Name: tempmatching_tabid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tempmatching_tabid_seq', 480, true);


--
-- Name: childstandards childstandards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.childstandards
    ADD CONSTRAINT childstandards_pkey PRIMARY KEY (childstandardid);


--
-- Name: clusters clusters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clusters
    ADD CONSTRAINT clusters_pkey PRIMARY KEY (clusterid);


--
-- Name: domains domains_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.domains
    ADD CONSTRAINT domains_pkey PRIMARY KEY (domainid);


--
-- Name: grades grades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_pkey PRIMARY KEY (gradeid);


--
-- Name: standarddependencies standarddependencies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.standarddependencies
    ADD CONSTRAINT standarddependencies_pkey PRIMARY KEY (standardid, prerequisitestandardid);


--
-- Name: standards standards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.standards
    ADD CONSTRAINT standards_pkey PRIMARY KEY (standardid);


--
-- Name: tempmatching tempmatching_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tempmatching
    ADD CONSTRAINT tempmatching_pkey PRIMARY KEY (tabid);


--
-- Name: childstandards childstandards_parentstandardid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.childstandards
    ADD CONSTRAINT childstandards_parentstandardid_fkey FOREIGN KEY (parentstandardid) REFERENCES public.standards(standardid) ON DELETE CASCADE;


--
-- Name: clusters clusters_domainid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clusters
    ADD CONSTRAINT clusters_domainid_fkey FOREIGN KEY (domainid) REFERENCES public.domains(domainid) ON DELETE CASCADE;


--
-- Name: domains domains_gradeid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.domains
    ADD CONSTRAINT domains_gradeid_fkey FOREIGN KEY (gradeid) REFERENCES public.grades(gradeid) ON DELETE CASCADE;


--
-- Name: standarddependencies standarddependencies_prerequisitestandardid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.standarddependencies
    ADD CONSTRAINT standarddependencies_prerequisitestandardid_fkey FOREIGN KEY (prerequisitestandardid) REFERENCES public.standards(standardid);


--
-- Name: standarddependencies standarddependencies_standardid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.standarddependencies
    ADD CONSTRAINT standarddependencies_standardid_fkey FOREIGN KEY (standardid) REFERENCES public.standards(standardid);


--
-- Name: standards standards_clusterid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.standards
    ADD CONSTRAINT standards_clusterid_fkey FOREIGN KEY (clusterid) REFERENCES public.clusters(clusterid) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

