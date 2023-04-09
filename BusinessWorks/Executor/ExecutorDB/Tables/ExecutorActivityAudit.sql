CREATE TABLE IF NOT EXISTS EXECUTOR.EXECUTORACTIVITYAUDIT
(
    AUDITID UUID NOT NULL DEFAULT GEN_RANDOM_UUID(),
    ACTIVITYID UUID NOT NULL,
    ACTIVITYSTATEID SMALLINT NOT NULL,
    CREATEDBY UUID NOT NULL,
    CREATEDON TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    CONSTRAINT PK_EXECUTORACTIVITYAUDIT_AUDITID PRIMARY KEY (AUDITID),
    CONSTRAINT UK_EXECUTORACTIVITYAUDIT_ACTIVITYID_ACTIVITYSEQUENCE UNIQUE (ACTIVITYID, ACTIVITYSTATEID),
    CONSTRAINT FK_EXECUTORACTIVITYAUDIT_ACTIVITYID FOREIGN KEY (ACTIVITYID)
        REFERENCES EXECUTOR.EXECUTORACTIVITY (ACTIVITYID) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT FK_EXECUTORACTIVITYAUDIT_ACTIVITYSTATEID FOREIGN KEY (ACTIVITYSTATEID)
        REFERENCES EXECUTOR.EXECUTORACTIVITYSTATE (STATEID) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

ALTER TABLE IF EXISTS JOBEXECUTOR.EXECUTORACTIVITYAUDIT
    OWNER TO POSTGRES;