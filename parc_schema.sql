-- =====================================================================
--  R3.10 · Gestion d'un système de bases de données · IUT de Roanne
--  TD MySQL : base « parc » (inventaire du réseau d'un opérateur)
--  Fichier 1/2 : modèle de données (structure seule, aucune donnée)
--
--  Entreprise FICTIVE : OFR, Opérateur Fibre Roannais
--  Compatible MySQL 8.0 et 8.4 (moteur InnoDB, jeu de caractères utf8mb4)
--
--  Import (sur le serveur) :   sudo mysql < parc_schema.sql
-- =====================================================================

-- Recrée la base de zéro : à n'exécuter que sur la VM de TD !
DROP DATABASE IF EXISTS parc;
CREATE DATABASE parc
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE parc;

-- ---------------------------------------------------------------------
-- 1. SITE : les implantations de l'entreprise
-- ---------------------------------------------------------------------
CREATE TABLE site (
  id_site        SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  code           CHAR(3)      NOT NULL,              -- ex. ROA, STE
  nom            VARCHAR(80)  NOT NULL,
  type_site      ENUM('siege','datacenter','pop','agence') NOT NULL,
  adresse        VARCHAR(120) NOT NULL,
  code_postal    CHAR(5)      NOT NULL,
  ville          VARCHAR(60)  NOT NULL,
  date_ouverture DATE         NOT NULL,
  CONSTRAINT pk_site PRIMARY KEY (id_site),
  CONSTRAINT uq_site_code UNIQUE (code),
  CONSTRAINT ck_site_code CHECK (REGEXP_LIKE(code, '^[A-Z]{3}$', 'c')),
  CONSTRAINT ck_site_cp   CHECK (REGEXP_LIKE(code_postal, '^[0-9]{5}$'))
) ENGINE=InnoDB COMMENT='Implantations (siège, datacenters, points de présence)';

-- ---------------------------------------------------------------------
-- 2. FABRICANT : constructeurs des équipements
-- ---------------------------------------------------------------------
CREATE TABLE fabricant (
  id_fabricant SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nom          VARCHAR(60)  NOT NULL,
  site_web     VARCHAR(120) NULL,
  CONSTRAINT pk_fabricant PRIMARY KEY (id_fabricant),
  CONSTRAINT uq_fabricant_nom UNIQUE (nom)
) ENGINE=InnoDB COMMENT='Constructeurs';

-- ---------------------------------------------------------------------
-- 3. TYPE_EQUIPEMENT : catégories (routeur, commutateur…)
-- ---------------------------------------------------------------------
CREATE TABLE type_equipement (
  id_type  TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  libelle  VARCHAR(40) NOT NULL,
  CONSTRAINT pk_type_equipement PRIMARY KEY (id_type),
  CONSTRAINT uq_type_libelle UNIQUE (libelle)
) ENGINE=InnoDB COMMENT='Catégories d''équipements';

-- ---------------------------------------------------------------------
-- 4. TECHNICIEN : le personnel qui intervient sur le parc
-- ---------------------------------------------------------------------
CREATE TABLE technicien (
  id_technicien SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  nom           VARCHAR(60)  NOT NULL,
  prenom        VARCHAR(60)  NOT NULL,
  email         VARCHAR(120) NOT NULL,
  id_site       SMALLINT UNSIGNED NOT NULL,           -- site de rattachement
  actif         BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT pk_technicien PRIMARY KEY (id_technicien),
  CONSTRAINT uq_technicien_email UNIQUE (email),
  CONSTRAINT ck_technicien_email CHECK (email LIKE '%_@_%._%'),
  CONSTRAINT fk_technicien_site FOREIGN KEY (id_site)
    REFERENCES site (id_site)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='Techniciens réseau';

-- ---------------------------------------------------------------------
-- 5. EQUIPEMENT : la table centrale de l'inventaire
-- ---------------------------------------------------------------------
CREATE TABLE equipement (
  id_equipement     INT UNSIGNED NOT NULL AUTO_INCREMENT,
  hostname          VARCHAR(63)  NOT NULL,            -- nom DNS de l'équipement
  numero_serie      VARCHAR(40)  NOT NULL,
  modele            VARCHAR(60)  NOT NULL,
  id_type           TINYINT UNSIGNED  NOT NULL,
  id_fabricant      SMALLINT UNSIGNED NOT NULL,
  id_site           SMALLINT UNSIGNED NOT NULL,
  ip_admin          VARCHAR(15)  NULL,                -- adresse d'administration
  statut            ENUM('en_stock','en_service','en_panne','reforme')
                    NOT NULL DEFAULT 'en_stock',
  date_achat        DATE NOT NULL,
  date_mise_service DATE NULL,
  fin_garantie      DATE NULL,
  CONSTRAINT pk_equipement PRIMARY KEY (id_equipement),
  CONSTRAINT uq_equipement_hostname UNIQUE (hostname),
  CONSTRAINT uq_equipement_serie    UNIQUE (numero_serie),
  CONSTRAINT uq_equipement_ip       UNIQUE (ip_admin),
  CONSTRAINT ck_equipement_ip CHECK (
    ip_admin IS NULL
    OR REGEXP_LIKE(ip_admin, '^([0-9]{1,3}[.]){3}[0-9]{1,3}$')),
  CONSTRAINT ck_equipement_dates CHECK (
    date_mise_service IS NULL OR date_mise_service >= date_achat),
  CONSTRAINT ck_equipement_service CHECK (
    statut <> 'en_service' OR date_mise_service IS NOT NULL),
  CONSTRAINT fk_equipement_type FOREIGN KEY (id_type)
    REFERENCES type_equipement (id_type)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_equipement_fabricant FOREIGN KEY (id_fabricant)
    REFERENCES fabricant (id_fabricant)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_equipement_site FOREIGN KEY (id_site)
    REFERENCES site (id_site)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  INDEX ix_equipement_statut (statut),
  INDEX ix_equipement_garantie (fin_garantie)
) ENGINE=InnoDB COMMENT='Inventaire des équipements';

-- ---------------------------------------------------------------------
-- 6. INTERFACE : ports réseau d'un équipement
--    Supprimer un équipement supprime ses interfaces (ON DELETE CASCADE)
-- ---------------------------------------------------------------------
CREATE TABLE interface (
  id_interface   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_equipement  INT UNSIGNED NOT NULL,
  nom            VARCHAR(40)  NOT NULL,               -- ex. Gi1/0/1, xe-0/0/0
  adresse_mac    CHAR(17)     NULL,
  vitesse_mbps   INT UNSIGNED NOT NULL,
  etat           ENUM('up','down','admin_down') NOT NULL DEFAULT 'down',
  description    VARCHAR(120) NULL,
  CONSTRAINT pk_interface PRIMARY KEY (id_interface),
  CONSTRAINT uq_interface_nom UNIQUE (id_equipement, nom),
  CONSTRAINT uq_interface_mac UNIQUE (adresse_mac),
  CONSTRAINT ck_interface_mac CHECK (
    adresse_mac IS NULL
    OR REGEXP_LIKE(adresse_mac, '^([0-9a-f]{2}:){5}[0-9a-f]{2}$', 'c')),
  CONSTRAINT ck_interface_vitesse CHECK (vitesse_mbps BETWEEN 10 AND 400000),
  CONSTRAINT fk_interface_equipement FOREIGN KEY (id_equipement)
    REFERENCES equipement (id_equipement)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Interfaces réseau';

-- ---------------------------------------------------------------------
-- 7. VLAN
-- ---------------------------------------------------------------------
CREATE TABLE vlan (
  id_vlan  SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  numero   SMALLINT UNSIGNED NOT NULL,                -- 802.1Q : 1 à 4094
  nom      VARCHAR(40) NOT NULL,
  reseau   VARCHAR(18) NOT NULL,                      -- notation CIDR
  CONSTRAINT pk_vlan PRIMARY KEY (id_vlan),
  CONSTRAINT uq_vlan_numero UNIQUE (numero),
  CONSTRAINT ck_vlan_numero CHECK (numero BETWEEN 1 AND 4094),
  CONSTRAINT ck_vlan_reseau CHECK (
    REGEXP_LIKE(reseau, '^([0-9]{1,3}[.]){3}[0-9]{1,3}/[0-9]{1,2}$'))
) ENGINE=InnoDB COMMENT='VLAN de l''entreprise';

-- ---------------------------------------------------------------------
-- 8. INTERFACE_VLAN : association plusieurs-à-plusieurs
--    (un port trunk porte plusieurs VLAN, un VLAN passe sur plusieurs ports)
-- ---------------------------------------------------------------------
CREATE TABLE interface_vlan (
  id_interface INT UNSIGNED      NOT NULL,
  id_vlan      SMALLINT UNSIGNED NOT NULL,
  mode         ENUM('access','trunk') NOT NULL,
  CONSTRAINT pk_interface_vlan PRIMARY KEY (id_interface, id_vlan),
  CONSTRAINT fk_ifvlan_interface FOREIGN KEY (id_interface)
    REFERENCES interface (id_interface)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_ifvlan_vlan FOREIGN KEY (id_vlan)
    REFERENCES vlan (id_vlan)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB COMMENT='Affectation des VLAN aux interfaces';

-- ---------------------------------------------------------------------
-- 9. INTERVENTION : historique (installation, panne, maintenance…)
--    ON DELETE RESTRICT : on ne peut pas effacer un équipement
--    qui a un historique d'interventions (traçabilité).
-- ---------------------------------------------------------------------
CREATE TABLE intervention (
  id_intervention   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_equipement     INT UNSIGNED      NOT NULL,
  id_technicien     SMALLINT UNSIGNED NOT NULL,
  date_intervention DATETIME NOT NULL,
  type_intervention ENUM('installation','maintenance','panne',
                         'remplacement','mise_a_jour') NOT NULL,
  description       VARCHAR(255) NOT NULL,
  duree_minutes     SMALLINT UNSIGNED NOT NULL,
  CONSTRAINT pk_intervention PRIMARY KEY (id_intervention),
  CONSTRAINT ck_intervention_duree CHECK (duree_minutes BETWEEN 1 AND 1440),
  CONSTRAINT fk_intervention_equipement FOREIGN KEY (id_equipement)
    REFERENCES equipement (id_equipement)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_intervention_technicien FOREIGN KEY (id_technicien)
    REFERENCES technicien (id_technicien)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  INDEX ix_intervention_date (date_intervention)
) ENGINE=InnoDB COMMENT='Historique des interventions';

-- ---------------------------------------------------------------------
-- VUE : équipements en service, lisible par un humain
--   SQL SECURITY INVOKER : la vue s'exécute avec les droits de celui
--   qui l'interroge (et non ceux de son créateur).
-- ---------------------------------------------------------------------
CREATE SQL SECURITY INVOKER VIEW v_equipements_en_service AS
SELECT e.hostname,
       t.libelle  AS type,
       f.nom      AS fabricant,
       e.modele,
       s.code     AS site,
       e.ip_admin,
       e.date_mise_service,
       e.fin_garantie
FROM equipement e
JOIN type_equipement t ON t.id_type      = e.id_type
JOIN fabricant       f ON f.id_fabricant = e.id_fabricant
JOIN site            s ON s.id_site      = e.id_site
WHERE e.statut = 'en_service';

-- Contrôle rapide : doit afficher 9 tables et 1 vue
SHOW FULL TABLES;
