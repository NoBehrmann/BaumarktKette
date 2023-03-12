
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


DROP SCHEMA IF EXISTS `mydb` ;


CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;


CREATE TABLE IF NOT EXISTS `mydb`.`anschrift` (
  `idAnschrift` INT NOT NULL AUTO_INCREMENT,
  `land` VARCHAR(45) NOT NULL,
  `stadt` VARCHAR(45) NOT NULL,
  `plz` INT NOT NULL,
  `strasse` VARCHAR(45) NOT NULL ,
  `hausnummer` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`idAnschrift`),
  UNIQUE INDEX `idAnschrift_UNIQUE` (`idAnschrift` ASC))
ENGINE = InnoDB;

INSERT INTO anschrift(land, stadt, plz, strasse, hausnummer) VALUES 
("DE", "Hamburg", 20095, "Fährstraße", "25"),
("DE", "Luebeck", 23552, "Bleichenweg", "8"),
("NL", "Amsterdam", 1014, "Weestpoortweg", "2"),
("DK", "Hamburg", 7200, "Nygade", "22"),
("DE", "Schwerin", 19053, "Mittelweg", "135");




CREATE TABLE IF NOT EXISTS `mydb`.`umsatz` (
  `idUmsatz` INT NOT NULL AUTO_INCREMENT,
  `jahresumsatz` INT NOT NULL,
  `avgMonatsumsatz` INT NOT NULL,
  PRIMARY KEY (`idUmsatz`),
  UNIQUE INDEX `idUmsatz_UNIQUE` (`idUmsatz` ASC))
ENGINE = InnoDB;

INSERT INTO umsatz(jahresumsatz,avgmonatsumsatz) VALUES
(89111, jahresumsatz / 12),
(13223, jahresumsatz / 12),
(333, jahresumsatz / 12),
(3411, jahresumsatz / 12),
(10, jahresumsatz / 12);


CREATE TABLE IF NOT EXISTS `mydb`.`stammkunde` (
  `idKunde` INT NOT NULL AUTO_INCREMENT,
  `idAnschrift` INT NOT NULL,
  `idUmsatz` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `vorname` VARCHAR(45) NOT NULL,
  `gebDatum` DATE NOT NULL,
  `telefon` VARCHAR(50) NOT NULL,
  CONSTRAINT validTelefon
  CHECK( telefon NOT LIKE '%[^0-9]%'),
  `mobil` VARCHAR(50) NULL,
  CONSTRAINT validMobil
  CHECK ( mobil NOT LIKE '%[^0-9]%'),
  `telefax` VARCHAR(50) NULL,
  PRIMARY KEY (`idKunde`),
  UNIQUE INDEX `idKunde_UNIQUE` (`idKunde` ASC) ,
  INDEX `fk_stammdaten_anschrift1_idx` (`idAnschrift` ASC) ,
  INDEX `fk_stammkunde_umsatz1_idx` (`idUmsatz` ASC) ,
  UNIQUE INDEX `idUmsatz_UNIQUE` (`idUmsatz` ASC) ,
  CONSTRAINT `fk_stammdaten_anschrift1`
    FOREIGN KEY (`idAnschrift`)
    REFERENCES `mydb`.`anschrift` (`idAnschrift`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_stammkunde_umsatz1`
    FOREIGN KEY (`idUmsatz`)
    REFERENCES `mydb`.`umsatz` (`idUmsatz`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

INSERT INTO stammkunde(idAnschrift, idUmsatz, name, vorname, gebDatum,telefon,mobil,telefax) VALUES
(3, 55,"Toni", "Sheena",'1968-11-11',"0453165972","0679862",NULL),
(443, 33,"Hannah", "Sheena",'2000-12-4',"1276414",NULL,NULL),
(2, 1,"Jonas", "Theo",'2005-5-30',"7609326",NULL,"097637"),
(4, 51,"Riku" ,"Arnda",'1983-3-05',"786903837","245907",NULL),
(5, 4,"Min", "Shion",'1990-2-28',"8739082","765098534","6148");



CREATE TABLE IF NOT EXISTS `mydb`.`baumarkt` (
  `idBaumarkt` INT NOT NULL AUTO_INCREMENT,
  `idAnschrift` INT NOT NULL,
  `idUmsatz` INT NOT NULL,
  `besitzer` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idBaumarkt`),
  UNIQUE INDEX `idBaumarkt_UNIQUE` (`idBaumarkt` ASC) ,
  INDEX `fk_baumarkt_anschrift1_idx` (`idAnschrift` ASC) ,
  INDEX `fk_baumarkt_Umsatz1_idx` (`idUmsatz` ASC) ,
  UNIQUE INDEX `idUmsatz_UNIQUE` (`idUmsatz` ASC) ,
  CONSTRAINT `fk_baumarkt_anschrift1`
    FOREIGN KEY (`idAnschrift`)
    REFERENCES `mydb`.`anschrift` (`idAnschrift`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_baumarkt_Umsatz1`
    FOREIGN KEY (`idUmsatz`)
    REFERENCES `mydb`.`umsatz` (`idUmsatz`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

INSERT INTO baumarkt(idAnschrift, idUmsatz, besitzer) VALUES
(1, 3, "Hans Zommerhaus"),
(2, 2, "Rosa Blume"),
(190, 271, "Emma Liam"),
(27412, 999, " Lego Las"),
(43, 21, " Bilbo Beutlin");


CREATE TABLE IF NOT EXISTS `mydb`.`artikelTyp` (
  `idArtikelTyp` INT NOT NULL AUTO_INCREMENT,
  `idUmsatz` INT NOT NULL,
  `artikeltypName` VARCHAR(80) NOT NULL,
  INDEX `fk_artikelTyp_umsatz1_idx` (`idUmsatz` ASC) ,
  PRIMARY KEY (`idArtikelTyp`),
  UNIQUE INDEX `idArtikelTyp_UNIQUE` (`idArtikelTyp` ASC) ,
  UNIQUE INDEX `artikeltypName_UNIQUE` (`artikeltypName` ASC) ,
  CONSTRAINT `fk_artikelTyp_umsatz1`
    FOREIGN KEY (`idUmsatz`)
    REFERENCES `mydb`.`umsatz` (`idUmsatz`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

INSERT INTO artikelTyp(artikeltypName, idUmsatz) VALUES
("Hammer", 5),
("Zange",743),
("Bohrmaschine", 82713),
("Schraubendreher",5245),
("Nagel",12344);



CREATE TABLE IF NOT EXISTS `mydb`.`artikel` (
  `idArtikel` INT NOT NULL AUTO_INCREMENT,
  `idArtikelTyp` INT NOT NULL,
  `artikelName` VARCHAR(100) NOT NULL,
  `gewichtInKilos` DECIMAL(5,2) NULL,
  `material` VARCHAR(40) NULL,
  `verkaufspreis` DECIMAL(6,2) NOT NULL,
  INDEX `fk_artikel_artikelTyp1_idx` (`idArtikelTyp` ASC) ,
  PRIMARY KEY (`idArtikel`, `idArtikelTyp`),
  CONSTRAINT `fk_artikel_artikelTyp1`
    FOREIGN KEY (`idArtikelTyp`)
    REFERENCES `mydb`.`artikelTyp` (`idArtikelTyp`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

INSERT INTO artikel(idArtikelTyp, artikelName, gewichtInKilos, material, verkaufspreis) VALUES
(1, "Vorschlaghammer mit Hülse", 5, "Hickory", 54.90),
(2, "Profilverbindunszange 270mm", NULL, "Stahl", 28.40),
(3, "Tischbohrmaschine Bosch PBD 40",NULL, NULL, 255),
(4, "Schraubendreher Set Witte VDE 6-tlg", NULL, "Chom-Vanadium-Stahl",18.75),
(5, "Drahtstife Senkkopf 7,6 x 230 mm", NULL, "Drath",9.95),
(1, "Vorschlaghammer xy", 8.5, "Eiche", 54.90);


CREATE TABLE IF NOT EXISTS `mydb`.`retoure` (
  `idretoure` INT NOT NULL AUTO_INCREMENT,
  `idKunde` INT NOT NULL,
  `idArtikel` INT NOT NULL,
  `grund` VARCHAR(100) NULL,
  `datum` DATE NULL,
  PRIMARY KEY (`idretoure`, `idKunde`, `idArtikel`),
  INDEX `fk_retoure_stammkunde1_idx` (`idKunde` ASC) ,
  INDEX `fk_retoure_artikel1_idx` (`idArtikel` ASC) ,
  CONSTRAINT `fk_retoure_stammkunde1`
    FOREIGN KEY (`idKunde`)
    REFERENCES `mydb`.`stammkunde` (`idKunde`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_retoure_artikel1`
    FOREIGN KEY (`idArtikel`)
    REFERENCES `mydb`.`artikel` (`idArtikel`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

INSERT INTO retoure(idKunde, idArtikel, grund, datum) VALUES	
(5, 5, "Drecks Ding funktioniert nicht",'2022-9-19'),
(5, 4, NULL,'2022-10-8'),
(2, 3, " ",'2022-5-4'),
(1, 2, "Nie wieder werde ich bei Ihnen einkaufen, absoluter Müll!!!",'2022-7-7'),
(4, 1, NULL,'2022-3-15');

CREATE TABLE IF NOT EXISTS `mydb`.`baumarktArtikel` (
  `idBaumarkt` INT NOT NULL,
  `idArtikel` INT NOT NULL,
  `idArtikelTyp` INT NOT NULL,
  `stueckzahl` INT NOT NULL,
  INDEX `fk_baumarkt_has_artikel_baumarkt1_idx` (`idBaumarkt` ASC) ,
  INDEX `fk_baumarktArtikel_artikel1_idx` (`idArtikel` ASC, `idArtikelTyp` ASC) ,
  PRIMARY KEY (`idBaumarkt`, `idArtikel`, `idArtikelTyp`),
  CONSTRAINT `fk_baumarkt_has_artikel_baumarkt1`
    FOREIGN KEY (`idBaumarkt`)
    REFERENCES `mydb`.`baumarkt` (`idBaumarkt`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_baumarktArtikel_artikel1`
    FOREIGN KEY (`idArtikel` , `idArtikelTyp`)
    REFERENCES `mydb`.`artikel` (`idArtikel` , `idArtikelTyp`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

INSERT INTO baumarktArtikel VALUES
(3, 1, 1, 200),
(1, 2, 2, 0),
(1, 3, 3, 2),
(1, 4, 4, 500),
(1, 5, 5, 4832),
(2, 5, 5, 99999);



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
