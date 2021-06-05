Use Cartis;

--Afisati clientii care nu au plasat nici macar o comanda
SELECT CLienti.nume, Clienti.prenume FROM Clienti
EXCEPT
SELECT Clienti.nume, Clienti.prenume FROM Clienti
INNER JOIN 
Comenzi ON Clienti.id_client=Comenzi.id_client;

--Afisati clientii care au plasat cel putin o comanda.
SELECT DISTINCT Clienti.nume, Clienti.prenume FROM Clienti
INNER JOIN 
Comenzi ON Clienti.id_client=Comenzi.id_client;

--Afisati cartile si autorii care le-au scris.
SELECT Carti.titlu, Autori.nume_complet FROM Carti
LEFT JOIN
CartiAutori ON Carti.id_carte = CartiAutori.id_carte
LEFT JOIN 
Autori ON Autori.id_autor = CartiAutori.id_autor;

--Pentu fiecare comanda in parte, afisati clientul care a facut comanda, cartile din comanda si numarul de exemplare.
SELECT Comenzi.id_comanda, Clienti.nume, Clienti.prenume, Carti.titlu, CartiComenzi.nr_carti FROM CartiComenzi
LEFT JOIN
Comenzi ON Comenzi.id_comanda = CartiComenzi.id_comanda 
LEFT JOIN
Carti ON Carti.id_carte = CartiComenzi.id_carte
LEFT JOIN 
Clienti ON Comenzi.id_client = Clienti.id_client;

--Afisati cate comenzi a avut clientul Bardas Alexandru?
SELECT Clienti.nume, Clienti.prenume,
COUNT(Comenzi.id_comanda) AS numar_comenzi
FROM Clienti
INNER JOIN 
Comenzi ON Clienti.id_client = Comenzi.id_client
WHERE nume='Bardas' AND prenume='Alexandru'
GROUP BY nume,prenume;

--Cate comenzi au costat sub 100 de lei?
SELECT CartiComenzi.id_comanda, 
SUM(CartiComenzi.pret*CartiComenzi.nr_carti) AS suma_comanda
FROM CartiComenzi
GROUP BY CartiComenzi.id_comanda
HAVING SUM(CartiComenzi.pret*CartiComenzi.nr_carti)<100;

--Care este cea mai scumpa carte disponibila online?
SELECT titlu, pret FROM Carti
INNER JOIN
(SELECT
MAX(pret) as p
FROM Carti
WHERE disp_online=0
GROUP BY disp_online) as s ON  pret=s.p;

