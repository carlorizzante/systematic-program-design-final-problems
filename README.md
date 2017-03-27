# Systematic Program Design - Final Problems
Release 0.7.0

A collection of final projects made while studying Systematic Program Design - the most interesting bits anyway.

The code is currently written in BSL/ISL since those are the languages and used to teach Systematic Program Design at the University of British Columbia, along with the corresponding UBCx course. You can run these codes with Dr.Racket.

Note that the entire SPD path has been recently restructured into a new set of 6 parts, and it may not match the path of the old three courses.

[Software Development](https://www.edx.org/micromasters/software-development)

## Index
- 01.  HtDF + HtDD
- 02.  HtDW
- 03.  Compound Data
- 04a. Self Reference
- 04b. Reference
- 05a. Naturals
- 05b. Helpers
- 06a. Binary Search Trees
- 06b. Mutual Reference
- 07a. Crossed Data - Two One-of Types
- 07b. Local
- 08.  Abstraction

## 02. HtDW
Lander is a very basic interactive video game where the player has to land a block on the bottom side of a canvas against gravity.

## 04a. Self Reference
Bubbles of various sizes and colors pop up and fade away at the pressure of the "space bar".

## 05a. Naturals
An interesting experiment redefining a custom set of Natural numbers (more precisely an equivalent representation) and relative methods to work with it.

## 05b. Helpers
A small set of methods to support a various set of functions operating on lists.
- Blobs
- Pyramid & pyramid-random
- Sorting

## 06a. Binary Search Trees
Working with Binary Search Trees. A proper BST data definition following the SPD method, and a set of functions to work with Binary Search Trees like "insert", "lookup", and "balance-factor".

## 06b. Mutual Reference
Working with data with self and mutual reference.

## 07a. Crossed Data - Two One-of Types
Functions operating on crossed data, and relative templates. The key here is to first visualize how the problem can be solved, and to identify areas that can be grouped or simplified.

## 07b. Local
Lexical scope and encapsulation allow for a cleaner code, packing helpers within the function that depends from them, avoiding at the same time to pollute the global scope. Locals may also improve performances reducing the computation load.

## 08. Abstraction
Abstraction allows for a cleaner code with less repetition. Most programming languages offer a set of built in functions/helpers to manipulate arbitrary data, like map, filter, range, reduce, etc.

In order to better apply abstraction to our code it is helpful to understand what problems built in functions are designed to solve, and how to structure our main functions to better employ them.
