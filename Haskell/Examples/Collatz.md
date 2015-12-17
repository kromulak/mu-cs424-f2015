### Problem Statement
Take any natural number **n**. If **n** is even, divide it by 2 to get **n/2**,
if **n** is odd multiply it by 3 and add 1 to obtain **3n+1**. Repeat the
process indefinitely. The conjecture is that no matter what number you start
with, you will always eventually reach 1.

<img alt="" src="https://s3.amazonaws.com/istreet-assets/0uUme3nVBEST_xEg4Dbaiw/Collatz.png" style="width: 389px; height: 55px;" />

Your task is to find the number that produces the longest _collatz_ sequence
below a given number **N**.

<img alt="The Strong Collatz Conjecture states that this holds for any set of obsessively-hand-applied rules." src="http://imgs.xkcd.com/comics/collatz_conjecture.png" style="width: 311px; height: 452px;" />

### Input Format
A single Integer **N** on a single line.

### Constraints
1 ≤ **N** ≤ 100000

### Output Format
A single integer on one line, representing the number that produces the longest
Collatz Sequence.

### Sample Input
#### Sample Input 1
```
10
```

#### Sample Input 2
```
100
```
### Sample Output
#### Sample Output 1
```
9
```

#### Sample Output 2
```
97
```
