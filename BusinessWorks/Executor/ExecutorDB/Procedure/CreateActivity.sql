CREATE OR REPLACE PROCEDURE EXECUTOR.CREATEACTIVITY(
	IN ACTIVITYTYPE TEXT,
	IN ACTIVITYSTATE TEXT,
	IN ACTIVITYNAME TEXT,
	IN ACTIVITYSEQUENCE TEXT,
	IN ACTIVITYTASKID UUID,
	IN ACTIVITYCREATEDBY UUID,
	OUT ACTIVITYID UUID,
	IN ACTIVITYREQUESTMESSAGE XML DEFAULT NULL,
	IN ACTIVITYEVENTKEYS TEXT DEFAULT NULL )-- Expectting comma seperated keys
LANGUAGE 'PLPGSQL'
AS $BODY$
DECLARE
	ACTIVITYTYPEID SMALLINT;
    ACTIVITYSTATEID SMALLINT;  
	VALIDATEDACTIVITYTASKID UUID;
	ACTIVITYCREATEDON TIMESTAMP WITH TIME ZONE;
	ACTIVITYINTEGRATIONID UUID;
	ACTIVITYEVENTID UUID;
	EVENTKEY TEXT;
BEGIN
	BEGIN
        SELECT EXECUTOR.EXECUTORACTIVITYTYPE.TYPEID FROM EXECUTOR.EXECUTORACTIVITYTYPE WHERE EXECUTOR.EXECUTORACTIVITYTYPE.TYPE=ACTIVITYTYPE INTO STRICT ACTIVITYTYPEID;
        EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE EXCEPTION 'EXECUTORTYPE % NOT FOUND', ACTIVITYTYPE;
                WHEN TOO_MANY_ROWS THEN
                    RAISE EXCEPTION 'EXECUTORTYPE % NOT UNIQUE', ACTIVITYTYPE;
    END;

 	BEGIN
        SELECT EXECUTOR.EXECUTORSTATE.STATEID FROM EXECUTOR.EXECUTORSTATE WHERE EXECUTOR.EXECUTORSTATE.STATE=ACTIVITYSTATE INTO STRICT ACTIVITYSTATEID;
        EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE EXCEPTION 'EXECUTORSTATE % NOT FOUND', ACTIVITYSTATE;
                WHEN TOO_MANY_ROWS THEN
                    RAISE EXCEPTION 'EXECUTORSTATE % NOT UNIQUE', ACTIVITYSTATE;
    END;
	
	
 	BEGIN
        SELECT EXECUTOR.EXECUTORTASK.TASKID FROM EXECUTOR.EXECUTORTASK WHERE EXECUTOR.EXECUTORTASK.TASKID=ACTIVITYTASKID INTO STRICT VALIDATEDACTIVITYTASKID;
        EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE EXCEPTION 'EXECUTORID % NOT FOUND', ACTIVITYTASKID;
                WHEN TOO_MANY_ROWS THEN
                    RAISE EXCEPTION 'EXECUTORID % NOT UNIQUE', ACTIVITYTASKID;
    END;
	
	BEGIN
		INSERT INTO EXECUTOR.EXECUTORACTIVITY(ACTIVITYTYPEID,ACTIVITYSTATEID,ACTIVITYNAME,ACTIVITYSEQUENCE,TASKID,CREATEDBY)
		VALUES(ACTIVITYTYPEID,ACTIVITYSTATEID,ACTIVITYNAME,ACTIVITYSEQUENCE,VALIDATEDACTIVITYTASKID,ACTIVITYCREATEDBY)
		RETURNING EXECUTOR.EXECUTORACTIVITY.ACTIVITYID, EXECUTOR.EXECUTORACTIVITY.CREATEDON INTO ACTIVITYID,ACTIVITYCREATEDON;
	END;
	
	IF ACTIVITYTYPEID = 2 THEN
		CALL EXECUTOR.CREATEINTEGRATIONACTIVITY(ACTIVITYID,ACTIVITYREQUESTMESSAGE,ACTIVITYINTEGRATIONID);
	ELSE
		FOREACH EVENTKEY IN ARRAY (STRING_TO_ARRAY(ACTIVITYEVENTKEYS, ',')::TEXT[])
		LOOP
			CALL EXECUTOR.CREATEEVENTACTIVITY(ACTIVITYID,EVENTKEY,ACTIVITYEVENTID);
		END LOOP;
	END IF;
	
	BEGIN
		INSERT INTO EXECUTOR.EXECUTORACTIVITYAUDIT(
		 ACTIVITYID, ACTIVITYSTATEID, CREATEDBY, CREATEDON)
		VALUES (ACTIVITYID, ACTIVITYSTATEID,ACTIVITYCREATEDBY, ACTIVITYCREATEDON);
	END;

END
$BODY$;
ALTER PROCEDURE EXECUTOR.CREATEACTIVITY(TEXT, TEXT, TEXT, TEXT, UUID, UUID, XML, TEXT)
    OWNER TO POSTGRES;
