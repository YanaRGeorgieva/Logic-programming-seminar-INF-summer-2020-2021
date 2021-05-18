% flatten(L, R) [[[[[],a]], b], [c]] -> [a, b, c]
isList([]).
isList([_|_]).

flatten1([], []).
flatten1(X, [X]):- not(isList(X)).
flatten1([H|T], R):- flatten1(H, FH), flatten1(T, FT), append(FH, FT, R).
flatten(L, R):- isList(L), flatten1(L, R).


flatten2([], []).
flatten2([H|T], [H|R]):- not(isList(H)), flatten2(T, R).
flatten2([H|T], R):- isList(H), flatten2(H, FH), flatten2(T, FT), append(FH, FT, R).

% split(L, R) L=[a, b, c] -> R=[[a], [b], [c]], R=[[a, b], [c]] ,..., R=[[a,b,c]]
split([], []).
split(L, [X|R]):- append(X, Y, L), X\=[], split(Y, R). 


% sums(N, S).
sums(0, []).
sums(N, [H|T]):-between(1, N, H), M is N - H, sums(M, T).

% []
% [A, B] ако A, B са дървета.
% [[], []]

% tree([]).
% tree([A, B]):- tree(A), tree(B).

natural(0).
natural(X):-natural(Y), X is Y+1.

tree(T):-natural(N), tree(N, T).

tree(0, []).
tree(N, [A, B]):-N > 0, N1 is N - 1, between(0, N1, M), K is N1 - M, tree(M, A), tree(K, B).

% G=<V,E> 
% V=[a,b,...]
% E=[[a,b], ....]

edge([_, E], X, Y):- member([X, Y], E); member([Y, X], E). 

% path([V, E], A, B, Path).
path(G, A, B, Path):-path(G, A, B, [], Path).
% a -> b -> c -> d
%         c -> a
% path(G, A, B, V, Path).
path(_, B, B, V, R):- reverse([B|V], R).
path(G, A, B, V, Path):-A\=B, edge(G, A, C), not(member(C, V)), path(G, C, B, [A|V], Path).

graph([[a, b, c, d], [[a, b], [b, c], [c, d], [c, a]]]).

% p():-path(), q()
hasCycle(G, P):- edge(G, A, B), path(G, B, A, P), length(P, N), N > 2.

isConnected([[X|V], E]):- not(( member(Y, V), X\=Y, not(path([[X|V], E], X, Y, _)))).

% spanningTree([V, E], ST).
spanningTree([V, E], ST):- V=[H|T], spanningTree([V, E], [H], T, ST).
spanningTree(_, _, [], []).
spanningTree([V, E], Visited, NotVisited, [[U, W]|ST]):- member(U, Visited), edge([V, E], U, W), 
    member(W, NotVisited), remove(W, NotVisited, NewNotVisited), spanningTree([V, E], [W|Visited], NewNotVisited, ST).

remove(X, L, R):- append(A, [X|B], L), append(A, B, R).

isConnected2(G):- spanningTree(G, _).

hasCycleConnectedGraph([V, E]):- spanningTree([V, E], ST), length(E, N), length(ST, M), N > M.

% criticalVertex([V, E], X).

criticalVertex([V, E], X):- member(X, V), member(A, V), member(B, V), not(member(X, [A, B])), path([V, E], A, B, P), member(X, P), 
    not((path([V, E], A, B, P1), not(member(X, P1)))).
% a -b -c
%   -c -d