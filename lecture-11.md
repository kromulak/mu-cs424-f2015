# Lambda Calculus

[Alonzo Church](https://en.wikipedia.org/wiki/Alonzo_Church) -- 1940s

## Grammar of Lambda Calculus

E = term

* E ::= Variable | Application | Lambda-Expression
* Application ::= E E
* Lambda-Expression ::= λ Variable . E
* Variable ::= a | b | c | d | ...

(parentheses used for grouping)

## Examples of Lambda Calculus Terms

a

b

x

y

### These are the same:

x y

(x y)

(((x y)))

### These are the same: (i.e., application is "right associative")

x y z

(x y) z

((x y) z)

## Reductions

### β-reduction

(λ x . a x b) c ↝ a c b

(λ x . a x b) c d e ↝ a c b d e

(λ x . a x b) (c d) e ↝ a (c d) b e

(λ x . a x b) (c d e) ↝ a (c d e) b

(λ X . E1) E2 ↝ [X↦E2]E1

### Substitution

[X↦E2](E0 E1) = [X↦E2]E0 [X↦E2]E1

[X↦E2]X = E2

[X↦E2]Y = Y
  where:
    X and Y are different variables, i.e., X≠Y

[X↦E2](λ X . E1) = λ X . E1

[X↦E2](λ Y . E1) = λ Y . [X↦E2]E1
 where:
   X and Y are different variables, i.e., X≠Y
 and
   Y is not a free variable in E2, i.e., Y ∉ Free(E2)

[X↦E2](λ Y . E1) = λ Z . [X↦E2][Y↦Z]E2
 where Z ∉ Free(E2), i.e., α-rename Y to protect occurrences of Y in E2

### α-renaming

(λ X . E) ↝ (λ Y . [X↦Y]E)
 for any Y where Y ∉ Free(E) 

α-rename X to Y

### Free Variables

Free : Term → Set(Variable)

Free(E1 E2) = Free(E1) ∪ Free(E2)

Free(X) = {X}

Free(λ X . E) = Free(E) \ {X}

### syntactic sugar: these are the same

λ x . λ y . λ z . z (x y) (y x)

(λ x . (λ y . (λ z . z (x y) (y x))))

λ x y z . z (x y) (y x)

### examples

λ x . c    (returns a constant, i.e., a constant function)

λ c . λ x . c   (returns a constant function)

λ c x . c

    (λ x . a (λ y . x) b) y
     ↝ [x↦y](a (λ y . x) b)
	 = [x↦y](a (λ y . x)) [x↦y]b
	 = [x↦y]a [x↦y](λ y . x) [x↦y]b
	 = a [x↦y](λ y . x) b 
	 = a (λ y . [x↦y]x) b    WRONG!!!! y∈Free(y)={y}
	 = a (λ y . y) b         WRONG

# Remarkable Fact

The pure lambda calculus is Turing Complete!
