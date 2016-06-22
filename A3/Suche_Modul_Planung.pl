
start_description([
				block(block1),
				block(block2),
				block(block3),
				block(block4),
				block(block5),
				block(block6),
				on(table,block2),
				on(table,block6),
				on(block2,block1),
				on(block1,block4),
				on(block4,block3),
				on(block6,block5),
				clear(block3),
				clear(block5),
				handempty
]).

goal_description([
				block(block1),
				block(block2),
				block(block3),
				block(block4),
				block(block5),
				block(block6),
				on(table,block1),
				on(table,block2),
				on(table,block3),
				on(block1,block4),
				on(block4,block6),
				on(block2,block5),
				clear(block6),
				clear(block5),
				clear(block3),
				handempty
]).
/*
start_description([
  block(block1),
  block(block2),
  block(block3),
  block(block4),  %mit Block4
  on(table,block2),
  on(table,block3),
  on(block2,block1),
  on(table,block4), %mit Block4
  clear(block1),
  clear(block3),
  clear(block4), %mit Block4
  handempty
  ]).

goal_description([
  block(block1),
  block(block2),
  block(block3),
  block(block4), %mit Block4
  on(block4,block2), %mit Block4
  on(table,block3),
  on(table,block1),
  on(block1,block4), %mit Block4
%  on(block1,block2), %ohne Block4
  clear(block3),
  clear(block2),
  handempty
  ]).
*/

start_node((start,_,_)).

goal_node((_,State,_)):-
  goal_description(GoalState), % zielbedingungen einlesen
  mysubset(GoalState, State). % zustand gegen zielbedingungen testen

% abbruch: liste leer
state_member(_,[]):- !,fail.

% teste, ob state bereits durch firststate beschrieben war
% abbruch: state ist untermenge oder obermenge von firststate
state_member(State,[FirstState|_]):-
  mysubset(State,FirstState),
  mysubset(FirstState,State),
  !.

% sonst checke ob state eine untermenge von dem rest
state_member(State,[_|RestStates]):-  
  state_member(State,RestStates).


% eval fuer a*: normale heuristik + kosten vom start
eval_path(astar, [(_, State, Value)|Rest]) :-
        length(Rest, G),
        eval_state(State, Heuristic),
        Value is Heuristic + G.

% normale eval mit normaler heuristik
eval_path(_, [(_,State,Value)|_]) :-
        eval_state(State, Value).
        
% heuristik: wie viel Zielzustaende habe ich schon
eval_state(State, Value) :-
        goal_description(Goal),
        lists:subtract(Goal, State, NochNicht),
        lists:subtract(Goal, NochNicht, SchonRichtig),
        heuristik(SchonRichtig, Value).

%einfache heuristik_help
/*heuristik(SchonRichtig,Value):-
	length(SchonRichtig,L), 
	Value is -1 * L.
*/
% heuristik: zaehle nach art der zustaende und gewichte
heuristik(SchonRichtig, Value):-
		findall(OnTable, heuristik_help(on(table,X), SchonRichtig, OnTable), OnTableResult),
		findall(On, heuristik_help(on(_,X), SchonRichtig, On), OnResult),
		findall(Clear, heuristik_help(clear(X), SchonRichtig, Clear), ClearResult),
		length(OnTableResult, OnTableLength),
		length(OnResult, OnLength),
		length(ClearResult, ClearLength),
		Value is -1 * (OnTableLength * 3 + OnLength + ClearLength * 2).

% hat der aktuelle state diese aktion
heuristik_help(Name, State, Name):-
		member(Name, State).

action(pick_up(X),
       [handempty, clear(X), on(table,X)],
       [handempty, clear(X), on(table,X)],
       [holding(X)]).

action(pick_up(X),
       [handempty, clear(X), on(Y,X), block(Y)],
       [handempty, clear(X), on(Y,X)],
       [holding(X), clear(Y)]).

action(put_on_table(X),
       [holding(X)],
       [holding(X)],
       [handempty, clear(X), on(table,X)]).

action(put_on(Y,X),
       [holding(X), clear(Y)],
       [holding(X), clear(Y)],
       [handempty, clear(X), on(Y,X)]).

% ist die Liste [H|T] in Liste, d.h. eine untermenge
mysubset([],_).
mysubset([H|T],List):-
  member(H,List),
  mysubset(T,List).


expand_help(State, Name, Result):-
  action(Name, CondList, DelList, AddList), % aktion suchen
  mysubset(CondList, State), % conditions testen
  lists:subtract(State, DelList, SubtractResult), % del liste umsetzen, d.h. loesche alle Stati, die jetzt nicht mehr gelten
  lists:union(AddList, SubtractResult, Result). % add list umsetzen, alle neuen Stati hinzufuegen

% suche nachfolge zustaende des aktuellen knotens, 
expand((_,State,_),Result):-
  findall((Name,NewState,_),expand_help(State,Name,NewState),Result).% finde alle moeglichen Kindknoten, formatiere sie und schreibe sie in Result
