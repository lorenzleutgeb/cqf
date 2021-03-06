# Conjunctive Query Fun

This repository contains two amusing examples of (ab)using answering of simple conjunctive queries to solve NP-complete problems.

In both cases solutions take the form of (structure-preserving) mappings. Since the problem of conjunctive query
answering is equivalent to finding a homomorphism between query and data, which are exactly that, the reductions/implementations are straight forward.

The data takes the role of a constrained target structure, while the query corresponds to the input,
and respects its structure. Then, results to the query are homomorphisms from the input to the constrained data.

## Reductions

### Boolean Satisfiability

Mapping: From propositional variables to truth values, a.k.a. "truth assignment".
Structure to preserve/Property to achieve: Satisfiability of (all) clauses.

### Graph 3-Colorability

Mapping: From nodes to colors, a.k.a. "coloring".
Structure to preserve/Property to achieve: Legal coloring of connected nodes.
