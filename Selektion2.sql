USE mydb;
-- Alle in Baumarkt #1 vorhandenen artikel mit stueckzahl. AS;INNER JOIN;
SELECT artikel.artikelName, baumarktArtikel.stueckzahl, CONCAT(artikel.verkaufspreis,' €') AS verkaufspreis
FROM artikel
INNER JOIN baumarktartikel
ON baumarktArtikel.idArtikel = artikel.idArtikel
WHERE baumarktArtikel.idBaumarkt = 1;

-- Alle stammkunden anschriften außer Daenemark RIGHT JOIN;ORDER BY;
SELECT stammKunde.name, stammKunde.vorname, anschrift.land, anschrift.stadt, anschrift.plz, anschrift.strasse, stammKunde.telefon
FROM anschrift
RIGHT JOIN stammKunde
ON stammkunde.idAnschrift = anschrift.idAnschrift
WHERE NOT land = "DK"
ORDER BY stammKunde.name;


-- unionisiert stammkundenen namen mit besitzern wober nur bestimmte namen genommen werden. UNION;LIKE;
SELECT name
FROM stammKunde
WHERE name LIKE '%i%a'
UNION
SELECT besitzer FROM baumarkt
WHERE besitzer LIKE '%_i%';


-- Zeigt stammkunden namen und geburtsjahr an welche KEINE retoure getätigt haben SUBSTRING;IN
SELECT vorname, name, Substring(gebDatum, 1, 4) AS geburtsjahr, telefon
FROM stammKunde
WHERE idKunde NOT IN (Select idKunde FROM retoure);

-- anzahl von staedten in stammkunde COUNT;GROUP BY;HAVING
SELECT stadt, count(stadt) AS anzahl
FROM anschrift
LEFT JOIN stammkunde
USING (idAnschrift)
GROUP BY stadt
HAVING stadt NOT LIKE "luebeck"
ORDER BY anzahl DESC



