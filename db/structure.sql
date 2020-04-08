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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.countries (
    id bigint NOT NULL,
    name character varying,
    slug character varying,
    iso2 character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;


--
-- Name: infections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.infections (
    id bigint NOT NULL,
    country_id bigint,
    confirmed bigint DEFAULT 0,
    recovered bigint DEFAULT 0,
    deaths bigint DEFAULT 0,
    date date NOT NULL,
    confirmed_delta bigint DEFAULT 0,
    confirmed_rate integer DEFAULT 0,
    recovered_delta bigint DEFAULT 0,
    recovered_rate integer DEFAULT 0,
    deaths_delta bigint DEFAULT 0,
    deaths_rate integer DEFAULT 0,
    confirmed_notified bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: infections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.infections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: infections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.infections_id_seq OWNED BY public.infections.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    uid bigint NOT NULL,
    chat_id bigint NOT NULL,
    first_name character varying,
    last_name character varying,
    username character varying,
    language_code character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    reported boolean DEFAULT false NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);


--
-- Name: infections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.infections ALTER COLUMN id SET DEFAULT nextval('public.infections_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: infections infections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.infections
    ADD CONSTRAINT infections_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_countries_on_UPPER_iso2; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "index_countries_on_UPPER_iso2" ON public.countries USING btree (upper((iso2)::text));


--
-- Name: index_infections_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_infections_on_country_id ON public.infections USING btree (country_id);


--
-- Name: index_infections_on_country_id_and_date; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_infections_on_country_id_and_date ON public.infections USING btree (country_id, date DESC);


--
-- Name: index_infections_on_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_infections_on_date ON public.infections USING btree (date DESC);


--
-- Name: index_infections_on_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_infections_on_id ON public.infections USING btree (id) WHERE (confirmed <> confirmed_notified);


--
-- Name: index_users_on_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_id ON public.users USING btree (id) WHERE (reported = false);


--
-- Name: index_users_on_uid_and_chat_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_uid_and_chat_id ON public.users USING btree (uid, chat_id);


--
-- Name: infections fk_rails_4801f296e5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.infections
    ADD CONSTRAINT fk_rails_4801f296e5 FOREIGN KEY (country_id) REFERENCES public.countries(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20200407120145'),
('20200407121907'),
('20200407165926'),
('20200408182941');


