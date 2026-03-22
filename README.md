# Medical Archive

Веб-приложение для личного хранения медицинских документов пользователя при жизни в разных странах и обращении в разные клиники.

## Идея проекта

Пользователь загружает медицинские документы (справки, заключения, ЭКГ, анализы), хранит оригиналы у себя в личном кабинете и получает структурированные данные для быстрого доступа.

Целевой сценарий:
- документы не теряются в отдельных больницах;
- все файлы собраны в одном кабинете;
- в дальнейшем документы можно переводить на язык врача;
- анализы можно представлять в табличном виде.

## Текущий технологический стек

- Java 21+ (проект компилируется в bytecode 21)
- Apache Tomcat 9
- Spring MVC 5.3.x
- Spring Security 5.8.x
- PostgreSQL
- Flyway (миграции БД)
- JSP + JavaScript
- Хранение файлов: файловая система сервера
- Сборка: Maven (`war`)
- Docker Compose (для локального PostgreSQL)

## Что уже реализовано

- Базовая архитектура Spring MVC (Java config, без `web.xml`)
- Регистрация и вход пользователей
- Роли:
  - `USER`
  - `DOCTOR`
- Защита маршрутов через Spring Security:
  - публичные: `/`, `/auth/login`, `/auth/register`
  - кабинет: `/cabinet/**` для `USER` и `DOCTOR`
  - кабинет врача: `/doctor/**` только для `DOCTOR`
- JDBC-репозиторий для таблицы `users`
- Подключен Flyway для версионирования изменений БД
- Flyway запускается автоматически при старте приложения
- Шифрование пароля через BCrypt
- Базовые JSP-страницы:
  - `index`
  - `login`
  - `register`
  - `cabinet`
  - `doctor-dashboard`
  - `doctors`
  - `doctor-view`
- Добавлены сущности профиля врача:
  - `doctor_profiles` (фото, специализация)
  - `doctor_diplomas` (список дипломов)

## Структура проекта

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
pom.xml
flyway.properties
docker-compose.yml
docker/db/init/
  01-create-database.sql
```

## Настройка и запуск

### 1) Требования

- JDK 21+ (можно использовать JDK 26, но сборка идет с `--release 21`)
- Maven 3.9+
- PostgreSQL 14+ (или совместимая версия)
- Tomcat 9

### 2) Создать БД

Рекомендуемый способ — через Docker Compose:

```bash
docker compose up -d
```

Проверка статуса:

```bash
docker compose ps
```

Остановка:

```bash
docker compose down
```

В `docker-compose.yml` подключен init-скрипт `docker/db/init/01-create-database.sql`.
Важно: скрипты из `/docker-entrypoint-initdb.d` выполняются только при первичной инициализации volume.
Если нужно выполнить init заново, удалите volume:

```bash
docker compose down -v
docker compose up -d
```

Либо создать БД вручную. Пример:

```sql
CREATE DATABASE medical_archive;
```

### 3) Миграции БД (Flyway)

Приложение использует Flyway и SQL-миграции из:

- `src/main/resources/db/migration`

Запуск миграций вручную (опционально):

```bash
mvn flyway:migrate
```

Для Maven Flyway используется файл:

- `flyway.properties`

Пример:

```properties
db.url=${env.DB_URL}
db.user=${env.DB_USER}
db.password=${env.DB_PASSWORD}
```

Автоматический режим:

- при старте приложения Spring создает bean Flyway;
- миграции из `src/main/resources/db/migration` применяются автоматически.

Соглашение по именам миграций:

- Формат: `VYYYYMMDD_<pomVersion>__description.sql`
- Пример для версии `0.1.0-SNAPSHOT`: `V20260321_0_1_0__init_users.sql`
- `SNAPSHOT` в имени файла не используем, только числовую часть версии.

### 4) Переменные окружения

Параметры подключения БД теперь хранятся в:

- `src/main/resources/application.properties`

Файл содержит:

```properties
db.url=${DB_URL:jdbc:postgresql://localhost:5432/medical_archive}
db.user=${DB_USER:postgres}
db.password=${DB_PASSWORD:postgres}
```

Это значит:

- можно оставить значения по умолчанию из файла;
- или переопределять их через переменные окружения.

Используются переменные:

- `DB_URL` (по умолчанию `jdbc:postgresql://localhost:5432/medical_archive`)
- `DB_USER` (по умолчанию `postgres`)
- `DB_PASSWORD` (по умолчанию `postgres`)

Пример для Windows PowerShell:

```powershell
$env:DB_URL="jdbc:postgresql://localhost:5432/medical_archive"
$env:DB_USER="postgres"
$env:DB_PASSWORD="postgres"
```

### 5) Сборка

```bash
mvn clean package
```

Если хотите выполнить миграции и сборку подряд:

```bash
mvn flyway:migrate clean package
```

### 6) Деплой в Tomcat

Скопировать `target/medical-archive.war` в каталог `webapps` Tomcat 9 и запустить сервер.

После старта приложение будет доступно по адресу:

- `http://localhost:8080/medical-archive`

## Основные URL

- Главная: `/`
- Вход: `/auth/login`
- Регистрация: `/auth/register`
- Кабинет: `/cabinet`
- Список врачей: `/cabinet/doctors`
- Карточка врача: `/cabinet/doctors/{id}`
- Кабинет врача: `/doctor/dashboard`
- Обновить профиль врача (POST): `/doctor/profile`
- Добавить диплом (POST): `/doctor/profile/diplomas`
- Выход: `/logout`

## Ограничения текущей версии

- Пока реализована только база кабинета и авторизация.
- Загрузка медицинских файлов, OCR, переводы и таблицы анализов еще не реализованы.
- `schema.sql` сохранен как справочный файл, рабочий путь обновления БД — через Flyway миграции.

## Ближайшие шаги

1. Добавить модуль загрузки и хранения файлов на файловой системе.
2. Реализовать карточку документа (дата, тип, название, врач).
3. Добавить OCR-пайплайн с сохранением оригинала и текста.
4. Реализовать таблицу анализов и ручное редактирование.
5. Добавить напоминания о приеме лекарств.
