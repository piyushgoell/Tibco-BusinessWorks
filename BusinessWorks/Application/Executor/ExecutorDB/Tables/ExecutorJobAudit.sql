CREATE TABLE IF NOT EXISTS EXECUTOR.EXECUTORJOBAUDIT
(
    AUDITID UUID NOT NULL DEFAULT GEN_RANDOM_UUID(),
    EXECUTORID UUID NOT NULL,
    EXECUTORSTATEID SMALLINT NOT NULL,
    CREATEDBY UUID NOT NULL,
    CREATEDON TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_EXECUTORJOBAUDIT_AUDITID PRIMARY KEY (AUDITID),
    CONSTRAINT UK_EXECUTORJOBAUDIT_EXECUTORID_EXECUTORSTATEID UNIQUE (EXECUTORID, EXECUTORSTATEID),
    CONSTRAINT FK_EXECUTORJOBAUDIT_EXECUTORAUDITEXECUTORID_EXECUTORID FOREIGN KEY (EXECUTORID)
        REFERENCES EXECUTOR.EXECUTORJOB (EXECUTORID) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT FK_EXECUTORJOBAUDIT_EXECUTORSTATEID_STATEID FOREIGN KEY (EXECUTORSTATEID)
        REFERENCES EXECUTOR.EXECUTORJOBSTATE (STATEID) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

ALTER TABLE IF EXISTS EXECUTOR.EXECUTORJOBAUDIT
    OWNER TO POSTGRES;

CREATE INDEX IF NOT EXISTS FKI_FK_EXECUTORJOBAUDIT_EXECUTORAUDIT_EXECUTORID
    ON EXECUTOR.EXECUTORJOBAUDIT USING BTREE
    (EXECUTORID ASC NULLS LAST);