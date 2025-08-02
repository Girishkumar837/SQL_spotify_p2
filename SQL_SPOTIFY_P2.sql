-- SQL Project Spotify

DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

SELECT * from public.spotify
LIMIT 10 ;

-- EDA

SELECT COUNT(*) FROM spotify;

SELECT COUNT (DISTINCT artist) FROM spotify;

SELECT COUNT (DISTINCT album) FROM spotify;

SELECT DISTINCT most_played_on FROM spotify
ORDER BY 1 DESC;

SELECT MAX(duration_min) FROM spotify;
SELECT MIN(duration_min) FROM spotify;

SELECT *
FROM spotify
WHERE duration_min = 0;

DELETE FROM spotify
WHERE duration_min = 0;

SELECT *
FROM spotify
WHERE duration_min = 0;

SELECT COUNT (DISTINCT channel) FROM spotify;

-- ----------------------------
-- Data Analysis - 1st Category 
-- ----------------------------

-- 1.Retrieve the names of all tracks that have more than 1 billion streams.

SELECT 
	track
FROM spotify
WHERE stream > 10000000;

-- 2.List all albums along with their respective artists.

SELECT 
	DISTINCT(album),
	artist 
FROM spotify
ORDER BY 1;

-- 3.Get the total number of comments for tracks where licensed = TRUE.

SELECT 
	SUM(comments) as total_comments
FROM spotify 
WHERE licensed = 'true';

-- 4.Find all tracks that belong to the album type single.

SELECT 
	*
FROM spotify 
WHERE album_type ILIKE 'single';

-- 5.Count the total number of tracks by each artist.

SELECT 
	artist,
	COUNT(track)
FROM spotify 
GROUP BY artist
ORDER BY 2 DESC;

---------------------
---- Category -2 ----
---------------------

-- 6.Calculate the average danceability of tracks in each album.

SELECT 
	album,
	avg(danceability) as Danceability_avg
FROM spotify 
GROUP BY album
ORDER BY 2 DESC;

-- 7.Find the top 5 tracks with the highest energy values.
SELECT 
	track,
	MAX(energy) as highest_energy
FROM spotify 
GROUP BY track
ORDER BY 2 DESC
LIMIT 5;

-- 8.List all tracks along with their views and likes where official_video = TRUE.
SELECT 
	track,
	sum(views) as total_views,
	sum(likes) as total_likes
FROM spotify 
WHERE official_video = 'True'
GROUP BY track
ORDER BY 2 DESC
LIMIT 5;

-- 9.For each album, calculate the total views of all associated tracks.

SELECT
	album,
	track,
	sum(views) as total_views
FROM spotify
GROUP BY 1,2
ORDER BY 3 DESC;

-- 10.Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT * FROM
(SELECT 
	track,
	COALESCE(sum(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) as streamed_on_youtube, 
	COALESCE(sum(CASE WHEN most_played_on = 'Spotify' THEN stream END),0) as streamed_on_spotify 
	--most_played_on
FROM spotify 
GROUP BY 1) as t1 
WHERE streamed_on_spotify > streamed_on_youtube
	AND streamed_on_youtube <> 0;

----------------------------------------
------------- Category - 3 -------------
----------------------------------------

-- 11.Find the top 3 most-viewed tracks for each artist using window functions.

WITH ranking_artist as (
SELECT artist,
	   track,
	   sum(views) as total_views,
	   DENSE_RANK () OVER (PARTITION BY artist ORDER BY sum(views) DESC) as rnk 
FROM spotify
	   GROUP BY 1,2
	   ORDER BY 1,3 DESC
)
SELECT 
	*
FROM ranking_artist
WHERE rnk <= 3;


-- 12. Write a query to find tracks where the liveness score is above the average.

SELECT 
	track,
	artist,
	liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);



-- 13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH CTE AS(
SELECT 
	album,
	MAX(energy) as Highest_energy,
	MIN(energy) as lowest_energy
FROM spotify 
GROUP BY 1
)
Select
	album,
	Highest_energy - lowest_energy as energy_dif
FROM CTE 
ORDER BY 2 DESC;
	
-- 14. Find tracks where the energy-to-liveness ratio is greater than 1.2

SELECT 
	track
Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.





