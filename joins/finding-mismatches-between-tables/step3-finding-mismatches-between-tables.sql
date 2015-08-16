# If you want to find rows in one table that have no match in another use an outer join 
# (a LEFT JOIN or a RIGHT JOIN) or a NOT IN subquery.
# ---------------------------------------------------

# which artists in the artist table are missing from the painting table.
# Following query falsely indicates that each painting was painted by several different artists. The problem is that
# the statement lists all combinations of values from the two tables in which the artist ID
# values aren’t the same. What you really need is a list of values in  artist that aren’t present at allin painting, 
# but an inner join can only produce results based on values that are
# present in both tables.
SELECT * FROM artist INNER JOIN painting
ON artist.a_id <> painting.a_id
ORDER BY artist.a_id;

# +------+----------+------+------+-------------------+-------+-------+
# | a_id | name     | a_id | p_id | title             | state | price |
# +------+----------+------+------+-------------------+-------+-------+
# |    1 | Da Vinci |    4 |    5 | Les Deux Soeurs   | NE    |    64 |
# |    1 | Da Vinci |    3 |    4 | The Potato Eaters | KY    |    67 |
# |    1 | Da Vinci |    3 |    3 | Starry Night      | KY    |    48 |
# |    2 | Monet    |    3 |    3 | Starry Night      | KY    |    48 |
# |    2 | Monet    |    1 |    2 | Mona Lisa         | MI    |    87 |
# |    2 | Monet    |    1 |    1 | The Last Supper   | IN    |    34 |
# |    2 | Monet    |    4 |    5 | Les Deux Soeurs   | NE    |    64 |
# |    2 | Monet    |    3 |    4 | The Potato Eaters | KY    |    67 |
# |    3 | Van Gogh |    4 |    5 | Les Deux Soeurs   | NE    |    64 |
# |    3 | Van Gogh |    1 |    2 | Mona Lisa         | MI    |    87 |
# |    3 | Van Gogh |    1 |    1 | The Last Supper   | IN    |    34 |
# |    4 | Renoir   |    1 |    2 | Mona Lisa         | MI    |    87 |
# |    4 | Renoir   |    1 |    1 | The Last Supper   | IN    |    34 |
# |    4 | Renoir   |    3 |    4 | The Potato Eaters | KY    |    67 |
# |    4 | Renoir   |    3 |    3 | Starry Night      | KY    |    48 |
# +------+----------+------+------+-------------------+-------+-------+

# Begin with an inner join that displays matching rows
SELECT * FROM artist INNER JOIN painting 
ON artist.a_id = painting.a_id 
ORDER BY artist.a_id; 

# +------+----------+------+------+-------------------+-------+-------+
# | a_id | name     | a_id | p_id | title             | state | price |
# +------+----------+------+------+-------------------+-------+-------+
# |    1 | Da Vinci |    1 |    2 | Mona Lisa         | MI    |    87 |
# |    1 | Da Vinci |    1 |    1 | The Last Supper   | IN    |    34 |
# |    3 | Van Gogh |    3 |    4 | The Potato Eaters | KY    |    67 |
# |    3 | Van Gogh |    3 |    3 | Starry Night      | KY    |    48 |
# |    4 | Renoir   |    4 |    5 | Les Deux Soeurs   | NE    |    64 |
# +------+----------+------+------+-------------------+-------+-------+

# Now substitute LEFTfor INNERto see the result you get from an outer join:
SELECT * FROM artist LEFT JOIN painting 
ON artist.a_id = painting.a_id 
ORDER BY artist.a_id;

# +------+----------+------+------+-------------------+-------+-------+
# | a_id | name     | a_id | p_id | title             | state | price |
# +------+----------+------+------+-------------------+-------+-------+
# |    1 | Da Vinci |    1 |    2 | Mona Lisa         | MI    |    87 |
# |    1 | Da Vinci |    1 |    1 | The Last Supper   | IN    |    34 |
# |    2 | Monet    | NULL | NULL | NULL              | NULL  |  NULL |
# |    3 | Van Gogh |    3 |    4 | The Potato Eaters | KY    |    67 |
# |    3 | Van Gogh |    3 |    3 | Starry Night      | KY    |    48 |
# |    4 | Renoir   |    4 |    5 | Les Deux Soeurs   | NE    |    64 |
# +------+----------+------+------+-------------------+-------+-------+

# Next, to restrict the output only to the unnmatched artist  rows, add a WHEREclause 
# that looks for  NULLvalues in any  paintingcolumn that cannot otherwise contain NULL.
SELECT * FROM artist LEFT JOIN painting 
ON artist.a_id = painting.a_id 
WHERE painting.a_id IS NULL;

# +------+-------+------+------+-------+-------+-------+
# | a_id | name  | a_id | p_id | title | state | price |
# +------+-------+------+------+-------+-------+-------+
# |    2 | Monet | NULL | NULL | NULL  | NULL  |  NULL |
# +------+-------+------+------+-------+-------+-------+

# Finally, to show only the artist table values that are missing from the painting table,
# write the output column list to name only columns from the artist table.
SELECT artist.* FROM artist LEFT JOIN painting 
ON artist.a_id = painting.a_id 
WHERE painting.a_id IS NULL;

# +------+-------+
# | a_id | name  |
# +------+-------+
# |    2 | Monet |
# +------+-------+

# List each artist from the artist
# table and shows whether you have any paintings by the artist:

SELECT artist.name,
IF(COUNT(painting.a_id)>0,'yes','no') AS 'in collection?' 
FROM artist LEFT JOIN painting ON artist.a_id = painting.a_id 
GROUP BY artist.name;

# +----------+----------------+
# | name     | in collection? |
# +----------+----------------+
# | Da Vinci | yes            |
# | Monet    | no             |
# | Renoir   | yes            |
# | Van Gogh | yes            |
# +----------+----------------+

# Another way to identify values present in one table but missing from another is to use
# a NOT IN subquery.

SELECT * FROM artist 
WHERE a_id NOT IN (SELECT a_id FROM painting);

# +------+-------+
# | a_id | name  |
# +------+-------+
# |    2 | Monet |
# +------+-------+