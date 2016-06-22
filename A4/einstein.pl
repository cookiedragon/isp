leftto(A,B,[A,B|_]).
leftto(A,B,[_|Tail]):- leftto(A,B,Tail).

nextto(A,B,H):- leftto(A,B,H).
nextto(A,B,H):- leftto(B,A,H).

first(A, [A|_]).

middle(A, [_,_,A,_,_]).

schreibe(Wem,[]):- write('Der '), write(Wem), write(' hat den Fisch.'), !.
schreibe(Wem,[Head|Tail]):- write(Head), nl, schreibe(Wem, Tail).

einstein():- H = [_,_,_,_,_],
	%%% land,farbe,tier,getraenk,zigarette
	member([brite,rot,_,_,_], H),
	member([schwede,_,hund,_,_], H),
	member([daene,_,_,tee,_], H),
	leftto([_,gruen,_,_,_],[_,weiss,_,_,_], H),
	member([_,gruen,_,kaffee,_], H),
	member([_,_,vogel,_,pallmall], H),
	middle([_,_,_,milch,_], H),
	member([_,gelb,_,_,dunhill], H),
	first([norweger,_,_,_,_], H),
	nextto([_,_,_,_,marlboro],[_,_,katze,_,_], H),
	nextto([_,_,pferd,_,_],[_,_,_,_,dunhill], H),
	member([_,_,_,bier,winfield], H),
	nextto([norweger,_,_,_,_],[_,blau,_,_,_], H),
	member([deutsche,_,_,_,rothmanns], H),
	nextto([_,_,_,_,marlboro],[_,_,_,wasser,_], H),
	member([Wem,_,fisch,_,_], H), 
	!, schreibe(Wem,H).
