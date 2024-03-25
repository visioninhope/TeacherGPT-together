DROP TABLE IF EXISTS 
    "course_period_room",
    "expulsions",
    "suspensions",
    "behavior_plan",
    "behavior_referrals",
    "etr",
    "iep_accomodations",
    "iep_goals",
    "iep",
    "students_sped_categories",
    "sped_categories",
    "sped_roster",
    "student_score",
    "assignment",
    "course_student",
    "course_staff",
    "course",
    "student_grade_levels",
    "staff_grade_levels",
    "grade_levels",
    "staff_department",
    "department",
    "staff",
    "attendance_types",
    "assignment_types",
    "period_list",
    "rooms",
    "daily_attendance",
    "school_enrollment",
    "student" CASCADE;

-- BEGIN TRANSACTION;

-- CREATE EXTENSION citext;

-- CREATE DOMAIN email AS citext
--   CHECK ( value ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$' );
-- ERROR:  permission denied to create extension "citext"
-- HINT:  Must have CREATE privilege on current database to create this extension. 

CREATE TABLE "student" (
  "student_id" SERIAL PRIMARY KEY,
  "first_name" varchar(255) NOT NULL,
  "middle_name" varchar(255),
  "last_name" varchar(255) NOT NULL,
  "dob" date,
  "email" varchar UNIQUE,
  "ohio_ssid" varchar UNIQUE NOT NULL,
  CONSTRAINT "chk_ohio_ssid_format" CHECK ("ohio_ssid" ~ '^[A-Za-z]{2}[0-9]{7}$')
  -- CONSTRAINT "chk_email_format" CHECK ("email" ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$')
  --  CONSTRAINT "chk_email_format" CHECK ("email" ~ '^[a-zA-Z0-9.!#$%&''*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$')
);

CREATE TABLE "school_enrollment" (
  "student_id" int,
  "first_day" date,
  "last_day" date
);

CREATE TABLE "daily_attendance" (
  "student_id" int,
  "date" date,
  "attendance_type" int,
  "arrival" timestamptz,
  "departure" timestamptz,
  "excuse_note" varchar
);

CREATE TABLE "attendance_type" (
  "attendance_type_id" SERIAL PRIMARY KEY,
  "attendance_type" varchar
);

CREATE TABLE "staff" (
  "staff_id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "first_name" varchar,
  "middle_name" varchar,
  "last_name" varchar,
  "email" varchar UNIQUE,
  "position" varchar
);

CREATE TABLE "department" (
  "department_id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "department_name" varchar
);

CREATE TABLE "staff_department" (
  "department_id" int,
  "staff_id" int
);

CREATE TABLE "grade_levels" (
  "grade_level_id" SERIAL PRIMARY KEY,
  "grade_level_name" varchar,
  "grade_level_chair" int
);

CREATE TABLE "staff_grade_levels" (
  "grade_level_id" int,
  "staff_id" int
);

CREATE TABLE "student_grade_levels" (
  "grade_level_id" int,
  "student_id" int
);

CREATE TABLE "course" (
  "course_id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "lead_teacher_id" int,
  "grade_level_id" int
);

CREATE TABLE "course_staff" (
  "course_id" int,
  "staff_id" int
);

CREATE TABLE "course_student" (
  "student_id" int,
  "course_id" int
);

CREATE TABLE "assignment" (
  "assignment_id" SERIAL PRIMARY KEY,
  "assignment_title" varchar,
  "assignment_type_id" int,
  "date_assigned" date,
  "date_due" date,
  "weight" float DEFAULT 1,
  "course_id" int
);

CREATE TABLE "assignment_types" (
  "assignment_type_id" SERIAL PRIMARY KEY,
  "assignment_type" varchar
);

CREATE TABLE "student_score" (
  "student_id" int,
  "assignment_id" int,
  "percentage_score" float
);

CREATE TABLE "sped_roster" (
  "student_id" int,
  "has_iep" bool,
  "has_504" bool
);

CREATE TABLE "sped_categories" (
  "category_id" SERIAL PRIMARY KEY,
  "sped_category" varchar
);

CREATE TABLE "students_sped_categories" (
  "student_id" int,
  "category_id" int
);

CREATE TABLE "iep" (
  "iep_id" SERIAL PRIMARY KEY,
  "student_id" int,
  "last_updated" date
);

CREATE TABLE "iep_goals" (
  "iep_id" int,
  "goal" varchar
);

CREATE TABLE "iep_accomodations" (
  "iep_id" int,
  "accomodation" varchar
);

CREATE TABLE "etr" (
  "etr_id" SERIAL PRIMARY KEY,
  "student_id" int,
  "last_updated" date,
  "executive_summary" varchar
);

CREATE TABLE "behavior_referrals" (
  "student_id" int,
  "reporting_staff" int,
  "date" date,
  "period_id" int,
  "student_report" varchar,
  "internal_report" varchar
);

CREATE TABLE "behavior_plan" (
  "student_id" int,
  "plan_description" varchar,
  "staff_author" int,
  "adoption_date" date,
  "active" bool
);

CREATE TABLE "suspensions" (
  "suspension_id" SERIAL PRIMARY KEY,
  "student_id" int,
  "startdate" date,
  "enddate" date
);

CREATE TABLE "expulsions" (
  "expulsion_id" SERIAL PRIMARY KEY,
  "student_id" int,
  "date" date NOT NULL,
  "days_length" int NOT NULL,
  "expulsion_report" varchar NOT NULL
);

CREATE TABLE "period_list" (
  "period_id" SERIAL PRIMARY KEY,
  "period_name" varchar,
  "start_time" timestamptz,
  "end_time" timestamptz
);

CREATE TABLE "rooms" (
  "room_id" SERIAL PRIMARY KEY,
  "room_name" varchar
);

CREATE TABLE "course_period_room" (
  "course_id" int,
  "room_id" int,
  "period_id" int
);

ALTER TABLE "school_enrollment" ADD FOREIGN KEY ("student_id") REFERENCES "student" ("student_id");

ALTER TABLE "daily_attendance" ADD FOREIGN KEY ("student_id") REFERENCES "student" ("student_id");

ALTER TABLE "daily_attendance" ADD FOREIGN KEY ("attendance_type") REFERENCES "attendance_type" ("attendance_type_id");

ALTER TABLE "staff_department" ADD FOREIGN KEY ("department_id") REFERENCES "department" ("department_id");

ALTER TABLE "staff_department" ADD FOREIGN KEY ("staff_id") REFERENCES "staff" ("staff_id");

ALTER TABLE "grade_levels" ADD FOREIGN KEY ("grade_level_chair") REFERENCES "staff" ("staff_id");

ALTER TABLE "staff_grade_levels" ADD FOREIGN KEY ("grade_level_id") REFERENCES "grade_levels" ("grade_level_id");

ALTER TABLE "staff_grade_levels" ADD FOREIGN KEY ("staff_id") REFERENCES "staff" ("staff_id");

ALTER TABLE "student_grade_levels" ADD FOREIGN KEY ("grade_level_id") REFERENCES "grade_levels" ("grade_level_id");

ALTER TABLE "student_grade_levels" ADD FOREIGN KEY ("student_id") REFERENCES "student" ("student_id");

ALTER TABLE "course" ADD FOREIGN KEY ("lead_teacher_id") REFERENCES "staff" ("staff_id");

ALTER TABLE "course" ADD FOREIGN KEY ("grade_level_id") REFERENCES "grade_levels" ("grade_level_id");

ALTER TABLE "course_staff" ADD FOREIGN KEY ("course_id") REFERENCES "course" ("course_id");

ALTER TABLE "course_staff" ADD FOREIGN KEY ("staff_id") REFERENCES "staff" ("staff_id");

ALTER TABLE "course_student" ADD FOREIGN KEY ("student_id") REFERENCES "student" ("student_id");

ALTER TABLE "course_student" ADD FOREIGN KEY ("course_id") REFERENCES "course" ("course_id");

ALTER TABLE "assignment" ADD FOREIGN KEY ("assignment_type_id") REFERENCES "assignment_types" ("assignment_type_id");

ALTER TABLE "assignment" ADD FOREIGN KEY ("course_id") REFERENCES "course" ("course_id");

ALTER TABLE "student_score" ADD FOREIGN KEY ("student_id") REFERENCES "student" ("student_id");

ALTER TABLE "student_score" ADD FOREIGN KEY ("assignment_id") REFERENCES "assignment" ("assignment_id");

ALTER TABLE "sped_roster" ADD FOREIGN KEY ("student_id") REFERENCES "student" ("student_id");

ALTER TABLE "students_sped_categories" ADD FOREIGN KEY ("student_id") REFERENCES "student" ("student_id");

ALTER TABLE "students_sped_categories" ADD FOREIGN KEY ("category_id") REFERENCES "sped_categories" ("category_id");

ALTER TABLE "iep" ADD FOREIGN KEY ("student_id") REFERENCES "student" ("student_id");

ALTER TABLE "iep_goals" ADD FOREIGN KEY ("iep_id") REFERENCES "iep" ("iep_id");

ALTER TABLE "iep_accomodations" ADD FOREIGN KEY ("iep_id") REFERENCES "iep" ("iep_id");

ALTER TABLE "etr" ADD FOREIGN KEY ("student_id") REFERENCES "student" ("student_id");

ALTER TABLE "behavior_referrals" ADD FOREIGN KEY ("student_id") REFERENCES "student" ("student_id");

ALTER TABLE "behavior_referrals" ADD FOREIGN KEY ("reporting_staff") REFERENCES "staff" ("staff_id");

ALTER TABLE "behavior_referrals" ADD FOREIGN KEY ("period_id") REFERENCES "period_list" ("period_id");

ALTER TABLE "behavior_plan" ADD FOREIGN KEY ("student_id") REFERENCES "student" ("student_id");

ALTER TABLE "behavior_plan" ADD FOREIGN KEY ("staff_author") REFERENCES "staff" ("staff_id");

ALTER TABLE "suspensions" ADD FOREIGN KEY ("student_id") REFERENCES "student" ("student_id");

ALTER TABLE "expulsions" ADD FOREIGN KEY ("student_id") REFERENCES "student" ("student_id");

ALTER TABLE "course_period_room" ADD FOREIGN KEY ("course_id") REFERENCES "course" ("course_id");

ALTER TABLE "course_period_room" ADD FOREIGN KEY ("room_id") REFERENCES "rooms" ("room_id");

ALTER TABLE "course_period_room" ADD FOREIGN KEY ("period_id") REFERENCES "period_list" ("period_id");
