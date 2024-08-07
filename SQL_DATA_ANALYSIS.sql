CREATE DATABASE sample_log_db;
use sample_log_db;

-- 1. Log Data Aggregation and Summarization: Aggregate log data by date and log level

SELECT 
    date, 
    log_level, 
    COUNT(*) AS log_count,
    GROUP_CONCAT(message) AS messages
FROM 
    logs 
GROUP BY 
    date, log_level 
LIMIT 0, 1000;

-- 2. Error Analysis and Identification: Filter and aggregate error entries to identify common issues or patterns

SELECT 
    message AS error_message,
    COUNT(*) AS occurrence_count
FROM 
    logs
WHERE 
    log_level = 'error'
GROUP BY 
    message
ORDER BY 
    occurrence_count DESC;

-- 3. Log Frequency Analysis: Count occurrences of log entries by log level

SELECT 
    log_level,
    COUNT(*) AS occurrence_count
FROM 
    logs
GROUP BY 
    log_level;

-- 4. Database Performance Monitoring: Extract performance-related metrics from logs for error and notice logs

SELECT 
    date,
    log_level,
    COUNT(*) AS log_count
FROM 
    logs
where
	log_level = 'error'
GROUP BY 
    date;

SELECT 
    date,
    log_level,
    COUNT(*) AS log_count
FROM 
    logs
where
	log_level = 'notice'
GROUP BY 
    date;

-- 5. User Behavior Analysis: Filter and analyze logs related to user activities or interactions

SELECT 
    message AS activity,
    COUNT(*) AS activity_count
FROM 
    logs
WHERE 
    log_level = 'notice'
GROUP BY 
    message;
    
-- 6. Data Quality and Validation - Check for inconsistencies or missing values in the log data

SELECT 
    id,
    CASE 
        WHEN message IS NULL OR message = '' THEN 'Missing message'
        WHEN date IS NULL THEN 'Missing date'
        WHEN time IS NULL THEN 'Missing time'
        WHEN log_level IS NULL OR log_level NOT IN ('notice', 'error') THEN 'Invalid log_level'
        ELSE 'Valid'
    END AS data_quality_issue
FROM 
    logs
WHERE 
    message IS NULL 
    OR message = '' 
    OR date IS NULL 
    OR time IS NULL 
    OR log_level IS NULL 
    OR log_level NOT IN ('notice', 'error')

UNION ALL

SELECT 
    NULL AS id, 
    'No inconsistencies found' AS data_quality_issue
WHERE NOT EXISTS (
    SELECT 1
    FROM logs
    WHERE 
        message IS NULL 
        OR message = '' 
        OR date IS NULL 
        OR time IS NULL 
        OR log_level IS NULL 
        OR log_level NOT IN ('notice', 'error')
);

