CREATE TABLE IF NOT EXISTS EXECUTOR.EXECUTORTASK
(
    TASKID UUID NOT NULL DEFAULT GEN_RANDOM_UUID(),
    TASKTYPEID SMALLINT NOT NULL,
    TASKSTATEID SMALLINT NOT NULL,
    TASKNAME TEXT NOT NULL,
    TASKSEQUENCE TEXT  NOT NULL,
    EXECUTORID UUID NOT NULL,
    CREATEDBY UUID NOT NULL,
    CREATEDON TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_EXECUTORTASK_TASKID PRIMARY KEY (TASKID),
    CONSTRAINT UK_EXECUTORTASK_EXECUTORID_TASKSEQUENCE UNIQUE (TASKSEQUENCE, EXECUTORID),
    CONSTRAINT FK_EXECUTORTASK_EXECUTORID FOREIGN KEY (EXECUTORID)
        REFERENCES EXECUTOR.EXECUTORJOB (EXECUTORID) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT FK_EXECUTORTASK_TASKINTEGRATIONTYPEID FOREIGN KEY (TASKTYPEID)
        REFERENCES EXECUTOR.EXECUTORTASKTYPE (TYPEID) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT FK_EXECUTORTASK_TASKSTATEID FOREIGN KEY (TASKSTATEID)
        REFERENCES EXECUTOR.EXECUTORTASKSTATE (STATEID) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

ALTER TABLE IF EXISTS EXECUTOR.EXECUTORTASK
    OWNER TO POSTGRES;