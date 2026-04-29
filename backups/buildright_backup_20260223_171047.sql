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
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES (1,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-02-18 21:34:30'),(2,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-02-18 21:50:41'),(3,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-02-18 23:02:20'),(4,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-02-19 11:27:48'),(5,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-02-19 17:17:06'),(6,1,'LOGOUT','users','1',NULL,NULL,'127.0.0.1','2026-02-19 17:17:08'),(7,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-02-19 17:17:11'),(8,1,'LOGOUT','users','1',NULL,NULL,'127.0.0.1','2026-02-19 17:40:23'),(9,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-02-19 17:40:25'),(10,1,'UPDATE_USER','users','1','{\"role\": \"Admin\", \"email\": \"admin@buildright.com\", \"full_name\": \"System Administrator\"}','{\"role\": \"Admin\", \"email\": \"admin@buildright.com\", \"full_name\": \"System Administrator\"}','127.0.0.1','2026-02-19 17:40:51'),(11,1,'LOGOUT','users','1',NULL,NULL,'127.0.0.1','2026-02-19 18:10:33'),(12,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-02-19 18:10:37'),(13,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-02-19 18:29:02'),(14,1,'CREATE_USER','users','3',NULL,'{\"role\": \"Staff\", \"username\": \"Eli\"}','127.0.0.1','2026-02-19 18:38:09'),(15,1,'LOGOUT','users','1',NULL,NULL,'127.0.0.1','2026-02-19 18:38:15'),(16,NULL,'LOGIN','users','3',NULL,NULL,'127.0.0.1','2026-02-19 18:38:23'),(17,3,'LOGOUT','users','3',NULL,NULL,'127.0.0.1','2026-02-19 18:46:00'),(18,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-02-19 18:46:09'),(19,1,'LOGOUT','users','1',NULL,NULL,'127.0.0.1','2026-02-19 18:46:34'),(20,NULL,'LOGIN','users','3',NULL,NULL,'127.0.0.1','2026-02-19 18:46:41'),(21,NULL,'LOGIN','users','3',NULL,NULL,'127.0.0.1','2026-02-19 18:46:41'),(22,3,'LOGOUT','users','3',NULL,NULL,'127.0.0.1','2026-02-19 18:46:44'),(23,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-02-19 18:47:52'),(24,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-02-19 19:12:58'),(25,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-02-19 23:17:05'),(26,1,'LOGOUT','users','1',NULL,NULL,'127.0.0.1','2026-02-19 23:36:11'),(27,NULL,'LOGIN','users','3',NULL,NULL,'127.0.0.1','2026-02-19 23:36:17'),(28,NULL,'LOGIN','users','3',NULL,NULL,'127.0.0.1','2026-02-20 23:24:31'),(29,3,'LOGOUT','users','3',NULL,NULL,'127.0.0.1','2026-02-20 23:25:18'),(30,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-02-20 23:25:28'),(31,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-02-23 00:07:33'),(32,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-02-23 00:30:43'),(33,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-02-23 16:54:54'),(34,1,'LOGOUT','users','1',NULL,NULL,'127.0.0.1','2026-02-23 16:54:59'),(35,NULL,'LOGIN','users','3',NULL,NULL,'127.0.0.1','2026-02-23 16:55:04'),(36,3,'LOGOUT','users','3',NULL,NULL,'127.0.0.1','2026-02-23 16:56:01'),(37,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-02-23 16:56:06'),(38,1,'LOGOUT','users','1',NULL,NULL,'127.0.0.1','2026-02-23 17:03:00'),(39,NULL,'LOGIN','users','1',NULL,NULL,'127.0.0.1','2026-02-23 17:03:02');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `backups`
--

LOCK TABLES `backups` WRITE;
/*!40000 ALTER TABLE `backups` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Power Tools','Electric and battery powered tools','2026-02-18 19:48:45'),(2,'Hand Tools','Manual hand-operated tools','2026-02-18 19:48:45'),(3,'Safety Equipment','Protective gear and safety items','2026-02-18 19:48:45'),(4,'Heavy Equipment','Large machinery and equipment','2026-02-18 19:48:45'),(5,'Materials','Raw construction materials','2026-02-18 19:48:45'),(6,'Consumables','Items used up during construction','2026-02-18 19:48:45');
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
  PRIMARY KEY (`item_id`),
  KEY `supplier_id` (`supplier_id`),
  KEY `created_by` (`created_by`),
  KEY `idx_item_name` (`name`),
  KEY `idx_item_category` (`category_id`),
  KEY `idx_item_status` (`status`),
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','System Administrator','admin@buildright.com','$2b$12$/W5dXERK24mk0MMX3GYX9uqsinLHr7C5HpopxSZ2Le5mNO5dKjPi.','Admin','Active',0,NULL,'2026-02-23 17:03:02','2026-02-18 19:57:44','2026-02-23 17:03:02'),(3,'Eli','Elvis Otoli','elvis@buildright.com','$2b$12$nIqwAaDaxmOGXSDLLLR.nuKiaitqdqt5WWqRMCH3Hm3BNhWQHSHom','Staff','Active',0,NULL,'2026-02-23 16:55:05','2026-02-19 18:38:09','2026-02-23 16:55:04');
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

-- Dump completed on 2026-02-23 17:10:48
