:- use_module(library(lists)).
:- use_module(library(assoc)).
:- use_module(library(ordsets)).
:- consult('facts.pl').


%------------REGOLE-----------------



%OTTIENI LE COORDINATE DI UNA QUALSIASI ENTITA CHE SFRUTTA IL PREDICATO isLocated 

getCoords(Entity, P, Lat,Lon) :-
	isLocated(Entity,P, latlon(Lat,Lon)), 
	(nonvar(Lat), nonvar(Lon)).




%%CALCOLA LA DISTANZA TRA DUE ENTITA SFRUTTANDO LA FORUMLA DELL'EMISENOVERSO
getDist(E1,E2,Dist):-
	getCoords(E1,P1,Lat1,Lon1), 
	getCoords(E2,P2,Lat2,Lon2),
	emisenoverso(Lat1,Lat2,Lon1,Lon2,Dist).




%FORMULA PER IL CALCOLO DELLA DISTAMZA TRA DUE PUNTI SULLA SUPERFICIE TERRESTRE
emisenoverso(Lat1,Lat2,Lon1,Lon2,Dist):-
	R is 6371*10**3, 
	Phi1 is Lat1*pi/180,
	Phi2 is Lat2*pi/180,
	Delta_phi is (Lat2-Lat1)*pi/180,
	Delta_lambda is (Lon2-Lon1)*pi/180,
	A is (sin(Delta_phi/2)*sin(Delta_phi/2) + cos(Phi1)*cos(Phi2)*sin(Delta_lambda/2)*sin(Delta_lambda/2)),
	C is 2*atan2(sqrt(A),sqrt(1-A)), 
	Dist is R*C.



%MEMORIZZA UNA PREFERENZA PER L'UTENTE
assertLikes(UID,Something):-
	assert(likes(UID,Something)), 
	writeToFile(likes(UID,Something)).



%STAMPA NELL'OUTPUT CORRENTE OGNI ELEMENTO DELLA LISTA PASSATA IN INPUT
assertRule(List):-
	assertRuleService(List).

assertRuleService([]).

assertRuleService([H|T]):-
	write(H), 
	assertRuleService(T).



%MEMORIZZA LA POSIZIONE DELL'UTENTE
assertPos(UID,PlaceName,Lat,Lon):-
	assert(isLocated(user(1,nome,cognome), place(PlaceName,_,_), latlon(Lat,Lon) )), 
	writeToFile(isLocated(user(1,nome,cognome), place(PlaceName,_,_), latlon(Lat,Lon) )).
	


%SCRIVE IN UN FILE LA VARIABILE A
writeToFile(A):-
	open('new_fact.pl',append,S), writeq(S,A), write(S,'.\n'),close(S).
	


% RECUPERA LE PREFERENZE DELL'UTENTE
interestedIn(UID,ListCat,ListAuthor,ListPoi,ListPlace) :-
	findall( C1,(likes(UID,category(_,C1)), nonvar(C1)),ListCat),
	findall( NameAuthor,(likes(UID,author(_,NameAuthor,_,_,_,_,_,_)),nonvar(NameAuthor)),ListAuthor),
	findall( CatPoi,(likes(UID,pointOfInterest(_,X,CatPoi,_,_,_,_)),nonvar(CatPoi)),ListPoi), 
	findall( NamePlace,(likes(UID,place(NamePlace,_,_)), nonvar(NamePlace)),ListPlace), 
	assertRule(['\n\nHo trovato tutti i nomi dei punti di interesse collegate ai tuoi interessi tramite la regola interestedIn: \n']).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% TROVA  I PUNTI DI INTERESSE CORRISPONDENTI ALLE CATEGORIA DATE

findPOIByCat([],[]).

findPOIByCat(ListAtt, [H|T]):-
	findall(X,(relatedTo(pointOfInterest(_,X,_,_,_,_,_),category(_,H))), List ), 
	findPOIByCat(L1,T),
	append(L1,List,ListAtt).


% TROVA  I PUNTI DI INTERESSE  CORRISPONDENTI AI TIPI DI POI

findPOIByType([],[]).


findPOIByType(ListAtt, [H|T]):-
	
	findall(X,pointOfInterest(_,X,H,_,_,_,_) , List ), 
	findPOIByType(L1,T),
	append(L1,List,ListAtt).




%TROVA  I PUNTI DI INTERESSE  CORRISPONDENTI ALLE CITTA

findPOIByPlace([],[]).

findPOIByPlace(ListAtt, [H|T]):-
	findall(X,(isLocated(pointOfInterest(_,X,_,_,_,_,_),place(H,_,_), latlon(_,_)) ), List ), 
	findPOIByPlace(L1,T),
	append(L1,List,ListAtt).




%TROVA I PUNTI DI INTERESSE CORRISPONDENTI AGLI AUTORI

findPOIByAuth([],[]).

findPOIByAuth(ListAtt, [H|T]):-
	findall(X,(developed(author(_, H, _, _, _, _, _, _), pointOfInterest(_, X, _, _, _ , _,_) )), List1 ),	
	findall(X,(developed(author(_, H, _, _, _, _, _, _), attraction(_, X, _, _, _ , _,_) )), List2 ),
	findPOIFromAttr(ListPOI,List2), 
	merge(ListPOI,List1,List), 
	findPOIByAuth(L1,T),
	append(L1,List,ListAtt).


%TROVA I PUNTI DI INTERESSE CORRISPONDENTI ALLE ATTRAZIONI PASSATE IN INPUT

findPOIFromAttr([],[]).

findPOIFromAttr(ListPOI,[H|T]):-
	findall(X, isLocated(attraction(_,H, _, _, _ , _,_), pointOfInterest(_, X, _, _, _ , _,_) , _ ), List), 
	findPOIByAuth(L1,T),
	append(L1,List,ListPOI).




%TROVA I PUNTI DI INTERESSE CORRISPONDENTI AL PREZZO DATO

findPOIByPrice(Price,List):-
	findall(X,(pointOfInterest(_,X,_,_,_,_,price(P)), P =< Price ),List).





% FILTRA I PUNTI DI INTERESSE 
filteredPOI(UID,Price,Result):-
	interestedIn(1,ListCat,ListAuthor,ListPoi,ListPlace), 
	findPOIByCat(ListC, ListCat), 
	findPOIByAuth(ListA, ListAuthor), 
	findPOIByType(Listpoi, ListPoi), 
	findPOIByPlace(ListP,ListPlace), 
	findPOIByPrice(Price,ListPr), 
	selectPOI(ListC,ListA,ListP,Listpoi,ListPr,Result), 
	assertRule(['\n\nHo filtrato i punti di interesse in base ai tuoi interessi tramite filteredPOI:\n', Result]).


% SELEZIONA I PUNTI DI INTERESSE IN BASE ALLE PREFERENZE DELL'UTENTE

selectPOI(LCat,LAuth,LPlace,LPOI,LPrice,Result):-
	merge(LCat,LAuth,R1), 
	merge(R1,LPOI,R3),
	merge(R3,LPrice,R4), 
	remove_duplicates(R4,R5), 
	intersection(R5,LPrice,R6), 
	intersectPlace(R6,LPlace,ResultPlace), 
	intersectAll(ResultPlace,R3,Result).
	




intersectPlace(ListInput, LPlace, Result):-

	(length(LPlace,L1 ), L1 > 0
	->
	(subtract(ListInput, LPlace,Sub1), 
	subtract(ListInput,Sub1,Result))
	; 
	Result = ListInput). 

intersectAll(ListInput, ListAll, Result):-

	(length(ListAll,L1 ), L1 > 0
	->
	(subtract(ListInput, ListAll,Sub1), 
	subtract(ListInput,Sub1,Result))
	; 
	Result = ListInput). 



%TROVA I PUNTI DI INTERESSE ATTORNO ALL'UTENTE IN UN DATO RAGGIO
% si assume che l'utente sia in una sola posizione nella KB


aroundUser(_,[],_,[],[]).

aroundUser(UID, ListFiltered, MaxDist, ListDist,ListNames):-
	remove_duplicates(ListFiltered,List),
	reverse(List,List1),
	subtract(List1,[[]],ListPOI), %%rimuoviamo lista vuota per fare in modo che calcDist non cerchi una attrazione con nome [] ==> impediamo il fallimento di calcDist
	calcDistUser(UID, ListPOI, ListD),

	findall(El, (select(poidist(_,El),ListD,Residuo), El < MaxDist), ListDist),
	findall(N, (select(poidist(N,El),ListD,Residuo), El < MaxDist), ListNames), 

	assertRule(['\n\nHo trovato i punti di interesse più vicine a te con la regola aroundUser: \n',ListNames,'\n Le relative distanze sono: \n',ListDist]).


%TROVA IL PUNTO DI INTERESSE CON DISTANZA MINORE 
	
nearestPOI([],[],[],0.0).


nearestPOI(ListDist,ListNames,NearestPOI,Min):-
	min_list(ListDist,Min),
	nth1(Nth, ListDist,Min), 
	nth1(Nth,ListNames,NearestPOI),
	assertRule(['\n\nHo utilizzato la regola nearestPOI per trovare la più vicina' , NearestPOI, ' con distanza:', Min,'\n']).
	


%CALCOLA LE DISTANZE TRA L'UTENTE E I PUNTI DI INTERESSE
calcDistUser(_,[],[]).


calcDistUser(UID,[H|T],ListDist):-
	getDist(user(UID,_,_),pointOfInterest(_,H,_,_,_,_,_), Dist), 
	calcDistUser(UID,T,LD1),
	append(LD1,[poidist(H,Dist)],ListDist).


	

%TROVA I PUNTI DI INTERESSE ATTORNO AD UN ALTRO

aroundPOI([],_,_,[],[],[]).


%%passiamo il final path per eslcuderne gli elementi ed evitare che ci siano cicli

aroundPOI(POIName, ListFiltered, MaxDist, ListDist,ListNames,FinalPath):-
	remove_duplicates(ListFiltered,List),
	reverse(List,List1),
	subtract(List1,[[]],ListPOI), %%rimuoviamo lista vuota per fare in modo che calcDist non cerchi una attrazione con nome [] ==> impediamo il fallimento di calcDist
	calcDistPOI(POIName, ListPOI, ListD),
	findall(El, (select(poidist(N,El),ListD,Residuo), El < MaxDist ,\+member(N,FinalPath) ), ListDist),
	findall(N, (select(poidist(N,El),ListD,Residuo), El < MaxDist, \+member(N,FinalPath) ), ListNames), 
	assertRule(['\n\nTramite aroundPOI, ho trovato i punti di interesse intorno a ', POIName, ' nel raggio di ', MaxDist, '.\n I punti di interesse sono: \n',ListNames,'\n Le relative distanze sono: \n',ListDist]).
	

	

%CALCOLA LE DISTANZE TRA UN PUNTO DI INTERESSE E QUELLI NELLA LISTA PASSATA IN INPUT
calcDistPOI(_,[],[]).


calcDistPOI(POIName,[H|T],ListDist):-
	getDist(pointOfInterest(_,POIName,_,_,_,_,_),pointOfInterest(_,H,_,_,_,_,_), Dist), 
	calcDistPOI(POIName,T,LD1),
	append(LD1,[poidist(H,Dist)],ListDist).



%CALCOLA I PERCORSI ALTRERNATIVI CON QUEL PREZZO E QUELLA DISTANZA

alternativePath(_,_,_,[],[]).

alternativePath(UID,Price,MaxDist,[D|TD],[N|TN]):-

	nearestPOI([D|TD],[N|TN], InitialPoi,Min),

	subtract([D|TD],[Min],AltDist),
	subtract([N|TN],[InitialPoi],AltPoi),

	pointOfInterest(_,InitialPoi,_,_,_,_,price(PricePoi)),

	InitPrice is Price - PricePoi, 
	InitDist is MaxDist-Min,
	
	append([],InitialPoi,FinalPath),
	
	findPath(UID,InitialPoi,InitDist, InitPrice,[FinalPath]),


	alternativePath(IUD,Price,MaxDist,AltDist,AltPoi).


%%PATH OTTIMALE
%%% NB: VERIFICARE AD OGNI STEP CHE L'ATTRAZIONE PIU VICINA NON SIA GIA PRESENTE NELLA LISTA PER EVITARE CICLI. 


pointOfInterest(_,[],_,_,_,_,price(0.0)).


%CALCOLA IL PATH OTTIMALE DATI PREZZO E DISTANZA

findPath(_,[],_,_,[H|T]):-
	!,
	subtract([H|T], [[]], Res),
	assertRule(['\n\nAlla fine, utilizzando la regola findPath, il percorso ottimale per le tue preferenze è: \n', Res]), 
	expandAttractions(Res,List), 
	assertRule(['\n\n Allo interno di questi punti di interesse puoi ammirare queste attrazioni:\n\n', List,'\n\n']).
	

findPath(UID, CenterPOI, ResidualDist, Budget, FinalPath ):-

	filteredPOI(UID, Budget, ResFil ), 
	subtract(ResFil, [CenterPOI], ResFiltered),

	aroundPOI(CenterPOI, ResFiltered, ResidualDist, ListDist,ListNames,FinalPath), 
	nearestPOI(ListDist,ListNames, NewCenter,NewMin), 

	pointOfInterest(_,NewCenter,_,_,_,_,price(PricePoi)), 

	NewBudget is Budget - PricePoi, 
	NewDist is ResidualDist - NewMin, 
	
	append(FinalPath, [NewCenter], Result), 

	findPath(UID, NewCenter, NewDist, NewBudget, Result). 



%MOSTRA TUTTE LE ATTRAZIONI ALL'INTERNO DEI PUNTI DI INTERESSE PASSATI IN INPUT
	
expandAttractions([],[]).

expandAttractions([H|T],Res):-
	findall(X,isLocated(attraction(_,X,_,_,_,_,_), pointOfInterest(_,H,_,_,_,_,_),_),List), 
	expandAttractions(T,L1),
	append(L1,List,Res).
	


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


main :-
	writeln('   ____        _   _                 _   _____      _   _     '),
	writeln('  / __ \      | | (_)               | | |  __ \    | | | |    '),
	writeln(' | |  | |_ __ | |_ _ _ __ ___   __ _| | | |__) |_ _| |_| |__  '),
	writeln(' | |  | |  _ \| __| |  _ ` _ \ / _` | | |  ___/ _` | __|  _ \ '),
	writeln(' | |__| | |_) | |_| | | | | | | (_| | | | |  | (_| | |_| | | |'),
	writeln('  \____/| .__/ \__|_|_| |_| |_|\__,_|_| |_|   \__,_|\__|_| |_|'),
	writeln('        | |                                                   '),
	writeln('        |_|                                                   '),
	writeln('Progetto FoAI 2022 - Universita degli studi di Bari Aldo Moro'),
	writeln('Autori: Andrea Basile - Roberto Lorusso'),
	writeln('Benvenuto!'), 
	writeln('Per cominciare inserisci la tua posizione...'), 
	writeln('Inserisci Latitudine:'), read(Lat),
	writeln('Inserisci Longitudine:'), read(Lon),
	
	
	%dati dentro bari utilizzati per il testing
	%Lat is 41.126427,
	%Lon is 16.872545,
	%PlaceName = 'bari', 


	assertPos(1,_, Lat,Lon), 
	menuCat, 
	menuAuthor, 
	menuPoi,
	menuPlace, 
	
	retractall(budget(R)),
	retractall(radius(P)),
	askBudget, 
	askRadius, 
	radius(MaxDist),
	budget(Price),

	tell('explanation.txt'),

	filteredPOI(1,Price,ResFil),
	aroundUser(1,ResFil,MaxDist, ListDist,ListNames), 
	nearestPOI(ListDist,ListNames, InitialPoi,Min), 
	
	subtract(ListDist,[Min],AltDist),
	subtract(ListNames,[InitialPoi],AltPoi),

	pointOfInterest(_,InitialPoi,_,_,_,_,price(PricePoi)),

	InitPrice is Price - PricePoi, 
	InitDist is MaxDist-Min,

	assertRule(['Inizio il calcolo del percorso ottimale con prezzo iniziale di ', Price, ' e distanza rimanente di ' ,InitDist, '.\n' ]),
	
	append([],InitialPoi,FinalPath),

	findPath(UID,InitialPoi,InitDist, InitPrice,[FinalPath]),

	told,

	tell('alternative-paths.txt'),

	write('\n\nTi consiglio percorsi alternativi che corrispondono alle tue preferenze...\n\n'), 
	
	alternativePath(UID,Price,MaxDist,AltDist,AltPoi),
	told.
	


	
%%%%%%%%%%%%%%%% USER INTERACTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


menuCat :- 
	write('Vuoi selezionare delle categorie di tuo interesse?:[[y/n]]'), nl, 
	read(y) 
	-> askCategory 
	;true.

menuPlace :-
	
	write('Vuoi selezionare delle citta di tuo interesse?:[[y/n]]'), nl, 
	read(y) 
	-> askPlace
	;true.



menuPoi:- 
	write('Vuoi selezionare specifiche tipologie di luoghi?:[y/n]]'), nl, 
	read(y) 
	-> askPOI
	;true.


menuAuthor:- 
	write('Vuoi selezionare un autore di tuo interesse?:[[y/n]]'), nl, 
	read(y) 
	-> askAuthor
	;true.





askCategory :-
    repeat,
    writeln('Seleziona una categoria di tuo interesse:'), nl,
	findall(N,relatedTo(Entity, category(_,N)), ML),
	remove_duplicates(ML,MenuList), 
    write(MenuList),nl,
    read(X),
    (   member(X,MenuList)
    ->  write('Hai selezionato: '), write(X), assertLikes(1,category(period,X)), nl, !
    ;   write('Immetti un nome valido'), nl, fail
    ), 
	writeln('Vuoi selezionare altro?: [y/n]'),
	(read(y)
	-> askCategory
	; true).



askPlace :-
    repeat,
    writeln('Seleziona una citta:'), nl,
	findall(N, (isLocated(_, place(N,_,_),_),nonvar(N)), ML),
	remove_duplicates(ML,MenuList), 
    write(MenuList),nl,
    read(X),
    (   member(X,MenuList)
    ->  write('Hai selezionato: '), write(X), assertLikes(1,place(X,_,_)), nl, !
    ;   write('Immetti un nome valido'), nl, fail
    ), 
	writeln('Vuoi selezionare altro?: [y/n]'),
	(read(y)
	-> askPlace
	; true).



askPOI :-
    repeat,
    writeln('Seleziona una tipologia di punto di interesse:'), nl,
	findall(N, (pointOfInterest(_,_,N,_,_,_,price(_)) , nonvar(N)), ML),
	remove_duplicates(ML,MenuList), 
    write(MenuList),nl,
    read(X),
    write('Hai selezionato: '), write(X), assertLikes(1,pointOfInterest(_,_,X,_,_,_,_)), nl, !,
	writeln('Vuoi selezionare altro?: [y/n]'),
	(read(y)
	*-> askPOI
	; true).

askAuthor :-
    repeat,
    writeln('Seleziona un autore:'), nl,
	findall(N, ( developed(author(_,N, _, _, _, _, _, _),_),nonvar(N)), ML),
	remove_duplicates(ML,MenuList), 
    write(MenuList),nl,
    read(X),
    write('Hai selezionato: '), write(X), assertLikes(1,author(_,X,_,_,_,_,_,_)), nl, !,
	writeln('Vuoi selezionare altro?: [y/n]'),
	(read(y)
	*-> askAuthor
	; true).



askBudget :-
    repeat,
    writeln('Inserisci un costo massimo per la tua visita:'), nl,
    read(X),
    ( number(X)
    ->  write('Hai selezionato: '), write(X), assert(budget(X)), nl, !
    ;   write('Immetti un valore valido'), nl, fail
    ).



askRadius :-
    repeat,
    writeln('Inserisci un raggio di azione per la ricerca delle punti di interesse (in metri):'), nl,
    read(X),
    ( number(X)
    ->  write('Hai selezionato: '), write(X), assert(radius(X)), nl, !
    ;   write('Immetti un valore valido'), nl, fail
    ).
