CREATE TABLE IF NOT EXISTS EXECUTOR.EXECUTORTASKTYPE
(
    TYPEID SMALLINT NOT NULL,
    TYPE TEXT NOT NULL,
    CONSTRAINT PK_EXECUTORTASKINTEGRATIONTYPE_TYPEID PRIMARY KEY (TYPEID),
    CONSTRAINT UK_EXECUTORTASKINTEGRATIONTYPE_TYPE UNIQUE (TYPE)
);

ALTER TABLE IF EXISTS EXECUTOR.EXECUTORTASKTYPE
    OWNER TO POSTGRES;