--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: category_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE category_type AS ENUM (
    'Art Gallery',
    'Historic Site',
    'Museum',
    'Music Venue',
    'Performing Arts Venue',
    'Zoo',
    'Beach',
    'Garden',
    'Plaza',
    'Religious/Spiritual',
    'National Parks'
);


--
-- Name: entry_point_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE entry_point_type AS ENUM (
    'airport',
    'railway'
);


--
-- Name: local_transport_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE local_transport_type AS ENUM (
    'metro',
    'bus'
);


--
-- Name: role_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE role_type AS ENUM (
    'reader',
    'writer'
);


--
-- Name: my_trigger_function(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION my_trigger_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		BEGIN
		IF NOT EXISTS(
			  	select count(*) from map_points as m1,map_points as m2,state_bounded_bies as s  					
	  			where  					
	  			(m1.id=NEW.top_left_corner_id and NEW.state_id=s.id and m2.id=s.top_left_corner_id and m1.latitude>m2.latitude and m1.longitude < m2.longitude)
	  			and  					
	  			(m1.id=NEW.right_bottom_corner_id and NEW.state_id=s.id and m2.id=s.right_bottom_corner_id and m1.latitude<m2.latitude and m1.longitude > m2.longitude)
			  ) 
		THEN RETURN NULL;
		  END IF;

		
		  RETURN NEW;
		END$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: buddies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE buddies (
    id integer NOT NULL,
    friend_id integer,
    tourist_spot_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: buddies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE buddies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: buddies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE buddies_id_seq OWNED BY buddies.id;


--
-- Name: closer_tos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE closer_tos (
    id integer NOT NULL,
    local_transport_stand_id integer,
    tourist_spot_id integer,
    distance integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT distancecheck2 CHECK ((distance >= 0))
);


--
-- Name: closer_tos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE closer_tos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: closer_tos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE closer_tos_id_seq OWNED BY closer_tos.id;


--
-- Name: closest_hotels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE closest_hotels (
    id integer NOT NULL,
    entry_point_id integer,
    hotel_id integer,
    distance integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT distancecheck4 CHECK ((distance >= 0))
);


--
-- Name: closest_hotels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE closest_hotels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: closest_hotels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE closest_hotels_id_seq OWNED BY closest_hotels.id;


--
-- Name: district_bounded_bies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE district_bounded_bies (
    id integer NOT NULL,
    state_id integer,
    district_id integer,
    top_left_corner_id integer,
    bottom_right_corner_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: district_bounded_bies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE district_bounded_bies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: district_bounded_bies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE district_bounded_bies_id_seq OWNED BY district_bounded_bies.id;


--
-- Name: districts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE districts (
    id integer NOT NULL,
    state_id integer,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: districts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE districts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: districts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE districts_id_seq OWNED BY districts.id;


--
-- Name: entry_points; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE entry_points (
    id integer NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    name character varying(255) NOT NULL,
    "districtName" character varying(255) NOT NULL,
    "stateName" character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    "entryType" entry_point_type,
    gmaps boolean
);


--
-- Name: entry_points_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE entry_points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: entry_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE entry_points_id_seq OWNED BY entry_points.id;


--
-- Name: hotels; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hotels (
    id integer NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    "districtName" character varying(255) NOT NULL,
    "stateName" character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    gmaps boolean
);


--
-- Name: hotels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hotels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hotels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hotels_id_seq OWNED BY hotels.id;


--
-- Name: in_proximity_ofs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE in_proximity_ofs (
    id integer NOT NULL,
    hotel_id integer,
    tourist_spot_id integer,
    distance integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT distancecheck1 CHECK ((distance >= 0))
);


--
-- Name: in_proximity_ofs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE in_proximity_ofs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: in_proximity_ofs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE in_proximity_ofs_id_seq OWNED BY in_proximity_ofs.id;


--
-- Name: local_transport_stands; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE local_transport_stands (
    id integer NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    name character varying(255) NOT NULL,
    "districtName" character varying(255) NOT NULL,
    "stateName" character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    "localTransport" local_transport_type,
    gmaps boolean
);


--
-- Name: local_transport_stands_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE local_transport_stands_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: local_transport_stands_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE local_transport_stands_id_seq OWNED BY local_transport_stands.id;


--
-- Name: map_points; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE map_points (
    id integer NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    "districtName" character varying(255),
    "stateName" character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: map_points_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE map_points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: map_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE map_points_id_seq OWNED BY map_points.id;


--
-- Name: near_bies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE near_bies (
    id integer NOT NULL,
    hotel_id integer,
    local_transport_stand_id integer,
    distance integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT distancecheck3 CHECK ((distance >= 0))
);


--
-- Name: near_bies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE near_bies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: near_bies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE near_bies_id_seq OWNED BY near_bies.id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE reviews (
    id integer NOT NULL,
    user_id integer,
    tourist_spot_id integer,
    review text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    rating double precision,
    CONSTRAINT reviewratingchk CHECK (((rating >= (0)::double precision) AND (rating <= (10)::double precision)))
);


--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reviews_id_seq OWNED BY reviews.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: state_bounded_bies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE state_bounded_bies (
    id integer NOT NULL,
    state_id integer,
    top_left_corner_id integer,
    bottom_right_corner_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: state_bounded_bies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE state_bounded_bies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: state_bounded_bies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE state_bounded_bies_id_seq OWNED BY state_bounded_bies.id;


--
-- Name: states; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE states (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying(255) NOT NULL
);


--
-- Name: states_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE states_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: states_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE states_id_seq OWNED BY states.id;


--
-- Name: tourist_spots; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tourist_spots (
    id integer NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    name character varying(255) NOT NULL,
    rating double precision,
    description text,
    "districtName" character varying(255) NOT NULL,
    "stateName" character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    category category_type,
    gmaps boolean,
    CONSTRAINT ratingchk CHECK (((rating >= (0)::double precision) AND (rating <= (10)::double precision)))
);


--
-- Name: tourist_spots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tourist_spots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tourist_spots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tourist_spots_id_seq OWNED BY tourist_spots.id;


--
-- Name: trips; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trips (
    id integer NOT NULL,
    user_id integer,
    tourist_spot_id integer,
    "startDate" date NOT NULL,
    "dayNumber" integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: trips_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE trips_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trips_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE trips_id_seq OWNED BY trips.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    role role_type,
    password_hash character varying(255),
    password_salt character varying(255)
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY buddies ALTER COLUMN id SET DEFAULT nextval('buddies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY closer_tos ALTER COLUMN id SET DEFAULT nextval('closer_tos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY closest_hotels ALTER COLUMN id SET DEFAULT nextval('closest_hotels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY district_bounded_bies ALTER COLUMN id SET DEFAULT nextval('district_bounded_bies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY districts ALTER COLUMN id SET DEFAULT nextval('districts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY entry_points ALTER COLUMN id SET DEFAULT nextval('entry_points_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hotels ALTER COLUMN id SET DEFAULT nextval('hotels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY in_proximity_ofs ALTER COLUMN id SET DEFAULT nextval('in_proximity_ofs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY local_transport_stands ALTER COLUMN id SET DEFAULT nextval('local_transport_stands_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY map_points ALTER COLUMN id SET DEFAULT nextval('map_points_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY near_bies ALTER COLUMN id SET DEFAULT nextval('near_bies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reviews ALTER COLUMN id SET DEFAULT nextval('reviews_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY state_bounded_bies ALTER COLUMN id SET DEFAULT nextval('state_bounded_bies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY states ALTER COLUMN id SET DEFAULT nextval('states_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tourist_spots ALTER COLUMN id SET DEFAULT nextval('tourist_spots_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY trips ALTER COLUMN id SET DEFAULT nextval('trips_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: buddies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY buddies
    ADD CONSTRAINT buddies_pkey PRIMARY KEY (id);


--
-- Name: closer_tos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY closer_tos
    ADD CONSTRAINT closer_tos_pkey PRIMARY KEY (id);


--
-- Name: closest_hotels_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY closest_hotels
    ADD CONSTRAINT closest_hotels_pkey PRIMARY KEY (id);


--
-- Name: district_bounded_bies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY district_bounded_bies
    ADD CONSTRAINT district_bounded_bies_pkey PRIMARY KEY (id);


--
-- Name: districts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (id);


--
-- Name: entry_points_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY entry_points
    ADD CONSTRAINT entry_points_pkey PRIMARY KEY (id);


--
-- Name: hotels_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hotels
    ADD CONSTRAINT hotels_pkey PRIMARY KEY (id);


--
-- Name: in_proximity_ofs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY in_proximity_ofs
    ADD CONSTRAINT in_proximity_ofs_pkey PRIMARY KEY (id);


--
-- Name: local_transport_stands_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY local_transport_stands
    ADD CONSTRAINT local_transport_stands_pkey PRIMARY KEY (id);


--
-- Name: map_points_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY map_points
    ADD CONSTRAINT map_points_pkey PRIMARY KEY (id);


--
-- Name: near_bies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY near_bies
    ADD CONSTRAINT near_bies_pkey PRIMARY KEY (id);


--
-- Name: reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: state_bounded_bies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY state_bounded_bies
    ADD CONSTRAINT state_bounded_bies_pkey PRIMARY KEY (id);


--
-- Name: states_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY states
    ADD CONSTRAINT states_pkey PRIMARY KEY (id);


--
-- Name: tourist_spots_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tourist_spots
    ADD CONSTRAINT tourist_spots_pkey PRIMARY KEY (id);


--
-- Name: trips_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trips
    ADD CONSTRAINT trips_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: closer_tos_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX closer_tos_index ON closer_tos USING btree (local_transport_stand_id, tourist_spot_id);


--
-- Name: closest_hotels_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX closest_hotels_index ON closest_hotels USING btree (entry_point_id, hotel_id);


--
-- Name: index_districts_on_state_id_and_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_districts_on_state_id_and_name ON districts USING btree (state_id, name);


--
-- Name: index_in_proximity_ofs_on_hotel_id_and_tourist_spot_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_in_proximity_ofs_on_hotel_id_and_tourist_spot_id ON in_proximity_ofs USING btree (hotel_id, tourist_spot_id);


--
-- Name: index_near_bies_on_hotel_id_and_local_transport_stand_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_near_bies_on_hotel_id_and_local_transport_stand_id ON near_bies USING btree (hotel_id, local_transport_stand_id);


--
-- Name: index_states_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_states_on_name ON states USING btree (name);


--
-- Name: index_trips_on_user_id_and_startDate; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX "index_trips_on_user_id_and_startDate" ON trips USING btree (user_id, "startDate");


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20131006150912');

INSERT INTO schema_migrations (version) VALUES ('20131006152353');

INSERT INTO schema_migrations (version) VALUES ('20131006152528');

INSERT INTO schema_migrations (version) VALUES ('20131006153246');

INSERT INTO schema_migrations (version) VALUES ('20131006164255');

INSERT INTO schema_migrations (version) VALUES ('20131006164512');

INSERT INTO schema_migrations (version) VALUES ('20131006164900');

INSERT INTO schema_migrations (version) VALUES ('20131006165048');

INSERT INTO schema_migrations (version) VALUES ('20131006170351');

INSERT INTO schema_migrations (version) VALUES ('20131006170817');

INSERT INTO schema_migrations (version) VALUES ('20131006180255');

INSERT INTO schema_migrations (version) VALUES ('20131006180839');

INSERT INTO schema_migrations (version) VALUES ('20131006181359');

INSERT INTO schema_migrations (version) VALUES ('20131006182632');

INSERT INTO schema_migrations (version) VALUES ('20131006183457');

INSERT INTO schema_migrations (version) VALUES ('20131006184201');

INSERT INTO schema_migrations (version) VALUES ('20131007070240');

INSERT INTO schema_migrations (version) VALUES ('20131007070933');

INSERT INTO schema_migrations (version) VALUES ('20131007071931');

INSERT INTO schema_migrations (version) VALUES ('20131007072420');

INSERT INTO schema_migrations (version) VALUES ('20131007073206');

INSERT INTO schema_migrations (version) VALUES ('20131007073709');

INSERT INTO schema_migrations (version) VALUES ('20131007074103');

INSERT INTO schema_migrations (version) VALUES ('20131007074308');

INSERT INTO schema_migrations (version) VALUES ('20131007074948');

INSERT INTO schema_migrations (version) VALUES ('20131007075328');

INSERT INTO schema_migrations (version) VALUES ('20131007075823');

INSERT INTO schema_migrations (version) VALUES ('20131007080113');

INSERT INTO schema_migrations (version) VALUES ('20131007082601');

INSERT INTO schema_migrations (version) VALUES ('20131007082815');

INSERT INTO schema_migrations (version) VALUES ('20131015122853');

INSERT INTO schema_migrations (version) VALUES ('20131015132251');

INSERT INTO schema_migrations (version) VALUES ('20131015132745');

INSERT INTO schema_migrations (version) VALUES ('20131015133054');

INSERT INTO schema_migrations (version) VALUES ('20131015144100');

INSERT INTO schema_migrations (version) VALUES ('20131015150007');

INSERT INTO schema_migrations (version) VALUES ('20131015152917');

INSERT INTO schema_migrations (version) VALUES ('20131019130301');

INSERT INTO schema_migrations (version) VALUES ('20131019133854');

INSERT INTO schema_migrations (version) VALUES ('20131019134135');

INSERT INTO schema_migrations (version) VALUES ('20131019134221');

INSERT INTO schema_migrations (version) VALUES ('20131019143239');

INSERT INTO schema_migrations (version) VALUES ('20131019145807');

INSERT INTO schema_migrations (version) VALUES ('20131019153008');

INSERT INTO schema_migrations (version) VALUES ('20131019164433');

INSERT INTO schema_migrations (version) VALUES ('20131019212422');

INSERT INTO schema_migrations (version) VALUES ('20131019213839');

INSERT INTO schema_migrations (version) VALUES ('20131019215403');