CREATE DATABASE Cartis;
USE Cartis;

--Tabelul Carti
CREATE TABLE Carti
(id_carte INT IDENTITY(1,1),
titlu VARCHAR(100),
an_publicatie INT,
editura VARCHAR(30),
categorie VARCHAR(30),
disp_online BIT,
CONSTRAINT pk_carti PRIMARY KEY (id_carte)
);

--Tabelul Autori
CREATE TABLE Autori
(id_autor INT IDENTITY(1,1),
nume_complet VARCHAR(50)
CONSTRAINT pk_autori PRIMARY KEY(id_autor)
);

--Tabelul Clienti
CREATE TABLE Clienti
(id_client INT IDENTITY(1,1),
nume VARCHAR(20),
prenume VARCHAR(30),
data_nasterii DATE
CONSTRAINT pk_clienti PRIMARY KEY(id_client)
);

--Tabelul Comenzi
CREATE TABLE Comenzi
(id_comanda INT IDENTITY(1,1),
id_client INT,
adresa_livrare VARCHAR(100),
cod_postal VARCHAR(6),
metoda_plata VARCHAR(4),
stare_comanda VARCHAR(15),
CONSTRAINT pk_comenzi PRIMARY KEY(id_comanda),
CONSTRAINT fk_client FOREIGN KEY (id_client) REFERENCES Clienti(id_client),
CONSTRAINT ck_metoda_plata CHECK (metoda_plata IN ('cash','card')),
CONSTRAINT ck_stare_comanda CHECK (stare_comanda IN('in procesare', 'preluata', 'pregatita', 'predata curierului', 'livrata'))
);

--Tabelul Magazine
CREATE TABLE Magazine
(id_magazin INT IDENTITY(1,1),
adresa VARCHAR(50),
oras VARCHAR(20),
judet VARCHAR(15),
nr_telefon VARCHAR(10),
mail VARCHAR(50),
CONSTRAINT pk_magazine PRIMARY KEY (id_magazin)
);

--Relatie n-m intre Carti si Autori
--Tabelul CartiAutori
CREATE TABLE CartiAutori
(id_carte INT FOREIGN KEY REFERENCES Carti(id_carte),
id_autor INT FOREIGN KEY REFERENCES Autori(id_autor),
CONSTRAINT pk_CartiAutori PRIMARY KEY (id_carte, id_autor)
);

--Relatie n-m intre Carti si Magazine
--Tabelul CartiMagazine
CREATE TABLE CartiMagazine
(id_carte INT FOREIGN KEY REFERENCES Carti(id_carte),
id_magazin INT FOREIGN KEY REFERENCES Magazine(id_magazin),
CONSTRAINT pk_CartiMagazine PRIMARY KEY (id_carte, id_magazin)
);

--Modificari
USE Cartis;
--Relatie n-m intre Carti si Comenzi
--Tabelul CartiComenzi
CREATE TABLE CartiComenzi
(id_comanda INT FOREIGN KEY REFERENCES Comenzi(id_comanda),
id_carte INT FOREIGN KEY REFERENCES Carti(id_carte),
nr_carti INT,
CONSTRAINT pk_CartiComenzi PRIMARY KEY (id_comanda, id_carte)
);

--Adaugare coloana pret la tabelul Carti
ALTER TABLE Carti
ADD pret FLOAT;

--Adaugare coloana tara_origine, data_nasterii la tabelul Autori
ALTER  TABLE Autori
ADD tara_origine VARCHAR(30);
ALTER TABLE Autori
ADD data_nasterii DATE;

--Adaugare coloana pret_carte la tabelul CartiComenzi
ALTER TABLE CartiComenzi
ADD pret FLOAT;