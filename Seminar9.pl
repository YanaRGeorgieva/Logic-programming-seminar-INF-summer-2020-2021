% insert(X, L, R) -> X=1, L=[a,b] -> [1,a,b]; [a,1,b]; [a,b,1]

insert(X, L, R):- append(A, B, L), append(A, [X], C), append(C, B, R).
insert1(X, List, Result):- append(List1, List2, List), append(List1, [X|List2], Result).
% remove(X, L, R) -> X=a, L=[a,b,a] -> [b,a]; [a,b]

remove(X, List, Result):- append(List1, [X|List2], List), append(List1, List2, Result).

% remove1(X, List, Result)
remove1(X, [X|Tail], Tail).
remove1(X, [Head|Tail], [Head|NewTail]):- remove1(X, Tail, NewTail).

insert2(X, List, Result):- remove1(X, Result, List).

% [X|P] L
permutation(L,[X|P]):- remove(X, L, M), permutation(M, P).
permutation([], []).

permutation1([], []).
permutation1([H|T], Result):- permutation1(T, Q), insert1(H, Q, Result).

% < , =<, > >=
lessOrEqual(X, Y):- X =< Y.

% isSorted(L) (forall x \in L) (forall y \in L after x)  lessOrEqual(x, y)
isSorted([]).
isSorted([_]).
isSorted([X, Y|Tail]):-lessOrEqual(X, Y), isSorted([Y|Tail]).

isSorted1(L):- not(( append(_, [X, Y|_], L), not(lessOrEqual(X, Y)) )).

/* 
AxF-> \forall x F
ExF -> \exists x F
~F -> \neg F

AxF |=| ~Ex~F
|= AxF <-> ~Ex~F
*/

% X списък от числа, Y списък от списъци от числа
% p1(X, Y) <-> Има ел. на Х, който е в ел. на Y.
% p2(X, Y) <-> Има ел на Х, който е във всеки ел на Y.
% p3(X, Y) <-> Всеки ел на Х е в ел на Y.
% p4(X, Y) <-> Всеки ел на Х е във всеки ел на Y.

% p1 member(A, X), member(B, Y), member(A, B).
% EaEb member(a, b)
% EaAb member(a, b) |=| Ea~Eb~member(a, b)
% AaEb member(a, b) |=| ~Ea~Eb member(a, b)
% AaAb member(a, b) |=| ~Ea~~Eb~ member(a, b) |=| ~EaEb~member(a, b)

p1(X, Y):-member(A, X), member(B, Y), member(A, B).
p2(X, Y):-member(A, X), not((member(B, Y), not(member(A, B)))).
p3(X, Y):-not((member(A, X), not((member(B, Y), member(A, B))))).
p4(X, Y):-not((member(A, X), member(B, Y), not(member(A, B)))).

prefix(L, P):- append(P, _, L).
suffix(L, S):- append(_, S, L).

% [1, 2, a, s, d] -> [a,s,d] ->  [a, s]
infix(L, SubL):- suffix(Suff, L), prefix(SubL, Suff).
% [1, 2, a, s, d] -> [1,2,a,s] -> [a, s]
infix1(L, SubL):- prefix(Pref, L), suffix(SubL, Pref).

% A SubL B
% append(A, SubL, C), append(C, B, L)
% [a,b,c] -> [1,1,1]
% [a,c] -> [1,0,1] ->>> [X|T] -> ([X|Res] || Res)
subsequence([], []).
subsequence([_|T], Res):- subsequence(T, Res).
subsequence([H|T], [H|Res]):- subsequence(T, Res).

% (Ax \in L1)(x \in L2) |=| Ax (x \in L1 -> x \in L2).
isSubset(L1, L2):- not(( member(X, L1), not(member(X, L2)) )).

isSubset1([], _).
isSubset1([H|T], L):- member(H, L), isSubset1(T, L).

% m(L, M) Да се генерират в М всички списъци, чиито елементи са елементи на L.
% [a, b] [], [a], [a, a], [a, b, a, b, b, b]
m(_, []).
m(L, [H|T]):- member(H, L), m(L, T).
% [], [a], [a, a]
m1(_, []).
m1(L, [H|T]):- m1(L, T), member(H, L).

% reverse(L, R).