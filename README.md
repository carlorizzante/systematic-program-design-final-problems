# Systematic Program Design - Final Problems
Release 0.15.0

A collection of final projects made while studying Systematic Program Design - the most interesting bits anyway - and the most relevant concepts in Systematic Program Design in nutshells.

The code is currently written in BSL/ISL/ASL since those are the languages used to teach Systematic Program Design at the University of British Columbia, along with the corresponding UBCx course. To run the codes presented in this repo you can use Dr.Racket.

Note that the entire SPD path has been recently restructured into a new set of 6 courses.

[Software Development](https://www.edx.org/micromasters/software-development)

## Index
- 01a. BSL Fundamentals
- 01b. HtDF, How to Design Functions
- 02 . HtDD, How to Design Data
- 03a. HtDW, How to Design Worlds
- 03b. Compound Data
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
- 09b. Search & Lambda
- 10 . Accumulators
- 11 . Graphs

## 01a. BSL Fundamentals
Systematic Program Design is taught through a language called BSL at first, for Beginner Student Language. The language will later be extended to Intermediary Student Language, and Advanced Student Language.

This first chapter demonstrates some basic aspects of the language, like primitives, constants, functions and function arguments, and the use of images as data.

## 01b. HtDF, How to Design Functions
Functions are written systematically, though a series of steps that define, describe, and prototype the desired result. These three components are Signature, Purpose, and Stub.

The Signature expresses what types and arguments the function will accept and/or require.

The Purpose describe the expected result of the function.

And finally the Stub prototypes the function, offering an initial mockup to be used against unit tests.

Each step poses the basis for the subsequent step, down to the Stub that puts the basis for the tests. Tests are run initially against the Stub, and they are supposed to fail, but at the same time run correctly.

If we wrote the tests correctly, we may have good insides on how the function should perform and what operations will be involved in order to obtain the expected result.

Once stub and tests have been written, it is fundamental to run the code to verify that the code has been written correctly up to this point. Run the code regularly to identify bugs and errors. That way errors will be corrected with ease without allowing them to knot your code into an impossible mess.

### Tests
Tests are run right after the stub has been written so that to assure they are well formed. Tests have to offer full coverage of the various possibilities the final function has to take in account. This is a crucial point, there may be corner cases or boundary conditions to include.

### Template
After the tests, at least initially, functions are taken from an inventory of templates which are chosen in base of the Signature. The template offers an initial body for the function and help writing efficient code.

### Function body
Once tests and stub are in place and we verified that all run properly (though tests are expected to fail at this point), the template is edited or copied to write the function body which will be run against the tests to verify that the function satisfies the requirements.

## 02. HtDD, How to Design Data
While most programs tend to have more function designs than data designs, the design of data is an important and crucial aspect of software design. Data represents information and functions are designed accordingly to how data is designed information represented.

Data definitions constrain problems to reasonable parameters - parameters we can reason about - therefore making code easier to understand and manipulate as legacy code for other developers and/or at future date for ourselves.

To do so we often artificially create and specify new types from the basic types of the programming language we are using - see traffic-light.rkt or cities.rkt for some basic examples.

## 03a. HtDW, How to Design World
Decent sized programs all share an important aspect: they are complex. At the same time, successful programs and apps evolve over time and require constant maintenance and improving. Clearly defining the various parts of a complex application allows to refactor its parts efficiently.

Different programming languages may have syntax and paradigms different than BSL. However the main concepts still apply. There will be information to be expressed as data and users interactions to be handled.

## 03b. Compound Data
In progress...

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

## 11. Graphs
Information may naturally organize into trees of various kinds. When elements and/or properties of an information set are interrelated with more than one vector to the parent elements, we say that they take the form of graphs. Those data structures are generally defined as cyclic or directed graphs but there are of course acyclic graphs as well where data does not create opportunities for infinite loops.

Graphs help representing complex data structures like maps, wiring diagrams, even labyrinths. In order to work on graphs we need to define a new type of data generically called cyclic data as well as develop functions capable of working on this new form of data.
