-- kettle tips on how to find tranforms , jobs , directories based on certain database connection, transform name or job name
 
-- Get all transforms who have certain database connections , for example prodsnapshot

    select s.ID_TRANSFORMATION, t.name,d.* from R_STEP_ATTRIBUTE s  
    join kettle.`R_TRANSFORMATION` t  
    ON t.ID_TRANSFORMATION = s.ID_TRANSFORMATION and s.code = 'id_connection'  
    join kettle.`R_DATABASE` d on s.value_num = d.ID_DATABASE and d.HOST_NAME LIKE '%prodsnap%'  

-- get directory based on certain job name

    SELECT d.* , j.* FROM R_JOB j  
    JOIN R_DIRECTORY d ON d.ID_DIRECTORY = j.ID_DIRECTORY  
    WHERE j.name = 'risk_dm_import'  


-- get jobs based on certain transform

    select j.name as job_name, d.directory_name from R_JOBENTRY je  
    join R_JOB j on j.ID_JOB = je.ID_JOB  
    JOIN R_DIRECTORY d ON d.ID_DIRECTORY = j.ID_DIRECTORY  
    where je.name = 'wcc_override_accounts' and je.description = 'Transformation'  
 

-- get all directories/jobs/transforms having a database connection

    SELECT dir.directory_name, j.name job, t.name transform FROM R_STEP_ATTRIBUTE s  
    JOIN kettle.`R_TRANSFORMATION` t  
    ON t.ID_TRANSFORMATION = s.ID_TRANSFORMATION AND s.code = 'id_connection'  
    JOIN kettle.`R_DATABASE` d ON s.value_num = d.ID_DATABASE AND d.HOST_NAME LIKE '%prodsnap%'  
    JOIN R_JOBENTRY je ON je.name = t.name  
    JOIN R_JOB j ON j.ID_JOB = je.ID_JOB  
    JOIN R_DIRECTORY dir ON dir.ID_DIRECTORY = j.ID_DIRECTORY  
    ORDER BY j.name  


-- List all post day end entrys' - including transfroms, jobs, shell, sql

	SELECT je.`NAME` AS entry_name, je.`ID_JOBENTRY_TYPE`, jt.code AS entry_type, jt.`DESCRIPTION`, j.name AS job_name, d.directory_name FROM R_JOBENTRY je
	JOIN R_JOB j ON j.ID_JOB = je.ID_JOB
	JOIN R_DIRECTORY d ON d.ID_DIRECTORY = j.ID_DIRECTORY
	JOIN `R_JOBENTRY_TYPE` jt ON jt.`ID_JOBENTRY_TYPE` = je.`ID_JOBENTRY_TYPE`
	WHERE	
	d.`DIRECTORY_NAME` = 'post_day_end' 
	AND j.name IN ('job_post_dayend_multicast','job_jobrunner_dbload_multicast' )
	AND jt.code IN ('SHELL', 'SQL', 'JOB', 'TRANS')
	ORDER BY j.name

 


-- kettle tool on jobrunner01 server

-- /usr/local/bin/job_wfs account_queue_history


-- Those will help us to do cleanups later or quickly locate a job/transform based on some logs.
-- To look for kettle jobs that have fields with specific words you can use the below query (in this example we are looking for transformations that have a step attribute that contains 'ucm')
-- This can capture input queries as well, which can be useful for identifying what kettle transformations touch what tables on a specific database.


    SELECT * FROM R_TRANSFORMATION
    WHERE ID_TRANSFORMATION IN(
    SELECT
      `ID_TRANSFORMATION`
    FROM
      `kettle`.`R_STEP_ATTRIBUTE`
    WHERE VALUE_STR LIKE '%ucm%')
