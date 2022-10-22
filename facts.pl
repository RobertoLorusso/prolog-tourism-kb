%KB facts


%---------ENTITA----------

%pointOfInterest(1, david, type, _,date(01,01,1501), technique, material)
%place(citta, poi(type, name, latlon(lat,lon)))

%ATTRAZIONI
pointOfInterest(6, 'teatro margherita', teatro, _ , _ , _, price(10)).
pointOfInterest(7, 'museo civico', museo, _ , _ , _, price(12)).
pointOfInterest(8, 'museo nuova era', museo,  _ , _ , _, price(43)).
pointOfInterest(9, 'museo nicolaiano', museo,  _ , _ , _, price(34)).
pointOfInterest(10, 'teatro petruzzelli', teatro,  _ , _ , _, price(0.0)).
pointOfInterest(11, 'museo archeologico di santa scolastica', museo, _ , _ , _, price(77)).
pointOfInterest(12, kunsthalle, galleria, _ , _ , _, price(56)).
pointOfInterest(13, quadreria, galleria,  _ , _ , _, price(42)).
pointOfInterest(14, 'galleria arcieri', galleria,  _ , _ , _, price(11)).

% Firenze 

pointOfInterest(15, 'cupola del brunelleschi', chiesa,  date(_,_,1420) , _ , _, price(11)).
pointOfInterest(16, 'campanile di giotto', chiesa,  date(_,_,1420) , _ , _, price(15)).
pointOfInterest(17, 'battistero di san giovanni', chiesa,  date(_,_,1059) , _ , _, price(15)).
pointOfInterest(18, 'ponte vecchio', chiesa,  date(_,_,1345) , _ , _, price(0.0)).
pointOfInterest(19, 'galleria degli uffizi', galleria,  date(_,_,_) , _ , _, price(15)).







%AUTORI
author(4, michelangelo, birthDate(6,3,1475), deathDate(18,2,1564), birthPlace(caprese), deathPlace(roma), italian, artist).
author(4, 'filippo brunelleschi', birthDate(6,3,1475), deathDate(18,2,1564), birthPlace(caprese), deathPlace(roma), italian, artist).




%CATEGORIE
category(period, rinascimento). 
category(period, risorgimento). 
category(period, contemporaneo).
category(period, medioevo).
 





%DEVELOPED

developed(author(4, 'filippo brunelleschi', _, _, _, _, _, _), 		pointOfInterest(15, 'cupola del brunelleschi', _, _, _ , _,_) ).
developed(author(5,'piccinni',_,_,_,_,_,_), 				pointOfInterest(6, 'quadreria', museo, _ , _ , _, price(10))).
developed(author(6,'botticelli',_,_,_,_,_,_), 				attraction(14, 'nascita di venere', quadro, _ , _ , _, _)).
developed(author(7,'raffaello',_,_,_,_,_,_), 				attraction(15, 'venere de medici', quadro, _ , _ , _, _)).



%USER
user(1,roberto,lorusso).







%---------RELAZIONI----------

%RELATEDTO (pointOfInterest, category)

relatedTo(pointOfInterest(6, 'teatro margherita', teatro, _ , _ , _, price(10)), 			category(period,contemporaneo) ).
relatedTo(pointOfInterest(7, 'museo civico', museo, _ , _ , _, price(12)), 				category(period,contemporaneo) ).
relatedTo(pointOfInterest(8, 'museo nuova era', museo,  _ , _ , _, price(43)), 				category(period,contemporaneo) ).
relatedTo(pointOfInterest(9, 'museo nicolaiano', museo,  _ , _ , _, price(34)), 			category(period,contemporaneo) ).
relatedTo(pointOfInterest(10, 'teatro petruzzelli', teatro,  _ , _ , _, price(0.0)), 			category(period,contemporaneo) ).
relatedTo(pointOfInterest(11, 'museo archeologico di santa scolastica', museo, _ , _ , _, price(77)), 	category(subject,archeologia) ).
relatedTo(pointOfInterest(12, kunsthalle, galleria, _ , _ , _, price(56)), 				category(period,contemporaneo) ).
relatedTo(pointOfInterest(13, quadreria, galleria,  _ , _ , _, price(42)), 				category(period,contemporaneo) ).
relatedTo(pointOfInterest(14, 'galleria arcieri', galleria,  _ , _ , _, price(11)), 			category(period,contemporaneo) ).

relatedTo(pointOfInterest(15, 'cupola del brunelleschi', chiesa,  date(_,_,1420) , _ , _, price(11)), 	category(period,medioevo) ).
relatedTo(pointOfInterest(16, 'campanile di giotto', chiesa,  date(_,_,1420) , _ , _, price(15)), 	category(period,medioevo) ).
relatedTo(pointOfInterest(17, 'battistero di san giovanni', chiesa,  date(_,_,1059),_  , _,price(15)),  category(_,medioevo) ).
relatedTo(pointOfInterest(18, 'ponte vecchio', chiesa,  date(_,_,1345) , _ , _, price(0.0)), 		category(_,medioevo) ).

relatedTo(attraction(14, 'nascita di venere', quadro, _ , _ , _, _), 					category(period,rinascimento) ).









%% OGNI pointOfInterest DEVE ESSERE IN UNA RELAZIONE isLocated ALTRIMENTI LA REGOLA AROUNDUSER FALLISCE. 

isLocated(user(1,roberto,lorusso), place(bari,_,_), latlon(41.1209754,16.8634188) ).

isLocated(pointOfInterest(6, 'teatro margherita', museo, _ , _ , _, price(10)), 			place(bari,_,_), latlon(41.126427,16.872545)).
isLocated(pointOfInterest(7, 'museo civico', museo, _ , _ , _, price(12)), 				place(bari,_,_), latlon(41.127308,16.869257)).
isLocated(pointOfInterest(8, 'museo nuova era', museo,  _ , _ , _, price(43)), 				place(bari,_,_), latlon(41.1288543,16.8708644)).
isLocated(pointOfInterest(9, 'museo nicolaiano', museo,  _ , _ , _, price(34)), 			place(bari,_,_), latlon(41.1307315,16.8706677)).
isLocated(pointOfInterest(10, 'teatro petruzzelli', teatro,  _ , _ , _, price(0.0)), 			place(bari,_,_), latlon(41.123529,16.872580)).
isLocated(pointOfInterest(11, 'museo archeologico di santa scolastica', museo, _ , _ , _, price(77)), 	place(bari,_,_), latlon(41.1320564,16.8709559)).
isLocated(pointOfInterest(12, kunsthalle, galleria, _ , _ , _, price(56)), 				place(bari,_,_), latlon(41.1211175,16.8759397)).
isLocated(pointOfInterest(13, quadreria, galleria,  _ , _ , _, price(42)), 				place(bari,_,_), latlon(41.122474,16.8688328)).
isLocated(pointOfInterest(14, 'galleria arcieri', galleria,  _ , _ , _, price(11)), 			place(bari,_,_), latlon(41.1150861,16.8730968)).



isLocated(pointOfInterest(15, 'cupola del brunelleschi', chiesa,  _ , _ , _, price(11)), 		place(firenze,_,_), latlon(43.773333,11.257294)).
isLocated(pointOfInterest(16, 'campanile di giotto', chiesa,  date(_,_,_) , _ , _, price(15)), 		place(firenze,_,_), latlon(43.772778,11.255833)).
isLocated(pointOfInterest(17, 'battistero di san giovanni', chiesa,  date(_,_,_) , _ , _, price(15)), 	place(firenze,_,_), latlon(43.773197,11.255194)).
isLocated(pointOfInterest(18, 'ponte vecchio', chiesa,  date(_,_,_) , _ , _, price(15)), 		place(firenze,_,_), latlon(43.768009,11.253165)).
isLocated(pointOfInterest(19, 'galleria degli uffizi', galleria,  date(_,_,_) , _ , _, price(15)), 	place(firenze,_,_), latlon(43.7677893,11.2552773)).






%%ATTRAZIONI BARI 

isLocated(attraction(1, 'collezione fondo tanzi', collezione, _ , _ , _, _),		pointOfInterest(7, 'museo civico', museo, _ , _ , _, price(12)),latlon(41.127308,16.869257)).
isLocated(attraction(2, 'collezione fondo menotti', collezione, _ , _ , _, _),		pointOfInterest(7, 'museo civico', museo, _ , _ , _, price(12)),latlon(41.127308,16.869257)).
isLocated(attraction(3, 'collezione fondo antonelli', collezione, _ , _ , _, _),	pointOfInterest(7, 'museo civico', museo, _ , _ , _, price(12)),latlon(41.127308,16.869257)).
isLocated(attraction(4, 'collezione di armi', collezione, _ , _ , _, _),		pointOfInterest(7, 'museo civico', museo, _ , _ , _, price(12)),latlon(41.127308,16.869257)).
isLocated(attraction(5, 'collezione campagna di africa', collezione, _ , _ , _, _),	pointOfInterest(7, 'museo civico', museo, _ , _ , _, price(12)),latlon(41.127308,16.869257)).



isLocated(attraction(6, 'argento vivo', quadro, _ , _ , _, _), 				pointOfInterest(8, 'museo nuova era', museo,  _ , _ , _, price(43)), latlon(41.1288543,16.8708644)).
isLocated(attraction(7, 'altrove', installazione, _ , _ , _, _), 			pointOfInterest(8, 'museo nuova era', museo,  _ , _ , _, price(43)), latlon(41.1288543,16.8708644)).


isLocated(attraction(8, 'statua di san nicola', scultura, _ , _ , _, _),	pointOfInterest(9, 'museo nicolaiano', museo,  _ , _ , _, price(34)),latlon(41.1307315,16.8706677)).
isLocated(attraction(9, 'La manna', workofart, _ , _ , _, _),			pointOfInterest(9, 'museo nicolaiano', museo,  _ , _ , _, price(34)),latlon(41.1307315,16.8706677)).
isLocated(attraction(10, 'tomba di San Nicola', reliquia , _ , _ , _, _),	pointOfInterest(9, 'museo nicolaiano', museo,  _ , _ , _, price(34)),latlon(41.1307315,16.8706677)).


isLocated(attraction(11, 'collezione polese', collezione , _ , _ , _, _), 	pointOfInterest(11, 'museo archeologico di santa scolastica', museo, _ , _ , _, price(77)), latlon(41.1320564,16.8709559)).
isLocated(attraction(12, 'artefatti preistorici', collezione , _ , _ , _, _), 	pointOfInterest(11, 'museo archeologico di santa scolastica', museo, _ , _ , _, price(77)), latlon(41.1320564,16.8709559)).



% ATTRAZIONI FIRENZE




isLocated(attraction(13, 'la velata', quadro, _ , _ , _, _), 				pointOfInterest(19, 'galleria degli uffizi', galleria,  date(_,_,_) , _ , _, price(15)),  latlon(43.7677893,11.2552773)).
isLocated(attraction(14, 'nascita di venere', quadro, _ , _ , _, _), 			pointOfInterest(19, 'galleria degli uffizi', galleria,  date(_,_,_) , _ , _, price(15)),  latlon(43.7677893,11.2552773)).
isLocated(attraction(15, 'venere de medici', scultura, _ , _ , _, _), 			pointOfInterest(19, 'galleria degli uffizi', galleria,  date(_,_,_) , _ , _, price(15)),  latlon(43.7677893,11.2552773)).
isLocated(attraction(16, 'madonna del latte', quadro, _ , _ , _, _), 			pointOfInterest(19, 'galleria degli uffizi', galleria,  date(_,_,_) , _ , _, price(15)),  latlon(43.7677893,11.2552773)).
isLocated(attraction(17, 'i duchi di urbino', quadro, _ , _ , _, _), 			pointOfInterest(19, 'galleria degli uffizi', galleria,  date(_,_,_) , _ , _, price(15)),  latlon(43.7677893,11.2552773)).
isLocated(attraction(18, 'bacco', quadro, _ , _ , _, _), 				pointOfInterest(19, 'galleria degli uffizi', galleria,  date(_,_,_) , _ , _, price(15)),  latlon(43.7677893,11.2552773)).








