:- consult(readsentence).
:- consult(stammbaum).
:- consult(grammar).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% starte prompt fuer anfragen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
foo():- read_sentence(List), s(_,List,[]),!.
foo():- stupido().

stupido():- write('Unbekannter Fehlercode #3247').

