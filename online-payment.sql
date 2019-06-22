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
SET
  NAMES utf8mb4;
SET
  FOREIGN_KEY_CHECKS = 0;
DROP DATABASE IF EXISTS `OnlinePayment`;
  /*******************************************************************************
           Create database
        ********************************************************************************/
  CREATE DATABASE `OnlinePayment` CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `OnlinePayment`;
-- ----------------------------
  -- Table structure for Administrator
  -- ----------------------------
  DROP TABLE IF EXISTS `Administrator`;
CREATE TABLE `Administrator` (
    `AdministratorId` int(11) NOT NULL AUTO_INCREMENT,
    `LoginPassword` varchar(150) NOT NULL,
    `AuthenticationPassword` varchar(150) NOT NULL,
    `UserName` varchar(40) NOT NULL,
    `TypeId` int(11) NOT NULL,
    `Permission` int(11) NOT NULL,
    PRIMARY KEY (`AdministratorId`)
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8 COLLATE = utf8_general_ci;
-- ----------------------------
  -- Table structure for Buyer
  -- ----------------------------
  DROP TABLE IF EXISTS `Buyer`;
CREATE TABLE `Buyer` (
    `BuyerId` int(11) NOT NULL AUTO_INCREMENT,
    `LoginPassword` varchar(120) NOT NULL,
    `PayPassword` varchar(120) NOT NULL,
    `Balance` decimal(25, 2) NOT NULL,
    `UserName` varchar(40) NOT NULL,
    `RealName` varchar(20) NOT NULL,
    `CitizenId` varchar(40) NOT NULL,
    `TypeId` int(11) NOT NULL,
    `Email` varchar(60) NOT NULL,
    `Phone` varchar(24) NOT NULL,
    `Point` int(11) NOT NULL,
    `Valid` int(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`BuyerId`)
  ) ENGINE = InnoDB;
-- ----------------------------
  -- Table structure for CitizenIdentity
  -- ----------------------------
  DROP TABLE IF EXISTS `CitizenIdentity`;
CREATE TABLE `CitizenIdentity` (
    `RealName` varchar(20) NOT NULL,
    `CitizenId` varchar(40) NOT NULL,
    PRIMARY KEY (`CitizenId`)
  ) ENGINE = InnoDB;
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
    `Price` double(10, 2) NOT NULL,
    `SellerID` int(11) NOT NULL,
    `IsReview` tinyint(1) DEFAULT NULL,
    PRIMARY KEY (`GoodID`),
    KEY `SellerID` (`SellerID`),
    CONSTRAINT `good_ibfk_1` FOREIGN KEY (`SellerID`) REFERENCES `seller` (`SellerId`)
  ) ENGINE = InnoDB;
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
    `Amount` decimal(25, 2) NOT NULL,
    PRIMARY KEY (`OrderNo`),
    KEY `BuyerID` (`BuyerID`),
    KEY `SellerID` (`SellerID`),
    KEY `GoodID` (`GoodID`),
    CONSTRAINT `order_ibfk_1` FOREIGN KEY (`BuyerID`) REFERENCES `buyer` (`BuyerId`),
    CONSTRAINT `order_ibfk_2` FOREIGN KEY (`SellerID`) REFERENCES `seller` (`SellerId`),
    CONSTRAINT `order_ibfk_3` FOREIGN KEY (`GoodID`) REFERENCES `Good` (`GoodID`)
  ) ENGINE = InnoDB;
CREATE VIEW SellerOrder AS
SELECT
  `OrderNo`,
  `SellerId`,
  `GoodID`,
  `Numbers`,
  `OrderState`,
  `OrderTime`,
  `PayTime`,
  `DeliverTime`,
  `CancelTime`,
  `SuccessTime`,
  `Amount`
FROM
  `Order`;
CREATE VIEW BuyerOrder AS
SELECT
  `OrderNo`,
  `BuyerId`,
  `GoodID`,
  `Numbers`,
  `OrderState`,
  `OrderTime`,
  `PayTime`,
  `DeliverTime`,
  `CancelTime`,
  `SuccessTime`,
  `Amount`
FROM
  `Order`;
-- ----------------------------
  -- Table structure for Seller
  -- ----------------------------
  DROP TABLE IF EXISTS `Seller`;
CREATE TABLE `Seller` (
    `SellerId` int(11) NOT NULL AUTO_INCREMENT,
    `LoginPassword` varchar(120) NOT NULL,
    `PayPassword` varchar(120) NOT NULL,
    `Balance` decimal(25, 2) NOT NULL,
    `UserName` varchar(40) NOT NULL,
    `RealName` varchar(20) NOT NULL,
    `CitizenId` varchar(40) NOT NULL,
    `Email` varchar(60) NOT NULL,
    `Phone` varchar(24) NOT NULL,
    `Valid` int(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (`SellerId`)
  ) ENGINE = InnoDB;
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
INSERT INTO
  `Buyer` (
    `LoginPassword`,
    `PayPassword`,
    `Balance`,
    `UserName`,
    `RealName`,
    `CitizenId`,
    `TypeId`,
    `Email`,
    `Phone`,
    `Point`
  )
VALUES
  (
    '7c4a8d09ca3762af61e59520943dc26494f8941b',
    '7c4a8d09ca3762af61e59520943dc26494f8941b',
    0,
    'Zhang',
    'ZhangSan',
    '110000199801011010',
    0,
    '123456@qq.com',
    '13112345678',
    0
  );
INSERT INTO
  `Seller` (
    `LoginPassword`,
    `PayPassword`,
    `Balance`,
    `UserName`,
    `RealName`,
    `CitizenId`,
    `Email`,
    `Phone`
  )
VALUES
  (
    '7c4a8d09ca3762af61e59520943dc26494f8941b',
    '7c4a8d09ca3762af61e59520943dc26494f8941b',
    0,
    'Li',
    'LiSi',
    '110000199801011012',
    '123457@qq.com',
    '13112345679'
  );
INSERT INTO
  `CitizenIdentity` (`RealName`, `CitizenId`)
VALUES
  ('ZhangSan', '110000199801011010');
INSERT INTO
  `CitizenIdentity` (`RealName`, `CitizenId`)
VALUES
  ('LiSi', '110000199801011012');
INSERT INTO
  `CitizenIdentity` (`RealName`, `CitizenId`)
VALUES
  ('WangWu', '110000199801011014');
INSERT INTO
  `Good` (
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  (
    "海航商务舱",
    "萧山机场",
    "普陀机场",
    "2019-03-11",
    609,
    1,
    0
  );
INSERT INTO
  `Order` (
    `BuyerId`,
    `SellerId`,
    `GoodId`,
    `Numbers`,
    `OrderState`,
    `OrderTime`,
    `Amount`
  )
VALUES
  (
    1,
    1,
    1,
    3,
    0,
    NOW(),
    1800
  );
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  (
    'Cathay 商务舱',
    'KCH',
    'CAN',
    '2019/08/11',
    1000.00,
    1,
    1
  );
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  (
    'Airasia 经济舱',
    'CAN',
    'BDO',
    '2019/07/12',
    231.00,
    1,
    1
  );
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  (
    'Airasia 经济舱',
    'CAN',
    'KUL',
    '2019/09/22',
    442.00,
    1,
    1
  );
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  (
    'Airasia 商务舱',
    'BDD',
    'CAN',
    '2019/10/30',
    499.00,
    1,
    1
  );
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  (
    'Airasia 经济舱',
    'HGH',
    'CAN',
    '2019/11/02',
    402.00,
    1,
    1
  );
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  (
    'Cathay 经济舱',
    'CAN',
    'HGH',
    '2019/12/10',
    600.00,
    1,
    1
  );
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  ('ShangriLa', 'single', NULL, '0', 450.00, 1, 1);
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  ('Shangrila', 'double', NULL, '0', 234.00, 1, 1);
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  ('Shangrila', 'single', NULL, '0', 432.00, 1, 1);
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  ('Shangrila', 'single', NULL, '0', 555.00, 1, 1);
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  ('Shangrila', 'family', NULL, '0', 234.00, 1, 1);
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  ('Shangrila', 'family', NULL, '0', 544.00, 1, 0);
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  ('Shangrila', 'double', NULL, '0', 2332.00, 1, 0);
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  (
    'Cathay 经济舱',
    'IDR',
    'KUL',
    '2019/07/20',
    388.00,
    1,
    1
  );
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  (
    'Cathay 商务舱',
    'KCH',
    'CAN',
    '2019/08/11',
    1000.00,
    1,
    1
  );
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  (
    'Airasia 经济舱',
    'CAN',
    'BDO',
    '2019/07/12',
    231.00,
    1,
    1
  );
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  (
    'Airasia 经济舱',
    'CAN',
    'KUL',
    '2019/09/22',
    442.00,
    1,
    1
  );
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  (
    'Airasia 商务舱',
    'BDD',
    'CAN',
    '2019/10/30',
    499.00,
    1,
    1
  );
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  (
    'Airasia 经济舱',
    'HGH',
    'CAN',
    '2019/11/02',
    402.00,
    1,
    1
  );
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  (
    'Cathay 经济舱',
    'CAN',
    'HGH',
    '2019/12/10',
    600.00,
    1,
    1
  );
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  ('ShangriLa', 'single', NULL, '0', 450.00, 1, 1);
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  ('Shangrila', 'double', NULL, '0', 234.00, 1, 1);
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  ('Shangrila', 'single', NULL, '0', 432.00, 1, 1);
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  ('Shangrila', 'single', NULL, '0', 555.00, 1, 1);
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  ('Shangrila', 'family', NULL, '0', 234.00, 1, 1);
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  ('Shangrila', 'family', NULL, '0', 544.00, 1, 0);
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  ('Shangrila', 'double', NULL, '0', 2332.00, 1, 0);
INSERT INTO
  `Good`(
    `GoodName`,
    `From`,
    `Dest`,
    `Date`,
    `Price`,
    `SellerID`,
    `IsReview`
  )
VALUES
  (
    'Cathay 经济舱',
    'IDR',
    'KUL',
    '2019/07/20',
    388.00,
    1,
    1
  );