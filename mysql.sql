CREATE DATABASE  IF NOT EXISTS `quanlynhahang` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `quanlynhahang`;
-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: quanlynhahang
-- ------------------------------------------------------
-- Server version	9.6.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '598faf52-1e8c-11f1-8d8b-0250bb3fcd8b:1-490';

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) NOT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'Khai vị'),(2,'Món chính'),(3,'Món nước'),(4,'Món nướng'),(5,'Món lẩu'),(6,'Tráng miệng'),(7,'Đồ uống');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chef`
--

DROP TABLE IF EXISTS `chef`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chef` (
  `employee_id` int NOT NULL,
  PRIMARY KEY (`employee_id`),
  CONSTRAINT `chef_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chef`
--

LOCK TABLES `chef` WRITE;
/*!40000 ALTER TABLE `chef` DISABLE KEYS */;
INSERT INTO `chef` VALUES (3),(5);
/*!40000 ALTER TABLE `chef` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `phone` (`phone`),
  KEY `idx_customer_phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'hoa','','0812427141',''),(3,'hoàng kỳ','anh','8888888888',''),(4,'hoàng kỳ','anh','8888888880',''),(5,'phạm văn','nguyên','8888888889','pretyboy222@gmail.com'),(6,'Hoa','Ninh Mỹ','0888888889','');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `deposit`
--

DROP TABLE IF EXISTS `deposit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `deposit` (
  `reservation_id` int NOT NULL,
  `deposit_turn` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `status` varchar(50) DEFAULT 'Paid',
  PRIMARY KEY (`reservation_id`,`deposit_turn`),
  CONSTRAINT `deposit_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `reservation` (`reservation_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `deposit`
--

LOCK TABLES `deposit` WRITE;
/*!40000 ALTER TABLE `deposit` DISABLE KEYS */;
INSERT INTO `deposit` VALUES (7,1,300000.00,'Paid'),(7,2,30000.00,'Paid');
/*!40000 ALTER TABLE `deposit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dining_table`
--

DROP TABLE IF EXISTS `dining_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dining_table` (
  `room_id` int NOT NULL,
  `table_number` int NOT NULL,
  `status` varchar(50) DEFAULT 'Available',
  PRIMARY KEY (`room_id`,`table_number`),
  CONSTRAINT `dining_table_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `room` (`room_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dining_table`
--

LOCK TABLES `dining_table` WRITE;
/*!40000 ALTER TABLE `dining_table` DISABLE KEYS */;
INSERT INTO `dining_table` VALUES (1,1,'Ranh'),(1,2,'Đang phục vụ'),(1,3,'Co Khach'),(2,1,'Co Khach');
/*!40000 ALTER TABLE `dining_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dish`
--

DROP TABLE IF EXISTS `dish`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dish` (
  `dish_id` int NOT NULL AUTO_INCREMENT,
  `dish_name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `category_id` int DEFAULT NULL,
  PRIMARY KEY (`dish_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `dish_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dish`
--

LOCK TABLES `dish` WRITE;
/*!40000 ALTER TABLE `dish` DISABLE KEYS */;
INSERT INTO `dish` VALUES (1,'Gỏi cuốn tôm thịt',50000.00,1),(2,'Chả giò',50000.00,1),(3,'Salad trộn dầu giấm',40000.00,1),(4,'Cơm chiên hải sản',70000.00,2),(5,'Cơm gà xối mỡ',65000.00,2),(6,'Bò lúc lắc',120000.00,2),(7,'Phở bò',60000.00,3),(8,'Bún bò Huế',65000.00,3),(9,'Hủ tiếu Nam Vang',60000.00,3),(10,'Ba chỉ nướng',90000.00,4),(11,'Gà nướng mật ong',110000.00,4),(12,'Mực nướng sa tế',120000.00,4),(13,'Lẩu thái hải sản',250000.00,5),(14,'Lẩu bò',220000.00,5),(15,'Lẩu nấm',200000.00,5),(16,'Chè khúc bạch',35000.00,6),(17,'Rau câu',25000.00,6),(18,'Trái cây dĩa',40000.00,6),(19,'Trà đá',5000.00,7),(20,'Coca Cola',15000.00,7),(21,'Nước cam ép',30000.00,7),(22,'Sinh tố bơ',35000.00,7);
/*!40000 ALTER TABLE `dish` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `employee_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `street` varchar(100) DEFAULT NULL,
  `district` varchar(50) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `phone` varchar(15) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `position` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`employee_id`),
  UNIQUE KEY `phone` (`phone`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES (1,'Cường','Trần Văn','12 Nguyễn Trãi','Thanh Xuân','Hà Nội','0901234567','cuong.tv@nhahangx.com','Manager','123'),(2,'Mai','Lê Thị','34 Cầu Giấy','Cầu Giấy','Hà Nội','0912345678','mai.lt@nhahangx.com','Waiter','123'),(3,'Kiên','Phạm Đình','56 Láng Hạ','Đống Đa','Hà Nội','0923456789','kien.pd@nhahangx.com','Chef','123'),(4,'Trúc','Ngô Thanh','78 Hai Bà Trưng','Hoàn Kiếm','Hà Nội','0934567890','truc.nt@nhahangx.com','Waiter','123'),(5,'Sơn','Đỗ Ngọc','90 Kim Mã','Ba Đình','Hà Nội','0945678901','son.dn@nhahangx.com','Chef','123'),(6,'Anh ','Hoàng Kỳ','Yên Ngưu','Thanh Trì','Hà Nội','0812427141','ninhmyhoa02@gmail.com','Waiter','123'),(12,'Hoa','Ninh Mỹ ','Hung Vuong','','Phu Tho, Vietnam','0999999999','ninhmyhoa01@gmail.com','Manager','123');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `export_history`
--

DROP TABLE IF EXISTS `export_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `export_history` (
  `employee_id` int NOT NULL,
  `batch_id` int NOT NULL,
  `export_date` datetime NOT NULL,
  `export_quantity` float NOT NULL,
  `export_purpose` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`employee_id`,`batch_id`,`export_date`),
  KEY `batch_id` (`batch_id`),
  CONSTRAINT `export_history_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`),
  CONSTRAINT `export_history_ibfk_2` FOREIGN KEY (`batch_id`) REFERENCES `import_batch` (`batch_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `export_history`
--

LOCK TABLES `export_history` WRITE;
/*!40000 ALTER TABLE `export_history` DISABLE KEYS */;
INSERT INTO `export_history` VALUES (1,1,'2026-04-16 21:56:00',5,'hỏng'),(1,1,'2026-04-16 22:03:00',3,'hỏng'),(1,1,'2026-04-16 22:16:00',5,'hỏng'),(1,1,'2026-04-16 22:18:00',5,'hỏng'),(1,1,'2026-04-17 22:05:00',5,'hỏng');
/*!40000 ALTER TABLE `export_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `import_batch`
--

DROP TABLE IF EXISTS `import_batch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `import_batch` (
  `batch_id` int NOT NULL AUTO_INCREMENT,
  `import_date` datetime NOT NULL,
  `expiration_date` datetime NOT NULL,
  `batch_price` decimal(10,2) NOT NULL,
  `stock_quantity` float NOT NULL,
  `ingredient_id` int DEFAULT NULL,
  `employee_id` int DEFAULT NULL,
  PRIMARY KEY (`batch_id`),
  KEY `ingredient_id` (`ingredient_id`),
  KEY `employee_id` (`employee_id`),
  CONSTRAINT `import_batch_ibfk_1` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredient` (`ingredient_id`),
  CONSTRAINT `import_batch_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `manager` (`employee_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_batch`
--

LOCK TABLES `import_batch` WRITE;
/*!40000 ALTER TABLE `import_batch` DISABLE KEYS */;
INSERT INTO `import_batch` VALUES (1,'2026-04-16 20:47:00','2026-05-02 20:47:00',100000.00,66,1,1),(2,'2026-04-16 20:47:00','2026-05-09 20:47:00',100000.00,100,1,1),(3,'2026-04-17 02:37:00','2026-06-18 02:37:00',500.00,97,2,1),(4,'2026-04-17 04:41:00','2026-04-25 04:41:00',1400000.00,97.5,3,1),(5,'2026-04-17 04:47:00','2026-04-18 04:47:00',100000.00,100,1,1),(6,'2026-04-17 04:51:00','2026-04-18 04:51:00',100.00,10,5,1);
/*!40000 ALTER TABLE `import_batch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ingredient`
--

DROP TABLE IF EXISTS `ingredient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ingredient` (
  `ingredient_id` int NOT NULL AUTO_INCREMENT,
  `ingredient_name` varchar(255) NOT NULL,
  `unit` varchar(20) NOT NULL,
  `min_stock` float NOT NULL,
  PRIMARY KEY (`ingredient_id`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ingredient`
--

LOCK TABLES `ingredient` WRITE;
/*!40000 ALTER TABLE `ingredient` DISABLE KEYS */;
INSERT INTO `ingredient` VALUES (1,'Bánh tráng','cái',195),(2,'Tôm','kg',149),(3,'Thịt heo','kg',149),(4,'Bún','kg',500),(5,'Rau sống','kg',30),(6,'Bánh phở','kg',500),(7,'Thịt bò','kg',500),(8,'Nước dùng','l',1000),(9,'Gia vị','kg',200),(10,'Gạo','kg',1000),(11,'Hải sản','kg',500),(12,'Trứng','quả',50),(13,'Gà','kg',500),(14,'Mực','kg',200),(15,'Nấm','kg',300),(16,'Đường','kg',1000),(17,'Sữa','ml',500),(18,'Trà','kg',200),(19,'Cam','quả',50),(20,'Bơ','quả',50),(21,'Thịt bò Kobe','kg',4),(23,'Bánh tráng','cái',50),(24,'Tôm','gram',500),(25,'Thịt heo','kg',500),(26,'Bún','gram',500),(27,'Rau sống','gram',300),(28,'Bánh phở','gram',500),(29,'Thịt bò','gram',500),(30,'Nước dùng','ml',1000),(31,'Gia vị','gram',200),(32,'Gạo','gram',1000),(33,'Hải sản','gram',500),(34,'Trứng','quả',50),(35,'Gà','gram',500),(36,'Mực','gram',500),(37,'Nấm','gram',300),(38,'Đường','gram',200),(39,'Sữa','ml',500),(40,'Trà','gram',200),(41,'Cam','quả',50),(42,'Bơ','quả',50),(43,'Bánh tráng','cái',50),(44,'Tôm','gram',500),(45,'Thịt heo','gram',500),(46,'Bún','gram',500),(47,'Rau sống','gram',300),(48,'Bánh phở','gram',500),(49,'Thịt bò','gram',500),(50,'Nước dùng','ml',1000),(51,'Gia vị','gram',200),(52,'Gạo','gram',1000),(53,'Hải sản','gram',500),(54,'Trứng','quả',50),(55,'Gà','gram',500),(56,'Mực','gram',500),(57,'Nấm','gram',300),(58,'Đường','gram',200),(59,'Sữa','ml',500),(60,'Trà','gram',200),(61,'Cam','quả',50),(62,'Bơ','quả',50),(63,'Bánh tráng','cái',50),(64,'Tôm','gram',500),(65,'Thịt heo','gram',500),(66,'Bún','gram',500),(67,'Rau sống','gram',300),(68,'Bánh phở','gram',500),(69,'Thịt bò','gram',500),(70,'Nước dùng','ml',1000),(71,'Gia vị','gram',200),(72,'Gạo','gram',1000),(73,'Hải sản','gram',500),(74,'Trứng','quả',50),(75,'Gà','gram',500),(76,'Mực','gram',500),(77,'Nấm','gram',300),(78,'Đường','gram',200),(79,'Sữa','ml',500),(80,'Trà','gram',200),(81,'Cam','quả',50),(82,'Bơ','quả',50);
/*!40000 ALTER TABLE `ingredient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice`
--

DROP TABLE IF EXISTS `invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice` (
  `invoice_id` int NOT NULL AUTO_INCREMENT,
  `created_time` datetime NOT NULL,
  `customer_id` int DEFAULT NULL,
  `employee_id` int DEFAULT NULL,
  PRIMARY KEY (`invoice_id`),
  KEY `customer_id` (`customer_id`),
  KEY `employee_id` (`employee_id`),
  CONSTRAINT `invoice_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`),
  CONSTRAINT `invoice_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice`
--

LOCK TABLES `invoice` WRITE;
/*!40000 ALTER TABLE `invoice` DISABLE KEYS */;
INSERT INTO `invoice` VALUES (1,'2026-04-17 00:00:00',NULL,2),(3,'2026-04-18 00:00:00',NULL,1),(4,'2026-04-18 00:00:00',NULL,1),(5,'2026-04-18 00:00:00',NULL,1),(6,'2026-04-18 00:00:00',NULL,1),(7,'2026-04-17 00:00:00',NULL,1),(8,'2026-04-17 00:00:00',NULL,1),(9,'2026-04-17 00:00:00',NULL,1),(10,'2026-04-18 00:00:00',NULL,1);
/*!40000 ALTER TABLE `invoice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice_detail`
--

DROP TABLE IF EXISTS `invoice_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice_detail` (
  `invoice_id` int NOT NULL,
  `room_id` int NOT NULL,
  `table_number` int NOT NULL,
  `dish_id` int NOT NULL,
  `order_time` datetime NOT NULL,
  `quantity` int NOT NULL,
  `note` text,
  `kitchen_status` varchar(50) DEFAULT 'Pending',
  `employee_id` int DEFAULT NULL,
  PRIMARY KEY (`invoice_id`,`room_id`,`table_number`,`dish_id`,`order_time`),
  KEY `room_id` (`room_id`,`table_number`),
  KEY `dish_id` (`dish_id`),
  KEY `employee_id` (`employee_id`),
  KEY `idx_kitchen_status` (`kitchen_status`),
  CONSTRAINT `invoice_detail_ibfk_1` FOREIGN KEY (`invoice_id`) REFERENCES `invoice` (`invoice_id`) ON DELETE CASCADE,
  CONSTRAINT `invoice_detail_ibfk_2` FOREIGN KEY (`room_id`, `table_number`) REFERENCES `dining_table` (`room_id`, `table_number`),
  CONSTRAINT `invoice_detail_ibfk_3` FOREIGN KEY (`dish_id`) REFERENCES `dish` (`dish_id`),
  CONSTRAINT `invoice_detail_ibfk_4` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice_detail`
--

LOCK TABLES `invoice_detail` WRITE;
/*!40000 ALTER TABLE `invoice_detail` DISABLE KEYS */;
INSERT INTO `invoice_detail` VALUES (1,1,1,1,'2026-04-16 23:18:38',1,'','DA_XONG',1),(1,1,1,1,'2026-04-16 23:52:53',2,'','DA_XONG',1),(10,1,1,1,'2026-04-17 04:20:12',1,'','DA_XONG',1),(10,1,1,1,'2026-04-17 04:29:58',1,'','DA_XONG',1),(10,1,1,1,'2026-04-17 04:40:11',1,'','DA_XONG',1),(10,1,1,1,'2026-04-17 04:41:45',1,'','DA_XONG',1),(10,1,1,1,'2026-04-17 04:42:08',1,'','DA_XONG',1),(10,1,1,1,'2026-04-17 04:52:05',3,'','DA_XONG',1);
/*!40000 ALTER TABLE `invoice_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `manager`
--

DROP TABLE IF EXISTS `manager`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manager` (
  `employee_id` int NOT NULL,
  PRIMARY KEY (`employee_id`),
  CONSTRAINT `manager_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `manager`
--

LOCK TABLES `manager` WRITE;
/*!40000 ALTER TABLE `manager` DISABLE KEYS */;
INSERT INTO `manager` VALUES (1),(12);
/*!40000 ALTER TABLE `manager` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pre_order`
--

DROP TABLE IF EXISTS `pre_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pre_order` (
  `reservation_id` int NOT NULL,
  `dish_id` int NOT NULL,
  `quantity` int NOT NULL,
  `note` text,
  PRIMARY KEY (`reservation_id`,`dish_id`),
  KEY `dish_id` (`dish_id`),
  CONSTRAINT `pre_order_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `reservation` (`reservation_id`) ON DELETE CASCADE,
  CONSTRAINT `pre_order_ibfk_2` FOREIGN KEY (`dish_id`) REFERENCES `dish` (`dish_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pre_order`
--

LOCK TABLES `pre_order` WRITE;
/*!40000 ALTER TABLE `pre_order` DISABLE KEYS */;
INSERT INTO `pre_order` VALUES (1,1,1,NULL),(1,2,3,NULL),(1,3,3,NULL),(2,1,1,'dị ứng tôm'),(2,3,1,''),(3,2,1,''),(3,3,1,''),(4,1,1,''),(4,2,1,'ko giò'),(4,3,1,'');
/*!40000 ALTER TABLE `pre_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `price_history`
--

DROP TABLE IF EXISTS `price_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `price_history` (
  `dish_id` int NOT NULL,
  `applied_time` datetime NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `employee_id` int DEFAULT NULL,
  PRIMARY KEY (`dish_id`,`applied_time`),
  KEY `employee_id` (`employee_id`),
  CONSTRAINT `price_history_ibfk_1` FOREIGN KEY (`dish_id`) REFERENCES `dish` (`dish_id`),
  CONSTRAINT `price_history_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `manager` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `price_history`
--

LOCK TABLES `price_history` WRITE;
/*!40000 ALTER TABLE `price_history` DISABLE KEYS */;
INSERT INTO `price_history` VALUES (1,'2026-04-16 20:56:00',50000.00,1),(1,'2026-04-17 21:23:00',50000.00,1),(1,'2026-04-17 21:36:00',50000.00,1),(1,'2026-04-17 21:39:00',50000.00,1),(1,'2026-04-17 21:46:00',50000.00,1),(1,'2026-04-18 21:34:00',50000.00,1);
/*!40000 ALTER TABLE `price_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recipe`
--

DROP TABLE IF EXISTS `recipe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recipe` (
  `dish_id` int NOT NULL,
  `ingredient_id` int NOT NULL,
  `quantity` float NOT NULL,
  PRIMARY KEY (`dish_id`,`ingredient_id`),
  KEY `ingredient_id` (`ingredient_id`),
  CONSTRAINT `recipe_ibfk_1` FOREIGN KEY (`dish_id`) REFERENCES `dish` (`dish_id`),
  CONSTRAINT `recipe_ibfk_2` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredient` (`ingredient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recipe`
--

LOCK TABLES `recipe` WRITE;
/*!40000 ALTER TABLE `recipe` DISABLE KEYS */;
INSERT INTO `recipe` VALUES (1,1,1),(1,2,0.5),(1,3,0.5),(1,5,0.03),(2,1,2),(2,3,70),(2,9,10),(3,5,100),(3,9,10),(4,9,10),(4,10,200),(4,11,100),(4,12,2),(5,9,10),(5,10,200),(5,13,150),(6,7,150),(6,9,10),(7,6,200),(7,7,100),(7,8,300),(7,9,10),(8,6,200),(8,7,100),(8,8,300),(8,9,10),(9,3,100),(9,6,200),(9,8,300),(9,9,10),(10,3,200),(10,9,10),(11,9,10),(11,13,200),(12,9,10),(12,14,200),(13,8,500),(13,9,20),(13,11,200),(14,7,200),(14,8,500),(14,9,20),(15,8,500),(15,9,20),(15,15,200),(16,16,50),(16,17,100),(17,16,50),(18,19,100),(19,18,10),(20,16,0.02),(21,19,2),(22,17,100),(22,20,1);
/*!40000 ALTER TABLE `recipe` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservation`
--

DROP TABLE IF EXISTS `reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservation` (
  `reservation_id` int NOT NULL AUTO_INCREMENT,
  `created_time` datetime NOT NULL,
  `arrival_time` datetime NOT NULL,
  `guest_count` int NOT NULL,
  `customer_id` int DEFAULT NULL,
  `employee_id` int DEFAULT NULL,
  PRIMARY KEY (`reservation_id`),
  KEY `customer_id` (`customer_id`),
  KEY `employee_id` (`employee_id`),
  CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`),
  CONSTRAINT `reservation_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservation`
--

LOCK TABLES `reservation` WRITE;
/*!40000 ALTER TABLE `reservation` DISABLE KEYS */;
INSERT INTO `reservation` VALUES (1,'2026-04-15 17:14:08','2026-04-17 17:19:00',2,1,NULL),(2,'2026-04-15 17:32:54','2026-04-17 17:33:00',2,3,NULL),(3,'2026-04-15 17:35:04','2026-04-17 17:36:00',2,4,NULL),(4,'2026-04-15 17:43:34','2026-04-18 17:45:00',2,5,NULL),(5,'2026-04-17 01:29:00','2026-04-18 13:33:00',2,NULL,1),(6,'2026-04-17 01:33:00','2026-04-18 16:34:00',2,NULL,1),(7,'2026-04-17 01:34:00','2026-04-18 13:34:00',2,NULL,1);
/*!40000 ALTER TABLE `reservation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `room`
--

DROP TABLE IF EXISTS `room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room` (
  `room_id` int NOT NULL,
  `max_capacity` int NOT NULL,
  PRIMARY KEY (`room_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room`
--

LOCK TABLES `room` WRITE;
/*!40000 ALTER TABLE `room` DISABLE KEYS */;
INSERT INTO `room` VALUES (1,30),(2,20),(3,10),(4,10);
/*!40000 ALTER TABLE `room` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `table_reservation`
--

DROP TABLE IF EXISTS `table_reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `table_reservation` (
  `reservation_id` int NOT NULL,
  `room_id` int NOT NULL,
  `table_number` int NOT NULL,
  PRIMARY KEY (`reservation_id`,`room_id`,`table_number`),
  KEY `room_id` (`room_id`,`table_number`),
  CONSTRAINT `table_reservation_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `reservation` (`reservation_id`) ON DELETE CASCADE,
  CONSTRAINT `table_reservation_ibfk_2` FOREIGN KEY (`room_id`, `table_number`) REFERENCES `dining_table` (`room_id`, `table_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `table_reservation`
--

LOCK TABLES `table_reservation` WRITE;
/*!40000 ALTER TABLE `table_reservation` DISABLE KEYS */;
/*!40000 ALTER TABLE `table_reservation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vw_chef_order_queue`
--

DROP TABLE IF EXISTS `vw_chef_order_queue`;
/*!50001 DROP VIEW IF EXISTS `vw_chef_order_queue`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_chef_order_queue` AS SELECT 
 1 AS `room_id`,
 1 AS `table_number`,
 1 AS `dish_name`,
 1 AS `quantity`,
 1 AS `note`,
 1 AS `kitchen_status`,
 1 AS `order_time`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vw_invoice_total`
--

DROP TABLE IF EXISTS `vw_invoice_total`;
/*!50001 DROP VIEW IF EXISTS `vw_invoice_total`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vw_invoice_total` AS SELECT 
 1 AS `invoice_id`,
 1 AS `created_time`,
 1 AS `customer_name`,
 1 AS `total_amount`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `waiter`
--

DROP TABLE IF EXISTS `waiter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `waiter` (
  `employee_id` int NOT NULL,
  PRIMARY KEY (`employee_id`),
  CONSTRAINT `waiter_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `waiter`
--

LOCK TABLES `waiter` WRITE;
/*!40000 ALTER TABLE `waiter` DISABLE KEYS */;
INSERT INTO `waiter` VALUES (2),(4),(6);
/*!40000 ALTER TABLE `waiter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `work_shift`
--

DROP TABLE IF EXISTS `work_shift`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_shift` (
  `employee_id` int NOT NULL,
  `login_time` datetime NOT NULL,
  `logout_time` datetime DEFAULT NULL,
  PRIMARY KEY (`employee_id`,`login_time`),
  CONSTRAINT `work_shift_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `work_shift`
--

LOCK TABLES `work_shift` WRITE;
/*!40000 ALTER TABLE `work_shift` DISABLE KEYS */;
INSERT INTO `work_shift` VALUES (1,'2026-04-16 19:33:00','2026-04-16 22:33:00'),(1,'2026-04-16 23:39:00','2026-04-16 23:42:00'),(1,'2026-04-17 23:41:00','2026-04-24 23:41:00'),(2,'2026-04-16 22:27:58','2026-04-16 22:28:03'),(2,'2026-04-17 04:55:20','2026-04-17 04:55:21'),(3,'2026-04-16 19:35:02','2026-04-16 19:35:10'),(3,'2026-04-16 19:36:20',NULL);
/*!40000 ALTER TABLE `work_shift` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `vw_chef_order_queue`
--

/*!50001 DROP VIEW IF EXISTS `vw_chef_order_queue`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_chef_order_queue` AS select `id`.`room_id` AS `room_id`,`id`.`table_number` AS `table_number`,`d`.`dish_name` AS `dish_name`,`id`.`quantity` AS `quantity`,`id`.`note` AS `note`,`id`.`kitchen_status` AS `kitchen_status`,`id`.`order_time` AS `order_time` from (`invoice_detail` `id` join `dish` `d` on((`id`.`dish_id` = `d`.`dish_id`))) where (`id`.`kitchen_status` in ('Pending','Cooking')) order by `id`.`order_time` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_invoice_total`
--

/*!50001 DROP VIEW IF EXISTS `vw_invoice_total`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_invoice_total` AS select `i`.`invoice_id` AS `invoice_id`,`i`.`created_time` AS `created_time`,`c`.`first_name` AS `customer_name`,sum((`d`.`price` * `idet`.`quantity`)) AS `total_amount` from (((`invoice` `i` join `invoice_detail` `idet` on((`i`.`invoice_id` = `idet`.`invoice_id`))) join `dish` `d` on((`idet`.`dish_id` = `d`.`dish_id`))) left join `customer` `c` on((`i`.`customer_id` = `c`.`customer_id`))) group by `i`.`invoice_id`,`i`.`created_time`,`c`.`first_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-17  6:55:32
