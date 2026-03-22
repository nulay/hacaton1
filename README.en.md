# Medical Archive

A web application for storing personal medical documents when a user lives in different countries and visits different clinics.

## Project Idea

The user uploads medical documents (certificates, doctor conclusions, ECG, lab tests), keeps original files in a personal cabinet, and gets structured data for quick access.

Target scenario:
- documents are not lost in separate hospitals;
- all files are collected in one cabinet;
- in future, documents can be translated to the doctor's language;
- lab tests can be represented in table format.

## Current Technology Stack

- Java 21+ (project compiles to Java 21 bytecode)
- Apache Tomcat 9
- Spring MVC 5.3.x
- Spring Security 5.8.x
- PostgreSQL
- Flyway (DB migrations)
- JSP + JavaScript
- File storage: server file system
- Build tool: Maven (`war`)
- Docker Compose (for local PostgreSQL)

## Implemented So Far

- Base Spring MVC architecture (Java config, no `web.xml`)
- User registration and login
- Roles:
  - `USER`
  - `DOCTOR`
- Route protection via Spring Security:
  - public: `/`, `/auth/login`, `/auth/register`
  - cabinet: `/cabinet/**` for `USER` and `DOCTOR`
  - doctor area: `/doctor/**` only for `DOCTOR`
- JDBC repository for `users` table
- Flyway connected for DB versioned updates
- Flyway runs automatically on application startup
- Password hashing with BCrypt
- Base JSP pages:
  - `index`
  - `login`
  - `register`
  - `cabinet`
  - `doctor-dashboard`
  - `doctors`
  - `doctor-view`
- Added doctor profile entities:
  - `doctor_profiles` (photo, specialization)
  - `doctor_diplomas` (diplomas list)

## Project Structure

```text
src/
  main/
    java/com/hackaton/
      config/
      controller/
      model/
      repository/
      security/
      service/
    resources/db/
      schema.sql
      migration/
        V20260321_0_1_0__init_users.sql
        V20260321_0_1_1__doctor_profiles.sql
    resources/
      application.properties
    webapp/WEB-INF/jsp/
      *.jsp
docker/db/init/
  01-create-database.sql
pom.xml
flyway.properties
docker-compose.yml
```

## Setup and Run

### 1) Requirements

- JDK 21+ (you can use JDK 26, but build runs with `--release 21`)
- Maven 3.9+
- PostgreSQL 14+ (or compatible)
- Tomcat 9
- Docker (optional, for DB)

### 2) Start PostgreSQL

Recommended way is Docker Compose:

```bash
docker compose up -d
```

Check status:

```bash
docker compose ps
```

Stop:

```bash
docker compose down
```

`docker-compose.yml` mounts init script `docker/db/init/01-create-database.sql`.
Important: scripts from `/docker-entrypoint-initdb.d` run only during first volume initialization.
If you need to re-run init scripts, recreate volumes:

```bash
docker compose down -v
docker compose up -d
```

Or create the DB manually. Example:

```sql
CREATE DATABASE medical_archive;
```

### 3) DB Migrations (Flyway)

The app uses Flyway SQL migrations from:

- `src/main/resources/db/migration`

Manual migration run (optional):

```bash
mvn flyway:migrate
```

Maven Flyway uses:

- `flyway.properties`

Example:

```properties
db.url=${env.DB_URL}
db.user=${env.DB_USER}
db.password=${env.DB_PASSWORD}
```

Automatic mode:

- on application startup, Spring creates Flyway bean;
- migrations from `src/main/resources/db/migration` are applied automatically.

Migration naming convention:

- Format: `VYYYYMMDD_<pomVersion>__description.sql`
- Example for version `0.1.0-SNAPSHOT`: `V20260321_0_1_0__init_users.sql`
- `SNAPSHOT` is not used in file names, only numeric part.

### 4) Environment Variables

Database settings are now stored in:

- `src/main/resources/application.properties`

File contents:

```properties
db.url=${DB_URL:jdbc:postgresql://localhost:5432/medical_archive}
db.user=${DB_USER:postgres}
db.password=${DB_PASSWORD:postgres}
```

This means:

- you can keep defaults from the file;
- or override them via environment variables.

Used environment variables:

- `DB_URL` (default: `jdbc:postgresql://localhost:5432/medical_archive`)
- `DB_USER` (default: `postgres`)
- `DB_PASSWORD` (default: `postgres`)

Windows PowerShell example:

```powershell
$env:DB_URL="jdbc:postgresql://localhost:5432/medical_archive"
$env:DB_USER="postgres"
$env:DB_PASSWORD="postgres"
```

### 5) Build

```bash
mvn clean package
```

If you want migration + build in one run:

```bash
mvn flyway:migrate clean package
```

### 6) Deploy to Tomcat

Copy `target/medical-archive.war` to Tomcat 9 `webapps` folder and start server.

After startup, app URL:

- `http://localhost:8080/medical-archive`

## Main URLs

- Home: `/`
- Login: `/auth/login`
- Registration: `/auth/register`
- Cabinet: `/cabinet`
- Doctors list: `/cabinet/doctors`
- Doctor profile page: `/cabinet/doctors/{id}`
- Doctor dashboard: `/doctor/dashboard`
- Update doctor profile (POST): `/doctor/profile`
- Add diploma (POST): `/doctor/profile/diplomas`
- Logout: `/logout`

## Current Limitations

- Only cabinet/auth base is implemented now.
- Medical file upload, OCR, translation, and lab tables are not implemented yet.
- `schema.sql` is kept as a reference file; production DB update flow is Flyway migrations.

## Next Steps

1. Add medical file upload and file-system storage module.
2. Implement document card (date, type, title, doctor).
3. Add OCR pipeline with original file + extracted text.
4. Add lab-table parsing and manual editing.
5. Add medication reminder module.
