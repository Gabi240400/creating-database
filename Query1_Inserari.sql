USE Cartis;

--Inserari de carti in tabelul Carti
INSERT INTO Carti
(titlu, an_publicatie, editura, categorie, disp_online, pret)
VALUES('Hunger Games', 2014, 'Scholastic', 'Aventura', 1, 119.0);
INSERT INTO Carti
(titlu, an_publicatie, editura, categorie, disp_online, pret)
VALUES('Harry Potter and The Philisopher''s Stone', 2019, 'Arthur', 'Fantasy', 0, 63.3);
INSERT INTO Carti
(titlu, an_publicatie, editura, categorie, disp_online, pret)
VALUES('Peste cinci ani', 2020, 'Nemira', 'Modern', 1, 39.99);
INSERT INTO Carti
(titlu, an_publicatie, editura, categorie, disp_online, pret)
VALUES('Muzica noptii', 2020, 'Litera', 'Modern', 0, 49.9);
INSERT INTO Carti
(titlu, an_publicatie, editura, categorie, disp_online, pret)
VALUES('Robinson Crusoe', 2020, 'Niculescu', 'Aventura', 1, 27.9);
INSERT INTO Carti
(titlu, an_publicatie, editura, categorie, disp_online, pret)
VALUES('Puterea mitului', 2020, 'Trei', 'Psihoterapie', 1, 29.25);
--Am executat instructiunile de mai sus de 2 ori din greseala asa ca le sterg aici:
DELETE FROM Carti WHERE id_carte in (8,9,10,11,12,13);

--Inserari de autori in tabelul Autori
INSERT INTO Autori
(nume_complet, tara_origine, data_nasterii)
VALUES('Joseph Campbell', 'USA', '1904-03-26');
--Am executat instructiunea de mai sus de 2 ori din greseala asa ca o sterg aici:
DELETE FROM Autori WHERE id_autor=3;
INSERT INTO Autori
(nume_complet, tara_origine, data_nasterii)
VALUES('J. K. Rowling', 'Regatul Unit al Marii Britanii', '1965-07-31');
INSERT INTO Autori
(nume_complet, tara_origine, data_nasterii)
VALUES('Bill Moyeres', 'SUA', '1934-06-05');
INSERT INTO Autori
(nume_complet, tara_origine, data_nasterii)
VALUES('Suzanne Collins', 'SUA', '1962-08-10');
INSERT INTO Autori
(nume_complet, tara_origine, data_nasterii)
VALUES('Rebecca Serle', 'SUA', '1966-04-24');
INSERT INTO Autori
(nume_complet, tara_origine, data_nasterii)
VALUES('Daniel Defoe', 'Regatul Unit al Marii Britanii', '1660-09-13');
INSERT INTO Autori
(nume_complet, tara_origine, data_nasterii)
VALUES('Jojo Moyens', 'Regatul Unit al Marii Britanii', '1969-08-04');
INSERT INTO Autori
(nume_complet, tara_origine, data_nasterii)
VALUES('Steven King', 'SUA', '1947-09-21');

--Inserari in tabelul CartiAutori(asociem cartilor unul sau mai multi autori)
INSERT INTO CartiAutori
(id_carte, id_autor)
VALUES(2,6);
INSERT INTO CartiAutori
(id_carte, id_autor)
VALUES(3,4);
INSERT INTO CartiAutori
(id_carte, id_autor)
VALUES(4,7);
INSERT INTO CartiAutori
(id_carte, id_autor)
VALUES(5,9);
INSERT INTO CartiAutori
(id_carte, id_autor)
VALUES(6,8);
INSERT INTO CartiAutori
(id_carte, id_autor)
VALUES(7,2);
INSERT INTO CartiAutori
(id_carte, id_autor)
VALUES(7,5);

--Inserari de clienti in tabelul Clienti
INSERT INTO Clienti
(nume, prenume, data_nasterii)
VALUES('Constantinescu', 'Gabriela', '2000-04-24');
INSERT INTO Clienti
(nume, prenume, data_nasterii)
VALUES('Bardas', 'Alexandru', '2000-08-30');
INSERT INTO Clienti
(nume, prenume, data_nasterii)
VALUES('Costin', 'Iulia', '2000-07-26');
INSERT INTO Clienti
(nume, prenume, data_nasterii)
VALUES('Comsa', 'Mihai', '2000-06-20');
INSERT INTO Clienti
(nume, prenume, data_nasterii)
VALUES('Adam', 'Andrei', '2001-03-06');
INSERT INTO Clienti
(nume, prenume, data_nasterii)
VALUES('Cornea', 'Ciprian', '2001-06-28');
INSERT INTO Clienti
(nume, prenume)
VALUES('Boboc', 'Vlad');

--Inserari de comenzi in tabelul Comenzi
INSERT INTO Comenzi
(id_client, adresa_livrare, cod_postal, metoda_plata, stare_comanda)
VALUES(2, 'Bd. Alexandru Lapusneanu nr 102 blT16 sc A et 1 ap 6 Constanta Constanta', '900565', 'cash', 'in procesare');
INSERT INTO Comenzi
(id_client, adresa_livrare, cod_postal, metoda_plata, stare_comanda)
VALUES(5, 'Str. Pacii 103 Tulcea Tulcea', '900413', 'card', 'livrata');
INSERT INTO Comenzi
(id_client, adresa_livrare, cod_postal, metoda_plata, stare_comanda)
VALUES(2, 'Str. Memorandumului nr 7 Cluj-Napoca Cluj', '900713', 'card', 'pregatita');

--Inserari de perechi carti-comenzi in tabelul CartiComenzi in care sa se regaseasca fiecare carte din fiecare comanda
INSERT INTO CartiComenzi
(id_comanda, id_carte, nr_carti, pret)
VALUES(1, 2, 1, 100.0), (1, 3, 1, 63.3), (2, 5, 2, 49.9), (6, 6, 1, 23.9), (6, 4, 1, 39.99);

--Inserari de magazine in tabelul Magazine
INSERT INTO Magazine
(adresa, oras, judet, nr_telefon, mail)
VALUES('Bd. Tomis nr 134', 'Constanta', 'Constanta', '0730442382', 'mgz_cta@cartis.ro'),
('Str. Lujerului nr 30 parter', 'Mangalia', 'Constanta', '0721112221', 'mgz_mangalia@cartis.ro'),
('Str. Buftea nr 7', 'Cluj-Napoca', 'Cluj', '0773034540', 'mgz_cluj@cartis.ro');

--Inserari de carti si magazine in tabelul CartiMagazine (dacaexista o pereche (carte,magazin) inseamna ca acea carte este disponibila in acel magazin)
INSERT INTO CartiMagazine
(id_carte, id_magazin)
VALUES(2,1),(2,3),(3,1),(3,2),(3,3),(4,1),(6,1),(6,2),(6,3),(7,1),(7,2);

--Modificare de date
UPDATE Autori
SET tara_origine='SUA'
WHERE nume_complet='Joseph Campbell';

UPDATE Clienti
SET data_nasterii='1990-03-07'
WHERE nume='Adam' AND prenume='Andrei';

UPDATE Carti
SET disp_online=0
WHERE pret < 30.0 OR pret > 100.0;

--Stergere de date 
DELETE FROM Autori WHERE nume_complet='Steven King';
DELETE FROM Clienti WHERE data_nasterii IS NULL;