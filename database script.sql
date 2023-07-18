CREATE DATABASE  IF NOT EXISTS `airline_reservation_system` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `airline_reservation_system`;
-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)
--
-- Host: localhost    Database: airline_reservation_system
-- ------------------------------------------------------
-- Server version	8.0.30

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

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `Admin_id` int NOT NULL,
  PRIMARY KEY (`Admin_id`),
  CONSTRAINT `admin` FOREIGN KEY (`Admin_id`) REFERENCES `user` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1015);
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `class`
--

DROP TABLE IF EXISTS `class`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `class` (
  `flight_id` int NOT NULL,
  `class` varchar(10) NOT NULL,
  `total_seats` int NOT NULL,
  `seats_left` int NOT NULL,
  `price` int NOT NULL,
  `discount` int NOT NULL,
  PRIMARY KEY (`flight_id`,`class`),
  KEY `discount` (`discount`) /*!80000 INVISIBLE */,
  KEY `class` (`class`),
  CONSTRAINT `flightID` FOREIGN KEY (`flight_id`) REFERENCES `flight` (`flight_id`),
  CONSTRAINT `chk_discount` CHECK ((`discount` between 0 and 60)),
  CONSTRAINT `chk_seats_left` CHECK (((`seats_left` <= `total_seats`) and (`seats_left` >= 0))),
  CONSTRAINT `chk_total_seats` CHECK ((`total_seats` between 20 and 60))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `class`
--

LOCK TABLES `class` WRITE;
/*!40000 ALTER TABLE `class` DISABLE KEYS */;
INSERT INTO `class` VALUES (1001,'Business',59,59,847,0),(1001,'Economy',59,59,69,10),(1002,'business',59,59,965,0),(1002,'economy',59,59,56,5),(1003,'Business',59,59,382,5),(1003,'Economy',59,59,76,0),(1004,'Business',59,59,718,0),(1004,'Economy',59,59,60,0),(1005,'Business',59,59,544,0),(1005,'Economy',59,59,74,0),(1006,'Business',59,59,465,0),(1006,'Economy',59,59,90,0),(1007,'Business',59,59,595,0),(1007,'Economy',59,59,76,0),(1008,'Business',59,59,579,0),(1008,'Economy',59,59,60,0),(1009,'Business',59,59,108,0),(1009,'Economy',59,59,73,0),(1010,'Business',59,59,507,0),(1010,'Economy',59,59,83,0),(1011,'Business',59,59,308,0),(1011,'Economy',59,59,97,0),(1012,'Business',59,59,822,0),(1012,'Economy',59,59,85,0),(1013,'Business',59,59,381,0),(1013,'Economy',59,59,86,0),(1014,'Business',59,59,242,0),(1014,'Economy',59,59,73,0),(1015,'Business',59,59,869,0),(1015,'Economy',59,59,58,0),(1016,'Business',59,59,814,0),(1016,'Economy',59,59,72,0),(1017,'Business',59,59,465,0),(1017,'Economy',59,59,86,0),(1018,'Business',59,59,684,0),(1018,'Economy',59,59,64,0),(1019,'Business',59,59,125,0),(1019,'Economy',59,59,62,0),(1020,'Business',59,59,274,10),(1020,'Economy',59,59,70,0),(1021,'Business',59,59,897,0),(1021,'Economy',59,59,61,0),(1022,'Business',59,59,858,0),(1022,'Economy',59,59,98,0),(1023,'Business',59,59,599,0),(1023,'Economy',59,59,54,0),(1024,'Business',59,59,321,0),(1024,'Economy',59,59,77,0),(1025,'Business',59,59,612,0),(1025,'Economy',59,59,73,0),(1026,'Business',59,59,193,0),(1026,'Economy',59,59,84,0),(1027,'Business',59,59,832,0),(1027,'Economy',59,59,99,0),(1028,'Business',59,59,779,0),(1028,'Economy',59,59,91,0),(1029,'Business',59,59,397,0),(1029,'Economy',59,59,61,0),(1030,'Business',59,59,452,0),(1030,'Economy',59,59,81,0),(1031,'Business',59,59,969,0),(1031,'Economy',59,59,71,0),(1032,'Business',59,59,687,0),(1032,'Economy',59,59,63,0),(1033,'Business',59,59,429,0),(1033,'Economy',59,59,54,0),(1034,'Business',59,59,884,0),(1034,'Economy',59,59,81,0),(1035,'Business',59,59,332,0),(1035,'Economy',59,59,93,0),(1036,'Business',59,59,708,0),(1036,'Economy',59,59,71,0),(1037,'Business',59,59,644,0),(1037,'Economy',59,59,75,0),(1038,'Business',59,59,995,0),(1038,'Economy',59,59,64,0),(1039,'Business',59,59,244,0),(1039,'Economy',59,59,94,0),(1040,'Business',59,59,835,0),(1040,'Economy',59,59,77,0),(1041,'Business',59,59,640,0),(1041,'Economy',59,59,53,0),(1042,'Business',59,59,599,0),(1042,'Economy',59,59,88,0),(1043,'Business',59,59,972,0),(1043,'Economy',59,59,76,0),(1044,'Business',59,59,263,0),(1044,'Economy',59,59,69,0),(1045,'Business',59,59,1000,0),(1045,'Economy',59,59,69,0),(1046,'Business',59,59,507,0),(1046,'Economy',59,59,85,0),(1047,'Business',59,59,339,0),(1047,'Economy',59,59,69,0),(1048,'Business',59,59,974,0),(1048,'Economy',59,59,89,0),(1049,'Business',59,59,152,0),(1049,'Economy',59,59,86,0),(1050,'Business',59,59,439,0),(1050,'Economy',59,59,65,0),(1051,'Business',59,59,739,0),(1051,'Economy',59,59,70,0),(1052,'Business',59,59,475,0),(1052,'Economy',59,59,51,0),(1053,'Business',59,59,962,0),(1053,'Economy',59,59,100,0),(1054,'Business',59,59,582,0),(1054,'Economy',59,59,92,0),(1055,'Business',59,59,824,0),(1055,'Economy',59,59,60,0),(1056,'Business',59,59,471,0),(1056,'Economy',59,59,78,0),(1057,'Business',59,59,688,0),(1057,'Economy',59,59,57,0),(1058,'Business',59,59,125,0),(1058,'Economy',59,59,51,0),(1059,'Business',59,59,261,0),(1059,'Economy',59,59,87,0),(1060,'Business',59,59,834,0),(1060,'Economy',59,59,80,0),(1061,'Business',59,59,582,0),(1061,'Economy',59,59,91,0),(1062,'Business',59,59,309,0),(1062,'Economy',59,59,62,0),(1063,'Business',59,59,602,0),(1063,'Economy',59,59,90,0),(1064,'Business',59,59,182,0),(1064,'Economy',59,59,60,0),(1065,'Business',59,59,807,0),(1065,'Economy',59,59,84,0),(1066,'Business',59,59,684,0),(1066,'Economy',59,59,89,0),(1067,'Business',59,59,901,0),(1067,'Economy',59,59,94,0),(1068,'Business',59,59,551,0),(1068,'Economy',59,59,100,0),(1069,'Business',59,59,852,0),(1069,'Economy',59,59,69,0),(1070,'Business',59,59,708,0),(1070,'Economy',59,59,96,0),(1071,'Business',59,59,882,0),(1071,'Economy',59,59,72,0),(1072,'Business',59,59,387,0),(1072,'Economy',59,59,71,0),(1073,'Business',59,59,991,0),(1073,'Economy',59,59,89,0),(1074,'Business',59,59,989,0),(1074,'Economy',59,59,83,0),(1075,'Business',59,59,974,0),(1075,'Economy',59,59,96,0),(1076,'Business',59,59,904,0),(1076,'Economy',59,59,83,0),(1077,'Business',59,59,322,0),(1077,'Economy',59,59,77,0),(1078,'Business',59,59,167,0),(1078,'Economy',59,59,71,0),(1079,'Business',59,59,751,0),(1079,'Economy',59,59,87,0),(1080,'Business',59,59,451,0),(1080,'Economy',59,59,68,0),(1081,'Business',59,59,804,0),(1081,'Economy',59,59,80,0),(1082,'Business',59,59,766,0),(1082,'Economy',59,59,97,0),(1083,'Business',59,59,416,0),(1083,'Economy',59,59,91,0),(1084,'Business',59,59,583,0),(1084,'Economy',59,59,67,0),(1085,'Business',59,59,666,0),(1085,'Economy',59,59,61,0),(1086,'Business',59,59,583,0),(1086,'Economy',59,59,54,0),(1087,'Business',59,58,817,0),(1087,'Economy',59,59,88,0),(1088,'Business',59,59,436,0),(1088,'Economy',59,59,75,0),(1089,'Business',59,59,528,0),(1089,'Economy',59,59,60,0),(1090,'Business',59,59,331,0),(1090,'Economy',59,59,80,0),(1091,'Business',59,59,873,0),(1091,'Economy',59,59,68,0),(1092,'Business',59,59,571,0),(1092,'Economy',59,59,51,0),(1093,'Business',59,59,137,0),(1093,'Economy',59,59,50,0),(1094,'Business',59,59,676,0),(1094,'Economy',59,59,99,0),(1095,'Business',59,59,164,0),(1095,'Economy',59,59,92,0),(1096,'Business',59,59,493,0),(1096,'Economy',59,59,61,0),(1097,'Business',59,59,975,0),(1097,'Economy',59,59,82,0),(1098,'Business',59,59,592,0),(1098,'Economy',59,59,74,0),(1099,'Business',59,59,836,0),(1099,'Economy',59,59,77,0),(1100,'Business',59,59,505,0),(1100,'Economy',59,59,60,0),(1101,'Business',59,59,817,0),(1101,'Economy',59,59,73,0),(1102,'Business',59,59,667,0),(1102,'Economy',59,59,84,0),(1103,'Business',59,59,787,0),(1103,'Economy',59,59,100,0),(1104,'Business',59,59,931,0),(1104,'Economy',59,59,97,0),(1105,'Business',59,59,394,0),(1105,'Economy',59,59,83,5),(1106,'Business',59,59,879,0),(1106,'Economy',59,59,77,0),(1107,'Business',59,59,413,0),(1107,'Economy',59,59,87,0),(1108,'Business',59,59,226,0),(1108,'Economy',59,59,50,0),(1109,'Business',59,59,694,0),(1109,'Economy',59,59,93,0),(1110,'Business',59,59,892,0),(1110,'Economy',59,59,62,0),(1111,'Business',59,59,474,0),(1111,'Economy',59,59,82,0),(1112,'Business',59,59,496,0),(1112,'Economy',59,59,71,0),(1113,'Business',59,59,960,0),(1113,'Economy',59,59,63,0),(1114,'Business',59,59,510,0),(1114,'Economy',59,59,50,0),(1115,'Business',59,59,472,0),(1115,'Economy',59,59,65,0),(1116,'Business',59,59,728,0),(1116,'Economy',59,59,75,0),(1117,'Business',59,59,322,0),(1117,'Economy',59,59,78,0),(1118,'Business',59,59,229,0),(1118,'Economy',59,59,64,0),(1119,'Business',59,59,981,0),(1119,'Economy',59,59,88,0),(1120,'Business',59,59,515,0),(1120,'Economy',59,59,98,0),(1121,'Business',59,59,433,0),(1121,'Economy',59,59,72,0),(1122,'Business',59,59,519,0),(1122,'Economy',59,59,67,0),(1123,'Business',59,59,298,0),(1123,'Economy',59,59,69,0),(1124,'Business',59,59,735,0),(1124,'Economy',59,59,97,0),(1125,'Business',59,59,876,0),(1125,'Economy',59,59,74,0),(1126,'Business',59,59,277,0),(1126,'Economy',59,59,80,0),(1127,'Business',59,59,459,0),(1127,'Economy',59,59,77,0),(1128,'Business',59,59,463,0),(1128,'Economy',59,59,96,0),(1129,'Business',59,59,840,0),(1129,'Economy',59,59,99,0),(1130,'Business',59,59,908,0),(1130,'Economy',59,59,56,0),(1131,'Business',59,59,117,0),(1131,'Economy',59,59,85,0),(1132,'Business',59,59,466,0),(1132,'Economy',59,59,55,0),(1133,'Business',59,59,977,0),(1133,'Economy',59,59,70,0),(1134,'Business',59,59,687,0),(1134,'Economy',59,59,88,0),(1135,'Business',59,59,403,0),(1135,'Economy',59,59,75,0),(1136,'Business',59,59,756,0),(1136,'Economy',59,59,64,0),(1137,'Business',59,59,669,0),(1137,'Economy',59,59,94,0),(1138,'Business',59,59,978,0),(1138,'Economy',59,59,77,0),(1139,'Business',59,59,980,0),(1139,'Economy',59,59,53,0),(1140,'Business',59,59,966,0),(1140,'Economy',59,59,85,0),(1141,'Business',59,59,890,0),(1141,'Economy',59,59,63,0),(1142,'Business',59,59,553,0),(1142,'Economy',59,59,64,0),(1143,'Business',59,59,894,0),(1143,'Economy',59,59,81,0),(1144,'Business',59,59,910,0),(1144,'Economy',59,59,63,0),(1145,'Business',59,59,867,0),(1145,'Economy',59,59,71,0),(1146,'Business',59,59,606,0),(1146,'Economy',59,59,68,0),(1147,'Business',59,59,328,0),(1147,'Economy',59,59,76,0),(1148,'Business',59,59,625,0),(1148,'Economy',59,59,75,0),(1149,'Business',59,59,240,0),(1149,'Economy',59,59,98,0),(1150,'Business',59,59,125,0),(1150,'Economy',59,59,61,0);
/*!40000 ALTER TABLE `class` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `customer_id` int NOT NULL,
  `first_name` varchar(15) NOT NULL,
  `last_name` varchar(15) NOT NULL,
  PRIMARY KEY (`customer_id`),
  CONSTRAINT `customer` FOREIGN KEY (`customer_id`) REFERENCES `user` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1012,'hamza','anwar'),(1016,'Usaid','sid'),(1017,'Muhammad ','Ali'),(1018,'Babar','azam'),(1019,'Virat ','Kohli'),(1020,'muhammad ','rizwan'),(1021,'ahsan','ali'),(1022,'maaz','tariq'),(1023,'Hasnain','Ali'),(1024,'Osman','Bey');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_booked_flights`
--

DROP TABLE IF EXISTS `customer_booked_flights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_booked_flights` (
  `flightID` int NOT NULL,
  `customer_ID` int NOT NULL,
  PRIMARY KEY (`flightID`,`customer_ID`),
  KEY `customerID_idx` (`customer_ID`),
  CONSTRAINT `customerID` FOREIGN KEY (`customer_ID`) REFERENCES `customer` (`customer_id`),
  CONSTRAINT `flight` FOREIGN KEY (`flightID`) REFERENCES `flight` (`flight_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_booked_flights`
--

LOCK TABLES `customer_booked_flights` WRITE;
/*!40000 ALTER TABLE `customer_booked_flights` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_booked_flights` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `discounted`
--

DROP TABLE IF EXISTS `discounted`;
/*!50001 DROP VIEW IF EXISTS `discounted`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `discounted` AS SELECT 
 1 AS `flight_id`,
 1 AS `destination`,
 1 AS `date`,
 1 AS `departure_time`,
 1 AS `price`,
 1 AS `discount`,
 1 AS `class`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `flight`
--

DROP TABLE IF EXISTS `flight`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flight` (
  `flight_id` int NOT NULL AUTO_INCREMENT,
  `source` varchar(45) NOT NULL,
  `destination` varchar(45) NOT NULL,
  `date` date NOT NULL,
  `departure_time` time NOT NULL,
  `arrival_time` time NOT NULL,
  `airplane_name` varchar(5) NOT NULL,
  `status` varchar(10) NOT NULL DEFAULT 'available',
  `terminal` varchar(3) NOT NULL,
  `admin_id` int DEFAULT NULL,
  PRIMARY KEY (`flight_id`),
  KEY `admin_id_idx` (`admin_id`),
  KEY `source` (`source`) /*!80000 INVISIBLE */,
  KEY `destination` (`destination`) /*!80000 INVISIBLE */,
  KEY `date` (`date`),
  CONSTRAINT `admin_id` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`Admin_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1151 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flight`
--

LOCK TABLES `flight` WRITE;
/*!40000 ALTER TABLE `flight` DISABLE KEYS */;
INSERT INTO `flight` VALUES (1001,'Bangkok','Athens','2023-07-19','08:00:00','15:00:00','B747 ','available','T2',1015),(1002,'Hong Kong','Athens','2023-07-25','10:30:00','12:00:00','B787','available','T4',1015),(1003,'Dubai','Athens','2023-07-20','14:45:00','16:30:00','A380','available','T1',1015),(1004,'Seoul','Athens','2023-07-19','09:30:00','18:00:00','B747 ','available','T3',1015),(1005,'Karachi','Athens','2023-07-20','11:15:00','23:30:00','A350','available','T2',1015),(1006,'Auckland','Berlin','2023-07-23','13:45:00','19:30:00','B737 ','available','T4',1015),(1007,'Lahore','Berlin','2023-07-24','08:30:00','10:15:00','B747 ','available','T1',1015),(1008,'Hong Kong','Berlin','2023-07-20','12:00:00','15:30:00','A350','available','T3',1015),(1009,'Toronto','Berlin','2023-07-23','14:15:00','15:45:00','A380','available','T2',1015),(1010,'Dubai','Berlin','2023-07-26','10:00:00','20:30:00','B737 ','available','T4',1015),(1011,'Hong Kong','London','2023-07-18','12:30:00','02:00:00','A350','available','T1',1015),(1012,'Dubai','London','2023-07-21','15:00:00','16:45:00','A380','available','T3',1015),(1013,'Mexico City','London','2023-07-22','09:15:00','11:30:00','B747 ','available','T2',1015),(1014,'Lahore','London','2023-07-27','11:45:00','13:30:00','B737 ','available','T4',1015),(1015,'Seoul','London','2023-07-26','14:00:00','16:15:00','A380','available','T1',1015),(1016,'Karachi','Mumbai','2023-07-18','08:30:00','20:00:00','B787','available','T3',1015),(1017,'Lahore','Mumbai','2023-07-19','10:00:00','18:15:00','A320','available','T2',1015),(1018,'Bangkok','Mumbai','2023-07-25','12:45:00','19:30:00','B747 ','available','T4',1015),(1019,'Hong Kong','Mumbai','2023-07-23','13:20:00','21:30:00','A380','available','T2',1015),(1020,'Cairo','Mumbai','2023-07-22','09:54:00','02:00:00','B747 ','available','T1',1015),(1021,'Toronto','USA','2023-07-24','10:45:00','12:00:00','A350','available','T2',1015),(1022,'Cairo','USA','2023-07-24','10:00:00','08:45:00','A380','available','T3',1015),(1023,'Auckland','USA','2023-07-29','11:00:00','08:00:00','B737 ','available','T3',1015),(1024,'Mexico City','USA','2023-07-30','08:00:00','10:00:00','A320','available','T3',1015),(1025,'Lahore','USA','2023-07-20','08:30:00','10:45:00','B787','available','T1',1015),(1026,'Seoul','Tokyo','2023-07-18','09:30:00','22:00:00','B737 ','available','T2',1015),(1027,'Hong Kong','Tokyo','2023-07-27','21:30:00','07:45:00','B747 ','available','T1',1015),(1028,'Karachi','Tokyo','2023-07-24','02:45:00','08:00:00','A380','available','T4',1015),(1029,'Bangkok','Tokyo','2023-07-20','11:30:00','18:30:00','B747 ','available','T4',1015),(1030,'Dubai','Tokyo','2023-07-23','10:20:00','18:00:00','A350','available','T2',1015),(1031,'Lahore','Istanbul','2023-07-25','24:00:00','03:30:00','B747 ','available','T1',1015),(1032,'Toronto','Istanbul','2023-07-26','05:45:00','11:30:00','A320','available','T1',1015),(1033,'Karachi','Istanbul','2023-07-25','03:00:00','08:00:00','A350','available','T3',1015),(1034,'Bangkok','Istanbul','2023-07-29','08:45:00','16:20:00','B737 ','available','T4',1015),(1035,'Dubai','Istanbul','2023-07-26','12:00:00','20:00:00','A380','available','T2',1015),(1036,'Dubai','Beijing','2023-07-25','11:30:00','16:00:00','B747 ','available','T4',1015),(1037,'Bangkok','Beijing','2023-07-29','01:00:00','06:00:00','B787','available','T2',1015),(1038,'Karachi','Beijing','2023-07-28','03:45:00','08:30:00','B737 ','available','T3',1015),(1039,'Hong Kong','Beijing','2023-07-22','11:20:00','16:30:00','A380','available','T1',1015),(1040,'Seoul','Beijing','2023-07-20','02:20:00','05:00:00','B747 ','available','T4',1015),(1041,'Lahore','Singapore','2023-07-29','06:00:00','08:00:00','A350','available','T3',1015),(1042,'Mexico City','Singapore','2023-07-29','05:00:00','13:00:00','A320','available','T2',1015),(1043,'Auckland','Singapore','2023-07-28','09:00:00','20:00:00','B787','available','T4',1015),(1044,'Cairo','Singapore','2023-07-23','03:00:00','09:30:00','B747 ','available','T1',1015),(1045,'Toronto','Singapore','2023-07-26','10:00:00','16:30:00','A320','available','T3',1015),(1046,'Mexico City','Los Angeles','2023-07-29','02:00:00','07:00:00','B737 ','available','T4',1015),(1047,'Hong Kong','Los Angeles','2023-07-26','09:00:00','15:00:00','A350','available','T2',1015),(1048,'Toronto','Los Angeles','2023-07-23','02:00:00','05:40:00','B737 ','available','T3',1015),(1049,'Seoul','Los Angeles','2023-07-22','16:00:00','20:00:00','A380','available','T1',1015),(1050,'Dubai','Los Angeles','2023-07-23','13:00:00','17:30:00','B747 ','available','T3',1015),(1051,'Karachi','Rome','2023-07-29','07:00:00','15:00:00','A350','available','T2',1015),(1052,'Toronto','Rome','2023-07-21','04:30:00','08:30:00','B787','available','T4',1015),(1053,'Dubai','Rome','2023-07-27','09:00:00','16:00:00','B737 ','available','T1',1015),(1054,'Hong Kong','Rome','2023-07-28','08:30:00','19:00:00','B787','available','T2',1015),(1055,'Mexico City','Rome','2023-07-18','19:20:00','20:00:00','A350','available','T3',1015),(1056,'Dubai','Islamabad','2023-07-24','23:00:00','09:30:00','B737 ','available','T4',1015),(1057,'Hong Kong','Islamabad','2023-07-24','16:00:00','20:00:00','B747 ','available','T4',1015),(1058,'Lahore','Islamabad','2023-07-29','06:40:00','17:00:00','A320','available','T3',1015),(1059,'Auckland','Islamabad','2023-07-29','16:50:00','21:00:00','A380','available','T2',1015),(1060,'Karachi','Islamabad','2023-07-30','03:10:00','08:00:00','B737 ','available','T1',1015),(1061,'Toronto','Amsterdam','2023-07-21','09:10:00','16:00:00','A350','available','T2',1015),(1062,'Auckland','Amsterdam','2023-07-20','08:00:00','14:00:00','B737 ','available','T3',1015),(1063,'Lahore','Amsterdam','2023-07-20','11:00:00','16:10:00','B747 ','available','T1',1015),(1064,'Hong Kong','Amsterdam','2023-07-24','02:00:00','04:30:00','A320','available','T4',1015),(1065,'Bangkok','Amsterdam','2023-07-30','05:00:00','10:00:00','B787','available','T1',1015),(1066,'Seoul','Dubai','2023-07-22','21:00:00','03:00:00','B787','available','T2',1015),(1067,'Mexico City','Dubai','2023-07-27','17:00:00','23:10:00','A350','available','T3',1015),(1068,'Karachi','Dubai','2023-07-27','08:00:00','15:00:00','B747 ','available','T4',1015),(1069,'Toronto','Dubai','2023-07-23','02:10:00','08:40:00','B787','available','T1',1015),(1070,'Lahore','Dubai','2023-07-30','16:20:00','21:00:00','A380','available','T1',1015),(1071,'Dubai','Moscow','2023-07-26','04:00:00','08:40:00','B747 ','available','T3',1015),(1072,'Bangkok','Moscow','2023-07-22','06:00:00','10:20:00','A320','available','T4',1015),(1073,'Karachi','Moscow','2023-07-26','08:00:00','14:00:00','A350','available','T2',1015),(1074,'Hong Kong','Moscow','2023-07-22','10:10:00','16:00:00','B747 ','available','T2',1015),(1075,'Seoul','Moscow','2023-07-27','05:00:00','10:20:00','B787','available','T4',1015),(1076,'Bangkok','Athens','2023-07-19','02:20:00','08:30:00','A380','available','T1',1015),(1077,'Hong Kong','Athens','2023-07-24','19:00:00','03:30:00','B747 ','available','T3',1015),(1078,'Dubai','Athens','2023-07-20','07:30:00','11:00:00','A320','available','T2',1015),(1079,'Seoul','Athens','2023-07-23','06:20:00','10:00:00','A350','available','T1',1015),(1080,'Karachi','Athens','2023-07-25','09:00:00','12:10:00','B737 ','available','T4',1015),(1081,'Auckland','Berlin','2023-07-26','08:00:00','13:20:00','B747 ','available','T2',1015),(1082,'Lahore','Berlin','2023-07-23','03:20:00','10:30:00','B787','available','T3',1015),(1083,'Hong Kong ','Berlin','2023-07-19','08:45:00','15:00:00','A380','available','T4',1015),(1084,'Toronto','Berlin','2023-07-24','20:00:00','08:00:00','B787','available','T1',1015),(1085,'Dubai','Berlin','2023-07-30','16:00:00','20:40:00','B747 ','available','T3',1015),(1086,'Hong Kong','London','2023-07-22','08:40:00','16:00:00','A350','available','T2',1015),(1087,'Dubai','London','2023-07-27','04:30:00','11:00:00','B787','available','T1',1015),(1088,'Mexico City ','London','2023-07-28','09:10:00','15:00:00','A320','available','T4',1015),(1089,'Seoul','London ','2023-07-28','04:30:00','20:00:00','A350','available','T3',1015),(1090,'Lahore','London','2023-07-24','05:00:00','08:30:00','B737 ','available','T2',1015),(1091,'Karachi','Mumbai','2023-07-19','11:30:00','18:20:00','B747 ','available','T3',1015),(1092,'Lahore','Mumbai','2023-07-19','01:30:00','04:30:00','A380','available','T3',1015),(1093,'Bangkok','Mumbai','2023-07-20','06:00:00','13:00:00','B787','available','T1',1015),(1094,'Hong Kong','Mumbai','2023-07-25','16:00:00','20:30:00','B737 ','available','T2',1015),(1095,'Cairo','Mumbai','2023-07-20','12:20:00','16:30:00','A350','available','T1',1015),(1096,'Toronto','USA','2023-07-22','07:00:00','10:30:00','A320','available','T4',1015),(1097,'Cairo','USA','2023-07-20','03:00:00','11:00:00','A320','available','T2',1015),(1098,'Auckland','USA','2023-07-27','01:00:00','05:00:00','B787','available','T3',1015),(1099,'Mexico City','USA','2023-07-21','02:20:00','06:20:00','A320','available','T1',1015),(1100,'Lahore','USA','2023-07-30','03:30:00','10:00:00','B737 ','available','T2',1015),(1101,'Seoul','Tokyo','2023-07-30','04:30:00','08:00:00','A350','available','T4',1015),(1102,'Hong Kong','Tokyo','2023-07-20','11:00:00','16:20:00','A380','available','T3',1015),(1103,'Karachi','Tokyo','2023-07-28','08:30:00','14:00:00','B747 ','available','T1',1015),(1104,'Bangkok','Tokyo','2023-07-26','05:20:00','11:00:00','B737 ','available','T4',1015),(1105,'Dubai','Tokyo','2023-07-29','06:20:00','11:00:00','A350','available','T2',1015),(1106,'Lahore','Istanbul','2023-07-21','07:20:00','14:00:00','B787','available','T3',1015),(1107,'Toronto','Istanbul','2023-07-26','02:30:00','10:00:00','B787','available','T4',1015),(1108,'Karachi','Istanbul','2023-07-25','03:10:00','08:00:00','A320','available','T2',1015),(1109,'Bangkok','Istanbul','2023-07-18','08:00:00','15:00:00','A380','available','T1',1015),(1110,'Dubai','Istanbul','2023-07-23','01:10:00','10:00:00','A350','available','T3',1015),(1111,'Dubai','Beijing','2023-07-19','12:00:00','20:00:00','A320','available','T1',1015),(1112,'Bangkok','Beijing','2023-07-20','03:20:00','10:00:00','B787','available','T3',1015),(1113,'Karachi','Beijing','2023-07-25','10:20:00','20:00:00','B787','available','T2',1015),(1114,'Hong Kong','Beijing','2023-07-22','11:30:00','19:20:00','A350','available','T1',1015),(1115,'Seoul','Beijing','2023-07-30','04:20:00','09:00:00','A380','available','T3',1015),(1116,'Lahore','Singapore','2023-07-27','02:00:00','11:00:00','B737 ','available','T2',1015),(1117,'Mexico City','Singapore','2023-07-28','17:00:00','01:00:00','B747 ','available','T4',1015),(1118,'Auckland','Singapore','2023-07-29','03:00:00','11:20:00','A350','available','T1',1015),(1119,'Cairo','Singapore','2023-07-29','02:30:00','09:00:00','B787','available','T2',1015),(1120,'Toronto','Singapore','2023-07-27','10:00:00','18:20:00','B737 ','available','T1',1015),(1121,'Mexico City','Los Angeles','2023-07-19','08:00:00','11:00:00','A380','available','T3',1015),(1122,'Hong Kong','Los Angeles','2023-07-20','09:10:00','15:00:00','A350','available','T4',1015),(1123,'Toronto','Los Angeles','2023-07-29','15:20:00','20:00:00','A320','available','T2',1015),(1124,'Seoul','Los Angeles','2023-07-25','02:20:00','10:00:00','B747 ','available','T1',1015),(1125,'Dubai','Los Angeles','2023-07-23','16:00:00','20:20:00','A380','available','T3',1015),(1126,'Karachi','Rome','2023-07-22','04:10:00','09:00:00','A350','available','T2',1015),(1127,'Toronto','Rome','2023-07-21','11:00:00','17:00:00','B737 ','available','T4',1015),(1128,'Dubai','Rome','2023-07-25','04:00:00','13:20:00','A320','available','T1',1015),(1129,'Hong Kong','Rome','2023-07-28','14:20:00','22:00:00','B787','available','T4',1015),(1130,'Mexico City','Rome','2023-07-25','23:10:00','07:30:00','A380','available','T2',1015),(1131,'Dubai','Islamabad','2023-07-21','16:20:00','20:00:00','A350','available','T1',1015),(1132,'Hong Kong','Islamabad','2023-07-25','03:20:00','11:20:00','A320','available','T3',1015),(1133,'Lahore','Islamabad','2023-07-22','03:00:00','08:00:00','B787','available','T2',1015),(1134,'Auckland','Islamabad','2023-07-27','08:00:00','17:00:00','B737 ','available','T1',1015),(1135,'Karachi','Islamabad','2023-07-25','08:10:00','16:00:00','A380','available','T4',1015),(1136,'Toronto','Amsterdam','2023-07-27','14:30:00','23:20:00','A350','available','T2',1015),(1137,'Auckland','Amsterdam','2023-07-29','20:00:00','03:00:00','B787','available','T1',1015),(1138,'Lahore ','Amsterdam','2023-07-20','03:10:00','10:00:00','A350','available','T2',1015),(1139,'Hong Kong','Amsterdam','2023-07-22','15:30:00','22:20:00','B737 ','available','T3',1015),(1140,'Bangkok','Amsterdam','2023-07-19','01:30:00','08:00:00','A320','available','T4',1015),(1141,'Seoul','Dubai','2023-07-25','07:45:00','17:00:00','A320','available','T1',1015),(1142,'Mexico City','Dubai','2023-07-25','02:30:00','08:00:00','B787','available','T4',1015),(1143,'Karachi','Dubai','2023-07-19','08:00:00','13:30:00','A380','available','T3',1015),(1144,'Toronto','Dubai','2023-07-30','04:10:00','09:00:00','B737 ','available','T2',1015),(1145,'Lahore','Dubai','2023-07-23','22:10:00','09:30:00','A350','available','T1',1015),(1146,'Dubai','Moscow','2023-07-20','03:20:00','11:00:00','A320','available','T3',1015),(1147,'Bangkok','Moscow','2023-07-29','15:20:00','20:20:00','B787','available','T4',1015),(1148,'Karachi ','Moscow','2023-07-25','18:00:00','04:00:00','A380','available','T4',1015),(1149,'Hong Kong','Moscow','2023-07-24','06:20:00','13:00:00','A380','available','T2',1015),(1150,'Seoul','Moscow','2023-07-25','02:00:00','10:45:00','B737 ','available','T1',1015);
/*!40000 ALTER TABLE `flight` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `passenger_contact_number`
--

DROP TABLE IF EXISTS `passenger_contact_number`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `passenger_contact_number` (
  `ticket_id` int NOT NULL,
  `contact_number` int NOT NULL,
  PRIMARY KEY (`ticket_id`,`contact_number`),
  CONSTRAINT `ticketIDCascadeDelete` FOREIGN KEY (`ticket_id`) REFERENCES `ticket` (`ticket_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `passenger_contact_number`
--

LOCK TABLES `passenger_contact_number` WRITE;
/*!40000 ALTER TABLE `passenger_contact_number` DISABLE KEYS */;
/*!40000 ALTER TABLE `passenger_contact_number` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `ticket_id` int NOT NULL,
  PRIMARY KEY (`payment_id`),
  UNIQUE KEY `ticket_id_UNIQUE` (`ticket_id`),
  CONSTRAINT `paymentCascadeDelete` FOREIGN KEY (`ticket_id`) REFERENCES `ticket` (`ticket_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_card_info`
--

DROP TABLE IF EXISTS `payment_card_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_card_info` (
  `card_number` int NOT NULL,
  `card_expiry_date` date NOT NULL,
  PRIMARY KEY (`card_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_card_info`
--

LOCK TABLES `payment_card_info` WRITE;
/*!40000 ALTER TABLE `payment_card_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment_card_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_details`
--

DROP TABLE IF EXISTS `payment_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_details` (
  `ticketID` int NOT NULL,
  `amount` int NOT NULL,
  `card_number` int NOT NULL,
  PRIMARY KEY (`ticketID`),
  KEY `card_number_idx` (`card_number`),
  CONSTRAINT `paymentdetailsCascadeDelete` FOREIGN KEY (`card_number`) REFERENCES `payment_card_info` (`card_number`) ON DELETE CASCADE,
  CONSTRAINT `paymentticketCascadeDelete` FOREIGN KEY (`ticketID`) REFERENCES `ticket` (`ticket_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_details`
--

LOCK TABLES `payment_details` WRITE;
/*!40000 ALTER TABLE `payment_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket`
--

DROP TABLE IF EXISTS `ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticket` (
  `ticket_id` int NOT NULL AUTO_INCREMENT,
  `meal` varchar(20) NOT NULL,
  `passengerName` varchar(30) NOT NULL,
  `customerID` int NOT NULL,
  `flightID` int NOT NULL,
  `class` varchar(10) NOT NULL,
  PRIMARY KEY (`ticket_id`),
  KEY `customerFK_idx` (`customerID`),
  KEY `flightFK` (`flightID`),
  KEY `class` (`class`),
  CONSTRAINT `ticketclassCascadeDelete` FOREIGN KEY (`class`) REFERENCES `class` (`class`) ON DELETE CASCADE,
  CONSTRAINT `ticketcustomeridCascadeDelete` FOREIGN KEY (`customerID`) REFERENCES `customer` (`customer_id`) ON DELETE CASCADE,
  CONSTRAINT `ticketflightidCascadeDelete` FOREIGN KEY (`flightID`) REFERENCES `flight` (`flight_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4531 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket`
--

LOCK TABLES `ticket` WRITE;
/*!40000 ALTER TABLE `ticket` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `email` varchar(50) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  CONSTRAINT `email1` FOREIGN KEY (`email`) REFERENCES `user_info` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=1025 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1017,'ali103@gmail.com'),(1020,'basit7869@gmail.com'),(1023,'hasnainlai45@gmail.com'),(1012,'hmzmohi2003@gmail.com'),(1021,'jawwad55686@gmail.com'),(1022,'maazhsi45@gmail.com'),(1024,'osmanbey@gmail.com'),(1019,'saad113@gmail.com'),(1015,'takensol@takensol.com'),(1016,'usaidsid@gmail.com'),(1018,'Yaseen345@gmail.com');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `user_customer_info`
--

DROP TABLE IF EXISTS `user_customer_info`;
/*!50001 DROP VIEW IF EXISTS `user_customer_info`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `user_customer_info` AS SELECT 
 1 AS `user_id`,
 1 AS `email`,
 1 AS `first_name`,
 1 AS `last_name`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `user_flight_info`
--

DROP TABLE IF EXISTS `user_flight_info`;
/*!50001 DROP VIEW IF EXISTS `user_flight_info`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `user_flight_info` AS SELECT 
 1 AS `user_id`,
 1 AS `email`,
 1 AS `first_name`,
 1 AS `last_name`,
 1 AS `flight_id`,
 1 AS `source`,
 1 AS `destination`,
 1 AS `date`,
 1 AS `departure_time`,
 1 AS `arrival_time`,
 1 AS `airplane_name`,
 1 AS `status`,
 1 AS `terminal`,
 1 AS `ticket_id`,
 1 AS `meal`,
 1 AS `passengerName`,
 1 AS `class`,
 1 AS `contact_numbers`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `user_info`
--

DROP TABLE IF EXISTS `user_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_info` (
  `email` varchar(50) NOT NULL,
  `password` text,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_info`
--

LOCK TABLES `user_info` WRITE;
/*!40000 ALTER TABLE `user_info` DISABLE KEYS */;
INSERT INTO `user_info` VALUES ('ali103@gmail.com','$2b$10$tOeZwEWopx5Z2op027QWd.Y89zkmcT0Q01LgBgnCEEUxCU8hj7qIC'),('basit7869@gmail.com','$2b$10$zWFwRMs/KYJLTN/Xpqu86.aTzAvvziGzl.001TBNK75PmG5UIpcP2'),('hasnainlai45@gmail.com','$2b$10$JEI6TafrkXvr2kjPR8peTuDn8JbjgFcdcuuLePrIhTQGz5UxJ5R9.'),('hmzmohi2003@gmail.com','$2b$10$y5rR668uPMuDzcahvR3QT.Kkh2vtJPMkTplwDqeKhWyP9bhMwvkny'),('jawwad55686@gmail.com','$2b$10$H1BeuvwkmFpp8a1EKe.g6eqPQ6WRmsi/WDc5Iy8Sm3y6ZqJzqPWaC'),('maazhsi45@gmail.com','$2b$10$el66ovLkvcIGP0H9srLX2ObiEV2qnuSrJ1KAINBLXjm71Ze/8xrze'),('osmanbey@gmail.com','$2b$10$0ww.e/l/cQK93y1L8jEWUO7g3XMa/4n/Qhli6Lb4RS2SkI2xuhmD2'),('saad113@gmail.com','$2b$10$xvFirc4B6fMMP6Sh2VnP.OsmOEl5BuiUrTNIYteXHZ7Zyy.goRPNO'),('takensol@takensol.com','12345'),('usaidsid@gmail.com','$2b$10$K4Ne6tCEXc1xM2FZoHmTku3sprsRlNInVTY8Gh9gqnhJ64.jU0AKW'),('Yaseen345@gmail.com','$2b$10$3OWgLEASEAuF6S5RHB6XtuBEpONLvJpRXwynvPdWv4V6eazEf4T5u');
/*!40000 ALTER TABLE `user_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `discounted`
--

/*!50001 DROP VIEW IF EXISTS `discounted`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `discounted` AS select `f`.`flight_id` AS `flight_id`,`f`.`destination` AS `destination`,`f`.`date` AS `date`,`f`.`departure_time` AS `departure_time`,`c`.`price` AS `price`,`c`.`discount` AS `discount`,`c`.`class` AS `class` from (`flight` `f` join `class` `c` on((`f`.`flight_id` = `c`.`flight_id`))) where ((`c`.`discount` > 0) and (`f`.`status` = 'available') and (`c`.`seats_left` > 0)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `user_customer_info`
--

/*!50001 DROP VIEW IF EXISTS `user_customer_info`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `user_customer_info` AS select `u`.`ID` AS `user_id`,`ui`.`email` AS `email`,`c`.`first_name` AS `first_name`,`c`.`last_name` AS `last_name` from ((`user_info` `ui` join `user` `u` on((`ui`.`email` = `u`.`email`))) left join `customer` `c` on((`u`.`ID` = `c`.`customer_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `user_flight_info`
--

/*!50001 DROP VIEW IF EXISTS `user_flight_info`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `user_flight_info` AS select `u`.`ID` AS `user_id`,`u`.`email` AS `email`,`c`.`first_name` AS `first_name`,`c`.`last_name` AS `last_name`,`f`.`flight_id` AS `flight_id`,`f`.`source` AS `source`,`f`.`destination` AS `destination`,`f`.`date` AS `date`,`f`.`departure_time` AS `departure_time`,`f`.`arrival_time` AS `arrival_time`,`f`.`airplane_name` AS `airplane_name`,`f`.`status` AS `status`,`f`.`terminal` AS `terminal`,`t`.`ticket_id` AS `ticket_id`,`t`.`meal` AS `meal`,`t`.`passengerName` AS `passengerName`,`t`.`class` AS `class`,group_concat(`pc`.`contact_number` separator ', ') AS `contact_numbers` from (((((`user` `u` join `customer` `c` on((`u`.`ID` = `c`.`customer_id`))) join `customer_booked_flights` `cbf` on((`c`.`customer_id` = `cbf`.`customer_ID`))) join `flight` `f` on((`cbf`.`flightID` = `f`.`flight_id`))) join `ticket` `t` on(((`f`.`flight_id` = `t`.`flightID`) and (`c`.`customer_id` = `t`.`customerID`)))) left join `passenger_contact_number` `pc` on((`t`.`ticket_id` = `pc`.`ticket_id`))) group by `u`.`ID`,`t`.`ticket_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-07-18 23:39:12
