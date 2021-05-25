:- use_module(library(clpfd)). % Only integers - finite domains. 
% The world where # lives is only of integers.
% :- use_module(library(clpr)). % Real numbers. 
% :- use_module(library(clpq)). % Rational numbers with arbitrary precision.

% #= #<= #>= #> #< 
len([], 0).
len([_|T], N):- len(T, M), N is M+1.

len2([], 0).
len2([_|T], N):- N #= M+1, len2(T, M).

% ?- len2([a,as,asa,a], N).
% N = 4.

% ?- len2([a,as,asa,a], 3+1).
% true.

% ?- len2([], 3-3).
% false.

len3([], N):- N #= 0.
len3([_|T], N):- N #= M+1, len3(T, M).

% ?- len3([], 3-3).
% true.

% ?- len3(L, 5).
% L = [_660, _826, _992, _1158, _1324] ;
% ^CAction (h for help) ? abort
% % Execution Aborted

len4([], N):- N #= 0.
len4([_|T], N):- N #> 0, N #= M+1, len4(T, M).


len5([], N):- N #= 0.
len5([_|T], N):- N #> 0, len5(T, N-1).

evenLen([]).
evenLen([_, _|L]):-evenLen(L).

evenLen2(L):-len5(L, 2*_).

between(A, B, A):- A =< B.
between(A, B, C):- A < B, A1 is A + 1, between(A1, B, C).

between2(A, B, A):- A #=< B.
between2(A, B, C):- A #< B, A1 #= A + 1, between2(A1, B, C).

between3(A, B, C):- A #=< B, C #= A.
between3(A, B, C):- A #< B, between3(A+1, B, C).

between4(A, B, C):- C in A..B, label([C]).

between5(A, B, C):- C#=<B, C#>=A, label([C]).

range(A, B, []):- A #> B.
range(A, B, [A|R]):- A #=< B, A1 #= A + 1, range(A1, B, R).

range2(A, B, L):- len5(L, B-A+1), all_distinct(L), chain(L, #<), L ins A..B, label(L). 

nthElement([H|_], 0, H).
nthElement([_|T], N, X):- nthElement(T, M, X), N is M + 1.

nthElement2([H|_], N, H):- N #= 0.
nthElement2([_|T], N, X):- N #> 0, nthElement2(T, N-1, X).

remove(X, L, R):- append(A, [X|B], L), append(A, B, R).

perm([], []).
perm(L, [H|R]):- remove(H, L, Q), perm(Q, R).

perm2(L, P):-len5(L, N), len5(I, N), N1 #= N - 1, I ins 0..N1, all_distinct(I), maplist(nthElement2(L), I, P). 

fact(0, 1).
fact(N, F):- N > 0, N1 is N - 1, fact(N1, F1), F is N * F1.

fact2(N, F):- N #= 0, F #= 1.
fact2(N, F):- N #> 0, F #= F1 * N, fact2(N - 1, F1).

graph([[a, b, c, d], [[a, b], [b, c], [c, d], [c, a]]]).

edge([_, E], X, Y):- member([X, Y], E); member([Y, X], E). 

:- table path(+, +, +, -).
path(_, Y, Y, [Y]).
path(G, X, Y, [X|P]):- edge(G, X, Z), path(G, Z, Y, P).

:- table fib2(+, -).
% fib2(N ,X)
fib2(N, 0):-N #=0.
fib2(N, 1):-N #= 1.
fib2(N, Z):- N #> 1, Z #= X+Y, fib2(N - 1, X), fib2(N - 2, Y).

fib3(X):-n(N), fib2(N, X).


n(X):-between(0, inf, X).

fib(0, 1).
fib(Y, Z):- fib(X, Y), Z is X + Y.
fib(X):- fib(X, _).

range3(A, B, R):-bagof(X, between(A, B, X), R).


% I.1 Редиците на Фарей, Fn , са редици от двойки естествени числа, които
% се дефинират рекурсивно за n ≥ 1 по следния начин:
% • F1 = [[0, 1], [1, 1]];
% • Fn+1 се получава от Fn , като между всеки два последователни члена
% [a, b] и [c, d] на Fn, за които b+d = n+1, се добавя двойката [a+c, n+1].
% Да се дефинира на пролог едноместен предикат farey(F), който при пре-
% удовлетворяване генерира в F всички редици на Фарей. 

farey(L):- generateFarey(L, _).

generateFarey([[0, 1], [1, 1]], 1).
generateFarey(FNplus1, Nplus1):- Nplus1 #= N + 1, generateFarey(FN, N), addPairs(FN, Nplus1, FNplus1).

addPairs([X], _, [X]).
addPairs([[A, B], [C, D]|Tail], Nplus1, [[A, B], [AplusC, Nplus1]|R]):- 
        B + D #= Nplus1, AplusC #= A + C, 
        addPairs([[C, D]|Tail], Nplus1, R).
addPairs([[A, B], [C, D]|Tail], Nplus1, [[A, B]|R]):- 
        B + D #\= Nplus1, 
        addPairs([[C, D]|Tail], Nplus1, R).

