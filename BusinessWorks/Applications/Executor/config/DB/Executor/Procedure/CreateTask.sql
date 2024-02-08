-- PROCEDURE: Executor.CreateTask(text, text, text, text, uuid, uuid)

-- DROP PROCEDURE IF EXISTS Executor.CreateTask(text, text, text, text, uuid, uuid);

CREATE OR REPLACE PROCEDURE Executor.CreateTask(
	IN TaskType text,
	IN TaskState text,
	IN TaskName text,
	IN TaskSequence text,
	IN TaskExecutorId uuid,
	IN TaskCreatedBy uuid,
	OUT TaskId uuid)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
	TaskTypeId SMALLINT;
    TaskStateId SMALLINT;  
	ValidatedTaskExecutorId UUID;
	TaskCreatedOn timestamp with time zone;
BEGIN
	BEGIN
        SELECT Executor.ExecutorTaskType.TypeId FROM Executor.ExecutorTaskType WHERE Executor.ExecutorTaskType.Type=TaskType INTO STRICT TaskTypeId;
        EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE EXCEPTION 'ExecutorType % not found', TaskType;
                WHEN TOO_MANY_ROWS THEN
                    RAISE EXCEPTION 'ExecutorType % not unique', TaskType;
    END;

 	BEGIN
        SELECT Executor.ExecutorState.StateId FROM Executor.ExecutorState WHERE Executor.ExecutorState.State=TaskState INTO STRICT TaskStateId;
        EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE EXCEPTION 'ExecutorState % not found', TaskState;
                WHEN TOO_MANY_ROWS THEN
                    RAISE EXCEPTION 'ExecutorState % not unique', TaskState;
    END;
	
	
 	BEGIN
        SELECT Executor.Executor.ExecutorId FROM Executor.Executor WHERE Executor.Executor.ExecutorId=TaskExecutorId INTO STRICT ValidatedTaskExecutorId;
        EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RAISE EXCEPTION 'ExecutorId % not found', TaskExecutorId;
                WHEN TOO_MANY_ROWS THEN
                    RAISE EXCEPTION 'ExecutorId % not unique', TaskExecutorId;
    END;
	
	INSERT INTO Executor.ExecutorTask(TaskTypeId,TaskStateId,TaskName,TaskSequence,ExecutorId,CreatedBy)
	VALUES(TaskTypeId,TaskStateId,TaskName,TaskSequence,ValidatedTaskExecutorId,TaskCreatedBy)
	RETURNING Executor.ExecutorTask.TaskId, Executor.ExecutorTask.CreatedOn INTO TaskId,TaskCreatedOn;
	
	INSERT INTO Executor.ExecutorTaskAudit(
	 TaskId, TaskStateId, CreatedBy, CreatedOn)
	VALUES (TaskId, TaskStateId,TaskCreatedBy, TaskCreatedOn);

END
$BODY$;
ALTER PROCEDURE Executor.CreateTask(text, text, text, text, uuid, uuid)
    OWNER TO postgres;
