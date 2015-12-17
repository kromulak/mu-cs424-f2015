Finished with Haskell lectures, moving on to Prolog.

Assignment due on Thursday 16th - [Learn you Haskell for great good](http://learnyouahaskell.com/chapters) should prove useful. 
Also [learnXinYminutes.com](https://learnxinyminutes.com/docs/haskell/) for a quick view.

#Prolog#
File type: *.pl
.pl is also associated with perl files so you need to switch emacs to [Prolog mode](http://www.emacswiki.org/emacs/PrologMode) 
`M-x prolog-mode`

 - Uppercase reserved for variables, eg X
 - lowercase for constants, eg aristotle
 - Relations instead of functions, eg `father(X,Y).` means father is a relation between X and Y
 - Make sure to end statements with a full stop, eg `mortal(X) :- dog(X).`
 - Uses % for comments
 - Be careful with order of axioms as can cause inf loops/crashes etc when interpreter tries to prove something
 - Think of variables as logic variables and not as storage locations in memory like in other languages

###Background###
Back in the 50s you had languages like Snowball (that was based on Strings). People would change the syntax slightly and call it a new language. As a result  there were lots of very similar languages. In the 70s there was attempts at new ways of looking at programming languages. One such result was Prolog.

Axioms
It generally hard to tell if a program is right but its easy to agree on axioms. The idea of Prolog is write sets of logical axioms. If all axioms are true then the program must be true. 
Caution: The order of axioms affects termination so your program may never end.

###Coding:###

    %%% Prolog = PROgramming in LOGic
    
    %%% CLASSICAL LOGIC
    
    %%% for all X, if man(X) then mortal(X).
    
    %%% The below lines are axioms in our database.
    
    %%% free variable X is implicitly "forall X":
    mortal(X) :- man(X). %notice its backwards
    
    %%% free variable X is implicitly "forall X":
    mortal(X) :- dog(X).
    
    %%% free variable X is implicitly "forall X":
    mortal(X) :- usedToBeAlive(X), dead(X).
Notice the above axioms are *if then* axioms.
You can also have just *then* axioms.
Using *then* axioms we can create a little Prolog database (aka facts)

    man(aristotle).
    dead(aristotle).
    usedToBeAlive(aristotle).

From the terminal you can use [GNU-Prolog](http://www.gprolog.org/) using the command `gprolog` or you can use [swi](http://www.swi-prolog.org/). 
(We are using GNU-Prolog in lectures)

You can load a Prolog file using

>['Lecture-22.pl']

When you make queries it tries to prove the conjecture and replys true
>mortal(aristotle)
>>true

FYI
 - Press semicolon to show (if any) more proofs
 - Press carriage return if you are done asking for proofs.

Prolog uses a specific way of proving called "Constructive Proof"

    mortal(X) :- usedToBeAlive(X), dead(X).
Note the explicit free variable x means *for all* x but with queries free variables are explicit *there exists* an x.
So a query like mortal(x) is asking it to prove if there is a x that is mortal. If there is it returns the value(s) for x that makes it true.
Trying the query `mortal(naal)` will result in an uncaught exception error(existence error) because Prolog couldnt prove it.

Add more to our Prolog file.

    dog(spot).
    dog(naal).
    
    %%% Ancestry Database
    
    female(ziva).
    female(soca).
    parent(barak,ziva).
    parent(barak,soca).
    parent(fishel,barak).
    parent(frances,barak).
    female(frances).
    male(barak).
    male(fishel).
    
    %% Prolog starts pattern matching from the left.
    %% It's more efficient to start with a predicate with fewer solutions after :- (the "if" operator)
    father(X, Y) :- parent(X, Y), male(X).
    mother(X, Y) :- parent(X, Y), female(X).
    grandfather(X, Z) :- father(X, Y), parent(Y, Z).

Note above if we had used `father(X, Y) :- male(X), parent(X, Y)` the system would have had to first prove the male part by going through all males and then check the parent part.

####Peano Arithmatic####

Named after a guy called Peano who came up with [axioms](http://mathworld.wolfram.com/PeanosAxioms.html) in an attempt to embed arithmetic in logic

####Back to code####

    %%% Peano Arithmetic - an attempt to embed arithmetic in logic
    
    %% z                            = zero
    %% s(s(s(z)))                   = three
    
    add(z,X,X).
    add(s(X),Y,s(Z)) :- add(X,Y,Z).
    
    %% | ?- add(X, s(s(Y)), s(s(s(s(s(z)))))).
    %%
    %% X = z
    %% Y = s(s(s(z))) ? ;
    %%
    %% X = s(z)
    %% Y = s(s(z)) ? ;
    %%
    %% X = s(s(z))
    %% Y = s(z) ? ;
    %%
    %% X = s(s(s(z)))
    %% Y = z ? ;
    %%
    %% no
    
    mul(z, _, z).
    mul(s(X), Y, Z) :- mul(X, Y, W), add(Y, W, Z).

We can make queries like 'find all values of X and Y such that X + (2+Y) = 5'
> add(X, s(s(Y)), s(s(s(s(s(z)))))).


###Lists###
append and member are already defined in Prolog so we use app and mem for our implementation

    %% .(1,.(2,.(3,[])))      %% three-element list in Prolog
    %% [1,2,3]                %% syntactic sugar for above
    %% [X|Ys]                 %% sugar for   .(X,Ys)
    %% [X,Y,Z|Ws]             %% sugar for .(X,.(Y,.(Z,Ws)))
    
    app([],Zs,Zs).
    app([X|Xs],Ys,[X|Zs]) :- app(Xs,Ys,Zs).
    
    mem1(X,[X|_]).
    mem1(X,[_,Ys]) :- mem1(X,Ys).
    
    mem2(X, Ys) :- append(_, [X|_], Ys).
    
    equals(X,X).
    
    %% | ?- equals(X,[the,quick,brown]).
    %%
    %% X = [the,quick,brown]
    %%
    %% yes
    %% | ?- equals([X,foo,bar],[the,Y,brown]).
    %%
    %% no
    %% | ?- equals([X,foo,B],[the,Y,brown]).
    %%
    %% B = brown
    %% X = the
    %% Y = foo
    %%
    %% yes

Very useful with lists, can make queries like what appended to A gives B etc.


###Full Lecture-22.pl

    %%% Prolog = PROgramming in LOGic
    
    %%% CLASSICAL LOGIC
    
    %%% for all X, if man(X) then mortal(X).
    
    %%% The below lines are axioms in our database.
    
    %%% free variable X is implicitly "forall X":
    mortal(X) :- man(X). %notice its backwards
    
    %%% free variable X is implicitly "forall X":
    mortal(X) :- dog(X).
    
    %%% free variable X is implicitly "forall X":
    mortal(X) :- usedToBeAlive(X), dead(X).
    
    
    man(aristotle).
    dead(aristotle).
    usedToBeAlive(aristotle).
    
    dog(spot).
    dog(naal).
    
    %%% Ancestry Database
    
    female(ziva).
    female(soca).
    parent(barak,ziva).
    parent(barak,soca).
    parent(fishel,barak).
    parent(frances,barak).
    female(frances).
    male(barak).
    male(fishel).
    
    %% Prolog starts pattern matching from the left.
    %% It's more efficient to start with a predicate with fewer solutions after :- (the "if" operator)
    father(X, Y) :- parent(X, Y), male(X).
    mother(X, Y) :- parent(X, Y), female(X).
    grandfather(X, Z) :- father(X, Y), parent(Y, Z).
    
    %%% Peano Arithmetic - an attempt to embed arithmetic in logic
    
    %% z                            = zero
    %% s(s(s(z)))                   = three
    
    add(z,X,X).
    add(s(X),Y,s(Z)) :- add(X,Y,Z).
    
    %% | ?- add(X, s(s(Y)), s(s(s(s(s(z)))))).
    %%
    %% X = z
    %% Y = s(s(s(z))) ? ;
    %%
    %% X = s(z)
    %% Y = s(s(z)) ? ;
    %%
    %% X = s(s(z))
    %% Y = s(z) ? ;
    %%
    %% X = s(s(s(z)))
    %% Y = z ? ;
    %%
    %% no
    
    mul(z, _, z).
    mul(s(X), Y, Z) :- mul(X, Y, W), add(Y, W, Z).
    
    %% .(1,.(2,.(3,[])))      %% three-element list in Prolog
    %% [1,2,3]                %% syntactic sugar for above
    %% [X|Ys]                 %% sugar for   .(X,Ys)
    %% [X,Y,Z|Ws]             %% sugar for .(X,.(Y,.(Z,Ws)))
    
    app([],Zs,Zs).
    app([X|Xs],Ys,[X|Zs]) :- app(Xs,Ys,Zs).
    
    mem1(X,[X|_]).
    mem1(X,[_,Ys]) :- mem1(X,Ys).
    
    mem2(X, Ys) :- append(_, [X|_], Ys).
    
    equals(X,X).
    
    %% | ?- equals(X,[the,quick,brown]).
    %%
    %% X = [the,quick,brown]
    %%
    %% yes
    %% | ?- equals([X,foo,bar],[the,Y,brown]).
    %%
    %% no
    %% | ?- equals([X,foo,B],[the,Y,brown]).
    %%
    %% B = brown
    %% X = the
    %% Y = foo
    %%
    %% yes
