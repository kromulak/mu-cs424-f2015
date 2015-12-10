%%% Prolog = PROgramming in LOGic

%%% CLASSICAL LOGIC

%%% for all X, if man(X) then mortal(X). The below lines are axioms in our database.

%%% free variable X is implicitly "forall X":
mortal(X) :- man(X).

%%% free variable X is implicitly "forall X":
mortal(X) :- dog(X).

%%% free variable X is implicitly "forall X":
mortal(X) :- usedToBeAlive(X), dead(X).

max(aristotle).
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

father(X, Y) :- parent(X, Y), male(X). % Prolog starts pattern matching from the left. It's more efficient to start with a first-order predicate after :- (the if operator)
mother(X, Y) :- parent(X, Y), female(X).
grandfather(X, Z) :- father(X, Y), parent(Y, Z).
grandmother(X, Z) :- mother(X, Y), parent(Y, Z).

%%% Peano Arithmetic - an attempt to embed arithmetic in logic

%% z							= zero
%% s(s(s(z)))					= three

add(z,X,X).
add(s(X),Y,s(Z)) :- add(X,Y,Z).

%% | ?- add(X, s(s(Y)), s(s(s(s(s(z))))).
%
%% X = z
%% Y = s(s(s(z))) ? ;
%
%% X = s(z)
%% Y = (s(s(z) ? ;
%
%% X = s*s*z))
%% Y = s(z) ? ;
%
%% X = s(s(s(z)))
%% Y = z ? ;
%
%% no

mul(z, _, z).
mul(s(X), Y, Z) :- mul(X, Y, W), add(Y, W, Z).

%% .(1,.(2,.(3,[]))) 		%% a three element list in Prolog
%% [1,2,3] 					%% syntactic sugar for above
%% [X,Ys]					%% sugar for	.(X,Ys)
%% [X,Y,Z|Ws]				%% sugar for	.(X,.(Y,.(Z,Ws)))

app([],Zs,Zs).
app([X|Xs],Ys,[X|Zs]) :- app(Xs,Ys,Zs).

mem1(X,[X|_]).
mem1(X,[_,Ys]) :- mem1(X,Ys).

mem2(X, Ys) :- append(_, [X|_], Ys).

equals(X,X).