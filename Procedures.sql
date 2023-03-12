USE mydb;
 
DROP PROCEDURE IF EXISTS getNagel;
DELIMITER $$
CREATE PROCEDURE `getNagel`()
BEGIN
	SELECT at.artikeltypName, a.artikelName, CONCAT(a.verkaufspreis," €") AS verkaufspreis
	FROM artikeltyp at
	LEFT JOIN artikel a
	ON a.idArtikeltyp = at.idArtikeltyp
WHERE at.artikeltypName LIKE "Nagel";
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS insertAnschrift;
DELIMITER $$
CREATE PROCEDURE insertAnschrift(land Varchar(45),stadt Varchar(70),plz int,strasse Varchar(45),hausnummer Varchar(10))
BEGIN
INSERT INTO anschrift(land,stadt,plz,strasse,hausnummer)
        VALUES
        (land,stadt,plz,strasse,hausnummer);
	IF LENGTH(stadt) OR LENGTH(strasse) <= 30 THEN 
		ROLLBACK;
	END IF;
END $$
DELIMITER ;

START TRANSACTION;
CALL insertAnschrift("Wales","Llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch",12345,"Lon Refail","3B");
CALL getNagel();
COMMIT;

