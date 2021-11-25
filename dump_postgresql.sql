--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE onlinejudge;
ALTER ROLE onlinejudge WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'md54827417b344ff91a2f608bbad9b4e488';






--
-- Database creation
--

CREATE DATABASE onlinejudge WITH TEMPLATE = template0 OWNER = onlinejudge;
REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


\connect onlinejudge

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.19
-- Dumped by pg_dump version 10.19

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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: acm_contest_rank; Type: TABLE; Schema: public; Owner: onlinejudge
--

CREATE TABLE public.acm_contest_rank (
    id integer NOT NULL,
    submission_number integer NOT NULL,
    accepted_number integer NOT NULL,
    total_time integer NOT NULL,
    submission_info jsonb NOT NULL,
    contest_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.acm_contest_rank OWNER TO onlinejudge;

--
-- Name: acm_contest_rank_id_seq; Type: SEQUENCE; Schema: public; Owner: onlinejudge
--

CREATE SEQUENCE public.acm_contest_rank_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.acm_contest_rank_id_seq OWNER TO onlinejudge;

--
-- Name: acm_contest_rank_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: onlinejudge
--

ALTER SEQUENCE public.acm_contest_rank_id_seq OWNED BY public.acm_contest_rank.id;


--
-- Name: ai_contest; Type: TABLE; Schema: public; Owner: onlinejudge
--

CREATE TABLE public.ai_contest (
    id integer NOT NULL,
    _id text NOT NULL,
    title text NOT NULL,
    contest_description text NOT NULL,
    rule_description text NOT NULL,
    schedule_description text,
    start_time timestamp with time zone,
    end_time timestamp with time zone,
    reward_description text,
    data_description text,
    create_time timestamp with time zone NOT NULL,
    last_update_time timestamp with time zone,
    visible boolean NOT NULL,
    solution_id text,
    data_id text,
    contest_id integer,
    created_by_id integer NOT NULL,
    p_type text,
    rank jsonb,
    password character varying(20),
    accepted_number bigint NOT NULL,
    submission_number bigint NOT NULL,
    join_contest jsonb,
    eval_type text
);


ALTER TABLE public.ai_contest OWNER TO onlinejudge;

--
-- Name: ai_contest_id_seq; Type: SEQUENCE; Schema: public; Owner: onlinejudge
--

CREATE SEQUENCE public.ai_contest_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ai_contest_id_seq OWNER TO onlinejudge;

--
-- Name: ai_contest_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: onlinejudge
--

ALTER SEQUENCE public.ai_contest_id_seq OWNED BY public.ai_contest.id;


--
-- Name: ai_contest_tag; Type: TABLE; Schema: public; Owner: onlinejudge
--

CREATE TABLE public.ai_contest_tag (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.ai_contest_tag OWNER TO onlinejudge;

--
-- Name: ai_contest_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: onlinejudge
--

CREATE SEQUENCE public.ai_contest_tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ai_contest_tag_id_seq OWNER TO onlinejudge;

--
-- Name: ai_contest_tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: onlinejudge
--

ALTER SEQUENCE public.ai_contest_tag_id_seq OWNED BY public.ai_contest_tag.id;


--
-- Name: ai_contest_tags; Type: TABLE; Schema: public; Owner: onlinejudge
--

CREATE TABLE public.ai_contest_tags (
    id integer NOT NULL,
    aiproblem_id integer NOT NULL,
    aiproblemtag_id integer NOT NULL
);


ALTER TABLE public.ai_contest_tags OWNER TO onlinejudge;

--
-- Name: ai_contest_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: onlinejudge
--

CREATE SEQUENCE public.ai_contest_tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ai_contest_tags_id_seq OWNER TO onlinejudge;

--
-- Name: ai_contest_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: onlinejudge
--

ALTER SEQUENCE public.ai_contest_tags_id_seq OWNED BY public.ai_contest_tags.id;


--
-- Name: announcement; Type: TABLE; Schema: public; Owner: onlinejudge
--

CREATE TABLE public.announcement (
    id integer NOT NULL,
    title text NOT NULL,
    content text NOT NULL,
    create_time timestamp with time zone NOT NULL,
    last_update_time timestamp with time zone NOT NULL,
    visible boolean NOT NULL,
    important boolean NOT NULL,
    created_by_id integer NOT NULL
);


ALTER TABLE public.announcement OWNER TO onlinejudge;

--
-- Name: announcement_id_seq; Type: SEQUENCE; Schema: public; Owner: onlinejudge
--

CREATE SEQUENCE public.announcement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.announcement_id_seq OWNER TO onlinejudge;

--
-- Name: announcement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: onlinejudge
--

ALTER SEQUENCE public.announcement_id_seq OWNED BY public.announcement.id;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: onlinejudge
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO onlinejudge;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: onlinejudge
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO onlinejudge;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: onlinejudge
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: onlinejudge
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO onlinejudge;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: onlinejudge
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO onlinejudge;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: onlinejudge
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: onlinejudge
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO onlinejudge;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: onlinejudge
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO onlinejudge;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: onlinejudge
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: contest; Type: TABLE; Schema: public; Owner: onlinejudge
--

CREATE TABLE public.contest (
    id integer NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    real_time_rank boolean NOT NULL,
    password text,
    rule_type text NOT NULL,
    start_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone NOT NULL,
    create_time timestamp with time zone NOT NULL,
    last_update_time timestamp with time zone NOT NULL,
    visible boolean NOT NULL,
    allowed_ip_ranges jsonb NOT NULL,
    created_by_id integer NOT NULL
);


ALTER TABLE public.contest OWNER TO onlinejudge;

--
-- Name: contest_announcement; Type: TABLE; Schema: public; Owner: onlinejudge
--

CREATE TABLE public.contest_announcement (
    id integer NOT NULL,
    title text NOT NULL,
    content text NOT NULL,
    visible boolean NOT NULL,
    create_time timestamp with time zone NOT NULL,
    contest_id integer NOT NULL,
    created_by_id integer NOT NULL
);


ALTER TABLE public.contest_announcement OWNER TO onlinejudge;

--
-- Name: contest_announcement_id_seq; Type: SEQUENCE; Schema: public; Owner: onlinejudge
--

CREATE SEQUENCE public.contest_announcement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contest_announcement_id_seq OWNER TO onlinejudge;

--
-- Name: contest_announcement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: onlinejudge
--

ALTER SEQUENCE public.contest_announcement_id_seq OWNED BY public.contest_announcement.id;


--
-- Name: contest_id_seq; Type: SEQUENCE; Schema: public; Owner: onlinejudge
--

CREATE SEQUENCE public.contest_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contest_id_seq OWNER TO onlinejudge;

--
-- Name: contest_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: onlinejudge
--

ALTER SEQUENCE public.contest_id_seq OWNED BY public.contest.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: onlinejudge
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO onlinejudge;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: onlinejudge
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO onlinejudge;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: onlinejudge
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_dramatiq_task; Type: TABLE; Schema: public; Owner: onlinejudge
--

CREATE TABLE public.django_dramatiq_task (
    id uuid NOT NULL,
    status character varying(8) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    message_data bytea NOT NULL
);


ALTER TABLE public.django_dramatiq_task OWNER TO onlinejudge;

--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: onlinejudge
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO onlinejudge;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: onlinejudge
--

CREATE SEQUENCE public.django_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO onlinejudge;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: onlinejudge
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: onlinejudge
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO onlinejudge;

--
-- Name: faq; Type: TABLE; Schema: public; Owner: onlinejudge
--

CREATE TABLE public.faq (
    id integer NOT NULL,
    question text NOT NULL,
    answer text NOT NULL,
    create_time timestamp with time zone NOT NULL,
    last_update_time timestamp with time zone NOT NULL,
    visible boolean NOT NULL,
    created_by_id integer NOT NULL
);


ALTER TABLE public.faq OWNER TO onlinejudge;

--
-- Name: faq_id_seq; Type: SEQUENCE; Schema: public; Owner: onlinejudge
--

CREATE SEQUENCE public.faq_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.faq_id_seq OWNER TO onlinejudge;

--
-- Name: faq_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: onlinejudge
--

ALTER SEQUENCE public.faq_id_seq OWNED BY public.faq.id;


--
-- Name: judge_server; Type: TABLE; Schema: public; Owner: onlinejudge
--

CREATE TABLE public.judge_server (
    id integer NOT NULL,
    hostname text NOT NULL,
    ip text,
    judger_version text NOT NULL,
    cpu_core integer NOT NULL,
    memory_usage double precision NOT NULL,
    cpu_usage double precision NOT NULL,
    last_heartbeat timestamp with time zone NOT NULL,
    create_time timestamp with time zone NOT NULL,
    task_number integer NOT NULL,
    service_url text,
    is_disabled boolean NOT NULL
);


ALTER TABLE public.judge_server OWNER TO onlinejudge;

--
-- Name: judge_server_id_seq; Type: SEQUENCE; Schema: public; Owner: onlinejudge
--

CREATE SEQUENCE public.judge_server_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.judge_server_id_seq OWNER TO onlinejudge;

--
-- Name: judge_server_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: onlinejudge
--

ALTER SEQUENCE public.judge_server_id_seq OWNED BY public.judge_server.id;


--
-- Name: oi_contest_rank; Type: TABLE; Schema: public; Owner: onlinejudge
--

CREATE TABLE public.oi_contest_rank (
    id integer NOT NULL,
    submission_number integer NOT NULL,
    total_score integer NOT NULL,
    submission_info jsonb NOT NULL,
    contest_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.oi_contest_rank OWNER TO onlinejudge;

--
-- Name: oi_contest_rank_id_seq; Type: SEQUENCE; Schema: public; Owner: onlinejudge
--

CREATE SEQUENCE public.oi_contest_rank_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.oi_contest_rank_id_seq OWNER TO onlinejudge;

--
-- Name: oi_contest_rank_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: onlinejudge
--

ALTER SEQUENCE public.oi_contest_rank_id_seq OWNED BY public.oi_contest_rank.id;


--
-- Name: options_sysoptions; Type: TABLE; Schema: public; Owner: onlinejudge
--

CREATE TABLE public.options_sysoptions (
    id integer NOT NULL,
    key text NOT NULL,
    value jsonb NOT NULL
);


ALTER TABLE public.options_sysoptions OWNER TO onlinejudge;

--
-- Name: options_sysoptions_id_seq; Type: SEQUENCE; Schema: public; Owner: onlinejudge
--

CREATE SEQUENCE public.options_sysoptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.options_sysoptions_id_seq OWNER TO onlinejudge;

--
-- Name: options_sysoptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: onlinejudge
--

ALTER SEQUENCE public.options_sysoptions_id_seq OWNED BY public.options_sysoptions.id;


--
-- Name: problem; Type: TABLE; Schema: public; Owner: onlinejudge
--

CREATE TABLE public.problem (
    id integer NOT NULL,
    _id text NOT NULL,
    is_public boolean NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    samples jsonb NOT NULL,
    test_case_id text NOT NULL,
    test_case_score jsonb NOT NULL,
    testhint text,
    languages jsonb NOT NULL,
    template jsonb NOT NULL,
    create_time timestamp with time zone NOT NULL,
    last_update_time timestamp with time zone,
    memory_limit integer NOT NULL,
    io_mode jsonb NOT NULL,
    spj boolean NOT NULL,
    spj_language text,
    spj_code text,
    spj_version text,
    spj_compile_ok boolean NOT NULL,
    rule_type text NOT NULL,
    visible boolean NOT NULL,
    difficulty text NOT NULL,
    source text,
    total_score integer NOT NULL,
    submission_number bigint NOT NULL,
    accepted_number bigint NOT NULL,
    statistic_info jsonb NOT NULL,
    share_submission boolean NOT NULL,
    contest_id integer,
    created_by_id integer NOT NULL
);


ALTER TABLE public.problem OWNER TO onlinejudge;

--
-- Name: problem_id_seq; Type: SEQUENCE; Schema: public; Owner: onlinejudge
--

CREATE SEQUENCE public.problem_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.problem_id_seq OWNER TO onlinejudge;

--
-- Name: problem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: onlinejudge
--

ALTER SEQUENCE public.problem_id_seq OWNED BY public.problem.id;


--
-- Name: problem_tag; Type: TABLE; Schema: public; Owner: onlinejudge
--

CREATE TABLE public.problem_tag (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.problem_tag OWNER TO onlinejudge;

--
-- Name: problem_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: onlinejudge
--

CREATE SEQUENCE public.problem_tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.problem_tag_id_seq OWNER TO onlinejudge;

--
-- Name: problem_tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: onlinejudge
--

ALTER SEQUENCE public.problem_tag_id_seq OWNED BY public.problem_tag.id;


--
-- Name: problem_tags; Type: TABLE; Schema: public; Owner: onlinejudge
--

CREATE TABLE public.problem_tags (
    id integer NOT NULL,
    problem_id integer NOT NULL,
    problemtag_id integer NOT NULL
);


ALTER TABLE public.problem_tags OWNER TO onlinejudge;

--
-- Name: problem_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: onlinejudge
--

CREATE SEQUENCE public.problem_tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.problem_tags_id_seq OWNER TO onlinejudge;

--
-- Name: problem_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: onlinejudge
--

ALTER SEQUENCE public.problem_tags_id_seq OWNED BY public.problem_tags.id;


--
-- Name: submission; Type: TABLE; Schema: public; Owner: onlinejudge
--

CREATE TABLE public.submission (
    id text NOT NULL,
    create_time timestamp with time zone NOT NULL,
    user_id integer NOT NULL,
    username text NOT NULL,
    code text NOT NULL,
    result integer NOT NULL,
    info jsonb NOT NULL,
    language text NOT NULL,
    shared boolean NOT NULL,
    statistic_info jsonb NOT NULL,
    ip text,
    contest_id integer,
    problem_id integer NOT NULL
);


ALTER TABLE public.submission OWNER TO onlinejudge;

--
-- Name: user; Type: TABLE; Schema: public; Owner: onlinejudge
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    username text NOT NULL,
    email text,
    create_time timestamp with time zone,
    admin_type text NOT NULL,
    problem_permission text NOT NULL,
    reset_password_token text,
    reset_password_token_expire_time timestamp with time zone,
    auth_token text,
    two_factor_auth boolean NOT NULL,
    tfa_token text,
    session_keys jsonb NOT NULL,
    open_api boolean NOT NULL,
    open_api_appkey text,
    is_disabled boolean NOT NULL
);


ALTER TABLE public."user" OWNER TO onlinejudge;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: onlinejudge
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO onlinejudge;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: onlinejudge
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: user_profile; Type: TABLE; Schema: public; Owner: onlinejudge
--

CREATE TABLE public.user_profile (
    id integer NOT NULL,
    acm_problems_status jsonb NOT NULL,
    oi_problems_status jsonb NOT NULL,
    real_name text,
    avatar text NOT NULL,
    blog character varying(200),
    mood text,
    github text,
    school text,
    major text,
    language text,
    accepted_number integer NOT NULL,
    total_score bigint NOT NULL,
    submission_number integer NOT NULL,
    user_id integer NOT NULL,
    user_join_contest jsonb NOT NULL,
    submit_info jsonb NOT NULL
);


ALTER TABLE public.user_profile OWNER TO onlinejudge;

--
-- Name: user_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: onlinejudge
--

CREATE SEQUENCE public.user_profile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_profile_id_seq OWNER TO onlinejudge;

--
-- Name: user_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: onlinejudge
--

ALTER SEQUENCE public.user_profile_id_seq OWNED BY public.user_profile.id;


--
-- Name: acm_contest_rank id; Type: DEFAULT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.acm_contest_rank ALTER COLUMN id SET DEFAULT nextval('public.acm_contest_rank_id_seq'::regclass);


--
-- Name: ai_contest id; Type: DEFAULT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.ai_contest ALTER COLUMN id SET DEFAULT nextval('public.ai_contest_id_seq'::regclass);


--
-- Name: ai_contest_tag id; Type: DEFAULT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.ai_contest_tag ALTER COLUMN id SET DEFAULT nextval('public.ai_contest_tag_id_seq'::regclass);


--
-- Name: ai_contest_tags id; Type: DEFAULT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.ai_contest_tags ALTER COLUMN id SET DEFAULT nextval('public.ai_contest_tags_id_seq'::regclass);


--
-- Name: announcement id; Type: DEFAULT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.announcement ALTER COLUMN id SET DEFAULT nextval('public.announcement_id_seq'::regclass);


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: contest id; Type: DEFAULT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.contest ALTER COLUMN id SET DEFAULT nextval('public.contest_id_seq'::regclass);


--
-- Name: contest_announcement id; Type: DEFAULT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.contest_announcement ALTER COLUMN id SET DEFAULT nextval('public.contest_announcement_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Name: faq id; Type: DEFAULT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.faq ALTER COLUMN id SET DEFAULT nextval('public.faq_id_seq'::regclass);


--
-- Name: judge_server id; Type: DEFAULT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.judge_server ALTER COLUMN id SET DEFAULT nextval('public.judge_server_id_seq'::regclass);


--
-- Name: oi_contest_rank id; Type: DEFAULT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.oi_contest_rank ALTER COLUMN id SET DEFAULT nextval('public.oi_contest_rank_id_seq'::regclass);


--
-- Name: options_sysoptions id; Type: DEFAULT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.options_sysoptions ALTER COLUMN id SET DEFAULT nextval('public.options_sysoptions_id_seq'::regclass);


--
-- Name: problem id; Type: DEFAULT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.problem ALTER COLUMN id SET DEFAULT nextval('public.problem_id_seq'::regclass);


--
-- Name: problem_tag id; Type: DEFAULT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.problem_tag ALTER COLUMN id SET DEFAULT nextval('public.problem_tag_id_seq'::regclass);


--
-- Name: problem_tags id; Type: DEFAULT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.problem_tags ALTER COLUMN id SET DEFAULT nextval('public.problem_tags_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Name: user_profile id; Type: DEFAULT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.user_profile ALTER COLUMN id SET DEFAULT nextval('public.user_profile_id_seq'::regclass);


--
-- Data for Name: acm_contest_rank; Type: TABLE DATA; Schema: public; Owner: onlinejudge
--

COPY public.acm_contest_rank (id, submission_number, accepted_number, total_time, submission_info, contest_id, user_id) FROM stdin;
\.


--
-- Data for Name: ai_contest; Type: TABLE DATA; Schema: public; Owner: onlinejudge
--

COPY public.ai_contest (id, _id, title, contest_description, rule_description, schedule_description, start_time, end_time, reward_description, data_description, create_time, last_update_time, visible, solution_id, data_id, contest_id, created_by_id, p_type, rank, password, accepted_number, submission_number, join_contest, eval_type) FROM stdin;
2	병변 검출 AI 경진대회	농산물 가격예측 AI 대회	<h2><b>1. 주제</b></h2><p style="text-align: justify;">농산물 가격 예측 모형 개발</p><h2><b>2. 배경</b></h2><p>• 농산물 가격 예측 서비스:</p><p><span style="color: rgb(34, 34, 34);">농산물의 원활한 수급과 적정한 가격 유지를 위해 한국농수산식품유통공사(aT)는 농산물유통 종합정보시스템(이하 농넷)을 구축하여 운영하고 있습니다.</span></p><p><span style="color: rgb(34, 34, 34);">농넷에서는 농산물 수급 관련 정보를 수집하여 다양한 빅데이터 분석 정보를 제공하고 있으며,</span></p><p><span style="color: rgb(34, 34, 34);">AI를 활용한 농산물가격예측 시스템을 구축하여 활용하고 있습니다. (향후 대민서비스 예정)</span></p><p>• 목적:</p><p>본 대회에서는 기존 농넷의 농산물 가격 예측 모형을 개선할 수 있는 새로운 아이디어와 알고리즘을 얻고자 합니다.</p><h2><b>3. 결과 활용</b></h2><p>수상자 알고리즘은 농넷 가격예측 서비스에 활용됩니다.</p><h2><b>4. 주최 / 주관</b></h2><p>•주최: 한국농수산식품유통공사</p><p>•주관:데이콘</p><h2><b>5. 참가 대상</b></h2><p>• 내국인은 누구나 참여 가능</p><p>• 외국인은 내국인과 팀을 이루어야 참여 가능</p><h2><b>6. 참고문헌</b></h2><p><a href="https://www.mdpi.com/2077-0472/10/12/612" target="_blank">Agriculture | Free Full-Text | STL-ATTLSTM: Vegetable Price Forecasting Using STL and Attention Mechanism-Based LSTM (mdpi.com)</a></p><ul><li>Helin Yin, Dong Jin, Yeong Hyeon Gu, Chang Jin Park, Sang Keun Han, Seong Joon Yoo, &quot;STL-ATTLSTM: Vegetable Price Forecasting Using STL and Attention Mechanism-Based LSTM&quot;, Agriculture 2020</li></ul>	<h2><b>1. 평가</b></h2><p>1차 평가에서 6팀을 선발하여 이들을 대상으로 2차 평가 진행</p><p>1차 계량 평가(90%)와 2차 비계량 평가(10%) 점수를 합산하여 최종 순위 결정</p><h3><b>① 1차 평가</b></h3><p>ⅰ) 평가 산식: NMAE (Normalized Mean Absolute Error)</p><pre>import numpy as np<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />import pandas as pd<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" /><br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" /><br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />def nmae(answer_df, submission_df):<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    answer = answer_df.iloc[:,1:].to_numpy()<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    submission = submission_df.iloc[:,1:].to_numpy()<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    target_idx = np.where(answer!=0)<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    <br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    true = answer[target_idx]<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    pred = submission[target_idx]<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    <br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    score = np.mean(np.abs(true-pred)/true)<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    <br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    return score<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" /><br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" /><br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />def at_nmae(answer_df, submission_df):<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    week_1_answer = answer_df.iloc[0::3]<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    week_2_answer = answer_df.iloc[1::3]<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    week_4_answer = answer_df.iloc[2::3]<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    <br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    idx_col_nm = answer_df.columns[0]<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    week_1_submission = submission_df[submission_df[idx_col_nm].isin(week_1_answer[idx_col_nm])]<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    week_2_submission = submission_df[submission_df[idx_col_nm].isin(week_2_answer[idx_col_nm])]<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    week_4_submission = submission_df[submission_df[idx_col_nm].isin(week_4_answer[idx_col_nm])]<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    <br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    score1 = nmae(week_1_answer, week_1_submission)<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    score2 = nmae(week_2_answer, week_2_submission)<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    score4 = nmae(week_4_answer, week_4_submission)<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    <br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    score = (score1+score2+score4)/3<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    <br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    return score<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" /></pre><p>ⅱ) 예측 대상: 21개 품목 및 품종의1주 후, 2주 후, 4주 후 가격</p><h5>*대상품목(16): 배추, 무, 양파, 건고추, 마늘, 대파, 얼갈이배추, 양배추, 깻잎, 시금치, 미나리, 당근, 파프리카, 새송이, 팽이버섯, 토마토</h5><h5>*대상품종(5): 청상추, 백다다기, 애호박, 캠벨얼리, 샤인마스캇</h5><p>ⅲ) 가격 산출 기준 : 전국 도매시장(총 거래금액)/(총 거래량)(원/kg)</p><p>※ 거래 취소내역(음수로 집계)은 미반영</p><p>ⅳ) Public Score: Private Score 평가 전에 자신의 모델 성능을 확인해볼 수 있는 점수</p><ul><li>예측 대상: 2020년 10월 6일(화) ~ 2020년 11월 12일(목) 기간 내 품목별 1주, 2주, 4주 후 가격</li><li>리더보드 업데이트 : 제출 후 실시간 업데이트</li></ul><p>ⅴ) Private Score: 최종 점수에 반영되는 Score</p><ul><li>예측 대상: 2021년 10월 5일(화) ~ 2021년 11월 11일(목) 기간 내 품목별 1주, 2주, 4주 후 가격</li><li>답안 제출 기간: 2021년 9월 28일(화) ~ 2021년 11월 4일(목)</li><li>리더보드 업데이트: 2021년 10월 6일(수) ~ 2021년 11월 12일(금) 내 1일 1회 업데이트</li></ul><p>※ Private 리더보드 업데이트 시기는 시장 상황에 따라 변동 가능. (일반적으로 가격 자료 수집까지 하루 소요)</p><p>※ 답안 제출 기간 동안 매일 자정까지 답안을 제출해야함. API 사용하여 자동화 가능.</p><p>ⅵ) 2차 평가 대상 선발: 수상 제외 및 실격 사유에 해당하지 않는 팀 중에서 Private Score가 높은 상위 6팀</p><p>ⅶ) 참고 사진:<img src="https://dacon.s3.ap-northeast-2.amazonaws.com/img/competition/235801/rule3.jpg" /></p><h3><b>② 2차 평가</b></h3><p>ⅰ) 일시: 2021년 12월 1일(수)</p><p>ⅱ) 평가 방식: 온라인 발표 평가</p><p>ⅲ) 평가 대상: 1차 평가에서 선발된 6팀</p><p>ⅳ) 평가 기준: 과제 이해도, 기술 우수성, 적용 가능성, 부정제출 여부</p><h2><b>2. 코드 제출</b></h2><p>ⅰ) 제출 대상: 대회 종료 직후 Private 1~10위 팀</p><p>ⅱ) 제출물: Private 리더보드 점수를 복원할 수 있는 소스 코드</p><p>ⅲ) 제출 메일:<a href="http://mailto:dacon@dacon.io" target="_blank">dacon@dacon.io</a></p><p>ⅳ) 제출 기간: 2021년 11월 15일(월) ~ 2021년 11월 19일(금)</p><p>ⅴ) 코드 검증 기간: 2021년 11월 22일(월) ~ 2021년 11월 26일(금)</p><p>※ 코드 미제출시 수상 및 2차 평가 대상에서 제외</p><h2><b>3. 개인 또는 팀 참여 규칙</b></h2><p>ⅰ) 개인 또는 팀을 이루어 참여 가능</p><p>ⅱ) 동일인이 개인 또는 복수팀에 중복하여 등록 불가</p><p>ⅲ)팀 병합 후 해체시 개인 참여 및 팀 등록 불가</p><p>ⅳ) 개인 참가 방법: 팀 신청 없이, 자유롭게 제출 창에서 제출 가능</p><p>ⅴ) 팀 구성 방법: &#039;<a href="https://dacon.io/competitions/official/235803/team" target="_blank">팀 페이지</a>&#039; - &#039;팀 구성 안내&#039; 참고</p><p>ⅵ) 팀 최대 인원: 5명</p><h2><b>4. 외부 데이터 및 사전학습 모델</b></h2><p>ⅰ) 예측일 전날 자정까지 확인이 가능한 데이터만 학습 및 추론 과정에서 사용 가능(Data Leakage 관련 토크 게시글 참고)</p><p>ⅱ) 공공데이터와 같이 누구나 얻을 수 있고 법적 제약이 없는 외부 데이터 허용(코드 제출시 출처 명시)</p><p>ⅲ) 사전학습 모델 사용 가능(코드 제출시 사전학습에 사용된 데이터 명시)</p><p>ⅳ)<span style="color: rgb(29, 28, 29);">추천 외부 데이터</span></p><ul><li><span style="color: rgb(29, 28, 29);">농산물 유통 정보:</span><a href="https://www.kamis.or.kr/customer/reference/openapi_list.do" target="_blank">https://www.kamis.or.kr/customer/reference/openapi_list.do</a></li><li><span style="color: rgb(29, 28, 29);">aT 도매유통 정보시스템:</span><a href="https://at.agromarket.kr/openApi/apiInfoDtl.do?apiSeq=1" target="_blank">https://at.agromarket.kr/openApi/apiInfoDtl.do?apiSeq=1</a></li><li><span style="color: rgb(29, 28, 29);">농촌진흥청 국립농업과학원 농업기상 데이터:</span><a href="https://www.data.go.kr/data/15078057/openapi.do" target="_blank">https://www.data.go.kr/data/15078057/openapi.do</a></li><li><span style="color: rgb(29, 28, 29);">관세청_품목별 수출입 실적:</span><a href="https://www.data.go.kr/data/3046122/openapi.do" target="_blank">https://www.data.go.kr/data/3046122/openapi.do</a></li><li><span style="color: rgb(29, 28, 29);">농식품수출정보:</span><a href="https://www.kati.net/statistics/monthlyPerformanceByProduct.do" target="_blank">https://www.kati.net/statistics/monthlyPerformanceByProduct.do</a></li></ul><h2><b>5. 유의 사항</b></h2><p>ⅰ) 다음 사항에 해당하면 실격 처리:</p><ul><li>부정 제출 및 치팅 행위(<a href="https://dacon.io/notice/notice/13" target="_blank">https://dacon.io/notice/notice/13</a>참고)</li><li>허용되지 않은 외부데이터 사용</li><li>대회 공지 및 안내에 명시된 규칙 위반</li><li>기타 경쟁의 공정성을 저해하는 행위</li><li>Data Leakage(학습, 추론 시점에 획득 불가능한 데이터 사용 등. 관련 토크 게시글 필독)</li></ul><p>※ 제출물 중 Data Leakage가 발생하였을 경우 대회문의 게시판에 제보(2회까지 제출물 삭제, 3회 이상은 실격)</p><p>※ 규칙 위반 사항이 의심될 경우 운영진 측에서 소스 코드 제출을 요구할 수 있으며, 이에 응하지 않으면 실격 처리됩니다.</p><p>ⅱ) Private 첫 제출 후 전처리 및 모델 변경 불가(관련 토크 게시글 필독)</p><p>ⅳ) 1일 최대 제출 횟수: 3회</p><p>ⅴ) 사용 가능 언어: Python, R</p><h2><b>6. 대회 문의</b></h2><p>ⅰ) 대회 운영 및 데이터 이상에 관련된 질문 외에는 답변을 드리지 않고 있습니다. 기타 질문은 토론 페이지를 통해 자유롭게 토론해주시기 바랍니다.</p><p>ⅱ) 데이콘 답변을 희망하는 경우, &#039;대회문의&#039; 페이지에 질문을 올려주시기 바랍니다.</p>	<h2><b>세부 일정</b></h2><ul><li>데이터 공개  \t\t\t\t\t\t\t\t2021년 8월 30일 10:00</li><li>대회 기간  \t\t\t\t\t\t\t\t\t\t2021년 8월 30일 10:00 ~ 2021년 11월 12일</li><li>팀 병합 마감  \t\t\t\t\t\t\t\t2021년 9월 21일</li><li>Private 제출 \t\t\t\t\t\t\t\t2021년 09월 28일 ~ 2021년 11월 4일</li><li>Private 평가\t\t\t\t\t\t\t\t2021년 10월 6일 ~ 2021년 11월 12일</li><li>코드 제출 기간  \t\t\t\t\t\t\t2021년 11월 15일 ~ 2021년 11월 19일<br /></li><li>코드 평가 기간\t\t\t\t\t\t\t\t2021년 11월 22일 ~ 2021년 11월 26일</li><li>2차 평가\t\t\t\t\t\t\t\t\t\t2021년 12월 1일<br /></li><li>최종 순위 발표  \t\t\t\t\t\t\t2021년 12월 3일</li><li>시상식\t\t\t\t\t\t\t\t\t\t\t2021년 12월 10일</li></ul><p>※ 세부 일정은 대회 운영상황에 따라 변동될 수 있습니다.</p>	2021-11-17 15:00:00+00	2021-11-19 15:00:00+00	<p>🏆 총 상금 2,600만원</p><p><b>•대상(농식품부 장관상)(1팀) 상장 및 상금 1,000만원🥇</b></p><p><b>•최우수상(aT 사장상)(2팀) 상장 및 상금  각 500만원🥈</b></p><p><b>•우수상(aT 사장상)(3팀) 상장 및 상금  각 200만원🥉</b></p>	<p>※ 데이터 출처 :<a href="https://www.nongnet.or.kr/index.do" target="_blank">농넷 | 농산물유통종합정보시스템 (nongnet.or.kr)</a>(대회용 API 제공 예정)</p><p>1. public_data : public leaderboard용 데이터</p><p>1-1. train.csv : 베이스라인 코드용으로 가공된 학습 데이터</p><ul><li>date: 일자</li><li>요일: 요일</li><li>품목_거래량(kg): 해당 품목의 거래량</li><li>품목_가격(원/kg): 해당 품목의 kg당 가격</li><li>품목_가격 산출 방식 : 품목 또는 품종의 총 거래금액/총 거래량 (※취소된 거래내역 제외)</li></ul><p>1-2. test_files : 베이스라인 코드용으로 가공된 테스트 데이터(추론일자별 분리, ex.test_2020-08-29.csv =&gt; 2020년 8월 29일 추론에 사용 가능 데이터)</p><p>1-3. train_AT_TSALET_ALL : 학습용 전국 도매시장 거래정보 데이터(train.csv 생성에 사용)</p><ul><li>SALEDATE: 경락 일자</li><li>WHSAL_NM: 도매시장</li><li>CMP_NM: 법인</li><li>PUM_NM: 품목</li><li>KIND_NM: 품종</li><li>DAN_NM: 단위</li><li>POJ_NM: 포장</li><li>SIZE_NM: 크기</li><li>LV_NM: 등급</li><li>SAN_NM: 산지</li><li>DANQ: 단위중량</li><li>QTY: 물량</li><li>COST: 단가</li><li>TOT_QTY: 총물량 (음수로 집계된 값은 거래 취소 내역)</li><li>TOT_AMT: 총금액</li></ul><p>1-4. test_AT_TSALET_ALL : 추론용 전국 도매시장 거래정보 데이터(test_files 생성에 사용)</p><p>2. private_data : private leaderboard용 데이터, public leaderboard 학습 및 추론 사용 불가</p><p>2-1. private.csv : 베이스라인 코드용으로 가공된 데이터</p><p>2-2. AT_TSALET_ALL : 2021년 8월까지의 전국 도매시장 거래정보 데이터(private.csv 생성에 사용)</p><p>3. sample_submission.csv : 제출 양식</p><ul><li>예측대상일자: 예측대상일(기준일로부터 1,2,4주 뒤 일자)</li><li>품목_가격(원/kg): 해당 품목의 kg당 가격</li></ul><p>4. 추천 외부 데이터</p><ul><li>농산물 유통 정보:<a href="https://www.kamis.or.kr/customer/reference/openapi_list.do" target="_blank">https://www.kamis.or.kr/customer/reference/openapi_list.do</a></li><li>aT 도매유통 정보시스템:<a href="https://at.agromarket.kr/openApi/apiInfoDtl.do?apiSeq=1" target="_blank">https://at.agromarket.kr/openApi/apiInfoDtl.do?apiSeq=1</a></li><li>농촌진흥청 국립농업과학원 농업기상 데이터:<a href="https://www.data.go.kr/data/15078057/openapi.do" target="_blank">https://www.data.go.kr/data/15078057/openapi.do</a></li><li>관세청_품목별 수출입 실적:<a href="https://www.data.go.kr/data/3046122/openapi.do" target="_blank">https://www.data.go.kr/data/3046122/openapi.do</a></li><li>농식품수출정보:<a href="https://www.kati.net/statistics/monthlyPerformanceByProduct.do" target="_blank">https://www.kati.net/statistics/monthlyPerformanceByProduct.do</a></li></ul>	2021-11-17 12:20:14.315428+00	\N	t	a3ea661dbf33d3eca384104bfd55df8d	1f00da380c28f57a6da3abcc6257dcf0	\N	1	General	[]		0	0	[]	acc
3	가스공급량 수요예측	가스공급량 수요예측	<h2><b>1. 개요</b></h2><ul><li>가스・에너지분야 문서요약 모델개발 대회에 참여하신 걸 환영합니다.</li><li>한국가스공사는 공사 보유 데이터 및 노하우와 빅데이터・인공지능 분야 스타트업 기업의 4차 산업기술 융합으로 새로운 가치를 창출하는 상생협력을 실천하고자 합니다.</li><li>스타트업 및 예비창업자에게 창업 유도와 성장 지원으로 일자리를 창출하고자 본 대회를 주최하게 되었습니다.</li><li>본 대회를 통해 가스・에너지분야의 기사, 법률문서 등을 요약해 시장분석에 활용할 수 있는 모델개발을 목표로 하고 있습니다.</li></ul><h2><b>2. 주제</b></h2><ul><li>일반 및 가스・에너지분야 국어 문서 원문으로부터 생성요약문을 도출해 내는 인공지능을 개발합니다.</li></ul><h2><b>3. 주최 및 주관</b></h2><ul><li>주최/주관: 한국가스공사</li><li>운영:데이콘주식회사</li></ul><h2><b>4. 참가 대상</b></h2><ul><li>스타트업: 창업 7년 이내의 기업(2014. 9. 30 이후 사업자등록 업체)</li><li>예비창업가: 1-5년 이내의 창업을 희망하는 자로 대학생 및 일반인</li></ul><h2><b>5. 참가 유의사항(필독)</b></h2><ul><li>대회 참가신청은 10월 29일 23:00까지(서면제출은 11월 2일 21시까지) 입니다.</li><li>본대회 주관사인 한국가스공사의 대회홈페이지에서 먼저 참가신청을 하지않고 본 데이콘 사이트로 직접 참가하신 경우는 반드시 공식 대회홈페이지 (<a href="https://kogasbigstar.kr/" target="_blank">https://kogasbigstar.kr/</a>)에 참가신청서를 상기 마감전까지 제출하셔야 합니다.</li><li>만약 제출하지 않으시면 자동 탈락되오니 개인은 바로 공식 대회홈페이지에서 참가신청서를 제출해 주시고 팀을 모집하시는 경우는 팀구성이 마무리되는대로 제출해 주시기를 권고드립니다.</li></ul>	<h2><b>1. 평가</b></h2><p>1) 공개평가(리더보드)</p><ul><li>Public 리더보드 : 전체 테스트 데이터 중 무작위 50%</li><li>본대회에서는 모델이 예측한 생성요약문과 사람이 생성한 요약문의 ROUGE-N에 대한 F1 SCORE를 사용합니다.</li></ul><p><img src="https://dacon.s3.ap-northeast-2.amazonaws.com/competition/235818/editor-image/163271918293650.jpeg" /></p><ul><li>채점 기준: ROUGE-1(점수1), ROUGE-2(점수2), ROUGE-L(점수3)</li><li>순위 기준</li></ul><p>- 3가지 지표에대한 개별 순위의 합산 오름차순( ex - ROUGE-1:1위, ROUGE-2:3위, ROUGE-L:2위 =&gt; 1+3+2=6점)</p><p>- 합산 점수 동률시 제출 시간 오름차순</p><p>2) 1차 평가</p><ul><li>평가기간: 12월 6일 ~ 12월 10일</li><li>테스트셋: 가스에너지분야 문서 포함 재배포</li><li>평가셋: 전체테스트 데이터 100%</li><li>코드제출기한: 12월 10일 23:00까지</li><li>코드제출내용: 12월 10일까지 점수를 토대로 평가를 원하는 제출결과에 대한 코드/모델/외부데이터(사용시) 모두 제출</li><li>코드제출방법: 추후 자유게시판에 공지</li><li>1차평가 결과(스타트업 및 예비창업자 그룹 각각 5위)는 대회종료인 12월 10일 이후 발표됩니다.</li><li>주의사항</li></ul><p>- 12월 5일 이전에 결과제출 하셨더라도 1차평가 기간동안 반드시 1회 이상 제출하셔야 합니다</p><p>- 상기 내용 대로 평가받고자 하는 코드/모델/외부데이터(사용시) 모두 제출하셔야 평가조건 외 완료됩니다.</p><p>- 평가결과(팀 최고점 또는 선택한 제출결과)와 코드/모델/외부데이터(사용시)의 재현결과가 다를 경우 자동 탈락됩니다.</p><h2><b>2. 개인 또는 팀 참여 규칙</b></h2><ul><li>&#039;팀병합&#039;은 개인들이 팀을 구성하는 것을 의미하며 팀을 합친다는 의미는 아닙니다.</li><li>개인 또는 팀을 이루어 참여할 수 있습니다.</li><li>개인 참가 방법: 팀 신청 없이, 자유롭게 제출 창에서 제출 가능합니다.</li><li>팀 구성 방법: 배너 하단 팀 탭을 클릭하고 해당 페이지에서 팀 구성 안내 확인</li><li>팀 최대 인원: 5 명</li></ul><p>- 동일인이 개인 또는 복수팀에 중복하여 등록 불가</p><h2><b>3. 외부 데이터 및 사전 학습 모델</b></h2><ul><li>참가자가 저작권 또는 사용허가를 획득한 외부 데이터로서 모델 성능 향상을 위해 가스・에너지분야의 문건들을 사용한 데이터의 사용이 권장됩니다.</li><li>법적 제약이 없으며 공개된 사전 학습 모델 사용이 허용됩니다.</li><li>외부데이터(가스・에너지분야의 문건) 요약문 가이드라인</li></ul><p>- 제목에서 제시된 주요 단어 활용</p><p>- 가장 중요하게 선택된 문장 활용</p><p>- 생성된 문장의 6하원칙 내용 표함</p><p>- 전체 문장의 10% 내외로 요약 (극단적 축약 및 복문 지양)</p><p>- 문장 원형 추출 금지</p><h2><b>4. 제출 규정</b></h2><ul><li>1일 최대 제출 횟수: 3회</li></ul><h2><b>5. 부정 행위</b></h2><ul><li>참가자가 사용한 외부데이터가 저작권을 침해하거나 사용허가를 득하지 않은 사실이 적발되는 즉시 탈락 조치됩니다.</li><li>모델 학습에서 검증 혹은 평가 데이터셋 활용(Data Leakage) 또는 수기 작성 시 실격됩니다.</li><li>최종 순위는 선택된 파일 중에서 채점되므로 참가자는 제출 창에서 자신이 최종적으로 채점 받고 싶은 파일을 선택해야 합니다.</li><li>데이콘은 부정 제출 행위를 금지하고 있으며 데이콘 대회 부정 제출 이력이 있는 경우 평가가 제한됩니다. 자세한 사항은 링크를 참고해 주시기 바랍니다.<a href="https://dacon.io/notice/notice/13" target="_blank">https://dacon.io/notice/notice/13</a></li><li>본 대회 페이지 url 유출을 금지합니다.</li></ul><h2><b>6. 질문 사항</b></h2><ul><li>대회 운영 및 데이터 이상에 관련된 질문 외에는 답변을 드리지 않고 있습니다. 기타 질문은 토론 페이지를 통해 자유롭게 토론해주시기 바랍니다.</li></ul>	<h2><b>세부 일정</b></h2><ul><li>대회기간 : 2021년 10월 11일 ~ 2021년 12월 10일</li><li>1차심사  : 2021년 12월 6일 ~ 2021년 12월 10일 (10팀 선발)</li><li>2차심사  : 2021년 12월 20일 또는 2021년 12월 21일 (순위 결정)</li></ul>	2021-11-29 15:00:00+00	2021-11-29 15:00:00+00	<p><b>🏆총 상금: 32,500,000원</b></p><h4><b>1. 스타트업</b><br /></h4><p>🥇1등     : 12,000,000원</p><p>🥈2등     :   5,000,000원</p><p>🥉3등     :   2,500,000원</p><ul><li>특별상 :   1,000,000원</li></ul><h2><b>2. 예비창업가</b></h2><p>🥇1등     :   5,000,000원</p><p>🥈2등     :   2,500,000원</p><p>🥉3등     :   1,500,000원</p><ul><li>특별상 :   1,000,000원</li></ul>	<p>본 대회의 테스트 데이터셋은 AIHub의<a href="https://aihub.or.kr/aidata/8054" target="_blank">문서요약 텍스트 | AI 허브 (aihub.or.kr)</a>데이터셋 신문기사의 비공개 평가 데이터로 구성되었습니다.</p><p>학습 데이터는 AIHub를 통해 다운로드 받아주시기 바랍니다.</p><h3><b>test.jsonl - 테스트 데이터셋</b></h3><ul><li>id: 데이터 고유아이디</li><li>article_original: 텍스트 내용</li><li>media: 언론사</li></ul><h3><b>sample_submission.csv - 제출양식</b></h3><ul><li>id: 데이터 고유아이디</li><li>summary: 예측한 요약문</li></ul><p><span style="color: inherit;">다운로드</span></p>	2021-11-17 12:21:00.584159+00	\N	t	57625ba079871d663166fe0b8b7f35a7	295d2eb4f0f10e01979246a045a32aec	\N	1	General	[]		0	0	[]	mse
1	따릉이 예측 문제	따릉이 대여량 예측 문제	<h2><b>데이콘 베이직 Basic은 입문용 분석 코드 2개와 데이터 탐색 코드 1개가 제공됩니다!</b></h2><p><span style="color: rgb(53, 55, 68);">데이터 분석을 하고 싶어도 방법을 몰라서 시도하지 못하셨나요?</span></p><p><span style="color: rgb(53, 55, 68);">데이콘 베이직 Basic 에서는 방법을 몰라도 누구나 따라할 수 있도록 코드를 제공해드립니다!</span></p><ul><li>입문자의 눈높이에 맞춰데이터 분석 Baseline 코드를 매주 월요일 1개씩, 총2회제공합니다.</li><li>데이터의 모양을 살펴볼 수 있도록탐색적 데이터 분석 (EDA) 코드를1회제공합니다.</li></ul><h3>그러니 데이터 분석을 잘 몰라도 편안한 마음으로 참가해주세요!</h3><h2><b>1. 배경</b></h2><ul><li><span style="color: rgb(53, 55, 68);">서울시 공유 자전거 “따릉이” 대여량과 날씨</span>데이터를 통해데이터 분석 대회에 입문해보세요.</li><li>다른 사람들과 실력을 겨뤄보며데이터 분석대회의 즐거움을 느껴보세요.</li><li>자신만의시각화 방법과 분석 방법을 공유하여 “좋아요”와 “댓글”을 모아보세요!</li><li>가장 많은 호응을 얻으신 분께는데이콘 후드를 선물로 드립니다!</li></ul><h2><b>2. 주제</b></h2><ul><li>서울의 일별 온도, 습도, 강수량 등 일기 예보 데이터를 통해 따릉이 대여량을 예측해보세요.</li><li>서울의 2018~2021년 4년 동안의 날씨 데이터와 2018~2020년의 따릉이 대여량 데이터가 주어집니다.</li><li>이 데이터를 이용해 2021년의 따릉이 대여량을 예측해보세요.</li><li>주어진 데이터이외의 데이터는 사용 금지입니다!</li></ul><h2><span style="color: rgb(53, 55, 68);"><b>3. 주최/주관</b></span></h2><ul><li>주최 및 주관: 데이콘</li></ul><h2><span style="color: rgb(53, 55, 68);"><b>4. 참가대상</b></span></h2><ul><li>데이터 분석, 머신러닝에 관심있는 분</li><li>컴피티션을 경험해보고 싶은 분</li></ul><h3><span style="color: rgb(53, 55, 68);">데이콘은 활발한 코드 공유를 통한 참가자 전원의 실력 향상을 목표로 합니다!</span></h3><h3><span style="color: rgb(53, 55, 68);">모든 정보 교환은 적극 환영합니다!</span></h3>	<p><span style="color: rgb(0, 0, 0);"><b>1. 평가</b></span><br /></p><ul><li>리더보드</li><li>평가 산식 : NMAE (Normalized Mean Absolute Error)</li></ul><p><img src="https://dacon.s3.ap-northeast-2.amazonaws.com/competition/235837/editor-image/163513348923557.jpeg" /></p><pre>import numpy as np<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" /><br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />def NMAE(true, pred):<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    score = np.mean(np.abs(true-pred) / true)<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" />    return score<br style="background-repeat: no-repeat; box-sizing: inherit; padding: 0px; margin: 0px;" /></pre><ul><li>public score : 전체 테스트 데이터 중 50%</li><li>private score : 전체 테스트 데이터 중 100%</li></ul><ul><li>리더보드 수상자 (1~3등) 코드 평가</li></ul><ol><li>Private 순위 공개 후 코드 제출 기간 내 코드 공유 게시판에 게시</li><li>제목 양식 : 팀 이름, Private 순위와 점수, 모델 이름 (e.g.데이콘팀, Private 1위, Private 점수 :5.23, RandomForest)</li><li>내용 : 전처리, 학습, 후처리, 추론 일련의 과정을 담은 코드 및 코드 설명을 게시.</li><li>참가자들의 &quot;좋아요&quot;, &quot;댓글&quot; 및 정성 평가를 통해 특별상 수상자 선정</li></ol><h2><span style="color: rgb(68, 68, 68);"><b>2. 개인 또는 팀 참여 규칙</b></span></h2><ul><li>1일 최대 제출 횟수 : 3회</li><li>개인으로만 참여할 수 있습니다. (팀 구성 X)</li><li>개인 참가 방법 : 팀 신청 없이, 자유롭게 제출 창에서 제출 가능</li></ul><h2><b>3. 부정 행위</b></h2><ul><li>아래 사항들은 모두부정행위로 간주합니다.</li><li>주어진학습 데이터(train.csv)이외의 데이터를 학습에 사용</li><li>테스트 데이터(test.csv)를학습에 사용 (* 제출 파일 생성에만 사용해주세요)</li><li>외부에 공개된원본 데이터를 사용</li><li>사전 학습(pretrained) 모델사용</li><li>대회 진행 중 부정행위가 의심되는 경우, 데이콘 측에서 코드 제출을 요청할 수 있습니다.</li><li>요청 3일 이내 코드를 제출하지 않을 시 리더보드에서 기록이 삭제됩니다.</li><li>대회 종료 후 부정행위가 확인된 경우, 리더보드에서 기록이 삭제되며 수상자 명단에서 제외됩니다.</li><li><span style="color: rgb(68, 68, 68);">데이콘은 부정행위를 엄격히 금지하고 있으며 데이콘 대회 부정 제출 이력이 있는 경우 평가가 제한됩니다.</span></li><li><span style="color: rgb(68, 68, 68);">자세한 사항은 다음의 링크를 참고해 주시기 바랍니다.</span><a href="https://dacon.io/notice/notice/13" target="_blank">https://dacon.io/notice/notice/13</a></li></ul><h2><span style="color: rgb(68, 68, 68);"><b>4. 유의 사항</b></span></h2><ul><li>1일 최대 제출 횟수: 3회</li><li>모델 학습에서 검증 혹은 평가 데이터셋 활용 시 Data Leakage로 판단하여 실격 처리됩니다. (부정 행위)</li><li>최종 순위는 선택된 파일 중에서 채점되므로 참가자는 제출 창에서 자신이 최종적으로 채점 받고 싶은 파일을 선택해야 합니다.</li><li>대회 직후 공개되는 Private 랭킹은 최종 순위가 아니며 코드 검증 후 수상자가 결정됩니다.</li><li>대회 종료 후 리더보드 및 코드 공유 수상자 순위를 결정합니다.</li></ul>	<h2><span style="color: rgb(68, 68, 68);"><b>대회 일정 Timeline</b></span></h2><ul><li>대회 오픈 :2021-11-01(월) 10:00</li><li><span style="color: rgb(68, 68, 68);">대회 종료 : 2021-11-12</span>(금) 18:00</li><li><span style="color: rgb(68, 68, 68);">코드 제출 마감 : 2021-11-16</span>(화) 23:59</li><li>최종 순위 발표 : 2021-11-18 (목)</li></ul>	2021-11-23 15:00:00+00	2021-11-19 15:00:00+00	<h2><b>상금</b></h2><p><span style="color: rgb(53, 55, 68);">순위에 상관없이 제출만 해도 XP를 지급하며, 코드 공유의 경우 특별상으로</span><span style="color: rgb(53, 55, 68);">“데이콘 후드”</span><span style="color: rgb(53, 55, 68);">를 드립니다!</span></p><p><span style="color: rgb(53, 55, 68);">(데이콘은 활발한 코드 공유를 통한 참가자 전원의 실력 향상을 목표로 합니다!)</span></p><h3><b>대회 리더보드 보상</b></h3><p><span style="color: rgb(53, 55, 68);">🥇1등</span><span style="color: rgb(53, 55, 68);">: 100 XP</span></p><p><span style="color: rgb(53, 55, 68);">🥈</span><span style="color: rgb(53, 55, 68);">2등</span><span style="color: rgb(53, 55, 68);">: 95 XP</span></p><p><span style="color: rgb(53, 55, 68);">🥉</span><span style="color: rgb(53, 55, 68);">3등 : 90 XP</span></p><p><span style="color: rgb(53, 55, 68);">🏅그 외 참여해주신 모든 분들 :</span><span style="color: rgb(53, 55, 68);">50 XP</span></p><p><span style="color: rgb(53, 55, 68);">(참가 신청 시 자동으로 제출되는 경우는 포함되지 않습니다!)</span></p><p>※ 리더보드 1등, 2등, 3등 대상자는 부정행위 여부 검증을 위해</p><p>대회 종료 후 코드 공유를 반드시 진행해주셔야 보상 지급이 가능합니다.</p><h3><b>코드 공유 보상</b></h3><p><span style="color: rgb(53, 55, 68);">✨</span>대회 진행 중 EDA 코드 공유: 100XP</p><p><span style="color: rgb(53, 55, 68);">🎊</span>대회 종료 후 예측 코드 공유: 100XP</p><p>(부정행위 적발 시 지급 대상에서 제외됩니다.)</p><p><span style="color: rgb(53, 55, 68);">🏆</span><span style="color: rgb(53, 55, 68);">특별상: “데이콘 후드티”</span></p><p>(특별상 선정 기준은 좋아요 수, 댓글 수, 정성 평가를 포함합니다)</p><p><img src="https://dacon.s3.ap-northeast-2.amazonaws.com/competition/235836/editor-image/1634202825906700.jpeg" width="600" /></p><p>※ 대회 진행 중 Submission 제출 시, 좋아요, 댓글 작성 시 XP 지급 (<a href="https://dacon.io/more/notice/77" target="_blank">DACON XP</a><a href="https://dacon.io/more/notice/77" target="_blank">|</a><a href="https://dacon.io/more/notice/77" target="_blank">데이콘 XP(경험치)</a><a href="https://dacon.io/more/notice/77" target="_blank">- DACON</a>)</p><p>※ 대회 종료 후 리더보드, 코드 공유 보상 대상자 XP 추가 지급</p>	<h3><b>1. bicycle_train.csv : 학습 데이터</b></h3><ul><li>date_time: 일별 날짜</li><li>wind_direction: 풍향 (degree)</li><li>sky_condition: 하늘 상태 (하단 설명 참조)</li><li>precipitation_form: 강수 형태 (하단 설명 참조)</li><li>wind_speed: 풍속(m/s)</li><li>humidity: 습도(%)</li><li>low_temp : 최저 기온 ( `C)</li><li>high_temp : 최고 기온 ( `C)</li><li>Precipitation_Probability : 강수 확률 (%)</li><li>number_of_rentals : 따릉이 대여량</li></ul><h3><b>2. bicycle_test.csv : 테스트 데이터</b></h3><ul><li>date_time: 일별 날짜</li><li>wind_direction: 풍향</li><li>sky_condition: 하늘 상태</li><li>precipitation_form: 강수 형태</li><li>wind_speed: 풍속</li><li>humidity: 습도</li><li>low_temp : 최저 기온</li><li>high_temp : 최고 기온</li><li>Precipitation_Probability : 강수 확률</li></ul><h3><b>3. sample_submissoin.csv : 제출 양식</b></h3><ul><li>date_time: 일별 날짜</li><li>number_of_rentals : 따릉이 대여량</li></ul><h2><b>데이터 상세 설명</b></h2><ul><li>기상 데이터는 하루에 총 8번 3시간 간격으로 발표되는 기상단기예보(SHRT) 데이터를1일 평균으로 변환한 데이터입니다.</li><li>2019년 6월 4일 까지 sky_condition(하늘 상태) 코드  : 맑음(1), 구름조금(2), 구름많음(3), 흐림(4)</li><li>2020년  sky_condition(하늘 상태) 코드  : 맑음(1), 구름많음(3), 흐림(4)</li><li>precipitation_form (강수 형태) 코드 : 없음(0), 비(1), 진눈깨비(2), 눈(3), 소나기(4)</li><li>원본 데이터에는 없음(0), 비(1),소나기(4)가 포함되어있었으며 진눈깨비(2)와 눈(3) 성분은 존재하지 않습니다.</li></ul><p><span style="color: rgb(136, 136, 136);">위 자료는 아래 공공 데이터를 바탕으로 제작되었습니다.</span></p><ul><li><span style="color: rgb(136, 136, 136);">[기상청] 기상자료개방포털</span></li><li><span style="color: rgb(136, 136, 136);">[서울특별시] 서울 열린데이터 광장</span></li></ul>	2021-11-17 10:36:03.260017+00	\N	t	2a9ee3aaa07056d72410d4ca4335851d	356d4aa1e4926760869b89ed3c7a4b3f	\N	1	General	[]		0	0	[]	acc
4	빅데이터 통신 플랫폼	빅데이터 통신 플랫폼	<h2><b>[주제]</b></h2><ul><li>코로나 시대와 함께하는 국민의 음식, 배달 문화 변화에 대한 시각화 처리</li></ul><h2><b>[배경]</b></h2><ul><li>2019년부터 3년간 약 1,500억원의 정부 예산이 투입되어 통신, 유통 등 10개 플랫폼과 100여개의 센터가 연계된 &quot;빅데이터 플랫폼 및 센터 구축&quot; 사업이 진행 중에 있습니다.</li><li>본 대회는 통신 분야 플랫폼으로 선정된 KT와 충북대 주최로 통신 빅데이터 플랫폼(<a href="https://www.bigdata-telecom.kr/" target="_blank">https://www.bigdata-telecom.kr</a>) 내 데이터를 활용하여 포스트 코로나 시대 유의미한 인사이트 도출과 빅데이터 기반의 생태계 활성화를 목적으로 합니다.</li></ul><h2><b>[대회 설명]</b></h2><ul><li>빅데이터를 통해 코로나 시대 의미 있는 인사이트 도출</li><li>빅데이터 분석 생태계 활성화 및 아이디어 발굴</li></ul><h2><b>[주최 / 주관]</b></h2><ul><li>주최 : 충북대학교, KT 통신 빅데이터 플랫폼</li><li>주관 : 충북대학교, 데이콘</li></ul><h2><b>[참가 대상]</b></h2><ul><li>일반인, 학생, 직장인 등 누구나 참여 가능</li><li>2020년 KT 포스트 코로나 데이터 시각화 경진대회 수상자는 참여 불가</li><li><a href="https://www.dacon.io/competitions/official/235618/overview/description" target="_blank">https://www.dacon.io/competitions/official/235618/overview/description</a></li></ul>	<h1><b>[규칙]</b></h1><h2><b>1. 평가</b></h2><h2><b>- 가채점 순위(Public Score): 유저 평가로 상위 10팀 선정</b></h2><p>- 최종 순위(Private Score): 심사위원단 평가로 최종 순위 결정</p><p>[가채점 순위(Public Score)]</p><p>시각화 대회는 투표로 점수가 산정됩니다. 다음과 같이 사용자의 투표에 가중치를 부여합니다.</p><ul><li>브론즈 이상 사용자 (가중치 브론즈 1, 실버 1.1, 골드 1.2, 챌린저 1.3, 챔피언1.4)</li><li>일반 사용자 (가중치 0.2)</li></ul><p>[최종 순위(Private Score)]</p><p>심사위원단의 정성평가로 최종 순위가 결정됩니다.</p><ul><li>평가 대상 :가채점 순위 상위 10팀 중 PPT 제출을 완료한 팀</li><li>심사기준 :<a href="https://www.dacon.io/competitions/official/235753/talkboard/403784/" target="_blank">평가방법</a></li></ul><h2><b>2. 개인 또는 팀 참여 규칙</b></h2><ul><li>개인 또는 팀을 이루어 참여할 수 있습니다.</li><li>단체 혹은 기관 참여시 별도의 절차가 필요합니다. (More &gt; 공지사항&gt; 게시글 확인)</li><li>개인 참가 방법: 팀 신청 없이, 자유롭게 제출 창에서 제출 가능</li><li>팀 구성 방법: 팀 페이지(<a href="https://dacon.io/competitions/official/235753/team" target="_blank">https://dacon.io/competitions/official/235753/team</a>)에서 팀 구성 안내 확인</li><li>팀 최대 인원: 4 명</li></ul><p>* 동일인이 개인 또는 복수팀에 중복하여 등록 불가.</p><ul><li>팀의 수상 요건 충족 시 팀의 대표가 수상</li></ul><h2><b>3. 참여 부문 및 아이템의 제한</b></h2><ul><li>타인의 특허 또는 실용신안 등 지적재산권을 침해하거나 침해할 우려가 있는 아이템</li><li>2020년 KT 포스트 코로나 데이터 시각화 경진대회 수상자는 참여 불가</li><li><a href="https://www.dacon.io/competitions/official/235618/overview/description" target="_blank">https://www.dacon.io/competitions/official/235618/overview/description</a></li></ul><h2><b>4. 대회문의</b></h2><ul><li>대회 운영 및 데이터 이상에 관련된 질문 외에는 답변을 드리지 않고 있습니다. 기타 질문은 토론 페이지를 통해 자유롭게 토론해주시기 바랍니다.</li><li>데이콘 답변을 희망하는 경우 [대회문의] 페이지에 질문을 올려 주시기 바랍니다.</li></ul><h2><b>5. 제출 방법</b></h2><ul><li>대회의 코드 공유 페이지에 시각화 자료 게시</li><li>사용 가능 툴: Python, R, Tableau</li><li>게시물 형식 : .ipynb 또는 .twbx</li><li>.ipynb 파일 크기는 20MB를 초과할 수 없음</li></ul><h2><b>6. PPT 자료</b></h2><ul><li>제출 대상 :대회 참여자</li><li>제출 메일 : dacon@dacon.io</li><li>제출 마감 기한 :2021년 8월 26일 17:59</li><li>형식 : 자유 형식</li></ul>	<h1><b>[세부 일정]</b></h1><ul><li>데이터 오픈 : 2021년 7월 28일 10:00</li><li>대회 기간 : 2021년 7월 28일 10:00 ~ 2021년 8월 26일 17:59</li><li>팀 병합 마감 : 2021년 8월 12일</li><li>코드 및<span style="color: rgb(230, 0, 0);"><b>PPT 제출</b></span>기간 : 대회 기간과 동일 (*<a href="http://mailto:dacon@dacon.io" target="_blank">dacon@dacon.io</a>제출)</li><li>투표 기간 : 코드 제출 시점 ~ 2021년 8월 26일 17:59</li><li>최종 심사 및 시상식 개최 : 2021년 8월 26일 17:59 ~ 2021년 9월 1일 17:59</li><li>최종 결과 발표: 2021년 9월 1일 18:00</li><li>시상식 개최: 2021년 9월 2일(온라인)</li></ul><p>※ 세부 일정은 대회 운영상황에 따라 변동될 수 있습니다.</p>	2021-11-17 15:00:00+00	2021-11-19 15:00:00+00	<h1><b>🏆 총상금 400만원</b></h1><ul><li>대상 : 200만원 (충북대 총장 상)🏆</li><li>최우수상 : 100만원 (KT 상무 상)🥇</li><li>우수상 : 50만원 (빅데이터서비스학회장상)🥈</li><li>장려상: 50만원🥉</li></ul><p>※ Zoom 활용한 유튜브 라이브 송출, 수상자 온라인 상장 수여</p><p><b>※대상(1팀)은 연말 과학기술정보통신부 주체 통합 경진대회 참가 기회 제공</b></p>	<p>**<b><span style="color: rgb(230, 0, 0);">KT 빅데이터플랫폼 데이터는 &quot;</span><span style="color: rgb(230, 0, 0);">2021 빅데이터 통신 플랫폼 경진대회</span><span style="color: rgb(230, 0, 0);">&quot; 에서만 활용할 수 있습니다.</span></b></p><p><span style="color: rgb(230, 0, 0);"><b>또한, 대회가 종료되면 데이터는 다운로드 받으실 수 없습니다.</b></span></p><p>2021년 08월 10일 데이터 업데이트</p><p>StartupOrClosing_Region.csv --&gt; StartupOrClosing_Region_ver2.csv</p><p>StartupOrClosing_Shop.csv --&gt; StartupOrClosing_Shop_ver2.csv</p><p>데이터 출처: KT빅데이터플랫폼</p><p>KT빅데이터플랫폼에 가입하셔서 다양한 데이터 및 손쉬운 분석/시각화 서비스를 경험하세요.</p><p>메인 포털 :<a href="https://www.bigdata-telecom.kr/" target="_blank">https://www.bigdata-telecom.kr</a></p><p>dlvr_call.csv (1.25GB)</p><ul><li>배달 호출 데이터 (출처 : KT 통신 빅데이터 플랫폼 내 경기대학교 데이터)</li><li>음식점에서 배달을 위해 배달기사를 호출하고 고객에게 배달이 완료되는 과정에서 생산되는 데이터</li></ul><p>popl.csv (972MB)</p><ul><li>행정동별 생활인구 데이터 (출처 : KT 통신 빅데이터 플랫폼 내 KT 데이터)</li><li>시간대-행정동-성별-연령 구분에 따른 생활인구 데이터</li></ul><p>StarupOrClosing_Shop_ver2.csv(11.4MB)</p><ul><li>업종/상호별 창업.폐업 유추 데이터 (출처 : KT 통신 빅데이터 플랫폼 내 (주)네스 데이터)</li><li>114에 등록된 정보 기반의 업종/상호별 창업/폐업 유추 분류 데이터</li></ul><p>StartupOrClosing_Region_ver2.csv(5.96MB)</p><ul><li>업종/지역별 창업/폐업 유추 데이터 (출처 : KT 총신 빅데이터 플랫폼 내 (주)네스 데이터)</li><li>114에 등록된 정보 기반의 업종/지역별 창업/폐업 유추 분류 데이터</li></ul><p>*식품 영양소 데이터는 추후 업데이트 예정</p><p>================================================================================</p><p>COVID_19 (625KB) -&gt; 작년과 동일한 코로나 확진자 데이터 정보</p><p>- 코로나 확진자 데이터 (출처: DS4C<a href="https://github.com/jihoo-kim/Data-Science-for-COVID-19" target="_blank">https://github.com/jihoo-kim/Data-Science-for-COVID-19</a>)</p><p>COVID_eng_kor_table.xlsx (20KB) -&gt; 작년과 동일한 코로나 확진자 데이터 정보</p><p>- 코로나 데이터 province, city 컬럼 영/한 변환 테이블 (Google Translate API 사용)</p><h4>상세</h4>	2021-11-17 12:53:06.332264+00	\N	t	776b732d35be4ccef74aff51ebeded44	9a9194e331a99e57b955a0d4deac9ba3	\N	1	General	[]	1111	0	0	["root", "mink"]	acc
7	AI 기반 회의 녹취록 요약	AI 기반 회의 녹취록 요약	<h2><b>1. 배경</b></h2><p>회의에서 논의된 내용 중 핵심 안건을 정리해주는 회의 요약 서비스는 수기 회의록 작성에 드는 부담을 완화하고, 참여자들에게 논의 결과를 한 눈에 보여줄 수 있습니다.</p><p>이러한 서비스를 위해서는 긴 시간동안 다수의 발화자가 대화한 내용으로부터 핵심 내용을 가독성 좋은 요약문으로 생성하는 요약 모델 개발이 필수적입니다.</p><p>본 대회에서는 문서화된 회의 녹취록에 대해 요약문을 라벨링한 데이터셋을 활용하여 회의 내용을 요약하고자 합니다.</p><h2><b>2. 주제</b></h2><ul><li>문서화된 회의 녹취록에서 핵심 내용을 요약하는생성요약 AI모델개발</li></ul><h2><b>3. 주최 / 주관</b></h2><ul><li>주최:LG AI Research</li><li>주관:데이콘</li></ul><h2><b>4. 참가 대상</b></h2><ul><li>대학생 / 대학원생 / 직장인 등 누구나</li></ul>	<h2><b>1. 제출 횟수 및 팀 최대 인원</b></h2><ul><li>1일 최대 제출 횟수 : 3회</li><li>팀 최대 인원 : 3명</li></ul><h2><b>2. 평가 방식</b></h2><ul><li>1차 평가 : Private리더보드 상위 10팀 선발</li><li>본대회에서는 모델이 예측한 생성요약문과 사람이 생성한 요약문의 ROUGE-N에 대한 F1 SCORE를 사용</li></ul><p><img src="https://dacon.s3.ap-northeast-2.amazonaws.com/competition/0/235671-rule.png" /></p><ul><li>채점 기준: ROUGE-1(점수1), ROUGE-2(점수2), ROUGE-L(점수3)</li><li>Public Score : 테스트 데이터 중 랜덤 샘플 50%로 채점, 대회 기간 중 공개</li><li>Private Score : 테스트 데이터 중 나머지 50%로 채점, 대회 종료 후 공개(1차 평가 순위 기준)</li><li>순위 기준</li><li>3가지 지표에대한 개별 순위의 합산 오름차순( ex - ROUGE-1:1위, ROUGE-2:3위, ROUGE-L:2위 =&gt; 1+3+2=6점)</li><li>합산 점수 동률시 제출 시간 오름차순</li><li>2차 평가 : 온라인 대면 평가, 상위 3팀 수상</li></ul><p>[평가 항목]</p><ul><li>모델 성능</li></ul><p>- 리더보드 Private 점수 : 40</p><p>- HARD EXAMPLE 점수 : 20</p><ul><li>적용 가능성</li></ul><p>- 동작 속도 : 10</p><p>- 모델&데이터 로딩 후 데이터 전처리 ~ 추론(batch size:1) ~ 결과 저장 시간 측정</p><ul><li>아이디어</li></ul><p>- 발표 내용, 질의 응답 : 20</p><p>- 모델 창의성 / 모델의 한계 분석 등</p><ul><li>(가산점) 추가 개선의 아이디어 제시 : 10</li></ul><h2><b>3. 학습 및 추론</b></h2><ul><li>누구나 사용할 수 있는 공개된 외부 데이터는 활용할 수 있으나, 추가로 사용한 데이터를 반드시 명시해야 함</li><li>대회 공개 시점(2021년 9월 13일 전)에 누구나 다운로드하여 활용이 가능한 공개된 사전학습 모델 사용 가능 (Google Multilingual BERT, KorBERT, KoBERT, KoGPT2, KoBART 등)</li><li>대회 공개 시점 및 진행기간동안 공개되어 있지 않은 사전학습 모델 사용 시 실격</li><li>코드와 체크포인트가 모두에게 공개되어 있는 사전학습된 체크 포인트에 한하여 fine-tuning을 통한 활용 가능</li><li>단, 제출한 모델은 Google Colab 무료 환경 (GPU:K80 / 메모리 12GB)에서 추론이 가능해야 함. (해당 환경에서 추론 불가 시 실격 처리)</li></ul><h2><b>4. 제출 파일</b></h2><ul><li>대회 종료 후 평가 대상자는 코드와 PPT를 제출</li></ul><p>- 코드에 &#039;/data&#039; 데이터 입/출력 경로 포함</p><p>- 코드 파일 확장자 : .R, .rmd, .py, .ipynb</p><ul><li>코드 제출 유의 사항</li></ul><p>- 코드 인코딩 : UTF-8</p><p>- 개발환경(OS) 및 라이브러리 버전 기재</p><p>- 전체 실행 프로세스 및 코드 실행 방법을 readme 파일로 정리해서 제출</p><p>- 코드에 대한 주석을 일일이 달 필요는 없으나, 실행 방법대로 실행 시 모든 코드가 오류 없이 실행되어야 합니다.</p><p>(라이브러리 로딩 코드 포함)</p><ul><li>PPT 제출 유의사항</li></ul><p>- 데이터 전처리 / 모델링에 대한 간략한 설명</p><p>- (사용했을 시) 추가 데이터셋 혹은 Pre-trained 모델 명시</p><h2><b>5. 개인 및 팀 병합 규정</b></h2><ul><li>개인 참가 방법 : 팀 신청 없이, 자유롭게 제출탭에서 제출 가능</li><li>팀 참가 방법 : 팀 탭에서 가능, 상세 내용은 팀 탭에서 팀 병합 정책 확인</li><li>하나의 대회는 하나의 팀으로만 등록 가능</li><li>팀 병합 후 해체 및 개인 참가 불가</li><li>팀의 수상 요건 충족시 팀의 대표가 수상</li></ul><h2><b>6. 유의 사항</b></h2><ul><li>사용 가능 언어 : Python, R</li><li>최종 순위는 선택된 파일 중에서 채점되므로 참가자는 제출 창에서 자신이 최종적으로 채점받고 싶은 파일을 선택해야 함(최대 2개 선택 가능)</li><li>대회 직후 공개되는 Private 랭킹은 최종 순위가 아니며 2차 평가(온라인 대면 평가) 후 수상자가 결정 됨</li><li>데이콘은 타팀과의 비공개 공유, 다중 계정 사용 등 부정행위를 금지하고 있으며 데이콘 대회 부정 제출 이력이 있는 경우 평가가 제한될 수 있음. 자세한 사항은 아래 링크 참고</li></ul><p><a href="https://dacon.io/notice/notice/13" rel="nofollow" target="_blank">https://dacon.io/notice/notice/13</a></p>	<h1><b>세부 일정</b></h1><ul><li>대회 페이지 공개: 2021년 09월 13일</li><li>팀 병합 마감 : 2021년 10월 18일</li><li>대회 기간 : 2021년 09월 27일 10:00 ~ 2021년 10월 25일 18:00</li><li>코드 및 발표 자료 제출 기간 : 2021년 10월 26일 ~ 2021년 10월 31일</li><li>코드 및 PPT 평가 : 2021년 11월 1일 ~ 2021년 11월 10일</li><li>온라인 대면 평가 : 2021년 11월 11일</li><li>최종 결과 발표 : 2021년 11월 17일</li></ul><p><span style="color: rgb(68, 68, 68);">※ 세부 일정은 대회 운영상황에 따라 변동될 수 있습니다.</span></p>	2021-11-18 15:00:00+00	2021-11-21 15:00:00+00	<h1><b>🏆 총 상금 1,000만원</b></h1><ul><li>1등 : 500만원 🥇</li><li>2등 : 300만원 🥈</li><li>3등 : 200만원 🥉</li></ul><p>※ 상위팀 입사 희망자 LG 계열사 입사 추천(최상위 10명 서류 전형 면제) 및 LG AI인재풀 등록</p><p>※ 제세공과금 제외한 금액 입금 예정</p>	<p>1. train.json : 학습용 데이터셋</p><p>├ id : 회의록 id</p><p>├ region : 회의 지역</p><p>├ num_agenda : 안건 수</p><p>│ ├ AGENDA_1 : 안건1</p><p>│ ├ AGENDA_2 : 안건2</p><p>│ ├ AGENDA_3 : 안건3</p><p>│ └ ...</p><p>└ label : 안건별 요약문</p><p>├ AGENDA_1 : 안건1의 요약문</p><p>│ ├ evidence : 요약 근거</p><p>│ └ summary : 요약문(정답)</p><p>├ AGENDA_2 : 안건2의 요약문</p><p>│ ├ evidence : 요약 근거</p><p>│ └ summary : 요약문(정답)</p><p>├ AGENDA_3 : 안건3의 요약문</p><p>│ ├ evidence : 요약 근거</p><p>│ └ summary : 요약문(정답)</p><p>└ ...</p><p>2. test.json : 평가용 데이터셋</p><p>├ id : 회의록 id</p><p>├ region : 회의 지역</p><p>├ num_agenda : 안건 수</p><p>└ context : 회의내용</p><p>├ AGENDA_1 : 안건1</p><p>├ AGENDA_2 : 안건2</p><p>├ AGENDA_3 : 안건3</p><p>└ ...</p><p>3. sample_submission.csv : 제출용 양식</p><p>- uid : test.json의 안건별 고유 id (&#039;id2000-AGENDA_1 : id2000회의의 안건1)</p><p>- summary : 안건의 요약문</p><p><span style="color: inherit;">다운로드</span></p>	2021-11-18 11:43:38.938956+00	\N	t	8ae9a979798be52164ddb12a7b071a56	b577fcffbff8e787e4bb8e302e02e88f	\N	1	General	[{"score": 0, "userid": 2, "username": "mink", "submitTime": "2021-11-22 12:13:16"}]		0	0	["mink"]	mse
8	작물 병해 분류 AI 대회	작물 병해 분류 AI 대회	<h1><b>1. 배경</b></h1><p>농사에서 병해 진단 및 발병 원인을 찾는 것은 작물 재배에 있어 중요한 요인입니다.</p><p>병해 피해를 입은 작물 사진을 통해 병해를 진단해주세요.</p><h1><b>2. 목적</b></h1><p>병해 판별 및 처방에 도움을 줄 수 있는 인공지능 기술 개발을 통해 질병에 대한 조기 방제가 가능토록 하여 농작물의 병해 피해 감소와 농가소득 증대</p><h1><b>3. 주최 / 주관 / 운영</b></h1><ul><li>주최 :<span style="color: rgb(34, 34, 34);">한국지능정보사회진흥원(NIA)</span></li><li>주관 : 팜한농</li><li>운영 : 데이콘</li></ul><p>※<span style="color: rgb(34, 34, 34);">본 해커톤은 &#039;2021년 인공지능 학습용 데이터 구축사업&#039;의 일부이며 한국지능정보사회진흥원(NIA)의 지원으로 진행됩니다.</span></p><h1><b>4. 참가 대상</b></h1><h1>일반인, 학생 등 누구나</h1>	<h2><b>1. 규칙</b></h2><ul><li>제출 횟수 및 최대 팀원</li></ul><ol><li>1일 최대 제출 횟수 : 3회</li><li>팀 최대 인원 : 1명</li><li>개인 참여만 가능</li></ol><ul><li>리더보드</li></ul><ol><li>평가 산식 : macro-f1</li><li>public score : 전체 테스트 데이터 중 33%</li><li>private score : 전체 테스트 데이터 중 67%</li></ol><ul><li>코드 평가</li></ul><ol><li>다음 조건을 만족하며 제출한 코드로 Private Score 복원된 상위 3팀에게 상금 수여</li><li>Private 순위 공개 후 코드 제출 기간 내 코드 공유 게시판에 게시한 팀</li><li>제목 양식 : 팀 이름, Private 순위와 점수, 모델 이름.예) 데이콘팀, Private 1위, Private 점수 :5.23, ResNet</li><li>내용 : 전처리, 학습, 후처리, 추론 일련의 과정을 담은 코드를 게시.</li></ol><h2><b>2. 외부 데이터 및 사전학습 모델</b></h2><ul><li>공공 데이터와 같이 누구나 얻을 수 있고 법적 제약이 없는 외부 데이터 허용</li><li>사전학습 모델의 경우 사전학습에 사용된 데이터를 명시해야함</li></ul><h2><b>3. 유의 사항</b></h2><ul><li>사용 가능 언어 : Python, R</li><li>최종 순위는 선택된 파일 중에서 채점되므로 참가자는 제출창에서 자신이 최정적으로 채점 받고 싶은 파일을 선택해야 함(최대 2개 선택)</li><li>대회 직후 공개되는 Private 랭킹은 최종 순위가 아니며 코드 검증 후 수상자가 결정됨</li><li>데이콘은 부정 제출 행위를 금지하고 있으며 데이콘 대회 부정 제출 이력이 있는 경우 평가가 제한됩니다. 자세한 사항은 아래의 링크를 참고해주시기 바랍니다.<a href="https://dacon.io/notice/notice/13" target="_blank">https://dacon.io/notice/notice/13</a></li></ul><h2><b>4. 대회문의</b></h2><ul><li>대회 운영 및 데이터 이상에 관련된 질문 외에는 답변을 드리지 않고 있습니다. 기타 질문은 토론 페이지를 통해 자유롭게 토론해주시기 바랍니다.</li><li>데이콘 답변을 희망하는 경우 [대회문의] 페이지에 질문을 올려주시기 바랍니다.</li></ul>	<h2><b>세부일정</b></h2><ul><li>대회 기간 : 2021년 10월 13일(수) 11:00 ~ 2021년 10월 22일(금) 18:00</li><li>코드 제출 : 2021년 10월 23일(토) ~ 2021년 10월 25일(월)</li><li>최종 순위 발표 : 2021년 10월 29일(금)</li></ul><p>※ 세부 일정은 대회 운영상황에 따라 변동될 수 있습니다.</p>	2021-11-17 15:00:00+00	2021-11-19 15:00:00+00	<p>🏆 총 상금 100만원</p><p>•🥇1등- 50만원</p><p>•🥈2등- 30만원</p><p>•🥉3등- 20만원</p>	<p>train.csv - 학습 데이터</p><ul><li>uid : 데이터 고유 아이디</li><li>img_path : 이미지 데이터 경로</li><li>disease : 병해정보</li><li>disease_code : 병해 코드</li></ul><p>test.csv - 테스트 데이터</p><ul><li>uid : 데이터 고유 아이디</li><li>img_path : 이미지 데이터 경로</li></ul><p>sample_submission - 제출 양식</p><ul><li>uid : 데이터 고유 아이디</li><li>disease_code : 병해 코드</li></ul><p>train_imgs : 학습 이미지 데이터</p><p>test_imgs : 테스트 이미지 데이터</p>	2021-11-18 11:47:08.716051+00	\N	t	a10fc129e41b306650d02168db3d650e	aa60205ae2667a1381dce4375192c242	\N	1	General	[]		0	0	["mink"]	logloss
6	빅데이터 활용 경진대회	빅데이터 활용 경진대회	<h4><b>[주제]</b></h4><ul><li>해양과학자료 분석에 기초한 해양물리, 해양화학, 해양생물, 해양지질, 해양기상, 수산응용 분야에서의 지식발견</li></ul><h4><b>[목적]</b></h4><ul><li>오픈사이언스 기반의 &#039;해양과학데이터 저장소(JOISS)&#039;와 오픈 해양데이터 활용 증진</li><li>해양 빅데이터 분야의 연구 및 산업 활성화</li></ul><h4><b>[주최/주관]</b></h4><ul><li>주최: 해양수산부</li><li>주관: 부경대학교, (사)한국해양학회, (사)대한원격탐사학회, (주)환경과학기술, 데이콘</li></ul><h4><b>[참가 대상]</b></h4><ul><li>대한민국 국민 누구나(대한민국 국적이 아니더라도 우리나라 소재 대학에 재학중인 대학생 및 대학원생 포함) ※개인 또는 팀 제약 없이 구성</li></ul>	<h1><b>규칙</b></h1><h4><b>1. 평가</b></h4><p>- 1차 평가: 유저 평가로 상위 10개팀 선정</p><p>- 2차 평가: 심사위원단 평가로 최종 순위 결정</p><p>1차 심사[유저 평가]</p><ul><li>다음과 같이 사용자의 투표에 가중치를 부여합니다.</li><li>브론즈 이상 사용자 (가중치 브론즈 1, 실버 1.1, 골드 1.2, 챌린저 1.3, 챔피언1.4) 일반 사용자 (가중치 0.2)</li></ul><p>2차 심사[심사위원단 평가]</p><ul><li>전문 심사위원단의 정성평가로 최종 순위가 결정됩니다.</li><li>평가 대상: 1차 평가 상위 10팀 중 발표 자료 동영상 제출을 완료한 팀</li><li>전문가 평가: 기제출한 동영상, 설명자료, 소스코드 등으로 전문가 심사위원단이 평가(추가자료 제출은 필요 없음)</li></ul><p>**심사위원**</p><ul><li><span style="color: rgb(17, 17, 17);">강○○ 기업 대표</span></li><li><span style="color: rgb(17, 17, 17);">김○○ 대학 교수</span></li><li><span style="color: rgb(17, 17, 17);">김○○ 대학 교수</span></li><li><span style="color: rgb(17, 17, 17);">양○○ 정부출연연구기관</span></li><li><span style="color: rgb(17, 17, 17);">오○○ 대학 교수</span></li><li><span style="color: rgb(17, 17, 17);">임○○ 대학 교수</span></li><li><span style="color: rgb(17, 17, 17);">조○○ 대학 교수</span></li><li><span style="color: rgb(17, 17, 17);">한○○ 정부출연연구기관</span></li></ul><p>a. 평가기준 및 규칙</p><ul><li>(1차)‘개인’참가: 팀 신청 없이, 결과 동영상(목적, 자료수집, 분석과정, 결과, 의의 등을 포함하여 5분 이내) 및 코드 제출</li><li>(1차)‘팀’참가: 팀 병합 후 결과 동영상(목적, 자료수집, 분석과정, 결과, 의의 등을 포함하여 5분 이내) 및 코드 제출</li><li>1차 아이템 심사에서 투표결과 기준 상위 10팀 선정</li><li>2차 심사는 1차 선정팀을 대상으로 전문가 심사하여 수상등급 결정</li><li>2차 심사에서 해양과학데이터 저장소(JOISS,<a href="https://joiss.kr/)" target="_blank">https://joiss.kr</a>)의 개선사항 제시할 경우 가점 부여</li><li>2차 심사 일정 및 평가방법은 추후 통보</li><li>2021. 10. 31 – 2021. 11. 12 중 1차 평가를 총과한 상위 10팀을 대상으로 전문가 평가 진행</li></ul><p>b. 제출 방법</p><ul><li>결과 동영상(목적, 자료수집, 분석과정, 결과, 의의 등을 포함하여 5분 이내) 및 코드 공유</li><li>사용 가능 툴: Python, R, QGIS 등 해양과학자료 분석이 가능한 모든 툴</li><li>게시물 형식: 동영상 및 코드 파일</li><li>동영상 전체 길이는 5분 이내</li><li>1차 합격자는 자유 형식으로 발표자료 동영상 제작 및 업로드</li></ul><h4><b>2. 개인 또는 팀 참여 규칙</b></h4><ul><li>개인 또는 팀을 이루어 참여할 수 있습니다.</li><li>단체 혹은 기관 참여시 별도의 절차가 필요합니다. (More &gt; 공지사항&gt; 게시글 확인)</li><li>개인 참가 방법: 팀 신청 없이, 자유롭게 제출 창에서 제출 가능</li><li>팀 구성 방법: 팀 페이지에서 팀 구성 안내 확인</li><li>팀 최대 인원: 5 명</li></ul><p>* 동일인이 개인 또는 복수팀에 중복하여 등록 불가.</p><h4><b>3. 데이터</b></h4><ul><li>데이터 출처 표시</li><li>크롤링시 코드 제출 필수</li></ul><h4><b>4. 참여 부문 및 아이템의 제한</b></h4><ul><li>타인의 특허 또는 실용신안 등 지적재산권을 침해하거나 침해할 우려가 있는 아이템</li></ul><h4><b>5. 대회문의</b></h4><p>대회 운영 및 데이터 이상에 관련된 질문 외에는 답변을 드리지 않고 있습니다. 기타 질문은 토론 페이지를 통해 자유롭게 토론해주시기 바랍니다.</p><p>데이콘 답변을 희망하는 경우 [대회문의] 페이지에 질문을 올려 주시기 바랍니다.</p>	<p><b>[일정]</b></p><ul><li>대회 기간  \t\t\t\t\t\t\t\t\t\t\t\t\t\t2021년 9월 1일 10:00 ~ 2021년 10월 24일 17:59</li><li>참가 신청 마감\t\t\t\t\t\t\t\t\t\t\t\t2021년 10월 17일</li><li>팀 병합 마감  \t\t\t\t\t\t\t\t\t\t\t\t2021년 10월 17일</li><li><span style="color: rgb(230, 0, 0);">결과 동영상 및 코드 제출 기간  \t\t\t\t대회 기간과 동일</span></li></ul><p>(대회 종료 시점부터 투표 기간 종료까지 제출 및 수정 불가)</p><ul><li>1차 평가   \t\t\t\t\t\t\t\t\t\t\t\t\t\t코드 제출 시점 ~ 2021년 10월 31일</li><li>1차 평가 결과 발표 \t\t\t\t\t\t\t\t\t\t2021년 10월 31일(상위 10개 팀 선정)</li><li>2차 평가 및 최종 평가\t\t\t\t\t\t\t\t\t2021년 10월 31일 ~ 2021년 11월 12일</li><li>최종평가 결과발표  \t\t\t\t\t\t\t\t\t2021년 11월 12일(최종 10개 팀 순위 발표)</li></ul>	2021-11-18 15:00:00+00	2021-11-19 15:00:00+00	<h2><b>🏆 총 상금 2,000만원</b></h2><ul><li>부경대학교총장상(1팀): 500만원</li></ul><ul><li>한국해양학회장상(3팀): 각 200만원</li></ul><ul><li>대한원격탐사학회장상(3팀): 각 200만원</li></ul><ul><li>환경과학기술대표이사상(3팀): 각 100만원</li></ul>	<p><span style="color: rgb(128, 131, 136);">‘해양과학데이터 저장소(JOISS,</span><a href="https://joiss.kr/joiss" target="_blank">https://joiss.kr</a><span style="color: rgb(128, 131, 136);">)의 데이터를 필수 포함하고, 가용한 모든 오픈 해양데이터</span><br /></p>	2021-11-18 06:52:35.641692+00	\N	t	13d779b21031df854b04df06e8c87fb8	b9abff49069bf6ea8edd2f1ecdf67ab4	\N	1	Class	[]	2222	0	0	[]	acc
5	손동작 인식 경진대회	손동작 인식 경진대회	<h1><b>1. 주제</b></h1><p>•Ego-Vision 관점의 영상에서 추출한 이미지 학습데이터를 활용한 인공지능 모델 기반의 손동작 인식 및 분류 모델 개발</p><h1><b>2. 배경</b></h1><p>•Ego-Vision 손 동작 데이터는 스마트 안경 등의 기술의 기본이 되는 데이터입니다.</p><p>•위 데이터를 더욱 다양하게 다량으로 구축할 수 있다면 더욱 다양한 사업에 접목 가능합니다.</p><p>•빠르고 정확하게 손 동작을 인식할 수 있는 모델을 개발함으로써, 인공지능 학습용 데이터를 구축하고자 합니다.</p><h1><b>3. 주최 / 주관 / 운영</b></h1><p>•주최 :한국지능정보사회진흥원(NIA)</p><p>•주관 :(주)유클리드소프트</p><p>•운영 :데이콘</p><h1><b>4. 참가 대상</b></h1><p>•AI에 관심이 많은 일반인, 학생, 직장인 등 누구나 참여 가능</p><p>•외국인은 내국인과 팀을 이루어야 참여 가능</p><p>•단체(학교, 기업, 교육업체 등)는 별도 신청</p>	<h1><b>1. 평가</b></h1><p>1차 계량 평가, 2차 비계량 평가로 나누어 진행</p><p>1)\t\t1차 평가에서 Private Score 기준 상위 코드 제출 심사 통과 상위 6팀 선발</p><p>2)\t\t선발된 6팀을 대상으로 2차 평가 진행</p><p>3)\t\t1차 평가(80%)와 2차 평가 점수(20%)를 합산하여 최종 순위 결정</p><h3><b>①<span style="color: black;">1차 평가</span></b></h3><p>ⅰ)평가 산식 : logloss</p><p>ⅱ)예측 대상 : 손 동작의 Label</p><p>ⅲ)Public Score : 자신의 모델 성능을 확인해 볼 수 있는 점수</p><p>비공개 데이터셋의 33%</p><p>리더보드 업데이트 : 제출 후 실시간 업데이트</p><p>ⅲ)Private Score : 최종 점수에 반영되는 Score</p><p>비공개 데이터셋의 Public에 적용되지 않은 66%</p><p>리더보드 업데이트 : 대회 종료 직후 자동 계산</p><h3><b>②<span style="color: black;">코드 제출</span></b></h3><p>ⅰ)제출 대상 : 2차 평가를 받고 싶은 분 모두</p><p>ⅱ)제출물 : 리더보드상 상위 점수를 복원한 수 있는 소스 코드</p><p>ⅲ)제출 방법 : Dacon 코드공유 게시판에 업로드</p><p>ⅳ)제출 기간 : 2021년 10월 14일 (목) ~ 2021년 10월 19일 (화)</p><h3><b>③<span style="color: black;">2차 평가 및 코드 검증 기간</span></b></h3><p>ⅰ)평가 대상 : 코드 제출 심사를 통과한 상위 6팀</p><p>ⅱ)평가 기준 : 1차 평가 점수(80%), 모델 추론 시간(20%)</p><p>ⅲ)일시 : 2021년 10월 19일 (화) ~ 10월 27일 (수) 진행</p><p>ⅳ)규칙 : 코드 미제출 혹은 코드 검증 과정에서 규칙 위반 사항 (Data Leakage, 불법 데이터 사용 등)이 확인될 시, 2차 평가 및 수상 후보에서 제외</p><h1><b>2. 코드 제출 방법</b></h1><p>ⅰ)Private 순위 공개 후 코드 제출 기간 내 코드 공유 페이지에 코드 업로드</p><p>ⅱ)제목에 Private 순위와 Public 점수, 사용한 방법 기입</p><p>예시 ) Private 1위, Public점수 : 0.98, NN Ensemble</p><p>ⅲ)게시물 형식: .ipynb 또는 .twbx</p><p>iv)ipynb 파일 크기 제한: 20MB 이하</p><p>v)대회 참가자는 공개된 코드 평가</p><p>vi)코드 오류 등 코멘트를 댓글로 작성</p><h1><b>3. 개인 또는 팀 참여 규칙</b></h1><p>ⅰ)개인 또는 팀을 이루어 참여 가능</p><p>ⅱ)동일인이 개인 또는 복수 팀에 중복하여 등록 불가</p><p>ⅲ)팀 병합 후 해체시 개인 참여 및 팀 등록 불가</p><p>iv )개인 참가 방법: 팀 신청 없이, 자유롭게 제출 창에서 제출 가능</p><p>ⅴ)팀 구성 방법: 팀 페이지에서 팀 구성 안내</p><p>vi )팀 최대 인원: 5명</p><h1><b>4. 사전학습모델 사용</b></h1><p>ⅰ)누구나 얻을 수 있고 법적 제약이 없는 사전학습 모델 사용 가능 (코드 제출시 사전학습에 사용된 모델 명시 필요)</p><h1><b>5. 유의 사항</b></h1><p>ⅰ)리더보드 운영 관련 )</p><ul><li>1일 최대 제출 횟수 : 3회</li><li>모델 학습에서 학습용(train) 데이터셋 외에 평가(test) 데이터셋 활용 시 Data Leakage로 간주하여 실격 처리</li><li>대회 진행 중 Data Leakage 및 규칙 위반 사항이 의심되는 경우 운영진이 코드 제출 요청을 할 수 있으며, 요청 2일 이내 코드 미제출 혹은 규칙 위반 사항이 확인되었을 경우 리더보드 기록 삭제</li><li>최종 순위는 선택된 파일 중에서 채점되므로 참가자는 제출 창에서 자신이 최종적으로 채점받고 싶은 파일을 선택해야 함</li></ul><p>ⅱ)동일인이 개인 또는 복수팀에 중복하여 등록 불가</p><p>ⅲ)팀 병합 후 해체시 개인 참여 및 팀 등록 불가</p><p>ⅲ)개인 참가 방법: 팀 신청 없이, 자유롭게 제출 창에서 제출 가능</p><p>ⅳ)팀 구성 방법: 팀 페이지에서 팀 구성 안내</p><p>ⅴ)팀 최대 인원: 5명</p><p>vi )데이콘은 부정 제출 행위를 금지하고 있으며 데이콘 대회 부정 제출 이력이 있는 경우 평가가 제한됩니다.</p><h1><b>6. 대회문의</b></h1><p>ⅰ)대회 운영 및 데이터 이상에 관련된 질문 외에는 답변을 드리지 않고 있습니다. 기타 질문은 토론 페이지를 통해 자유롭게 토론해주시기 바랍니다.</p><p>ⅱ)데이콘 답변을 희망하는 경우 &#039;대회문의&#039; 페이지에 질문을 올려 주시기 바랍니다.</p>	<p>손글씨 분류 경진대회<br /></p>	2021-11-18 15:00:00+00	2021-11-19 15:00:00+00	<h1><b>1. 경진대회 일정</b></h1><ul><li>대회 오픈2021년 09월 15일 10:00</li><li>팀 병합 마감2021년 10월 07일 23:59</li><li>Private 채점2021년 10월 14일 18:00</li><li>코드 제출 기간2021년 10월 14일 ~ 2021년 10월 19일</li><li>최종 순위 발표2021년 10월 27일</li><li>시상식2021년 10월 29일</li></ul><p>※ 세부 일정은 대회 운영상황에 따라 변동될 수 있습니다.</p>	<h1><b>🏆 [손 동작 인식 AI 경진대회 : 총 상금 1,000 만원]</b></h1><h2><b>🎐 2021 Ego-Vision 손동작 인식 AI 경진대회 : 상금 500만원 🎐</b></h2><p>• 최우수상1팀 상금 250만원 🥇</p><p>• 우수상1팀 상금 150만원 🥈</p><p>• 장려상1팀 상금 100만원 🥉</p><p>※ 본 경진대회는 &quot;2021 교통 수(手) 신호 동작 인식 AI 경진대회&quot;와 함께 진행됩니다.</p><p>대회 일정부터 시상식까지 모두 함께 진행되며, 그에 따라 총 상금이 1,000만원으로 표기됩니다.</p>	2021-11-18 06:46:53.078688+00	\N	t	6050d1e5bb40a57d363cda9082c0ec0b	112fc101c4da225d35ab15b9e553ee36	\N	1	Class	[]	1111	0	0	["root", "mink"]	mse
9	국토교통 빅데이터 분석	국토교통 빅데이터 분석	<h1><b>[배경]</b></h1><ul><li>2017년부터 국토교통 데이터와 민간의 창의적인 아이디어를 결합하여, 정책 문제를 해결하기 위한 국토교통 빅데이터 해커톤을 개최해왔습니다.</li><li>코로나 이후, 국토교통 데이터 활용으로 변화하는 미래 사업의 기회를 잡으세요.</li><li>[참고-작년 경진대회]<a href="https://dacon.io/competitions/official/235622/overview/description" target="_blank">2020 국토교통 빅데이터 온라인 해커톤 바로가기</a></li></ul><h1><b>[목적]</b></h1><ul><li>국토교통 공공데이터 이용에 대한 대국민 인식 제고 및 이를 이용, 활성화를 통한 국토·교통 분야 정책 및 창업 아이디어·서비스 발굴</li></ul><h1><b>[주최/주관/운영]</b></h1><ul><li>주최 : 국토교통부</li><li>주관 : 국토연구원, 한국공항공사, 한국도로공사, 한국교통안전공단</li><li>운영 : 데이콘</li></ul><h1><b>[참가대상]</b></h1><ul><li>데이터 활용 능력과 기획력으로 새로운 문제를 해결하려는 열정을 가진대한민국 국민이면 누구나</li><li>2인 이상 5인 이하 팀으로 참가</li></ul>	<p>1. 평가</p><ul><li>1차 유저 평가 (Public 리더보드)</li><li>데이콘 유저 투표 평가(50%) (※ 부정 투표 방지를 위한 유저별 가중치 부여)</li><li>심사위원단 정성 평가(50%)</li><li>2차 심사위원단 평가 (Private 리더보드) : 1차 평가 상위 10팀 대상으로 심사위원단 심사 진행</li><li>2차 심사위원단 구성 : 주최/주관/운영 기관별 1명</li><li>기관별 참가자에게 전하는 말</li><li>국토교통부</li><li>이번 해커톤을 통해 국토교통 데이터를 활용하여 참신한 기획력과 기술력으로 국토교통 산업뿐만 아니라 국민의 일상을 안전하게 만드는 성과를 기대합니다.</li><li>국토연구원</li><li>오픈소스 데이터를 활용하여 주택시장 위기징후 포착이나 주거환경 개선에 도움이 될수 있는 창의적인 아이디어로 정부정책에 도움이 되었으면 합니다.</li><li>한국공항공사</li><li>안녕하세요! &#039;항공업계 온실가스 배출&#039; 주제로 관련 데이터를 제공하니 여러가지 오픈소스 데이터를 활용하여 여러분들의 다양한 인사이트를 보여주세요! 많은 참여 부탁드립니다^^</li><li>한국도로공사</li><li>코로나 이후 고속도로 이용현황에서 유의미한 변화를 감지하고 그것을 기반으로 남다른 인사이트와 아이디어를 뽐내주시기 바랍니다.</li><li>한국교토안전공단</li><li>한국교통안전공단에서는 사업용차량의 이동경로분석 및 행태분석을 통한 다양한 교통안전 분석에 활용되는 DTG데이터와 위험운전행동통계 데이터를 제공하오니, 관심있으신 분은 많은 이용 바랍니다.</li></ul><h1><b>2차 평가 심사기준</b></h1><p>구분\t\t\t\t\t\t항목\t\t\t\t\t\t\t\t\t심사기준\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t점수</p><p>기술력(50)\t\t\t데이터\t\t\t\t\t\t\t\t적절한 데이터 분석 기법을 적용하였는가?\t\t\t\t\t\t\t\t\t\t\t20</p><p>분석 기법\t\t\t\t\t\t\t데이터 분석 결과를 효과적으로 시각화 했는가?\t\t\t\t\t\t\t\t\t20</p><p>코드품질\t\t\t\t\t\t\t코드의 오류는 없는가\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t5</p><p>코드의 가독성 및 구조화 수준이 높은가\t\t\t\t\t\t\t\t\t\t\t\t\t5</p><p>창의력(30)\t\t\t데이터 활용의 다양성\t\t다양한 데이터를 활용하였는가?\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t10</p><p>데이터 간의 융합을 통한 분석을 시도했는가?\t\t\t\t\t\t\t\t\t\t5</p><p>분석 방법의 독창성\t\t\t문제 해결을 위한 논리구조가 명확한가?\t\t\t\t\t\t\t\t\t\t\t\t5</p><p>기존의 분석 방식과는 다른 기법, 데이터, 로직을 활용하였는가?\t\t5</p><p>분석 결과에 대한 검증 방법을 제시하고 있는가?\t\t\t\t\t\t\t\t\t5</p><p>실효성(20)\t\t\t활용 가능성\t\t\t\t\t\t분석 결과를 적용하기 위한 적절한 방안을 제시하였는가?\t\t\t\t\t10</p><p>활용의 효과성이 있는가?\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t10</p><p>2. 데이터</p><ul><li>국토·교통과 관련된 공공데이터</li><li>추천 데이터</li><li>국토교통 데이터 통합채널(<a href="https://data.molit.go.kr/" target="_blank">https://data.molit.go.kr/</a>), 교통데이터거래소(<a href="https://www.bigdata-transportation.kr/" target="_blank">https://www.bigdata-transportation.kr/</a>) 등</li><li>추가 추천 데이터는 데이터탭을 확인</li><li>법적제약이 없으며 누구에게나 공개된 민간 데이터(2021.08.06 추가)</li><li>데이터 출처 표시</li><li>크롤링시 코드 제출 필수</li></ul><p>3. 참가 방법</p><ul><li>개인 참가 불가, 2인 이상 5인 이하로 팀을 구성 (1인 참여시 평가 대상 제외됩니다.)</li><li>팀 참가 방법(<a href="https://bit.ly/38Vq1tf" target="_blank">https://bit.ly/38Vq1tf</a>)</li><li>팀장, 팀원 모두 참여하기 버튼 클릭</li><li>샘플 파일(zip 파일) 다운로드 받아 제출(<a href="https://bit.ly/3eqnXe9" target="_blank">https://bit.ly/3eqnXe9</a>)</li><li>팀장이 각 팀원을 검색(닉네임 or ID or 가입 이메일), 해당 팀원 합체 요청</li><li>각 팀원은 팀장으로부터 온 팀 병합 요청 수락</li><li>팀 참가 완료</li></ul><p>4. 제출 방법</p><ul><li>대회의 코드 공유 페이지에 시각화 자료 게시</li><li>분석결과를 정리한 PPT를 dacon@dacon.io로 제출</li><li>제출 양식 : [국토교통]팀명-제목</li><li>사용 가능 툴 : Python, R, Tableau</li><li>게시물 형식 : .ipynb 또는 .twbx</li><li>ipynp 파일 크기는 20MB를 초과할 수 없음</li></ul><p>5. 참가자 라이센스</p><ul><li>제출물은 오픈 소스라이센스인 Apache License v.2.0 를 적용해야 합니다.  (제출물에 해당 라이센스파일 포함)</li><li>제출물은 국토교통부 깃허브 사이트, 데이콘 깃허브 및 국토부 통합채널 서비스 등에 추가 배포됩니다.</li></ul>	<h1><b>[세부일정]</b></h1><ul><li>대회 및 결과 제출 기간 : 2021년 7월 19일 10:00 ~ 2021년 8월 31일 18:00</li><li>팀 병합 마감 : 2021년 8월 24일</li><li>1차 유저 평가 기간 : 2021년 7월 19일 10:00 ~ 2021년 9월 7일 18:00</li><li>2차 심사위원단 평가 기간 : 2021년 9월 8일 ~ 2021년 9월 15일</li><li>최종 평가 및 결과 발표 : 2021년 9월 중</li></ul><p><span style="color: rgb(68, 68, 68);">※ 세부 일정은 대회 운영상황에 따라 변동될 수 있습니다.</span></p>	2021-11-18 15:00:00+00	2021-11-29 15:00:00+00	<h2><b>🏆 총 상금 1,100만원</b></h2><ul><li>🥇대상 1팀 : 300만원  - 국토교통부 장관상</li><li>🥈우수상 4팀 : 각 200만원</li><li>한국국토연구원 원장상, 한국공항공사 사장상, 한국도로공사 사장상, 한국교통안전공단이사장상</li></ul>	<p>추천 데이터</p><ul><li>국토교통 데이터 통합채널(<a href="https://data.molit.go.kr/" target="_blank">https://data.molit.go.kr/</a>)</li><li>국토교통과 관련된 전반의 공공데이터 사용 가능</li></ul><ul><li>운행기록데이터(<a href="https://www.kotsa.or.kr/dps" target="_blank">https://www.kotsa.or.kr/dps/</a>)</li><li>&#039;20.06~&#039;21.06 1년 전국 사업용차량 DTG 데이터</li><li>이용방법 :<a href="https://bit.ly/3xUbkm4" target="_blank">https://bit.ly/3xUbkm4</a></li></ul><ul><li>위험운전행동통계데이터(<a href="https://www.kotsa.or.kr/dps" target="_blank">https://www.kotsa.or.kr/dps/</a>)</li><li>&#039;20.06~&#039;21.06 1년 전국 사업용차량 DTG기반 위험운전통계 데이터</li><li>이용방법 :<a href="https://bit.ly/3xUbkm4" target="_blank">https://bit.ly/3xUbkm4</a></li></ul><ul><li>고속도로 하이패스 이용 구간별 교통 데이터(<a href="https://www.bigdata-transportation.kr/productGroupPopup/7436a91e-cb12-11ea-8310-b4969166fed2" target="_blank">https://www.bigdata-transportation.kr/productGroupPopup/7436a91e-cb12-11ea-8310-b4969166fed2</a>)</li><li>고속도로를 이용한 하이패스 이용차량을 대상으로 노선별, 이용 구간별로 수집된 데이터</li><li>수집일시, 단말기 및 노변기지국 ID와 차종 등의 정보</li></ul><ul><li>고속도로 진출입(출발지, 목적지)별 교통 소통 데이터(<a href="https://www.bigdata-transportation.kr/productGroupPopup/a283f121-cbb0-11ea-8e8a-b4969166fed2" target="_blank">https://www.bigdata-transportation.kr/productGroupPopup/a283f121-cbb0-11ea-8e8a-b4969166fed2</a>)</li><li>고속도로 이용차량을 대상으로 출발지(진입)와 도착지(전출) 간의 통행시간, 평균속도 등을 진출입톨게이트, 차종별, 교통량 등에 대해 5분 단위로 통계 생성된 데이터</li></ul><ul><li>고속도로 톨게이트 입출구 교통량 데이터(<a href="https://www.bigdata-transportation.kr/productGroupPopup/77d6cd2e-cbb0-11ea-881e-b4969166fed2" target="_blank">https://www.bigdata-transportation.kr/productGroupPopup/77d6cd2e-cbb0-11ea-881e-b4969166fed2</a>)</li><li>전국 고속도로를 이용한 차량에 대하여 차종별, 입출구, 톨게이트별, 지불수단별(TCS(현금, 전자카드), 하이패스) 등 15분 단위로 통계 생성된 데이터</li></ul><ul><li>전국고속도로 공사(작업) 계획 및 상태 데이터(<a href="https://www.bigdata-transportation.kr/productGroupPopup/8e84cfe1-cbb1-11ea-8546-b4969166fed2" target="_blank">https://www.bigdata-transportation.kr/productGroupPopup/8e84cfe1-cbb1-11ea-8546-b4969166fed2</a>)</li><li>고속도로 작업에 대한 위치, 교통노선, 구간, 공사일자 등을 기록한 데이터</li></ul><ul><li>차량검지장치(VDS)기반 고속도로 지점 별 교통소통 통계 데이터(<a href="https://www.bigdata-transportation.kr/productGroupPopup/8de4e65e-cbb1-11ea-a01d-b4969166fed2" target="_blank">https://www.bigdata-transportation.kr/productGroupPopup/8de4e65e-cbb1-11ea-a01d-b4969166fed2</a>)</li><li>차량검지장치(VDS)에 의한 지점별, 차로유형별 교통량 및 평균 속도 데이터</li></ul><ul><li>코레일 사회적 거리두기 단계에 따른 역이용인원(<a href="https://www.bigda-tatransportation.kr/productGroupPopup/TR032000030001)" target="_blank">https://www.bigdata-transportation.kr/productGroupPopup/TR032000030001)</a></li><li>여객 정차역별 승하차인원수와 코로나19 사회적 거리두기 단계 정보로 운행일자, 요일구분, 영업일구분, 정차역, 사회적거리두기 단계 등으로 구성</li><li>운행일자를 기준으로 산출</li></ul><ul><li>코레일 전철역 시간대별 이용인원(<a href="https://www.bigdata-transportation.kr/productGroupPopup/TR032000010001)" target="_blank">https://www.bigdata-transportation.kr/productGroupPopup/TR032000010001)</a></li><li>전철역 시간별 이용인원 정보로 운행일자, 요일구분, 영업일구분, 역코드, 승차인원, 하차인원 등으로 구성</li><li>운행일자를 기준으로 산출</li></ul><ul><li>주택매매 실거래가 자료(<a href="http://www.data.go.k/" target="_blank">http://www.data.go.kr</a>,<a href="http://rt.molit.go.kr/" target="_blank">http://rt.molit.go.kr</a>)</li><li>아파트, 연립, 다세대, 오피스텔, 상업 등</li></ul><ul><li>공동주택가격정보 서비스 등(<a href="http://www.data.go.kr/" target="_blank">http://www.data.go.kr</a>,<a href="http://www.kab.co.kr/" target="_blank">http://www.kab.co.kr</a>)</li><li>공동/개별주택공시가격, 개별공시지가, 표준공시지가 등</li></ul><ul><li>시군구별 전출입 지역현황(<a href="http://mdis.kostat.go.kr/" target="_blank">http://mdis.kostat.go.kr</a>,<a href="http://www.kosis.kr/" target="_blank">http://www.kosis.kr</a>,<a href="https://www.khug.or.kr/index.jsp?mainType=housta" target="_blank">https://www.khug.or.kr/index.jsp?mainType=housta</a>)</li><li>년도별/지역별 전입전출인구 및 이동율</li></ul><ul><li>주거실태조사 자료(<a href="http://mdis.kostat.go.kr/" target="_blank">http://mdis.kostat.go.kr</a><a href="http://mdis.kostat.go.kr/" target="_blank">)</a></li><li>주택/주거환경, 이사경험, 이사계획, 주거의식, 주거지원프로그램 만족도, 가구현황, 가구소득, 자산</li></ul><ul><li>부동산시장 소비심리지수(<a href="https://kremap.krihs.re.kr/" target="_blank">https://kremap.krihs.re.kr/</a>)</li><li>지역별 주택매매, 전세, 토지시장에 대한 중개업소 및 일반국민의 조사내용을 토대로 지수화</li></ul><ul><li>부동산시장 소비자심리조사 마이크로 데이터(<a href="https://mdis.kostat.go.kr/extract/extYearsSurvSearchNew.do?curMenuNo=UI_POR_P9012" target="_blank">https://mdis.kostat.go.kr/extract/extYearsSurvSearchNew.do?curMenuNo=UI_POR_P9012</a>)</li><li>지역별 주택매매, 전세, 토지시장에 대한 중개업소 및 일반국민의 조사내용에 대한 마이크로데이터</li></ul><ul><li>항공기 운항정보(<a href="https://www.data.go.kr/" target="_blank">https://www.data.go.kr/</a>)</li><li>운항스케줄, 실시간 운항정보 등</li></ul><ul><li>전국공항 수송실적(<a href="https://www.data.go.kr/" target="_blank">https://www.data.go.kr/</a>)</li><li>수송실적(운항, 여객, 화물)의 통계 서비스</li></ul><ul><li>기종별 온실가스 배출량(<a href="https://www.data.go.kr/" target="_blank">https://www.data.go.kr/</a>)</li><li>항공기 기종별 온실가스 배출량</li></ul><ul><li>공항 온실가스(<a href="https://www.data.go.kr/" target="_blank">https://www.data.go.kr/</a>)</li><li>공항 온실가스 배출량</li></ul><ul><li>노선별 소요시간(<a href="https://www.data.go.kr/" target="_blank">https://www.data.go.kr/</a>)</li><li>노선별 소요시간 및 거리 정보</li></ul><ul><li>공항 온실가스(<a href="https://www.data.go.kr/" target="_blank">https://www.data.go.kr/</a>)</li><li>공항 온실가스 배출량</li></ul><ul><li>각종 항공통계 자료(<a href="https://www.airport.co.kr/www/cms/frCon/index.do?MENU_ID=1250" target="_blank">https://www.airport.co.kr/www/cms/frCon/index.do?MENU_ID=1250</a>)</li><li>각종 항공통계 자료</li></ul><ul><li>한국부동산원, LH 등 유관기관 데이터(기관별 홈페이지)</li></ul>	2021-11-18 11:50:48.750054+00	\N	t	cccf1f023cb6de16d6b583e7c12cfca7	a3c8da18dc8c3cb1a70f82dbb45f583a	\N	1	General	[{"score": 0, "userid": 3, "username": "user1", "submitTime": "2021-11-19 02:12:02"}, {"score": 0, "userid": 1, "username": "root", "submitTime": "2021-11-19 15:47:35"}, {"score": 0, "userid": 2, "username": "mink", "submitTime": "2021-11-22 11:41:32"}]		0	0	["root", "mink", "user1"]	mae
\.


--
-- Data for Name: ai_contest_tag; Type: TABLE DATA; Schema: public; Owner: onlinejudge
--

COPY public.ai_contest_tag (id, name) FROM stdin;
1	1234
2	객체검출
3	mAP
4	수요예측
5	정형데이터
6	시각화
7	KT
8	컴퓨터 비전
9	이미지 분류
10	LogLoss
11	분석해커톤
12	빅데이터
13	자연어
14	생성요약
15	NIA
16	농작물
17	vision
\.


--
-- Data for Name: ai_contest_tags; Type: TABLE DATA; Schema: public; Owner: onlinejudge
--

COPY public.ai_contest_tags (id, aiproblem_id, aiproblemtag_id) FROM stdin;
23	1	1
24	2	2
25	2	3
30	7	13
31	7	14
35	3	4
36	3	5
43	9	6
44	9	12
47	4	6
48	4	7
49	6	11
50	6	12
54	5	8
55	5	9
56	5	10
57	8	15
58	8	16
59	8	17
\.


--
-- Data for Name: announcement; Type: TABLE DATA; Schema: public; Owner: onlinejudge
--

COPY public.announcement (id, title, content, create_time, last_update_time, visible, important, created_by_id) FROM stdin;
1	공지사항	<p>공지사항<br /></p>	2021-11-17 15:13:38.954019+00	2021-11-17 15:13:38.954069+00	t	f	1
\.


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: onlinejudge
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: onlinejudge
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: onlinejudge
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add permission	1	add_permission
2	Can change permission	1	change_permission
3	Can delete permission	1	delete_permission
4	Can view permission	1	view_permission
5	Can add group	2	add_group
6	Can change group	2	change_group
7	Can delete group	2	delete_group
8	Can view group	2	view_group
9	Can add session	3	add_session
10	Can change session	3	change_session
11	Can delete session	3	delete_session
12	Can view session	3	view_session
13	Can add content type	4	add_contenttype
14	Can change content type	4	change_contenttype
15	Can delete content type	4	delete_contenttype
16	Can view content type	4	view_contenttype
17	Can add task	5	add_task
18	Can change task	5	change_task
19	Can delete task	5	delete_task
20	Can view task	5	view_task
21	Can add user	6	add_user
22	Can change user	6	change_user
23	Can delete user	6	delete_user
24	Can view user	6	view_user
25	Can add user profile	7	add_userprofile
26	Can change user profile	7	change_userprofile
27	Can delete user profile	7	delete_userprofile
28	Can view user profile	7	view_userprofile
29	Can add announcement	8	add_announcement
30	Can change announcement	8	change_announcement
31	Can delete announcement	8	delete_announcement
32	Can view announcement	8	view_announcement
33	Can add judge server	9	add_judgeserver
34	Can change judge server	9	change_judgeserver
35	Can delete judge server	9	delete_judgeserver
36	Can view judge server	9	view_judgeserver
37	Can add problem tag	10	add_problemtag
38	Can change problem tag	10	change_problemtag
39	Can delete problem tag	10	delete_problemtag
40	Can view problem tag	10	view_problemtag
41	Can add problem	11	add_problem
42	Can change problem	11	change_problem
43	Can delete problem	11	delete_problem
44	Can view problem	11	view_problem
45	Can add contest	12	add_contest
46	Can change contest	12	change_contest
47	Can delete contest	12	delete_contest
48	Can view contest	12	view_contest
49	Can add acm contest rank	13	add_acmcontestrank
50	Can change acm contest rank	13	change_acmcontestrank
51	Can delete acm contest rank	13	delete_acmcontestrank
52	Can view acm contest rank	13	view_acmcontestrank
53	Can add oi contest rank	14	add_oicontestrank
54	Can change oi contest rank	14	change_oicontestrank
55	Can delete oi contest rank	14	delete_oicontestrank
56	Can view oi contest rank	14	view_oicontestrank
57	Can add contest announcement	15	add_contestannouncement
58	Can change contest announcement	15	change_contestannouncement
59	Can delete contest announcement	15	delete_contestannouncement
60	Can view contest announcement	15	view_contestannouncement
61	Can add submission	16	add_submission
62	Can change submission	16	change_submission
63	Can delete submission	16	delete_submission
64	Can view submission	16	view_submission
65	Can add sys options	17	add_sysoptions
66	Can change sys options	17	change_sysoptions
67	Can delete sys options	17	delete_sysoptions
68	Can view sys options	17	view_sysoptions
69	Can add ai problem tag	18	add_aiproblemtag
70	Can change ai problem tag	18	change_aiproblemtag
71	Can delete ai problem tag	18	delete_aiproblemtag
72	Can view ai problem tag	18	view_aiproblemtag
73	Can add ai problem	19	add_aiproblem
74	Can change ai problem	19	change_aiproblem
75	Can delete ai problem	19	delete_aiproblem
76	Can view ai problem	19	view_aiproblem
77	Can add faq	20	add_faq
78	Can change faq	20	change_faq
79	Can delete faq	20	delete_faq
80	Can view faq	20	view_faq
\.


--
-- Data for Name: contest; Type: TABLE DATA; Schema: public; Owner: onlinejudge
--

COPY public.contest (id, title, description, real_time_rank, password, rule_type, start_time, end_time, create_time, last_update_time, visible, allowed_ip_ranges, created_by_id) FROM stdin;
\.


--
-- Data for Name: contest_announcement; Type: TABLE DATA; Schema: public; Owner: onlinejudge
--

COPY public.contest_announcement (id, title, content, visible, create_time, contest_id, created_by_id) FROM stdin;
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: onlinejudge
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	auth	permission
2	auth	group
3	sessions	session
4	contenttypes	contenttype
5	django_dramatiq	task
6	account	user
7	account	userprofile
8	announcement	announcement
9	conf	judgeserver
10	problem	problemtag
11	problem	problem
12	contest	contest
13	contest	acmcontestrank
14	contest	oicontestrank
15	contest	contestannouncement
16	submission	submission
17	options	sysoptions
18	aicontest	aiproblemtag
19	aicontest	aiproblem
20	faq	faq
\.


--
-- Data for Name: django_dramatiq_task; Type: TABLE DATA; Schema: public; Owner: onlinejudge
--

COPY public.django_dramatiq_task (id, status, created_at, updated_at, message_data) FROM stdin;
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: onlinejudge
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2021-11-16 14:47:57.668382+00
2	contenttypes	0002_remove_content_type_name	2021-11-16 14:47:57.724413+00
3	auth	0001_initial	2021-11-16 14:47:57.788775+00
4	auth	0002_alter_permission_name_max_length	2021-11-16 14:47:57.802454+00
5	auth	0003_alter_user_email_max_length	2021-11-16 14:47:57.814503+00
6	auth	0004_alter_user_username_opts	2021-11-16 14:47:57.826711+00
7	auth	0005_alter_user_last_login_null	2021-11-16 14:47:57.886319+00
8	auth	0006_require_contenttypes_0002	2021-11-16 14:47:57.890504+00
9	auth	0007_alter_validators_add_error_messages	2021-11-16 14:47:57.905744+00
10	auth	0008_alter_user_username_max_length	2021-11-16 14:47:57.923551+00
11	auth	0009_alter_user_last_name_max_length	2021-11-16 14:47:57.933702+00
12	django_dramatiq	0001_initial	2021-11-16 14:47:57.9501+00
13	sessions	0001_initial	2021-11-16 14:47:57.968473+00
14	account	0001_initial	2021-11-17 10:12:40.708533+00
15	account	0002_userprofile_user_join_contest	2021-11-17 10:12:40.736439+00
16	contest	0001_initial	2021-11-17 10:12:40.866397+00
17	aicontest	0001_initial	2021-11-17 10:12:40.945738+00
18	aicontest	0002_aiproblem_p_type	2021-11-17 10:12:41.026933+00
19	aicontest	0003_aiproblem_migrate_test	2021-11-17 10:12:41.053964+00
20	aicontest	0004_remove_aiproblem_migrate_test	2021-11-17 10:12:41.07722+00
21	aicontest	0005_aiproblem_rank	2021-11-17 10:12:41.099577+00
22	aicontest	0006_aiproblem_password	2021-11-17 10:12:41.122614+00
23	aicontest	0007_alter_aiproblem_password	2021-11-17 10:12:41.144791+00
24	aicontest	0008_auto_20211109_0730	2021-11-17 10:12:41.487467+00
25	aicontest	0009_auto_20211109_0809	2021-11-17 10:12:41.545807+00
26	aicontest	0010_auto_20211109_0813	2021-11-17 10:12:41.618275+00
27	aicontest	0011_aiproblem_join_contest	2021-11-17 10:12:41.654997+00
28	aicontest	0012_aiproblem_eval_type	2021-11-17 10:12:41.676556+00
29	announcement	0001_initial	2021-11-17 10:12:41.712162+00
30	conf	0001_initial	2021-11-17 10:12:41.726201+00
31	faq	0001_initial	2021-11-17 10:12:41.765578+00
32	options	0001_initial	2021-11-17 10:12:41.782845+00
33	problem	0001_initial	2021-11-17 10:12:41.856739+00
34	submission	0001_initial	2021-11-17 10:12:41.906928+00
35	account	0003_userprofile_submit_info	2021-11-20 16:31:11.774642+00
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: onlinejudge
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
\.


--
-- Data for Name: faq; Type: TABLE DATA; Schema: public; Owner: onlinejudge
--

COPY public.faq (id, question, answer, create_time, last_update_time, visible, created_by_id) FROM stdin;
1	대회 참가 방법	<p><br /></p>	2021-11-17 15:14:34.41925+00	2021-11-18 12:01:40.44478+00	t	1
\.


--
-- Data for Name: judge_server; Type: TABLE DATA; Schema: public; Owner: onlinejudge
--

COPY public.judge_server (id, hostname, ip, judger_version, cpu_core, memory_usage, cpu_usage, last_heartbeat, create_time, task_number, service_url, is_disabled) FROM stdin;
74	98446b791435	172.18.0.4	2.1.1	1	48.5	0	2021-11-25 15:18:59.726844+00	2021-11-25 14:27:39.092223+00	0	http://judge-server:8080	f
73	13a498d618fb	172.18.0.2	2.1.1	1	38.1000000000000014	0	2021-11-24 16:37:47.595155+00	2021-11-24 09:10:54.431085+00	0	http://judge-server:8080	f
69	df45eeef8e22	172.18.0.5	2.1.1	1	36.6000000000000014	0	2021-11-23 12:21:19.30862+00	2021-11-20 16:25:02.862363+00	0	http://judge-server:8080	f
35	f13619ed66a5	172.18.0.2	2.1.1	1	36.8999999999999986	0	2021-11-20 11:54:56.297872+00	2021-11-20 11:52:44.947719+00	0	http://judge-server:8080	f
1	5da70cd978f1	172.18.0.5	2.1.1	1	37.3999999999999986	0	2021-11-20 04:34:59.867476+00	2021-11-17 10:12:51.222152+00	0	http://judge-server:8080	f
2	824b8400121d	172.18.0.4	2.1.1	1	36.2999999999999972	0	2021-11-20 11:52:10.503683+00	2021-11-20 04:50:53.412401+00	0	http://judge-server:8080	f
68	963842c315da	172.18.0.3	2.1.1	1	36.2999999999999972	0	2021-11-20 12:38:17.057081+00	2021-11-20 12:19:46.430283+00	0	http://judge-server:8080	f
70	3d43f2bf3862	172.18.0.4	2.1.1	1	50.6000000000000014	0	2021-11-23 14:58:17.045301+00	2021-11-23 12:24:23.108974+00	0	http://judge-server:8080	f
71	d090440ba0c2	172.18.0.2	2.1.1	1	38.7999999999999972	0	2021-11-24 07:56:14.733451+00	2021-11-24 07:47:16.678098+00	0	http://judge-server:8080	f
72	bbd4a3bc85ba	127.0.0.1	2.1.1	1	68.9000000000000057	0	2021-11-24 09:10:37.96956+00	2021-11-24 09:10:37.969944+00	0	http://judge-server:8080	f
\.


--
-- Data for Name: oi_contest_rank; Type: TABLE DATA; Schema: public; Owner: onlinejudge
--

COPY public.oi_contest_rank (id, submission_number, total_score, submission_info, contest_id, user_id) FROM stdin;
\.


--
-- Data for Name: options_sysoptions; Type: TABLE DATA; Schema: public; Owner: onlinejudge
--

COPY public.options_sysoptions (id, key, value) FROM stdin;
1	website_base_url	"http://127.0.0.1"
2	website_name	"Online Judge"
3	website_name_shortcut	"oj"
4	website_footer	"Online Judge Footer"
5	allow_register	true
6	submission_list_show_all	true
7	smtp_config	{}
9	throttling	{"ip": {"capacity": 100, "fill_rate": 0.1, "default_capacity": 50}, "user": {"capacity": 20, "fill_rate": 0.03, "default_capacity": 10}}
10	languages	[{"spj": {"config": {"command": "{exe_path} {in_file_path} {user_out_file_path}", "exe_name": "spj-{spj_version}", "seccomp_rule": "c_cpp"}, "compile": {"exe_name": "spj-{spj_version}", "src_name": "spj-{spj_version}.c", "max_memory": 1073741824, "max_cpu_time": 3000, "max_real_time": 10000, "compile_command": "/usr/bin/gcc -DONLINE_JUDGE -O2 -w -fmax-errors=3 -std=c11 {src_path} -lm -o {exe_path}"}}, "name": "C", "config": {"run": {"env": ["LANG=en_US.UTF-8", "LANGUAGE=en_US:en", "LC_ALL=en_US.UTF-8"], "command": "{exe_path}", "seccomp_rule": {"File IO": "c_cpp_file_io", "Standard IO": "c_cpp"}}, "compile": {"exe_name": "main", "src_name": "main.c", "max_memory": 268435456, "max_cpu_time": 3000, "max_real_time": 10000, "compile_command": "/usr/bin/gcc -DONLINE_JUDGE -O2 -w -fmax-errors=3 -std=c11 {src_path} -lm -o {exe_path}"}, "template": "//PREPEND BEGIN\\n#include <stdio.h>\\n//PREPEND END\\n\\n//TEMPLATE BEGIN\\nint add(int a, int b) {\\n  // Please fill this blank\\n  return ___________;\\n}\\n//TEMPLATE END\\n\\n//APPEND BEGIN\\nint main() {\\n  printf(\\"%d\\", add(1, 2));\\n  return 0;\\n}\\n//APPEND END"}, "description": "GCC 9.4", "content_type": "text/x-csrc"}, {"spj": {"config": {"command": "{exe_path} {in_file_path} {user_out_file_path}", "exe_name": "spj-{spj_version}", "seccomp_rule": "c_cpp"}, "compile": {"exe_name": "spj-{spj_version}", "src_name": "spj-{spj_version}.cpp", "max_memory": 1073741824, "max_cpu_time": 10000, "max_real_time": 20000, "compile_command": "/usr/bin/g++ -DONLINE_JUDGE -O2 -w -fmax-errors=3 -std=c++14 {src_path} -lm -o {exe_path}"}}, "name": "C++", "config": {"run": {"env": ["LANG=en_US.UTF-8", "LANGUAGE=en_US:en", "LC_ALL=en_US.UTF-8"], "command": "{exe_path}", "seccomp_rule": {"File IO": "c_cpp_file_io", "Standard IO": "c_cpp"}}, "compile": {"exe_name": "main", "src_name": "main.cpp", "max_memory": 1073741824, "max_cpu_time": 10000, "max_real_time": 20000, "compile_command": "/usr/bin/g++ -DONLINE_JUDGE -O2 -w -fmax-errors=3 -std=c++14 {src_path} -lm -o {exe_path}"}, "template": "//PREPEND BEGIN\\n#include <iostream>\\n//PREPEND END\\n\\n//TEMPLATE BEGIN\\nint add(int a, int b) {\\n  // Please fill this blank\\n  return ___________;\\n}\\n//TEMPLATE END\\n\\n//APPEND BEGIN\\nint main() {\\n  std::cout << add(1, 2);\\n  return 0;\\n}\\n//APPEND END"}, "description": "G++ 9.4", "content_type": "text/x-c++src"}, {"name": "Java", "config": {"run": {"env": ["LANG=en_US.UTF-8", "LANGUAGE=en_US:en", "LC_ALL=en_US.UTF-8"], "command": "/usr/bin/java -cp {exe_dir} -XX:MaxRAM={max_memory}k -Djava.security.manager -Dfile.encoding=UTF-8 -Djava.security.policy==/etc/java_policy -Djava.awt.headless=true Main", "seccomp_rule": null, "memory_limit_check_only": 1}, "compile": {"exe_name": "Main", "src_name": "Main.java", "max_memory": -1, "max_cpu_time": 5000, "max_real_time": 10000, "compile_command": "/usr/bin/javac {src_path} -d {exe_dir} -encoding UTF8"}, "template": "//PREPEND BEGIN\\n//PREPEND END\\n\\n//TEMPLATE BEGIN\\n//TEMPLATE END\\n\\n//APPEND BEGIN\\n//APPEND END"}, "description": "OpenJDK 11", "content_type": "text/x-java"}, {"name": "Python2", "config": {"run": {"env": ["LANG=en_US.UTF-8", "LANGUAGE=en_US:en", "LC_ALL=en_US.UTF-8"], "command": "/usr/bin/python {exe_path}", "seccomp_rule": "general"}, "compile": {"exe_name": "solution.pyc", "src_name": "solution.py", "max_memory": 134217728, "max_cpu_time": 3000, "max_real_time": 10000, "compile_command": "/usr/bin/python -m py_compile {src_path}"}, "template": "//PREPEND BEGIN\\n//PREPEND END\\n\\n//TEMPLATE BEGIN\\n//TEMPLATE END\\n\\n//APPEND BEGIN\\n//APPEND END"}, "description": "Python 2.7", "content_type": "text/x-python"}, {"name": "Python3", "config": {"run": {"env": ["LANG=en_US.UTF-8", "LANGUAGE=en_US:en", "LC_ALL=en_US.UTF-8", "PYTHONIOENCODING=utf-8"], "command": "/usr/bin/python3 {exe_path}", "seccomp_rule": "general"}, "compile": {"exe_name": "__pycache__/solution.cpython-36.pyc", "src_name": "solution.py", "max_memory": 134217728, "max_cpu_time": 3000, "max_real_time": 10000, "compile_command": "/usr/bin/python3 -m py_compile {src_path}"}, "template": "//PREPEND BEGIN\\n//PREPEND END\\n\\n//TEMPLATE BEGIN\\n//TEMPLATE END\\n\\n//APPEND BEGIN\\n//APPEND END"}, "description": "Python 3.6", "content_type": "text/x-python"}, {"name": "Golang", "config": {"run": {"env": ["GODEBUG=madvdontneed=1", "LANG=en_US.UTF-8", "LANGUAGE=en_US:en", "LC_ALL=en_US.UTF-8"], "command": "{exe_path}", "seccomp_rule": "", "memory_limit_check_only": 1}, "compile": {"env": ["GOCACHE=/tmp"], "exe_name": "main", "src_name": "main.go", "max_memory": 1073741824, "max_cpu_time": 3000, "max_real_time": 5000, "compile_command": "/usr/bin/go build -o {exe_path} {src_path}"}, "template": "//PREPEND BEGIN\\n//PREPEND END\\n\\n//TEMPLATE BEGIN\\n//TEMPLATE END\\n\\n//APPEND BEGIN\\n//APPEND END"}, "description": "Golang 1.15", "content_type": "text/x-go"}]
8	judge_server_token	"CHANGE_THIS"
\.


--
-- Data for Name: problem; Type: TABLE DATA; Schema: public; Owner: onlinejudge
--

COPY public.problem (id, _id, is_public, title, description, samples, test_case_id, test_case_score, testhint, languages, template, create_time, last_update_time, memory_limit, io_mode, spj, spj_language, spj_code, spj_version, spj_compile_ok, rule_type, visible, difficulty, source, total_score, submission_number, accepted_number, statistic_info, share_submission, contest_id, created_by_id) FROM stdin;
\.


--
-- Data for Name: problem_tag; Type: TABLE DATA; Schema: public; Owner: onlinejudge
--

COPY public.problem_tag (id, name) FROM stdin;
\.


--
-- Data for Name: problem_tags; Type: TABLE DATA; Schema: public; Owner: onlinejudge
--

COPY public.problem_tags (id, problem_id, problemtag_id) FROM stdin;
\.


--
-- Data for Name: submission; Type: TABLE DATA; Schema: public; Owner: onlinejudge
--

COPY public.submission (id, create_time, user_id, username, code, result, info, language, shared, statistic_info, ip, contest_id, problem_id) FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: onlinejudge
--

COPY public."user" (id, password, last_login, username, email, create_time, admin_type, problem_permission, reset_password_token, reset_password_token_expire_time, auth_token, two_factor_auth, tfa_token, session_keys, open_api, open_api_appkey, is_disabled) FROM stdin;
1	pbkdf2_sha256$120000$Bm4RMtDrznGL$loo2Nq58PuESIugepXqmsantKg0Lz3RKszo/r0w1+xw=	2021-11-24 09:12:43.806661+00	root	\N	2021-11-17 10:12:43.74882+00	Super Admin	All	\N	\N	\N	f	\N	["6hqpogdci4varzi1s4zcw052vdxsevmt", "uo5w6jjx13qlbe1mqmyf3snre0zaugdg", "3ld3h90r25bz2apyi8n9xza5mkqulhnq", "3fmd41nukztj27n2sjxodflbdz87obuh"]	f	\N	f
2	pbkdf2_sha256$120000$moXtWtlWDqpK$RkUB0uxN0bS2ff6QM9r23o1QbDclLt3/qC0X9aBTRvs=	2021-11-24 09:13:10.53362+00	mink	mink@naver.com	2021-11-18 16:21:04.560006+00	Regular User	None	\N	\N	\N	f	807eb33ada68a334f727c4c84f3263c9	["kjuziobi36u24yawazcjg7eodbqamgux", "jb853egn679caxgl28l6p0cviapzuvnd", "3c1kfuzwxdpwxna3bpa96vskb7ryj3gl", "w4wzhfpxbqhm0wv3fdg1m48idm28pu7s", "nokgi2na0xiv0lfyclagp6vsqb3cfwte", "pm02u89iuycuxploc1yevyfvlhxeuzhw", "he31taa6fy0nrfv4zlsg8z2mgwor9fog", "5lkxfyfl6v8ows4azpu8jijpzfj6fvgm", "ooaclcz4v0c4ffxxl5k5erx7yvjkb6q7", "oc75dns5npy7cddynil5be59hrtzehso"]	f	\N	f
3	pbkdf2_sha256$120000$RElHplNccmXa$Z9273oDp1R8Sw3GeSeAWf68nMSYwR4C55xR500mBMqc=	2021-11-18 17:11:41.947082+00	user1	user1@naver.com	2021-11-18 17:11:36.646679+00	Regular User	None	\N	\N	\N	f	\N	["7ukz62rrblqc1cscvpn8g8fpsb29zfuz"]	f	\N	f
\.


--
-- Data for Name: user_profile; Type: TABLE DATA; Schema: public; Owner: onlinejudge
--

COPY public.user_profile (id, acm_problems_status, oi_problems_status, real_name, avatar, blog, mood, github, school, major, language, accepted_number, total_score, submission_number, user_id, user_join_contest, submit_info) FROM stdin;
3	{}	{}	\N	/public/avatar/default.png	\N	\N	\N	\N	\N	\N	0	0	0	3	["국토교통 빅데이터 분석"]	[]
1	{}	{}	\N	/public/avatar/default.png	\N	\N	\N	\N	\N	\N	0	0	0	1	["빅데이터 통신 플랫폼 경진", "국토교통 빅데이터 해커톤", "손동작 인식 경진대회", "국토교통 빅데이터 분석"]	[]
2	{}	{}	11111	/public/avatar/default.png	\N	\N	\N	\N	지능기전공학부	\N	0	0	0	2	["국토교통 빅데이터 분석", "손동작 인식 경진대회", "작물 병해 분류 AI 대회", "AI 기반 회의 녹취록 요약", "빅데이터 통신 플랫폼"]	[{"score": 0, "problem_id": "국토교통 빅데이터 분석", "submit_time": "2021-11-22 11:41:32"}, {"score": 0, "problem_id": "AI 기반 회의 녹취록 요약", "submit_time": "2021-11-22 12:13:16"}, {"score": 55, "problem_id": "국토교통 빅데이터 분석", "submit_time": "2021-11-24 18:28:52"}]
\.


--
-- Name: acm_contest_rank_id_seq; Type: SEQUENCE SET; Schema: public; Owner: onlinejudge
--

SELECT pg_catalog.setval('public.acm_contest_rank_id_seq', 1, false);


--
-- Name: ai_contest_id_seq; Type: SEQUENCE SET; Schema: public; Owner: onlinejudge
--

SELECT pg_catalog.setval('public.ai_contest_id_seq', 9, true);


--
-- Name: ai_contest_tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: onlinejudge
--

SELECT pg_catalog.setval('public.ai_contest_tag_id_seq', 17, true);


--
-- Name: ai_contest_tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: onlinejudge
--

SELECT pg_catalog.setval('public.ai_contest_tags_id_seq', 59, true);


--
-- Name: announcement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: onlinejudge
--

SELECT pg_catalog.setval('public.announcement_id_seq', 1, true);


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: onlinejudge
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: onlinejudge
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: onlinejudge
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 80, true);


--
-- Name: contest_announcement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: onlinejudge
--

SELECT pg_catalog.setval('public.contest_announcement_id_seq', 1, false);


--
-- Name: contest_id_seq; Type: SEQUENCE SET; Schema: public; Owner: onlinejudge
--

SELECT pg_catalog.setval('public.contest_id_seq', 1, false);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: onlinejudge
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 20, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: onlinejudge
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 35, true);


--
-- Name: faq_id_seq; Type: SEQUENCE SET; Schema: public; Owner: onlinejudge
--

SELECT pg_catalog.setval('public.faq_id_seq', 1, true);


--
-- Name: judge_server_id_seq; Type: SEQUENCE SET; Schema: public; Owner: onlinejudge
--

SELECT pg_catalog.setval('public.judge_server_id_seq', 74, true);


--
-- Name: oi_contest_rank_id_seq; Type: SEQUENCE SET; Schema: public; Owner: onlinejudge
--

SELECT pg_catalog.setval('public.oi_contest_rank_id_seq', 1, false);


--
-- Name: options_sysoptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: onlinejudge
--

SELECT pg_catalog.setval('public.options_sysoptions_id_seq', 10, true);


--
-- Name: problem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: onlinejudge
--

SELECT pg_catalog.setval('public.problem_id_seq', 1, false);


--
-- Name: problem_tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: onlinejudge
--

SELECT pg_catalog.setval('public.problem_tag_id_seq', 1, false);


--
-- Name: problem_tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: onlinejudge
--

SELECT pg_catalog.setval('public.problem_tags_id_seq', 1, false);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: onlinejudge
--

SELECT pg_catalog.setval('public.user_id_seq', 3, true);


--
-- Name: user_profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: onlinejudge
--

SELECT pg_catalog.setval('public.user_profile_id_seq', 3, true);


--
-- Name: acm_contest_rank acm_contest_rank_pkey; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.acm_contest_rank
    ADD CONSTRAINT acm_contest_rank_pkey PRIMARY KEY (id);


--
-- Name: acm_contest_rank acm_contest_rank_user_id_contest_id_26151d10_uniq; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.acm_contest_rank
    ADD CONSTRAINT acm_contest_rank_user_id_contest_id_26151d10_uniq UNIQUE (user_id, contest_id);


--
-- Name: ai_contest ai_contest__id_contest_id_1468bc85_uniq; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.ai_contest
    ADD CONSTRAINT ai_contest__id_contest_id_1468bc85_uniq UNIQUE (_id, contest_id);


--
-- Name: ai_contest ai_contest_pkey; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.ai_contest
    ADD CONSTRAINT ai_contest_pkey PRIMARY KEY (id);


--
-- Name: ai_contest_tag ai_contest_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.ai_contest_tag
    ADD CONSTRAINT ai_contest_tag_pkey PRIMARY KEY (id);


--
-- Name: ai_contest_tags ai_contest_tags_aiproblem_id_aiproblemtag_id_466af71e_uniq; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.ai_contest_tags
    ADD CONSTRAINT ai_contest_tags_aiproblem_id_aiproblemtag_id_466af71e_uniq UNIQUE (aiproblem_id, aiproblemtag_id);


--
-- Name: ai_contest_tags ai_contest_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.ai_contest_tags
    ADD CONSTRAINT ai_contest_tags_pkey PRIMARY KEY (id);


--
-- Name: announcement announcement_pkey; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.announcement
    ADD CONSTRAINT announcement_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: contest_announcement contest_announcement_pkey; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.contest_announcement
    ADD CONSTRAINT contest_announcement_pkey PRIMARY KEY (id);


--
-- Name: contest contest_pkey; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.contest
    ADD CONSTRAINT contest_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_dramatiq_task django_dramatiq_task_pkey; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.django_dramatiq_task
    ADD CONSTRAINT django_dramatiq_task_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: faq faq_pkey; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.faq
    ADD CONSTRAINT faq_pkey PRIMARY KEY (id);


--
-- Name: judge_server judge_server_pkey; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.judge_server
    ADD CONSTRAINT judge_server_pkey PRIMARY KEY (id);


--
-- Name: oi_contest_rank oi_contest_rank_pkey; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.oi_contest_rank
    ADD CONSTRAINT oi_contest_rank_pkey PRIMARY KEY (id);


--
-- Name: oi_contest_rank oi_contest_rank_user_id_contest_id_fe51a302_uniq; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.oi_contest_rank
    ADD CONSTRAINT oi_contest_rank_user_id_contest_id_fe51a302_uniq UNIQUE (user_id, contest_id);


--
-- Name: options_sysoptions options_sysoptions_key_key; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.options_sysoptions
    ADD CONSTRAINT options_sysoptions_key_key UNIQUE (key);


--
-- Name: options_sysoptions options_sysoptions_pkey; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.options_sysoptions
    ADD CONSTRAINT options_sysoptions_pkey PRIMARY KEY (id);


--
-- Name: problem problem__id_contest_id_346645fe_uniq; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.problem
    ADD CONSTRAINT problem__id_contest_id_346645fe_uniq UNIQUE (_id, contest_id);


--
-- Name: problem problem_pkey; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.problem
    ADD CONSTRAINT problem_pkey PRIMARY KEY (id);


--
-- Name: problem_tag problem_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.problem_tag
    ADD CONSTRAINT problem_tag_pkey PRIMARY KEY (id);


--
-- Name: problem_tags problem_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.problem_tags
    ADD CONSTRAINT problem_tags_pkey PRIMARY KEY (id);


--
-- Name: problem_tags problem_tags_problem_id_problemtag_id_318459d1_uniq; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.problem_tags
    ADD CONSTRAINT problem_tags_problem_id_problemtag_id_318459d1_uniq UNIQUE (problem_id, problemtag_id);


--
-- Name: submission submission_pkey; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.submission
    ADD CONSTRAINT submission_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user_profile user_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.user_profile
    ADD CONSTRAINT user_profile_pkey PRIMARY KEY (id);


--
-- Name: user_profile user_profile_user_id_key; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.user_profile
    ADD CONSTRAINT user_profile_user_id_key UNIQUE (user_id);


--
-- Name: user user_username_key; Type: CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_username_key UNIQUE (username);


--
-- Name: acm_contest_rank_contest_id_21030ccd; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX acm_contest_rank_contest_id_21030ccd ON public.acm_contest_rank USING btree (contest_id);


--
-- Name: acm_contest_rank_user_id_40391ab2; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX acm_contest_rank_user_id_40391ab2 ON public.acm_contest_rank USING btree (user_id);


--
-- Name: ai_contest__id_ce50228c; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX ai_contest__id_ce50228c ON public.ai_contest USING btree (_id);


--
-- Name: ai_contest__id_ce50228c_like; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX ai_contest__id_ce50228c_like ON public.ai_contest USING btree (_id text_pattern_ops);


--
-- Name: ai_contest_contest_id_53ae9113; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX ai_contest_contest_id_53ae9113 ON public.ai_contest USING btree (contest_id);


--
-- Name: ai_contest_created_by_id_79fba3a2; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX ai_contest_created_by_id_79fba3a2 ON public.ai_contest USING btree (created_by_id);


--
-- Name: ai_contest_tags_aiproblem_id_6ea1f73d; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX ai_contest_tags_aiproblem_id_6ea1f73d ON public.ai_contest_tags USING btree (aiproblem_id);


--
-- Name: ai_contest_tags_aiproblemtag_id_a30dab80; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX ai_contest_tags_aiproblemtag_id_a30dab80 ON public.ai_contest_tags USING btree (aiproblemtag_id);


--
-- Name: announcement_created_by_id_359ccf50; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX announcement_created_by_id_359ccf50 ON public.announcement USING btree (created_by_id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: contest_announcement_contest_id_a8cb419f; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX contest_announcement_contest_id_a8cb419f ON public.contest_announcement USING btree (contest_id);


--
-- Name: contest_announcement_created_by_id_469a14ce; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX contest_announcement_created_by_id_469a14ce ON public.contest_announcement USING btree (created_by_id);


--
-- Name: contest_created_by_id_a763ca7e; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX contest_created_by_id_a763ca7e ON public.contest USING btree (created_by_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: faq_created_by_id_5cb5711f; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX faq_created_by_id_5cb5711f ON public.faq USING btree (created_by_id);


--
-- Name: oi_contest_rank_contest_id_171fcdaf; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX oi_contest_rank_contest_id_171fcdaf ON public.oi_contest_rank USING btree (contest_id);


--
-- Name: oi_contest_rank_user_id_0ba36852; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX oi_contest_rank_user_id_0ba36852 ON public.oi_contest_rank USING btree (user_id);


--
-- Name: options_sysoptions_key_b36a7ed9_like; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX options_sysoptions_key_b36a7ed9_like ON public.options_sysoptions USING btree (key text_pattern_ops);


--
-- Name: problem__id_919b1d80; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX problem__id_919b1d80 ON public.problem USING btree (_id);


--
-- Name: problem__id_919b1d80_like; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX problem__id_919b1d80_like ON public.problem USING btree (_id text_pattern_ops);


--
-- Name: problem_contest_id_328e013a; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX problem_contest_id_328e013a ON public.problem USING btree (contest_id);


--
-- Name: problem_created_by_id_cb362143; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX problem_created_by_id_cb362143 ON public.problem USING btree (created_by_id);


--
-- Name: problem_tags_problem_id_866ecb8d; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX problem_tags_problem_id_866ecb8d ON public.problem_tags USING btree (problem_id);


--
-- Name: problem_tags_problemtag_id_72d20571; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX problem_tags_problemtag_id_72d20571 ON public.problem_tags USING btree (problemtag_id);


--
-- Name: submission_contest_id_775716d5; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX submission_contest_id_775716d5 ON public.submission USING btree (contest_id);


--
-- Name: submission_id_bf9deb55_like; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX submission_id_bf9deb55_like ON public.submission USING btree (id text_pattern_ops);


--
-- Name: submission_problem_id_76847b55; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX submission_problem_id_76847b55 ON public.submission USING btree (problem_id);


--
-- Name: submission_result_37e2f67a; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX submission_result_37e2f67a ON public.submission USING btree (result);


--
-- Name: submission_user_id_3779a8c1; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX submission_user_id_3779a8c1 ON public.submission USING btree (user_id);


--
-- Name: user_username_cf016618_like; Type: INDEX; Schema: public; Owner: onlinejudge
--

CREATE INDEX user_username_cf016618_like ON public."user" USING btree (username text_pattern_ops);


--
-- Name: acm_contest_rank acm_contest_rank_contest_id_21030ccd_fk_contest_id; Type: FK CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.acm_contest_rank
    ADD CONSTRAINT acm_contest_rank_contest_id_21030ccd_fk_contest_id FOREIGN KEY (contest_id) REFERENCES public.contest(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: acm_contest_rank acm_contest_rank_user_id_40391ab2_fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.acm_contest_rank
    ADD CONSTRAINT acm_contest_rank_user_id_40391ab2_fk_user_id FOREIGN KEY (user_id) REFERENCES public."user"(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ai_contest ai_contest_contest_id_53ae9113_fk_contest_id; Type: FK CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.ai_contest
    ADD CONSTRAINT ai_contest_contest_id_53ae9113_fk_contest_id FOREIGN KEY (contest_id) REFERENCES public.contest(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ai_contest ai_contest_created_by_id_79fba3a2_fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.ai_contest
    ADD CONSTRAINT ai_contest_created_by_id_79fba3a2_fk_user_id FOREIGN KEY (created_by_id) REFERENCES public."user"(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ai_contest_tags ai_contest_tags_aiproblem_id_6ea1f73d_fk_ai_contest_id; Type: FK CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.ai_contest_tags
    ADD CONSTRAINT ai_contest_tags_aiproblem_id_6ea1f73d_fk_ai_contest_id FOREIGN KEY (aiproblem_id) REFERENCES public.ai_contest(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: ai_contest_tags ai_contest_tags_aiproblemtag_id_a30dab80_fk_ai_contest_tag_id; Type: FK CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.ai_contest_tags
    ADD CONSTRAINT ai_contest_tags_aiproblemtag_id_a30dab80_fk_ai_contest_tag_id FOREIGN KEY (aiproblemtag_id) REFERENCES public.ai_contest_tag(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: announcement announcement_created_by_id_359ccf50_fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.announcement
    ADD CONSTRAINT announcement_created_by_id_359ccf50_fk_user_id FOREIGN KEY (created_by_id) REFERENCES public."user"(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contest_announcement contest_announcement_contest_id_a8cb419f_fk_contest_id; Type: FK CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.contest_announcement
    ADD CONSTRAINT contest_announcement_contest_id_a8cb419f_fk_contest_id FOREIGN KEY (contest_id) REFERENCES public.contest(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contest_announcement contest_announcement_created_by_id_469a14ce_fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.contest_announcement
    ADD CONSTRAINT contest_announcement_created_by_id_469a14ce_fk_user_id FOREIGN KEY (created_by_id) REFERENCES public."user"(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contest contest_created_by_id_a763ca7e_fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.contest
    ADD CONSTRAINT contest_created_by_id_a763ca7e_fk_user_id FOREIGN KEY (created_by_id) REFERENCES public."user"(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: faq faq_created_by_id_5cb5711f_fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.faq
    ADD CONSTRAINT faq_created_by_id_5cb5711f_fk_user_id FOREIGN KEY (created_by_id) REFERENCES public."user"(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: oi_contest_rank oi_contest_rank_contest_id_171fcdaf_fk_contest_id; Type: FK CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.oi_contest_rank
    ADD CONSTRAINT oi_contest_rank_contest_id_171fcdaf_fk_contest_id FOREIGN KEY (contest_id) REFERENCES public.contest(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: oi_contest_rank oi_contest_rank_user_id_0ba36852_fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.oi_contest_rank
    ADD CONSTRAINT oi_contest_rank_user_id_0ba36852_fk_user_id FOREIGN KEY (user_id) REFERENCES public."user"(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: problem problem_contest_id_328e013a_fk_contest_id; Type: FK CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.problem
    ADD CONSTRAINT problem_contest_id_328e013a_fk_contest_id FOREIGN KEY (contest_id) REFERENCES public.contest(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: problem problem_created_by_id_cb362143_fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.problem
    ADD CONSTRAINT problem_created_by_id_cb362143_fk_user_id FOREIGN KEY (created_by_id) REFERENCES public."user"(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: problem_tags problem_tags_problem_id_866ecb8d_fk_problem_id; Type: FK CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.problem_tags
    ADD CONSTRAINT problem_tags_problem_id_866ecb8d_fk_problem_id FOREIGN KEY (problem_id) REFERENCES public.problem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: problem_tags problem_tags_problemtag_id_72d20571_fk_problem_tag_id; Type: FK CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.problem_tags
    ADD CONSTRAINT problem_tags_problemtag_id_72d20571_fk_problem_tag_id FOREIGN KEY (problemtag_id) REFERENCES public.problem_tag(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: submission submission_contest_id_775716d5_fk_contest_id; Type: FK CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.submission
    ADD CONSTRAINT submission_contest_id_775716d5_fk_contest_id FOREIGN KEY (contest_id) REFERENCES public.contest(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: submission submission_problem_id_76847b55_fk_problem_id; Type: FK CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.submission
    ADD CONSTRAINT submission_problem_id_76847b55_fk_problem_id FOREIGN KEY (problem_id) REFERENCES public.problem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_profile user_profile_user_id_8fdce8e2_fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: onlinejudge
--

ALTER TABLE ONLY public.user_profile
    ADD CONSTRAINT user_profile_user_id_8fdce8e2_fk_user_id FOREIGN KEY (user_id) REFERENCES public."user"(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

\connect postgres

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.19
-- Dumped by pg_dump version 10.19

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
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: onlinejudge
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- PostgreSQL database dump complete
--

\connect template1

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.19
-- Dumped by pg_dump version 10.19

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
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: onlinejudge
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

