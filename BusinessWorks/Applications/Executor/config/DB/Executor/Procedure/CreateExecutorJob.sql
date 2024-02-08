CREATE OR REPLACE PROCEDURE Executor.CreateExecutorJob(
	IN ExecutorType text,
	IN ExecutorState text,
	IN ExecutorPriority text,
	IN ExecutorEffectiveDate timestamp with time zone,
	IN ExecutorCreatedBy uuid,
	OUT ExecutorId uuid)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
	ExecutorTypeId SMALLINT;
    ExecutorStateId SMALLINT;  
	ExecutorPriorityId SMALLINT;
	ExecutorCreatedOn timestamp without time zone;
BEGIN
	BEGIN
        SELECT Executor.ExecutorJobType.TypeId FROM Executor.ExecutorJobType WHERE Executor.ExecutorJobType.Type=ExecutorType INTO STRICT ExecutorTypeId;
        EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE EXCEPTION 'ExecutorType % not found', ExecutorType;
                WHEN TOO_MANY_ROWS THEN
                    RAISE EXCEPTION 'ExecutorType % not unique', ExecutorType;
    END;
    BEGIN
        SELECT Executor.ExecutorJobPriority.PriorityId FROM Executor.ExecutorJobPriority WHERE Executor.ExecutorJobPriority.Priority=ExecutorPriority INTO STRICT ExecutorPriorityId;
        EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE EXCEPTION 'ExecutorPrioritey % not found', ExecutorPriority;
                WHEN TOO_MANY_ROWS THEN
                    RAISE EXCEPTION 'ExecutorPriority % not unique', ExecutorPriority;
    END;
    BEGIN
        SELECT Executor.ExecutorJobState.StateId FROM Executor.ExecutorJobState WHERE Executor.ExecutorJobState.State=ExecutorState INTO STRICT ExecutorStateId;
        EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE EXCEPTION 'ExecutorState % not found', ExecutorState;
                WHEN TOO_MANY_ROWS THEN
                    RAISE EXCEPTION 'ExecutorState % not unique', ExecutorState;
    END;
	
	INSERT INTO Executor.ExecutorJob(
             ExecutorEffectiveDate, CreatedBy, ExecutorTypeId, ExecutorPriorityId, ExecutorStateId)
            VALUES (ExecutorEffectiveDate, ExecutorCreatedBy, ExecutorTypeId, ExecutorPriorityId, ExecutorStateId)
            RETURNING Executor.ExecutorJob.ExecutorId, Executor.ExecutorJob.CreatedOn INTO ExecutorId,ExecutorCreatedOn;
	
	BEGIN
		INSERT INTO Executor.ExecutorJobAudit(
		 ExecutorId, ExecutorStateId, CreatedBy, CreatedOn)
		VALUES (ExecutorId, ExecutorStateId,ExecutorCreatedBy, ExecutorCreatedOn);
	END;

END
$BODY$;
ALTER PROCEDURE Executor.CreateExecutorJob(text, text, text, timestamp with time zone, uuid)
    OWNER TO postgres;
