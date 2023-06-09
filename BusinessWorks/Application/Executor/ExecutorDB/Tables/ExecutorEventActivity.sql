CREATE TABLE IF NOT EXISTS EXECUTOR.EXECUTOREVENTACTIVITY
(
    EVENTID UUID NOT NULL DEFAULT GEN_RANDOM_UUID(),
    ACTIVITYID UUID NOT NULL,
    EVENTKEY TEXT COLLATE PG_CATALOG.DEFAULT NOT NULL,
    CONSTRAINT PK_EXECUTOREVENTACTIVITY_EVENTID PRIMARY KEY (EVENTID),
    CONSTRAINT FK_EXECUTOREVENTACTIVITY_ACTIVITYID FOREIGN KEY (ACTIVITYID)
        REFERENCES JOBEXECUTOR.EXECUTORACTIVITY (ACTIVITYID) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

ALTER TABLE IF EXISTS EXECUTOR.EXECUTOREVENTACTIVITY
    OWNER TO POSTGRES;