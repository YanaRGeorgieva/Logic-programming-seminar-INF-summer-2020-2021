
reverse([], []).
% reverse([X], [X]).
reverse([H|T], R):- reverse(T, R1), append(R1, [H], R). 

% reverse1(List, Stack, Result).
% [H|T] S -> T [H|S]
reverse1(L, R):- reverse1(L, [], R).
reverse1([], Stack, Stack).
reverse1([H|T], Stack, Result):- reverse1(T, [H|Stack], Result).

palindrome1(L):- reverse(L, L).
% palindrome(L).
palindrome([]).
palindrome([_]).
palindrome(L):- append([H|Middle], [H], L), palindrome(Middle).

pSort(L, R):- permutation(L, R), isSorted(R).

isSorted(L):- not(( append(_, [X, Y|_], L), not(X =< Y))).

% minimal Ax(x=<m -> m=x)
% least Ax(m =< x).
lessOrEqual(A, B):- A =< B.

min2(A, B, A):- lessOrEqual(A, B).
min2(A, B, B):- not(lessOrEqual(A, B)). 

minElementInList([X], X).
minElementInList([H|T], Min):- minElementInList(T, TMin), min2(H, TMin, Min).

/* not very effective - double calculation of minElementInList(T, TMin) -> quadratic time complexity :(
minElementInList([X], X).
minElementInList([H|T], H):- minElementInList(T, TMin), lessOrEqual(H, TMin).
minElementInList([H|T], TMin):- minElementInList(T, TMin), not(lessOrEqual(H, TMin)).
*/
minElementInList(L, Min):- member(Min, L), not(( member(X, L), not(lessOrEqual(Min, X)) )).

remove(X, [X|L], L).
remove(X, [H|L], [H| M]):-remove(X, L, M).

selectionSort([], []).
selectionSort(L, [M|S]):-minElementInList(L, M), remove(M, L, N), selectionSort(N, S).

% A <=X < B
% split(X, L, A, B)
split(_, [], [], []).
split(X, [H|T], [H|A], B):-lessOrEqual(H, X), split(X, T, A, B).
split(X, [H|T], A, [H|B]):-not(lessOrEqual(H, X)), split(X, T, A, B).

quickSort([], []).
quickSort([X|L], S):-split(X, L, A, B), quickSort(A, SA), quickSort(B, SB), append(SA,[X|SB], S).

% split2(L, A, B).
split2([], [], []).
split2([X], [X], []).
split2([X, Y|T], [X|A], [Y|B]):-split2(T, A, B).

% merge(A, B, S)
merge([], S, S).
merge(S, [], S).
merge([X|A], [Y|B], [X|S]):-lessOrEqual(X, Y), merge(A, [Y|B], S).
merge([X|A], [Y|B], [Y|S]):-not(lessOrEqual(X,Y)), merge([X|A], B, S).

mergeSort([], []).
mergeSort([X], [X]).
mergeSort(L, S):-L\=[], L\=[_], split2(L, A, B), mergeSort(A, SA), mergeSort(B, SB), merge(SA, SB, S).

% add(X, Tree, NTree).
% makeTree(List, Tree).
% leftRootRight(Tree, SortedList).
% treeSort(L, SortedL).

% tree(LT, R, RT)
% empty

% []
% [LT, R, RT]

makeTree([], empty).
makeTree([H|L], Tree):-makeTree(L, Tree1), add(H, Tree1, Tree).

add(X, empty, tree(empty, X, empty)).
add(X, tree(LT, R, RT), tree(LT1, R, RT)):-lessOrEqual(X, R), add(X, LT, LT1).
add(X, tree(LT, R, RT), tree(LT, R, RT1)):-not(lessOrEqual(X, R)), add(X, RT, RT1).

leftRootRight(empty, []).
leftRootRight(tree(LT, R, RT), L):-leftRootRight(LT, LL), leftRootRight(RT, RL), append(LL, [R|RL], L).

treeSort(L, S):-makeTree(L, T), leftRootRight(T, S).

% d(L, D).
% [1, 2, 3] x [a, b]
% [a, b]
% %
% [1, a]
% [1, b]
% [2, a]
% ...

d([], []).
d([H|T], [A|R]):- member(A, H), d(T, R).