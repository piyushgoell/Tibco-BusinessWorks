CREATE OR REPLACE PROCEDURE EXECUTOR.CREATEEVENTACTIVITY(
	IN EVENTACTIVITYID UUID,
	IN EVENTKEY TEXT,
	OUT EVENTID UUID)
LANGUAGE 'PLPGSQL'
AS $BODY$
DECLARE
	VALIDEVENTACTIVITYID UUID;
BEGIN
	BEGIN
        SELECT EXECUTOR.EXECUTORACTIVITY.ACTIVITYID FROM EXECUTOR.EXECUTORACTIVITY WHERE EXECUTOR.EXECUTORACTIVITY.ACTIVITYID=EVENTACTIVITYID INTO STRICT VALIDEVENTACTIVITYID;
        EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE EXCEPTION 'ACTIVITYID % NOT FOUND', INTEGRATIONACTIVITYID;
                WHEN TOO_MANY_ROWS THEN
                    RAISE EXCEPTION 'ACTIVITYID % NOT UNIQUE', INTEGRATIONACTIVITYID;
    END;
	BEGIN
			INSERT INTO EXECUTOR.EXECUTOREVENTACTIVITY(ACTIVITYID,EVENTKEY)
			VALUES (VALIDEVENTACTIVITYID,EVENTKEY)
			RETURNING EXECUTOR.EXECUTOREVENTACTIVITY.EVENTID INTO EVENTID;
			
	END;
END
$BODY$;
ALTER PROCEDURE EXECUTOR.CREATEEVENTACTIVITY(UUID, TEXT)
    OWNER TO POSTGRES;