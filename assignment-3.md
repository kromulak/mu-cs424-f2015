MU CS424, Fall 2015
-------------------
Assignment 3: Prolog
=====================

The goal of this assignment is to do a bit of programming in Prolog.

1.  Define a relation ```interleave/3``` which is true when, given
    three lists, the third contains the elements of the first two,
    interleaved.

	Example:

	```
	| ?- interleave(Xs, Ys, [a,b,c,d,e,f]).

	Xs = [a,c,e]
	Ys = [b,d,f] ? ;

	no
	| ?- interleave([a,b,c,d,e,f],Ys,Zs).  

	Ys = [A,B,C,D,E]
	Zs = [a,A,b,B,c,C,d,D,e,E,f] ? ;

	Ys = [A,B,C,D,E,F]
	Zs = [a,A,b,B,c,C,d,D,e,E,f,F]

	yes
	```

2.  Using family tree fact of the sort discussed in class
    (```parent/2```, ```male/1```, ```female/1```) Define a relation
    ```cousin/2``` which is true which its two arguments are first
    cousins, i.e., when they share a grandparent.  In a comment,
    discuss under which circumstances your relation would claim that
    siblings are cousins, or that a person is their own cousin, and
    how you might avoid this behaviour.

What to turn in
---------------

* a *single* file
* without anything unusual (like spaces or unicode) in the filename
* with extension .pl
* that loads and runs in gprolog so I can test it

* **DUE** noon, Thur 24-Dec-2015
