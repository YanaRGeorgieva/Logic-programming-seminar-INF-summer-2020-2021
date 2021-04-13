/*
Some links:
    https://www.swi-prolog.org/
    http://www.learnprolognow.org/lpnpage.php?pageid=top
    https://www.ic.unicamp.br/~meidanis/courses/mc336/2009s2/prolog/problemas/
    http://cs.union.edu/~striegnk/courses/esslli04prolog/index.php
    http://kti.ms.mff.cuni.cz/~bartak/prolog.old/learning.html
*/
/* Променливи: Maria, X, Y, This_lalalalalallala, _ 
Константи: атоми и числа:
атом: 'нещо такова', this_atom, a, +-*>; спец: [], {}, ;, !
числа: integer, floating point
Съставни термове: foo(h(0),baz(0)), foo(a)
Списъци (специални термове): [], (X-element, Y-list -> [X|Y])
Съждителни връзки: (, -> LogicAnd); (; -> LogicOr); (not(unary) -> LogicNot).
Предикати: започват с малки букви p(x, y), lessEq(X, Y).
*Всички клаузи завършват на точка!!!!!!!
S |= f 
 X=f(maria)
3 вида клаузи(хорнови): 
- факти: p(x, y). // <x, y> \in p; p(X,Y).
- правила: p(   ):-p1(), p2(), ..., pn(). //p1 , p2 ,... pn -> p
- цели: ?-p1(), p2(), ...,pn(). */


parent(maria, ivan).
parent(ivan, peter).
parent(ivan, stoyan).

grandparent(X, Y):- parent(X, Z), parent(Z, Y).

sibling(X, Y):- parent(Z, X), parent(Z, Y), X \= Y.

% X Z1--------Zn Y
% ancestor(X, X):-parent(X, _); not(parent(_, X)).
% ancestor(X, X):-parent(_, X); not(parent(_, X)).
% ancestor(X, X):-not(parent(_, X)); parent(X, _).
ancestor(X, Y):-parent(X, Y).
ancestor(X, Y):-parent(X, Z), ancestor(Z, Y).

% d(X, DX). x 2*x*x + x
d(x, 1).
d(X, 0):-number(X).
d(X+Y, DX+DY):-d(X, DX), d(Y, DY).
d(X*Y, DX*Y+X*DY):-d(X, DX), d(Y, DY).
d(sin(X), cos(X)*DX):-d(X, DX).

empty(c).
add(X, C, f(X, C)).
member(X, f(X,_)).
member(X, f(_,Tail)):- member(X, Tail).
/* f(X, Y, Z), c f(1,f(2,f(3,c))) -> [1,2,3]
?-empty(C), add(1, C, N), member(1, N). 
?-empty(C), add(1, C, N), add(2, N, NN), add(2,NN, NNN), member(2, NNN).
member(2, f(2, f(2, f(1, c)))).*/
/* []
[X|T] */
isList([]).
isList([_|_]).
/* [1,2,3,4] -> [X|T] -> [1|[2|[3|[4|[]]]]], 
[X,Y|_] */
first(X, [X|_]).
% second(X, [_, X|_]).
second(X, [_|T]):- first(X, T). 

last(X, [X]).
last(X, [_|T]):- last(X, T).

member1(X, [X|_]).
member1(X, [_|T]):- member1(X, T).

% [[[[[]]]], 3, 1,8, []]
% append(A, B, L) A=[1,2], B=[a,b]-> L=[1,2,a,b].
% A=[X|A1] B C=[X|A1.B]

append1([], B, B).
append1([X|A], B, [X|C]):-append1(A, B, C).

firstAppendVersion(X, L):-append1([X], _, L).
% secondAppendVersion(X, L):-append1([_, X], _, L).
secondAppendVersion(X, L):-append1([_], [X|_], L).
lastAppendVersion(X, L):-append1(_, [X], L).

memberAppendVersion(X, L):-append1(_, [X|_], L).

% insert(X, L, R) -> X=1, L=[a,b] -> [1,a,b]; [a,1,b]; [a,b,1]

insert(X, L, R):- append(A, B, L), append(A, [X], C), append(C, B, R).

% remove(X, L, R) -> X=a, L=[a,b,a] -> [b,a]; [a,b]