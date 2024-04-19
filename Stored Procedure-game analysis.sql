CREATE DEFINER=`root`@`localhost` PROCEDURE `TopHeadShots`()
BEGIN
SELECT Dev_ID, Headshots_Count, Difficulty, 
       ROW_NUMBER() OVER (PARTITION BY dev_id ORDER BY headshots_count ASC) AS Headshots_rank
FROM level_details2
ORDER BY Dev_ID, Headshots_rank
LIMIT 5;
END