%Fakt
maennlich(michael).
maennlich(hannes).
maennlich(joe).
maennlich(john).
maennlich(gerd).
maennlich(cedric).
maennlich(paul).
maennlich(jan).
maennlich(olaf).
maennlich(timo).
weiblich(corinna).
weiblich(hanna).
weiblich(heidi).
weiblich(anna).
weiblich(petra).
weiblich(simone).
weiblich(ute).
weiblich(tina).
weiblich(susi).


%Hannes ist Kind von Michael und Anna
kind(hannes,michael,anna).
kind(john,michael,anna).
kind(hanna,michael,anna).

kind(heidi,hannes,corinna).
kind(joe,gerd,hanna).
kind(petra,gerd,hanna).

kind(paul,cedric,heidi).
kind(jan,joe,simone).
kind(timo,joe,simone).
kind(ute,joe,simone).

kind(susi,timo,tina).


%Regeln
%X ist Mutter von Y
mutter(X,Y):- weiblich(X),kind(Y,_,X).
%X ist Vater von Y
vater(X,Y):- maennlich(X),kind(Y,X,_).
geschwister(X,Y):- kind(X,V,M), kind(Y,V,M), Y \= X.
halbgeschwister(X,Y):- vater(V,X), vater(V,Y), Y \= X.
halbgeschwister(X,Y):- mutter(M,X), mutter(M,Y), Y \=X.
 
bruder(X,Y):- maennlich(X), geschwister(X,Y).
schwester(X,Y):- weiblich(X), geschwister(X,Y).
halbschwester(X,Y):- weiblich(X), halbgeschwister(X,Y).
halbbruder(X,Y):- weiblich(X), halbgeschwister(X,Y).

sohn(X,Y):- maennlich(X), mutter(Y,X).
sohn(X,Y):- maennlich(X), vater(Y,X).
tochter(X,Y):- weiblich(X), mutter(Y,X).
tochter(X,Y):- weiblich(X), vater(Y,X).

%not(P):- call(P),!,fail.
%not(P). 

%opa(X,Y):- not(weiblich(X)), vater(X,Z), mutter(Z,Y).
opa(X,Y):- maennlich(X), vater(X,Z), mutter(Z,Y).
opa(X,Y):- maennlich(X), vater(X,Z), vater(Z,Y).
oma(X,Y):- weiblich(X), mutter(X,Z), mutter(Z,Y).
oma(X,Y):- weiblich(X), mutter(X,Z), vater(Z,Y).

onkel(X,Y):- maennlich(X), kind(Y,Z,_), geschwister(Z,X).
onkel(X,Y):- maennlich(X), kind(Y,_,Z), geschwister(Z,X).
halbonkel(X,Y):- maennlich(X), kind(Y,Z,_), halbgeschwister(Z,X).
halbonkel(X,Y):- maennlich(X), kind(Y,_,Z), halbgeschwister(Z,X).

tante(X,Y):- weiblich(X), kind(Y,Z,_), geschwister(Z,X).
tante(X,Y):- weiblich(X), kind(Y,_,Z), geschwister(Z,X).
halbtante(X,Y):- weiblich(X), kind(Y,Z,_), halbgeschwister(Z,X).
halbtante(X,Y):- weiblich(X), kind(Y,_,Z), halbgeschwister(Z,X).

neffe(X,Y):- maennlich(X), onkel(Y,X).
neffe(X,Y):- maennlich(X), tante(Y,X).

nichte(X,Y):- weiblich(X), onkel(Y,X).
nichte(X,Y):- weiblich(X), tante(Y,X).

enkelkind(X,Y):- opa(Y,X).
enkelkind(X,Y):- oma(Y,X).

enkelsohn(X,Y):- maennlich(X), enkelkind(X,Y).
enkeltochter(X,Y):- weiblich(X), enkelkind(X,Y).

cousin(X,Y):- maennlich(X), enkelkind(X,Z), enkelkind(Y,Z).
cousine(X,Y):- weiblich(X), enkelkind(X,Z), enkelkind(Y,Z).
