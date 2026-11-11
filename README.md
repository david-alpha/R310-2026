# Base « parc » · TD R3.10 MySQL

Scripts SQL du TD **R3.10 · Gestion d'un système de bases de données** (BUT Réseaux & Télécommunications, 2e année, IUT de Roanne).

La base **parc** recense les équipements réseau d'**OFR, Opérateur Fibre Roannais**, une entreprise **fictive**. Les personnes, adresses et numéros de série sont inventés. Les adresses e-mail utilisent le domaine `ofr.example`, réservé à la documentation (RFC 2606).

## Contenu du dépôt

| Fichier | Rôle |
|---|---|
| `parc_schema.sql` | Crée la base `parc` : 9 tables et 1 vue, avec clés primaires, clés étrangères, contraintes et index. **Supprime la base `parc` si elle existe déjà.** |
| `parc_donnees.sql` | Insère le parc de l'entreprise (partie A), puis joue 6 scénarios de mise à jour (partie B) et affiche un comptage final. |
| `README.md` | Ce document. |

## Compatibilité

| SGBD | Statut |
|---|---|
| **MySQL 8.0** (Ubuntu Server 24.04 LTS) | **Testé** : import sans erreur, comptages conformes. |
| **MySQL 8.4 LTS** (Ubuntu Server 26.04 LTS, Debian 12/13 avec le dépôt Oracle) | **Non testé, compatible attendu** : les scripts n'utilisent aucune fonctionnalité modifiée entre 8.0 et 8.4. |
| **MariaDB** (paquet par défaut de Debian) | **Non compatible.** Voir ci-dessous. |

### Pourquoi MariaDB ne fonctionne pas

Les scripts utilisent deux éléments propres à MySQL 8 :

- la collation `utf8mb4_0900_ai_ci`, que MariaDB ne reconnaît pas (erreur `1273 Unknown collation`) ;
- la fonction `REGEXP_LIKE()` dans les contraintes `CHECK` (format des codes de site, des adresses IP, des adresses MAC, des réseaux), absente de MariaDB.

**Le piège sous Debian :** `sudo apt install mysql-server` installe **MariaDB**, pas MySQL. Il faut d'abord ajouter le dépôt officiel d'Oracle (étape 1 du cahier de TD).

Pour savoir ce qui est installé :

```bash
mysql --version
# MySQL   : mysql  Ver 8.0.46 ...   ou   Ver 8.4.x ...
# MariaDB : mysql  Ver 15.1 Distrib 10.11.x-MariaDB ...   → mauvais SGBD pour ce TD
```

## Installation

Sur le serveur, une fois MySQL installé :

```bash
sudo mysql < parc_schema.sql
sudo mysql parc < parc_donnees.sql
```

Les deux imports doivent se faire **dans cet ordre**, et chacun **une seule fois** : relancer `parc_donnees.sql` sur une base déjà remplie provoque des erreurs de doublons. Pour repartir de zéro, relancez les deux scripts.

## Résultat attendu

La fin de `parc_donnees.sql` affiche ce comptage :

| Table | Lignes |
|---|---|
| site | 4 |
| fabricant | 7 |
| type_equipement | 6 |
| technicien | 6 |
| equipement | **43** |
| interface | 101 |
| vlan | 6 |
| interface_vlan | 186 |
| intervention | **54** |

La vue `v_equipements_en_service` renvoie 41 équipements.

## Le modèle de données

| Table | Clé primaire | Clés étrangères | Contraintes notables |
|---|---|---|---|
| `site` | `id_site` | — | code de 3 lettres majuscules unique, code postal sur 5 chiffres |
| `fabricant` | `id_fabricant` | — | nom unique |
| `type_equipement` | `id_type` | — | libellé unique |
| `technicien` | `id_technicien` | `id_site` (RESTRICT) | e-mail unique |
| `equipement` | `id_equipement` | `id_type`, `id_fabricant`, `id_site` (RESTRICT) | hostname, numéro de série et IP uniques ; mise en service postérieure à l'achat |
| `interface` | `id_interface` | `id_equipement` (CASCADE) | couple (équipement, nom) unique ; format MAC |
| `vlan` | `id_vlan` | — | numéro entre 1 et 4094 ; réseau en notation CIDR |
| `interface_vlan` | (`id_interface`, `id_vlan`) | `id_interface` (CASCADE), `id_vlan` (RESTRICT) | association plusieurs-à-plusieurs |
| `intervention` | `id_intervention` | `id_equipement`, `id_technicien` (RESTRICT) | durée entre 1 et 1 440 minutes |

- **CASCADE** : supprimer un équipement supprime ses interfaces.
- **RESTRICT** : impossible de supprimer un équipement qui a un historique d'interventions. On le passe au statut `reforme`.
- La vue est déclarée `SQL SECURITY INVOKER` : elle s'exécute avec les droits de l'utilisateur qui l'interroge.

## Les scénarios de mise à jour (partie B)

Chaque scénario est une transaction :

1. **Panne** du commutateur `sw-roa-acc-02`.
2. **Remplacement** par le commutateur en stock, renommé `sw-roa-acc-04`, qui reprend l'adresse d'administration de l'ancien.
3. **Achat et installation** de deux bornes Wi-Fi à Feurs.
4. **Mise à jour de sécurité** de tous les pare-feu en service, en une seule requête `INSERT … SELECT`.
5. **Extension de garantie** de deux ans pour les serveurs de Saint-Étienne.
6. **Départ d'un technicien** : il est désactivé, pas supprimé, pour garder l'historique.

## Vérifications effectuées

Tests réalisés sur MySQL 8.0.46 (Ubuntu 24.04) :

- import des deux scripts sans erreur, comptage final conforme au tableau ci-dessus ;
- contraintes actives : un VLAN numéroté 5000 est refusé, un équipement rattaché à un site inexistant est refusé, `DROP TABLE equipement` renvoie l'erreur 3730 ;
- aucune interface orpheline ;
- sauvegarde par `mysqldump` avec un compte limité à `SELECT, SHOW VIEW, TRIGGER` sur `parc.*`, puis restauration complète après suppression de la table `intervention`.

## Auteur

David Lacan · IUT de Roanne, Université Jean Monnet · david.lacan@univ-st-etienne.fr
