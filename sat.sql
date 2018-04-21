-- SAT Solver for formulae in 3-CNF, implemented in SQL
-- Lorenz Leutgeb <lorenz@leutgeb.xyz>

-- Note that any propositional formula can be
-- translated into an equivalent formula in 3-CNF.

-- Run as follows:
-- psql -q < sat.sql

-- Implementation --------------------------------------------------------------

-- Unary clauses
create temporary table clause1 (l1 bool);
insert into clause1 values
	(true);

-- Binary claues
create temporary table clause2 (l1 bool, l2 bool);
insert into clause2 values 
	(false,  true),
	( true, false);

-- Ternary clauses
create temporary table clause3 (l1 bool, l2 bool, l3 bool);
insert into clause3 values
	(false, false,  true),
	(false,  true, false),
	(false,  true,  true),
	( true, false, false),
	( true, false,  true),
	( true,  true, false),
	( true,  true,  true);

-- Literals (can be captured by binary clauses)
create temporary view literal (x, nx) as select * from clause2;

-- Test ------------------------------------------------------------------------

-- 1

-- Example Formula:
--  p implies (q xor r)
--
-- Translated into conjunctive normal form:
--  (~p or q or r) and (~p or ~q or ~r)
--
-- Models:
--  Vacously (p is false):
--    {}, {q}, {q,r}, {r}
--  Exclusive or (p is true, and q is the negation of p):
--    {p,q}, {q,r}

select distinct
	-- Read off the assignment for all variables
	p.x as p,
	q.x as q,
	r.x as r
from
	-- Declare clauses
	clause3 as c1,
	clause3 as c2,
	-- Declare literals for variables
	literal as p,
	literal as q,
	literal as r
where
	-- Define first clause
	c1.l1 = p.nx and
	c1.l2 = q.x  and
	c1.l3 = r.x  and
	-- Define second clause
	c2.l1 = p.nx and
	c2.l2 = q.nx and
	c2.l3 = r.nx ;

-- Expected Output:
--  p | q | r 
-- ---+---+---
--  t | t | f
--  t | f | t
--  f | t | t
--  f | t | f
--  f | f | t
--  f | f | f
-- (6 rows)

-- 2

-- Example Formula
--   p and ~p
--
-- Models: NONE

select distinct
	-- Read off the assignment for all variables
	p.x as p
from
	-- Declare clauses
	clause1 as c1,
	clause1 as c2,
	-- Declare literals for variables
	literal as p
where
	-- Define first clause
	c1.l1 = p.x  and
	-- Define second clause
	c2.l1 = p.nx ;

-- Expected Output:
--  p 
-- ---
-- (0 rows)

-- Tested with PostgreSQL 9.6.8
