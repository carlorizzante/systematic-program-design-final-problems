# Systematic Program Design - Final Problems
Release 0.10.0

A collection of final projects made while studying Systematic Program Design - the most interesting bits anyway.

The code is currently written in BSL/ISL since those are the languages and used to teach Systematic Program Design at the University of British Columbia, along with the corresponding UBCx course. You can run these codes with Dr.Racket.

Note that the entire SPD path has been recently restructured into a new set of 6 parts, and it may not match the path of the old three courses.

[Software Development](https://www.edx.org/micromasters/software-development)

## Index
- 01 . HtDF + HtDD
- 02 . HtDW
- 03 . Compound Data
- 04a. Self Reference
- 04b. Reference
- 05a. Naturals
- 05b. Helpers
- 06a. Binary Search Trees
- 06b. Mutual Reference
- 07a. Crossed Data - Two One-of Types
- 07b. Local
- 08 . Abstraction
- 09a. Generative Recursion
- 09b. Search & Lamba
- 10.  Accumulators

## 02. HtDW
Lander is a very basic interactive video game where the player has to land a block on the bottom side of a canvas against gravity.

## 04a. Self Reference
When working on Arbitrary-sized information, since we do not know the size of the information, we can often apply recursion in order to handle the data. In order to do so, data has to be properly structured and self-referenced.

## 04b. Reference
Data doesn't necessarily have to reference itself. When within our data definition an entity refers to an other, we say there is a "reference". Reference allows for the creation of complex data structures.

## 05a. Naturals
An interesting experiment redefining a custom set of Natural numbers (more precisely an equivalent representation) and relative methods to work with it.

## 05b. Helpers
Helpers are usually quite generic functions designed with the purpose to support and enhance other more specific functions. Helpers are key for abstraction.

## 06a. Binary Search Trees
Binary Search Trees are a fundamental block in Computer Science. Even if we might not often have to directly handle data at low level, understanding how they are structured and how to work with them is greatly beneficial. Similar techniques can be applied to other fields.

## 06b. Mutual Reference
When data mutually interconnect we say that there is a mutual reference. This is a more complex data structure that requires a specific structure in our code to be properly handled.

## 07a. Crossed Data - Two One-of Types
When functions manipulate two or more different sets of data, we say that they operate on crossed data. The key here is to first visualize how the problem can be solved and to identify areas that can be grouped or simplified.

## 07b. Local
Lexical scope and encapsulation allow for a cleaner code. Helpers can be declared within the function that depends from them, so that not to pollute the global scope. Locals may also improve performances reducing the computation load.

## 08. Abstraction
Abstraction allows for a cleaner code with less repetition. This is typically achieved with the use of helpers shared across multiple functions.

Most programming languages offer a set of built in functions/helpers to manipulate arbitrary data, like map, filter, range, reduce, etc.

## 09a. Generative Recursion
Generative Recursion is similar to Structural Recursion: a function calls itself recursively (or several functions call themselves in mutual recursion). For the recursion to terminate, each recursive call must receive an argument that is in some way "closer to the base case". That is what guarantees the recursion will eventually terminate. Differently from Structural Recursion, though, for Generative Recursion the base case is usually harder to be defined.

Generative Recursion is typically used to create fractal images.

## 09b. Search & Lambda
Lambda are anonymous functions declared at the moment of necessity, that do not need to be kept in memory once the task the serve is accomplished. Lambda are an efficient alternative to helpers and local functions when the body of the function itself is straight forward and easier to understand (one-liner, a function simple enough to be clearly written in one single line).

A note about templates: a template is what I know about the body of the function based on what it consumes and its basic behavior, before getting into the details.

## 10. Accumulators
In natural recursion data is manipulated in chunks, and each iteration of the recursive process receives a smaller and smaller chunk to work on. That process loses part of the information, for the recursive function is agnostic of where it is in the process.

Accumulators can be seen as state being passed through the entire recursive process so that that part of information isn't lost. The next iteration will receive information about where it stands in the ongoing recursive path.

Another important concept is Tail Recursion that affects performances in programs that have to manipulate large amount of data.

This module shows applications for three kinds of accumulators:
1. Context preserving accumulators - to preserve context lost in natural recursion.
2. Result-so-far accumulators - to help achieve tail recursion by eliminating the need for pending operations.
3. Worklist accumulators - to help achieve tail recursion by eliminating the need to retain future recursive calls in pending operations.
