%% -*- prolog -*-

%%% Type inference for System F (λ Calc w/ "forall" types)

%% Representations.
%% Expression (aka λCalc Term):

%% Expr ::= LambdaExpr | Application | Variable | BasisObject
%% LambdaExpr ::= λ Variable : Type . Expr
%% Application ::= Expr Expr
%% Variable ::= x1 | x2 | x3 | ...
%% BasisObject ::= b1 | b2 | b3 | ...

%% REPRESENT: LambdaExpr, λ Variable : Type . Expr
%% AS: lambda(Variable,Type,Expr)

%% REPRESENT: Application, Expr Expr
%% AS: app(Expr,Expr)

%% REPRESENT: Variable, x1 | ...
%% AS: var(x1), except in formal parameter of λ expr, where just: x1

%% REPRESENT: BasisObject, b1
%% AS: basis(b1)

%% Example: (λ f : _ . (λ g : _ . (λ x : _ . f (g x))))
%% As: lambda(f,_,lambda(g,_,lambda(x,_,app(var(f),app(var(g),var(x))))))
%% (this is the "compose" combinator.)

%% Type:

%% Type ::= Type → Type | BasisType
%% BasisType ::= t1 | t2 | ...

%% REPRESENT: Type → Type
%% AS: arr(Type,Type)

%% REPRESENT: BasisType, t2
%% AS: t2

%% Type Environment:
%%  [[v1,t1],[v2,t2],...]

%% Use logic variables Exx for terms and Txx for types.
%% Use G for type environment (G for Γ)

%% check if a term is well typed
wellTyped(E) :- hasType(E, _T, []).

%% hasType(E, T, G) means expression E has type T in type env G.
%% Previously written ...     G ⊫ E : T

hasType(lambda(V,Tv,E), arr(Tv,Te), G) :- hasType(E, Te, [[V,Tv]|G]).
hasType(app(E1,E2), T2, G) :-
	hasType(E1, arr(T1,T2), G),
	hasType(E2, T1, G).
hasType(var(V1), T, G) :- firstMember([V1,T],G).
hasType(basis(true), bool, _G).
hasType(basis(false), bool, _G).
hasType(basis(0), real, _G).
hasType(basis(1), real, _G).
hasType(basis(2), real, _G).
hasType(basis(not), arr(bool,bool), _G).
hasType(basis(plus), arr(real,arr(real,real)), _G).
hasType(basis(zerop), arr(real,bool), _G).
hasType(basis(if), arr(bool,arr(T,app(T,T))), _G).

%%% EXAMPLE RUN
%%% 
%%% | ?- wellTyped(app(basis(plus),basis(1))).
%%% 
%%% true ? 
%%% 
%%% yes
%%% | ?- hasType(app(basis(plus),basis(1)), T, []).
%%% 
%%% T = arr(real,real) ? 
%%% 
%%% yes
%%% | ?- hasType(basis(if), T, []).                
%%% 
%%% T = arr(bool,arr(A,app(A,A)))
%%% 
%%% yes
%%% | ?- hasType(app(basis(if),basis(true)), T, []).
%%% 
%%% T = arr(A,app(A,A)) ? 
%%% 
%%% yes
%%% | ?- hasType(app(app(basis(if),basis(true)),basis(1)), T, []).
%%% 
%%% T = app(real,real) ? 
%%% 
%%% yes
%%% | ?- hasType(lambda(f,_,lambda(g,_,lambda(x,_,app(var(f),app(var(g),var(x)))))),T,[]).
%%% 
%%% T = arr(arr(A,B),arr(arr(C,A),arr(C,B))) ? 
%%% 
%%% yes

%%% CUT, written: !
%%% cuts off search for alternative ways of satisfying current goal.

not(E) :- E, !, fail.
not(_).

firstMember(X,Ys) :- member(X,Ys), !.