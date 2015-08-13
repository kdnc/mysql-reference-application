# produce a list of paintings together with the artist names

# Method 1 - with WHERE clause

SELECT * FROM artist INNER JOIN painting 
WHERE artist.a_id = painting.a_id 
ORDER BY artist.a_id;

# Method 2 - with ON  clause

SELECT * FROM artist INNER JOIN painting 
ON artist.a_id = painting.a_id 
ORDER BY artist.a_id;

# Method 3 - In the special case of equality comparisons between columns with the same name in both tables, 
# you can use an INNER  JOIN with a USING clause instead.

SELECT * FROM artist INNER JOIN painting 
USING (a_id) 
ORDER BY a_id; 

# Select only paintings obtained in Kentucky

SELECT * FROM artist INNER JOIN painting 
ON artist.a_id = painting.a_id 
WHERE painting.state = 'KY';

# The preceding queries use SELECT * to display all columns. To be more selective, name
# only those columns in which you’re interested:

SELECT artist.name, painting.title, painting.state, painting.price 
FROM artist INNER JOIN painting 
ON artist.a_id = painting.a_id 
WHERE painting.state = 'KY';

# Show complete state names rather than abbreviations in the preceding query result

SELECT artist.name, painting.title, states.name, painting.price 
FROM artist INNER JOIN painting INNER JOIN states 
ON artist.a_id = painting.a_id AND painting.state = states.abbrev 
WHERE painting.state = 'KY';

# Which paintings did Van Gogh paint? Use the a_id value to find matching rows,
# add a  WHERE clause to restrict output to rows that contain the artist name, and select
# the title from those rows

SELECT painting.title
FROM artist INNER JOIN painting ON artist.a_id = painting.a_id 
WHERE artist.name = 'Van Gogh'; 

# Who painted the Mona Lisa? Again, use the a_id column to join the rows, but this
# time use the WHERE  clause to restrict output to rows that contain the title, and select
# the artist name from those rows:
SELECT artist.name 
FROM artist INNER JOIN painting ON artist.a_id = painting.a_id 
WHERE painting.title = 'Mona Lisa'; 

# For which artists did you purchase paintings in Kentucky or Indiana? This is similar
# to the previous statement, but tests a different column in the  painting  table (state)
# to restrict output to rows for KY or IN:
SELECT DISTINCT artist.name 
FROM artist INNER JOIN painting ON artist.a_id = painting.a_id 
WHERE painting.state IN ('KY','IN');

# How many paintings you have per artist:
SELECT artist.name, COUNT(*) AS 'number of paintings' 
FROM artist INNER JOIN painting ON artist.a_id = painting.a_id 
GROUP BY artist.name;

# How much you paid for each artist’s paintings, in total and on average:
SELECT artist.name, 
COUNT(*) AS 'number of paintings', 
SUM(painting.price) AS 'total price', 
AVG(painting.price) AS 'average price' 
FROM artist INNER JOIN painting ON artist.a_id = painting.a_id 
GROUP BY artist.name;

# To avoid writing complete table names when qualifying column references, give each
# table a short alias and refer to its columns using the alias. The following two statements
# are equivalent:
SELECT artist.name, painting.title, states.name, painting.price
FROM artist INNER JOIN painting INNER JOIN states
ON artist.a_id = painting.a_id AND painting.state = states.abbrev;

SELECT a.name, p.title, s.name, p.price
FROM artist AS a INNER JOIN painting AS p INNER JOIN states AS s
ON a.a_id = p.a_id AND p.state = s.abbrev;