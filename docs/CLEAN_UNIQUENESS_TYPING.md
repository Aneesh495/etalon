# Uniqueness Typing in Concurrent Clean

Concurrent Clean is a pure, lazy, functional language with a formal Uniqueness Type System. Uniqueness typing solves the fundamental challenge of functional I/O and high-performance mutable state: achieving destructive in-place updates with zero copying overhead while preserving referential transparency.

## 1. Core Principles

In standard pure functional programming, modifying an array or graph requires allocating a new copy to preserve referential transparency:

```
// Naive functional update: O(N) allocation and copying
updateArray :: (Array Int) Int Int -> Array Int
```

Clean introduces uniqueness attributes denoted by an asterisk prefix (`*`):

```clean
updateUniqueArray :: !*(Array Int) !Int !Int -> *(Array Int)
```

The uniqueness attribute `*` asserts that the object has a reference count of exactly one at runtime. The compiler verifies this property statically during type checking. Because no other pointer can reference the object, the compiler generates machine instructions that mutate the memory block directly in place:
- Memory Allocation: Zero bytes allocated.
- Copy Overhead: Zero memory copies.
- Referential Transparency: Preserved, because the pre-mutation value cannot be observed by any other expression.

## 2. Invariant Rules of the Clean Uniqueness Checker

The Clean uniqueness checker enforces three invariant rules:

### Rule 1: Single Use of Unique Variables
A variable $x$ typed with uniqueness attribute `*T` cannot appear more than once in an expression tree:

```clean
// ILLEGAL: Duplicate reference to unique variable 'g'
illegalUpdate :: *OpticalGraph -> (*OpticalGraph, *OpticalGraph)
illegalUpdate g = (g, g) // Compile-time uniqueness violation!
```

Instead, the updated value must be threaded in linear order:

```clean
// LEGAL: Single threaded sequence
legalUpdate :: *OpticalGraph -> *OpticalGraph
legalUpdate g0 =
    let g1 = addNode g0 nodeA
        g2 = addLink g1 linkAB
    in g2
```

### Rule 2: Uniqueness Propagation Through Data Structures
If a data structure contains an object marked with uniqueness attribute `*`, the container itself must be unique:

```clean
:: *NetworkState =
    { topology       :: !*OpticalGraph
    , activeServices :: ![Int]
    }
```

This prevents aliasing the container to indirectly duplicate references to the underlying unique object.

### Rule 3: Branch Exclusivity
When evaluating conditional branching constructs (`if ... then ... else`, pattern matching guards, or `case ... of`), a unique variable may be passed to multiple branches provided that exactly one branch executes at runtime:

```clean
processFault :: *OpticalGraph !Bool -> *OpticalGraph
processFault g isFiberCut
    | isFiberCut = triggerFastReroute g
    | otherwise  = g // Valid: mutually exclusive branches
```

## 3. Comparison with Other Systems

| Property | Concurrent Clean | Rust | Haskell |
| :--- | :--- | :--- | :--- |
| Core Abstraction | Uniqueness Types (`*T`) | Affine Types & Borrow Checker (`&mut T`) | Monads (`ST s a`, `IO a`) |
| In-Place Mutation | Yes (compile-time proven) | Yes (exclusive mutable reference) | Yes (encapsulated in monad) |
| Referential Transparency | Pure equational reasoning | Imperative statement sequence | Monadic sequence (`do` notation) |
| Lazy Evaluation | Fully lazy by default | Strict evaluation | Fully lazy by default |
| Aliasing Guarantees | Static reference count = 1 | Strict aliasing XOR mutability | Runtime heap isolation |

In Etalon, the entire optical topology graph (`*OpticalGraph`), multi-wavelength spectrum matrix (`*SpectrumGrid`), and OTN frame structures (`*OtnFrame`) are authored using uniqueness types. This provides bare-metal C performance inside a pure mathematical functional paradigm.
