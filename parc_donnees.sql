-- =====================================================================
--  R3.10 · TD MySQL · base « parc »
--  Fichier 2/2 : données de l'entreprise FICTIVE « OFR, Opérateur Fibre
--  Roannais », puis mises à jour qui simulent la vie du parc.
--
--  Prérequis : parc_schema.sql déjà importé.
--  Import    : sudo mysql parc < parc_donnees.sql
--  Toutes les personnes, adresses et numéros de série sont inventés.
--  Domaine e-mail réservé à la documentation : ofr.example (RFC 2606).
-- =====================================================================

USE parc;
SET NAMES utf8mb4;

-- ---------------------------------------------------------------------
-- PARTIE A : état initial du parc
-- ---------------------------------------------------------------------
START TRANSACTION;

INSERT INTO site (code, nom, type_site, adresse, code_postal, ville, date_ouverture) VALUES
  ('ROA', 'Siège et centre de supervision', 'siege', '12 rue de la Fibre', '42300', 'Roanne', '2018-03-01'),
  ('STE', 'Datacenter Saint-Étienne', 'datacenter', '4 allée des Serveurs', '42000', 'Saint-Étienne', '2019-06-15'),
  ('LYO', 'Datacenter Lyon', 'datacenter', '27 quai du Backbone', '69007', 'Lyon', '2021-01-11'),
  ('FEU', 'Point de présence Feurs', 'pop', '3 chemin du Répartiteur', '42110', 'Feurs', '2022-09-05');

INSERT INTO fabricant (nom, site_web) VALUES
  ('Cisco', 'https://www.cisco.com'),
  ('Juniper Networks', 'https://www.juniper.net'),
  ('Fortinet', 'https://www.fortinet.com'),
  ('HPE Aruba Networking', 'https://www.arubanetworks.com'),
  ('Dell Technologies', 'https://www.dell.com'),
  ('Schneider Electric (APC)', 'https://www.apc.com'),
  ('MikroTik', 'https://mikrotik.com');

INSERT INTO type_equipement (libelle) VALUES
  ('Routeur'),
  ('Commutateur'),
  ('Pare-feu'),
  ('Borne Wi-Fi'),
  ('Serveur'),
  ('Onduleur');

INSERT INTO technicien (nom, prenom, email, id_site) VALUES
  ('Martin', 'Léa', 'lea.martin@ofr.example', 1),
  ('Bernard', 'Hugo', 'hugo.bernard@ofr.example', 1),
  ('Dubois', 'Inès', 'ines.dubois@ofr.example', 2),
  ('Moreau', 'Karim', 'karim.moreau@ofr.example', 2),
  ('Laurent', 'Chloé', 'chloe.laurent@ofr.example', 3),
  ('Girard', 'Tom', 'tom.girard@ofr.example', 4);

INSERT INTO vlan (numero, nom, reseau) VALUES
  (10, 'ADMINISTRATIF', '10.10.10.0/24'),
  (20, 'SERVEURS', '10.10.20.0/24'),
  (30, 'VOIX-IP', '10.10.30.0/24'),
  (40, 'WIFI-PERSONNEL', '10.10.40.0/24'),
  (50, 'WIFI-INVITES', '172.16.50.0/24'),
  (99, 'MANAGEMENT', '10.99.0.0/16');

-- Équipements : id_type, id_fabricant et id_site renvoient aux tables ci-dessus
INSERT INTO equipement (hostname, numero_serie, modele, id_type, id_fabricant, id_site,
                        ip_admin, statut, date_achat, date_mise_service, fin_garantie) VALUES
  ('rtr-roa-01', 'FOCCC9B5D82F', 'ISR 4331', 1, 1, 1, '10.99.1.10', 'en_service', '2021-02-10', '2021-03-03', '2026-02-10'),
  ('fw-roa-01', 'FG5026DB118', 'FortiGate 100F', 3, 3, 1, '10.99.1.11', 'en_service', '2022-04-04', '2022-04-25', '2025-04-04'),
  ('sw-roa-core-01', 'FOC10E7CDA68', 'Catalyst 9300-48P', 2, 1, 1, '10.99.1.12', 'en_service', '2021-02-10', '2021-03-03', '2026-02-10'),
  ('sw-roa-acc-01', 'FOCA3E88620E', 'Catalyst 9200L-24P-4G', 2, 1, 1, '10.99.1.13', 'en_service', '2021-03-22', '2021-04-12', '2026-03-22'),
  ('sw-roa-acc-02', 'FOC65C206686', 'Catalyst 9200L-24P-4G', 2, 1, 1, '10.99.1.14', 'en_service', '2021-03-22', '2021-04-12', '2026-03-22'),
  ('sw-roa-acc-03', 'FOCB030E8413', 'Catalyst 9200L-24P-4G', 2, 1, 1, '10.99.1.15', 'en_service', '2021-03-22', '2021-04-12', '2026-03-22'),
  ('ap-roa-01', 'CNR06DD302CE', 'AP-535', 4, 4, 1, '10.99.1.16', 'en_service', '2023-01-16', '2023-02-06', '2026-01-16'),
  ('ap-roa-02', 'CNR37D4330F5', 'AP-535', 4, 4, 1, '10.99.1.17', 'en_service', '2023-01-16', '2023-02-06', '2026-01-16'),
  ('ap-roa-03', 'CNRA3BDA3650', 'AP-535', 4, 4, 1, '10.99.1.18', 'en_service', '2023-01-16', '2023-02-06', '2026-01-16'),
  ('ap-roa-04', 'CNR0607696B5', 'AP-535', 4, 4, 1, '10.99.1.19', 'en_service', '2023-01-16', '2023-02-06', '2026-01-16'),
  ('srv-roa-01', 'DL2B0E9D873', 'PowerEdge R650', 5, 5, 1, '10.99.1.20', 'en_service', '2022-11-07', '2022-11-28', '2025-11-07'),
  ('ups-roa-01', 'ASD6307604A', 'Smart-UPS SRT 3000VA', 6, 6, 1, '10.99.1.21', 'en_service', '2020-05-18', '2020-06-08', '2023-05-18'),
  ('rtr-ste-01', 'JN0165C7486', 'MX204', 1, 2, 2, '10.99.2.10', 'en_service', '2020-09-14', '2020-10-05', '2025-09-14'),
  ('fw-ste-01', 'FGCA2CB2955', 'FortiGate 600F', 3, 3, 2, '10.99.2.11', 'en_service', '2023-03-06', '2023-03-27', '2026-03-06'),
  ('sw-ste-core-01', 'JNBB5331C66', 'QFX5120-48Y', 2, 2, 2, '10.99.2.12', 'en_service', '2020-09-14', '2020-10-05', '2025-09-14'),
  ('rtr-ste-02', 'JN3AAD0C52A', 'MX204', 1, 2, 2, '10.99.2.13', 'en_service', '2020-09-14', '2020-10-05', '2025-09-14'),
  ('fw-ste-02', 'FG6B6D55653', 'FortiGate 600F', 3, 3, 2, '10.99.2.14', 'en_service', '2023-03-06', '2023-03-27', '2026-03-06'),
  ('sw-ste-core-02', 'JNE6DB2AA29', 'QFX5120-48Y', 2, 2, 2, '10.99.2.15', 'en_service', '2020-09-14', '2020-10-05', '2025-09-14'),
  ('sw-ste-tor-01', 'JNCF0D868BD', 'EX4300-48T', 2, 2, 2, '10.99.2.16', 'en_service', '2019-07-01', '2019-07-22', '2024-07-01'),
  ('sw-ste-tor-02', 'JNFEA7CFE08', 'EX4300-48T', 2, 2, 2, '10.99.2.17', 'en_service', '2019-07-01', '2019-07-22', '2024-07-01'),
  ('sw-ste-tor-03', 'JN4662DC496', 'EX4300-48T', 2, 2, 2, '10.99.2.18', 'en_service', '2019-07-01', '2019-07-22', '2024-07-01'),
  ('sw-ste-tor-04', 'JN990F29665', 'EX4300-48T', 2, 2, 2, '10.99.2.19', 'en_service', '2019-07-01', '2019-07-22', '2024-07-01'),
  ('srv-ste-01', 'DLFF53D50D6', 'PowerEdge R760', 5, 5, 2, '10.99.2.20', 'en_service', '2024-02-12', '2024-03-04', '2027-02-12'),
  ('srv-ste-02', 'DL2837FAA71', 'PowerEdge R760', 5, 5, 2, '10.99.2.21', 'en_service', '2024-02-12', '2024-03-04', '2027-02-12'),
  ('srv-ste-03', 'DLBCCF7FACE', 'PowerEdge R760', 5, 5, 2, '10.99.2.22', 'en_service', '2024-02-12', '2024-03-04', '2027-02-12'),
  ('srv-ste-04', 'DL794FFD1E6', 'PowerEdge R760', 5, 5, 2, '10.99.2.23', 'en_service', '2024-02-12', '2024-03-04', '2027-02-12'),
  ('ups-ste-01', 'AS2BD930DC9', 'Smart-UPS SRT 10000VA', 6, 6, 2, '10.99.2.24', 'en_service', '2019-07-01', '2019-07-22', '2024-07-01'),
  ('ups-ste-02', 'AS087FE0CF0', 'Smart-UPS SRT 10000VA', 6, 6, 2, '10.99.2.25', 'en_service', '2019-07-01', '2019-07-22', '2024-07-01'),
  ('rtr-lyo-01', 'JN645AC126E', 'MX204', 1, 2, 3, '10.99.3.10', 'en_service', '2021-01-04', '2021-01-25', '2026-01-04'),
  ('fw-lyo-01', 'FGD08B614E9', 'FortiGate 600F', 3, 3, 3, '10.99.3.11', 'en_service', '2023-03-06', '2023-03-27', '2026-03-06'),
  ('sw-lyo-core-01', 'JNEA466711A', 'QFX5120-48Y', 2, 2, 3, '10.99.3.12', 'en_service', '2021-01-04', '2021-01-25', '2026-01-04'),
  ('sw-lyo-tor-01', 'JN880D1A091', 'EX4300-48T', 2, 2, 3, '10.99.3.13', 'en_service', '2021-01-04', '2021-01-25', '2026-01-04'),
  ('srv-lyo-01', 'DL956CEF8CB', 'PowerEdge R760', 5, 5, 3, '10.99.3.14', 'en_service', '2024-02-12', '2024-03-04', '2027-02-12'),
  ('sw-lyo-tor-02', 'JN8B46FF021', 'EX4300-48T', 2, 2, 3, '10.99.3.15', 'en_service', '2021-01-04', '2021-01-25', '2026-01-04'),
  ('srv-lyo-02', 'DLB0C61BB20', 'PowerEdge R760', 5, 5, 3, '10.99.3.16', 'en_service', '2024-02-12', '2024-03-04', '2027-02-12'),
  ('ups-lyo-01', 'AS53D429A4D', 'Smart-UPS SRT 10000VA', 6, 6, 3, '10.99.3.17', 'en_service', '2021-01-04', '2021-01-25', '2026-01-04'),
  ('rtr-feu-01', 'HE908D1B253', 'CCR2004-16G-2S+', 1, 7, 4, '10.99.4.10', 'en_service', '2022-08-22', '2022-09-12', '2024-08-22'),
  ('sw-feu-01', 'HEC1296DA32', 'CRS326-24G-2S+RM', 2, 7, 4, '10.99.4.11', 'en_service', '2022-08-22', '2022-09-12', '2024-08-22'),
  ('ups-feu-01', 'AS9FADEE943', 'Smart-UPS SRT 1500VA', 6, 6, 4, '10.99.4.12', 'en_service', '2022-08-22', '2022-09-12', '2025-08-22'),
  ('sw-stock-01', 'FOC85A8896A6', 'Catalyst 9200L-24P-4G', 2, 1, 1, NULL, 'en_stock', '2025-10-06', NULL, '2030-10-06'),
  ('ap-stock-01', 'CNR1FC8FC364', 'AP-535', 4, 4, 1, NULL, 'en_stock', '2025-10-06', NULL, '2028-10-06'),
  ('sw-roa-acc-00', 'FOC73FE6D378', 'Catalyst 2960X-24PS-L', 2, 1, 1, NULL, 'reforme', '2016-04-11', '2016-05-02', '2021-04-11');

-- Interfaces (sous-requête pour retrouver l'équipement par son nom d'hôte)
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'GigabitEthernet0/0/0', '02:5d:26:51:58:86', 1000, 'up', 'Lien opérateur de transit' FROM equipement WHERE hostname = 'rtr-roa-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'GigabitEthernet0/0/1', '02:dc:87:4f:6e:a5', 1000, 'up', 'Vers pare-feu' FROM equipement WHERE hostname = 'rtr-roa-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'wan1', '02:27:52:ca:90:0d', 1000, 'up', 'Côté Internet' FROM equipement WHERE hostname = 'fw-roa-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'port1', '02:7f:82:5e:a7:f5', 1000, 'up', 'Côté LAN' FROM equipement WHERE hostname = 'fw-roa-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'mgmt', '02:2b:fb:0c:75:00', 1000, 'up', 'Administration' FROM equipement WHERE hostname = 'fw-roa-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'TenGigabitEthernet1/1/1', '02:4f:96:6f:d5:0c', 10000, 'up', 'Uplink' FROM equipement WHERE hostname = 'sw-roa-core-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'GigabitEthernet1/0/1', '02:74:5d:e1:ad:49', 1000, 'up', 'Poste administratif' FROM equipement WHERE hostname = 'sw-roa-core-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'GigabitEthernet1/0/2', '02:73:bb:2c:43:46', 1000, 'up', 'Téléphone IP' FROM equipement WHERE hostname = 'sw-roa-core-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'GigabitEthernet1/0/24', '02:35:ee:fe:6a:2c', 1000, 'admin_down', 'Port désactivé' FROM equipement WHERE hostname = 'sw-roa-core-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'TenGigabitEthernet1/1/1', '02:b7:bc:87:39:4a', 10000, 'up', 'Uplink' FROM equipement WHERE hostname = 'sw-roa-acc-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'GigabitEthernet1/0/1', '02:5b:2e:f2:05:ca', 1000, 'up', 'Poste administratif' FROM equipement WHERE hostname = 'sw-roa-acc-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'GigabitEthernet1/0/2', '02:9d:c2:85:a9:8d', 1000, 'up', 'Téléphone IP' FROM equipement WHERE hostname = 'sw-roa-acc-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'GigabitEthernet1/0/24', '02:73:49:f6:38:73', 1000, 'admin_down', 'Port désactivé' FROM equipement WHERE hostname = 'sw-roa-acc-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'TenGigabitEthernet1/1/1', '02:f4:fb:f8:e3:e6', 10000, 'up', 'Uplink' FROM equipement WHERE hostname = 'sw-roa-acc-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'GigabitEthernet1/0/1', '02:b5:17:4c:50:ac', 1000, 'up', 'Poste administratif' FROM equipement WHERE hostname = 'sw-roa-acc-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'GigabitEthernet1/0/2', '02:67:81:55:a7:48', 1000, 'up', 'Téléphone IP' FROM equipement WHERE hostname = 'sw-roa-acc-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'GigabitEthernet1/0/24', '02:b8:d1:06:d1:ce', 1000, 'admin_down', 'Port désactivé' FROM equipement WHERE hostname = 'sw-roa-acc-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'TenGigabitEthernet1/1/1', '02:00:1d:16:9d:b0', 10000, 'up', 'Uplink' FROM equipement WHERE hostname = 'sw-roa-acc-03';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'GigabitEthernet1/0/1', '02:88:74:65:ef:24', 1000, 'up', 'Poste administratif' FROM equipement WHERE hostname = 'sw-roa-acc-03';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'GigabitEthernet1/0/2', '02:b6:d1:a1:0f:3a', 1000, 'up', 'Téléphone IP' FROM equipement WHERE hostname = 'sw-roa-acc-03';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'GigabitEthernet1/0/24', '02:d9:8a:c7:61:92', 1000, 'admin_down', 'Port désactivé' FROM equipement WHERE hostname = 'sw-roa-acc-03';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'eth0', '02:d9:50:13:1d:0f', 2500, 'up', 'Uplink PoE' FROM equipement WHERE hostname = 'ap-roa-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'eth0', '02:be:79:ed:67:cf', 2500, 'up', 'Uplink PoE' FROM equipement WHERE hostname = 'ap-roa-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'eth0', '02:76:45:56:db:81', 2500, 'up', 'Uplink PoE' FROM equipement WHERE hostname = 'ap-roa-03';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'eth0', '02:da:54:c5:23:74', 2500, 'up', 'Uplink PoE' FROM equipement WHERE hostname = 'ap-roa-04';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'eno1', '02:a6:4a:4f:96:8c', 25000, 'up', 'Production' FROM equipement WHERE hostname = 'srv-roa-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'eno2', '02:2a:71:0e:34:14', 1000, 'up', 'iDRAC / administration' FROM equipement WHERE hostname = 'srv-roa-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'NMC', '02:12:66:7a:6f:23', 1000, 'up', 'Carte réseau de supervision' FROM equipement WHERE hostname = 'ups-roa-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'et-0/0/0', '02:bc:da:c1:93:db', 100000, 'up', 'Backbone inter-datacenter' FROM equipement WHERE hostname = 'rtr-ste-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'xe-0/1/0', '02:7c:58:ee:3c:d1', 10000, 'up', 'Vers cœur de réseau' FROM equipement WHERE hostname = 'rtr-ste-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'xe-0/1/1', '02:52:f7:63:36:a5', 10000, 'down', 'Réserve' FROM equipement WHERE hostname = 'rtr-ste-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'port1', '02:00:28:a1:7f:d4', 10000, 'up', 'Côté Internet' FROM equipement WHERE hostname = 'fw-ste-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'port2', '02:d6:92:e7:5f:34', 10000, 'up', 'Côté LAN' FROM equipement WHERE hostname = 'fw-ste-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'mgmt', '02:90:69:b3:e0:05', 1000, 'up', 'Administration' FROM equipement WHERE hostname = 'fw-ste-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'xe-0/0/0', '02:e7:7e:2f:b9:8c', 10000, 'up', 'Uplink' FROM equipement WHERE hostname = 'sw-ste-core-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'ge-0/0/1', '02:32:a9:39:ca:02', 1000, 'up', 'Serveur' FROM equipement WHERE hostname = 'sw-ste-core-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'ge-0/0/47', '02:ca:66:df:f2:fa', 1000, 'admin_down', 'Port désactivé' FROM equipement WHERE hostname = 'sw-ste-core-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'et-0/0/0', '02:cd:44:ce:e4:1e', 100000, 'up', 'Backbone inter-datacenter' FROM equipement WHERE hostname = 'rtr-ste-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'xe-0/1/0', '02:43:88:4a:6b:4c', 10000, 'up', 'Vers cœur de réseau' FROM equipement WHERE hostname = 'rtr-ste-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'xe-0/1/1', '02:48:49:fa:21:c1', 10000, 'down', 'Réserve' FROM equipement WHERE hostname = 'rtr-ste-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'port1', '02:3c:bc:67:2f:92', 10000, 'up', 'Côté Internet' FROM equipement WHERE hostname = 'fw-ste-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'port2', '02:83:0e:24:23:39', 10000, 'up', 'Côté LAN' FROM equipement WHERE hostname = 'fw-ste-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'mgmt', '02:a4:3e:d1:0a:c4', 1000, 'up', 'Administration' FROM equipement WHERE hostname = 'fw-ste-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'xe-0/0/0', '02:84:0c:91:94:dc', 10000, 'up', 'Uplink' FROM equipement WHERE hostname = 'sw-ste-core-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'ge-0/0/1', '02:e4:64:46:22:69', 1000, 'up', 'Serveur' FROM equipement WHERE hostname = 'sw-ste-core-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'ge-0/0/47', '02:ed:6c:fd:57:b5', 1000, 'admin_down', 'Port désactivé' FROM equipement WHERE hostname = 'sw-ste-core-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'xe-0/0/0', '02:d1:c1:60:ab:b6', 10000, 'up', 'Uplink' FROM equipement WHERE hostname = 'sw-ste-tor-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'ge-0/0/1', '02:15:b6:c0:9c:99', 1000, 'up', 'Serveur' FROM equipement WHERE hostname = 'sw-ste-tor-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'ge-0/0/47', '02:f5:4e:7a:95:d6', 1000, 'admin_down', 'Port désactivé' FROM equipement WHERE hostname = 'sw-ste-tor-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'xe-0/0/0', '02:fa:72:ed:23:2b', 10000, 'up', 'Uplink' FROM equipement WHERE hostname = 'sw-ste-tor-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'ge-0/0/1', '02:d9:63:fc:c8:4d', 1000, 'up', 'Serveur' FROM equipement WHERE hostname = 'sw-ste-tor-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'ge-0/0/47', '02:c0:45:f1:5e:dc', 1000, 'admin_down', 'Port désactivé' FROM equipement WHERE hostname = 'sw-ste-tor-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'xe-0/0/0', '02:cc:ba:51:f2:c8', 10000, 'up', 'Uplink' FROM equipement WHERE hostname = 'sw-ste-tor-03';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'ge-0/0/1', '02:9f:a0:bb:46:de', 1000, 'up', 'Serveur' FROM equipement WHERE hostname = 'sw-ste-tor-03';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'ge-0/0/47', '02:e5:7a:6c:db:b4', 1000, 'admin_down', 'Port désactivé' FROM equipement WHERE hostname = 'sw-ste-tor-03';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'xe-0/0/0', '02:bf:22:36:92:ae', 10000, 'up', 'Uplink' FROM equipement WHERE hostname = 'sw-ste-tor-04';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'ge-0/0/1', '02:11:d5:28:aa:86', 1000, 'up', 'Serveur' FROM equipement WHERE hostname = 'sw-ste-tor-04';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'ge-0/0/47', '02:5f:dc:bf:11:4a', 1000, 'admin_down', 'Port désactivé' FROM equipement WHERE hostname = 'sw-ste-tor-04';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'eno1', '02:23:01:b5:34:a8', 25000, 'up', 'Production' FROM equipement WHERE hostname = 'srv-ste-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'eno2', '02:54:da:21:2e:3b', 1000, 'up', 'iDRAC / administration' FROM equipement WHERE hostname = 'srv-ste-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'eno1', '02:31:d3:85:28:cd', 25000, 'up', 'Production' FROM equipement WHERE hostname = 'srv-ste-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'eno2', '02:39:33:83:9c:ff', 1000, 'up', 'iDRAC / administration' FROM equipement WHERE hostname = 'srv-ste-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'eno1', '02:4f:d6:95:a8:4a', 25000, 'up', 'Production' FROM equipement WHERE hostname = 'srv-ste-03';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'eno2', '02:fa:25:79:b7:47', 1000, 'up', 'iDRAC / administration' FROM equipement WHERE hostname = 'srv-ste-03';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'eno1', '02:da:a9:b4:3a:28', 25000, 'up', 'Production' FROM equipement WHERE hostname = 'srv-ste-04';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'eno2', '02:6d:74:2e:69:ad', 1000, 'up', 'iDRAC / administration' FROM equipement WHERE hostname = 'srv-ste-04';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'NMC', '02:3a:10:15:26:6d', 1000, 'up', 'Carte réseau de supervision' FROM equipement WHERE hostname = 'ups-ste-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'NMC', '02:1b:f4:b6:b7:3b', 1000, 'up', 'Carte réseau de supervision' FROM equipement WHERE hostname = 'ups-ste-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'et-0/0/0', '02:dc:fa:24:83:03', 100000, 'up', 'Backbone inter-datacenter' FROM equipement WHERE hostname = 'rtr-lyo-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'xe-0/1/0', '02:e6:cc:b4:ed:41', 10000, 'up', 'Vers cœur de réseau' FROM equipement WHERE hostname = 'rtr-lyo-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'xe-0/1/1', '02:8c:1b:3a:02:b3', 10000, 'down', 'Réserve' FROM equipement WHERE hostname = 'rtr-lyo-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'port1', '02:fa:46:66:14:02', 10000, 'up', 'Côté Internet' FROM equipement WHERE hostname = 'fw-lyo-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'port2', '02:b0:9f:8b:33:73', 10000, 'up', 'Côté LAN' FROM equipement WHERE hostname = 'fw-lyo-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'mgmt', '02:ae:e8:15:52:8b', 1000, 'up', 'Administration' FROM equipement WHERE hostname = 'fw-lyo-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'xe-0/0/0', '02:07:3a:77:3f:fa', 10000, 'up', 'Uplink' FROM equipement WHERE hostname = 'sw-lyo-core-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'ge-0/0/1', '02:07:5f:4e:f9:95', 1000, 'up', 'Serveur' FROM equipement WHERE hostname = 'sw-lyo-core-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'ge-0/0/47', '02:82:b6:de:d7:a7', 1000, 'admin_down', 'Port désactivé' FROM equipement WHERE hostname = 'sw-lyo-core-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'xe-0/0/0', '02:ac:82:ac:83:35', 10000, 'up', 'Uplink' FROM equipement WHERE hostname = 'sw-lyo-tor-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'ge-0/0/1', '02:1a:8e:a0:6d:4c', 1000, 'up', 'Serveur' FROM equipement WHERE hostname = 'sw-lyo-tor-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'ge-0/0/47', '02:77:37:e3:8f:dc', 1000, 'admin_down', 'Port désactivé' FROM equipement WHERE hostname = 'sw-lyo-tor-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'eno1', '02:84:ce:bf:11:d2', 25000, 'up', 'Production' FROM equipement WHERE hostname = 'srv-lyo-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'eno2', '02:a4:ca:b5:df:24', 1000, 'up', 'iDRAC / administration' FROM equipement WHERE hostname = 'srv-lyo-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'xe-0/0/0', '02:ab:05:59:39:ca', 10000, 'up', 'Uplink' FROM equipement WHERE hostname = 'sw-lyo-tor-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'ge-0/0/1', '02:71:43:c7:c9:84', 1000, 'up', 'Serveur' FROM equipement WHERE hostname = 'sw-lyo-tor-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'ge-0/0/47', '02:b8:c1:2f:d4:32', 1000, 'admin_down', 'Port désactivé' FROM equipement WHERE hostname = 'sw-lyo-tor-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'eno1', '02:f5:f8:2b:b7:50', 25000, 'up', 'Production' FROM equipement WHERE hostname = 'srv-lyo-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'eno2', '02:5e:cb:ee:1a:3a', 1000, 'up', 'iDRAC / administration' FROM equipement WHERE hostname = 'srv-lyo-02';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'NMC', '02:b1:29:5c:f7:16', 1000, 'up', 'Carte réseau de supervision' FROM equipement WHERE hostname = 'ups-lyo-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'sfp-sfpplus1', '02:06:ad:2c:5f:0a', 10000, 'up', 'Collecte fibre' FROM equipement WHERE hostname = 'rtr-feu-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'ether1', '02:1f:e8:e4:0f:7a', 1000, 'up', 'Vers commutateur' FROM equipement WHERE hostname = 'rtr-feu-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'sfp-sfpplus1', '02:11:21:44:6c:91', 10000, 'up', 'Uplink' FROM equipement WHERE hostname = 'sw-feu-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'ether2', '02:f8:20:fb:68:59', 1000, 'up', 'Équipement client' FROM equipement WHERE hostname = 'sw-feu-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'NMC', '02:a0:fa:8e:de:ef', 1000, 'up', 'Carte réseau de supervision' FROM equipement WHERE hostname = 'ups-feu-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'TenGigabitEthernet1/1/1', '02:0f:5c:97:fe:33', 10000, 'admin_down', 'Uplink' FROM equipement WHERE hostname = 'sw-roa-acc-00';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'GigabitEthernet1/0/1', '02:0d:0e:af:b6:f2', 1000, 'admin_down', 'Poste administratif' FROM equipement WHERE hostname = 'sw-roa-acc-00';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'GigabitEthernet1/0/2', '02:fe:ce:9a:81:09', 1000, 'admin_down', 'Téléphone IP' FROM equipement WHERE hostname = 'sw-roa-acc-00';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description) SELECT id_equipement, 'GigabitEthernet1/0/24', '02:5c:0e:20:29:9c', 1000, 'admin_down', 'Port désactivé' FROM equipement WHERE hostname = 'sw-roa-acc-00';

-- Affectation des VLAN aux interfaces
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'rtr-roa-01' AND i.nom = 'GigabitEthernet0/0/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'fw-roa-01' AND i.nom = 'port1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'fw-roa-01' AND i.nom = 'port1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 30 WHERE e.hostname = 'fw-roa-01' AND i.nom = 'port1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 40 WHERE e.hostname = 'fw-roa-01' AND i.nom = 'port1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 50 WHERE e.hostname = 'fw-roa-01' AND i.nom = 'port1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'fw-roa-01' AND i.nom = 'mgmt';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'sw-roa-core-01' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'sw-roa-core-01' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 30 WHERE e.hostname = 'sw-roa-core-01' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 40 WHERE e.hostname = 'sw-roa-core-01' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 50 WHERE e.hostname = 'sw-roa-core-01' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'sw-roa-core-01' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'sw-roa-core-01' AND i.nom = 'GigabitEthernet1/0/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 30 WHERE e.hostname = 'sw-roa-core-01' AND i.nom = 'GigabitEthernet1/0/2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'sw-roa-acc-01' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'sw-roa-acc-01' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 30 WHERE e.hostname = 'sw-roa-acc-01' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 40 WHERE e.hostname = 'sw-roa-acc-01' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 50 WHERE e.hostname = 'sw-roa-acc-01' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'sw-roa-acc-01' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'sw-roa-acc-01' AND i.nom = 'GigabitEthernet1/0/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 30 WHERE e.hostname = 'sw-roa-acc-01' AND i.nom = 'GigabitEthernet1/0/2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'sw-roa-acc-02' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'sw-roa-acc-02' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 30 WHERE e.hostname = 'sw-roa-acc-02' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 40 WHERE e.hostname = 'sw-roa-acc-02' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 50 WHERE e.hostname = 'sw-roa-acc-02' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'sw-roa-acc-02' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'sw-roa-acc-02' AND i.nom = 'GigabitEthernet1/0/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 30 WHERE e.hostname = 'sw-roa-acc-02' AND i.nom = 'GigabitEthernet1/0/2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'sw-roa-acc-03' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'sw-roa-acc-03' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 30 WHERE e.hostname = 'sw-roa-acc-03' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 40 WHERE e.hostname = 'sw-roa-acc-03' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 50 WHERE e.hostname = 'sw-roa-acc-03' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'sw-roa-acc-03' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'sw-roa-acc-03' AND i.nom = 'GigabitEthernet1/0/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 30 WHERE e.hostname = 'sw-roa-acc-03' AND i.nom = 'GigabitEthernet1/0/2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 40 WHERE e.hostname = 'ap-roa-01' AND i.nom = 'eth0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 50 WHERE e.hostname = 'ap-roa-01' AND i.nom = 'eth0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'ap-roa-01' AND i.nom = 'eth0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 40 WHERE e.hostname = 'ap-roa-02' AND i.nom = 'eth0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 50 WHERE e.hostname = 'ap-roa-02' AND i.nom = 'eth0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'ap-roa-02' AND i.nom = 'eth0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 40 WHERE e.hostname = 'ap-roa-03' AND i.nom = 'eth0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 50 WHERE e.hostname = 'ap-roa-03' AND i.nom = 'eth0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'ap-roa-03' AND i.nom = 'eth0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 40 WHERE e.hostname = 'ap-roa-04' AND i.nom = 'eth0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 50 WHERE e.hostname = 'ap-roa-04' AND i.nom = 'eth0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'ap-roa-04' AND i.nom = 'eth0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'srv-roa-01' AND i.nom = 'eno1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'srv-roa-01' AND i.nom = 'eno2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'ups-roa-01' AND i.nom = 'NMC';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'rtr-ste-01' AND i.nom = 'xe-0/1/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'rtr-ste-01' AND i.nom = 'xe-0/1/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'fw-ste-01' AND i.nom = 'port2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'fw-ste-01' AND i.nom = 'port2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 30 WHERE e.hostname = 'fw-ste-01' AND i.nom = 'port2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 40 WHERE e.hostname = 'fw-ste-01' AND i.nom = 'port2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 50 WHERE e.hostname = 'fw-ste-01' AND i.nom = 'port2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'fw-ste-01' AND i.nom = 'mgmt';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'sw-ste-core-01' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'sw-ste-core-01' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 30 WHERE e.hostname = 'sw-ste-core-01' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 40 WHERE e.hostname = 'sw-ste-core-01' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 50 WHERE e.hostname = 'sw-ste-core-01' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'sw-ste-core-01' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'sw-ste-core-01' AND i.nom = 'ge-0/0/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'rtr-ste-02' AND i.nom = 'xe-0/1/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'rtr-ste-02' AND i.nom = 'xe-0/1/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'fw-ste-02' AND i.nom = 'port2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'fw-ste-02' AND i.nom = 'port2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 30 WHERE e.hostname = 'fw-ste-02' AND i.nom = 'port2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 40 WHERE e.hostname = 'fw-ste-02' AND i.nom = 'port2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 50 WHERE e.hostname = 'fw-ste-02' AND i.nom = 'port2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'fw-ste-02' AND i.nom = 'mgmt';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'sw-ste-core-02' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'sw-ste-core-02' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 30 WHERE e.hostname = 'sw-ste-core-02' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 40 WHERE e.hostname = 'sw-ste-core-02' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 50 WHERE e.hostname = 'sw-ste-core-02' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'sw-ste-core-02' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'sw-ste-core-02' AND i.nom = 'ge-0/0/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'sw-ste-tor-01' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'sw-ste-tor-01' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 30 WHERE e.hostname = 'sw-ste-tor-01' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 40 WHERE e.hostname = 'sw-ste-tor-01' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 50 WHERE e.hostname = 'sw-ste-tor-01' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'sw-ste-tor-01' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'sw-ste-tor-01' AND i.nom = 'ge-0/0/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'sw-ste-tor-02' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'sw-ste-tor-02' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 30 WHERE e.hostname = 'sw-ste-tor-02' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 40 WHERE e.hostname = 'sw-ste-tor-02' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 50 WHERE e.hostname = 'sw-ste-tor-02' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'sw-ste-tor-02' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'sw-ste-tor-02' AND i.nom = 'ge-0/0/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'sw-ste-tor-03' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'sw-ste-tor-03' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 30 WHERE e.hostname = 'sw-ste-tor-03' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 40 WHERE e.hostname = 'sw-ste-tor-03' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 50 WHERE e.hostname = 'sw-ste-tor-03' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'sw-ste-tor-03' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'sw-ste-tor-03' AND i.nom = 'ge-0/0/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'sw-ste-tor-04' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'sw-ste-tor-04' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 30 WHERE e.hostname = 'sw-ste-tor-04' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 40 WHERE e.hostname = 'sw-ste-tor-04' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 50 WHERE e.hostname = 'sw-ste-tor-04' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'sw-ste-tor-04' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'sw-ste-tor-04' AND i.nom = 'ge-0/0/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'srv-ste-01' AND i.nom = 'eno1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'srv-ste-01' AND i.nom = 'eno2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'srv-ste-02' AND i.nom = 'eno1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'srv-ste-02' AND i.nom = 'eno2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'srv-ste-03' AND i.nom = 'eno1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'srv-ste-03' AND i.nom = 'eno2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'srv-ste-04' AND i.nom = 'eno1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'srv-ste-04' AND i.nom = 'eno2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'ups-ste-01' AND i.nom = 'NMC';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'ups-ste-02' AND i.nom = 'NMC';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'rtr-lyo-01' AND i.nom = 'xe-0/1/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'rtr-lyo-01' AND i.nom = 'xe-0/1/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'fw-lyo-01' AND i.nom = 'port2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'fw-lyo-01' AND i.nom = 'port2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 30 WHERE e.hostname = 'fw-lyo-01' AND i.nom = 'port2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 40 WHERE e.hostname = 'fw-lyo-01' AND i.nom = 'port2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 50 WHERE e.hostname = 'fw-lyo-01' AND i.nom = 'port2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'fw-lyo-01' AND i.nom = 'mgmt';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'sw-lyo-core-01' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'sw-lyo-core-01' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 30 WHERE e.hostname = 'sw-lyo-core-01' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 40 WHERE e.hostname = 'sw-lyo-core-01' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 50 WHERE e.hostname = 'sw-lyo-core-01' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'sw-lyo-core-01' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'sw-lyo-core-01' AND i.nom = 'ge-0/0/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'sw-lyo-tor-01' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'sw-lyo-tor-01' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 30 WHERE e.hostname = 'sw-lyo-tor-01' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 40 WHERE e.hostname = 'sw-lyo-tor-01' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 50 WHERE e.hostname = 'sw-lyo-tor-01' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'sw-lyo-tor-01' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'sw-lyo-tor-01' AND i.nom = 'ge-0/0/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'srv-lyo-01' AND i.nom = 'eno1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'srv-lyo-01' AND i.nom = 'eno2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'sw-lyo-tor-02' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'sw-lyo-tor-02' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 30 WHERE e.hostname = 'sw-lyo-tor-02' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 40 WHERE e.hostname = 'sw-lyo-tor-02' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 50 WHERE e.hostname = 'sw-lyo-tor-02' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'sw-lyo-tor-02' AND i.nom = 'xe-0/0/0';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'sw-lyo-tor-02' AND i.nom = 'ge-0/0/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'srv-lyo-02' AND i.nom = 'eno1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'srv-lyo-02' AND i.nom = 'eno2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'ups-lyo-01' AND i.nom = 'NMC';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'rtr-feu-01' AND i.nom = 'ether1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'sw-feu-01' AND i.nom = 'sfp-sfpplus1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'sw-feu-01' AND i.nom = 'sfp-sfpplus1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 30 WHERE e.hostname = 'sw-feu-01' AND i.nom = 'sfp-sfpplus1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 40 WHERE e.hostname = 'sw-feu-01' AND i.nom = 'sfp-sfpplus1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 50 WHERE e.hostname = 'sw-feu-01' AND i.nom = 'sfp-sfpplus1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'sw-feu-01' AND i.nom = 'sfp-sfpplus1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'sw-feu-01' AND i.nom = 'ether2';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'ups-feu-01' AND i.nom = 'NMC';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'sw-roa-acc-00' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 20 WHERE e.hostname = 'sw-roa-acc-00' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 30 WHERE e.hostname = 'sw-roa-acc-00' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 40 WHERE e.hostname = 'sw-roa-acc-00' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 50 WHERE e.hostname = 'sw-roa-acc-00' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'trunk' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 99 WHERE e.hostname = 'sw-roa-acc-00' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 10 WHERE e.hostname = 'sw-roa-acc-00' AND i.nom = 'GigabitEthernet1/0/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode) SELECT i.id_interface, v.id_vlan, 'access' FROM interface i JOIN equipement e ON e.id_equipement = i.id_equipement JOIN vlan v ON v.numero = 30 WHERE e.hostname = 'sw-roa-acc-00' AND i.nom = 'GigabitEthernet1/0/2';

-- Historique des interventions
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 1, '2021-03-03 09:30:00', 'installation', 'Installation et mise en service de rtr-roa-01', 120 FROM equipement WHERE hostname = 'rtr-roa-01';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 1, '2022-04-25 09:30:00', 'installation', 'Installation et mise en service de fw-roa-01', 120 FROM equipement WHERE hostname = 'fw-roa-01';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 1, '2021-03-03 09:30:00', 'installation', 'Installation et mise en service de sw-roa-core-01', 120 FROM equipement WHERE hostname = 'sw-roa-core-01';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 1, '2021-04-12 09:30:00', 'installation', 'Installation et mise en service de sw-roa-acc-01', 120 FROM equipement WHERE hostname = 'sw-roa-acc-01';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 1, '2021-04-12 09:30:00', 'installation', 'Installation et mise en service de sw-roa-acc-02', 120 FROM equipement WHERE hostname = 'sw-roa-acc-02';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 1, '2021-04-12 09:30:00', 'installation', 'Installation et mise en service de sw-roa-acc-03', 120 FROM equipement WHERE hostname = 'sw-roa-acc-03';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 1, '2023-02-06 09:30:00', 'installation', 'Installation et mise en service de ap-roa-01', 45 FROM equipement WHERE hostname = 'ap-roa-01';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 1, '2023-02-06 09:30:00', 'installation', 'Installation et mise en service de ap-roa-02', 45 FROM equipement WHERE hostname = 'ap-roa-02';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 1, '2023-02-06 09:30:00', 'installation', 'Installation et mise en service de ap-roa-03', 45 FROM equipement WHERE hostname = 'ap-roa-03';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 1, '2023-02-06 09:30:00', 'installation', 'Installation et mise en service de ap-roa-04', 45 FROM equipement WHERE hostname = 'ap-roa-04';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 1, '2022-11-28 09:30:00', 'installation', 'Installation et mise en service de srv-roa-01', 120 FROM equipement WHERE hostname = 'srv-roa-01';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 1, '2020-06-08 09:30:00', 'installation', 'Installation et mise en service de ups-roa-01', 120 FROM equipement WHERE hostname = 'ups-roa-01';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 3, '2020-10-05 09:30:00', 'installation', 'Installation et mise en service de rtr-ste-01', 120 FROM equipement WHERE hostname = 'rtr-ste-01';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 3, '2023-03-27 09:30:00', 'installation', 'Installation et mise en service de fw-ste-01', 120 FROM equipement WHERE hostname = 'fw-ste-01';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 3, '2020-10-05 09:30:00', 'installation', 'Installation et mise en service de sw-ste-core-01', 120 FROM equipement WHERE hostname = 'sw-ste-core-01';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 3, '2020-10-05 09:30:00', 'installation', 'Installation et mise en service de rtr-ste-02', 120 FROM equipement WHERE hostname = 'rtr-ste-02';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 3, '2023-03-27 09:30:00', 'installation', 'Installation et mise en service de fw-ste-02', 120 FROM equipement WHERE hostname = 'fw-ste-02';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 3, '2020-10-05 09:30:00', 'installation', 'Installation et mise en service de sw-ste-core-02', 120 FROM equipement WHERE hostname = 'sw-ste-core-02';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 3, '2019-07-22 09:30:00', 'installation', 'Installation et mise en service de sw-ste-tor-01', 120 FROM equipement WHERE hostname = 'sw-ste-tor-01';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 3, '2019-07-22 09:30:00', 'installation', 'Installation et mise en service de sw-ste-tor-02', 120 FROM equipement WHERE hostname = 'sw-ste-tor-02';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 3, '2019-07-22 09:30:00', 'installation', 'Installation et mise en service de sw-ste-tor-03', 120 FROM equipement WHERE hostname = 'sw-ste-tor-03';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 3, '2019-07-22 09:30:00', 'installation', 'Installation et mise en service de sw-ste-tor-04', 120 FROM equipement WHERE hostname = 'sw-ste-tor-04';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 3, '2024-03-04 09:30:00', 'installation', 'Installation et mise en service de srv-ste-01', 120 FROM equipement WHERE hostname = 'srv-ste-01';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 3, '2024-03-04 09:30:00', 'installation', 'Installation et mise en service de srv-ste-02', 120 FROM equipement WHERE hostname = 'srv-ste-02';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 3, '2024-03-04 09:30:00', 'installation', 'Installation et mise en service de srv-ste-03', 120 FROM equipement WHERE hostname = 'srv-ste-03';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 3, '2024-03-04 09:30:00', 'installation', 'Installation et mise en service de srv-ste-04', 120 FROM equipement WHERE hostname = 'srv-ste-04';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 3, '2019-07-22 09:30:00', 'installation', 'Installation et mise en service de ups-ste-01', 120 FROM equipement WHERE hostname = 'ups-ste-01';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 3, '2019-07-22 09:30:00', 'installation', 'Installation et mise en service de ups-ste-02', 120 FROM equipement WHERE hostname = 'ups-ste-02';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 5, '2021-01-25 09:30:00', 'installation', 'Installation et mise en service de rtr-lyo-01', 120 FROM equipement WHERE hostname = 'rtr-lyo-01';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 5, '2023-03-27 09:30:00', 'installation', 'Installation et mise en service de fw-lyo-01', 120 FROM equipement WHERE hostname = 'fw-lyo-01';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 5, '2021-01-25 09:30:00', 'installation', 'Installation et mise en service de sw-lyo-core-01', 120 FROM equipement WHERE hostname = 'sw-lyo-core-01';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 5, '2021-01-25 09:30:00', 'installation', 'Installation et mise en service de sw-lyo-tor-01', 120 FROM equipement WHERE hostname = 'sw-lyo-tor-01';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 5, '2024-03-04 09:30:00', 'installation', 'Installation et mise en service de srv-lyo-01', 120 FROM equipement WHERE hostname = 'srv-lyo-01';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 5, '2021-01-25 09:30:00', 'installation', 'Installation et mise en service de sw-lyo-tor-02', 120 FROM equipement WHERE hostname = 'sw-lyo-tor-02';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 5, '2024-03-04 09:30:00', 'installation', 'Installation et mise en service de srv-lyo-02', 120 FROM equipement WHERE hostname = 'srv-lyo-02';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 5, '2021-01-25 09:30:00', 'installation', 'Installation et mise en service de ups-lyo-01', 120 FROM equipement WHERE hostname = 'ups-lyo-01';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 6, '2022-09-12 09:30:00', 'installation', 'Installation et mise en service de rtr-feu-01', 120 FROM equipement WHERE hostname = 'rtr-feu-01';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 6, '2022-09-12 09:30:00', 'installation', 'Installation et mise en service de sw-feu-01', 120 FROM equipement WHERE hostname = 'sw-feu-01';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 6, '2022-09-12 09:30:00', 'installation', 'Installation et mise en service de ups-feu-01', 120 FROM equipement WHERE hostname = 'ups-feu-01';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 1, '2016-05-02 09:30:00', 'installation', 'Installation et mise en service de sw-roa-acc-00', 120 FROM equipement WHERE hostname = 'sw-roa-acc-00';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 2, '2024-06-03 14:00:00', 'maintenance', 'Remplacement des batteries', 90 FROM equipement WHERE hostname = 'ups-roa-01';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 4, '2025-03-18 22:00:00', 'mise_a_jour', 'Mise à jour Junos (fenêtre de nuit)', 60 FROM equipement WHERE hostname = 'rtr-ste-01';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 4, '2025-03-19 22:00:00', 'mise_a_jour', 'Mise à jour Junos (fenêtre de nuit)', 60 FROM equipement WHERE hostname = 'rtr-ste-02';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 3, '2025-11-27 08:15:00', 'panne', 'Bloc d''alimentation défectueux remplacé', 40 FROM equipement WHERE hostname = 'sw-ste-tor-03';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 1, '2026-01-12 10:00:00', 'maintenance', 'Repositionnement de la borne (zone blanche)', 30 FROM equipement WHERE hostname = 'ap-roa-02';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention, type_intervention, description, duree_minutes) SELECT id_equipement, 2, '2025-10-20 16:00:00', 'remplacement', 'Fin de vie, retiré de la baie', 45 FROM equipement WHERE hostname = 'sw-roa-acc-00';

COMMIT;

-- ---------------------------------------------------------------------
-- PARTIE B : la vie du parc (mises à jour de novembre 2026)
-- Chaque scénario est une transaction : tout passe, ou rien ne passe.
-- ---------------------------------------------------------------------

-- Scénario 1 : le commutateur sw-roa-acc-02 tombe en panne
START TRANSACTION;
UPDATE equipement SET statut = 'en_panne'
 WHERE hostname = 'sw-roa-acc-02';
UPDATE interface i JOIN equipement e ON e.id_equipement = i.id_equipement
   SET i.etat = 'down'
 WHERE e.hostname = 'sw-roa-acc-02';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention,
                          type_intervention, description, duree_minutes)
SELECT id_equipement, 2, '2026-11-02 08:40:00', 'panne',
       'Commutateur ne démarre plus après une coupure électrique', 50
  FROM equipement WHERE hostname = 'sw-roa-acc-02';
COMMIT;

-- Scénario 2 : on le remplace par le commutateur en stock
--   - l'ancien est réformé et libère son adresse d'administration
--   - le neuf est renommé, reçoit l'adresse et passe en service
START TRANSACTION;
SET @ip_libre := (SELECT ip_admin FROM equipement WHERE hostname = 'sw-roa-acc-02');
UPDATE equipement SET statut = 'reforme', ip_admin = NULL
 WHERE hostname = 'sw-roa-acc-02';
UPDATE equipement
   SET hostname = 'sw-roa-acc-04', statut = 'en_service',
       ip_admin = @ip_libre, date_mise_service = '2026-11-02'
 WHERE hostname = 'sw-stock-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description)
SELECT id_equipement, 'TenGigabitEthernet1/1/1', '02:5e:a1:00:00:01', 10000, 'up', 'Uplink'
  FROM equipement WHERE hostname = 'sw-roa-acc-04';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description)
SELECT id_equipement, 'GigabitEthernet1/0/1', '02:5e:a1:00:00:02', 1000, 'up', 'Poste administratif'
  FROM equipement WHERE hostname = 'sw-roa-acc-04';
INSERT INTO interface_vlan (id_interface, id_vlan, mode)
SELECT i.id_interface, v.id_vlan, 'trunk'
  FROM interface i
  JOIN equipement e ON e.id_equipement = i.id_equipement
  JOIN vlan v ON v.numero IN (10, 20, 30, 40, 50, 99)
 WHERE e.hostname = 'sw-roa-acc-04' AND i.nom = 'TenGigabitEthernet1/1/1';
INSERT INTO interface_vlan (id_interface, id_vlan, mode)
SELECT i.id_interface, v.id_vlan, 'access'
  FROM interface i
  JOIN equipement e ON e.id_equipement = i.id_equipement
  JOIN vlan v ON v.numero = 10
 WHERE e.hostname = 'sw-roa-acc-04' AND i.nom = 'GigabitEthernet1/0/1';
INSERT INTO intervention (id_equipement, id_technicien, date_intervention,
                          type_intervention, description, duree_minutes)
SELECT id_equipement, 2, '2026-11-02 11:00:00', 'remplacement',
       'Remplacement de sw-roa-acc-02 par un commutateur du stock', 75
  FROM equipement WHERE hostname = 'sw-roa-acc-04';
COMMIT;

-- Scénario 3 : achat et installation de deux bornes Wi-Fi à Feurs
START TRANSACTION;
INSERT INTO equipement (hostname, numero_serie, modele, id_type, id_fabricant, id_site,
                        ip_admin, statut, date_achat, date_mise_service, fin_garantie)
SELECT 'ap-feu-01', 'CNR7F3A21B90', 'AP-535', t.id_type, f.id_fabricant, s.id_site,
       '10.99.4.13', 'en_service', '2026-10-19', '2026-11-04', '2029-10-19'
  FROM type_equipement t, fabricant f, site s
 WHERE t.libelle = 'Borne Wi-Fi' AND f.nom = 'HPE Aruba Networking' AND s.code = 'FEU';
UPDATE equipement e JOIN site s ON s.code = 'FEU'
   SET e.hostname = 'ap-feu-02', e.id_site = s.id_site, e.statut = 'en_service',
       e.ip_admin = '10.99.4.14', e.date_mise_service = '2026-11-04'
 WHERE e.hostname = 'ap-stock-01';
INSERT INTO interface (id_equipement, nom, adresse_mac, vitesse_mbps, etat, description)
SELECT id_equipement, 'eth0',
       CASE hostname WHEN 'ap-feu-01' THEN '02:5e:a1:00:00:11' ELSE '02:5e:a1:00:00:12' END,
       2500, 'up', 'Uplink PoE'
  FROM equipement WHERE hostname IN ('ap-feu-01', 'ap-feu-02');
INSERT INTO interface_vlan (id_interface, id_vlan, mode)
SELECT i.id_interface, v.id_vlan, 'trunk'
  FROM interface i
  JOIN equipement e ON e.id_equipement = i.id_equipement
  JOIN vlan v ON v.numero IN (40, 50, 99)
 WHERE e.hostname IN ('ap-feu-01', 'ap-feu-02');
INSERT INTO intervention (id_equipement, id_technicien, date_intervention,
                          type_intervention, description, duree_minutes)
SELECT id_equipement, 6, '2026-11-04 14:00:00', 'installation',
       CONCAT('Installation de la borne ', hostname), 45
  FROM equipement WHERE hostname IN ('ap-feu-01', 'ap-feu-02');
COMMIT;

-- Scénario 4 : mise à jour de sécurité de tous les pare-feu en service
--   (un seul INSERT ... SELECT pour toute une catégorie d'équipements)
START TRANSACTION;
INSERT INTO intervention (id_equipement, id_technicien, date_intervention,
                          type_intervention, description, duree_minutes)
SELECT e.id_equipement,
       CASE s.code WHEN 'ROA' THEN 1 WHEN 'STE' THEN 3 ELSE 5 END,
       '2026-11-06 23:00:00', 'mise_a_jour',
       'Mise à jour FortiOS (correctif de sécurité)', 35
  FROM equipement e
  JOIN type_equipement t ON t.id_type = e.id_type
  JOIN site s ON s.id_site = e.id_site
 WHERE t.libelle = 'Pare-feu' AND e.statut = 'en_service';
COMMIT;

-- Scénario 5 : extension de garantie de 2 ans pour les serveurs de Saint-Étienne
START TRANSACTION;
UPDATE equipement e
  JOIN type_equipement t ON t.id_type = e.id_type
  JOIN site s ON s.id_site = e.id_site
   SET e.fin_garantie = DATE_ADD(e.fin_garantie, INTERVAL 2 YEAR)
 WHERE t.libelle = 'Serveur' AND s.code = 'STE';
COMMIT;

-- Scénario 6 : départ d'un technicien (on le désactive, on ne l'efface pas :
--   ses interventions doivent rester dans l'historique)
START TRANSACTION;
UPDATE technicien SET actif = FALSE WHERE email = 'karim.moreau@ofr.example';
COMMIT;

-- ---------------------------------------------------------------------
-- Contrôle : nombre de lignes par table (à noter dans le compte rendu)
-- ---------------------------------------------------------------------
SELECT 'site' AS table_name, COUNT(*) AS nb_lignes FROM site
UNION ALL SELECT 'fabricant', COUNT(*) FROM fabricant
UNION ALL SELECT 'type_equipement', COUNT(*) FROM type_equipement
UNION ALL SELECT 'technicien', COUNT(*) FROM technicien
UNION ALL SELECT 'equipement', COUNT(*) FROM equipement
UNION ALL SELECT 'interface', COUNT(*) FROM interface
UNION ALL SELECT 'vlan', COUNT(*) FROM vlan
UNION ALL SELECT 'interface_vlan', COUNT(*) FROM interface_vlan
UNION ALL SELECT 'intervention', COUNT(*) FROM intervention;

