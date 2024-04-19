# Game-Analysis-with-SQL

In this project, I will be working with a dataset related to a game. The dataset includes two tables:
`Player Details` and `Level Details`. There are 15 questions for which I have to find the answers by
writing SQL queries.


Dataset Description:


Player Details Table:
 1. `P_ID`: Player ID
2. `PName`: Player Name
3.  `L1_status`: Level 1 Status
4.`L2_status`: Level 2 Status
5. `L1_code`: Systemgenerated Level 1 Code
6. `L2_code`: Systemgenerated Level 2 Code

 Level Details Table:
 
1.  `P_ID`: Player ID
2. `Dev_ID`: Device ID
3. `start_time`: Start Time
4.`stages_crossed`: Stages Crossed
5. `level`: Game Level
6. `difficulty`: Difficulty Level
7. `kill_count`: Kill Count
8. `headshots_count`: Headshots Count
9. `score`: Player Score
10. `lives_earned`: Extra Lives Earned

    
What I have to do?
Use the “Game Analysis.sql” file. Below are 15 questions for which I have to find the answers
by writing SQL queries. Each question carries 2 marks.
1. Extract `P_ID`, `Dev_ID`, `PName`, and `Difficulty_level` of all players at Level 0.
2. Find `Level1_code`wise average `Kill_Count` where `lives_earned` is 2, and at least 3
stages are crossed.

3. Find the total number of stages crossed at each difficulty level for Level 2 with players
using `zm_series` devices. Arrange the result in decreasing order of the total number of
stages crossed.
4. Extract `P_ID` and the total number of unique dates for those players who have played
games on multiple days.
5. Find `P_ID` and levelwise sum of `kill_counts` where `kill_count` is greater than the
average kill count for Medium difficulty.
6. Find `Level` and its corresponding `Level_code`wise sum of lives earned, excluding Level
0. Arrange in ascending order of level.
7. Find the top 3 scores based on each `Dev_ID` and rank them in increasing order using
`Row_Number`. Display the difficulty as well.
8. Find the `first_login` datetime for each device ID.
9. Find the top 5 scores based on each difficulty level and rank them in increasing order
using `Rank`. Display `Dev_ID` as well.
10. Find the device ID that is first logged in (based on `start_datetime`) for each player
(`P_ID`). Output should contain player ID, device ID, and first login datetime.
11. For each player and date, determine how many `kill_counts` were played by the player
so far.
a) Using window functions
b) Without window functions
12. Find the cumulative sum of stages crossed over `start_datetime` for each `P_ID`,
excluding the most recent `start_datetime`.
13. Extract the top 3 highest sums of scores for each `Dev_ID` and the corresponding `P_ID`.
14. Find players who scored more than 50% of the average score, scored by the sum of
scores for each `P_ID`.
15. Create a stored procedure to find the top `n` `headshots_count` based on each `Dev_ID`
and rank them in increasing order using `Row_Number`. Display the difficulty as well.
