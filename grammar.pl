%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% wer ist der opa von der tante von heidi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s(SemS) --> np(Wer,_,_,_), vp(Wer,_,_,SemS), end(fs).
s(SemS) --> ip(Wer), vp(Wer,_,_,SemS), end(qm).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mache validen antwortsatz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a([Rel,Wer,Wem]) --> pn(Wer), v(_), det(_,G,K), n(Rel,G,K), prae(_), pn(Wem), end(fs).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% schreibe einen antwortsatz aus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
schreibe(S):- call(S), S =.. A, a(A,L1,_), answer(L1), nl.

answer([]).
answer([Head|Tail]):- write(Head), write(' '), answer(Tail).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% regeln der einzelnen satzteile 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ip(_) --> [X], {lex(X,_,i,_,_)}.

vp(Wer,Rel,Wem,SemS) --> v(_), np(Wer,Rel,Wem,SemS).

np(Wer,_,_,_) --> pn(Wer).
%np(Wer,Rel,Wem,SemS) --> det(_,G,K), n(Rel,G,K).
np(Wer,Rel,Wem,SemS) --> det(_,G,nom), n(Rel,G,nom), pp(Wem), {SemS =.. [Rel,Wer,Wem], call(SemS), schreibe(SemS)}.
np(Wer,Rel,Wem,SemS) --> det(_,G,dat), n(Rel,G,dat), pp(Wem), {SemS =.. [Rel,Wer,Wem], call(SemS), schreibe(SemS)}.

pp(Wer) --> prae(_), np(Wer,_,_,_).

pn(Wer) --> [Wer], {lex(Wer,_)}.

n(SemN,G,K) --> [X], {lex(X,SemN,n,G,K)}.

v(_) --> [X], {lex(X,_,v,_,_)}.

prae(_) --> [X], {lex(X,_,prae,_,_)}.

det(_,G,K) --> [X], {lex(X,_,det,G,K)}.

end(E) --> [X], {lex(X,_,E,_,_)}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lexikon
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lex(Name,m):- maennlich(Name).
lex(Name,w):- weiblich(Name).

lex(mutter,mutter,n,w,_).
lex(vater,vater,n,m,_).
lex(geschwister,geschwister,n,_,_).
lex(halbgeschwister,halbgeschwister,n,_,_).
lex(bruder,bruder,n,m,_).
lex(halbbruder,halbbruder,n,m,_).
lex(schwester,schwester,n,w,_).
lex(halbschwester,halbschwester,n,w,_).
lex(sohn,sohn,n,m,_).
lex(tochter,tochter,n,w,_).
lex(oma,oma,n,w,_).
lex(opa,opa,n,m,_).
lex(onkel,onkel,n,m,_).
lex(halbonkel,halbonkel,n,m,_).
lex(tante,tante,n,w,_).
lex(halbtante,halbtante,n,w,_).
lex(neffe,neffe,n,m,_).
lex(nichte,nichte,n,w,_).
lex(enkelkind,enkelkind,n,_,_).
lex(enkelsohn,enkelsohn,n,m,_).
lex(enkeltochter,enkeltochter,n,w,_).
lex(cousin,cousin,n,m,_).
lex(cousine,cousine,n,w,_).

lex(ist,sein,v,_,_).

lex(wer,_,i,_,_).

lex(von,_,prae,_,_).

lex(der,_,det,m,nom).
lex(die,_,det,w,nom).

lex(der,_,det,w,dat).
lex(dem,_,det,m,dat).

lex(?,_,qm,_,_).
lex(.,_,fs,_,_).
