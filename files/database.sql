-- --------------------------------------------------------
-- Hôte:                         127.0.0.1
-- Version du serveur:           11.7.2-MariaDB - mariadb.org binary distribution
-- SE du serveur:                Win64
-- HeidiSQL Version:             12.10.0.7000
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- Listage de la structure de table onelife. account_info
CREATE TABLE IF NOT EXISTS `account_info` (
  `account_id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(50) NOT NULL,
  `steam` varchar(22) DEFAULT NULL,
  `xbl` varchar(50) DEFAULT NULL,
  `discord` varchar(50) DEFAULT NULL,
  `live` varchar(50) DEFAULT NULL,
  `fivem` varchar(50) DEFAULT NULL,
  `name` longtext DEFAULT NULL,
  `ip` varchar(20) DEFAULT NULL,
  `guid` varchar(20) DEFAULT NULL,
  `first_connection` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`account_id`) USING BTREE,
  UNIQUE KEY `license` (`license`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=32294 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- Listage de la structure de table onelife. baninfo
CREATE TABLE IF NOT EXISTS `baninfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(50) DEFAULT NULL,
  `identifier` varchar(25) DEFAULT NULL,
  `liveid` varchar(21) DEFAULT NULL,
  `xblid` varchar(21) DEFAULT NULL,
  `discord` varchar(30) DEFAULT NULL,
  `playerip` varchar(25) DEFAULT NULL,
  `playername` longtext DEFAULT NULL,
  `Token` longtext DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=8523 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- Listage de la structure de table onelife. bank_accounts
CREATE TABLE IF NOT EXISTS `bank_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(255) NOT NULL,
  `level` int(11) NOT NULL DEFAULT 0,
  `iban` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table onelife.bank_accounts : ~0 rows (environ)
DELETE FROM `bank_accounts`;

-- Listage de la structure de table onelife. banlist
CREATE TABLE IF NOT EXISTS `banlist` (
  `license` varchar(50) NOT NULL,
  `ban_id` varchar(255) DEFAULT NULL,
  `identifier` varchar(25) DEFAULT NULL,
  `liveid` varchar(21) DEFAULT NULL,
  `xblid` varchar(21) DEFAULT NULL,
  `discord` varchar(30) DEFAULT NULL,
  `playerip` varchar(25) DEFAULT NULL,
  `targetplayername` varchar(32) DEFAULT NULL,
  `sourceplayername` varchar(32) DEFAULT NULL,
  `reason` varchar(255) NOT NULL,
  `timeat` varchar(50) NOT NULL,
  `expiration` varchar(50) NOT NULL,
  `permanent` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`license`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.banlist : ~0 rows (environ)
DELETE FROM `banlist`;

-- Listage de la structure de table onelife. banlisthistory
CREATE TABLE IF NOT EXISTS `banlisthistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ban_id` varchar(255) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `identifier` varchar(25) DEFAULT NULL,
  `liveid` varchar(21) DEFAULT NULL,
  `xblid` varchar(21) DEFAULT NULL,
  `discord` varchar(30) DEFAULT NULL,
  `playerip` varchar(25) DEFAULT NULL,
  `targetplayername` varchar(32) DEFAULT NULL,
  `sourceplayername` varchar(32) DEFAULT NULL,
  `reason` varchar(255) NOT NULL,
  `timeat` int(11) NOT NULL,
  `added` varchar(40) NOT NULL,
  `expiration` int(11) NOT NULL,
  `permanent` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1602 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.banlisthistory : ~0 rows (environ)
DELETE FROM `banlisthistory`;

-- Listage de la structure de table onelife. billing
CREATE TABLE IF NOT EXISTS `billing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `sender` varchar(255) NOT NULL,
  `target_type` varchar(255) NOT NULL,
  `target` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_billing_identifier` (`identifier`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1410 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.billing : ~0 rows (environ)
DELETE FROM `billing`;

-- Listage de la structure de table onelife. boutique
CREATE TABLE IF NOT EXISTS `boutique` (
  `license` varchar(255) DEFAULT NULL,
  `fivem` varchar(255) DEFAULT NULL,
  `vip` varchar(255) DEFAULT NULL,
  `calendrier_noel` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.boutique : ~0 rows (environ)
DELETE FROM `boutique`;

-- Listage de la structure de table onelife. cardealer_vehicles
CREATE TABLE IF NOT EXISTS `cardealer_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vehicle` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT '',
  `price` int(11) NOT NULL,
  `society` varchar(50) NOT NULL DEFAULT 'carshop',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=17182 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.cardealer_vehicles : ~28 rows (environ)
DELETE FROM `cardealer_vehicles`;
INSERT INTO `cardealer_vehicles` (`id`, `vehicle`, `name`, `price`, `society`) VALUES
	(16744, 'feltzer3', 'Feltzer Clasique', 4000000, 'society_cardealer'),
	(16790, 'drafter', 'Obey 8F Drafter', 75000, 'society_cardealer'),
	(16800, 'asbo', 'Maxwell Asbo', 10000, 'society_cardealer'),
	(16858, 'alpha', 'Albany Alpha', 22500, 'society_cardealer'),
	(16861, 'sultan', 'Karin Sultan 1', 21250, 'society_cardealer'),
	(16877, 'panto', 'Benefactor Panto', 3750, 'society_cardealer'),
	(16878, 'comet6', 'Pfister Comet S2', 57500, 'society_cardealer'),
	(16884, 'panto', 'Benefactor Panto', 3750, 'society_cardealer'),
	(16907, 'adder', 'Truffade Adder', 250000, 'society_cardealer'),
	(16926, 'panto', 'Benefactor Panto', 3750, 'society_cardealer'),
	(16929, 'blista', 'Dinka Blista', 6250, 'society_cardealer'),
	(16935, 'issi2', 'Weeny Issi', 4000, 'society_cardealer'),
	(16947, 'kanjosj', 'Dinka KanjoSJ', 10000, 'society_cardealer'),
	(16948, 'brioso2', 'Brioso', 22500, 'society_cardealer'),
	(16949, 'asbo', 'Maxwell Asbo', 10000, 'society_cardealer'),
	(16967, 'thrax', 'Truffade Thrax', 635000, 'society_cardealer'),
	(16972, 'bf400', 'Nagasaki BF400', 10000, 'society_cardealer'),
	(17011, 'tezeract', 'Pegassi Tezeract', 775000, 'society_cardealer'),
	(17013, 'carbonrs', 'Nagasaki Carbon RS', 12000, 'society_cardealer'),
	(17035, 'panto', 'Benefactor Panto', 3750, 'society_cardealer'),
	(17037, 'panto', 'Benefactor Panto', 3750, 'society_cardealer'),
	(17077, 'deveste', 'Principe Deveste Eight', 875000, 'society_cardealer'),
	(17079, 'elegy', 'Annis Elegy RH8 Retro Custom', 100000, 'society_cardealer'),
	(17083, 'deveste', 'Principe Deveste Eight', 875000, 'society_cardealer'),
	(17141, 'coquette4', 'Invetero Coquette', 500000, 'society_cardealer'),
	(17143, 'iwagen', 'Obey I-Wagen', 62500, 'society_cardealer'),
	(17172, 'blista', 'Dinka Blista', 6250, 'society_cardealer'),
	(17181, 'sultan2', 'Karin Sultan 2', 21250, 'society_cardealer');

-- Listage de la structure de table onelife. casier
CREATE TABLE IF NOT EXISTS `casier` (
  `identifier` varchar(255) DEFAULT '''''',
  `Prenom` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `Nom` varchar(50) DEFAULT '',
  `naissance` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '',
  `raison` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '',
  `auteur` varchar(50) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.casier : ~0 rows (environ)
DELETE FROM `casier`;

-- Listage de la structure de table onelife. casino_cache
CREATE TABLE IF NOT EXISTS `casino_cache` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Settings` text CHARACTER SET utf8mb4 COLLATE utf8mb4_slovak_ci NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.casino_cache : ~0 rows (environ)
DELETE FROM `casino_cache`;

-- Listage de la structure de table onelife. casino_players
CREATE TABLE IF NOT EXISTS `casino_players` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(128) NOT NULL,
  `properties` longtext NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=926 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.casino_players : ~0 rows (environ)
DELETE FROM `casino_players`;

-- Listage de la structure de table onelife. chestbuilder
CREATE TABLE IF NOT EXISTS `chestbuilder` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pos` longtext DEFAULT NULL,
  `job` varchar(50) NOT NULL DEFAULT '0',
  `items` longtext NOT NULL,
  `maxWeight` int(11) NOT NULL DEFAULT 0,
  `accesbmoney` bit(1) NOT NULL DEFAULT b'0',
  `money` int(11) NOT NULL DEFAULT 0,
  `bmoney` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.chestbuilder : ~1 rows (environ)
DELETE FROM `chestbuilder`;
INSERT INTO `chestbuilder` (`id`, `pos`, `job`, `items`, `maxWeight`, `accesbmoney`, `money`, `bmoney`) VALUES
	(42, '{"x":222.218505859375,"y":-1111.4326171875,"z":29.23998260498047}', 'police', '{}', 100, b'0', 0, 0);

-- Listage de la structure de table onelife. clothes_data
CREATE TABLE IF NOT EXISTS `clothes_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` longtext NOT NULL,
  `name` longtext NOT NULL,
  `data` longtext DEFAULT NULL,
  `type` longtext NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=66076 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.clothes_data : ~0 rows (environ)
DELETE FROM `clothes_data`;

-- Listage de la structure de table onelife. drugss
CREATE TABLE IF NOT EXISTS `drugss` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdBy` text NOT NULL,
  `createdAt` text NOT NULL,
  `label` varchar(50) NOT NULL,
  `drugsInfos` text NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.drugss : ~7 rows (environ)
DELETE FROM `drugss`;
INSERT INTO `drugss` (`id`, `createdBy`, `createdAt`, `label`, `drugsInfos`) VALUES
	(6, 'none', 'none', 'weed', '{"rawItem":"weed","harvest":{"z":27.95937,"y":6503.103,"x":410.7797},"sellRewardPerCount":"73","name":"weed","treatmentCount":"1","treatmentReward":"1","sale":"1","treatedItem":"weed_pooch","vendor":{"z":-316.3931,"y":-9935.881,"x":816.6109},"treatement":{"z":27.86833,"y":6519.645,"x":412.1298},"sellCount":"1","harvestCount":"1"}'),
	(7, 'none', 'none', 'coke', '{"rawItem":"coke","harvest":{"z":26.28275,"y":1574.083,"x":2449.172},"sellRewardPerCount":"81","name":"coke","treatmentCount":"1","treatmentReward":"1","sale":"1","treatedItem":"coke_pooch","vendor":{"z":-2583.606,"y":-4629.874,"x":448.5531},"treatement":{"z":26.28275,"y":1562.518,"x":2451.919},"sellCount":"1","harvestCount":"1"}\n[23:54]'),
	(8, 'none', 'none', 'meth', '{"rawItem":"meth","harvest":{"z":38.65156,"y":4358.967,"x":1294.142},"sellRewardPerCount":"87","name":"meth","treatmentCount":"1","treatmentReward":"1","sale":"1","treatedItem":"meth_pooch","vendor":{"z":2432.153,"y":6194.414,"x":-6358.568},"treatement":{"z":38.15809,"y":4348.816,"x":1299.258},"sellCount":"1","harvestCount":"1"}'),
	(10, 'none', 'none', 'Bitcoin', '{"harvest":{"x":1273.3175048828126,"y":-1711.863037109375,"z":54.77141952514648},"sellCount":"1","treatedItem":"bitcoin","harvestCount":"1","rawItem":"bitcoin","treatmentReward":"1","name":"Bitcoin","treatement":{"x":6945.98388671875,"y":-668.0714721679688,"z":-188.35848999023438},"treatmentCount":"1","sale":"0","sellRewardPerCount":"50","vendor":{"x":605.7781372070313,"y":-3088.163330078125,"z":6.06926107406616}}'),
	(11, 'none', 'none', 'Tabac', '{"sellCount":"1","harvestCount":"1","name":"Tabac","harvest":{"y":4597.51220703125,"x":2854.02587890625,"z":47.86069107055664},"treatmentCount":"1","treatedItem":"tabacbrun","sellRewardPerCount":"95","treatement":{"y":3128.61376953125,"x":2340.943603515625,"z":48.20868301391601},"treatmentReward":"1","vendor":{"y":3842.948974609375,"x":1953.5892333984376,"z":32.18350982666015},"rawItem":"tabac","sale":"0"}\n'),
	(12, 'none', 'none', 'Ketamine', '{"treatmentReward":"1","vendor":{"z":263.3741455078125,"y":-3182.05224609375,"x":1384.3416748046876},"treatedItem":"pooch_ketamine","harvest":{"z":5.52790403366088,"y":-3192.218505859375,"x":1228.401611328125},"sale":"1","rawItem":"ketamine","sellRewardPerCount":"1","treatement":{"z":5.52791595458984,"y":-3191.67333984375,"x":1236.6905517578126},"sellCount":"1","name":"Ketamine","treatmentCount":"1","harvestCount":"1"}'),
	(14, 'none', 'none', 'xylazine', '{"harvestCount":"1","rawItem":"xylazine","sale":"1","treatedItem":"xylazine_pooch","name":"xylazine","harvest":{"y":-307.0762939453125,"x":1103.3011474609376,"z":59.35958099365234},"sellCount":"5","treatement":{"y":-316.0629577636719,"x":1100.23779296875,"z":59.35958099365234},"treatmentReward":"1","vendor":{"y":-214.7192840576172,"x":1803.037109375,"z":120.69371032714844},"treatmentCount":"3","sellRewardPerCount":"1"}');

-- Listage de la structure de table onelife. gangbuilder
CREATE TABLE IF NOT EXISTS `gangbuilder` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `posGarage` varchar(255) DEFAULT NULL,
  `posSpawnVeh` varchar(255) DEFAULT NULL,
  `posDeleteVeh` varchar(255) DEFAULT NULL,
  `posCoffre` varchar(255) DEFAULT NULL,
  `posBoss` varchar(255) DEFAULT NULL,
  `vehicules` longtext DEFAULT NULL,
  `inventory` longtext DEFAULT NULL,
  `grades` longtext DEFAULT NULL,
  `membres` longtext DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.gangbuilder : ~0 rows (environ)
DELETE FROM `gangbuilder`;

-- Listage de la structure de table onelife. hottubs
CREATE TABLE IF NOT EXISTS `hottubs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `coords` varchar(255) NOT NULL,
  `rotation` varchar(255) NOT NULL,
  `stairs` tinyint(1) NOT NULL DEFAULT 0,
  `type` tinyint(4) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `identifier` (`identifier`(191)) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.hottubs : ~0 rows (environ)
DELETE FROM `hottubs`;

-- Listage de la structure de table onelife. inventory_4_items
CREATE TABLE IF NOT EXISTS `inventory_4_items` (
  `uniqueID` varchar(512) NOT NULL,
  `type` varchar(64) DEFAULT NULL,
  `items` longtext NOT NULL,
  `originX` float DEFAULT NULL,
  `originY` float DEFAULT NULL,
  `originZ` float DEFAULT NULL,
  `expires` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`uniqueID`),
  KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage de la structure de table onelife. items
CREATE TABLE IF NOT EXISTS `items` (
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `weight` float NOT NULL DEFAULT 1,
  `can_remove` tinyint(1) NOT NULL DEFAULT 1,
  `type` varchar(255) DEFAULT NULL,
  `unique` int(11) DEFAULT 0,
  PRIMARY KEY (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.items : ~326 rows (environ)
DELETE FROM `items`;
INSERT INTO `items` (`name`, `label`, `weight`, `can_remove`, `type`, `unique`) VALUES
	('Faux papiers', 'faux_papiers', 0.1, 1, 'item', 0),
	('bandage', 'Bandage', 0.5, 1, 'item', 0),
	('basic_cuff', 'Menottes Basique', 0.5, 1, 'item', 0),
	('basic_key', 'Clefs de Menottes Basique', 0.5, 1, 'item', 0),
	('beer', 'Bière', 0.5, 1, 'item', 0),
	('bitcoin', 'Bitcoin', 1.5, 1, 'item', 0),
	('black_phone', 'Black Phone', 10, 1, 'item', 0),
	('blowpipe', 'Chalumeaux', 1.5, 1, 'item', 0),
	('blue_phone', 'Blue Phone', 10, 1, 'item', 0),
	('bread', 'Pain', 0.4, 1, 'item', 0),
	('brochet', 'Brochet', 0.4, 1, 'item', 0),
	('burger', 'Burger', 0.5, 1, 'item', 0),
	('burgerclassique', 'Burger Classique', 0.5, 1, 'item', 0),
	('cabillaud', 'Cabillaud', 0.6, 1, 'item', 0),
	('cacahuete', 'cacahuète', 0.5, 1, 'item', 0),
	('cagoule', 'Cagoule', 0.5, 1, 'item', 0),
	('capote', 'Capote', 0.5, 1, 'item', 0),
	('carotool', 'Outils carosserie', 4, 1, 'item', 0),
	('carton__ingredient_burgershot', 'Carton de ingrédient BurgerShot', 1, 1, 'item', 0),
	('carton_aliment_burgershot', 'Carton alimentaire BurgerShot', 1, 1, 'item', 0),
	('cash', 'Argent', 0, 1, 'accounts', 0),
	('casino_beer', 'Casino Beer', 0, 1, 'item', 0),
	('casino_burger', 'Burger', 0, 1, 'item', 0),
	('casino_chips', 'Casino Chips', 0, 1, 'item', 0),
	('casino_coffee', 'Casino Coffee', 0, 1, 'item', 0),
	('casino_coke', 'Casino Kofola', 0, 1, 'item', 0),
	('casino_donut', 'Donut', 0, 1, 'item', 0),
	('casino_ego_chaser', 'Casino Ego Chaser', 0, 1, 'item', 0),
	('casino_luckypotion', 'Casino Lucky Potion', 0, 1, 'item', 0),
	('casino_psqs', 'Casino Ps & Qs', 0, 1, 'item', 0),
	('casino_sandwitch', 'Sandwitch', 0.5, 1, 'item', 0),
	('casino_sprite', 'Casino Sprite', 0, 1, 'item', 0),
	('cb', 'Carte Bancaire', 1, 1, 'item', 0),
	('cbd', 'CBD', 1, 1, 'item', 0),
	('cbd_pooch', 'Pochon de CBD', 0.3, 1, 'item', 0),
	('chiffon_clean', 'Chiffon Microfibre', 2, 1, 'item', 0),
	('chip', 'Jeton', 0, 1, 'item', 0),
	('chips', 'chips', 0.5, 1, 'item', 0),
	('cigarette', 'Cigarette', 0.5, 1, 'item', 0),
	('classic_phone', 'Classic Phone', 2, 1, 'item', 0),
	('clip', 'Boite de munitions', 0.5, 1, 'item', 0),
	('coca', 'Coca', 0.5, 1, 'item', 0),
	('cofee', 'Café', 1, 1, 'item', 0),
	('coke', 'Coke', 1, 1, 'item', 0),
	('coke_pooch', 'Pochon de coke', 0.3, 1, 'item', 0),
	('cola', 'Cola', 0.5, 1, 'item', 0),
	('commandetacos', 'Commande Tacos', 1, 1, 'item', 0),
	('composant', 'Composant', 1, 1, 'item', 0),
	('composant_rtx', 'Composant RTX', 1, 1, 'item', 0),
	('cornichons', 'Cornichons', 0.5, 1, 'item', 0),
	('defibrillateur', 'Défibrillateur', 2, 1, 'item', 0),
	('dirtycash', 'Argent sale', 0, 1, 'accounts', 0),
	('donuts', 'Donuts', 1, 1, 'item', 0),
	('drive', 'Permis de conduire', 0, 1, 'item', 1),
	('drop_flareV2', 'Flare', 1, 1, 'item', 0),
	('fanta', 'fanta', 0.5, 1, 'item', 0),
	('feuille_coca', 'Feuille de coca', 1, 1, 'item', 0),
	('firstaidkit', 'Trousse premier secours', 1, 1, 'item', 0),
	('fish', 'Poisson', 0.5, 1, 'item', 0),
	('fishingrod', 'Canne à pêche', 0.5, 1, 'item', 0),
	('fixkit', 'Kit réparation', 1.5, 1, 'item', 0),
	('fixtool', 'Outils réparation', 2, 1, 'item', 0),
	('frites', 'Frites', 0.5, 1, 'item', 0),
	('gadget_parachute', 'Parachute', 1, 1, 'weapons', 1),
	('garnitures', 'Garnitures', 0.5, 1, 'item', 0),
	('gazbottle', 'Bouteille de gaz', 2, 1, 'item', 0),
	('gitanes', 'Gitanes', 0.5, 1, 'item', 0),
	('gold_phone', 'Gold Phone', 2, 1, 'item', 0),
	('gphone', 'gPhone', 1, 1, 'item', 0),
	('grand_cru', 'Grand cru', 0.5, 1, 'item', 0),
	('grapperaisin', 'Grappe de raisin', 0.5, 1, 'item', 0),
	('green_phone', 'Green Phone', 10, 1, 'item', 0),
	('greenlight_phone', 'Green Light Phone', 10, 1, 'item', 0),
	('handcuff', 'Serre câble ', 0.5, 1, 'item', 0),
	('hottub1', 'Hottub 1', 1, 1, 'item', 0),
	('hottub1stairs', 'Hottub 1 Stairs', 1, 1, 'item', 0),
	('hottub2', 'Hottub 2', 1, 1, 'item', 0),
	('hottub2stairs', 'Hottub 2 Stairs', 1, 1, 'item', 0),
	('hottub3', 'Hottub 3', 1, 1, 'item', 0),
	('hottub3stairs', 'Hottub 3 Stairs', 1, 1, 'item', 0),
	('ice', 'Glaçon', 0.5, 1, 'item', 0),
	('icetea', 'icetea', 0.5, 1, 'item', 0),
	('id_card_f', 'Carte de sécurité', 0.5, 1, 'item', 0),
	('idcard', 'Carte Identité', 0, 1, 'item', 1),
	('jager', 'Jägermeister', 0.5, 1, 'item', 0),
	('jagerbomb', 'Jägermeister', 0.5, 1, 'item', 0),
	('jagercerbere', 'Jäger Cerbère', 0.5, 1, 'item', 0),
	('jerican', 'Jerican', 4, 1, 'item', 0),
	('jewels', 'Bijoux', 1, 1, 'item', 0),
	('job_barilpetrole', 'Baril de petrole', 1, 1, 'item', 0),
	('job_cartemere', 'Carte mere', 0.5, 1, 'item', 0),
	('job_pc', 'pc', 1, 1, 'item', 0),
	('job_polypropylene', 'Polypropylene', 0.5, 1, 'item', 0),
	('job_tomate', 'Tomate Fraiche', 0.5, 1, 'item', 0),
	('job_ttomate', 'Tomate Traiter', 1, 1, 'item', 0),
	('jumelles', 'Jumelles', 0.5, 1, 'item', 0),
	('jus_coca', 'Jus de coca', 0.5, 1, 'item', 0),
	('jus_de_pomme', 'Jus de Pomme', 0.5, 1, 'item', 0),
	('jus_raisin', 'Jus de raisin', 0.5, 1, 'item', 0),
	('jusfruit', 'Jus de fruits', 0.5, 1, 'item', 0),
	('ketamine', 'Ketamine', 1, 1, 'item', 0),
	('kevlar', 'Kevlar Lourd', 2.5, 1, 'item', 0),
	('kevlarlow', 'Kevlar Léger', 0.5, 1, 'item', 0),
	('kevlarmid', 'Kevlar Medium', 1.5, 1, 'item', 0),
	('kitcrochetage', 'Kit de crochetage', 1, 1, 'item', 0),
	('kq_outfitbag', 'Outfit bag', 4, 1, 'item', 0),
	('lamp', 'Lampe pour Weed', 0.3, 1, 'item', 0),
	('latex', 'Latex', 1.5, 1, 'item', 0),
	('limonade', 'Limonade', 0.5, 1, 'item', 0),
	('lingotor', 'Lingot d\'or', 1, 1, 'item', 0),
	('lockpick', 'Pied de Biche', 1, 1, 'item', 0),
	('malbora', 'Malboro', 0.5, 1, 'item', 0),
	('martini', 'Martini blanc', 1, 1, 'item', 0),
	('meat', 'Viande', 0.5, 1, 'item', 0),
	('medikit', 'Medikit', 0.5, 1, 'item', 0),
	('menthe', 'Feuille de menthe', 1, 1, 'item', 0),
	('meth', 'Meth', 1, 1, 'item', 0),
	('meth_pooch', 'Pochon de meth', 0.3, 1, 'item', 0),
	('metreshooter', 'Mètre de shooter', 0.5, 1, 'item', 0),
	('mixapero', 'Mix Apéritif', 0.5, 1, 'item', 0),
	('mojito', 'Mojito', 0.5, 1, 'item', 0),
	('munitions', 'Munitions de pistolet', 0.5, 1, 'item', 0),
	('olive', 'Olive', 0.5, 1, 'item', 0),
	('opium', 'Opium', 1, 1, 'item', 0),
	('opium_pooch', 'Pochon d\'Opium', 0.3, 1, 'item', 0),
	('orange', 'Orange', 0.5, 1, 'item', 0),
	('orange_juice', 'Jus d\'orange', 0.5, 1, 'item', 0),
	('orangina', 'Orangina', 0.5, 1, 'item', 0),
	('oxygen_mask', 'Masque à Oxygène', 0.6, 1, 'item', 0),
	('painburger', 'Pain Burger', 1, 1, 'item', 0),
	('paper', 'Papier', 0.5, 1, 'item', 0),
	('pepitor', 'Pépite d\'or', 1, 1, 'item', 0),
	('pepperspray', 'Gazeuse', 1, -1, 'item', 0),
	('phone', 'Téléphone', 0.5, 1, 'item', 0),
	('phone_hack', 'Phone Hack', 10, 1, 'item', 0),
	('phone_module', 'Phone Module', 10, 1, 'item', 0),
	('piluleoubli', 'GHB', 1, 1, 'item', 0),
	('pink_phone', 'Pink Phone', 10, 1, 'item', 0),
	('pizza', 'Pizza', 1, 1, 'item', 0),
	('plante', 'Plante du Jardinier', 2, 1, 'item', 0),
	('police_cuff', 'Menottes LSPD', 0.5, 1, 'item', 0),
	('police_key', 'Clefs de Menottes LSPD', 0.5, 1, 'item', 0),
	('pomme', 'Pomme', 1, 1, 'item', 0),
	('pooch_ketamine', 'Pochon de ketamine', 0.3, 1, 'item', 0),
	('pot', 'Pot', 0.5, 1, 'item', 0),
	('poulet', 'Poulet', 0.5, 1, 'item', 0),
	('powerbank', 'Power Bank', 10, 1, 'item', 0),
	('pâte a pizza', 'Pate à pizza', 1, 1, 'item', 0),
	('radio', 'Radio', 0.5, 1, 'item', 0),
	('raisin', 'Raisin', 0.5, 1, 'item', 0),
	('red_phone', 'Red Phone', 10, 1, 'item', 0),
	('redbull', 'Redbull', 0.5, 1, 'item', 0),
	('redmonney', 'Faux Billet', 0.5, 1, 'item', 0),
	('repairkit', 'Kit de réparation', 2, 1, 'item', 0),
	('reparkit', 'Kit de réparation', 5, 1, 'item', 0),
	('rhum', 'Rhum', 0.5, 1, 'item', 0),
	('rhumcoca', 'Rhum-Coca', 0.5, 1, 'item', 0),
	('rhumfruit', 'Rhum-Jus de fruits', 0.5, 1, 'item', 0),
	('rorge', 'orge', 1, 1, 'item', 0),
	('rtissu', 'Tissu', 1, 1, 'item', 0),
	('rtx_4090', 'RTX 4090', 1, 1, 'item', 0),
	('salade', 'Salade', 0.5, 1, 'item', 0),
	('sardine', 'Sardine', 1, 1, 'item', 0),
	('saumon', 'Saumon', 1, 1, 'item', 0),
	('scrap', 'Pieces Détachés', 1, 1, 'item', 0),
	('scratch_ticket', 'Ticket a gratter', 2, 1, 'item', 0),
	('steak', 'Steak Haché', 1, 1, 'item', 0),
	('tabac', 'Tabac', 1.5, 1, 'item', 0),
	('tabacblond', 'Tabac Blond', 0.5, 1, 'item', 0),
	('tabacblondsec', 'Tabac Blond Séché', 0.5, 1, 'item', 0),
	('tabacbrun', 'Tabac Brun', 0.5, 1, 'item', 0),
	('tabacbrunsec', 'Tabac Brun Séché', 0.5, 1, 'item', 0),
	('tarte_pomme', 'Tarte aux Pommes', 0.5, 1, 'item', 0),
	('teqpaf', 'Teq\'paf', 0.5, 1, 'item', 0),
	('tequila', 'Tequila', 0.5, 1, 'item', 0),
	('thon', 'Thon', 1, 1, 'item', 0),
	('tomates', 'Tomates', 0.5, 1, 'item', 0),
	('tpoulet', 'Wings', 0.5, 1, 'item', 0),
	('truite', 'Truite', 1, 1, 'item', 0),
	('ttissu', 'Vetement Nike', 1, 1, 'item', 0),
	('twisky', 'wisky', 1, 1, 'item', 0),
	('viande_1', 'Viande Blanche', 1.5, 1, 'item', 0),
	('viande_2', 'Viande Rouge', 2.5, 1, 'item', 0),
	('vine', 'Bouteille de Vin', 0.5, 1, 'item', 0),
	('vittvin', 'Vin Blanc', 0.5, 1, 'item', 0),
	('vodka', 'Vodka', 0.5, 1, 'item', 0),
	('vodkaenergy', 'Vodka-Energy', 0.5, 1, 'item', 0),
	('vodkafruit', 'Vodka-Jus de fruits', 0.5, 1, 'item', 0),
	('vodkaredbull', 'Vodka-Redbull', 0.5, 1, 'item', 0),
	('water', 'Bouteille d\'eau', 0.5, 1, 'item', 0),
	('waterpass', 'Water Pass', 0.5, 1, 'item', 0),
	('waterpassunlimited', 'Water Pass Unlimited', 0.5, 1, 'item', 0),
	('weapon', 'Permis port d\'armes', 0, 1, 'item', 1),
	('weapon_advancedrifle', 'Fusil Avancé', 1, 1, 'weapons', 1),
	('weapon_appistol', 'Pistolet Perforant', 1, 1, 'weapons', 1),
	('weapon_assaultrifle', 'AK-47', 1, 1, 'weapons', 1),
	('weapon_assaultrifle_mk2', 'AK-47 MK2', 1, 1, 'weapons', 1),
	('weapon_assaultshotgun', 'Fusil à Pompe D\'assaut', 1, 1, 'weapons', 1),
	('weapon_assaultsmg', 'Mitraillette D\'assaut', 1, 1, 'weapons', 1),
	('weapon_autoshotgun', 'Fusil à Pompe Auto', 1, 1, 'weapons', 1),
	('weapon_ball', 'Balle', 1, 1, 'weapons', 1),
	('weapon_bat', 'Batte De Baseball', 1, 1, 'weapons', 1),
	('weapon_battleaxe', 'Hache', 1, 1, 'weapons', 1),
	('weapon_bayonet', 'Bayonet', 1, 1, 'weapons', 1),
	('weapon_beanbag', 'Pompe Bean-Bag', 1, 1, 'weapons', 1),
	('weapon_bottle', 'Bouteille Cassé', 1, 1, 'weapons', 1),
	('weapon_bullpuprifle', 'Fusil Bullpup', 1, 1, 'weapons', 1),
	('weapon_bullpuprifle_mk2', 'Fusil Bullpup MK2', 1, 1, 'weapons', 1),
	('weapon_bullpupshotgun', 'Fusil à Pompe Bullpup', 1, 1, 'weapons', 1),
	('weapon_bzgas', 'Gaz Lacrymogène', 1, 1, 'weapons', 1),
	('weapon_carbinerifle', 'M4A1', 1, 1, 'weapons', 1),
	('weapon_carbinerifle_mk2', 'M4A1 MK2', 1, 1, 'weapons', 1),
	('weapon_ceramicpistol', 'Pistolet En Céramique', 1, 1, 'weapons', 1),
	('weapon_combatmg', 'M60', 1, 1, 'weapons', 1),
	('weapon_combatmg_mk2', 'M60 MK2', 1, 1, 'weapons', 1),
	('weapon_combatpdw', 'Arme De Défense Personnelle', 1, 1, 'weapons', 1),
	('weapon_combatpistol', 'Pistolet De Combat', 1, 1, 'weapons', 1),
	('weapon_combatshotgun', 'Fusil à Pompe De Combat', 1, 1, 'weapons', 1),
	('weapon_compactlauncher', 'Lance Grenades Compact', 1, 1, 'weapons', 1),
	('weapon_compactrifle', 'AK Compact', 1, 1, 'weapons', 1),
	('weapon_crowbar', 'Pied De Biche', 1, 1, 'weapons', 1),
	('weapon_dagger', 'Poignard', 1, 1, 'weapons', 1),
	('weapon_dbshotgun', 'Fusil à Double Canon', 1, 1, 'weapons', 1),
	('weapon_doubleaction', 'Revolver Double Action', 1, 1, 'weapons', 1),
	('weapon_emplauncher', 'Lanceur EMP Compact', 1, 1, 'weapons', 1),
	('weapon_fertilizercan', 'Bidon D\'engrais', 1, 1, 'weapons', 1),
	('weapon_fireextinguisher', 'Extincteur', 1, 1, 'weapons', 1),
	('weapon_firework', 'Lanceur De Feu D\'artifice', 1, 1, 'weapons', 1),
	('weapon_flare', 'Fumée De Détresse', 1, 1, 'weapons', 1),
	('weapon_flaregun', 'Pistolet De Détresse', 1, 1, 'weapons', 1),
	('weapon_flashlight', 'Lampe Torche', 1, 1, 'weapons', 1),
	('weapon_gadgetpistol', 'Pistolet Cayo Périco', 1, 1, 'weapons', 1),
	('weapon_golfclub', 'Club De Golf', 1, 1, 'weapons', 1),
	('weapon_grenade', 'Grenade', 1, 1, 'weapons', 1),
	('weapon_grenadelauncher', 'Lance Grenades', 1, 1, 'weapons', 1),
	('weapon_gusenberg', 'Gusenberg', 1, 1, 'weapons', 1),
	('weapon_hammer', 'Marteau', 1, 1, 'weapons', 1),
	('weapon_hatchet', 'Hachette', 1, 1, 'weapons', 1),
	('weapon_hazardcan', 'Jerrycan Dangereux', 1, 1, 'weapons', 1),
	('weapon_heavypistol', 'Pistolet Lourd', 1, 1, 'weapons', 1),
	('weapon_heavyrifle', 'Fusil Lourd', 1, 1, 'weapons', 1),
	('weapon_heavyshotgun', 'Fusil à Pompe Lourd', 1, 1, 'weapons', 1),
	('weapon_heavysniper', 'Sniper Lourd', 1, 1, 'weapons', 1),
	('weapon_heavysniper_mk2', 'Sniper Lourd MK2', 1, 1, 'weapons', 1),
	('weapon_hominglauncher', 'Homing', 1, 1, 'weapons', 1),
	('weapon_karambit', 'Karambit', 1, 1, 'weapons', 1),
	('weapon_katana', 'Katana', 1, 1, 'weapons', 1),
	('weapon_knife', 'Couteau', 1, 1, 'weapons', 1),
	('weapon_knuckle', 'Poing Américain', 1, 1, 'weapons', 1),
	('weapon_lucile', 'Lucile', 1, 1, 'weapons', 1),
	('weapon_machete', 'Machette', 1, 1, 'weapons', 1),
	('weapon_machinepistol', 'Tec-9', 1, 1, 'weapons', 1),
	('weapon_marksmanpistol', 'Pistolet De Tireur D\'élite', 1, 1, 'weapons', 1),
	('weapon_marksmanrifle', 'Sniper Tireur D\'élite', 1, 1, 'weapons', 1),
	('weapon_marksmanrifle_mk2', 'Sniper Tireur D\'élite MK2', 1, 1, 'weapons', 1),
	('weapon_mg', 'Mitrailleuse Légère', 1, 1, 'weapons', 1),
	('weapon_microsmg', 'Micro Uzi', 1, 1, 'weapons', 1),
	('weapon_militaryrifle', 'Fusil Militaire', 1, 1, 'weapons', 1),
	('weapon_minigun', 'Minigun', 1, 1, 'weapons', 1),
	('weapon_minismg', 'Scorpion', 1, 1, 'weapons', 1),
	('weapon_molotov', 'Cocktails Molotov', 1, 1, 'weapons', 1),
	('weapon_musket', 'Mousquet', 1, 1, 'weapons', 1),
	('weapon_navyrevolver', 'Navy Revolver', 1, 1, 'weapons', 1),
	('weapon_nightstick', 'Matraque', 1, 1, 'weapons', 1),
	('weapon_pan', 'Poele', 1, 1, 'weapons', 1),
	('weapon_petrolcan', 'Jerrican D\'essence', 1, 1, 'weapons', 1),
	('weapon_pipebomb', 'Bombe Artisanale', 1, 1, 'weapons', 1),
	('weapon_pistol', 'Beretta', 1, 1, 'weapons', 1),
	('weapon_pistol50', 'Calibre 50', 1, 1, 'weapons', 1),
	('weapon_pistol_mk2', 'Beretta MK2', 1, 1, 'weapons', 1),
	('weapon_poolcue', 'Queue De Billard', 1, 1, 'weapons', 1),
	('weapon_precisionrifle', 'Sniper De Précision', 1, 1, 'weapons', 1),
	('weapon_proxmine', 'Mine De Proximité', 1, 1, 'weapons', 1),
	('weapon_pumpshotgun', 'Fusil à Pompe', 1, 1, 'weapons', 1),
	('weapon_pumpshotgun_mk2', 'Fusil à Pompe MK2', 1, 1, 'weapons', 1),
	('weapon_railgun', 'Fusil à Rail', 1, 1, 'weapons', 1),
	('weapon_raycarbine', 'Carabine Laser', 1, 1, 'weapons', 1),
	('weapon_rayminigun', 'Minigun Laser', 1, 1, 'weapons', 1),
	('weapon_raypistol', 'Pistolet Rayon', 1, 1, 'weapons', 1),
	('weapon_revolver', 'Revolver', 1, 1, 'weapons', 1),
	('weapon_revolver_mk2', 'Revolver MK2', 1, 1, 'weapons', 1),
	('weapon_rpg', 'RPG', 1, 1, 'weapons', 1),
	('weapon_sawnoffshotgun', 'Canon Scié', 1, 1, 'weapons', 1),
	('weapon_smg', 'MP5', 1, 1, 'weapons', 1),
	('weapon_smg_mk2', 'MP5 MK2', 1, 1, 'weapons', 1),
	('weapon_smokegrenade', 'Fumigène', 1, 1, 'weapons', 1),
	('weapon_sniperrifle', 'Sniper', 1, 1, 'weapons', 1),
	('weapon_snowball', 'Brique', 1, 1, 'weapons', 1),
	('weapon_snspistol', 'Pétoire', 1, 1, 'weapons', 1),
	('weapon_snspistol_mk2', 'Pétoire MK2', 1, 1, 'weapons', 1),
	('weapon_specialcarbine', 'G36', 1, 1, 'weapons', 1),
	('weapon_specialcarbine_mk2', 'G36 MK2', 1, 1, 'weapons', 1),
	('weapon_stickybomb', 'Bombes Collantes', 1, 1, 'weapons', 1),
	('weapon_stone_hatchet', 'Hachette En Pierre', 1, 1, 'weapons', 1),
	('weapon_stungun', 'Taser', 1, 1, 'weapons', 1),
	('weapon_switchblade', 'Couteau Papillon', 1, 1, 'weapons', 1),
	('weapon_tacticalrifle', 'Fusil Tactique', 1, 1, 'weapons', 1),
	('weapon_tridagger', 'Dagger', 1, 1, 'weapons', 1),
	('weapon_vintagepistol', 'Pistolet Vintage', 1, 1, 'weapons', 1),
	('weapon_wrench', 'Clé à Molette', 1, 1, 'weapons', 1),
	('weed_candy_leaf', 'Graine Candy', 0.5, 1, 'item', 0),
	('weed_head_candy', 'Tete de Candy', 1, 1, 'item', 0),
	('weed_head_mac10', 'Tete de Mac 10', 1, 1, 'item', 0),
	('weed_head_og', 'Tete de OG W', 1, 1, 'item', 0),
	('weed_head_rain', 'Tete de Rainbow', 1, 1, 'item', 0),
	('weed_head_tropical', 'Tete de Tropical', 1, 1, 'item', 0),
	('weed_mac10_leaf', 'Graine Mac10', 0.5, 1, 'item', 0),
	('weed_og_leaf', 'Graine OG W', 0.5, 1, 'item', 0),
	('weed_rainbow_leaf', 'Graine Rainbow', 0.5, 1, 'item', 0),
	('weed_tropical_leaf', 'Graine Tropical', 0.5, 1, 'item', 0),
	('wet_black_phone', 'Wet Black Phone', 10, 1, 'item', 0),
	('wet_blue_phone', 'Wet Blue Phone', 10, 1, 'item', 0),
	('wet_classic_phone', 'Wet Classic Phone', 10, 1, 'item', 0),
	('wet_gold_phone', 'Wet Gold Phone', 10, 1, 'item', 0),
	('wet_green_phone', 'Wet Green Phone', 10, 1, 'item', 0),
	('wet_greenlight_phone', 'Wet Green Light Phone', 10, 1, 'item', 0),
	('wet_pink_phone', 'Wet Pink Phone', 10, 1, 'item', 0),
	('wet_red_phone', 'Wet Red Phone', 10, 1, 'item', 0),
	('wet_white_phone', 'Wet White Phone', 10, 1, 'item', 0),
	('whisky', 'Whisky', 0.5, 1, 'item', 0),
	('whiskycoca', 'Whisky-coca', 0.5, 1, 'item', 0),
	('white_phone', 'White Phone', 10, 1, 'item', 0),
	('wiskycoca', 'wiskycoca', 0.5, 1, 'item', 0),
	('xylazine', 'xylazine', 0.5, 1, 'item', 0),
	('xylazine_pooch', 'Pochon de xylazine', 0.3, 1, 'item', 0),
	('zetony', 'Jetons', 0.5, 1, 'item', 0);

-- Listage de la structure de table onelife. jail
CREATE TABLE IF NOT EXISTS `jail` (
  `identifier` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tasks` int(100) NOT NULL,
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `staffname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table onelife.jail : ~0 rows (environ)
DELETE FROM `jail`;

-- Listage de la structure de table onelife. jailed_players
CREATE TABLE IF NOT EXISTS `jailed_players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(50) NOT NULL,
  `staff_license` varchar(50) DEFAULT NULL,
  `staff_name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table onelife.jailed_players : ~0 rows (environ)
DELETE FROM `jailed_players`;

-- Listage de la structure de table onelife. jobbuilder
CREATE TABLE IF NOT EXISTS `jobbuilder` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `society` varchar(50) NOT NULL,
  `posboss` varchar(255) NOT NULL,
  `posveh` varchar(255) NOT NULL,
  `poscoffre` varchar(255) NOT NULL,
  `posspawncar` varchar(255) NOT NULL,
  `nameitemrecolte` varchar(50) NOT NULL,
  `labelitemrecolte` varchar(50) NOT NULL,
  `posrecolte` varchar(255) NOT NULL,
  `nameitemtraitement` varchar(50) NOT NULL,
  `labelitemtraitement` varchar(50) NOT NULL,
  `postraitement` varchar(255) NOT NULL,
  `vehingarage` varchar(255) NOT NULL,
  `posvente` varchar(255) NOT NULL,
  `prixvente` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.jobbuilder : ~0 rows (environ)
DELETE FROM `jobbuilder`;

-- Listage de la structure de table onelife. jobs
CREATE TABLE IF NOT EXISTS `jobs` (
  `name` varchar(50) NOT NULL,
  `label` varchar(255) NOT NULL,
  `societyType` int(11) NOT NULL DEFAULT 1,
  `canWashMoney` tinyint(1) NOT NULL DEFAULT 0,
  `canUseOffshore` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.jobs : ~45 rows (environ)
DELETE FROM `jobs`;
INSERT INTO `jobs` (`name`, `label`, `societyType`, `canWashMoney`, `canUseOffshore`) VALUES
	('Ballas', 'Ballas', 2, 0, 0),
	('Cayo', 'Cayo', 2, 0, 0),
	('F4L', 'F4L', 2, 0, 0),
	('Marabunta', 'Marabunta', 2, 0, 0),
	('RaRecords', 'rarecords', 1, 0, 0),
	('ambulance', 'Ambulance', 1, 0, 0),
	('appleindustrie', 'Apple Industrie', 1, 0, 0),
	('avocat', 'Avocat', 1, 0, 0),
	('bcso', 'S.A.S.D', 1, 0, 0),
	('boatseller', 'Concessionnaire Bénéteau', 1, 1, 0),
	('bonelli', 'Bonelli', 2, 0, 0),
	('burgershot', 'BurgerShot', 1, 1, 0),
	('cardealer', 'Concessionnaire', 1, 1, 0),
	('chickenbell', 'ChickenBell', 1, 0, 0),
	('churchtown', 'ChurchTown', 1, 0, 0),
	('delivery', 'Delivery', 1, 0, 0),
	('duggan', 'Duggan', 2, 0, 0),
	('fib', 'FIB', 1, 0, 0),
	('fisherman', 'Pêcheur', 1, 0, 0),
	('fueler', 'Raffineur', 1, 0, 0),
	('gouv', 'Gouvernement', 1, 0, 0),
	('jardinier', 'Jardinier', 1, 0, 0),
	('journalist', 'Journaliste', 1, 1, 0),
	('label', 'RA Records', 1, 1, 0),
	('lost', 'Lost', 2, 0, 0),
	('lumberjack', 'Bûcheron', 1, 0, 0),
	('madrazo', 'madrazo', 2, 0, 0),
	('mayansmc', 'Mayans', 2, 0, 0),
	('mecano', 'Benny\'s', 1, 1, 0),
	('mecano2', 'Ls Custom', 1, 1, 0),
	('miner', 'Mineur', 1, 0, 0),
	('planeseller', 'Concessionnaire Aéronotique', 1, 1, 0),
	('police', 'Police', 1, 0, 0),
	('realestateagent', 'Agent immobilier', 1, 0, 0),
	('slaughterer', 'Abateur', 1, 0, 0),
	('tacos', 'Tacos', 1, 0, 0),
	('tailor', 'Couturier', 1, 0, 0),
	('taxi', 'Taxi', 1, 1, 0),
	('tequilala', 'Tequilala', 1, 0, 0),
	('unemployed', 'Citoyen', 3, 0, 0),
	('unemployed2', 'Aucune', 3, 0, 0),
	('unicorn', 'Unicorn', 1, 1, 0),
	('vagos', 'Vagos', 2, 0, 0),
	('vigneron', 'Vigneron', 1, 1, 0),
	('white', 'White', 2, 0, 0);

-- Listage de la structure de table onelife. job_grades
CREATE TABLE IF NOT EXISTS `job_grades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_name` varchar(50) DEFAULT NULL,
  `grade` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) NOT NULL,
  `salary` int(11) NOT NULL,
  `skin_male` longtext NOT NULL,
  `skin_female` longtext NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2279 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.job_grades : ~181 rows (environ)
DELETE FROM `job_grades`;
INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
	(1, 'ambulance', 0, 'stagiaire', 'Ambulancier', 1, '{"beard_1":0,"eye_color":0,"makeup_3":0,"blemishes_1":0,"mask_1":0,"glasses_1":0,"bproof_2":0,"lipstick_3":0,"beard_2":0,"torso_1":33,"pants_1":19,"blush_3":0,"torso_2":1,"blush_2":0,"complexion_1":0,"lipstick_2":0,"makeup_2":0,"bproof_1":0,"sun_2":0,"complexion_2":0,"chain_2":0,"sun_1":0,"eyebrows_3":0,"tshirt_1":21,"hair_color_1":0,"eyebrows_2":0,"mask_2":0,"helmet_2":0,"hair_2":0,"beard_3":0,"moles_2":0,"bags_1":0,"arms_2":0,"decals_2":0,"age_1":0,"ears_1":-1,"moles_1":0,"bracelets_2":0,"watches_1":-1,"face":0,"bags_2":0,"pants_2":11,"chest_3":0,"blemishes_2":0,"chest_1":0,"hair_color_2":0,"blush_1":0,"tshirt_2":0,"helmet_1":-1,"hair_1":0,"shoes_2":0,"lipstick_4":0,"eyebrows_4":0,"ears_2":0,"watches_2":0,"bodyb_2":0,"bodyb_1":0,"eyebrows_1":0,"decals_1":57,"makeup_4":0,"glasses_2":0,"age_2":0,"shoes_1":8,"arms":91,"chain_1":0,"bracelets_1":-1,"chest_2":0,"beard_4":0,"makeup_1":0,"lipstick_1":0,"skin":0,"sex":0}', '{"age_1":0,"blush_3":0,"complexion_2":0,"bracelets_2":0,"chain_2":0,"bodyb_1":0,"pants_1":23,"hair_1":4,"lipstick_4":0,"bproof_2":0,"bodyb_2":0,"shoes_2":1,"sun_2":0,"blush_1":0,"shoes_1":4,"decals_1":65,"eyebrows_2":10,"makeup_1":6,"glasses":0,"chest_3":0,"bags_2":0,"arms":105,"watches_1":2,"arms_2":0,"hair_color_1":28,"beard_3":0,"chain_1":96,"chest_1":0,"mask_1":0,"sex":1,"decals_2":0,"bproof_1":0,"hair_color_2":28,"eyebrows_3":61,"makeup_2":8,"helmet_1":-1,"bags_1":0,"lipstick_3":23,"face":45,"bracelets_1":-1,"tshirt_1":29,"beard_4":0,"moles_2":10,"mask_2":0,"helmet_2":0,"makeup_3":25,"skin":10,"beard_2":0,"shoes":1,"blemishes_2":0,"moles_1":0,"pants_2":0,"complexion_1":0,"glasses_2":1,"age_2":0,"ears_1":12,"watches_2":0,"eyebrows_4":0,"eye_color":3,"lipstick_2":4,"glasses_1":11,"eyebrows_1":1,"ears_2":0,"makeup_4":18,"sun_1":0,"blush_2":0,"torso_2":0,"chest_2":0,"hair_2":0,"tshirt_2":0,"torso_1":257,"lipstick_1":1,"blemishes_1":0,"beard_1":0}'),
	(2, 'ambulance', 1, 'ambulance', 'Infirmier', 1, '{"beard_1":0,"eye_color":0,"makeup_3":0,"blemishes_1":0,"mask_1":0,"glasses_1":0,"bproof_2":0,"lipstick_3":0,"beard_2":0,"torso_1":33,"pants_1":19,"blush_3":0,"torso_2":1,"blush_2":0,"complexion_1":0,"lipstick_2":0,"makeup_2":0,"bproof_1":0,"sun_2":0,"complexion_2":0,"chain_2":0,"sun_1":0,"eyebrows_3":0,"tshirt_1":21,"hair_color_1":0,"eyebrows_2":0,"mask_2":0,"helmet_2":0,"hair_2":0,"beard_3":0,"moles_2":0,"bags_1":0,"arms_2":0,"decals_2":0,"age_1":0,"ears_1":-1,"moles_1":0,"bracelets_2":0,"watches_1":-1,"face":0,"bags_2":0,"pants_2":11,"chest_3":0,"blemishes_2":0,"chest_1":0,"hair_color_2":0,"blush_1":0,"tshirt_2":0,"helmet_1":-1,"hair_1":0,"shoes_2":0,"lipstick_4":0,"eyebrows_4":0,"ears_2":0,"watches_2":0,"bodyb_2":0,"bodyb_1":0,"eyebrows_1":0,"decals_1":57,"makeup_4":0,"glasses_2":0,"age_2":0,"shoes_1":8,"arms":91,"chain_1":0,"bracelets_1":-1,"chest_2":0,"beard_4":0,"makeup_1":0,"lipstick_1":0,"skin":0,"sex":0}', '{"age_1":0,"blush_3":0,"complexion_2":0,"bracelets_2":0,"chain_2":0,"bodyb_1":0,"pants_1":51,"hair_1":4,"lipstick_4":0,"bproof_2":0,"bodyb_2":0,"shoes_2":7,"sun_2":0,"blush_1":0,"shoes_1":1,"decals_1":66,"eyebrows_2":10,"makeup_1":6,"glasses":0,"chest_3":0,"bags_2":0,"arms":106,"watches_1":2,"arms_2":0,"hair_color_1":28,"beard_3":0,"chain_1":96,"chest_1":0,"mask_1":0,"sex":1,"decals_2":0,"bproof_1":0,"hair_color_2":28,"eyebrows_3":61,"makeup_2":8,"helmet_1":-1,"bags_1":0,"lipstick_3":23,"face":45,"bracelets_1":-1,"tshirt_1":29,"beard_4":0,"moles_2":10,"mask_2":0,"helmet_2":0,"makeup_3":25,"skin":10,"beard_2":0,"shoes":1,"blemishes_2":0,"moles_1":0,"pants_2":0,"complexion_1":0,"glasses_2":1,"age_2":0,"ears_1":12,"watches_2":0,"eyebrows_4":0,"eye_color":3,"lipstick_2":4,"glasses_1":11,"eyebrows_1":1,"ears_2":0,"makeup_4":18,"sun_1":0,"blush_2":0,"torso_2":2,"chest_2":0,"hair_2":0,"tshirt_2":0,"torso_1":9,"lipstick_1":1,"blemishes_1":0,"beard_1":0}'),
	(3, 'ambulance', 2, 'infirmier', 'Médecin', 1, '{"beard_1":0,"eye_color":0,"makeup_3":0,"blemishes_1":0,"mask_1":0,"glasses_1":0,"bproof_2":0,"lipstick_3":0,"beard_2":0,"torso_1":33,"pants_1":19,"blush_3":0,"torso_2":1,"blush_2":0,"complexion_1":0,"lipstick_2":0,"makeup_2":0,"bproof_1":0,"sun_2":0,"complexion_2":0,"chain_2":0,"sun_1":0,"eyebrows_3":0,"tshirt_1":21,"hair_color_1":0,"eyebrows_2":0,"mask_2":0,"helmet_2":0,"hair_2":0,"beard_3":0,"moles_2":0,"bags_1":0,"arms_2":0,"decals_2":0,"age_1":0,"ears_1":-1,"moles_1":0,"bracelets_2":0,"watches_1":-1,"face":0,"bags_2":0,"pants_2":11,"chest_3":0,"blemishes_2":0,"chest_1":0,"hair_color_2":0,"blush_1":0,"tshirt_2":0,"helmet_1":-1,"hair_1":0,"shoes_2":0,"lipstick_4":0,"eyebrows_4":0,"ears_2":0,"watches_2":0,"bodyb_2":0,"bodyb_1":0,"eyebrows_1":0,"decals_1":57,"makeup_4":0,"glasses_2":0,"age_2":0,"shoes_1":8,"arms":91,"chain_1":0,"bracelets_1":-1,"chest_2":0,"beard_4":0,"makeup_1":0,"lipstick_1":0,"skin":0,"sex":0}', '{"age_1":0,"blush_3":0,"complexion_2":0,"bracelets_2":0,"chain_2":0,"bodyb_1":0,"pants_1":50,"hair_1":4,"lipstick_4":0,"bproof_2":0,"bodyb_2":0,"shoes_2":2,"sun_2":0,"blush_1":0,"shoes_1":4,"decals_1":66,"eyebrows_2":10,"makeup_1":6,"glasses":0,"chest_3":0,"bags_2":0,"arms":96,"watches_1":2,"arms_2":0,"hair_color_1":28,"beard_3":0,"chain_1":96,"chest_1":0,"mask_1":0,"sex":1,"decals_2":0,"bproof_1":0,"hair_color_2":28,"eyebrows_3":61,"makeup_2":8,"helmet_1":-1,"bags_1":0,"lipstick_3":23,"face":45,"bracelets_1":-1,"tshirt_1":29,"beard_4":0,"moles_2":10,"mask_2":0,"helmet_2":0,"makeup_3":25,"skin":10,"beard_2":0,"shoes":1,"blemishes_2":0,"moles_1":0,"pants_2":0,"complexion_1":0,"glasses_2":1,"age_2":0,"ears_1":12,"watches_2":0,"eyebrows_4":0,"eye_color":3,"lipstick_2":4,"glasses_1":11,"eyebrows_1":1,"ears_2":0,"makeup_4":18,"sun_1":0,"blush_2":0,"torso_2":0,"chest_2":0,"hair_2":0,"tshirt_2":0,"torso_1":258,"lipstick_1":1,"blemishes_1":0,"beard_1":0}'),
	(4, 'ambulance', 3, 'chirurgien', 'Chirurgien', 1, '{"beard_1":0,"eye_color":0,"makeup_3":0,"blemishes_1":0,"mask_1":0,"glasses_1":0,"bproof_2":0,"lipstick_3":0,"beard_2":0,"torso_1":33,"pants_1":19,"blush_3":0,"torso_2":1,"blush_2":0,"complexion_1":0,"lipstick_2":0,"makeup_2":0,"bproof_1":0,"sun_2":0,"complexion_2":0,"chain_2":0,"sun_1":0,"eyebrows_3":0,"tshirt_1":21,"hair_color_1":0,"eyebrows_2":0,"mask_2":0,"helmet_2":0,"hair_2":0,"beard_3":0,"moles_2":0,"bags_1":0,"arms_2":0,"decals_2":0,"age_1":0,"ears_1":-1,"moles_1":0,"bracelets_2":0,"watches_1":-1,"face":0,"bags_2":0,"pants_2":11,"chest_3":0,"blemishes_2":0,"chest_1":0,"hair_color_2":0,"blush_1":0,"tshirt_2":0,"helmet_1":-1,"hair_1":0,"shoes_2":0,"lipstick_4":0,"eyebrows_4":0,"ears_2":0,"watches_2":0,"bodyb_2":0,"bodyb_1":0,"eyebrows_1":0,"decals_1":57,"makeup_4":0,"glasses_2":0,"age_2":0,"shoes_1":8,"arms":91,"chain_1":0,"bracelets_1":-1,"chest_2":0,"beard_4":0,"makeup_1":0,"lipstick_1":0,"skin":0,"sex":0}', '{"age_1":0,"blush_3":0,"complexion_2":0,"bracelets_2":0,"chain_2":0,"bodyb_1":0,"pants_1":51,"hair_1":4,"lipstick_4":0,"bproof_2":0,"bodyb_2":0,"shoes_2":2,"sun_2":0,"blush_1":0,"shoes_1":81,"decals_1":66,"eyebrows_2":10,"makeup_1":6,"glasses":0,"chest_3":0,"bags_2":0,"arms":96,"watches_1":2,"arms_2":0,"hair_color_1":28,"beard_3":0,"chain_1":96,"chest_1":0,"mask_1":0,"sex":1,"decals_2":0,"bproof_1":0,"hair_color_2":28,"eyebrows_3":61,"makeup_2":8,"helmet_1":-1,"bags_1":0,"lipstick_3":23,"face":45,"bracelets_1":-1,"tshirt_1":29,"beard_4":0,"moles_2":10,"mask_2":0,"helmet_2":0,"makeup_3":25,"skin":10,"beard_2":0,"shoes":1,"blemishes_2":0,"moles_1":0,"pants_2":0,"complexion_1":0,"glasses_2":1,"age_2":0,"ears_1":12,"watches_2":0,"eyebrows_4":0,"eye_color":3,"lipstick_2":4,"glasses_1":11,"eyebrows_1":1,"ears_2":0,"makeup_4":18,"sun_1":0,"blush_2":0,"torso_2":2,"chest_2":0,"hair_2":0,"tshirt_2":0,"torso_1":14,"lipstick_1":1,"blemishes_1":0,"beard_1":0}'),
	(5, 'ambulance', 4, 'chefs', 'Chef de service', 1, '{"beard_1":0,"eye_color":0,"makeup_3":0,"blemishes_1":0,"mask_1":0,"glasses_1":0,"bproof_2":0,"lipstick_3":0,"beard_2":0,"torso_1":33,"pants_1":19,"blush_3":0,"torso_2":1,"blush_2":0,"complexion_1":0,"lipstick_2":0,"makeup_2":0,"bproof_1":0,"sun_2":0,"complexion_2":0,"chain_2":0,"sun_1":0,"eyebrows_3":0,"tshirt_1":21,"hair_color_1":0,"eyebrows_2":0,"mask_2":0,"helmet_2":0,"hair_2":0,"beard_3":0,"moles_2":0,"bags_1":0,"arms_2":0,"decals_2":0,"age_1":0,"ears_1":-1,"moles_1":0,"bracelets_2":0,"watches_1":-1,"face":0,"bags_2":0,"pants_2":11,"chest_3":0,"blemishes_2":0,"chest_1":0,"hair_color_2":0,"blush_1":0,"tshirt_2":0,"helmet_1":-1,"hair_1":0,"shoes_2":0,"lipstick_4":0,"eyebrows_4":0,"ears_2":0,"watches_2":0,"bodyb_2":0,"bodyb_1":0,"eyebrows_1":0,"decals_1":57,"makeup_4":0,"glasses_2":0,"age_2":0,"shoes_1":8,"arms":91,"chain_1":0,"bracelets_1":-1,"chest_2":0,"beard_4":0,"makeup_1":0,"lipstick_1":0,"skin":0,"sex":0}', '{"age_1":0,"blush_3":0,"complexion_2":0,"bracelets_2":0,"chain_2":0,"bodyb_1":0,"pants_1":51,"hair_1":4,"lipstick_4":0,"bproof_2":0,"bodyb_2":0,"shoes_2":2,"sun_2":0,"blush_1":0,"shoes_1":81,"decals_1":66,"eyebrows_2":10,"makeup_1":6,"glasses":0,"chest_3":0,"bags_2":0,"arms":96,"watches_1":2,"arms_2":0,"hair_color_1":28,"beard_3":0,"chain_1":96,"chest_1":0,"mask_1":0,"sex":1,"decals_2":0,"bproof_1":0,"hair_color_2":28,"eyebrows_3":61,"makeup_2":8,"helmet_1":-1,"bags_1":0,"lipstick_3":23,"face":45,"bracelets_1":-1,"tshirt_1":29,"beard_4":0,"moles_2":10,"mask_2":0,"helmet_2":0,"makeup_3":25,"skin":10,"beard_2":0,"shoes":1,"blemishes_2":0,"moles_1":0,"pants_2":0,"complexion_1":0,"glasses_2":1,"age_2":0,"ears_1":12,"watches_2":0,"eyebrows_4":0,"eye_color":3,"lipstick_2":4,"glasses_1":11,"eyebrows_1":1,"ears_2":0,"makeup_4":18,"sun_1":0,"blush_2":0,"torso_2":2,"chest_2":0,"hair_2":0,"tshirt_2":0,"torso_1":14,"lipstick_1":1,"blemishes_1":0,"beard_1":0}'),
	(6, 'ambulance', 5, 'coboss', 'Co directeur', 1, '{"beard_1":0,"eye_color":0,"makeup_3":0,"blemishes_1":0,"mask_1":0,"glasses_1":0,"bproof_2":0,"lipstick_3":0,"beard_2":0,"torso_1":33,"pants_1":19,"blush_3":0,"torso_2":1,"blush_2":0,"complexion_1":0,"lipstick_2":0,"makeup_2":0,"bproof_1":0,"sun_2":0,"complexion_2":0,"chain_2":0,"sun_1":0,"eyebrows_3":0,"tshirt_1":21,"hair_color_1":0,"eyebrows_2":0,"mask_2":0,"helmet_2":0,"hair_2":0,"beard_3":0,"moles_2":0,"bags_1":0,"arms_2":0,"decals_2":0,"age_1":0,"ears_1":-1,"moles_1":0,"bracelets_2":0,"watches_1":-1,"face":0,"bags_2":0,"pants_2":11,"chest_3":0,"blemishes_2":0,"chest_1":0,"hair_color_2":0,"blush_1":0,"tshirt_2":0,"helmet_1":-1,"hair_1":0,"shoes_2":0,"lipstick_4":0,"eyebrows_4":0,"ears_2":0,"watches_2":0,"bodyb_2":0,"bodyb_1":0,"eyebrows_1":0,"decals_1":57,"makeup_4":0,"glasses_2":0,"age_2":0,"shoes_1":8,"arms":91,"chain_1":0,"bracelets_1":-1,"chest_2":0,"beard_4":0,"makeup_1":0,"lipstick_1":0,"skin":0,"sex":0}', '{"age_1":0,"blush_3":0,"complexion_2":0,"bracelets_2":0,"chain_2":0,"bodyb_1":0,"pants_1":51,"hair_1":4,"lipstick_4":0,"bproof_2":0,"bodyb_2":0,"shoes_2":2,"sun_2":0,"blush_1":0,"shoes_1":81,"decals_1":66,"eyebrows_2":10,"makeup_1":6,"glasses":0,"chest_3":0,"bags_2":0,"arms":96,"watches_1":2,"arms_2":0,"hair_color_1":28,"beard_3":0,"chain_1":96,"chest_1":0,"mask_1":0,"sex":1,"decals_2":0,"bproof_1":0,"hair_color_2":28,"eyebrows_3":61,"makeup_2":8,"helmet_1":-1,"bags_1":0,"lipstick_3":23,"face":45,"bracelets_1":-1,"tshirt_1":29,"beard_4":0,"moles_2":10,"mask_2":0,"helmet_2":0,"makeup_3":25,"skin":10,"beard_2":0,"shoes":1,"blemishes_2":0,"moles_1":0,"pants_2":0,"complexion_1":0,"glasses_2":1,"age_2":0,"ears_1":12,"watches_2":0,"eyebrows_4":0,"eye_color":3,"lipstick_2":4,"glasses_1":11,"eyebrows_1":1,"ears_2":0,"makeup_4":18,"sun_1":0,"blush_2":0,"torso_2":2,"chest_2":0,"hair_2":0,"tshirt_2":0,"torso_1":14,"lipstick_1":1,"blemishes_1":0,"beard_1":0}'),
	(7, 'avocat', 0, 'recruit', 'Recrue', 350, '{"tshirt_1":57,"torso_1":55,"arms":0,"pants_1":35,"glasses":0,"decals_2":0,"hair_color_2":0,"helmet_2":0,"hair_color_1":5,"face":19,"glasses_2":1,"torso_2":0,"shoes":24,"hair_1":2,"skin":34,"sex":0,"glasses_1":0,"pants_2":0,"hair_2":0,"decals_1":0,"tshirt_2":0,"helmet_1":8}', '{"tshirt_1":34,"torso_1":48,"shoes":24,"pants_1":34,"torso_2":0,"decals_2":0,"hair_color_2":0,"glasses":0,"helmet_2":0,"hair_2":3,"face":21,"decals_1":0,"glasses_2":1,"hair_1":11,"skin":34,"sex":1,"glasses_1":5,"pants_2":0,"arms":14,"hair_color_1":10,"tshirt_2":0,"helmet_1":57}'),
	(8, 'avocat', 1, 'boss', 'Patron', 400, '{"tshirt_1":58,"torso_1":55,"shoes":24,"pants_1":35,"pants_2":0,"decals_2":3,"hair_color_2":0,"face":19,"helmet_2":0,"hair_2":0,"arms":41,"torso_2":0,"hair_color_1":5,"hair_1":2,"skin":34,"sex":0,"glasses_1":0,"glasses_2":1,"decals_1":8,"glasses":0,"tshirt_2":0,"helmet_1":11}', '{"tshirt_1":35,"torso_1":48,"arms":44,"pants_1":34,"pants_2":0,"decals_2":3,"hair_color_2":0,"face":21,"helmet_2":0,"hair_2":3,"decals_1":7,"torso_2":0,"hair_color_1":10,"hair_1":11,"skin":34,"sex":1,"glasses_1":5,"glasses_2":1,"shoes":24,"glasses":0,"tshirt_2":0,"helmet_1":57}'),
	(9, 'mecano', 0, 'recrue', 'Recrue', 1, '{}', '{}'),
	(10, 'mecano', 1, 'novice', 'Novice', 1, '{}', '{}'),
	(45, 'mecano', 2, 'experimente', 'Experimente', 1, '{}', '{}'),
	(46, 'mecano', 3, 'chief', 'Chef d\'equipe', 1, '{}', '{}'),
	(47, 'mecano', 4, 'boss', 'Patron', 1, '{}', '{}'),
	(50, 'police', 0, 'recruit', 'Cadet', 2500, '{}', '{}'),
	(51, 'police', 1, 'officer1', 'Officier I', 3000, '{}', '{}'),
	(52, 'police', 2, 'officer2', 'Officier II', 3200, '{}', '{}'),
	(53, 'police', 3, 'officer3', 'Officier III', 3400, '{}', '{}'),
	(54, 'police', 4, 'slo', 'S.L.O', 3600, '{}', '{}'),
	(55, 'police', 5, 'sergeant1', 'Sergent I', 3800, '{}', '{}'),
	(56, 'police', 6, 'sergeant2', 'Sergent II', 4000, '{}', '{}'),
	(57, 'police', 7, 'supervisor', 'Supervisor', 4200, '{}', '{}'),
	(58, 'police', 8, 'lieutenant1', 'Lieutenant I', 4500, '{}', '{}'),
	(59, 'police', 9, 'lieutenant2', 'Lieutenant II', 4700, '{}', '{}'),
	(60, 'police', 10, 'capitaine', 'Capitaine', 5000, '{}', '{}'),
	(61, 'police', 11, 'commandant', 'Commandant', 5500, '{}', '{}'),
	(62, 'police', 12, 'deputy', 'Deputy Chef', 6000, '{}', '{}'),
	(63, 'police', 13, 'bossassistantboss', 'Assistant Chef', 6500, '{}', '{}'),
	(64, 'police', 14, 'boss', 'Chef de Police', 7000, '{}', '{}'),
	(66, 'taxi', 0, 'recrue', 'Recrue', 100, '{}', '{}'),
	(67, 'taxi', 1, 'novice', 'Novice', 200, '{}', '{}'),
	(68, 'taxi', 2, 'experimente', 'Experimente', 1, '{}', '{}'),
	(69, 'taxi', 3, 'uber', 'Uber', 1, '{}', '{}'),
	(70, 'taxi', 4, 'boss', 'Patron', 1, '{}', '{}'),
	(74, 'unemployed', 0, 'unemployed', 'RSA', 100, '{}', '{}'),
	(75, 'unicorn', 0, 'barman', 'Barman', 1, '{}', '{}'),
	(76, 'unicorn', 1, 'dancer', 'Videur', 1, '{}', '{}'),
	(77, 'unicorn', 2, 'viceboss', 'Co-gérant', 1, '{}', '{}'),
	(78, 'unicorn', 3, 'boss', 'Gérant', 1, '{}', '{}'),
	(79, 'vigne', 0, 'recrue', 'Recrue', 250, '{"tshirt_1":59,"tshirt_2":0,"torso_1":12,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":1, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}', '{"tshirt_1":0,"tshirt_2":0,"torso_1":56,"torso_2":0,"shoes_1":27,"shoes_2":0,"pants_1":36, "pants_2":0, "arms":63, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}'),
	(80, 'vigne', 1, 'novice', 'Novice', 300, '{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}', '{"tshirt_1":0,"tshirt_2":0,"torso_1":56,"torso_2":0,"shoes_1":27,"shoes_2":0,"pants_1":36, "pants_2":0, "arms":63, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}'),
	(81, 'vigne', 2, 'cdisenior', 'Chef de Chai', 100, '{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}', '{"tshirt_1":0,"tshirt_2":0,"torso_1":56,"torso_2":0,"shoes_1":27,"shoes_2":0,"pants_1":36, "pants_2":0, "arms":63, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}'),
	(82, 'vigne', 3, 'boss', 'Patron', 400, '{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}', '{"tshirt_1":15,"tshirt_2":0,"torso_1":14,"torso_2":15,"shoes_1":12,"shoes_2":0,"pants_1":9, "pants_2":5, "arms":1, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}'),
	(90, 'burgershot', 0, 'recrue', 'Periode d\'essai', 75, '{}', '{}'),
	(91, 'burgershot', 1, 'novice', 'Novice', 125, '{}', '{}'),
	(92, 'burgershot', 2, 'experimente', 'Experimente', 150, '{}', '{}'),
	(93, 'burgershot', 3, 'chief', 'Chef d\'équipe', 300, '{}', '{}'),
	(94, 'burgershot', 4, 'boss', 'Patron', 1500, '{}', '{}'),
	(148, 'realestateagent', 0, 'location', 'Vendeurs', 5000, '{}', '{}'),
	(149, 'realestateagent', 1, 'vendeur', 'Responsable des ventes', 5000, '{}', '{}'),
	(150, 'realestateagent', 2, 'gestion', 'Recruteur', 5000, '{}', '{}'),
	(151, 'realestateagent', 3, 'boss', 'Patron', 5000, '{}', '{}'),
	(157, 'unemployed2', 0, 'unemployed2', 'Citoyen', 0, '{}', '{}'),
	(182, 'journalist', 0, 'stagiaire', 'Stagiaire', 1, '{}', '{}'),
	(183, 'journalist', 1, 'reporter', 'Reporter', 1, '{}', '{}'),
	(184, 'journalist', 2, 'investigator', 'Investigateur', 1, '{}', '{}'),
	(185, 'journalist', 3, 'boss', 'Directeur', 2000, '{}', '{}'),
	(551, 'cardealer', 0, 'recruit', 'Recrue', 1000, '{}', '{}'),
	(552, 'cardealer', 1, 'novice', 'Novice', 2500, '{}', '{}'),
	(553, 'cardealer', 2, 'experienced', 'Experimente', 4000, '{}', '{}'),
	(554, 'cardealer', 3, 'boss', 'Patron', 9999, '{}', '{}'),
	(612, 'delivery', 0, 'delivery', 'Delivery', 500, '{}', '{}'),
	(617, 'boatseller', 0, 'recruit', 'Recrue', 1, '{}', '{}'),
	(618, 'boatseller', 1, 'novice', 'Novice', 1, '{}', '{}'),
	(619, 'boatseller', 2, 'experienced', 'Experimente', 1, '{}', '{}'),
	(620, 'boatseller', 3, 'boss', 'Patron', 1, '{}', '{}'),
	(621, 'planeseller', 0, 'recruit', 'Recrue', 999, '{}', '{}'),
	(622, 'planeseller', 1, 'novice', 'Novice', 2300, '{}', '{}'),
	(623, 'planeseller', 2, 'experienced', 'Experimente', 5250, '{}', '{}'),
	(624, 'planeseller', 3, 'boss', 'Patron', 9500, '{}', '{}'),
	(625, 'slaughterer', 0, 'recruit', 'Recrue', 150, '{}', '{}'),
	(626, 'lumberjack', 0, 'recruit', 'Recrue', 150, '{}', '{}'),
	(627, 'tailor', 0, 'recruit', 'Recrue', 150, '{}', '{}'),
	(628, 'miner', 0, 'recruit', 'Recrue', 150, '{}', '{}'),
	(629, 'fisherman', 0, 'recruit', 'Recrue', 150, '{}', '{}'),
	(630, 'fueler', 0, 'recruit', 'Recrue', 150, '{}', '{}'),
	(801, 'tacos', 0, 'recrue', 'Recrue', 250, '{}', '{}'),
	(802, 'jardinier', 0, 'recrue', 'Recrue', 250, '{}', '{}'),
	(865, 'vigneron', 0, 'recrue', 'Recrue', 1, '{}', '{}'),
	(866, 'vigneron', 1, 'novice', 'Novice', 1, '{}', '{}'),
	(867, 'vigneron', 2, 'experimente', 'Experimente', 1, '{}', '{}'),
	(868, 'vigneron', 3, 'boss', 'Patron', 1, '{}', '{}'),
	(873, 'gouv', 0, 'chauffeur_prive', 'Avocat', 1, '{}', '{}'),
	(874, 'gouv', 1, 'avocat', 'Juge', 5000, '{}', '{}'),
	(875, 'gouv', 2, 'juge', 'Garde du corps', 3500, '{}', '{}'),
	(876, 'gouv', 3, 'garde_du_corps', 'Chef de section', 5000, '{}', '{}'),
	(877, 'gouv', 4, 'garde_corps_rap', 'Procureur', 5000, '{}', '{}'),
	(878, 'gouv', 5, 'chef_section', 'Contrôleur', 5000, '{}', '{}'),
	(879, 'gouv', 6, 'secrétaire', 'Secrétaire', 7500, '{}', '{}'),
	(880, 'gouv', 7, 'vice_gouverneur', 'Vice gouverneur', 8000, '{}', '{}'),
	(881, 'gouv', 8, 'boss', 'Gouverneur', 9999, '{}', '{}'),
	(900, 'mecano2', 0, 'recrue', 'Recrue', 1500, '{}', '{}'),
	(901, 'mecano2', 1, 'novice', 'Novice', 2500, '{}', '{}'),
	(902, 'mecano2', 2, 'experimente', 'Experimente', 3500, '{}', '{}'),
	(903, 'mecano2', 3, 'chief', 'Chef d\'equipe', 5000, '{}', '{}'),
	(904, 'mecano2', 4, 'boss', 'Patron', 9999, '{}', '{}'),
	(1151, 'fib', 0, 'recruit', 'Consultant Fédéral', 500, '{}', '{}'),
	(1152, 'fib', 1, 'officer', 'Agent Aspirant', 700, '{}', '{}'),
	(1153, 'fib', 2, 'sergeant', 'Agent Fédéral', 1000, '{}', '{}'),
	(1154, 'fib', 3, 'sergeant_chief', 'Agent Spécial', 2000, '{}', '{}'),
	(1155, 'fib', 4, 'intendent', 'Agent Spécial Superviseur', 5000, '{}', '{}'),
	(1156, 'fib', 5, 'lieutenant', 'Agent Spécial en Charge', 4500, '{}', '{}'),
	(1157, 'fib', 6, 'chef', 'Agent Spécial de Coordination', 4000, '{}', '{}'),
	(1158, 'fib', 7, 'boss', 'Directeur d\'Agence', 5500, '{}', '{}'),
	(1264, 'chickenbell', 0, 'recrue', 'Intérimaire', 1, '{}', '{}'),
	(1265, 'chickenbell', 1, 'novice', 'Employé', 1, '{}', '{}'),
	(1266, 'chickenbell', 2, 'experimente', 'Expérimente', 1, '{}', '{}'),
	(1267, 'chickenbell', 3, 'boss', 'Patron', 1000, '{}', '{}'),
	(1286, 'nikefactory', 0, 'recrue', 'Recrue', 1, '{}', '{}'),
	(1287, 'nikefactory', 1, 'novice', 'Novice', 1, '{}', '{}'),
	(1288, 'nikefactory', 2, 'experimente', 'Experimente', 1, '{}', '{}'),
	(1289, 'nikefactory', 3, 'boss', 'Patron', 1, '{}', '{}'),
	(1301, 'churchtown', 0, 'recrue', 'Recrue', 250, '{}', '{}'),
	(1302, 'churchtown', 1, 'novice', 'Novice', 300, '{}', '{}'),
	(1303, 'churchtown', 2, 'experimente', 'Experimente', 350, '{}', '{}'),
	(1304, 'churchtown', 3, 'boss', 'Patron', 400, '{}', '{}'),
	(1321, 'tequilala', 0, 'recrue', 'Recrue', 500, '{}', '{}'),
	(1322, 'tequilala', 1, 'novice', 'Novice', 1, '{}', '{}'),
	(1323, 'tequilala', 2, 'experimente', 'Experimente', 1, '{}', '{}'),
	(1324, 'tequilala', 3, 'boss', 'Patron', 1000, '{}', '{}'),
	(1340, 'ambulance', 6, 'boss', 'Directeur', 1, '{"beard_1":0,"eye_color":0,"makeup_3":0,"blemishes_1":0,"mask_1":0,"glasses_1":0,"bproof_2":0,"lipstick_3":0,"beard_2":0,"torso_1":33,"pants_1":19,"blush_3":0,"torso_2":1,"blush_2":0,"complexion_1":0,"lipstick_2":0,"makeup_2":0,"bproof_1":0,"sun_2":0,"complexion_2":0,"chain_2":0,"sun_1":0,"eyebrows_3":0,"tshirt_1":21,"hair_color_1":0,"eyebrows_2":0,"mask_2":0,"helmet_2":0,"hair_2":0,"beard_3":0,"moles_2":0,"bags_1":0,"arms_2":0,"decals_2":0,"age_1":0,"ears_1":-1,"moles_1":0,"bracelets_2":0,"watches_1":-1,"face":0,"bags_2":0,"pants_2":11,"chest_3":0,"blemishes_2":0,"chest_1":0,"hair_color_2":0,"blush_1":0,"tshirt_2":0,"helmet_1":-1,"hair_1":0,"shoes_2":0,"lipstick_4":0,"eyebrows_4":0,"ears_2":0,"watches_2":0,"bodyb_2":0,"bodyb_1":0,"eyebrows_1":0,"decals_1":57,"makeup_4":0,"glasses_2":0,"age_2":0,"shoes_1":8,"arms":91,"chain_1":0,"bracelets_1":-1,"chest_2":0,"beard_4":0,"makeup_1":0,"lipstick_1":0,"skin":0,"sex":0}', '{"age_1":0,"blush_3":0,"complexion_2":0,"bracelets_2":0,"chain_2":0,"bodyb_1":0,"pants_1":23,"hair_1":4,"lipstick_4":0,"bproof_2":0,"bodyb_2":0,"shoes_2":1,"sun_2":0,"blush_1":0,"shoes_1":4,"decals_1":65,"eyebrows_2":10,"makeup_1":6,"glasses":0,"chest_3":0,"bags_2":0,"arms":105,"watches_1":2,"arms_2":0,"hair_color_1":28,"beard_3":0,"chain_1":96,"chest_1":0,"mask_1":0,"sex":1,"decals_2":0,"bproof_1":0,"hair_color_2":28,"eyebrows_3":61,"makeup_2":8,"helmet_1":-1,"bags_1":0,"lipstick_3":23,"face":45,"bracelets_1":-1,"tshirt_1":29,"beard_4":0,"moles_2":10,"mask_2":0,"helmet_2":0,"makeup_3":25,"skin":10,"beard_2":0,"shoes":1,"blemishes_2":0,"moles_1":0,"pants_2":0,"complexion_1":0,"glasses_2":1,"age_2":0,"ears_1":12,"watches_2":0,"eyebrows_4":0,"eye_color":3,"lipstick_2":4,"glasses_1":11,"eyebrows_1":1,"ears_2":0,"makeup_4":18,"sun_1":0,"blush_2":0,"torso_2":0,"chest_2":0,"hair_2":0,"tshirt_2":0,"torso_1":257,"lipstick_1":1,"blemishes_1":0,"beard_1":0}'),
	(1437, 'appleindustrie', 0, 'recrue', 'Recrue', 1, '{}', '{}'),
	(1438, 'appleindustrie', 1, 'novice', 'Novice', 1, '{}', '{}'),
	(1439, 'appleindustrie', 2, 'experimente', 'Experimente', 1, '{}', '{}'),
	(1440, 'appleindustrie', 3, 'boss', 'Patron', 1, '{}', '{}'),
	(1701, 'bcso', 0, 'recruit', 'Junior', 2000, '{}', '{}'),
	(1702, 'bcso', 1, 'deputyone', 'Deputy I', 2500, '{}', '{}'),
	(1703, 'bcso', 2, 'deputytwo', 'Deputy II', 2500, '{}', '{}'),
	(1704, 'bcso', 3, 'deputytre', 'Deputy III', 2500, '{}', '{}'),
	(1705, 'bcso', 4, 'seniordeputy', 'Senior Deputy', 2500, '{}', '{}'),
	(1706, 'bcso', 5, 'masterdeputy', 'Master Deputy', 2500, '{}', '{}'),
	(1707, 'bcso', 6, 'caporal', 'Caporal', 2500, '{}', '{}'),
	(1716, 'bcso', 7, 'sergeant', 'Sergeant', 3000, '{}', '{}'),
	(1717, 'bcso', 8, 'mastersergeant', 'Master Sergeant', 3000, '{}', '{}'),
	(1718, 'bcso', 9, 'lieutenant', 'Lieutenant', 3500, '{}', '{}'),
	(1719, 'bcso', 10, 'captain', 'Captain', 4500, '{}', '{}'),
	(1720, 'bcso', 11, 'major', 'Major', 5500, '{}', '{}'),
	(1721, 'bcso', 12, 'chefdeputy', 'Chef Deputy', 2500, '{}', '{}'),
	(1722, 'bcso', 13, 'assistsheriff', 'Assistant Sheriff', 6000, '{}', '{}'),
	(1723, 'bcso', 14, 'undersheriff', 'Under Sheriff', 7000, '{}', '{}'),
	(1724, 'bcso', 15, 'boss', 'Sheriff', 1000, '{}', '{}'),
	(1748, 'rarecords', 0, 'rapper', 'Rappeur', 0, '[]', '[]'),
	(1749, 'rarecords', 1, 'manager', 'Manageur', 0, '[]', '[]'),
	(1750, 'rarecords', 2, 'boss', 'Patron', 0, '[]', '[]'),
	(1763, 'label', 1, 'novice', 'Novice', 1, '[]', '[]'),
	(1764, 'label', 0, 'recrue', 'Recrue', 1, '[]', '[]'),
	(1765, 'label', 3, 'boss', 'Patron', 1, '[]', '[]'),
	(1766, 'label', 2, 'experimente', 'Experimente', 1, '[]', '[]'),
	(1767, 'ltd_sud', 1, 'novice', 'Novice', 0, '[]', '[]'),
	(1768, 'ltd_sud', 0, 'recrue', 'Recrue', 0, '[]', '[]'),
	(1769, 'ltd_sud', 3, 'boss', 'Patron', 0, '[]', '[]'),
	(1770, 'ltd_sud', 2, 'experimente', 'Experimente', 0, '[]', '[]'),
	(1994, 'fermier', 2, 'experimente', 'Experimente', 0, '[]', '[]'),
	(1995, 'fermier', 1, 'novice', 'Novice', 0, '[]', '[]'),
	(1996, 'fermier', 0, 'recrue', 'Recrue', 0, '[]', '[]'),
	(1997, 'fermier', 3, 'boss', 'Patron', 0, '[]', '[]'),
	(2004, 'Pizza', 2, 'experimente', 'Experimente', 0, '[]', '[]'),
	(2005, 'Pizza', 3, 'boss', 'Patron', 0, '[]', '[]'),
	(2006, 'Pizza', 0, 'recrue', 'Recrue', 0, '[]', '[]'),
	(2007, 'Pizza', 1, 'novice', 'Novice', 0, '[]', '[]'),
	(2129, 'vagos', 0, 'user', 'User', 0, '[]', '[]'),
	(2130, 'vagos', 1, 'boss', 'Owner', 0, '[]', '[]'),
	(2207, 'Cayo', 0, 'user', 'User', 0, '[]', '[]'),
	(2208, 'Cayo', 1, 'boss', 'Owner', 0, '[]', '[]'),
	(2231, 'madrazo', 0, 'user', 'User', 0, '[]', '[]'),
	(2232, 'madrazo', 1, 'boss', 'Owner', 0, '[]', '[]'),
	(2249, 'lost', 0, 'user', 'User', 0, '[]', '[]'),
	(2250, 'lost', 1, 'boss', 'Owner', 0, '[]', '[]'),
	(2251, 'duggan', 0, 'user', 'User', 0, '[]', '[]'),
	(2252, 'duggan', 1, 'boss', 'Owner', 0, '[]', '[]'),
	(2253, 'bonelli', 0, 'user', 'User', 0, '[]', '[]'),
	(2254, 'bonelli', 1, 'boss', 'Owner', 0, '[]', '[]'),
	(2263, 'Ballas', 0, 'user', 'User', 0, '[]', '[]'),
	(2264, 'Ballas', 1, 'boss', 'Owner', 0, '[]', '[]'),
	(2265, 'mayansmc', 0, 'user', 'User', 0, '[]', '[]'),
	(2266, 'mayansmc', 1, 'boss', 'Owner', 0, '[]', '[]'),
	(2271, 'F4L', 1, 'boss', 'Owner', 0, '[]', '[]'),
	(2272, 'F4L', 0, 'user', 'User', 0, '[]', '[]'),
	(2273, 'Marabunta', 0, 'user', 'User', 0, '[]', '[]'),
	(2274, 'Marabunta', 1, 'boss', 'Owner', 0, '[]', '[]'),
	(2277, 'white', 0, 'user', 'User', 0, '[]', '[]'),
	(2278, 'white', 1, 'boss', 'Owner', 0, '[]', '[]');

-- Listage de la structure de table onelife. labos
CREATE TABLE IF NOT EXISTS `labos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(255) NOT NULL,
  `type` varchar(50) NOT NULL,
  `enterCoords` text NOT NULL,
  `players` text NOT NULL DEFAULT '[]',
  `accesList` text NOT NULL DEFAULT '[]',
  `drugsData` text NOT NULL DEFAULT '[]',
  `memberList` text NOT NULL DEFAULT '[]',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=91398009 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table onelife.labos : ~0 rows (environ)
DELETE FROM `labos`;

-- Listage de la structure de table onelife. licenses
CREATE TABLE IF NOT EXISTS `licenses` (
  `type` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL,
  PRIMARY KEY (`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.licenses : ~8 rows (environ)
DELETE FROM `licenses`;
INSERT INTO `licenses` (`type`, `label`) VALUES
	('avion', 'Avion License'),
	('boat', 'Boat License'),
	('dmv', 'Code de la route'),
	('drive', 'Permis de conduire'),
	('drive_bike', 'Permis moto'),
	('drive_truck', 'Permis Camion'),
	('helico', 'Helicoptere License'),
	('weapon', 'Permis port d\'armes');

-- Listage de la structure de table onelife. limitedvehicleboutique
CREATE TABLE IF NOT EXISTS `limitedvehicleboutique` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `carName` varchar(50) NOT NULL DEFAULT '0',
  `carLabel` varchar(50) NOT NULL DEFAULT '0',
  `limite` int(11) NOT NULL DEFAULT 0,
  `price` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.limitedvehicleboutique : ~0 rows (environ)
DELETE FROM `limitedvehicleboutique`;

-- Listage de la structure de table onelife. open_car
CREATE TABLE IF NOT EXISTS `open_car` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(50) DEFAULT NULL,
  `plate` varchar(11) DEFAULT NULL,
  `NB` int(11) DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_open_car_owner` (`owner`) USING BTREE,
  KEY `index_open_car_owner_plate` (`owner`,`plate`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10527 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.open_car : ~0 rows (environ)
DELETE FROM `open_car`;

-- Listage de la structure de table onelife. owned_vehicles
CREATE TABLE IF NOT EXISTS `owned_vehicles` (
  `owner` varchar(255) NOT NULL,
  `plate` varchar(12) NOT NULL,
  `vehicle` longtext NOT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'car',
  `state` tinyint(1) NOT NULL DEFAULT 0,
  `boutique` tinyint(1) DEFAULT 0,
  `selling` tinyint(1) DEFAULT 0,
  `carseller` int(11) DEFAULT 0,
  `stored` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`plate`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.owned_vehicles : ~0 rows (environ)
DELETE FROM `owned_vehicles`;

-- Listage de la structure de table onelife. playerstattoos
CREATE TABLE IF NOT EXISTS `playerstattoos` (
  `identifier` varchar(50) NOT NULL,
  `tattoos` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- Listage de la structure de table onelife. playtime
CREATE TABLE IF NOT EXISTS `playtime` (
  `identifier` varchar(50) NOT NULL DEFAULT 'nil',
  `timeplayed` int(11) DEFAULT NULL,
  PRIMARY KEY (`identifier`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Listage de la structure de table onelife. properties
CREATE TABLE IF NOT EXISTS `properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `entering` varchar(255) DEFAULT NULL,
  `exit` varchar(255) DEFAULT NULL,
  `inside` varchar(255) DEFAULT NULL,
  `outside` varchar(255) DEFAULT NULL,
  `ipls` varchar(255) DEFAULT '[]',
  `gateway` varchar(255) DEFAULT NULL,
  `is_single` int(11) DEFAULT NULL,
  `is_room` int(11) DEFAULT NULL,
  `is_gateway` int(11) DEFAULT NULL,
  `room_menu` varchar(255) DEFAULT NULL,
  `price` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.properties : ~42 rows (environ)
DELETE FROM `properties`;
INSERT INTO `properties` (`id`, `name`, `label`, `entering`, `exit`, `inside`, `outside`, `ipls`, `gateway`, `is_single`, `is_room`, `is_gateway`, `room_menu`, `price`) VALUES
	(1, 'WhispymoundDrive', '2677 Whispymound Drive', '{"y":564.89,"z":182.959,"x":119.384}', '{"x":117.347,"y":559.506,"z":183.304}', '{"y":557.032,"z":183.301,"x":118.037}', '{"y":567.798,"z":182.131,"x":119.249}', '[]', NULL, 1, 1, 0, '{"x":118.748,"y":566.573,"z":175.697}', 375000),
	(2, 'NorthConkerAvenue2045', '2045 North Conker Avenue', '{"x":372.796,"y":428.327,"z":144.685}', '{"x":373.548,"y":422.982,"z":144.907},', '{"y":420.075,"z":145.904,"x":372.161}', '{"x":372.454,"y":432.886,"z":143.443}', '[]', NULL, 1, 1, 0, '{"x":377.349,"y":429.422,"z":137.3}', 375000),
	(3, 'RichardMajesticApt2', 'Richard Majestic, Apt 2', '{"y":-379.165,"z":37.961,"x":-936.363}', '{"y":-365.476,"z":113.274,"x":-913.097}', '{"y":-367.637,"z":113.274,"x":-918.022}', '{"y":-382.023,"z":37.961,"x":-943.626}', '[]', NULL, 1, 1, 0, '{"x":-927.554,"y":-377.744,"z":112.674}', 420000),
	(4, 'NorthConkerAvenue2044', '2044 North Conker Avenue', '{"y":440.8,"z":146.702,"x":346.964}', '{"y":437.456,"z":148.394,"x":341.683}', '{"y":435.626,"z":148.394,"x":339.595}', '{"x":350.535,"y":443.329,"z":145.764}', '[]', NULL, 1, 1, 0, '{"x":337.726,"y":436.985,"z":140.77}', 375000),
	(5, 'WildOatsDrive', '3655 Wild Oats Drive', '{"y":502.696,"z":136.421,"x":-176.003}', '{"y":497.817,"z":136.653,"x":-174.349}', '{"y":495.069,"z":136.666,"x":-173.331}', '{"y":506.412,"z":135.0664,"x":-177.927}', '[]', NULL, 1, 1, 0, '{"x":-174.725,"y":493.095,"z":129.043}', 375000),
	(6, 'HillcrestAvenue2862', '2862 Hillcrest Avenue', '{"y":596.58,"z":142.641,"x":-686.554}', '{"y":591.988,"z":144.392,"x":-681.728}', '{"y":590.608,"z":144.392,"x":-680.124}', '{"y":599.019,"z":142.059,"x":-689.492}', '[]', NULL, 1, 1, 0, '{"x":-680.46,"y":588.6,"z":136.769}', 375000),
	(7, 'LowEndApartment', 'Appartement de base', '{"y":-1078.735,"z":28.4031,"x":292.528}', '{"y":-1007.152,"z":-102.002,"x":265.845}', '{"y":-1002.802,"z":-100.008,"x":265.307}', '{"y":-1078.669,"z":28.401,"x":296.738}', '[]', NULL, 1, 1, 0, '{"x":265.916,"y":-999.38,"z":-100.008}', 140500),
	(8, 'MadWayneThunder', '2113 Mad Wayne Thunder', '{"y":454.955,"z":96.462,"x":-1294.433}', '{"x":-1289.917,"y":449.541,"z":96.902}', '{"y":446.322,"z":96.899,"x":-1289.642}', '{"y":455.453,"z":96.517,"x":-1298.851}', '[]', NULL, 1, 1, 0, '{"x":-1287.306,"y":455.901,"z":89.294}', 375000),
	(9, 'HillcrestAvenue2874', '2874 Hillcrest Avenue', '{"x":-853.346,"y":696.678,"z":147.782}', '{"y":690.875,"z":151.86,"x":-859.961}', '{"y":688.361,"z":151.857,"x":-859.395}', '{"y":701.628,"z":147.773,"x":-855.007}', '[]', NULL, 1, 1, 0, '{"x":-858.543,"y":697.514,"z":144.253}', 375000),
	(10, 'HillcrestAvenue2868', '2868 Hillcrest Avenue', '{"y":620.494,"z":141.588,"x":-752.82}', '{"y":618.62,"z":143.153,"x":-759.317}', '{"y":617.629,"z":143.153,"x":-760.789}', '{"y":621.281,"z":141.254,"x":-750.919}', '[]', NULL, 1, 1, 0, '{"x":-762.504,"y":618.992,"z":135.53}', 375000),
	(11, 'TinselTowersApt12', 'Tinsel Towers, Apt 42', '{"y":37.025,"z":42.58,"x":-618.299}', '{"y":58.898,"z":97.2,"x":-603.301}', '{"y":58.941,"z":97.2,"x":-608.741}', '{"y":30.603,"z":42.524,"x":-620.017}', '[]', NULL, 1, 1, 0, '{"x":-622.173,"y":54.585,"z":96.599}', 420000),
	(12, 'MiltonDrive', 'Milton Drive', '{"x":-775.17,"y":312.01,"z":84.658}', NULL, NULL, '{"x":-775.346,"y":306.776,"z":84.7}', '[]', NULL, 0, 0, 1, NULL, 0),
	(13, 'Modern1Apartment', 'Appartement Moderne 1', NULL, '{"x":-784.194,"y":323.636,"z":210.997}', '{"x":-779.751,"y":323.385,"z":210.997}', NULL, '["apa_v_mp_h_01_a"]', 'MiltonDrive', 0, 1, 0, '{"x":-766.661,"y":327.672,"z":210.396}', 310000),
	(14, 'Modern2Apartment', 'Appartement Moderne 2', NULL, '{"x":-786.8663,"y":315.764,"z":186.913}', '{"x":-781.808,"y":315.866,"z":186.913}', NULL, '["apa_v_mp_h_01_c"]', 'MiltonDrive', 0, 1, 0, '{"x":-795.735,"y":326.757,"z":186.313}', 310000),
	(15, 'Modern3Apartment', 'Appartement Moderne 3', NULL, '{"x":-774.012,"y":342.042,"z":195.686}', '{"x":-779.057,"y":342.063,"z":195.686}', NULL, '["apa_v_mp_h_01_b"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.386,"y":330.782,"z":195.08}', 310000),
	(16, 'Mody1Apartment', 'Appartement Mode 1', NULL, '{"x":-784.194,"y":323.636,"z":210.997}', '{"x":-779.751,"y":323.385,"z":210.997}', NULL, '["apa_v_mp_h_02_a"]', 'MiltonDrive', 0, 1, 0, '{"x":-766.615,"y":327.878,"z":210.396}', 310000),
	(17, 'Mody2Apartment', 'Appartement Mode 2', NULL, '{"x":-786.8663,"y":315.764,"z":186.913}', '{"x":-781.808,"y":315.866,"z":186.913}', NULL, '["apa_v_mp_h_02_c"]', 'MiltonDrive', 0, 1, 0, '{"x":-795.297,"y":327.092,"z":186.313}', 310000),
	(18, 'Mody3Apartment', 'Appartement Mode 3', NULL, '{"x":-774.012,"y":342.042,"z":195.686}', '{"x":-779.057,"y":342.063,"z":195.686}', NULL, '["apa_v_mp_h_02_b"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.303,"y":330.932,"z":195.085}', 310000),
	(19, 'Vibrant1Apartment', 'Appartement Vibrant 1', NULL, '{"x":-784.194,"y":323.636,"z":210.997}', '{"x":-779.751,"y":323.385,"z":210.997}', NULL, '["apa_v_mp_h_03_a"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.885,"y":327.641,"z":210.396}', 310000),
	(20, 'Vibrant2Apartment', 'Appartement Vibrant 2', NULL, '{"x":-786.8663,"y":315.764,"z":186.913}', '{"x":-781.808,"y":315.866,"z":186.913}', NULL, '["apa_v_mp_h_03_c"]', 'MiltonDrive', 0, 1, 0, '{"x":-795.607,"y":327.344,"z":186.313}', 310000),
	(21, 'Vibrant3Apartment', 'Appartement Vibrant 3', NULL, '{"x":-774.012,"y":342.042,"z":195.686}', '{"x":-779.057,"y":342.063,"z":195.686}', NULL, '["apa_v_mp_h_03_b"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.525,"y":330.851,"z":195.085}', 310000),
	(22, 'Sharp1Apartment', 'Appartement Persan 1', NULL, '{"x":-784.194,"y":323.636,"z":210.997}', '{"x":-779.751,"y":323.385,"z":210.997}', NULL, '["apa_v_mp_h_04_a"]', 'MiltonDrive', 0, 1, 0, '{"x":-766.527,"y":327.89,"z":210.396}', 310000),
	(23, 'Sharp2Apartment', 'Appartement Persan 2', NULL, '{"x":-786.8663,"y":315.764,"z":186.913}', '{"x":-781.808,"y":315.866,"z":186.913}', NULL, '["apa_v_mp_h_04_c"]', 'MiltonDrive', 0, 1, 0, '{"x":-795.642,"y":326.497,"z":186.313}', 310000),
	(24, 'Sharp3Apartment', 'Appartement Persan 3', NULL, '{"x":-774.012,"y":342.042,"z":195.686}', '{"x":-779.057,"y":342.063,"z":195.686}', NULL, '["apa_v_mp_h_04_b"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.503,"y":331.318,"z":195.085}', 310000),
	(25, 'Monochrome1Apartment', 'Appartement Monochrome 1', NULL, '{"x":-784.194,"y":323.636,"z":210.997}', '{"x":-779.751,"y":323.385,"z":210.997}', NULL, '["apa_v_mp_h_05_a"]', 'MiltonDrive', 0, 1, 0, '{"x":-766.289,"y":328.086,"z":210.396}', 310000),
	(26, 'Monochrome2Apartment', 'Appartement Monochrome 2', NULL, '{"x":-786.8663,"y":315.764,"z":186.913}', '{"x":-781.808,"y":315.866,"z":186.913}', NULL, '["apa_v_mp_h_05_c"]', 'MiltonDrive', 0, 1, 0, '{"x":-795.692,"y":326.762,"z":186.313}', 310000),
	(27, 'Monochrome3Apartment', 'Appartement Monochrome 3', NULL, '{"x":-774.012,"y":342.042,"z":195.686}', '{"x":-779.057,"y":342.063,"z":195.686}', NULL, '["apa_v_mp_h_05_b"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.094,"y":330.976,"z":195.085}', 310000),
	(28, 'Seductive1Apartment', 'Appartement Séduisant 1', NULL, '{"x":-784.194,"y":323.636,"z":210.997}', '{"x":-779.751,"y":323.385,"z":210.997}', NULL, '["apa_v_mp_h_06_a"]', 'MiltonDrive', 0, 1, 0, '{"x":-766.263,"y":328.104,"z":210.396}', 310000),
	(29, 'Seductive2Apartment', 'Appartement Séduisant 2', NULL, '{"x":-786.8663,"y":315.764,"z":186.913}', '{"x":-781.808,"y":315.866,"z":186.913}', NULL, '["apa_v_mp_h_06_c"]', 'MiltonDrive', 0, 1, 0, '{"x":-795.655,"y":326.611,"z":186.313}', 310000),
	(30, 'Seductive3Apartment', 'Appartement Séduisant 3', NULL, '{"x":-774.012,"y":342.042,"z":195.686}', '{"x":-779.057,"y":342.063,"z":195.686}', NULL, '["apa_v_mp_h_06_b"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.3,"y":331.414,"z":195.085}', 310000),
	(31, 'Regal1Apartment', 'Appartement Régal 1', NULL, '{"x":-784.194,"y":323.636,"z":210.997}', '{"x":-779.751,"y":323.385,"z":210.997}', NULL, '["apa_v_mp_h_07_a"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.956,"y":328.257,"z":210.396}', 310000),
	(32, 'Regal2Apartment', 'Appartement Régal 2', NULL, '{"x":-786.8663,"y":315.764,"z":186.913}', '{"x":-781.808,"y":315.866,"z":186.913}', NULL, '["apa_v_mp_h_07_c"]', 'MiltonDrive', 0, 1, 0, '{"x":-795.545,"y":326.659,"z":186.313}', 310000),
	(33, 'Regal3Apartment', 'Appartement Régal 3', NULL, '{"x":-774.012,"y":342.042,"z":195.686}', '{"x":-779.057,"y":342.063,"z":195.686}', NULL, '["apa_v_mp_h_07_b"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.087,"y":331.429,"z":195.123}', 310000),
	(34, 'Aqua1Apartment', 'Appartement Aqua 1', NULL, '{"x":-784.194,"y":323.636,"z":210.997}', '{"x":-779.751,"y":323.385,"z":210.997}', NULL, '["apa_v_mp_h_08_a"]', 'MiltonDrive', 0, 1, 0, '{"x":-766.187,"y":328.47,"z":210.396}', 310000),
	(35, 'Aqua2Apartment', 'Appartement Aqua 2', NULL, '{"x":-786.8663,"y":315.764,"z":186.913}', '{"x":-781.808,"y":315.866,"z":186.913}', NULL, '["apa_v_mp_h_08_c"]', 'MiltonDrive', 0, 1, 0, '{"x":-795.658,"y":326.563,"z":186.313}', 310000),
	(36, 'Aqua3Apartment', 'Appartement Aqua 3', NULL, '{"x":-774.012,"y":342.042,"z":195.686}', '{"x":-779.057,"y":342.063,"z":195.686}', NULL, '["apa_v_mp_h_08_b"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.287,"y":331.084,"z":195.086}', 310000),
	(37, 'IntegrityWay', '4 Integrity Way', '{"x":-47.804,"y":-585.867,"z":36.956}', NULL, NULL, '{"x":-54.178,"y":-583.762,"z":35.798}', '[]', NULL, 0, 0, 1, NULL, 0),
	(38, 'IntegrityWay28', '4 Integrity Way - Apt 28', NULL, '{"x":-31.409,"y":-594.927,"z":79.03}', '{"x":-26.098,"y":-596.909,"z":79.03}', NULL, '[]', 'IntegrityWay', 0, 1, 0, '{"x":-11.923,"y":-597.083,"z":78.43}', 420000),
	(39, 'IntegrityWay30', '4 Integrity Way - Apt 30', NULL, '{"x":-17.702,"y":-588.524,"z":89.114}', '{"x":-16.21,"y":-582.569,"z":89.114}', NULL, '[]', 'IntegrityWay', 0, 1, 0, '{"x":-26.327,"y":-588.384,"z":89.123}', 420000),
	(40, 'DellPerroHeights', 'Dell Perro Heights', '{"x":-1447.06,"y":-538.28,"z":33.74}', NULL, NULL, '{"x":-1440.022,"y":-548.696,"z":33.74}', '[]', NULL, 0, 0, 1, NULL, 0),
	(41, 'DellPerroHeightst4', 'Dell Perro Heights - Apt 28', NULL, '{"x":-1452.125,"y":-540.591,"z":73.044}', '{"x":-1455.435,"y":-535.79,"z":73.044}', NULL, '[]', 'DellPerroHeights', 0, 1, 0, '{"x":-1467.058,"y":-527.571,"z":72.443}', 420000),
	(42, 'DellPerroHeightst7', 'Dell Perro Heights - Apt 30', NULL, '{"x":-1451.562,"y":-523.535,"z":55.928}', '{"x":-1456.02,"y":-519.209,"z":55.929}', NULL, '[]', 'DellPerroHeights', 0, 1, 0, '{"x":-1457.026,"y":-530.219,"z":55.937}', 420000);

-- Listage de la structure de table onelife. properties_list
CREATE TABLE IF NOT EXISTS `properties_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text DEFAULT NULL,
  `info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `price` varchar(255) DEFAULT NULL,
  `coords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `isBuy` varchar(255) DEFAULT '0',
  `owner` text DEFAULT NULL,
  `data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `id` (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1731 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.properties_list : ~0 rows (environ)
DELETE FROM `properties_list`;

-- Listage de la structure de table onelife. rapports
CREATE TABLE IF NOT EXISTS `rapports` (
  `Prenom` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `Nom` varchar(50) DEFAULT '',
  `Type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '',
  `Montant` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.rapports : ~0 rows (environ)
DELETE FROM `rapports`;

-- Listage de la structure de table onelife. societies_storage
CREATE TABLE IF NOT EXISTS `societies_storage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `inventory` longtext DEFAULT NULL,
  `money` int(11) NOT NULL DEFAULT 0,
  `dirty_money` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=357 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.societies_storage : ~32 rows (environ)
DELETE FROM `societies_storage`;
INSERT INTO `societies_storage` (`id`, `name`, `label`, `inventory`, `money`, `dirty_money`) VALUES
	(325, 'RaRecords', 'rarecords', '[]', 0, 0),
	(326, 'ambulance', 'Ambulance', '[]', 2047, 0),
	(327, 'bcso', 'S.A.S.D', '[]', 0, 0),
	(328, 'appleindustrie', 'Apple Industrie', '[]', 0, 0),
	(329, 'boatseller', 'Concessionnaire Bénéteau', '[]', 0, 0),
	(330, 'avocat', 'Avocat', '[]', 0, 0),
	(331, 'burgershot', 'BurgerShot', '[]', 0, 0),
	(332, 'chickenbell', 'ChickenBell', '[]', 0, 0),
	(333, 'cardealer', 'Concessionnaire', '[]', 0, 0),
	(334, 'churchtown', 'ChurchTown', '[]', 0, 0),
	(335, 'delivery', 'Delivery', '[]', 0, 0),
	(336, 'fib', 'FIB', '[]', 0, 0),
	(337, 'fisherman', 'Pêcheur', '[]', 0, 0),
	(338, 'fueler', 'Raffineur', '[]', 0, 0),
	(339, 'gouv', 'Gouvernement', '[]', 5, 0),
	(340, 'jardinier', 'Jardinier', '[]', 0, 0),
	(341, 'journalist', 'Journaliste', '[]', 0, 0),
	(342, 'label', 'RA Records', '[]', 0, 0),
	(343, 'lumberjack', 'Bûcheron', '[]', 0, 0),
	(344, 'mecano', 'Benny\'s', '[]', 50107, 0),
	(345, 'mecano2', 'Ls Custom', '[]', 0, 0),
	(346, 'miner', 'Mineur', '[]', 0, 0),
	(347, 'planeseller', 'Concessionnaire Aéronotique', '[]', 0, 0),
	(348, 'police', 'Police', '[]', 307391, 0),
	(349, 'realestateagent', 'Agent immobilier', '[]', 0, 0),
	(350, 'tacos', 'Tacos', '[]', 0, 0),
	(351, 'slaughterer', 'Abateur', '[]', 0, 0),
	(352, 'tailor', 'Couturier', '[]', 0, 0),
	(353, 'taxi', 'Taxi', '[]', 0, 0),
	(354, 'tequilala', 'Tequilala', '[]', 0, 0),
	(355, 'unicorn', 'Unicorn', '[]', 0, 0),
	(356, 'vigneron', 'Vigneron', '[]', 0, 0);

-- Listage de la structure de table onelife. staff
CREATE TABLE IF NOT EXISTS `staff` (
  `name` text NOT NULL,
  `license` varchar(255) NOT NULL,
  `evaluation` text NOT NULL,
  `report` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`license`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.staff : ~0 rows (environ)
DELETE FROM `staff`;

-- Listage de la structure de table onelife. tebex_history
CREATE TABLE IF NOT EXISTS `tebex_history` (
  `identifier` varchar(255) DEFAULT NULL,
  `transaction` varchar(255) DEFAULT NULL,
  `price` bigint(20) DEFAULT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Listage des données de la table onelife.tebex_history : ~0 rows (environ)
DELETE FROM `tebex_history`;

-- Listage de la structure de table onelife. tebex_limited_vehicles
CREATE TABLE IF NOT EXISTS `tebex_limited_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `quantity` bigint(20) NOT NULL DEFAULT 1,
  `price` bigint(20) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table onelife.tebex_limited_vehicles : ~0 rows (environ)
DELETE FROM `tebex_limited_vehicles`;

-- Listage de la structure de table onelife. tebex_pending_payment
CREATE TABLE IF NOT EXISTS `tebex_pending_payment` (
  `fivemID` varchar(255) NOT NULL,
  `coins` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table onelife.tebex_pending_payment : ~0 rows (environ)
DELETE FROM `tebex_pending_payment`;

-- Listage de la structure de table onelife. tebex_players_wallet
CREATE TABLE IF NOT EXISTS `tebex_players_wallet` (
  `identifiers` text NOT NULL,
  `transaction` text DEFAULT NULL,
  `price` text NOT NULL,
  `currency` text DEFAULT NULL,
  `points` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table onelife.tebex_players_wallet : ~0 rows (environ)
DELETE FROM `tebex_players_wallet`;

-- Listage de la structure de table onelife. trunk_inventory
CREATE TABLE IF NOT EXISTS `trunk_inventory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vehicleModel` int(11) NOT NULL DEFAULT 0,
  `vehiclePlate` varchar(50) NOT NULL,
  `items` longtext NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `vehiclePlate` (`vehiclePlate`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=22558 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.trunk_inventory : ~0 rows (environ)
DELETE FROM `trunk_inventory`;

-- Listage de la structure de table onelife. users
CREATE TABLE IF NOT EXISTS `users` (
  `character_id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(155) NOT NULL,
  `discord` varchar(50) DEFAULT NULL,
  `fivem` varchar(50) DEFAULT NULL,
  `permission_group` varchar(50) DEFAULT 'user',
  `permission_level` int(11) DEFAULT 0,
  `position` longtext DEFAULT NULL,
  `skin` longtext DEFAULT NULL,
  `accounts` longtext DEFAULT NULL,
  `inventory` longtext DEFAULT NULL,
  `clothes` longtext DEFAULT NULL,
  `job` varchar(50) DEFAULT 'unemployed',
  `job_grade` int(11) DEFAULT 0,
  `job2` varchar(50) DEFAULT 'unemployed2',
  `job2_grade` int(11) DEFAULT 0,
  `isDead` int(11) DEFAULT 0,
  `IsHurt` int(11) DEFAULT 0,
  `hurtTime` bigint(20) DEFAULT 0,
  `underPants` longtext DEFAULT NULL,
  `status` longtext DEFAULT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  `dateofbirth` varchar(25) DEFAULT NULL,
  `sex` varchar(10) DEFAULT NULL,
  `height` varchar(5) DEFAULT NULL,
  `coins` int(11) NOT NULL DEFAULT 0,
  `animation` longtext DEFAULT NULL,
  `demarche` longtext DEFAULT NULL,
  `expression` longtext DEFAULT NULL,
  `xp` int(11) DEFAULT 0,
  PRIMARY KEY (`character_id`) USING BTREE,
  UNIQUE KEY `identifier` (`identifier`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=24767 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- Listage de la structure de table onelife. user_licenses
CREATE TABLE IF NOT EXISTS `user_licenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(60) NOT NULL,
  `owner` varchar(60) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4933 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.user_licenses : ~0 rows (environ)
DELETE FROM `user_licenses`;

-- Listage de la structure de table onelife. user_tenue
CREATE TABLE IF NOT EXISTS `user_tenue` (
  `id` int(11) NOT NULL,
  `identifier` varchar(255) DEFAULT NULL,
  `tenue` longtext NOT NULL,
  `label` varchar(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.user_tenue : 0 rows
DELETE FROM `user_tenue`;
/*!40000 ALTER TABLE `user_tenue` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_tenue` ENABLE KEYS */;

-- Listage de la structure de table onelife. vdaaccess
CREATE TABLE IF NOT EXISTS `vdaaccess` (
  `license` varchar(50) NOT NULL,
  `lvl` int(11) DEFAULT NULL,
  PRIMARY KEY (`license`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.vdaaccess : ~0 rows (environ)
DELETE FROM `vdaaccess`;

-- Listage de la structure de table onelife. vehicleclaimsell
CREATE TABLE IF NOT EXISTS `vehicleclaimsell` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.vehicleclaimsell : ~0 rows (environ)
DELETE FROM `vehicleclaimsell`;

-- Listage de la structure de table onelife. vehicles
CREATE TABLE IF NOT EXISTS `vehicles` (
  `model` varchar(60) NOT NULL,
  `name` varchar(60) NOT NULL,
  `price` int(11) NOT NULL,
  `category` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`model`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.vehicles : ~415 rows (environ)
DELETE FROM `vehicles`;
INSERT INTO `vehicles` (`model`, `name`, `price`, `category`) VALUES
	('Ubermatch Sentinel XS', 'Benefactor Dubsta 6x6', 250000, 'offroad'),
	('adder', 'Truffade Adder', 250000, 'super'),
	('akuma', 'Dinka Akuma ', 3750, 'motorcycles'),
	('alpha', 'Albany Alpha', 22500, 'sports'),
	('asbo', 'Maxwell Asbo', 10000, 'compacts'),
	('asea', 'Declasse Asea', 6250, 'sedans'),
	('asterope', 'Karin Asterope', 12500, 'sedans'),
	('astron', 'Pfister Astron', 75000, 'suvs'),
	('autarch', 'Overflod Autarch', 450000, 'super'),
	('avarus', 'Liberty City Cycles Avarus', 12500, 'motorcycles'),
	('bagger', 'Bagger', 10000, 'motorcycles'),
	('baller', 'Gallivanter Baller LE LWB', 17500, 'suvs'),
	('baller2', 'Gallivanter Baller LE', 25000, 'suvs'),
	('baller4', 'Gallivanter Baller LE LWB Custom', 37500, 'suvs'),
	('baller7', 'Gallivanter Baller ST', 65000, 'suvs'),
	('banshee', 'Bravado Banshee', 25000, 'sports'),
	('banshee2', 'Banshee Custom', 75000, 'super'),
	('bati', 'Pegassi Bati 801', 13750, 'motorcycles'),
	('bati2', 'Pegassi Bati 801', 16250, 'motorcycles'),
	('bestiagts', 'Grotti Bestia GTS', 20000, 'sports'),
	('bf400', 'Nagasaki BF400', 10000, 'motorcycles'),
	('bfinjection', 'BF Injection', 1500, 'offroad'),
	('bifta', 'BF Bifta', 10000, 'offroad'),
	('bison', 'Bravado Bison', 12500, 'vans'),
	('bjxl', 'BeeJay XL', 17500, 'suvs'),
	('blade', 'Vapid Blade', 5500, 'muscle'),
	('blazer', 'Nagasaki Blazer', 1500, 'offroad'),
	('blazer3', 'Hot Rod Blazer', 8750, 'offroad'),
	('blazer4', 'Blazer Street', 13750, 'offroad'),
	('blista', 'Dinka Blista', 6250, 'compacts'),
	('blista2', 'Blista Compact', 20000, 'sports'),
	('bobcatxl', 'Vapid Bobcat XL', 9000, 'vans'),
	('bodhi2', 'Bodhi', 13750, 'offroad'),
	('brawler', 'Coil Brawler', 32500, 'offroad'),
	('brioso', 'Grotti Brioso R/A', 17750, 'compacts'),
	('brioso2', 'Brioso', 22500, 'compacts'),
	('btype', 'B Type', 50000, 'sportsclassics'),
	('btype2', 'Btype2 Hotrood Sedan', 55000, 'sportsclassics'),
	('btype3', 'Roosevelt Valor', 62500, 'sportsclassics'),
	('buccaneer', 'Albany Buccaneer', 7500, 'muscle'),
	('buccaneer2', 'Buccaneer Custom', 12500, 'muscle'),
	('buffalo', 'Bravado Buffalo', 12500, 'sports'),
	('buffalo2', 'Bravado Buffalo S', 18750, 'sports'),
	('bullet', 'Vapid Bullet', 75000, 'super'),
	('burrito3', 'Burrito', 15000, 'vans'),
	('calico', 'Karin Calico GTF', 23750, 'sports'),
	('camper', 'Brute Camper', 30000, 'vans'),
	('caracara2', 'Vapid 4x4 Caracara', 125000, 'offroad'),
	('carbonizzare', 'Grotti Carbonizzare', 40000, 'sports'),
	('carbonrs', 'Nagasaki Carbon RS', 12000, 'motorcycles'),
	('casco', 'Lampadati Casco', 32500, 'sportsclassics'),
	('cavalcade', 'Albany Cavalcade', 10000, 'suvs'),
	('cavalcade2', 'Albany Cavalcade', 12500, 'suvs'),
	('cheburek', 'RUNE Cheburek', 22500, 'sportsclassics'),
	('cheetah', 'Grotti Cheetah', 500000, 'super'),
	('cheetah2', 'Grotti Cheetah Classic', 125000, 'sportsclassics'),
	('chimera', 'Nagasaki Chimera', 22500, 'motorcycles'),
	('chino', 'Vapid Chino', 7500, 'muscle'),
	('chino2', 'Chino Custom', 11250, 'muscle'),
	('cinquemila', 'Lampadati Cinquemila', 42500, 'sports'),
	('cliffhanger', 'Cliffhanger', 21250, 'motorcycles'),
	('clique', 'Vapid Clique', 7500, 'muscle'),
	('club', 'BF Club', 6250, 'compacts'),
	('cog55', 'Enus Cognoscenti 55', 10000, 'sedans'),
	('cogcabrio', 'Enus Cognoscenti Cabrio', 25000, 'coupes'),
	('cognoscenti', 'Enus Cognoscenti', 32500, 'sedans'),
	('comet2', 'Pfister Comet', 25000, 'sports'),
	('comet3', 'Pfister Comet Rétro Custom', 37500, 'sports'),
	('comet5', 'Pfister Comet SR', 25000, 'sports'),
	('comet6', 'Pfister Comet S2', 57500, 'sports'),
	('comet7', 'Pfister Comet S2 Cabrio', 87500, 'sports'),
	('contender', 'Vapid Contender', 75000, 'suvs'),
	('coquette3', 'Invetero Coquette', 30000, 'muscle'),
	('coquette4', 'Invetero Coquette', 500000, 'sports'),
	('cuban800', 'Cuban 800', 450000, 'avionfdp'),
	('cyclone', 'oil Cyclone', 750000, 'super'),
	('cypher', 'Ubermacht Cypher', 25000, 'sports'),
	('daemon', 'Daemon', 10500, 'motorcycles'),
	('daemon2', 'Daemon', 21250, 'motorcycles'),
	('defiler', 'Shitzu Defiler', 15000, 'motorcycles'),
	('deveste', 'Principe Deveste Eight', 875000, 'sports'),
	('deviant', 'Schyster Deviant', 35000, 'muscle'),
	('diablous', 'Diablous', 17500, 'motorcycles'),
	('diablous2', 'Diablous', 22500, 'motorcycles'),
	('dilettante', 'Karin Dilettante', 5000, 'compacts'),
	('dinghy', 'Nagasaki Dinghy', 300000, 'superboat'),
	('dloader', 'Bravado Duneloader', 12500, 'offroad'),
	('dodo', 'Mammoth Dodo', 500000, 'avionfdp'),
	('dominator', 'Vapid Dominator', 15000, 'muscle'),
	('dominator3', 'Vapid Dominator GTX', 37500, 'muscle'),
	('dominator7', 'Vapid Dominator ASP', 60000, 'muscle'),
	('double', 'Dinka Double T', 11250, 'motorcycles'),
	('drafter', 'Obey 8F Drafter', 75000, 'sports'),
	('draugur', 'Declasse Draugur', 125000, 'offroads'),
	('dubsta', 'Benefactor Dubsta', 50000, 'suvs'),
	('dubsta2', 'Benefactor Dubsta', 60000, 'suvs'),
	('dukes', 'Imponte Dukes', 10000, 'muscle'),
	('dune', 'BF Dune Buggy', 6250, 'offroad'),
	('dynasty', 'Weeny Dynasty', 17500, 'sportsclassics'),
	('elegy', 'Annis Elegy RH8 Retro Custom', 100000, 'sports'),
	('elegy2', 'Annis Elegy RH8', 10000, 'sports'),
	('ellie', 'Vapid Ellie', 10000, 'muscle'),
	('emerus', 'Progen Emerus', 425000, 'super'),
	('emperor', 'Albany Emperor', 6250, 'sedans'),
	('enduro', 'Dinka Enduro', 10000, 'motorcycles'),
	('entity2', 'Entity XXR', 750000, 'super'),
	('entityxf', 'Overflod Entity XF', 225000, 'super'),
	('esskey', 'Pegassi Esskey', 12500, 'motorcycles'),
	('euros', 'Annis Euros', 20000, 'sports'),
	('everon', 'Karin Everon', 200000, 'offroad'),
	('exemplar', 'Dewbauchee Exemplar', 33750, 'coupes'),
	('f620', 'Ocelot F620', 18750, 'coupes'),
	('faction', 'Willard Faction', 6250, 'muscle'),
	('faction2', 'Faction Custom', 21250, 'muscle'),
	('faction3', 'Faction Custom', 26250, 'muscle'),
	('fagaloa', 'Vulcar Fagaloa', 16250, 'sportsclassics'),
	('faggio', 'Faggio', 1000, 'motorcycles'),
	('faggio2', 'Faggio', 1000, 'motorcycles'),
	('faggio3', 'Faggio', 1000, 'motorcycles'),
	('fcr', 'Pegassi FCR 1000', 18750, 'motorcycles'),
	('fcr2', 'Pegassi FCR 1000', 21250, 'motorcycles'),
	('felon', 'Lampadati Felon', 8750, 'coupes'),
	('feltzer2', 'Benefactor Feltzer', 23750, 'sports'),
	('feltzer3', 'Feltzer Clasique', 4000000, 'sportsclassics'),
	('flashgt', 'Vapid Flash GT', 62500, 'sports'),
	('fmj', 'Vapid FMJ', 30000, 'super'),
	('freecrawler', 'Canis Freecrawler', 75000, 'offroad'),
	('frogger', 'Maibatsu Frogger', 750000, 'avionfdp'),
	('fugitive', 'Cheval Fugitive', 12500, 'sedans'),
	('furia', 'Grotti Furia', 62500, 'super'),
	('furoregt', 'Lampadati Furore GT', 17500, 'sports'),
	('fusilade', 'Schyster Fusilade', 16250, 'sports'),
	('futo', 'Karin Futo', 7500, 'sports'),
	('futo2', 'Futo GTX', 23750, 'sports'),
	('gargoyle', 'Gargoyle', 32500, 'motorcycles'),
	('gauntlet', 'Bravado Gauntlet', 13750, 'muscle'),
	('gauntlet3', 'Bravado Gauntlet Classic', 16250, 'muscle'),
	('gauntlet4', 'Bravado Gauntlet Hellfire', 23750, 'muscle'),
	('gb200', 'Vapid GB 200', 25000, 'sports'),
	('gburrito', 'Burrito de gang', 15000, 'suvs'),
	('glendale', 'Benefactor Glendale', 16250, 'sedans'),
	('glendale2', 'Benefactor Glendale', 18750, 'sedans'),
	('gp1', 'Progen GP1', 27500, 'super'),
	('granger', 'Declasse Granger', 20000, 'suvs'),
	('greenwood', 'Bravado Greenwood', 30000, 'muscle'),
	('gresley', 'Bravado Gresley', 7500, 'suvs'),
	('growler', 'Pfister Growler', 125000, 'sports'),
	('gt500', 'Grotti GT500', 22500, 'sportsclassics'),
	('guardian', 'Guardian', 62500, 'suvs'),
	('habanero', 'Emperor Habanero', 6250, 'suvs'),
	('hakuchou', 'Shitzu Hakuchou', 18250, 'motorcycles'),
	('hakuchou2', 'Shitzu Hakuchou Drag', 68750, 'motorcycles'),
	('hellion', 'Annis Hellion', 37500, 'offroad'),
	('hermes', 'Albany Hermes', 22500, 'muscle'),
	('hexer', 'Hexer', 16250, 'motorcycles'),
	('hotknife', 'Vapid Hotknife', 10000, 'muscle'),
	('hotring', 'Declasse Hotring Sabre', 31250, 'sports'),
	('howard', 'Buckingham Howard NX-25', 1200000, 'avionfdp'),
	('huntley', 'Enus Huntley S', 7500, 'suvs'),
	('hustler', 'Vapid Hustler', 10000, 'muscle'),
	('ignus', 'Pegassi Ignus', 625000, 'super'),
	('imorgon', 'Overflod Imorgon', 47500, 'sports'),
	('impaler', 'Declasse Impaler', 6250, 'muscle'),
	('infernus', 'Pegassi Infernus', 10000, 'super'),
	('infernus2', 'Pegassi Infernus classic', 125000, 'sportsclassics'),
	('ingot', 'Vulcar Ingot', 5000, 'sedans'),
	('innovation', 'Liberty City Cycles Hexer', 17500, 'motorcycles'),
	('intruder', 'Karin Intruder', 10000, 'sedans'),
	('issi2', 'Weeny Issi', 4000, 'compacts'),
	('issi3', 'Weeny Issi Classic', 13000, 'compacts'),
	('issi7', 'Issi Sport', 14000, 'sports'),
	('italigtb', 'Progen Itali GTB', 100000, 'super'),
	('italigtb2', 'Progen Itali GTB Custom', 85000, 'super'),
	('italigto', 'Grotti Itali GTO', 400000, 'sports'),
	('italirsx', 'Grotti Itali RSX', 500000, 'sports'),
	('iwagen', 'Obey I-Wagen', 62500, 'suvs'),
	('jackal', 'Ocelot Jackal', 30000, 'coupes'),
	('jester', 'Dinka Jester', 25000, 'sports'),
	('jester2', 'Dinka Jester', 25000, 'sports'),
	('jester3', 'Dinka Jester Classic', 75000, 'sports'),
	('jester4', 'Dinka Jester RR', 37500, 'sports'),
	('jetmax', 'Shitzu Jetmax', 250000, 'superboat'),
	('journey', 'Zirconium Journey', 6250, 'vans'),
	('jugular', 'Ocelot Jugular', 450000, 'sports'),
	('kalahari', 'Canis Kalahari', 4000, 'offroad'),
	('kamacho', 'Canis Kamacho', 250000, 'offroad'),
	('kanjo', 'Dinka Blista Kanjo', 7500, 'compacts'),
	('kanjosj', 'Dinka KanjoSJ', 10000, 'coupes'),
	('khamelion', 'Hijak Khamelion', 16250, 'sports'),
	('komoda', 'Lampadati Komoda', 50000, 'sports'),
	('krieger', 'Benefactor Krieger', 750000, 'super'),
	('landstalker', 'Dundreary Landstalker', 6250, 'suvs'),
	('landstalker2', 'Dundreary Landstalker', 11250, 'suvs'),
	('le7b', 'RE-7B', 750000, 'super'),
	('lectro', 'Principe Lectro', 50000, 'motorcycles'),
	('lm87', 'Benefactor Lm87', 750000, 'super'),
	('locust', 'Ocelot Locust', 37500, 'sports'),
	('longfin', 'Shitzu Longfin', 350000, 'superboat'),
	('lurcher', 'Albany Lurcher', 8750, 'muscle'),
	('luxor', 'Buckingham Luxor', 6000000, 'avionfdp'),
	('luxor2', 'Buckingham Luxor Deluxe', 7500000, 'avionfdp'),
	('lynx', 'Ocelot Lynx', 21250, 'sports'),
	('mammatus', 'JoBuilt Mammatus', 325000, 'avionfdp'),
	('mamoa', 'Declasse Mamba', 225000, 'sportsclassics'),
	('manana', 'Albany Manana', 25000, 'sportsclassics'),
	('manana2', 'Albany Manana Custom', 25000, 'sportsclassics'),
	('manchez', 'Maibatsu Manchez', 12500, 'motorcycles'),
	('manchez2', 'MMaibatsu Manchez Black', 16250, 'motorcycles'),
	('marquis', 'Dinka Marquis', 450000, 'superboat'),
	('massacro', 'Dewbauchee Massacro', 23750, 'sports'),
	('maverick', 'Buckingham Maverick', 500000, 'avionfdp'),
	('mesa', 'Canis Mesa', 50000, 'suvs'),
	('mesa3', 'Canis Mesa Custom', 67500, 'offroad'),
	('michelli', 'Michelli GT', 32500, 'sportsclassics'),
	('minivan', 'Vapid Minivan', 12500, 'vans'),
	('monroe', 'Pegassi Monroe', 17500, 'sportsclassics'),
	('moonbeam', 'Declasse Moonbeam', 15000, 'muscle'),
	('moonbeam2', 'Declasse Moonbeam Custom', 21250, 'muscle'),
	('nebula', 'Vulcar Nebula Turbo', 17000, 'sportsclassics'),
	('nemesis', 'Principe Nemesis', 8750, 'motorcycles'),
	('neo', 'Vysser Neo', 35000, 'sports'),
	('neon', 'Pfister Neon', 225000, 'sports'),
	('nero', 'Truffade Nero', 550000, 'super'),
	('nero2', 'Truffade Nero Custom', 1250000, 'super'),
	('nightblade', 'Nightblade', 27500, 'motorcycles'),
	('nightshade', 'Imponte Nightshade', 25000, 'muscle'),
	('nimbus', 'Buckingham Nimbus', 1400000, 'avionfdp'),
	('ninef', 'Obey 9F', 16250, 'sports'),
	('novak', 'Lampadati Novak', 87500, 'suvs'),
	('omnis', 'Obey Omnis', 12500, 'sports'),
	('oracle', 'Ubermacht Oracle XS', 11250, 'coupes'),
	('oracle2', 'Ubermacht Oracle ', 18750, 'coupes'),
	('osiris', 'Pegassi Osiris', 187500, 'super'),
	('outlaw', 'Nagasaki Outlaw', 175000, 'offroad'),
	('panto', 'Benefactor Panto', 3750, 'compacts'),
	('paragon', 'nus Paragon R', 200000, 'sports'),
	('pariah', 'Ocelot Pariah', 250000, 'sports'),
	('patriot', 'Mammoth Patriot', 15000, 'suvs'),
	('patriot2', 'Mammoth Patriot Limo', 31250, 'suvs'),
	('patriot3', 'Mammoth Patriot Mil-Spec', 112500, 'suvs'),
	('pcj', 'Shitzu PCJ 600', 6250, 'motorcycles'),
	('penetrator', 'Ocelot Penetrator', 31000, 'super'),
	('penumbra', 'Maibatsu Penumbra', 16250, 'sports'),
	('penumbra2', 'Maibatsu Penumbra', 18750, 'sports'),
	('peyote', 'Vapid Peyote', 18750, 'sportsclassics'),
	('peyote2', 'Peyote Gasser', 22500, 'muscle'),
	('peyote3', 'Vapid Peyote Custom', 18750, 'sportsclassics'),
	('pfister811', 'Pfister 811', 245000, 'super'),
	('phoenix', 'Imponte Phoenix', 7500, 'muscle'),
	('picador', 'Cheval Picador', 5000, 'muscle'),
	('pigalle', 'Lampadati Pigalle', 23500, 'sportsclassics'),
	('postlude', 'Dinka Postlude', 7500, 'coupes'),
	('prairie', 'Bollokan Prairie', 6750, 'compacts'),
	('premier', 'Declasse Premier', 6250, 'sedans'),
	('previon', 'Karin Previon', 42500, 'coupes'),
	('primo', 'Albany Primo ', 11250, 'sedans'),
	('primo2', 'Primo Custom', 33750, 'sedans'),
	('prototipo', 'Grotti X80 Proto', 625000, 'super'),
	('radi', 'Vapid Radius', 9000, 'suvs'),
	('raiden', 'Coil Raiden', 52500, 'sports'),
	('rancherxl', 'Declasse Rancher XL', 5500, 'offroad'),
	('rapidgt', 'Dewbauchee Rapid GT', 47500, 'sports'),
	('rapidgt3', 'Rapid GT Classic', 23500, 'sportsclassics'),
	('raptor', 'BF Raptor', 25000, 'sports'),
	('ratbike', 'Ratbike', 7500, 'motorcycles'),
	('ratloader2', 'Bravado Rat-Loader', 3750, 'muscle'),
	('reaper', 'Pegassi Reaper', 90000, 'super'),
	('rebel', 'Karin Rebel', 7500, 'offroad'),
	('rebla', 'Ubermacht Rebla GTS', 125000, 'suvs'),
	('reever', 'Western Reever', 13750, 'motorcycles'),
	('regina', 'Dundreary Regina', 5000, 'sedans'),
	('remus', 'Annis Remus', 22500, 'sports'),
	('retinue', 'Vapid Retinue', 18750, 'sportsclassics'),
	('retinue2', 'Vapid Retinue Mk II', 18750, 'sportsclassics'),
	('rhapsody', 'Declasse Rhapsody', 6250, 'compacts'),
	('rhinehart', 'Rhinehart', 200000, 'sedans'),
	('riata', 'Vapid Riata', 11250, 'offroad'),
	('rocoto', 'Obey Rocoto', 7500, 'suvs'),
	('rrocket', 'Rampant Rocket', 60000, 'motorcycles'),
	('rt3000', 'Dinka RT3000', 30000, 'sports'),
	('ruffian', 'Pegassi Ruffian', 10000, 'motorcycles'),
	('ruiner', 'Imponte Ruiner', 3750, 'muscle'),
	('ruiner4', 'Imponte Ruiner ZZ-8', 20000, 'muscle'),
	('rumpo', 'Bravado Rumpo', 18750, 'vans'),
	('rumpo3', 'Bravado Rumpo Custom', 31250, 'vans'),
	('ruston', 'Hijak Ruston', 18750, 'sports'),
	('s80', 'Annis S80RR', 300000, 'super'),
	('sabregt', 'Declasse Sabre Turbo', 11250, 'muscle'),
	('sabregt2', 'Sabre Turbo Custom', 13750, 'muscle'),
	('sanchez', 'Maibatsu Sanchez', 3750, 'motorcycles'),
	('sanctus', 'Liberty City Cycles Sanctus', 21250, 'motorcycles'),
	('sandking', 'Vapid Sandking XL', 20000, 'offroad'),
	('sandking2', 'Sandking XL', 25000, 'offroad'),
	('sc1', 'Ubermacht SC1', 25000, 'super'),
	('schafter2', 'Schafter V12', 18750, 'sports'),
	('schafter3', 'Schafter V12', 75000, 'sports'),
	('schafter4', 'Schafter V12 LWB', 81250, 'sports'),
	('schlagen', 'Benefactor Schlagen GT', 181250, 'sports'),
	('schwarzer', 'Benefactor Schwartzer', 25000, 'sports'),
	('seabreeze', 'Seabreeze', 1300000, 'avionfdp'),
	('seashark', 'Speedophile Seashark', 75000, 'superboat'),
	('seminole', 'Canis Seminole', 6750, 'suvs'),
	('seminole2', 'Canis Seminole', 17500, 'suvs'),
	('sentinel', 'Ubermacht Sentinel XS', 16250, 'coupes'),
	('sentinel2', 'Ubermacht Sentinel', 18750, 'coupes'),
	('sentinel3', 'Ubermacht Sentinel Classic', 5000, 'sports'),
	('serrano', 'Benefactor Serrano', 6250, 'suvs'),
	('seven70', 'Dewbauchee Seven-70', 16250, 'sports'),
	('sheava', 'Emperor ETR1', 91500, 'super'),
	('shinobi', 'Nagasaki Shinobi', 18750, 'motorcycles'),
	('slamvan', 'Vapid Slamvan', 18750, 'muscle'),
	('slamvan2', 'Vapid Slamvan', 26250, 'muscle'),
	('slamvan3', 'Vapid Slamvan Custom', 38750, 'muscle'),
	('specter', 'Dewbauchee Specter', 16250, 'sports'),
	('specter2', 'Specter Custom', 16250, 'sports'),
	('speeder', 'Pegassi Speeder', 275000, 'superboat'),
	('speedo', 'Vapid Speedo', 12500, 'vans'),
	('squaddie', 'Squaddie', 15000, 'suvs'),
	('squalo', 'Squalo', 175000, 'superboat'),
	('stafford', 'Enus Stafford', 62500, 'sedans'),
	('stalion', 'Declasse Stallion', 18750, 'muscle'),
	('stanier', 'Vapid Stanier', 8250, 'sedans'),
	('stinger', 'Grotti Stinger', 28000, 'sportsclassics'),
	('stingergt', 'Grotti Stinger GT', 60000, 'sportsclassics'),
	('stratum', 'Zirconium Stratum', 6250, 'sedans'),
	('streiter', 'Benefactor Streiter', 31250, 'sports'),
	('stretch', 'Dundreary Stretch', 75000, 'sedans'),
	('stryder', 'Nagasaki Stryder', 38750, 'motorcycles'),
	('sugoi', 'Dinka Sugoi', 62500, 'sports'),
	('sultan', 'Karin Sultan 1', 21250, 'sports'),
	('sultan2', 'Karin Sultan 2', 21250, 'sports'),
	('sultan3', 'Karin Sultan 3', 21250, 'sports'),
	('sultanrs', 'Karin Sultan RS', 57500, 'super'),
	('suntrap', 'Shitzu Squalo', 200000, 'superboat'),
	('superd', 'Enus Super Diamond', 75000, 'sedans'),
	('supervolito', 'Buckingham SuperVolito', 1500000, 'avionfdp'),
	('supervolito2', 'Buckingham SuperVolito Carbon', 1800000, 'avionfdp'),
	('surano', 'Benefactor Surano', 11750, 'sports'),
	('surfer', 'BF Surfer', 12500, 'vans'),
	('surge', 'Cheval Surge', 7500, 'sedans'),
	('swift', 'Buckingham Swift', 4000000, 'avionfdp'),
	('swift2', 'Buckingham Swift Deluxe', 4250000, 'avionfdp'),
	('swinger', 'Ocelot Swinger', 169500, 'sportsclassics'),
	('t20', 'Progen T20', 312500, 'super'),
	('tailgater', 'Obey Tailgater', 21250, 'sedans'),
	('tailgater2', 'Obey Tailgater S', 42250, 'sedans'),
	('taipan', 'Cheval Taipan', 202500, 'super'),
	('tampa', 'Declasse Tampa', 42500, 'muscle'),
	('tampa2', 'Declasse Tampa drift', 71250, 'sports'),
	('tempesta', 'Pegassi Tempesta', 335000, 'super'),
	('tezeract', 'Pegassi Tezeract', 775000, 'super'),
	('thrax', 'Truffade Thrax', 635000, 'super'),
	('thrust', 'Dinka Thrust', 18750, 'motorcycles'),
	('tigon', 'Lampadati Tigon', 87500, 'super'),
	('torero', 'Pegassi Torero', 62500, 'sportsclassics'),
	('tornado', 'Declasse Tornado', 10500, 'sportsclassics'),
	('toro', 'Lampadati Toro', 300000, 'superboat'),
	('toros', 'Pegassi Toros', 125000, 'suvs'),
	('trophytruck', 'Vapid Trophy Truck', 33250, 'offroad'),
	('trophytruck2', 'Vapid Trophy Truck', 33750, 'offroad'),
	('tropic', 'Tropic', 125000, 'superboat'),
	('tropos', 'Lampadati Tropos rallye', 31250, 'sports'),
	('tulip', 'Declasse Tulip', 34000, 'muscle'),
	('turismo2', 'Grotti Turismo Classic', 131000, 'sportsclassics'),
	('turismor', 'Grotti Turismo R', 62500, 'super'),
	('tyrant', 'Overflod Tyrant', 280000, 'super'),
	('tyrus', 'Progen Tyrus', 327500, 'super'),
	('vacca', 'Pegassi Vacca', 30500, 'super'),
	('vader', 'Shitzu Vader', 6250, 'motorcycles'),
	('vagner', 'Dewbauchee Vagner', 500000, 'super'),
	('vagrant', 'Maxwell Vagrant', 33750, 'offroad'),
	('vamos', 'Declasse Vamos', 8750, 'muscle'),
	('vectre', 'Emperor Vectre', 13750, 'sports'),
	('velum', 'JoBuilt Velum', 300000, 'avionfdp'),
	('verlierer2', 'Bravado Verlierer', 33750, 'sports'),
	('verus', 'Dinka Verus', 31250, 'offroad'),
	('vestra', 'Buckingham Vestra', 380000, 'avionfdp'),
	('vigero', 'Declasse Vigero', 12500, 'muscle'),
	('vindicator', 'Dinka Vindicator', 40000, 'motorcycles'),
	('virgo', 'Albany Virgo', 16000, 'muscle'),
	('virgo2', 'Albany Virgo Custom', 21000, 'muscle'),
	('virgo3', 'Albany Virgo Custom', 22500, 'muscle'),
	('visione', 'Grotti Visione', 775000, 'super'),
	('volatus', 'Buckingham Volatus', 3000000, 'avionfdp'),
	('voltic', 'Coil Voltic', 57750, 'super'),
	('voodoo', 'Declasse Voodoo custom', 12500, 'muscle'),
	('vortex', 'Pegassi Vortex', 45000, 'motorcycles'),
	('vstr', 'Albany V-STR', 225000, 'sports'),
	('warrener', 'Vulcar Warrener', 5500, 'sedans'),
	('washington', 'Albany Washington', 11250, 'sedans'),
	('weevil', 'BF Weevil', 21250, 'compacts'),
	('windsor', 'Enus Windsor', 125000, 'coupes'),
	('windsor2', 'Windsor Drop', 100000, 'coupes'),
	('winky', 'Vapid Winky', 62500, 'offroad'),
	('wolfsbane', 'Wolfsbane', 23750, 'motorcycles'),
	('xa21', 'Ocelot XA-21', 475000, 'super'),
	('xls', 'Benefactor XLS', 17500, 'suvs'),
	('yosemite', 'Declasse Yosemite', 11250, 'muscle'),
	('yosemite2', 'Declasse Drift Yosemite', 22500, 'muscle'),
	('yosemite3', 'Yosemite', 8750, 'muscle'),
	('youga', 'Bravado Youga', 18750, 'vans'),
	('youga2', 'Bravado Youga Classic', 21250, 'vans'),
	('youga3', 'Bravado Youga Classic 4x4', 25000, 'vans'),
	('youga4', 'Youga Custom', 17500, 'vans'),
	('z190', 'Karin 190z', 67500, 'sportsclassics'),
	('zeno', 'Overflod Zeno', 575000, 'super'),
	('zentorno', 'Pegassi Zentorno', 200000, 'super'),
	('zion', 'Ubermacht Zion', 15000, 'coupes'),
	('zion2', 'Ubermacht Zion', 15000, 'coupes'),
	('zion3', 'Ubermacht Zion Classic', 67500, 'sportsclassics'),
	('zombiea', 'Zombie', 25000, 'motorcycles'),
	('zombieb', 'Zombie Custom', 25000, 'motorcycles'),
	('zorrusso', 'Pegassi Zorrusso', 125000, 'super'),
	('zr350', 'Annis ZR350', 18750, 'sports'),
	('ztype', 'Truffade Z-Type ', 225000, 'sportsclassics');

-- Listage de la structure de table onelife. vehicletosell
CREATE TABLE IF NOT EXISTS `vehicletosell` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(50) DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `props` longtext DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=224 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.vehicletosell : ~0 rows (environ)
DELETE FROM `vehicletosell`;

-- Listage de la structure de table onelife. vehicle_categories
CREATE TABLE IF NOT EXISTS `vehicle_categories` (
  `name` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL,
  `society` varchar(50) NOT NULL DEFAULT 'carshop',
  PRIMARY KEY (`name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- Listage des données de la table onelife.vehicle_categories : ~14 rows (environ)
DELETE FROM `vehicle_categories`;
INSERT INTO `vehicle_categories` (`name`, `label`, `society`) VALUES
	('avionfdp', 'Avion - Hélico', 'planeshop'),
	('compacts', 'Compacts', 'carshop'),
	('coupes', 'Coupes', 'carshop'),
	('imports', 'Imports', 'carshop'),
	('motorcycles', 'Motos', 'carshop'),
	('muscle', 'Muscle', 'carshop'),
	('offroad', 'Off Road', 'carshop'),
	('sedans', 'Sedans', 'carshop'),
	('sports', 'Sports', 'carshop'),
	('sportsclassics', 'Sports Classics', 'carshop'),
	('super', 'Super', 'carshop'),
	('superboat', 'Bateau', 'boatshop'),
	('suvs', 'SUVs', 'carshop'),
	('vans', 'Vans', 'carshop');

-- Listage de la structure de table onelife. vip_players
CREATE TABLE IF NOT EXISTS `vip_players` (
  `identifier` varchar(255) DEFAULT NULL,
  `fivemID` varchar(255) NOT NULL,
  `expiration` timestamp NULL DEFAULT NULL,
  `buyDay` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Listage des données de la table onelife.vip_players : ~0 rows (environ)
DELETE FROM `vip_players`;

-- Listage de la structure de table onelife. wl_vda
CREATE TABLE IF NOT EXISTS `wl_vda` (
  `license` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`license`,`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table onelife.wl_vda : ~0 rows (environ)
DELETE FROM `wl_vda`;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
