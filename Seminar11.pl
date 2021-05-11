% is, =:= =!=
% < > =< >= 
% + / - * ^ div mod ** // 

% X is 5
% 5 is 5
% X = []

% length(L, N).
len([], 0).
len([_|T], X) :- len(T, Y), X is Y+1.

% sum(L, SumL).
sum([], 0).
sum([H|T], X) :- sum(T, Y), X is Y+H.

% nthElement(X, IndX, L).
nthElement(X, 0, [X|_]).
nthElement(X, N, [H|T]):- nthElement(X, M, T), N is M+1. 

% 0, 1, 2, 3, 4, ...
% 0, 2, 4, ...
% 0, 1, -1, 2, -2....
% 0, 1, 1, 2, 3, 5, 8, 13, ...

% ?-f(X).
% 0, 1, -1, 2, -2....

natural(0).
natural(X):-natural(Y), X is Y+1.

even(X):- natural(X), X mod 2 =:= 0.

even1(0).
even1(X):- even1(Y), X is Y+2.
% even1(X):- even1(Y), X is Y-2.

even2(X):-natural(Y), X is Y*2.

% f(X):-natural(C), decode(C, X).
int(X):-natural(Y), decodeInt(Y, X).
decodeInt(Y, X):-Y mod 2 =:=0, X is -Y // 2.
decodeInt(Y, X):-Y mod 2 =:=1, X is (Y+1) // 2.

int2(X):-natural(Y), sign(Y, X).
sign(X, X).
sign(X, Y):-X> 0, Y is -X.

int3(0).
int3(X):-natural(Y), Y> 0, member(Z, [1 ,-1]), X is Y*Z.

% natural20(X):-natural(X), X < 21.
% between(A, B, X). X in [A, B]

% A A+1 . . ... B
between(A, B, A):-A =< B.
between(A, B, X):- A<B, A1 is A + 1, between(A1, B, X).

natural20(X):- between(0, 20, X).
% range(A, B, R)
range(A, B, []):- A > B.
range(A, B, [A|T]):- A1 is A+1, range(A1, B, T).

% pairNatural(X, Y)
% pairNatural(X, Y):-natural(X), natural(Y).
pairNatural(X, Y):- natural(Z), between(0, Z, X), Y is Z-X.

% genNS(N, S, L).
genNS(0, 0, []). % x_1 + x_2 + ... + x_n = S
genNS(N, S, [H|T]):-N > 0, between(0, S, H), S1 is S - H, N1 is N-1, genNS(N1, S1, T).

allNorks(N, L):- natural(S), genNS(N, S, L).
allFiniteNaturalNumberSequences(L):- pairNatural(N, S), genNS(N, S,L).

% 0 1 1
% 1 1 2
% 1 2 3
% f(n, first, second) {
%     if( n == 0) return first;
%     return f(n-1, second, first+second);
% }
% fib(X)
fib(X):- fib(X, _).
fib(0, 1).
fib(Y,Z):- fib(X, Y), Z is X + Y.

fibCheck(X):-fib2(0, 1, X).
fib2(X, _, X).
fib2(X, Y, L):-X < L, Z is X+Y, fib2(Y, Z, L).

% a_0 = a_1 = a_2 = 1
% a_(n+3) = a_n + a_(n+1) + 0*a_(n+2)
a(1, 1, 1).
a(Y, Z, T):-a(X, Y, Z), T is X + Y.
a(X):-a(X, _, _).