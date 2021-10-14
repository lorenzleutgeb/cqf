-- Solver for Graph 3-Colorability, implemented in SQL
-- Lorenz Leutgeb <lorenz@leutgeb.xyz>

-- Run as follows:
-- psql -q < sat.sql

-- Implementation --------------------------------------------------------------

create type color as enum ('r', 'g', 'b');

-- Vertices
create temporary table vertex (c color);
insert into vertex values ('r'), ('g'), ('b');

-- Edges
create temporary table edge (u color, v color);
insert into edge select u.c, v.c from vertex u, vertex v where u.c != v.c;

-- Test ------------------------------------------------------------------------

-- 1

-- Example Graph:
--  (1, 2), (2, 3), (3, 1)

select distinct
	-- Read off the coloring of all vertices
	v1.c as c1,
	v2.c as c2,
	v3.c as c3
from
	-- Declare vertices
	vertex as v1,
	vertex as v2,
	vertex as v3,
	-- Declare edges
	edge as e1,
	edge as e2,
	edge as e3
where
	-- Define edge 1
	e1.u = v1.c and
	e1.v = v2.c and
	-- Define edge 2
	e2.u = v2.c and
	e2.v = v3.c and
	-- Define edge 3
	e3.u = v3.c and
	e3.v = v1.c ;

-- Expected Output:
--  c1 | c2 | c3 
-- ----+----+----
--  r  | g  | b
--  r  | b  | g
--  g  | r  | b
--  g  | b  | r
--  b  | r  | g
--  b  | g  | r
-- (6 rows)

-- Tested with PostgreSQL 10
