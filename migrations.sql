-- 1 up
CREATE TABLE ides (
       id VARCHAR(100) PRIMARY KEY
);

CREATE TABLE submissions (
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       year INTEGER NOT NULL CHECK (year BETWEEN 2024 AND 2999),
       primary_ide VARCHAR(100) NOT NULL,
       secondary_ide VARCHAR(100),
       data TEXT -- data is a JSON document of extra stuff for the year
);
-- 1 down
DROP TABLE ides;
DROP TABLE submissions;
