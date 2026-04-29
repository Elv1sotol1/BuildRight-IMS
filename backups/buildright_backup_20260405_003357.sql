-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: buildright_db
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `action` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `table_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `record_id` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `old_values` json DEFAULT NULL,
  `new_values` json DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `idx_audit_user` (`user_id`),
  KEY `idx_audit_action` (`action`),
  KEY `idx_audit_table` (`table_name`),
  KEY `idx_audit_created` (`created_at`),
  CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES (1,NULL,'LOGIN','users','4',NULL,NULL,'127.0.0.1','2026-03-06 00:31:28'),(2,4,'LOGOUT','users','4',NULL,NULL,'127.0.0.1','2026-03-06 00:31:53'),(3,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-03-06 00:37:53'),(4,1,'TRANSACTION','transactions','BR-00001',NULL,'{\"type\": \"Outflow\", \"quantity\": 3, \"sub_type\": \"Sale\"}','127.0.0.1','2026-03-06 00:41:53'),(5,1,'TRANSACTION','transactions','BR-00002',NULL,'{\"type\": \"Outflow\", \"quantity\": 21, \"sub_type\": \"Sale\"}','127.0.0.1','2026-03-06 00:54:37'),(6,1,'CREATE_PO','purchase_orders','4',NULL,'{\"po_number\": \"PO-00004\"}','127.0.0.1','2026-03-06 00:57:47'),(7,1,'APPROVE_PO','purchase_orders','4',NULL,NULL,'127.0.0.1','2026-03-06 00:58:07'),(8,1,'APPROVE_PO','purchase_orders','3',NULL,NULL,'127.0.0.1','2026-03-06 01:00:52'),(9,1,'CREATE_PO','purchase_orders','5',NULL,'{\"po_number\": \"PO-00005\"}','127.0.0.1','2026-03-06 01:02:06'),(10,1,'APPROVE_PO','purchase_orders','5',NULL,NULL,'127.0.0.1','2026-03-06 01:02:14'),(11,1,'CREATE_PO','purchase_orders','6',NULL,'{\"po_number\": \"PO-00006\"}','127.0.0.1','2026-03-06 01:10:03'),(12,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-03-31 12:36:43'),(13,1,'UPDATE_ITEM','inventory_items','BR-00001','{\"name\": \"Bamburi Cement 50kg\", \"status\": \"Active\"}','{\"name\": \"Bamburi Cement 50kg\", \"status\": \"Active\"}','127.0.0.1','2026-03-31 12:52:16'),(14,1,'UPDATE_ITEM','inventory_items','BR-00002','{\"name\": \"Steel Hammer\", \"status\": \"Active\"}','{\"name\": \"Steel Hammer\", \"status\": \"Active\"}','127.0.0.1','2026-03-31 12:53:31'),(15,1,'UPDATE_ITEM','inventory_items','BR-00003','{\"name\": \"Safety Helmet\", \"status\": \"Active\"}','{\"name\": \"Safety Helmet\", \"status\": \"Active\"}','127.0.0.1','2026-03-31 12:55:11'),(16,1,'UPDATE_ITEM','inventory_items','BR-00004','{\"name\": \"Wire Nails 4 inch\", \"status\": \"Active\"}','{\"name\": \"Wire Nails 4 inch\", \"status\": \"Active\"}','127.0.0.1','2026-03-31 12:56:10'),(17,1,'UPDATE_ITEM','inventory_items','BR-00005','{\"name\": \"Electrical Cable 2.5mm\", \"status\": \"Active\"}','{\"name\": \"Electrical Cable 2.5mm\", \"status\": \"Active\"}','127.0.0.1','2026-03-31 12:58:11'),(18,1,'APPROVE_PO','purchase_orders','6',NULL,NULL,'127.0.0.1','2026-03-31 13:04:57'),(19,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-03-31 14:26:05'),(20,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-03-31 15:09:38'),(21,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-03-31 17:00:24'),(22,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-03-31 21:34:34'),(23,1,'CREATE_ITEM','inventory_items','BR-00006',NULL,'{\"name\": \"Gloves\"}','127.0.0.1','2026-03-31 21:40:49'),(24,1,'CREATE_PO','purchase_orders','7',NULL,'{\"po_number\": \"PO-00007\"}','127.0.0.1','2026-03-31 21:46:13'),(25,1,'APPROVE_PO','purchase_orders','7',NULL,NULL,'127.0.0.1','2026-03-31 21:46:53'),(26,1,'CREATE_PO','purchase_orders','8',NULL,'{\"po_number\": \"PO-00008\"}','127.0.0.1','2026-03-31 21:51:18'),(27,1,'APPROVE_PO','purchase_orders','8',NULL,NULL,'127.0.0.1','2026-03-31 21:51:21'),(28,1,'CREATE_PO','purchase_orders','9',NULL,'{\"po_number\": \"PO-00009\"}','127.0.0.1','2026-03-31 21:51:55'),(29,1,'APPROVE_PO','purchase_orders','9',NULL,NULL,'127.0.0.1','2026-03-31 21:52:02'),(30,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-03-31 23:12:01'),(31,1,'TRANSACTION','transactions','BR-00004',NULL,'{\"type\": \"Outflow\", \"quantity\": 40, \"sub_type\": \"Sale\"}','127.0.0.1','2026-03-31 23:13:41'),(32,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-04-01 18:25:34'),(33,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-04-01 20:42:10'),(34,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-04-03 12:41:16'),(35,1,'CREATE_PO','purchase_orders','10',NULL,'{\"po_number\": \"PO-00010\"}','127.0.0.1','2026-04-03 13:38:13'),(36,1,'APPROVE_PO','purchase_orders','10',NULL,NULL,'127.0.0.1','2026-04-03 13:39:04'),(37,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-04-03 14:27:27'),(38,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-04-03 14:55:09'),(39,1,'LOGOUT','users','1',NULL,NULL,'127.0.0.1','2026-04-03 14:55:27'),(40,NULL,'LOGIN','users','3',NULL,NULL,'127.0.0.1','2026-04-03 14:55:44'),(41,3,'REQUEST_ADJUSTMENT','stock_adjustments','1',NULL,'{\"type\": \"Increase\", \"item_id\": \"BR-00001\", \"quantity\": 2}','127.0.0.1','2026-04-03 14:57:55'),(42,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-04-03 14:58:07'),(43,1,'APPROVE_ADJUSTMENT','stock_adjustments','1',NULL,NULL,'127.0.0.1','2026-04-03 14:58:29'),(44,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-04-03 18:24:19'),(45,1,'CREATE_USER','users','5',NULL,'{\"role\": \"Staff\", \"username\": \"staff1\"}','127.0.0.1','2026-04-03 18:47:39'),(46,NULL,'LOGIN','users','5',NULL,NULL,'127.0.0.1','2026-04-03 18:48:00'),(47,5,'LOGOUT','users','5',NULL,NULL,'127.0.0.1','2026-04-03 18:48:22'),(48,NULL,'LOGIN','users','5',NULL,NULL,'127.0.0.1','2026-04-03 18:48:52'),(49,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-04-03 19:04:22'),(50,1,'RECEIVE_PO','purchase_orders','10',NULL,'{\"status\": \"Received\"}','127.0.0.1','2026-04-03 19:05:00'),(51,1,'RECEIVE_PO','purchase_orders','3',NULL,'{\"status\": \"Received\"}','127.0.0.1','2026-04-03 19:05:27'),(52,1,'RECEIVE_PO','purchase_orders','9',NULL,'{\"status\": \"Received\"}','127.0.0.1','2026-04-03 19:05:38'),(53,1,'RECEIVE_PO','purchase_orders','8',NULL,'{\"status\": \"Received\"}','127.0.0.1','2026-04-03 19:05:47'),(54,1,'RECEIVE_PO','purchase_orders','2',NULL,'{\"status\": \"Received\"}','127.0.0.1','2026-04-03 19:05:57'),(55,1,'RECEIVE_PO','purchase_orders','4',NULL,'{\"status\": \"Received\"}','127.0.0.1','2026-04-03 19:06:07'),(56,1,'RECEIVE_PO','purchase_orders','5',NULL,'{\"status\": \"Received\"}','127.0.0.1','2026-04-03 19:06:15'),(57,1,'RECEIVE_PO','purchase_orders','6',NULL,'{\"status\": \"Received\"}','127.0.0.1','2026-04-03 19:06:27'),(58,1,'RECEIVE_PO','purchase_orders','7',NULL,'{\"status\": \"Received\"}','127.0.0.1','2026-04-03 19:06:38'),(59,1,'CREATE_PO','purchase_orders','11',NULL,'{\"po_number\": \"PO-00011\"}','127.0.0.1','2026-04-03 19:07:54'),(60,1,'APPROVE_PO','purchase_orders','11',NULL,NULL,'127.0.0.1','2026-04-03 19:07:56'),(61,1,'RECEIVE_PO','purchase_orders','11',NULL,'{\"status\": \"Received\"}','127.0.0.1','2026-04-03 19:08:08'),(62,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-04-03 19:41:37'),(63,NULL,'LOGIN','users','3',NULL,NULL,'127.0.0.1','2026-04-03 20:35:54'),(64,3,'TRANSACTION','transactions','BR-00004',NULL,'{\"type\": \"Outflow\", \"quantity\": 5, \"sub_type\": \"Loan\"}','127.0.0.1','2026-04-03 20:39:14'),(65,3,'TRANSACTION','transactions','BR-00006',NULL,'{\"type\": \"Outflow\", \"quantity\": 77, \"sub_type\": \"Sale\"}','127.0.0.1','2026-04-03 20:41:57'),(66,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-04-03 20:46:34'),(67,1,'CREATE_PO','purchase_orders','12',NULL,'{\"po_number\": \"PO-00012\"}','127.0.0.1','2026-04-03 20:47:27'),(68,1,'APPROVE_PO','purchase_orders','12',NULL,NULL,'127.0.0.1','2026-04-03 20:51:45'),(69,1,'RECEIVE_PO','purchase_orders','12',NULL,'{\"status\": \"Partially Received\"}','127.0.0.1','2026-04-03 20:52:19'),(70,1,'CREATE_PO','purchase_orders','13',NULL,'{\"po_number\": \"PO-00013\"}','127.0.0.1','2026-04-03 20:54:18'),(71,1,'CREATE_PO','purchase_orders','14',NULL,'{\"po_number\": \"PO-00014\"}','127.0.0.1','2026-04-03 20:55:08'),(72,1,'REJECT_PO','purchase_orders','14',NULL,NULL,'127.0.0.1','2026-04-03 20:58:12'),(73,1,'CREATE_PO','purchase_orders','15',NULL,'{\"po_number\": \"PO-00015\"}','127.0.0.1','2026-04-03 20:58:59'),(74,1,'APPROVE_PO','purchase_orders','15',NULL,NULL,'127.0.0.1','2026-04-03 20:59:03'),(75,1,'TRANSACTION','transactions','BR-00001',NULL,'{\"type\": \"Outflow\", \"quantity\": 46, \"sub_type\": \"Loan\"}','127.0.0.1','2026-04-03 21:01:18'),(76,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-04-04 11:42:15'),(77,NULL,'LOGIN','users','3',NULL,NULL,'127.0.0.1','2026-04-04 11:49:45'),(78,1,'CREATE_SUPPLIER','suppliers','4',NULL,'{\"name\": \"Roofing Mabati\"}','127.0.0.1','2026-04-04 12:00:23'),(79,1,'CREATE_SUPPLIER','suppliers','5',NULL,'{\"name\": \"Mutua Mbao Limited\"}','127.0.0.1','2026-04-04 12:02:07'),(80,1,'CREATE_SUPPLIER','suppliers','6',NULL,'{\"name\": \"Lenah Wires Limited\"}','127.0.0.1','2026-04-04 12:04:46'),(81,1,'CREATE_ITEM','inventory_items','BR-00007',NULL,'{\"name\": \"Polishers\"}','127.0.0.1','2026-04-04 12:17:17'),(82,1,'CREATE_ITEM','inventory_items','BR-00008',NULL,'{\"name\": \"Polishers\"}','127.0.0.1','2026-04-04 12:19:02'),(83,1,'CREATE_ITEM','inventory_items','BR-00009',NULL,'{\"name\": \"Torpedo Level\"}','127.0.0.1','2026-04-04 12:20:47'),(84,1,'CREATE_ITEM','inventory_items','BR-00010',NULL,'{\"name\": \"Crow Bar\"}','127.0.0.1','2026-04-04 12:22:24'),(85,1,'CREATE_ITEM','inventory_items','BR-00011',NULL,'{\"name\": \"framing square\"}','127.0.0.1','2026-04-04 12:23:59'),(86,1,'CREATE_ITEM','inventory_items','BR-00012',NULL,'{\"name\": \"Line Level\"}','127.0.0.1','2026-04-04 12:30:37'),(87,1,'CREATE_ITEM','inventory_items','BR-00013',NULL,'{\"name\": \"Head Pan\"}','127.0.0.1','2026-04-04 12:31:58'),(88,1,'CREATE_ITEM','inventory_items','BR-00014',NULL,'{\"name\": \"wheelbarrow\"}','127.0.0.1','2026-04-04 12:34:41'),(89,1,'CREATE_ITEM','inventory_items','BR-00015',NULL,'{\"name\": \"Plumb Bob\"}','127.0.0.1','2026-04-04 12:36:13'),(90,1,'CREATE_ITEM','inventory_items','BR-00016',NULL,'{\"name\": \"Wooden float\"}','127.0.0.1','2026-04-04 12:37:22'),(91,1,'CREATE_ITEM','inventory_items','BR-00017',NULL,'{\"name\": \"concrete mixer\"}','127.0.0.1','2026-04-04 12:40:54'),(92,1,'CREATE_ITEM','inventory_items','BR-00018',NULL,'{\"name\": \"Trowel\"}','127.0.0.1','2026-04-04 12:42:25'),(93,1,'CREATE_ITEM','inventory_items','BR-00019',NULL,'{\"name\": \"Measuring tapes\"}','127.0.0.1','2026-04-04 12:44:01'),(94,1,'CREATE_ITEM','inventory_items','BR-00020',NULL,'{\"name\": \"Rubber gumboots\"}','127.0.0.1','2026-04-04 12:45:29'),(95,1,'CREATE_SUPPLIER','suppliers','7',NULL,'{\"name\": \"Muthokinju Suppliers\"}','127.0.0.1','2026-04-04 12:47:18'),(96,1,'CREATE_ITEM','inventory_items','BR-00021',NULL,'{\"name\": \"Self closing Faucet\"}','127.0.0.1','2026-04-04 12:50:11'),(97,1,'CREATE_ITEM','inventory_items','BR-00022',NULL,'{\"name\": \"Ordinary Tap\"}','127.0.0.1','2026-04-04 12:51:38'),(98,1,'CREATE_ITEM','inventory_items','BR-00023',NULL,'{\"name\": \"Swan Neck Tap\"}','127.0.0.1','2026-04-04 12:53:21'),(99,1,'CREATE_ITEM','inventory_items','BR-00024',NULL,'{\"name\": \"Plunger\"}','127.0.0.1','2026-04-04 12:54:55'),(100,1,'CREATE_ITEM','inventory_items','BR-00025',NULL,'{\"name\": \"Plumbing pipes\"}','127.0.0.1','2026-04-04 12:56:47'),(101,1,'CREATE_ITEM','inventory_items','BR-00026',NULL,'{\"name\": \"Mabati\"}','127.0.0.1','2026-04-04 12:59:08'),(102,1,'CREATE_ITEM','inventory_items','BR-00027',NULL,'{\"name\": \"Crow Paints\"}','127.0.0.1','2026-04-04 13:02:42'),(103,NULL,'LOGIN','users','3',NULL,NULL,'127.0.0.1','2026-04-04 13:03:24'),(104,3,'LOGOUT','users','3',NULL,NULL,'127.0.0.1','2026-04-04 13:04:25'),(105,NULL,'LOGIN','users','3',NULL,NULL,'127.0.0.1','2026-04-04 13:05:34'),(106,1,'TRANSACTION','transactions','BR-00001',NULL,'{\"type\": \"Outflow\", \"quantity\": 3, \"sub_type\": \"Sale\"}','127.0.0.1','2026-04-04 13:07:51'),(107,NULL,'LOGIN','users','4',NULL,NULL,'127.0.0.1','2026-04-04 13:40:46'),(108,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-04-05 00:04:55'),(109,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-04-05 00:22:07'),(110,1,'CREATE_PO','purchase_orders','16',NULL,'{\"po_number\": \"PO-00016\"}','127.0.0.1','2026-04-05 00:29:47'),(111,1,'APPROVE_PO','purchase_orders','16',NULL,NULL,'127.0.0.1','2026-04-05 00:29:50'),(112,1,'RECEIVE_PO','purchase_orders','15',NULL,'{\"status\": \"Received\"}','127.0.0.1','2026-04-05 00:30:17'),(113,1,'RECEIVE_PO','purchase_orders','16',NULL,'{\"status\": \"Received\"}','127.0.0.1','2026-04-05 00:30:39'),(114,1,'CREATE_USER','users','6',NULL,'{\"role\": \"Staff\", \"username\": \"Roy\"}','127.0.0.1','2026-04-05 00:31:52'),(115,1,'CREATE_USER','users','7',NULL,'{\"role\": \"Staff\", \"username\": \"Neema\"}','127.0.0.1','2026-04-05 00:32:43'),(116,1,'CREATE_SITE','sites','4',NULL,'{\"name\": \"Bee Center Warehouse\"}','127.0.0.1','2026-04-05 00:33:33');
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `backups`
--

DROP TABLE IF EXISTS `backups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `backups` (
  `backup_id` int NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_size_bytes` bigint DEFAULT NULL,
  `backup_type` enum('Manual','Scheduled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Manual',
  `status` enum('Completed','Failed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Completed',
  `performed_by` int DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`backup_id`),
  KEY `performed_by` (`performed_by`),
  CONSTRAINT `backups_ibfk_1` FOREIGN KEY (`performed_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `backups`
--

LOCK TABLES `backups` WRITE;
/*!40000 ALTER TABLE `backups` DISABLE KEYS */;
INSERT INTO `backups` VALUES (1,'buildright_backup_20260223_171047.sql',17776,'Manual','Completed',1,'2026-02-23 17:10:48');
/*!40000 ALTER TABLE `backups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Cement & Concrete','Binding materials and concrete products','2026-03-05 23:41:58'),(2,'Hand Tools','Manual tools for construction work','2026-03-05 23:41:58'),(3,'Safety Equipment','PPE and site safety gear','2026-03-05 23:41:58'),(4,'Electrical','Wiring, cables and electrical components','2026-03-05 23:41:58'),(5,'Plumbing','Pipes, fittings and plumbing materials','2026-03-05 23:41:58'),(6,'Roofing','Roofing materials to houses','2026-04-04 12:06:21'),(7,'Paint & Colour','Different painting materials to design house as intended','2026-04-04 12:07:37');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_items`
--

DROP TABLE IF EXISTS `inventory_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_items` (
  `item_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `category_id` int NOT NULL,
  `unit_of_measure` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unit_cost` decimal(12,2) NOT NULL DEFAULT '0.00',
  `current_stock` int NOT NULL DEFAULT '0',
  `reorder_level` int NOT NULL DEFAULT '0',
  `supplier_id` int DEFAULT NULL,
  `status` enum('Active','Discontinued','Out of Stock') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Active',
  `image_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_by` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `site_id` int DEFAULT NULL,
  PRIMARY KEY (`item_id`),
  KEY `supplier_id` (`supplier_id`),
  KEY `created_by` (`created_by`),
  KEY `idx_item_name` (`name`),
  KEY `idx_item_category` (`category_id`),
  KEY `idx_item_status` (`status`),
  KEY `fk_item_site` (`site_id`),
  CONSTRAINT `fk_item_site` FOREIGN KEY (`site_id`) REFERENCES `sites` (`site_id`) ON DELETE SET NULL,
  CONSTRAINT `inventory_items_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`),
  CONSTRAINT `inventory_items_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`) ON DELETE SET NULL,
  CONSTRAINT `inventory_items_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `chk_cost_non_negative` CHECK ((`unit_cost` >= 0)),
  CONSTRAINT `chk_reorder_non_negative` CHECK ((`reorder_level` >= 0)),
  CONSTRAINT `chk_stock_non_negative` CHECK ((`current_stock` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_items`
--

LOCK TABLES `inventory_items` WRITE;
/*!40000 ALTER TABLE `inventory_items` DISABLE KEYS */;
INSERT INTO `inventory_items` VALUES ('BR-00001','Bamburi Cement 50kg','Portland cement bag',1,'Bag',850.00,84,20,1,'Active','193167ba99ad4f469a8103e4b82b6573.jpg',1,'2026-03-05 23:41:58','2026-04-05 00:30:17',1),('BR-00002','Steel Hammer','Heavy duty 500g hammer',2,'Piece',650.00,99,10,2,'Active','a0848b3e4e03434f87915edcd83cbd77.jpg',1,'2026-03-05 23:41:58','2026-04-03 19:06:15',2),('BR-00003','Safety Helmet','Hard hat yellow',3,'Piece',1200.00,73,15,3,'Active','75461be6e28d438298e5699f286f3afd.jpg',1,'2026-03-05 23:41:58','2026-04-03 19:06:27',2),('BR-00004','Wire Nails 4 inch','Box of 500 nails',2,'Box',320.00,15,20,2,'Active','feab456a0acf49daad5b0ff47351b3ec.webp',1,'2026-03-05 23:41:58','2026-04-03 20:39:14',3),('BR-00005','Electrical Cable 2.5mm','100m roll twin and earth',4,'Roll',4500.00,2,10,2,'Active','170d826a0471488d9a52b53e7d4daa98.jpg',1,'2026-03-05 23:41:58','2026-03-31 12:58:11',1),('BR-00006','Gloves','Hand Gloves',3,'pcs',650.00,24,15,3,'Active','ab7e5c7a785845058bb33549fc90cced.jpg',1,'2026-03-31 21:40:49','2026-04-03 20:52:19',NULL),('BR-00007','Polishers','mainly in use for smoothening wood or marble flooring surfaces.',2,'pcs',2500.00,24,10,2,'Active','056076e565514acb979fea1e0389aeb7.webp',1,'2026-04-04 12:17:17','2026-04-04 12:17:17',NULL),('BR-00008','Polishers','Wearing safety glasses are used for safety purposes to protect the eyes',3,'pcs',399.00,17,15,3,'Active','dc6098dfe26c436683ab5bb19f2e6009.webp',1,'2026-04-04 12:19:02','2026-04-04 12:19:02',NULL),('BR-00009','Torpedo Level','Torpedo Level is one of the types of spirit levels that combines framing square and line levels.. The tubes or vials mainly hold yellowish-green additives, and they are used to define the surface level.',2,'pcs',499.00,14,5,2,'Discontinued','2772d1c86edd4c05aeb5bfdd00b2c8c0.webp',1,'2026-04-04 12:20:47','2026-04-04 12:20:47',NULL),('BR-00010','Crow Bar','A crowbar construction tool is a single metal bar curved at one end used in formwork to remove nails from boards or force apart two objects.',2,'pcs',799.00,0,10,2,'Out of Stock','45b67bfdad564a279534ae3fed14ea6c.webp',1,'2026-04-04 12:22:24','2026-04-04 12:22:24',NULL),('BR-00011','framing square','That framing square tool is used in plastering work, Brickwork for checking the right angle',2,'pcs',350.00,14,10,2,'Active','e039df5b625b425680974d1383dc2380.webp',1,'2026-04-04 12:23:59','2026-04-04 12:23:59',NULL),('BR-00012','Line Level','Line Level is one of the smaller construction tools used for checking straight horizontal levels',2,'pcs',300.00,40,10,2,'Discontinued','b5b7c8a01fbb48118229846ebb664908.webp',1,'2026-04-04 12:30:37','2026-04-04 12:30:37',NULL),('BR-00013','Head Pan','A Head Pan is used to transport materials like excavated soil, cement, concrete, etc., from one place to another at a working site',2,'pcs',200.00,23,20,1,'Active','c7487169822f46c685008145d6069c57.webp',1,'2026-04-04 12:31:58','2026-04-04 12:31:58',NULL),('BR-00014','wheelbarrow','A wheelbarrow acts as a carrier, typically having only one wheel, consisting of a plate bolted to two handles & two legs.',2,'pcs',599.00,25,15,1,'Active','68160bcae846426482be7162a511a204.webp',1,'2026-04-04 12:34:41','2026-04-04 12:34:41',NULL),('BR-00015','Plumb Bob','It is used as a plumb line, the standard vertical reference line, and one precursor to the spirit level',5,'pcs',298.00,0,5,5,'Out of Stock','5fc5ba79920447bc996d464ba063ff00.jpg',1,'2026-04-04 12:36:13','2026-04-04 12:36:13',NULL),('BR-00016','Wooden float','Wooden float construction tools are used to provide a smooth finish to the plastered surface, a wooden float tool is used',2,'pcs',345.00,35,0,5,'Discontinued','027eb987d133479e8ec08b1900d66501.webp',1,'2026-04-04 12:37:22','2026-04-04 12:37:22',NULL),('BR-00017','concrete mixer','A concrete mixer, frequently termed a cement mixer, is a machine that homogeneously mixes all the concrete ingredients together',1,'pcs',15000.00,3,5,1,'Active','f208269d7e954a6f82e5f24cdf78d42d.webp',1,'2026-04-04 12:40:54','2026-04-04 12:40:54',NULL),('BR-00018','Trowel','A hand tool utilized for smoothing, digging, applying, or moving mortar or concrete is a trowel',2,'pcs',150.00,12,10,2,'Active','4b0a25f6303843809dfeaa2de9d1d0a0.webp',1,'2026-04-04 12:42:25','2026-04-04 12:42:25',NULL),('BR-00019','Measuring tapes','Measuring tapes are utilized to measure distance, either short or long',2,'pcs',255.00,0,10,2,'Out of Stock','0f8db29cefaf42d4b4cf6e5f6f52f22d.jpg',1,'2026-04-04 12:44:01','2026-04-04 12:44:01',NULL),('BR-00020','Rubber gumboots','Rubber Boots are self-protecting equipment for employers to prevent their skin from chemical or any hazardous contact.',3,'pcs',199.00,20,12,3,'Active','79e23eb19e304a189d7e066520d54db3.jpg',1,'2026-04-04 12:45:29','2026-04-04 12:45:29',NULL),('BR-00021','Self closing Faucet','Self Closing Tap',5,'pcs',299.00,14,14,7,'Active','45416067b37d49768245d21612d475fb.jpg',1,'2026-04-04 12:50:11','2026-04-04 12:50:11',NULL),('BR-00022','Ordinary Tap','A plumbing device designed to regulate and control the flow of liquid',5,'pcs',129.00,20,10,7,'Active','e66fcac9f918415998f849785aa2b79d.jpg',1,'2026-04-04 12:51:38','2026-04-04 12:51:38',NULL),('BR-00023','Swan Neck Tap','type of water faucet characterized by a high, curved spout that resembles the neck of a swan.',5,'pcs',599.00,0,7,7,'Out of Stock','d1157efd9ec946ff800ae102dc4db899.jpg',1,'2026-04-04 12:53:21','2026-04-04 12:53:21',NULL),('BR-00024','Plunger','a common household tool used to clear clogged drains and pipes, consisting of a rubber suction cup on a handle that creates pressure to dislodge blockages',5,'pcs',99.00,15,10,7,'Active','db2b3d01b6d342cf8b3d98124de58ce5.jpg',1,'2026-04-04 12:54:54','2026-04-04 12:54:54',NULL),('BR-00025','Plumbing pipes','specialized tubes used to transport potable water, remove waste, and manage gas in buildings',5,'pcs',199.00,39,29,7,'Active','cd8f34d1827c46c2bc1ee8aafc0d9d02.jpg',1,'2026-04-04 12:56:47','2026-04-04 12:56:47',NULL),('BR-00026','Mabati','Corrugated iron sheeting, used as a building material for houses',6,'pcs',999.99,0,10,4,'Active','c02f9183f03d46c8993df71708c29a2f.webp',1,'2026-04-04 12:59:08','2026-04-04 12:59:08',NULL),('BR-00027','Crow Paints','',7,'pcs',699.00,15,10,7,'Active','784e022a9e684016bbf9e75affc4eebc.jpg',1,'2026-04-04 13:02:42','2026-04-05 00:30:39',NULL);
/*!40000 ALTER TABLE `inventory_items` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_auto_item_status` AFTER UPDATE ON `inventory_items` FOR EACH ROW BEGIN
    IF NEW.current_stock = 0 AND NEW.status = 'Active' THEN
        UPDATE inventory_items SET status = 'Out of Stock' WHERE item_id = NEW.item_id;
    END IF;
    IF NEW.current_stock > 0 AND OLD.status = 'Out of Stock' THEN
        UPDATE inventory_items SET status = 'Active' WHERE item_id = NEW.item_id;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `token_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expires_at` datetime NOT NULL,
  `used` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`token_id`),
  UNIQUE KEY `token` (`token`),
  KEY `user_id` (`user_id`),
  KEY `idx_token` (`token`),
  CONSTRAINT `password_reset_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `po_items`
--

DROP TABLE IF EXISTS `po_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `po_items` (
  `po_item_id` int NOT NULL AUTO_INCREMENT,
  `po_id` int NOT NULL,
  `item_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity_ordered` int NOT NULL,
  `quantity_received` int DEFAULT '0',
  `unit_cost` decimal(10,2) NOT NULL,
  `total_cost` decimal(12,2) GENERATED ALWAYS AS ((`quantity_ordered` * `unit_cost`)) STORED,
  PRIMARY KEY (`po_item_id`),
  KEY `po_id` (`po_id`),
  KEY `item_id` (`item_id`),
  CONSTRAINT `po_items_ibfk_1` FOREIGN KEY (`po_id`) REFERENCES `purchase_orders` (`po_id`) ON DELETE CASCADE,
  CONSTRAINT `po_items_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `po_items`
--

LOCK TABLES `po_items` WRITE;
/*!40000 ALTER TABLE `po_items` DISABLE KEYS */;
INSERT INTO `po_items` (`po_item_id`, `po_id`, `item_id`, `quantity_ordered`, `quantity_received`, `unit_cost`) VALUES (1,1,'BR-00001',100,100,850.00),(2,2,'BR-00003',20,20,1200.00),(3,3,'BR-00002',20,20,650.00),(4,3,'BR-00004',10,10,320.00),(5,4,'BR-00001',50,50,850.00),(6,5,'BR-00002',50,50,650.00),(7,6,'BR-00003',30,30,1200.00),(8,7,'BR-00001',50,50,850.00),(9,8,'BR-00002',20,20,650.00),(10,9,'BR-00006',20,20,650.00),(11,10,'BR-00003',20,20,1200.00),(12,11,'BR-00006',7,7,650.00),(13,12,'BR-00006',30,20,650.00),(14,13,'BR-00005',30,0,4500.00),(15,13,'BR-00004',30,0,320.00),(16,14,'BR-00003',22,0,1200.00),(17,14,'BR-00002',12,0,650.00),(18,14,'BR-00004',36,0,320.00),(19,15,'BR-00001',29,29,850.00),(20,16,'BR-00027',3,3,699.00);
/*!40000 ALTER TABLE `po_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase_orders`
--

DROP TABLE IF EXISTS `purchase_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_orders` (
  `po_id` int NOT NULL AUTO_INCREMENT,
  `po_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `supplier_id` int NOT NULL,
  `site_id` int DEFAULT NULL,
  `status` enum('Draft','Pending Approval','Approved','Partially Received','Received','Cancelled') COLLATE utf8mb4_unicode_ci DEFAULT 'Draft',
  `requested_by` int NOT NULL,
  `approved_by` int DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `expected_date` date DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `total_amount` decimal(15,2) DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`po_id`),
  UNIQUE KEY `po_number` (`po_number`),
  KEY `supplier_id` (`supplier_id`),
  KEY `requested_by` (`requested_by`),
  KEY `approved_by` (`approved_by`),
  KEY `site_id` (`site_id`),
  CONSTRAINT `purchase_orders_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`),
  CONSTRAINT `purchase_orders_ibfk_2` FOREIGN KEY (`requested_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `purchase_orders_ibfk_3` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `purchase_orders_ibfk_4` FOREIGN KEY (`site_id`) REFERENCES `sites` (`site_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_orders`
--

LOCK TABLES `purchase_orders` WRITE;
/*!40000 ALTER TABLE `purchase_orders` DISABLE KEYS */;
INSERT INTO `purchase_orders` VALUES (1,'PO-00001',1,1,'Received',1,1,'2026-01-10 06:00:00','2026-01-14','Urgent cement order for Westlands',85000.00,'2026-03-05 20:41:58','2026-03-05 20:41:58'),(2,'PO-00002',3,2,'Received',1,1,'2026-02-20 07:30:00','2026-03-05','Safety gear for Karen site',24000.00,'2026-03-05 20:41:58','2026-04-03 16:05:57'),(3,'PO-00003',2,3,'Received',1,1,'2026-03-05 22:00:52','2026-03-10','Tools restock for warehouse',16000.00,'2026-03-05 20:41:58','2026-04-03 16:05:27'),(4,'PO-00004',1,2,'Received',1,1,'2026-03-05 21:58:07','2026-03-06','Test PO Email',42500.00,'2026-03-05 21:57:47','2026-04-03 16:06:07'),(5,'PO-00005',2,3,'Received',1,1,'2026-03-05 22:02:14','2026-03-08','Test 2 for Approval',32500.00,'2026-03-05 22:02:06','2026-04-03 16:06:15'),(6,'PO-00006',3,3,'Received',1,1,'2026-03-31 10:04:57','2026-03-11','LOW STOCK',36000.00,'2026-03-05 22:10:03','2026-04-03 16:06:27'),(7,'PO-00007',1,3,'Received',1,1,'2026-03-31 18:46:53','2026-04-02','N/A',42500.00,'2026-03-31 18:46:13','2026-04-03 16:06:38'),(8,'PO-00008',2,1,'Received',1,1,'2026-03-31 18:51:21','2026-04-04','N/A',13000.00,'2026-03-31 18:51:18','2026-04-03 16:05:47'),(9,'PO-00009',3,2,'Received',1,1,'2026-03-31 18:52:02','2026-04-11','N/A',13000.00,'2026-03-31 18:51:55','2026-04-03 16:05:38'),(10,'PO-00010',2,2,'Received',1,1,'2026-04-03 10:39:04','2026-05-09',NULL,24000.00,'2026-04-03 10:38:13','2026-04-03 16:05:00'),(11,'PO-00011',2,1,'Received',1,1,'2026-04-03 16:07:56','2026-05-07','Upon call deliver to Specified Location',4550.00,'2026-04-03 16:07:54','2026-04-03 16:08:08'),(12,'PO-00012',3,2,'Partially Received',1,1,'2026-04-03 17:51:45','2026-04-10','Replacing the low gloves count',19500.00,'2026-04-03 17:47:27','2026-04-03 17:52:19'),(13,'PO-00013',2,1,'Pending Approval',1,NULL,NULL,'2026-04-30','N/A',144600.00,'2026-04-03 17:54:18','2026-04-03 17:54:18'),(14,'PO-00014',2,3,'Cancelled',1,NULL,NULL,'2026-04-10',NULL,45720.00,'2026-04-03 17:55:08','2026-04-03 17:58:12'),(15,'PO-00015',1,2,'Received',1,1,'2026-04-03 17:59:03','2026-04-10',NULL,24650.00,'2026-04-03 17:58:59','2026-04-04 21:30:17'),(16,'PO-00016',7,1,'Received',1,1,'2026-04-04 21:29:50','2026-04-05',NULL,2097.00,'2026-04-04 21:29:47','2026-04-04 21:30:39');
/*!40000 ALTER TABLE `purchase_orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sites`
--

DROP TABLE IF EXISTS `sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sites` (
  `site_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('Active','Inactive') COLLATE utf8mb4_unicode_ci DEFAULT 'Active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`site_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sites`
--

LOCK TABLES `sites` WRITE;
/*!40000 ALTER TABLE `sites` DISABLE KEYS */;
INSERT INTO `sites` VALUES (1,'Westlands Office Tower','Westlands, Nairobi','Active','2026-03-05 20:41:58'),(2,'Karen Residential Project','Karen, Nairobi','Active','2026-03-05 20:41:58'),(3,'Mombasa Road Warehouse','Industrial Area, Nairobi','Active','2026-03-05 20:41:58'),(4,'Bee Center Warehouse','Bee Center, Nairobi','Active','2026-04-04 21:33:33');
/*!40000 ALTER TABLE `sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_adjustments`
--

DROP TABLE IF EXISTS `stock_adjustments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_adjustments` (
  `adjustment_id` int NOT NULL AUTO_INCREMENT,
  `item_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `adjustment_type` enum('Increase','Decrease') COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int NOT NULL,
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `status` enum('Pending','Approved','Rejected') COLLATE utf8mb4_unicode_ci DEFAULT 'Pending',
  `requested_by` int NOT NULL,
  `approved_by` int DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`adjustment_id`),
  KEY `item_id` (`item_id`),
  KEY `requested_by` (`requested_by`),
  KEY `approved_by` (`approved_by`),
  CONSTRAINT `stock_adjustments_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`item_id`),
  CONSTRAINT `stock_adjustments_ibfk_2` FOREIGN KEY (`requested_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `stock_adjustments_ibfk_3` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_adjustments`
--

LOCK TABLES `stock_adjustments` WRITE;
/*!40000 ALTER TABLE `stock_adjustments` DISABLE KEYS */;
INSERT INTO `stock_adjustments` VALUES (1,'BR-00001','Increase',2,'Physical Count Error','N/A','Approved',3,1,'2026-04-03 11:58:29','2026-04-03 11:57:55');
/*!40000 ALTER TABLE `stock_adjustments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `suppliers` (
  `supplier_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_person` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`supplier_id`),
  KEY `idx_supplier_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
INSERT INTO `suppliers` VALUES (1,'Bamburi Cement Ltd','John Kamau','0722000001','sales@bamburi.co.ke','Mombasa Road, Nairobi','2026-03-05 23:41:58','2026-03-05 23:41:58'),(2,'Hardware Palace','Mary Njeri','0733000002','orders@hardwarepalace.co.ke','River Road, Nairobi','2026-03-05 23:41:58','2026-03-05 23:41:58'),(3,'SafetyFirst Kenya','Peter Otieno','0711000003','info@safetyfirst.co.ke','Industrial Area, Nairobi','2026-03-05 23:41:58','2026-03-05 23:41:58'),(4,'Roofing Mabati','Ken Dancan','0722567890','kendancan001@gmail.com','Syokimau ,Ngobin cresent L227','2026-04-04 12:00:23','2026-04-04 12:00:23'),(5,'Mutua Mbao Limited','John Mutua','0711235746','johnmutua@mbaolimited.com','Kiambu , Matunda','2026-04-04 12:02:07','2026-04-04 12:02:07'),(6,'Lenah Wires Limited','Nechesa Abisaki','072284148690','nechesaabisaki001@gmail.com','Kitale ,Noggin 456','2026-04-04 12:04:46','2026-04-04 12:04:46'),(7,'Muthokinju Suppliers','Alice Kimaitha','0789347524','Alicekimaitha001@gmail.com','Muthokinju','2026-04-04 12:47:17','2026-04-04 12:47:17');
/*!40000 ALTER TABLE `suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `txn_id` int NOT NULL AUTO_INCREMENT,
  `item_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `transaction_type` enum('Inflow','Outflow') COLLATE utf8mb4_unicode_ci NOT NULL,
  `sub_type` enum('Purchase','Return','Adjustment','Sale','Loan','Damage','Theft','Write-off') COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int NOT NULL,
  `unit_cost` decimal(12,2) NOT NULL,
  `total_value` decimal(14,2) GENERATED ALWAYS AS ((`quantity` * `unit_cost`)) STORED,
  `reference_number` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8mb4_unicode_ci,
  `transaction_date` date NOT NULL,
  `performed_by` int NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`txn_id`),
  KEY `idx_txn_item` (`item_id`),
  KEY `idx_txn_date` (`transaction_date`),
  KEY `idx_txn_type` (`transaction_type`),
  KEY `idx_txn_user` (`performed_by`),
  CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`item_id`),
  CONSTRAINT `transactions_ibfk_2` FOREIGN KEY (`performed_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `chk_quantity_positive` CHECK ((`quantity` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
INSERT INTO `transactions` (`txn_id`, `item_id`, `transaction_type`, `sub_type`, `quantity`, `unit_cost`, `reference_number`, `notes`, `transaction_date`, `performed_by`, `created_at`) VALUES (1,'BR-00001','Inflow','Purchase',100,850.00,'INV-001','Initial stock','2026-01-15',1,'2026-03-05 23:41:58'),(2,'BR-00001','Outflow','Sale',95,850.00,'SO-001','Dispatched to Westlands site','2026-02-01',1,'2026-03-05 23:41:58'),(3,'BR-00002','Inflow','Purchase',40,650.00,'INV-002','Initial stock','2026-01-15',1,'2026-03-05 23:41:58'),(4,'BR-00002','Outflow','Sale',10,650.00,'SO-002','Karen project tools','2026-02-10',1,'2026-03-05 23:41:58'),(5,'BR-00003','Inflow','Purchase',20,1200.00,'INV-003','Safety stock','2026-01-20',1,'2026-03-05 23:41:58'),(6,'BR-00003','Outflow','Sale',17,1200.00,'SO-003','All sites helmets','2026-02-15',1,'2026-03-05 23:41:58'),(7,'BR-00004','Inflow','Purchase',80,320.00,'INV-004','Initial stock','2026-01-15',1,'2026-03-05 23:41:58'),(8,'BR-00004','Outflow','Sale',30,320.00,'SO-004','Mombasa Road site','2026-02-20',1,'2026-03-05 23:41:58'),(9,'BR-00005','Inflow','Purchase',15,4500.00,'INV-005','Initial stock','2026-01-15',1,'2026-03-05 23:41:58'),(10,'BR-00005','Outflow','Sale',13,4500.00,'SO-005','Westlands electrical','2026-02-25',1,'2026-03-05 23:41:58'),(11,'BR-00001','Outflow','Sale',3,850.00,'INV-006','This is a sale for Email test','2026-03-06',1,'2026-03-06 00:41:53'),(12,'BR-00002','Outflow','Sale',21,650.00,'SO-006','Order for Mr.Regis to resell','2026-03-06',1,'2026-03-06 00:54:37'),(13,'BR-00004','Outflow','Sale',40,320.00,'SO-007',NULL,'2026-03-31',1,'2026-03-31 23:13:41'),(14,'BR-00001','Inflow','Adjustment',2,0.00,'ADJ-1','Physical Count Error','2026-04-03',1,'2026-04-03 14:58:29'),(15,'BR-00003','Inflow','Purchase',20,1200.00,'PO-00010','Received from PO PO-00010','2026-04-03',1,'2026-04-03 19:05:00'),(16,'BR-00002','Inflow','Purchase',20,650.00,'PO-00003','Received from PO PO-00003','2026-04-03',1,'2026-04-03 19:05:27'),(17,'BR-00004','Inflow','Purchase',10,320.00,'PO-00003','Received from PO PO-00003','2026-04-03',1,'2026-04-03 19:05:27'),(18,'BR-00006','Inflow','Purchase',20,650.00,'PO-00009','Received from PO PO-00009','2026-04-03',1,'2026-04-03 19:05:38'),(19,'BR-00002','Inflow','Purchase',20,650.00,'PO-00008','Received from PO PO-00008','2026-04-03',1,'2026-04-03 19:05:47'),(20,'BR-00003','Inflow','Purchase',20,1200.00,'PO-00002','Received from PO PO-00002','2026-04-03',1,'2026-04-03 19:05:57'),(21,'BR-00001','Inflow','Purchase',50,850.00,'PO-00004','Received from PO PO-00004','2026-04-03',1,'2026-04-03 19:06:07'),(22,'BR-00002','Inflow','Purchase',50,650.00,'PO-00005','Received from PO PO-00005','2026-04-03',1,'2026-04-03 19:06:15'),(23,'BR-00003','Inflow','Purchase',30,1200.00,'PO-00006','Received from PO PO-00006','2026-04-03',1,'2026-04-03 19:06:27'),(24,'BR-00001','Inflow','Purchase',50,850.00,'PO-00007','Received from PO PO-00007','2026-04-03',1,'2026-04-03 19:06:38'),(25,'BR-00006','Inflow','Purchase',7,650.00,'PO-00011','Received from PO PO-00011','2026-04-03',1,'2026-04-03 19:08:08'),(27,'BR-00004','Outflow','Loan',5,320.00,'LON-001','N/A','2026-04-03',3,'2026-04-03 20:39:14'),(28,'BR-00006','Outflow','Sale',77,650.00,'SLE-001','SALE TO EUGENE','2026-04-03',3,'2026-04-03 20:41:57'),(29,'BR-00006','Inflow','Purchase',20,650.00,'PO-00012','Received from PO PO-00012','2026-04-03',1,'2026-04-03 20:52:19'),(30,'BR-00001','Outflow','Loan',46,850.00,'SO-008',NULL,'2026-04-03',1,'2026-04-03 21:01:18'),(31,'BR-00001','Outflow','Sale',3,850.00,'SO-009',NULL,'2026-04-04',1,'2026-04-04 13:07:51'),(32,'BR-00001','Inflow','Purchase',29,850.00,'PO-00015','Received from PO PO-00015','2026-04-05',1,'2026-04-05 00:30:17'),(33,'BR-00027','Inflow','Purchase',3,699.00,'PO-00016','Received from PO PO-00016','2026-04-05',1,'2026-04-05 00:30:39');
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('Admin','Manager','Staff') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Staff',
  `status` enum('Active','Inactive') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Active',
  `failed_login_attempts` int NOT NULL DEFAULT '0',
  `locked_until` datetime DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_username` (`username`),
  KEY `idx_email` (`email`),
  KEY `idx_role` (`role`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','System Administrator','admin@buildright.com','$2b$12$/W5dXERK24mk0MMX3GYX9uqsinLHr7C5HpopxSZ2Le5mNO5dKjPi.','Admin','Active',0,NULL,'2026-04-05 00:22:07','2026-02-18 19:57:44','2026-04-05 00:22:07'),(3,'Eli','Elvis Otoli','elvis@buildright.com','$2b$12$nIqwAaDaxmOGXSDLLLR.nuKiaitqdqt5WWqRMCH3Hm3BNhWQHSHom','Staff','Active',0,NULL,'2026-04-04 13:05:34','2026-02-19 18:38:09','2026-04-04 13:05:34'),(4,'Mng_001','Chris Etale','etalechris001@buildright.com','$2b$12$2bs4kh1c/QIbvFKxl1loe.jMf4Zrawtg.sE9/1yIEsK0Ze8dYnDMG','Manager','Active',0,NULL,'2026-04-04 13:40:47','2026-02-25 18:41:15','2026-04-04 13:40:46'),(5,'staff1','Staff','staff1@buildright.com','$2b$12$FDmNJIpONB6bsIn3Lz4yGODttv4eh5/QSe6Vw8/DtWcOIKk35lViO','Staff','Active',0,NULL,'2026-04-03 18:48:52','2026-04-03 18:47:39','2026-04-03 18:48:52'),(6,'Roy','Roy Odhis','RoyOdhis@gmail.com','$2b$12$decABaSKwU8yAAZ7rJJq1.4cFK6pd3hMmDLk/OqQPfKzZQIOgfMDC','Staff','Active',0,NULL,NULL,'2026-04-05 00:31:52','2026-04-05 00:31:52'),(7,'Neema','Clarice Neema','ClariceNeema@gmail.com','$2b$12$utz5sbQUPw/Dt.KkCP1p9eI1QeNqw5ksDWI4Qbno76CNBlGtg350W','Staff','Active',0,NULL,NULL,'2026-04-05 00:32:43','2026-04-05 00:32:43');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-05  0:33:57
