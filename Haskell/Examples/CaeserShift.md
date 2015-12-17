### Problem Statement

In cryptography, a [Caesar
cipher](https://en.wikipedia.org/wiki/Caesar_cipher), also known as Caesar's
cipher, the shift cipher, Caesar's code or Caesar shift, is one of the simplest
and most widely known encryption techniques. It is a type of substitution
cipher in which each letter in the plaintext is replaced by a letter some fixed
number of positions down the alphabet. For example, with a left shift of 3, D
would be replaced by A, E would become B, and so on. The method is named after
Julius Caesar, who used it in his private correspondence. A left shift is when
we shift by a negative number.

You are given a string **S** and the number **N**. Encrypt the string and print
the encrypted string. For example, given the string **S** = _"Hello, World!"_
and **N** = 5, the encoded string would be _"Mjqqt, Btwqi!"_.

**Note:** Both upper and lower case letters get shifted separately. If a letter
was uppercase before it was encoded, it will be encoded as a capital letter.

**Hint:** Take a look at the
[Data.Char](https://hackage.haskell.org/package/base-4.8.1.0/docs/Data-Char.html)
package to convert between Characters and Ints. Also take a look at the
`isUpper` and `isLower` functions.

### Input Format

The first line contains an integer **N** which represents the shift and the
second line contains a String **S** to be encrypted.

### Constraints

-128 ≤ **N** ≤ 127
length **S** ≤ 1000

### Output Format

A single line containing the encoded string.

### Sample Input

```
5
Hello World!
```

### Sample Output
```
Mjqqt, Btwqi!
```
