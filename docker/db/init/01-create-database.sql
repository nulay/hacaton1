SELECT 'CREATE DATABASE medical_archive'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'medical_archive')\gexec
