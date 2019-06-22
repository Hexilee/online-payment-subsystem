/*
 Navicat Premium Data Transfer

 Source Server         : MySQL
 Source Server Type    : MySQL
 Source Server Version : 80016
 Source Host           : localhost:3306
 Source Schema         : onlineorder

 Target Server Type    : MySQL
 Target Server Version : 80016
 File Encoding         : 65001

 Date: 20/06/2019 10:15:11
*/
-- CREATE DATABASE `Test`;
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP DATABASE IF EXISTS `OnlinePayment`;

/*******************************************************************************
   Create database
********************************************************************************/
CREATE DATABASE `OnlinePayment` CHARACTER SET utf8 COLLATE utf8_general_ci;

USE `OnlinePayment`;


CREATE TABLE `Buyer`(
    `BuyerId` INT NOT NULL AUTO_INCREMENT,
    `LoginPassword` VARCHAR(120) NOT NULL,
    `PayPassword` VARCHAR(120) NOT NULL,
    `Balance` DECIMAL(25,2) NOT NULL,
    `UserName` VARCHAR(40) NOT NULL,
    `RealName` VARCHAR(20) NOT NULL,
    `CitizenId` VARCHAR(40) NOT NULL,
    `TypeId` INT NOT NULL,
    `Email` VARCHAR(60) NOT NULL,
    `Phone` VARCHAR(24) NOT NULL,
    `Point` INT NOT NULL,
    `Valid` INT NOT NULL,
    CONSTRAINT `PK_Buyer` PRIMARY KEY (`BuyerId`)
);

CREATE TABLE `Seller`(
    `SellerId` INT NOT NULL AUTO_INCREMENT,
    `LoginPassword` VARCHAR(120) NOT NULL,
    `PayPassword` VARCHAR(120) NOT NULL,
    `Balance` DECIMAL(25,2) NOT NULL,
    `UserName` VARCHAR(40) NOT NULL,
    `RealName` VARCHAR(20) NOT NULL,
    `CitizenId` VARCHAR(40) NOT NULL,
    `Email` VARCHAR(60) NOT NULL,
    `Phone` VARCHAR(24) NOT NULL,
	`Valid` INT NOT NULL,
    CONSTRAINT `PK_Seller` PRIMARY KEY (`SellerId`)
);

CREATE TABLE `Administrator`(
    `AdministratorId` INT NOT NULL AUTO_INCREMENT,
    `LoginPassword` VARCHAR(150) NOT NULL,
    `AuthenticationPassword` VARCHAR(150) NOT NULL,
    `UserName` VARCHAR(40) NOT NULL,
    `TypeId` INT NOT NULL,
    `Permission` INT NOT NULL,
    CONSTRAINT `PK_Administrator` PRIMARY KEY (`AdministratorId`)
);

CREATE TABLE `CitizenIdentity`(
    `RealName` VARCHAR(20) NOT NULL,
    `CitizenId` VARCHAR(40) NOT NULL,
    CONSTRAINT `PK_CitizenIdentity` PRIMARY KEY (`CitizenId`)
);

CREATE TABLE `UserType`(
    `TypeId` INT NOT NULL,
    `TypeName` VARCHAR(20) NOT NULL,
    `RequirementPoints` INT NOT NULL,
    `UpgradePoints` INT NOT NULL,
    CONSTRAINT `PK_UserType` PRIMARY KEY (`TypeId`)
);

CREATE TABLE `RechargeCard`(
    `Number` VARCHAR(50) NOT NULL,
    `Password` VARCHAR(120) NOT NULL,
    `Value` INT NOT NULL,
    `Used` INT NOT NULL
);


CREATE TABLE `AdministratorType`(
	`AdministratorId` INT NOT NULL ,
    `TypeId` INT NOT NULL,
    `TypeName` VARCHAR(20) NOT NULL,
    `DeleteRight` BOOLEAN NOT NULL,
    `AddRight` BOOLEAN NOT NULL,
    `ArbitrationRight` BOOLEAN NOT NULL,
    `BlacklistRight` BOOLEAN NOT NULL,
    `ViewRight` BOOLEAN NOT NULL,
    CONSTRAINT `PK_AdministratorType` PRIMARY KEY (`AdministratorId`)
);

/*******************************************************************************
   Create Foreign Keys
********************************************************************************/
ALTER TABLE `Buyer` ADD CONSTRAINT `FK_BuyerTypeId`
    FOREIGN KEY (`TypeId`) REFERENCES `UserType` (`TypeId`) ON DELETE NO ACTION ON UPDATE NO ACTION;



-- ----------------------------
-- Table structure for Comment
-- ----------------------------
/*
DROP TABLE IF EXISTS `Comment`;
CREATE TABLE `Comment` (
  `CommentID` int(11) NOT NULL,
  `GoodID` int(11) NOT NULL,
  `Score` enum('1','2','3','4','5') DEFAULT NULL,
  `CommentText` varchar(255) DEFAULT NULL,
  `Reply` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`CommentID`),
  KEY `GoodID` (`GoodID`),
  CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`GoodID`) REFERENCES `good` (`GoodID`)
) ENGINE=InnoDB ;

-- ----------------------------
-- Table structure for Company
-- ----------------------------
DROP TABLE IF EXISTS `Company`;
CREATE TABLE `Company` (
  `CompanyName` varchar(255) NOT NULL,
  `SellerID` int(11) NOT NULL,
  `Star` enum('1','2','3','4','5') DEFAULT NULL,
  PRIMARY KEY (`SellerID`,`CompanyName`),
  KEY `SellerID` (`SellerID`),
  CONSTRAINT `company_ibfk_1` FOREIGN KEY (`SellerID`) REFERENCES `seller` (`SellerId`)
) ENGINE=InnoDB ;
*/
-- ----------------------------
-- Table structure for Good
-- ----------------------------
DROP TABLE IF EXISTS `Good`;
CREATE TABLE `Good` (
  `GoodID` int(11) NOT NULL AUTO_INCREMENT,
  `GoodName` varchar(255) NOT NULL,
  `From` varchar(20) DEFAULT NULL,
  `Dest` varchar(20) DEFAULT NULL,
  `Date` char(11) NOT NULL,
  `Price` double(10,2) NOT NULL,
  `SellerID` int(11) NOT NULL,
  `IsReview` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`GoodID`),
  KEY `SellerID` (`SellerID`),
  CONSTRAINT `good_ibfk_1` FOREIGN KEY (`SellerID`) REFERENCES `seller` (`SellerId`)
) ENGINE=InnoDB ;

-- ----------------------------
-- Table structure for Order
-- ----------------------------
DROP TABLE IF EXISTS `Order`;
CREATE TABLE `Order` (
  `OrderNo` int(11) NOT NULL AUTO_INCREMENT,
  `BuyerID` int(11) NOT NULL,
  `SellerID` int(11) NOT NULL,
  `GoodID` int(11) NOT NULL,
  `Numbers` int(11) NOT NULL,
  `OrderState` int(11) NOT NULL,
  `OrderTime` timestamp NULL DEFAULT NULL,
  `PayTime` timestamp NULL DEFAULT NULL,
  `DeliverTime` timestamp NULL DEFAULT NULL,
  `CancelTime` timestamp NULL DEFAULT NULL,
  `SuccessTime` timestamp NULL DEFAULT NULL,
  `Amount` decimal(25,2) NOT NULL,
  PRIMARY KEY (`OrderNo`),
  KEY `BuyerID` (`BuyerID`),
  KEY `SellerID` (`SellerID`),
  KEY `GoodID` (`GoodID`),
  CONSTRAINT `order_ibfk_1` FOREIGN KEY (`BuyerID`) REFERENCES `buyer` (`BuyerId`),
  CONSTRAINT `order_ibfk_2` FOREIGN KEY (`SellerID`) REFERENCES `seller` (`SellerId`),
  CONSTRAINT `order_ibfk_3` FOREIGN KEY (`GoodID`) REFERENCES `Good` (`GoodID`)
) ENGINE=InnoDB;

CREATE VIEW SellerOrder AS
SELECT `OrderNo`, `SellerId`, `GoodID`, `Numbers`, `OrderState`, `OrderTime`, `PayTime`, `DeliverTime`, `CancelTime`, `SuccessTime`, `Amount`
FROM `Order`;

CREATE VIEW BuyerOrder AS
SELECT `OrderNo`, `BuyerId`, `GoodID`, `Numbers`, `OrderState`, `OrderTime`, `PayTime`, `DeliverTime`, `CancelTime`, `SuccessTime`, `Amount`
FROM `Order`;


-- ----------------------------
-- Table structure for TempGood
-- ----------------------------
/*

DROP TABLE IF EXISTS `TempGood`;
CREATE TABLE `TempGood` (
  `TempGoodID` int(11) NOT NULL,
  `GoodName` varchar(255) NOT NULL,
  `Price` double(10,2) NOT NULL,
  `SellerID` int(11) NOT NULL,
  `GoodInfo1` varchar(255) DEFAULT NULL,
  `GoodInfo2` varchar(255) DEFAULT NULL,
  `GoodInfo3` enum('经济舱','商务舱','头等舱') DEFAULT NULL,
  PRIMARY KEY (`GoodName`),
  KEY `SellerID` (`SellerID`),
  CONSTRAINT `tempgood_ibfk_1` FOREIGN KEY (`SellerID`) REFERENCES `seller` (`SellerId`)
) ENGINE=InnoDB ;

SET FOREIGN_KEY_CHECKS = 1;

*/
