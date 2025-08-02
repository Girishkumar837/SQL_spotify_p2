# SQL_spotify_p2

Project 
[Click Here to get Dataset](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

![Spotify Project Preview](https://github.com/Girishkumar837/SQL_spotify_p2/blob/main/spotify_2.jpeg?raw=true)

## Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using **SQL**. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.

```sql
-- create table
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
```
## Project Steps

### 1. Data Exploration
Before diving into SQL, it’s important to understand the dataset thoroughly. The dataset contains attributes such as:
- `Artist`: The performer of the track.
- `Track`: The name of the song.
- `Album`: The album to which the track belongs.
- `Album_type`: The type of album (e.g., single or album).
- Various metrics such as `danceability`, `energy`, `loudness`, `tempo`, and more.

### 4. Querying the Data
After the data is inserted, various SQL queries can be written to explore and analyze the data. Queries are categorized into **Category 1**, **Category 2**, and **Category 3** levels to help progressively develop SQL proficiency.

#### Category 1 Queries
- Simple data retrieval, filtering, and basic aggregations.
  
#### Category 2 Queries
- More complex queries involving grouping, aggregation functions, and joins.
  
#### Category 3 Queries
- Nested subqueries, window functions, CTEs, and performance optimization.

## 15-Practice Questions

### Category 1 
1. Retrieve the names of all tracks that have more than 1 billion streams.
2. List all albums along with their respective artists.
3. Get the total number of comments for tracks where `licensed = TRUE`.
4. Find all tracks that belong to the album type `single`.
5. Count the total number of tracks by each artist.

### Category 2
1. Calculate the average danceability of tracks in each album.
2. Find the top 5 tracks with the highest energy values.
3. List all tracks along with their views and likes where `official_video = TRUE`.
4. For each album, calculate the total views of all associated tracks.
5. Retrieve the track names that have been streamed on Spotify more than YouTube.

### Category 3
1. **Find the top 3 most-viewed tracks for each artist using window functions**
```sql
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
```

2. **Write a query to find tracks where the liveness score is above the average.**
```sql
SELECT 
	track,
	artist,
	liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);
```
3. **Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
```sql
WITH cte
AS
(SELECT 
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energery
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest_energy - lowest_energery as energy_diff
FROM cte
ORDER BY 2 DESC
```
   
4. **Find tracks where the energy-to-liveness ratio is greater than 1.2.**:
 ```sql
   SELECT 
	track,
	artist,
	energy,
	liveness,
	(energy/liveness) AS energy_to_liveness_ratio
FROM spotify 
WHERE (energy/liveness) > 1.2
```

5. **Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions**:
```sql
SELECT
	track,
	artist,
	views,
	likes,
	SUM(likes) OVER (ORDER BY views) as cumulative_likes
FROM spotify
```
---
      
## Technology Stack
- **Database**: PostgreSQL
- **SQL Queries**: DDL, DML, Aggregations, Joins, Subqueries, Window Functions
- **Tools**: pgAdmin 4 (or any SQL editor), PostgreSQL (via Homebrew, Docker, or direct installation)

## How to Run the Project
1. Install PostgreSQL and pgAdmin (if not already installed).
2. Set up the database schema and tables using the provided normalization structure.
3. Insert the sample data into the respective tables.
4. Execute SQL queries to solve the listed problems.
5. Explore query optimization techniques for large datasets.

---


