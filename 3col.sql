-- Solver for Graph 3-Colorability, implemented in SQL
-- Lorenz Leutgeb <lorenz@leutgeb.xyz>

-- Run as follows:
-- psql -q < sat.sql

-- Implementation --------------------------------------------------------------

-- Edges
create temporary table edge (s smallint, t smallint);
insert into edge values 
	(1, 2),
	(1, 3),
	(2, 1),
	(2, 3),
	(3, 1),
	(3, 2);

-- Nodes
create temporary table node (c smallint);
insert into node values
	(1),
	(2),
	(3);

-- Test ------------------------------------------------------------------------

-- 1

-- Example Graph:
--  (1, 2), (2, 3), (3, 1)

select distinct
	-- Read off the coloring of all nodes
	n1.c as c1,
	n2.c as c2,
	n3.c as c3
from
	-- Declare nodes
	node as n1,
	node as n2,
	node as n3,
	-- Declare edges
	edge as e1,
	edge as e2,
	edge as e3
where
	-- Define edge 1
	e1.s = n1.c and
	e1.t = n2.c and
	-- Define edge 2
	e2.s = n2.c and
	e2.t = n3.c and
	-- Define edge 3
	e3.s = n3.c and
	e3.t = n1.c ;

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

-- Tested with PostgreSQL 9.6.8
