CREATE TABLE IF NOT EXISTS EXECUTOR.EXECUTORJOBSTATE
(
    STATEID SMALLINT NOT NULL,
    STATE CHARACTER(10) COLLATE PG_CATALOG.DEFAULT NOT NULL,
    CONSTRAINT PK_EXECUTORJOBSTATE_STATEID PRIMARY KEY (STATEID),
    CONSTRAINT UK_EXECUTORJOBSTATE_STATE UNIQUE (STATE)
);

ALTER TABLE IF EXISTS EXECUTOR.EXECUTORJOBSTATE
    OWNER TO POSTGRES;