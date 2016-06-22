solve(Strategy):-
  start_description(StartState),
  solve((start, StartState, _), Strategy).

solve(StartNode, Strategy) :-
  start_node(StartNode),
  search([[StartNode]], Strategy, Path), % init maxLength
  reverse(Path, _Path_in_correct_order),
  length(Path,L), write('Laenge des Pfades: '), write(L).
  %write_solution(Path_in_correct_order).

% abbruch: wenn zielzustand erreicht, wird der aktuelle pfad an 3. param
% variable hier fuer maxlength
search([[FirstNode | Predecessors] | _], _, [FirstNode | Predecessors]) :- 
  goal_node(FirstNode),
  nl, write('SUCCESS'), nl, !.

% suche die loesung
% variable hier fuer maxlength, checke zum anfang, ob Pfad/Solution kleiner als maxlength
search([[FirstNode | Predecessors] | RestPaths], Strategy, Solution) :-
  expand(FirstNode, Children), % nachfolge zustaende berechnen
  generate_new_paths(Children, [FirstNode | Predecessors], NewPaths), % nachfolge zustaende einbauen
  insert_new_paths(Strategy, NewPaths, RestPaths, AllPaths), % neue pfade einsortieren
  search(AllPaths, Strategy, Solution).
  
%% weitere search
% wenn maxlength erreicht, dann duerfen wir nicht mehr expandieren, sondern tun so, als wuerden wir keine weiteren kindsknoten mehr finden. Hoeren also auf zu expandieren. wenn wir keine loesung finden, wird maxlength hoeher gesetzt.

% nachfolge zustaende einbauen
generate_new_paths(Children, Path, NewPaths):-
  maplist(get_state, Path, States), % alle stati extrahieren
  generate_new_paths_help(Children, Path, States, NewPaths).

% abbruch: wenn alle kindknoten abgearbeitet sind
generate_new_paths_help([],_,_,[]).

% falls der kindzustand schon im pfad, ganzer Pfad weg, sonst zyklus. Keine Pruefung, ob Kindzusstand in anderem Pfad, denn vielleicht ist dieser Pfad guenstiger.
generate_new_paths_help([FirstChild|RestChildren],Path,States,RestNewPaths):- 
  get_state(FirstChild,State),state_member(State,States),!,
  generate_new_paths_help(RestChildren,Path,States,RestNewPaths).

% wenn Kindzustand noch nicht im Pfad, als Nachfolgezustand einbauen.
generate_new_paths_help([FirstChild|RestChildren],Path,States,[[FirstChild|Path]|RestNewPaths]):- 
  generate_new_paths_help(RestChildren,Path,States,RestNewPaths).

% hol den state aus dem Knoten
get_state((_,State,_),State).

% alle strategien: keine neue pfade vorhanden
insert_new_paths(_Strategy, [], OldPaths, OldPaths):-
  %write_fail(Strategy, OldPaths), 
  !.

% Tiefensuche normal
% suche kindknoten vom ersten, durchsuche ersten kindknoten, haenge neue vorne an
insert_new_paths(depth, NewPaths, OldPaths, AllPaths):-
  append(NewPaths, OldPaths, AllPaths).
  %write_action(NewPaths).

% Breitensuche
% suche alle kindknoten von bekannten knoten und haenge die neuen hinten an
insert_new_paths(breadth, NewPaths, OldPaths, AllPaths):-
  append(OldPaths, NewPaths, AllPaths).
  %write_next_state(AllPaths),
  %write_action(AllPaths).

% A*
% sortiere die neuen zustaende nach heuristik (kosten vom Start + geschaetzte Kosten zum Ziel)
insert_new_paths(astar, NewPaths, OldPaths, AllPaths):-
  eval_paths(astar, NewPaths),
  insert_new_paths_informed(NewPaths, OldPaths, AllPaths).
  %write_action(AllPaths),
  %write_state(AllPaths).

% Optimistisches Bergsteigen
% sortiert nach heuristik (kosten vom Start), verwenden nur den besten pfad, schmeissen alle anderen weg
insert_new_paths(ob, NewPaths, _, [BestPath]):-
  eval_paths(ob, NewPaths),
  insert_new_paths_informed(NewPaths, [], [BestPath|_Verworfen]),
  cheaper2(BestPath). % check nochmal
  %write_Verworfen(Verworfen),
  %write_action([BestPath]),
  %write_state([BestPath]).

% Bergsteigen mit Backtracking
% wie ob, aber: neue pfade werden sortiert und komplett vor alle alten gepackt
insert_new_paths(bergback, NewPaths, OldPaths, AllPaths):-
  eval_paths(bergback, NewPaths),
  insert_new_paths_informed(NewPaths, [], SortedNewPaths),
  lists:append(SortedNewPaths, OldPaths, AllPaths).
  %write_action(AllPaths),
  %write_state(AllPaths).

% Gierige Bestensuche
% wie a*, aber nur mit einfacher heuristik (Kosten vom Start)
insert_new_paths(gierig, NewPaths, OldPaths, AllPaths):-
  eval_paths(gierig, NewPaths),
  insert_new_paths_informed(NewPaths, OldPaths, AllPaths).
  %write_action(AllPaths),
  %write_state(AllPaths).

% checke das erste und zweite element einer liste
cheaper2([(_, _, _),(_, _, _)]).
cheaper2([(_, _, V1),(_, _, V2)|_]):-
	%write(V1),write(V2),nl,
	V1 =< V2.
cheaper2([(_, _, _),(_, _, _)|_]).

write_solution(Path):-
  nl, write('SOLUTION:'), nl,
  write_actions(Path).

write_actions([]).

write_actions([(Action, _, _) | Rest]):-
  write('Action: '), write(Action), nl,
  write_actions(Rest).

write_action([[(Action,_)|_]|_]):-
  nl,write('Action: '),write(Action),nl.

write_next_state([[_,(_,State)|_]|_]):-
  nl,write('Go on with: '),write(State),nl.

write_state([[(_,State)|_]|_]):-
  write('New State: '),write(State),nl.

write_fail(depth,[[(_,State)|_]|_]):-
  nl,write('FAIL, go on with: '),write(State),nl.

write_fail(_,_):-  nl,write('FAIL').

write_Verworfen([]).

write_Verworfen([[(_,State)|_]|_]):-
  nl, write('Verworfen:'), nl,
  write('State: '),write(State),nl.
  
eval_used_time([]).
eval_used_time([CurrentStrategy|Rest]):-
   write('###########################################'),
   nl,
   write('Measuring time for ' + CurrentStrategy),
   nl,
   time(solve(CurrentStrategy)),
   eval_used_time(Rest),
   write('###########################################'),
   nl.

