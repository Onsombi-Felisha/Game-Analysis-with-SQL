USE game-analysis;

SHOW TABLES;

-- alter table pd modify L1_Status varchar(30);
ALTER TABLE player_details
MODIFY L1_Status VARCHAR(30);

-- alter table pd modify L2_Status varchar(30);
ALTER TABLE player_details
MODIFY L2_Status VARCHAR(30);

-- alter table pd modify P_ID int primary key;
ALTER TABLE player_details
ADD PRIMARY KEY (P_ID);

-- alter table pd drop myunknowncolumn;
ALTER TABLE player_details
DROP COLUMN MyUnknownColumn;

-- alter table ld drop myunknowncolumn;
ALTER TABLE level_details2
DROP COLUMN MyUnknownColumn;

-- alter table ld change timestamp start_datetime datetime;
ALTER TABLE level_details2
CHANGE COLUMN `start_datetime_new` start_datetime DATETIME;

-- alter table ld modify Dev_Id varchar(10);
ALTER TABLE level_details2
MODIFY Dev_Id  VARCHAR(10);

-- alter table ld modify Difficulty varchar(15);
ALTER TABLE level_details2
MODIFY Difficulty  VARCHAR(15);

-- alter table ld add primary key(P_ID,Dev_id,start_datetime);
ALTER TABLE level_details2
ADD CONSTRAINT pk_level_details2 PRIMARY KEY (P_ID, Dev_id, start_datetime);

 -- Q1) Extract P_ID,Dev_ID,PName and Difficulty_level of all players 
-- at level 0


SELECT pd.P_ID, pd.PName,
ld.Dev_ID,ld.Difficulty
FROM player_details AS pd
JOIN level_details2 AS ld
ON pd.P_ID = ld.P_ID
WHERE L1_Status = '0'
AND L2_Status = '0';


-- Q2) Find Level1_code wise Avg_Kill_Count where lives_earned is 2 and atleast
--    3 stages are crossed
SELECT AVG(Kill_Count) 
FROM level_details2
WHERE Stages_crossed >= 3
AND Lives_Earned = 2
AND Level = '1';

-- Q3) Find the total number of stages crossed at each diffuculty level
-- where for Level2 with players use zm_series devices. Arrange the result
-- in decsreasing order of total number of stages crossed.

SELECT Difficulty, COUNT(Stages_crossed) AS total_stages_crossed
FROM level_details2
WHERE Dev_ID LIKE 'zm%'
    AND level = 2
GROUP BY Difficulty
ORDER BY total_stages_crossed DESC;

-- Q4) Extract P_ID and the total number of unique dates for those players 
-- who have played games on multiple days.

SELECT P_ID, COUNT(DISTINCT start_datetime) AS unique_multipledates_played
FROM level_details2
GROUP BY P_ID
HAVING COUNT(DISTINCT start_datetime) > 1;

-- Q5) Find P_ID and level wise sum of kill_counts where kill_count
-- is greater than avg kill count for the Medium difficulty.

SELECT P_ID, level, SUM(Kill_count) AS Level_Killings
FROM level_details2
WHERE Kill_count > (
    SELECT AVG(Kill_count)
    FROM level_details2
    WHERE difficulty = 'Medium'
)
GROUP BY P_ID, level;

-- Q6)  Find Level and its corresponding Level code wise sum of lives earned 
-- excluding level 0. Arrange in asecending order of level.

SELECT Level, SUM(Lives_Earned) AS Sum_Lives_Earned
FROM level_details2
WHERE Level in  ('1','2')
GROUP BY Level
ORDER BY Level ASC;

-- Q7) Find Top 3 score based on each dev_id and Rank them in increasing order
-- using Row_Number. Display difficulty as well. 

SELECT Dev_id, Difficulty, Score, rnk, row_rank
FROM ( SELECT Dev_id, Difficulty, Score,
		RANK() OVER (ORDER BY Score ASC) AS rnk, ROW_NUMBER() OVER (ORDER BY Score ASC) AS row_rank
    FROM level_details2
) AS subquery
WHERE rnk <= 3;

-- Q8) Find first_login datetime for each device id

SELECT Dev_id, MIN(start_datetime) AS first_login
FROM level_details2
GROUP BY Dev_id;

-- Q9) Find Top 5 score based on each difficulty level and Rank them in 
-- increasing order using Rank. Display dev_id as well.

SELECT Dev_id, Difficulty, Score, RANK_5
FROM ( SELECT Dev_id, Difficulty, Score, 
		RANK() OVER (PARTITION BY Difficulty ORDER BY Score ASC) AS RANK_5
FROM level_details2
) AS subquery
WHERE RANK_5 <= 5;

-- Q10) Find the device ID that is first logged in(based on start_datetime) 
-- for each player(p_id). Output should contain player id, device id and 
-- first login datetime.

SELECT P_ID, Dev_ID, first_login 
FROM (SELECT P_ID, Dev_ID, MIN(start_datetime) AS first_login
       FROM level_details2
	   GROUP BY P_ID, Dev_ID) AS subquery;

-- Q11) For each player and date, how many kill_count played so far by the player. That is, the total number of games played -- by the player until that date.
-- a) window function
SELECT P_ID, start_datetime,
       SUM(Kill_count) OVER (PARTITION BY P_ID ORDER BY start_datetime) AS total_number_games_played
FROM level_details2;

-- b) without window function

-- Q12) Find the cumulative sum of stages crossed over a start_datetime 

SELECT start_datetime, Stages_crossed,
    SUM(Stages_crossed) OVER (ORDER BY start_datetime) AS Cumulative_Sum_Stages
FROM level_details2;

-- Q13) Find the cumulative sum of an stages crossed over a start_datetime 
-- for each player id but exclude the most recent start_datetime

SELECT P_ID,start_datetime,Stages_crossed,
    SUM(Stages_crossed) OVER (PARTITION BY P_ID ORDER BY start_datetime) AS Cumulative_Sum_Stages
FROM level_details2
WHERE (P_ID, start_datetime) 
 NOT IN (SELECT P_ID,MAX(start_datetime) AS max_start_datetime
        FROM level_details2
        GROUP BY P_ID);

-- Q14) Extract top 3 highest sum of score for each device id and the corresponding player_id

SELECT Dev_ID, P_ID, TOP_3
FROM ( SELECT Dev_ID, P_ID, 
	   RANK() OVER (PARTITION BY Dev_ID ORDER BY SUM(Score) DESC) AS TOP_3
       FROM level_details2
       GROUP BY Dev_ID, P_ID  
) AS subquery
WHERE TOP_3 <= 3;

-- Q15) Find players who scored more than 50% of the avg score scored by sum of 
-- scores for each player_id

SELECT P_ID
FROM ( SELECT P_ID, SUM(Score) AS total_score, AVG(SUM(Score)) OVER () AS avg_total_score
    FROM level_details2
    GROUP BY P_ID
) AS P_ID_scores
WHERE total_score > 0.5 * avg_total_score;

-- Q16) Create a stored procedure to find top n headshots_count based on each dev_id and Rank them in increasing order
-- using Row_Number. Display difficulty as well.

call TopHeadShots;
