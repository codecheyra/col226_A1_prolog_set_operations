del(X, [] , []) :- !.
del(X, [X|R], Z) :- del(X, R, Z), !.
del(X, [Y|R], [Y|Z]) :- Y\=X, del(X, R, Z), !.

%del(1, [1, 2, 3], Res).
%Res = [2, 3].
%del([], [], Res).
%Res = [].

remdups([], []) :- !.
remdups([X|R], [X|Z]) :- del(X, R, L), remdups(L, Z).

%remdups([1, 2, 3, 4, 5, 4], Res).
%Res = [1, 2, 3, 4, 5].
%remdups([], Res).
%Res = [].

unionI([], S2, S2) :- !.
unionI(S1, [], S1) :- !.
unionI([X|R], S2, [X|Z]) :- del(X, S2, S3),  unionI(R, S3, Z).

%unionI([1, 2, 3], [2, 3, 4], Res).
%Res = [1, 2, 3, 4].
%unionI([], [], Res).
%Result = [].
%Yes, Result of unionI does not have duplicates.

append( [], L, L).
append( [X|R], L, [X|Z]) :- append(R, L, Z).

%append([1, 2, 3], [4, 5, 6], Res).
%Res = [1, 2, 3, 4, 5, 6].
%append([], [], Res).
%Res = [].

mapcons(X, [], []) :- !.
mapcons(X, [Y|R], [ [X|Y] | Z ]) :- mapcons(X, R, Z).

%mapcons(a, [[1, 2, 3, 4], [9]], Res).
%Res = [[a, 1, 2, 3, 4], [a, 9]].
%mapcons([], [], Res).
%Res = [].

powerI([], [[]]) :- !.
powerI([X|R], P) :- powerI(R, P1),  mapcons(X, P1, P2), append(P2, P1, P).

%powerI([1, 2], Res).
%Res = [[1, 2], [1], [2], []].
%powerI([], Res).
%Res = [[]].

interI([], _, []).
interI(_, [], []).
interI([H|S1], S2, [H|Res]) :- member(H, S2), interI(S1, S2, Res), !.
%interI([H|S1], S2, Res) :- interI(S1, S2, Res).
interI([_|S1], S2, Res) :- interI(S1, S2, Res).

%interI([1, 2, 3, 4], [3, 4, 5, 6, 7], Res).
%Res = [3, 4].
%interI([], [1, 2, 3], Res).
%Res = [].

diffI([], _, []).
diffI([H|S1], S2, [H|Res]) :- \+ member(H, S2), !, diffI(S1, S2, Res).
diffI([H|S1], S2, Res) :- diffI(S1, S2, Res).

%diffI([1, 2, 3], [2, 3, 4], Res).
%Res = [1].
%diffI([], [1, 2, 3], Res).
%Res = [].

cartesianI([], _, []).
cartesianI([H|S1], S2, Res) :- 
    pairs(H, S2, CurrentPairs),
    cartesianI(S1, S2, Remaining),
    append(CurrentPairs, Remaining, Res).

pairs(_, [], []).
pairs(X, [Y|S2], [[X, Y]|Res]) :- pairs(X, S2, Res).

%cartesianI([1, 2], [3, 4], Res).
%Res = [[1, 3], [1, 4], [2, 3], [2, 4]] .
%cartesianI([], [1, 2, 3], Res).
%Res = [].

%powerset sort
sortPowerSet([], []).
sortPowerSet([Subset|Rest], [SortedSubset|SortedRest]) :-
    sort(Subset, SortedSubset),
    sortPowerSet(Rest, SortedRest).
%powerset sort themselves
sortPowerSets(PowerSets, SortedPowerSets) :-
    maplist(sortPowerSet, PowerSets, SortedPowerSets).
%powersets compare
equalPowerSets(X, Y) :-
    powerI(X, PowerSet1),
    powerI(Y, PowerSet2),
    sortPowerSets([PowerSet1, PowerSet2], [SortedPowerSet1, SortedPowerSet2]),
    subset(SortedPowerSet1, SortedPowerSet2),
    subset(SortedPowerSet2, SortedPowerSet1).

%equalPowerSets([], [0]).
%false.
%equalPowerSets([1, 2, 3, 4], [4, 2, 3, 1]).
%true.





% Base case: If we are looking at the same element, it is reflexive.
reflexive_closure(_, X, X).

% Transitive closure: A relation is transitive if (X, Z) is in R and (Z, Y) is in R, then (X, Y) is also considered in R.
transitive_closure(_, X, X).
transitive_closure(R, X, Y) :- member((X, Z), R), transitive_closure(R, Z, Y).

% Reflexive-transitive closure:
reflexive_transitive_closure(R, X, Y) :- transitive_closure(R, X, Y).
    
% Additionally, if we are already at the same element, it is reflexive.
reflexive_transitive_closure(_, X, X).

% Example usage:
%reflexive_transitive_closure([(1, 2), (2, 3), (3, 4)], 1, 4).
%true .



% Symmetric closure
symmetric_closure(R, X, Y) :- member((X, Y), R) ; member((Y, X), R).

% Reflexive-symmetric-transitive closure
rst_closure(R, X, Y) :- rst_closure(R, X, Y, [X]).

% Helper predicate for reflexive-symmetric-transitive closure
rst_closure(_, X, X, _).
rst_closure(R, X, Y, Visited) :- symmetric_closure(R, X, Z), \+ member(Z, Visited), transitive_closure(R, Z, Y), rst_closure(R, Z, Y, [Z | Visited]).

%rst_closure([], 1, 1).
%true .

%interI([1,2],[],X).
%interI([2,3,4],[2,3],X).
%interI([3,2,1],[4,3,2,0],X).
%diffI([],[3,4,5],X).
%diffI([3,4],[5],X).
%diffI([4,5,6],[6,4],X).
%cartesianI([],[a,b],X).
%cartesianI([1,2],[a,b],X).
%cartesianI([],[],X).
