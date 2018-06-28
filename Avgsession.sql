SELECT(
SELECT SUM(length) 
FROM(
     SELECT DISTINCT session_id, amplitude_id, 
     DATEDIFF('milliseconds',timestamp 'epoch' + session_id /
     1000.0 * INTERVAL '1 second',max)
     AS length 
     FROM(
          SELECT amplitude_id, session_id, 
          MAX(client_event_time) OVER(PARTITION BY session_id 
          ORDER BY amplitude_id, client_event_time ROWS 
          BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED 
          FOLLOWING)AS max, MIN(client_event_time) 
          OVER(PARTITION BY session_id ORDER BY amplitude_id, 
          client_event_time ROWS BETWEEN UNBOUNDED PRECEDING 
          AND UNBOUNDED FOLLOWING) AS min 
          FROM events123 
          WHERE country = 'United States' 
          AND DATE(event_time) BETWEEN '2017-03-30' AND 
          '2017-04-06' AND session_id != '-1') 
     WHERE DATE(min)= '2017-03-30')
)
/
(SELECT CAST(COUNT(DISTINCT session_id) AS float) 
FROM events123 
WHERE session_id != '-1' 
AND DATE(event_time)= '2017-03-30' 
AND country = 'United States')
/1000 AS average
;