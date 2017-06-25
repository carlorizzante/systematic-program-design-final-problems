# Systematic Program Design - Final Problems
Release 0.25.0

Notes and solutions for problems collected while studying Systematic Program Design.

The code is currently written in BSL/ISL/ASL since those are the languages used to teach Systematic Program Design at the University of British Columbia, along with the corresponding UBCx course. To run the codes presented in this repo you need to install Dr.Racket.

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
- 06b. Final Problem - Space Invaders
- 07.  Mutual Reference
- 08a. Two One-of Types
- 08b. Local
-----
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
We define as Compound Data information that consists of two or more naturally connected values. This relates to various types of entities normally used in programming, objects, dictionaries, structures, arrays containing different types, etc.

In BSL we typically use "define-struct" at this purpose.

## 04a. Self Reference
When working on Arbitrary-sized information, since we do not know the size of the information, we can often apply recursion in order to handle the data. In order to do so, data has to be properly structured and self-referenced.

Self Reference allows us to represent arbitrarily large amount of information - information we do not necessarily know the size of in advance.

Compound Data is the first choice for representing complex information. However, arrays, lists, similar entities are as well as good examples.

A well formed self-referenced data has at least two cases, at lease one base case, and one or more self-referenced cases. The base case is fundamental for it stops the recursive loop. The self-referenced cases allow for recursion on data.

Tests are fundamental for Self-Reference, they need to include a base test (usually tested first), and all edge cases right after.

## 04b. Reference
Data doesn't necessarily have to reference itself. When within our data definition an entity refers to an other, we say there is a "reference". Reference allows for the creation of even more complex data structures.

## 05a. Naturals
Being able to nimbly work with numbers is an essential skill for a developer. This section exposes some basic techniques and perhaps not immediately aspects of handling and manipulating numbers.

The file "pseudo-naturals.rkt" shows an interesting experiment where a custom set of Natural numbers (more precisely an equivalent representation) is used as a base for a set of dedicated methods.

## 05b. Helpers
Helpers are generic, simple functions designed with the purpose to support and enhance other more specific functions. Helpers are key for abstraction.

A good helper function takes care of one operation. More complex functions may use one or more helpers in order to perform more sophisticated operations, and to keep code easily maintainable and readable.

In Systematic Program Design, the use of helpers is defined as Function Composition. Function Composition is applied when a function has to perform two or more distinct and complete operations on the consumed data.

## 06a. Binary Search Trees
Binary Search Trees are a fundamental block in Computer Science. Even if we might not often have to directly handle data at low level, understanding how they are structured and how to work with them is greatly beneficial. Similar techniques can be applied to other fields.

## 06b. Final Problem - Space Invaders
Space Invaders is a simple game where the player defends against never ending waves of Space Villains coming from the sky. Arrows keys flip the direction towards which the player is sliding, on the bottom of the screen. Space Bar fires powerful energy beams that can destroy several foes at once. Game Over is if any of the Space Villains manages to reach the ground.

Despite the simplicity of the game and its graphical aspect, the code itself has been quite a challenge. Especially the aspects related to managing movements of all elements in play, and collisions against the edge of the screen and agains each other. Events that consequently require a change of the State.

## 07. Mutual Reference
Mutually recursive data is characterized by programs having two, or more, cycles. An example of Mutual recursive data is arbitrary sized data in two or more dimensions, which requires two or more cycles in the type reference graph.

R    - Reference
SR   - Self Reference
MR   - Mutual Reference
NR   - Natural Recursion
NMR  - Natural Mutual Recursion

## 08a. Two One-of Types
Functions that can operate on two arguments which are one-of types. Requires a peculiar model, the cross product of the types comment table.

The cross product of the types comment table provides with a way to clearly identify all possible test cases, which leads to identify all possible base cases.

Types comment tables support and extend function templates. Those tables are essential for generating the templates.

Type comments predict the templates, they are a model of the functions operating on the type. They are a representation of the program that tells us something about what the function will look like.

## 08b. Local
Most popular programming languages allow the definition of functions within other functions, constants and variables. In BSL/ISL/ASL, locals make possible to define constants, functions, and structures that are available only within the local expression. This allows the encapsulation of "private" helper functions.

An important use of locals is avoiding redundant calculations.

An other important use of locals is when two or more functions work in synergy (Mutual Recursion and alike). Those mutual recursive functions can be contained within a master function, so that to be visible exclusively within it.

Helper functions are another candidate for encapsulation. However, helpers may be used by several functions, and if so they have to be available for them as well, which means that in this specific case encapsulation may not be the appropriate solution.

--------

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
