-- Create the project databases:
CREATE DATABASE timetable_development;

-- Create user and set permission to the user:
CREATE USER pondpaun7z PASSWORD '7898';
GRANT ALL PRIVILEGES ON DATABASE timetable_development TO pondpaun7z;
