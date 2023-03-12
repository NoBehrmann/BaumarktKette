
-- erzeugt view welche artikelpreise von 9-20€ ausgibt außegenommen arikel mit der artikeltyp ID 2
CREATE OR REPLACE VIEW artikelpreise
AS
SELECT artikelName, verkaufspreis
FROM artikel
WHERE idArtikeltyp != 2 AND verkaufspreis BETWEEN 9 AND 20;

-- insertes "Buntstiftmix"
INSERT INTO artikelpreise(artikelName,verkaufspreis)
VALUES
("Buntstift Mix",5.99);

-- updates "Buntstift mix" zu "Buntstift Mix 5er Set"
UPDATE artikelpreise SET artikelname = "Buntstift Mix 5er Set" AND verkaufspreis = 6 WHERE artikelName = "Buntstift Mix";

SELECT * FROM artikelpreise;



-- gibt aus welche Kunden bereits eine retoure zu einem Schraubendreher gestellt haben und wann.
CREATE OR REPLACE VIEW KundenRetourechecker
AS
SELECT s.idKunde, s.vorname, s.name, r.datum
FROM retoure r
JOIN stammkunde s ON r.idKunde = s.idKunde
JOIN artikel a on  r.idArtikel = a.idArtikel
WHERE artikelName LIKE "Schraubendreher Set Witte VDE 6-tlg";

-- Inserts "Tim Klipp" mit values 
INSERT INTO KundenRetourechecker(idKunde,vorname,name) VALUES (10,"Tim","Klipp");
INSERT INTO KundenRetourechecker(idRetoure,idArtikel,idKunde,datum) VALUES (99,42,10,"2022-08-01");

-- updated "Tim" mit dem namen Thomas
UPDATE KundenRetourechecker SET vorname = "Thomas" WHERE idKunde = 10;

SELECT * FROM kundenretourechecker