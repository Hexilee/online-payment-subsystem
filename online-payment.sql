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
    7,
    6,
    2,
    NOW(),
    8701
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
    2,
    19,
    0,
    NOW(),
    5528
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
    3,
    8,
    1,
    NOW(),
    2701
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
    8,
    8,
    3,
    NOW(),
    4258
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
    14,
    3,
    NOW(),
    6848
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
    2,
    10,
    1,
    NOW(),
    6152
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
    5,
    0,
    1,
    NOW(),
    5765
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
    8,
    18,
    0,
    NOW(),
    8785
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
    9,
    2,
    1,
    NOW(),
    6166
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
    6,
    15,
    0,
    NOW(),
    6896
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
    4,
    9,
    3,
    NOW(),
    1283
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
    6,
    7,
    2,
    NOW(),
    2911
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
    0,
    13,
    1,
    NOW(),
    9076
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
    3,
    16,
    0,
    NOW(),
    4229
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
    7,
    18,
    2,
    NOW(),
    941
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
    3,
    9,
    2,
    NOW(),
    1710
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
    8,
    18,
    0,
    NOW(),
    3415
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
    6,
    7,
    2,
    NOW(),
    7136
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
    9,
    19,
    2,
    NOW(),
    9372
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
    8,
    6,
    2,
    NOW(),
    6001
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
    8,
    1,
    NOW(),
    1228
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
    0,
    16,
    3,
    NOW(),
    8397
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
    7,
    9,
    1,
    NOW(),
    4109
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
    7,
    16,
    3,
    NOW(),
    709
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
    0,
    9,
    1,
    NOW(),
    669
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
    5,
    12,
    2,
    NOW(),
    1230
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
    3,
    3,
    0,
    NOW(),
    2181
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
    5,
    17,
    1,
    NOW(),
    4723
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
    19,
    0,
    NOW(),
    6725
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
    5,
    1,
    3,
    NOW(),
    8551
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
    9,
    1,
    NOW(),
    2578
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
    7,
    14,
    0,
    NOW(),
    6006
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
    9,
    19,
    2,
    NOW(),
    2640
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
    0,
    10,
    3,
    NOW(),
    6874
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
    6,
    15,
    1,
    NOW(),
    8227
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
    6,
    15,
    3,
    NOW(),
    6562
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
    6,
    10,
    0,
    NOW(),
    5850
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
    5,
    1,
    0,
    NOW(),
    1648
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
    9,
    19,
    1,
    NOW(),
    7382
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
    8,
    16,
    3,
    NOW(),
    4163
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
    0,
    3,
    0,
    NOW(),
    3492
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
    3,
    8,
    3,
    NOW(),
    2535
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
    3,
    12,
    2,
    NOW(),
    6989
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
    9,
    18,
    2,
    NOW(),
    3084
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
    5,
    12,
    3,
    NOW(),
    8612
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
    0,
    11,
    1,
    NOW(),
    6977
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
    7,
    9,
    3,
    NOW(),
    5832
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
    7,
    7,
    2,
    NOW(),
    9695
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
    8,
    10,
    1,
    NOW(),
    1637
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
    6,
    2,
    3,
    NOW(),
    3579
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
    9,
    17,
    1,
    NOW(),
    3532
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
    9,
    15,
    3,
    NOW(),
    7528
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
    0,
    8,
    3,
    NOW(),
    1407
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
    5,
    16,
    0,
    NOW(),
    4398
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
    2,
    3,
    3,
    NOW(),
    8249
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
    5,
    19,
    3,
    NOW(),
    4868
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
    0,
    19,
    0,
    NOW(),
    4125
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
    5,
    8,
    0,
    NOW(),
    6475
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
    8,
    9,
    2,
    NOW(),
    192
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
    9,
    6,
    3,
    NOW(),
    1318
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
    6,
    0,
    NOW(),
    8155
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
    3,
    12,
    3,
    NOW(),
    2931
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
    4,
    0,
    NOW(),
    826
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
    7,
    5,
    1,
    NOW(),
    9146
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
    11,
    3,
    NOW(),
    4864
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
    7,
    3,
    3,
    NOW(),
    1701
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
    5,
    16,
    0,
    NOW(),
    3861
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
    6,
    16,
    1,
    NOW(),
    6986
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
    6,
    5,
    2,
    NOW(),
    8984
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
    2,
    16,
    3,
    NOW(),
    4662
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
    7,
    11,
    3,
    NOW(),
    5126
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
    4,
    6,
    1,
    NOW(),
    4767
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
    3,
    18,
    0,
    NOW(),
    6262
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
    9,
    18,
    3,
    NOW(),
    7794
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
    0,
    11,
    0,
    NOW(),
    3021
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
    3,
    3,
    3,
    NOW(),
    3529
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
    9,
    19,
    0,
    NOW(),
    6966
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
    8,
    4,
    1,
    NOW(),
    5420
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
    7,
    5,
    2,
    NOW(),
    681
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
    4,
    11,
    2,
    NOW(),
    6185
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
    1,
    3,
    NOW(),
    1644
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
    15,
    2,
    NOW(),
    5895
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
    4,
    11,
    3,
    NOW(),
    8049
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
    0,
    16,
    2,
    NOW(),
    7065
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
    4,
    14,
    2,
    NOW(),
    7156
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
    9,
    16,
    2,
    NOW(),
    7051
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
    5,
    14,
    0,
    NOW(),
    9621
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
    0,
    15,
    0,
    NOW(),
    5889
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
    3,
    16,
    0,
    NOW(),
    8523
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
    2,
    7,
    1,
    NOW(),
    7794
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
    8,
    16,
    2,
    NOW(),
    4468
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
    7,
    4,
    0,
    NOW(),
    1937
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
    5,
    0,
    1,
    NOW(),
    7068
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
    4,
    17,
    0,
    NOW(),
    6459
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
    4,
    17,
    0,
    NOW(),
    8325
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
    9,
    17,
    1,
    NOW(),
    5058
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
    8,
    8,
    0,
    NOW(),
    2496
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
    3,
    1,
    2,
    NOW(),
    3062
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
    7,
    17,
    1,
    NOW(),
    1738
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
    0,
    9,
    0,
    NOW(),
    7508
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
    7,
    8,
    3,
    NOW(),
    2462
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
    4,
    19,
    3,
    NOW(),
    5260
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
    3,
    14,
    2,
    NOW(),
    376
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
    9,
    8,
    2,
    NOW(),
    7581
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
    0,
    18,
    0,
    NOW(),
    4178
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
    9,
    18,
    2,
    NOW(),
    7648
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
    5,
    18,
    0,
    NOW(),
    1453
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
    6,
    14,
    2,
    NOW(),
    9461
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
    9,
    15,
    0,
    NOW(),
    1171
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
    6,
    10,
    2,
    NOW(),
    860
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
    6,
    6,
    2,
    NOW(),
    2057
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
    9,
    17,
    3,
    NOW(),
    7406
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
    3,
    4,
    3,
    NOW(),
    8755
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
    8,
    12,
    1,
    NOW(),
    9125
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
    9,
    0,
    1,
    NOW(),
    4920
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
    2,
    3,
    0,
    NOW(),
    7363
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
    3,
    14,
    2,
    NOW(),
    6678
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
    5,
    12,
    0,
    NOW(),
    9188
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
    9,
    12,
    0,
    NOW(),
    6056
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
    5,
    2,
    1,
    NOW(),
    4214
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
    4,
    1,
    NOW(),
    6303
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
    5,
    17,
    1,
    NOW(),
    7331
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
    8,
    1,
    3,
    NOW(),
    4892
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
    12,
    0,
    NOW(),
    4875
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
    4,
    17,
    3,
    NOW(),
    2472
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
    5,
    0,
    0,
    NOW(),
    1982
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
    6,
    5,
    1,
    NOW(),
    3693
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
    8,
    16,
    0,
    NOW(),
    8533
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
    9,
    2,
    3,
    NOW(),
    9802
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
    9,
    5,
    1,
    NOW(),
    7472
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
    5,
    13,
    3,
    NOW(),
    5821
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
    9,
    3,
    NOW(),
    8180
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
    4,
    15,
    3,
    NOW(),
    5028
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
    7,
    2,
    2,
    NOW(),
    6586
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
    4,
    14,
    2,
    NOW(),
    9293
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
    8,
    9,
    1,
    NOW(),
    1555
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
    3,
    3,
    3,
    NOW(),
    8810
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
    2,
    0,
    2,
    NOW(),
    1832
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
    14,
    3,
    NOW(),
    8588
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
    6,
    8,
    3,
    NOW(),
    3941
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
    3,
    12,
    3,
    NOW(),
    4928
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
    8,
    15,
    2,
    NOW(),
    1551
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
    12,
    1,
    NOW(),
    8748
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
    0,
    15,
    3,
    NOW(),
    9882
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
    6,
    11,
    3,
    NOW(),
    438
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
    2,
    8,
    0,
    NOW(),
    9402
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
    2,
    16,
    1,
    NOW(),
    8930
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
    6,
    7,
    2,
    NOW(),
    5362
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
    4,
    8,
    2,
    NOW(),
    8964
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
    8,
    11,
    3,
    NOW(),
    1173
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
    3,
    7,
    0,
    NOW(),
    2772
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
    2,
    16,
    0,
    NOW(),
    7643
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
    8,
    14,
    0,
    NOW(),
    1274
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
    5,
    2,
    3,
    NOW(),
    9195
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
    1,
    0,
    NOW(),
    4950
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
    4,
    9,
    3,
    NOW(),
    6866
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
    9,
    19,
    3,
    NOW(),
    4846
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
    8,
    1,
    3,
    NOW(),
    379
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
    15,
    3,
    NOW(),
    8968
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
    3,
    2,
    2,
    NOW(),
    8558
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
    8,
    7,
    3,
    NOW(),
    647
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
    4,
    14,
    0,
    NOW(),
    2999
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
    0,
    5,
    3,
    NOW(),
    2846
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
    4,
    19,
    2,
    NOW(),
    7694
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
    3,
    16,
    1,
    NOW(),
    8005
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
    7,
    19,
    3,
    NOW(),
    7441
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
    10,
    0,
    NOW(),
    4443
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
    3,
    7,
    1,
    NOW(),
    9618
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
    4,
    17,
    0,
    NOW(),
    8312
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
    3,
    5,
    0,
    NOW(),
    8241
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
    5,
    8,
    3,
    NOW(),
    122
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
    7,
    18,
    3,
    NOW(),
    7411
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
    4,
    6,
    2,
    NOW(),
    5374
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
    6,
    2,
    3,
    NOW(),
    2248
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
    6,
    13,
    3,
    NOW(),
    2703
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
    9,
    3,
    3,
    NOW(),
    6233
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
    2,
    18,
    3,
    NOW(),
    4907
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
    0,
    15,
    2,
    NOW(),
    2137
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
    2,
    2,
    0,
    NOW(),
    6630
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
    6,
    4,
    2,
    NOW(),
    3100
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
    8,
    8,
    1,
    NOW(),
    597
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
    2,
    16,
    3,
    NOW(),
    1237
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
    4,
    6,
    0,
    NOW(),
    4239
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
    0,
    1,
    2,
    NOW(),
    3002
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
    0,
    4,
    1,
    NOW(),
    4667
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
    4,
    0,
    0,
    NOW(),
    4314
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
    7,
    6,
    1,
    NOW(),
    4285
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
    3,
    13,
    1,
    NOW(),
    3309
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
    6,
    15,
    3,
    NOW(),
    200
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
    9,
    0,
    2,
    NOW(),
    6307
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
    1,
    1,
    NOW(),
    1211
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
    5,
    14,
    2,
    NOW(),
    6805
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
    4,
    16,
    0,
    NOW(),
    1862
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
    5,
    1,
    3,
    NOW(),
    5887
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
    9,
    5,
    3,
    NOW(),
    4296
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
    3,
    11,
    1,
    NOW(),
    4063
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
    4,
    12,
    2,
    NOW(),
    6236
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
    2,
    15,
    0,
    NOW(),
    3899
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
    6,
    19,
    0,
    NOW(),
    2098
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
    8,
    16,
    1,
    NOW(),
    628
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
    5,
    19,
    1,
    NOW(),
    7540
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
    7,
    16,
    2,
    NOW(),
    8128
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
    19,
    3,
    NOW(),
    1469
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
    6,
    15,
    3,
    NOW(),
    248
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
    6,
    6,
    3,
    NOW(),
    8988
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
    2,
    15,
    1,
    NOW(),
    8985
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
    7,
    11,
    3,
    NOW(),
    2706
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
    3,
    1,
    3,
    NOW(),
    684
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
    6,
    18,
    1,
    NOW(),
    5144
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
    6,
    9,
    0,
    NOW(),
    8088
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
    6,
    14,
    3,
    NOW(),
    1477
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
    3,
    7,
    1,
    NOW(),
    2195
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
    0,
    3,
    3,
    NOW(),
    3916
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
    17,
    3,
    NOW(),
    3710
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
    5,
    3,
    2,
    NOW(),
    1246
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
    8,
    1,
    2,
    NOW(),
    9359
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
    4,
    6,
    2,
    NOW(),
    6319
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
    7,
    5,
    0,
    NOW(),
    1484
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
    0,
    14,
    0,
    NOW(),
    9958
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
    5,
    3,
    1,
    NOW(),
    3681
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
    5,
    2,
    1,
    NOW(),
    7069
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
    4,
    0,
    2,
    NOW(),
    2566
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
    8,
    10,
    0,
    NOW(),
    1495
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
    7,
    12,
    3,
    NOW(),
    7421
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
    14,
    3,
    NOW(),
    240
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
    0,
    5,
    3,
    NOW(),
    7746
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
    4,
    18,
    1,
    NOW(),
    7789
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
    3,
    11,
    0,
    NOW(),
    3413
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
    6,
    18,
    1,
    NOW(),
    2629
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
    2,
    4,
    0,
    NOW(),
    3925
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
    9,
    18,
    1,
    NOW(),
    8470
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
    9,
    18,
    2,
    NOW(),
    351
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
    5,
    19,
    0,
    NOW(),
    8517
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
    8,
    3,
    2,
    NOW(),
    9313
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
    8,
    2,
    1,
    NOW(),
    706
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
    13,
    1,
    NOW(),
    2093
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
    7,
    8,
    1,
    NOW(),
    9087
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
    8,
    4,
    2,
    NOW(),
    4982
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
    3,
    15,
    2,
    NOW(),
    5622
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
    0,
    14,
    1,
    NOW(),
    7483
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
    0,
    2,
    2,
    NOW(),
    1108
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
    8,
    11,
    3,
    NOW(),
    2775
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
    3,
    16,
    1,
    NOW(),
    1400
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
    5,
    0,
    NOW(),
    8306
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
    8,
    10,
    0,
    NOW(),
    5990
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
    6,
    16,
    0,
    NOW(),
    4861
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
    9,
    7,
    2,
    NOW(),
    2552
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
    4,
    11,
    1,
    NOW(),
    6175
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
    3,
    14,
    3,
    NOW(),
    3774
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
    9,
    8,
    1,
    NOW(),
    5718
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
    6,
    11,
    3,
    NOW(),
    4389
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
    5,
    16,
    0,
    NOW(),
    4485
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
    8,
    16,
    3,
    NOW(),
    2374
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
    6,
    0,
    1,
    NOW(),
    7301
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
    7,
    9,
    3,
    NOW(),
    166
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
    9,
    13,
    2,
    NOW(),
    5184
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
    8,
    1,
    1,
    NOW(),
    9534
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
    5,
    15,
    3,
    NOW(),
    9608
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
    5,
    10,
    1,
    NOW(),
    9355
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
    3,
    13,
    3,
    NOW(),
    2536
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
    0,
    3,
    2,
    NOW(),
    9551
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
    19,
    1,
    NOW(),
    1441
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
    2,
    3,
    0,
    NOW(),
    5940
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
    3,
    18,
    1,
    NOW(),
    8784
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
    3,
    6,
    0,
    NOW(),
    4314
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
    8,
    4,
    2,
    NOW(),
    8925
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
    4,
    2,
    3,
    NOW(),
    963
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
    3,
    7,
    0,
    NOW(),
    8955
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
    6,
    15,
    0,
    NOW(),
    9532
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
    9,
    6,
    2,
    NOW(),
    9789
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
    2,
    2,
    0,
    NOW(),
    9635
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
    0,
    15,
    3,
    NOW(),
    2104
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
    2,
    5,
    0,
    NOW(),
    4513
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
    5,
    1,
    3,
    NOW(),
    8981
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
    0,
    1,
    3,
    NOW(),
    8532
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
    8,
    11,
    2,
    NOW(),
    4494
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
    6,
    13,
    1,
    NOW(),
    9241
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
    0,
    19,
    1,
    NOW(),
    9376
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
    0,
    5,
    2,
    NOW(),
    6710
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
    9,
    12,
    2,
    NOW(),
    5170
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
    7,
    18,
    1,
    NOW(),
    1081
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
    6,
    3,
    3,
    NOW(),
    6571
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
    8,
    14,
    1,
    NOW(),
    2103
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
    8,
    4,
    1,
    NOW(),
    5302
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
    9,
    13,
    0,
    NOW(),
    2984
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
    8,
    2,
    2,
    NOW(),
    8660
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
    4,
    13,
    3,
    NOW(),
    3127
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
    6,
    12,
    0,
    NOW(),
    5466
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
    0,
    14,
    0,
    NOW(),
    7332
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
    14,
    3,
    NOW(),
    8550
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
    8,
    0,
    2,
    NOW(),
    2783
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
    7,
    1,
    2,
    NOW(),
    6328
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
    7,
    12,
    0,
    NOW(),
    3493
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
    7,
    7,
    3,
    NOW(),
    9602
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
    13,
    2,
    NOW(),
    2720
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
    8,
    2,
    3,
    NOW(),
    6947
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
    0,
    6,
    0,
    NOW(),
    1828
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
    3,
    10,
    3,
    NOW(),
    9787
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
    0,
    14,
    0,
    NOW(),
    8821
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
    15,
    3,
    NOW(),
    1702
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
    13,
    1,
    NOW(),
    5082
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
    0,
    12,
    2,
    NOW(),
    6838
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
    1,
    NOW(),
    9681
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
    9,
    2,
    NOW(),
    6367
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
    5,
    18,
    1,
    NOW(),
    3793
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
    2,
    3,
    2,
    NOW(),
    4702
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
    16,
    2,
    NOW(),
    1427
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
    2,
    NOW(),
    1970
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
    0,
    4,
    0,
    NOW(),
    2438
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
    5,
    4,
    2,
    NOW(),
    7638
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
    5,
    14,
    3,
    NOW(),
    7629
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
    9,
    17,
    1,
    NOW(),
    1399
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
    4,
    12,
    1,
    NOW(),
    3140
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
    7,
    0,
    1,
    NOW(),
    1030
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
    4,
    14,
    3,
    NOW(),
    7055
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
    9,
    15,
    1,
    NOW(),
    8479
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
    8,
    0,
    3,
    NOW(),
    9605
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
    3,
    13,
    1,
    NOW(),
    2656
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
    5,
    2,
    2,
    NOW(),
    8909
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
    0,
    14,
    0,
    NOW(),
    3508
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
    5,
    14,
    0,
    NOW(),
    8139
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
    6,
    14,
    1,
    NOW(),
    4214
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
    5,
    10,
    0,
    NOW(),
    6272
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
    7,
    16,
    0,
    NOW(),
    3489
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
    5,
    7,
    1,
    NOW(),
    8548
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
    4,
    12,
    1,
    NOW(),
    7264
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
    5,
    14,
    2,
    NOW(),
    7943
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
    16,
    0,
    NOW(),
    9406
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
    9,
    7,
    1,
    NOW(),
    6009
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
    8,
    6,
    2,
    NOW(),
    3381
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
    5,
    7,
    0,
    NOW(),
    6461
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
    9,
    2,
    NOW(),
    3304
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
    5,
    17,
    2,
    NOW(),
    6173
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
    9,
    2,
    0,
    NOW(),
    8146
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
    8,
    3,
    2,
    NOW(),
    1981
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
    5,
    18,
    1,
    NOW(),
    3090
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
    5,
    6,
    0,
    NOW(),
    512
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
    9,
    18,
    3,
    NOW(),
    5106
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
    5,
    15,
    0,
    NOW(),
    4105
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
    7,
    14,
    2,
    NOW(),
    6117
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
    8,
    12,
    0,
    NOW(),
    9763
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
    8,
    3,
    0,
    NOW(),
    6339
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
    5,
    12,
    2,
    NOW(),
    2098
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
    13,
    1,
    NOW(),
    1792
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
    9,
    11,
    2,
    NOW(),
    3475
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
    0,
    11,
    1,
    NOW(),
    9724
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
    5,
    2,
    1,
    NOW(),
    3050
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
    4,
    11,
    1,
    NOW(),
    7992
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
    8,
    11,
    3,
    NOW(),
    8348
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
    6,
    3,
    0,
    NOW(),
    8106
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
    3,
    10,
    0,
    NOW(),
    6892
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
    4,
    14,
    3,
    NOW(),
    4413
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
    4,
    3,
    3,
    NOW(),
    8629
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
    6,
    4,
    1,
    NOW(),
    2596
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
    3,
    2,
    0,
    NOW(),
    7729
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
    3,
    2,
    3,
    NOW(),
    8328
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
    9,
    18,
    3,
    NOW(),
    5131
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
    7,
    2,
    NOW(),
    5988
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
    0,
    13,
    3,
    NOW(),
    7004
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
    8,
    9,
    0,
    NOW(),
    827
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
    0,
    0,
    3,
    NOW(),
    8006
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
    2,
    19,
    1,
    NOW(),
    7820
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
    9,
    16,
    3,
    NOW(),
    2960
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
    6,
    4,
    2,
    NOW(),
    3948
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
    4,
    18,
    3,
    NOW(),
    4911
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
    8,
    17,
    3,
    NOW(),
    9279
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
    7,
    9,
    0,
    NOW(),
    5998
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
    4,
    11,
    0,
    NOW(),
    5686
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
    7,
    4,
    2,
    NOW(),
    9118
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
    2,
    3,
    3,
    NOW(),
    8682
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
    4,
    2,
    1,
    NOW(),
    8086
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
    2,
    16,
    1,
    NOW(),
    9475
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
    6,
    10,
    3,
    NOW(),
    8745
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
    2,
    4,
    3,
    NOW(),
    3281
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
    3,
    10,
    0,
    NOW(),
    2904
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
    0,
    10,
    2,
    NOW(),
    6841
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
    18,
    2,
    NOW(),
    3831
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
    4,
    0,
    NOW(),
    7369
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
    8,
    13,
    0,
    NOW(),
    1959
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
    17,
    1,
    NOW(),
    9737
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
    8,
    12,
    0,
    NOW(),
    8216
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
    2,
    7,
    2,
    NOW(),
    4249
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
    9,
    19,
    2,
    NOW(),
    7583
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
    5,
    13,
    0,
    NOW(),
    880
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
    5,
    10,
    3,
    NOW(),
    4213
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
    11,
    3,
    NOW(),
    3654
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
    4,
    2,
    3,
    NOW(),
    7634
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
    6,
    10,
    0,
    NOW(),
    2281
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
    3,
    3,
    0,
    NOW(),
    3409
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
    7,
    19,
    0,
    NOW(),
    768
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
    11,
    1,
    NOW(),
    5960
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
    4,
    3,
    1,
    NOW(),
    8753
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
    0,
    13,
    3,
    NOW(),
    500
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
    7,
    4,
    3,
    NOW(),
    7441
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
    7,
    18,
    3,
    NOW(),
    5394
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
    6,
    11,
    1,
    NOW(),
    1715
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
    5,
    12,
    0,
    NOW(),
    4302
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
    2,
    14,
    0,
    NOW(),
    2768
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
    0,
    19,
    1,
    NOW(),
    7912
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
    5,
    0,
    1,
    NOW(),
    9929
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
    7,
    8,
    3,
    NOW(),
    5758
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
    7,
    1,
    0,
    NOW(),
    9513
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
    8,
    5,
    0,
    NOW(),
    4248
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
    4,
    19,
    0,
    NOW(),
    4462
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
    9,
    17,
    3,
    NOW(),
    7790
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
    5,
    5,
    2,
    NOW(),
    311
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
    0,
    9,
    3,
    NOW(),
    2823
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
    0,
    12,
    3,
    NOW(),
    765
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
    0,
    5,
    1,
    NOW(),
    7555
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
    2,
    8,
    2,
    NOW(),
    8384
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
    7,
    6,
    0,
    NOW(),
    7226
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
    8,
    3,
    1,
    NOW(),
    6090
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
    7,
    4,
    2,
    NOW(),
    6777
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
    8,
    16,
    1,
    NOW(),
    4803
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
    8,
    8,
    1,
    NOW(),
    9493
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
    5,
    9,
    0,
    NOW(),
    521
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
    0,
    2,
    0,
    NOW(),
    7797
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
    7,
    9,
    0,
    NOW(),
    398
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
    4,
    5,
    2,
    NOW(),
    245
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
    1,
    1,
    NOW(),
    9342
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
    4,
    9,
    0,
    NOW(),
    5992
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
    7,
    15,
    1,
    NOW(),
    2156
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
    8,
    13,
    1,
    NOW(),
    5658
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
    6,
    15,
    0,
    NOW(),
    6360
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
    5,
    0,
    3,
    NOW(),
    2748
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
    2,
    18,
    1,
    NOW(),
    4042
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
    6,
    6,
    0,
    NOW(),
    9725
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
    0,
    6,
    3,
    NOW(),
    1865
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
    9,
    19,
    2,
    NOW(),
    1939
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
    5,
    3,
    1,
    NOW(),
    5319
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
    18,
    3,
    NOW(),
    5561
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
    9,
    5,
    3,
    NOW(),
    9194
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
    2,
    19,
    1,
    NOW(),
    4228
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
    0,
    4,
    2,
    NOW(),
    4780
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
    0,
    3,
    2,
    NOW(),
    4828
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
    7,
    5,
    1,
    NOW(),
    3612
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
    3,
    13,
    2,
    NOW(),
    8644
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
    11,
    2,
    NOW(),
    2602
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
    4,
    10,
    1,
    NOW(),
    4813
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
    8,
    7,
    0,
    NOW(),
    9282
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
    8,
    18,
    2,
    NOW(),
    5326
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
    9,
    15,
    3,
    NOW(),
    4050
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
    0,
    0,
    NOW(),
    2449
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
    0,
    11,
    0,
    NOW(),
    1355
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
    3,
    19,
    3,
    NOW(),
    1091
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
    6,
    19,
    2,
    NOW(),
    9013
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
    5,
    4,
    2,
    NOW(),
    3726
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
    8,
    5,
    2,
    NOW(),
    8731
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
    11,
    2,
    NOW(),
    7517
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
    7,
    17,
    3,
    NOW(),
    1286
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
    2,
    13,
    2,
    NOW(),
    5896
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
    7,
    0,
    0,
    NOW(),
    7578
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
    3,
    6,
    1,
    NOW(),
    3354
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
    4,
    7,
    3,
    NOW(),
    8799
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
    2,
    3,
    2,
    NOW(),
    3916
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
    5,
    1,
    NOW(),
    9867
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
    17,
    1,
    NOW(),
    8060
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
    7,
    7,
    3,
    NOW(),
    1086
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
    2,
    0,
    0,
    NOW(),
    7198
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
    6,
    5,
    0,
    NOW(),
    9101
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
    6,
    4,
    2,
    NOW(),
    4843
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
    5,
    7,
    0,
    NOW(),
    3947
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
    6,
    18,
    3,
    NOW(),
    284
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
    3,
    15,
    1,
    NOW(),
    3882
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
    6,
    9,
    3,
    NOW(),
    4866
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
    6,
    5,
    3,
    NOW(),
    401
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
    4,
    16,
    2,
    NOW(),
    1090
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
    4,
    14,
    1,
    NOW(),
    4268
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
    8,
    16,
    3,
    NOW(),
    769
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
    7,
    3,
    0,
    NOW(),
    3838
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
    4,
    11,
    1,
    NOW(),
    1173
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
    11,
    3,
    NOW(),
    7467
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
    9,
    6,
    0,
    NOW(),
    4666
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
    4,
    12,
    1,
    NOW(),
    1753
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
    17,
    2,
    NOW(),
    7742
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
    6,
    1,
    3,
    NOW(),
    6648
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
    2,
    1,
    1,
    NOW(),
    5208
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
    3,
    12,
    2,
    NOW(),
    8022
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
    7,
    19,
    3,
    NOW(),
    8378
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
    9,
    3,
    2,
    NOW(),
    8315
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
    4,
    1,
    2,
    NOW(),
    3504
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
    6,
    11,
    1,
    NOW(),
    3869
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
    9,
    18,
    1,
    NOW(),
    7925
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
    7,
    15,
    2,
    NOW(),
    2867
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
    5,
    8,
    3,
    NOW(),
    2954
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
    2,
    18,
    2,
    NOW(),
    1782
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
    2,
    2,
    NOW(),
    3564
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
    6,
    2,
    0,
    NOW(),
    8730
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
    4,
    18,
    1,
    NOW(),
    4591
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
    5,
    8,
    0,
    NOW(),
    3675
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
    4,
    15,
    3,
    NOW(),
    6907
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
    7,
    8,
    3,
    NOW(),
    3204
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
    0,
    19,
    2,
    NOW(),
    7026
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
    4,
    8,
    3,
    NOW(),
    9779
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
    8,
    18,
    0,
    NOW(),
    3192
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
    7,
    4,
    2,
    NOW(),
    2450
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
    4,
    1,
    0,
    NOW(),
    4916
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
    7,
    3,
    2,
    NOW(),
    5224
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
    2,
    5,
    1,
    NOW(),
    2314
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
    0,
    13,
    2,
    NOW(),
    8154
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
    2,
    0,
    1,
    NOW(),
    5810
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
    0,
    7,
    2,
    NOW(),
    4514
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
    8,
    19,
    2,
    NOW(),
    9013
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
    3,
    8,
    1,
    NOW(),
    1030
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
    4,
    18,
    0,
    NOW(),
    6565
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
    5,
    11,
    2,
    NOW(),
    8330
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
    4,
    7,
    1,
    NOW(),
    8099
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
    3,
    1,
    2,
    NOW(),
    8649
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
    0,
    14,
    2,
    NOW(),
    8669
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
    2,
    18,
    0,
    NOW(),
    8009
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
    2,
    3,
    2,
    NOW(),
    699
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
    8,
    17,
    3,
    NOW(),
    4726
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
    7,
    5,
    2,
    NOW(),
    3322
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
    4,
    4,
    1,
    NOW(),
    7945
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
    3,
    5,
    1,
    NOW(),
    590
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
    0,
    19,
    2,
    NOW(),
    7054
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
    2,
    9,
    2,
    NOW(),
    6555
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
    4,
    2,
    2,
    NOW(),
    8503
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
    3315
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
    7,
    6,
    1,
    NOW(),
    7367
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
    5,
    18,
    3,
    NOW(),
    7733
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
    8,
    2,
    2,
    NOW(),
    1077
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
    5,
    6,
    2,
    NOW(),
    3317
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
    5,
    3,
    3,
    NOW(),
    804
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
    8,
    14,
    0,
    NOW(),
    7821
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
    8,
    1,
    1,
    NOW(),
    4118
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
    9,
    8,
    3,
    NOW(),
    7036
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
    7,
    13,
    0,
    NOW(),
    9942
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
    5,
    1,
    3,
    NOW(),
    5171
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
    9,
    6,
    1,
    NOW(),
    4700
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
    5,
    15,
    0,
    NOW(),
    5576
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
    3,
    16,
    3,
    NOW(),
    819
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
    11,
    0,
    NOW(),
    200
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
    3,
    7,
    0,
    NOW(),
    8193
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
    5,
    1,
    3,
    NOW(),
    4265
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
    2,
    3,
    NOW(),
    9110
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
    0,
    13,
    1,
    NOW(),
    6720
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
    5,
    1,
    3,
    NOW(),
    5238
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
    9,
    14,
    0,
    NOW(),
    4644
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
    6,
    18,
    3,
    NOW(),
    8335
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
    5,
    17,
    1,
    NOW(),
    3324
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
    8,
    2,
    NOW(),
    9964
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
    9,
    10,
    3,
    NOW(),
    5393
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
    2,
    0,
    3,
    NOW(),
    9251
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
    0,
    5,
    1,
    NOW(),
    8648
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
    8,
    17,
    1,
    NOW(),
    3363
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
    3,
    0,
    1,
    NOW(),
    7213
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
    7,
    10,
    0,
    NOW(),
    7165
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
    6,
    12,
    2,
    NOW(),
    450
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
    8,
    10,
    0,
    NOW(),
    3633
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
    9,
    17,
    0,
    NOW(),
    9794
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
    0,
    13,
    1,
    NOW(),
    4416
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
    5,
    9,
    2,
    NOW(),
    6743
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
    0,
    10,
    3,
    NOW(),
    716
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
    2,
    5,
    1,
    NOW(),
    1327
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
    0,
    12,
    3,
    NOW(),
    498
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
    7,
    5,
    3,
    NOW(),
    9629
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
    2,
    10,
    2,
    NOW(),
    2270
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
    8,
    6,
    2,
    NOW(),
    956
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
    5,
    8,
    1,
    NOW(),
    439
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
    9,
    7,
    3,
    NOW(),
    2084
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
    7,
    10,
    2,
    NOW(),
    4040
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
    3,
    18,
    2,
    NOW(),
    2303
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
    4,
    3,
    2,
    NOW(),
    6488
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
    16,
    3,
    NOW(),
    2355
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
    7,
    1,
    2,
    NOW(),
    7964
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
    8,
    1,
    3,
    NOW(),
    2358
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
    4,
    7,
    3,
    NOW(),
    9298
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
    7,
    1,
    2,
    NOW(),
    5526
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
    2,
    4,
    3,
    NOW(),
    4409
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
    6,
    0,
    3,
    NOW(),
    4922
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
    6,
    1,
    1,
    NOW(),
    2618
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
    0,
    5,
    3,
    NOW(),
    690
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
    2,
    12,
    1,
    NOW(),
    2573
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
    7,
    9,
    3,
    NOW(),
    5649
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
    6,
    14,
    0,
    NOW(),
    8358
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
    7,
    4,
    0,
    NOW(),
    3038
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
    7,
    7,
    2,
    NOW(),
    8796
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
    7,
    18,
    0,
    NOW(),
    2551
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
    8,
    6,
    3,
    NOW(),
    3614
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
    6,
    19,
    1,
    NOW(),
    6785
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
    0,
    13,
    2,
    NOW(),
    898
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
    7,
    3,
    1,
    NOW(),
    1119
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
    3,
    12,
    3,
    NOW(),
    9707
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
    7,
    19,
    0,
    NOW(),
    5317
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
    6,
    0,
    1,
    NOW(),
    1783
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
    6,
    13,
    3,
    NOW(),
    9567
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
    5,
    13,
    3,
    NOW(),
    1370
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
    6,
    5,
    3,
    NOW(),
    5218
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
    8,
    9,
    3,
    NOW(),
    2103
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
    8,
    4,
    1,
    NOW(),
    1089
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
    3,
    12,
    3,
    NOW(),
    5148
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
    9,
    5,
    2,
    NOW(),
    2117
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
    5,
    11,
    0,
    NOW(),
    1729
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
    5,
    1,
    3,
    NOW(),
    950
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
    9,
    12,
    0,
    NOW(),
    1695
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
    2,
    0,
    0,
    NOW(),
    3358
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
    5,
    5,
    0,
    NOW(),
    652
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
    9,
    19,
    2,
    NOW(),
    4396
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
    0,
    7,
    1,
    NOW(),
    2544
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
    6,
    4,
    0,
    NOW(),
    3237
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
    6,
    3,
    3,
    NOW(),
    7383
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
    3,
    19,
    1,
    NOW(),
    4796
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
    0,
    7,
    2,
    NOW(),
    6914
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
    5,
    10,
    1,
    NOW(),
    7874
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
    0,
    12,
    1,
    NOW(),
    4552
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
    9,
    17,
    0,
    NOW(),
    5303
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
    5,
    10,
    0,
    NOW(),
    5414
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
    0,
    12,
    0,
    NOW(),
    4906
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
    4,
    18,
    1,
    NOW(),
    4309
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
    9,
    14,
    1,
    NOW(),
    1254
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
    7,
    16,
    0,
    NOW(),
    7905
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
    6,
    2,
    1,
    NOW(),
    4901
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
    4,
    0,
    NOW(),
    1497
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
    11,
    0,
    NOW(),
    3670
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
    9,
    17,
    0,
    NOW(),
    417
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
    2,
    7,
    1,
    NOW(),
    5852
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
    3,
    1,
    2,
    NOW(),
    8118
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
    8,
    1,
    1,
    NOW(),
    3433
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
    2,
    0,
    2,
    NOW(),
    1502
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
    7,
    5,
    1,
    NOW(),
    8670
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
    6,
    12,
    0,
    NOW(),
    4958
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
    5,
    18,
    1,
    NOW(),
    5816
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
    8,
    14,
    0,
    NOW(),
    6299
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
    7,
    12,
    1,
    NOW(),
    4510
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
    7,
    2,
    2,
    NOW(),
    1429
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
    0,
    15,
    0,
    NOW(),
    4200
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
    5,
    11,
    1,
    NOW(),
    4572
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
    9,
    19,
    2,
    NOW(),
    4098
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
    9,
    16,
    0,
    NOW(),
    514
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
    4,
    0,
    0,
    NOW(),
    4266
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
    4,
    6,
    0,
    NOW(),
    4381
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
    3,
    6,
    0,
    NOW(),
    2335
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
    0,
    15,
    3,
    NOW(),
    1002
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
    7,
    19,
    0,
    NOW(),
    5562
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
    2,
    18,
    1,
    NOW(),
    4803
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
    0,
    9,
    3,
    NOW(),
    1577
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
    3,
    17,
    0,
    NOW(),
    8498
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
    4,
    17,
    3,
    NOW(),
    9941
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
    6,
    5,
    0,
    NOW(),
    8853
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
    7,
    8,
    0,
    NOW(),
    3781
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
    7,
    7,
    1,
    NOW(),
    1699
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
    0,
    2,
    2,
    NOW(),
    3400
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
    5,
    10,
    0,
    NOW(),
    4397
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
    0,
    14,
    2,
    NOW(),
    6041
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
    7,
    13,
    3,
    NOW(),
    8523
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
    6,
    15,
    2,
    NOW(),
    5497
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
    8,
    1,
    2,
    NOW(),
    2744
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
    6,
    10,
    0,
    NOW(),
    9005
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
    8,
    2,
    NOW(),
    9370
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
    8,
    11,
    0,
    NOW(),
    4651
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
    4,
    12,
    3,
    NOW(),
    3638
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
    9,
    13,
    3,
    NOW(),
    1805
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
    9,
    2,
    2,
    NOW(),
    7994
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
    7,
    8,
    1,
    NOW(),
    402
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
    3,
    17,
    2,
    NOW(),
    755
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
    0,
    6,
    1,
    NOW(),
    2336
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
    0,
    9,
    2,
    NOW(),
    749
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
    9,
    1,
    3,
    NOW(),
    1721
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
    4,
    1,
    1,
    NOW(),
    4037
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
    9,
    8,
    3,
    NOW(),
    2113
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
    4,
    19,
    2,
    NOW(),
    1159
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
    4,
    15,
    0,
    NOW(),
    2049
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
    2,
    13,
    3,
    NOW(),
    3996
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
    0,
    2,
    2,
    NOW(),
    1111
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
    16,
    3,
    NOW(),
    5029
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
    4,
    1,
    NOW(),
    8551
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
    3,
    3,
    2,
    NOW(),
    2508
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
    4,
    1,
    0,
    NOW(),
    3987
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
    0,
    11,
    1,
    NOW(),
    9042
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
    6,
    2,
    0,
    NOW(),
    6244
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
    14,
    3,
    NOW(),
    2816
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
    0,
    4,
    1,
    NOW(),
    8900
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
    2,
    15,
    1,
    NOW(),
    4218
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
    12,
    1,
    NOW(),
    910
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
    7,
    18,
    2,
    NOW(),
    9116
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
    6,
    2,
    0,
    NOW(),
    500
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
    5,
    6,
    1,
    NOW(),
    471
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
    6,
    8,
    2,
    NOW(),
    607
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
    6,
    4,
    3,
    NOW(),
    6708
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
    5,
    6,
    2,
    NOW(),
    7209
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
    2,
    6,
    2,
    NOW(),
    7062
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
    9,
    11,
    1,
    NOW(),
    637
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
    5,
    4,
    3,
    NOW(),
    2351
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
    3,
    0,
    0,
    NOW(),
    6729
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
    3,
    2,
    2,
    NOW(),
    8094
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
    5,
    18,
    0,
    NOW(),
    8356
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
    7,
    0,
    NOW(),
    1336
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
    9,
    13,
    2,
    NOW(),
    5608
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
    1,
    2,
    NOW(),
    8470
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
    2,
    7,
    2,
    NOW(),
    4055
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
    8,
    16,
    3,
    NOW(),
    149
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
    8,
    19,
    2,
    NOW(),
    7487
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
    3,
    12,
    3,
    NOW(),
    80
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
    0,
    6,
    1,
    NOW(),
    2043
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
    5,
    8,
    0,
    NOW(),
    1271
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
    8,
    17,
    1,
    NOW(),
    48
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
    16,
    2,
    NOW(),
    4346
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
    0,
    3,
    0,
    NOW(),
    6598
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
    0,
    16,
    2,
    NOW(),
    4652
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
    2,
    11,
    1,
    NOW(),
    9530
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
    7,
    11,
    3,
    NOW(),
    7767
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
    7,
    16,
    2,
    NOW(),
    3057
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
    6,
    14,
    2,
    NOW(),
    4937
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
    3,
    3,
    0,
    NOW(),
    7480
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
    3,
    11,
    2,
    NOW(),
    291
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
    4,
    12,
    0,
    NOW(),
    1047
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
    2,
    13,
    0,
    NOW(),
    1521
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
    6,
    15,
    3,
    NOW(),
    3115
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
    7,
    8,
    2,
    NOW(),
    4635
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
    3,
    11,
    3,
    NOW(),
    8227
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
    5,
    6,
    3,
    NOW(),
    6251
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
    3,
    6,
    3,
    NOW(),
    2081
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
    5,
    2,
    1,
    NOW(),
    209
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
    6,
    18,
    1,
    NOW(),
    4139
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
    7,
    19,
    2,
    NOW(),
    7978
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
    4,
    18,
    2,
    NOW(),
    6833
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
    9,
    7,
    1,
    NOW(),
    2534
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
    5,
    2,
    2,
    NOW(),
    81
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
    2,
    7,
    1,
    NOW(),
    9912
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
    7,
    12,
    3,
    NOW(),
    1546
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
    5,
    4,
    1,
    NOW(),
    5792
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
    0,
    0,
    2,
    NOW(),
    9715
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
    4,
    4,
    2,
    NOW(),
    6335
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
    19,
    0,
    NOW(),
    8296
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
    6,
    13,
    2,
    NOW(),
    4560
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
    12,
    1,
    NOW(),
    9679
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
    0,
    17,
    2,
    NOW(),
    8461
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
    8,
    14,
    3,
    NOW(),
    180
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
    4,
    5,
    2,
    NOW(),
    2071
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
    0,
    10,
    0,
    NOW(),
    1197
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
    2,
    17,
    0,
    NOW(),
    3729
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
    0,
    7,
    3,
    NOW(),
    2009
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
    12,
    0,
    NOW(),
    6832
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
    0,
    13,
    2,
    NOW(),
    7328
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
    9,
    9,
    0,
    NOW(),
    8359
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
    5,
    8,
    1,
    NOW(),
    2517
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
    7,
    2,
    0,
    NOW(),
    6948
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
    8,
    11,
    0,
    NOW(),
    2960
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
    3,
    17,
    2,
    NOW(),
    5642
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
    2,
    9,
    0,
    NOW(),
    3905
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
    9,
    5,
    2,
    NOW(),
    7765
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
    5,
    13,
    3,
    NOW(),
    8797
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
    0,
    4,
    1,
    NOW(),
    5678
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
    6,
    18,
    3,
    NOW(),
    4756
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
    6,
    19,
    2,
    NOW(),
    3337
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
    4,
    3,
    3,
    NOW(),
    3320
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
    7,
    6,
    1,
    NOW(),
    189
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
    4,
    4,
    2,
    NOW(),
    9155
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
    6,
    10,
    2,
    NOW(),
    3298
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
    9,
    1,
    0,
    NOW(),
    9640
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
    4,
    18,
    2,
    NOW(),
    4407
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
    8,
    2,
    1,
    NOW(),
    6618
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
    2,
    1,
    1,
    NOW(),
    4007
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
    7,
    19,
    2,
    NOW(),
    1052
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
    3,
    8,
    0,
    NOW(),
    3520
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
    5,
    7,
    2,
    NOW(),
    4546
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
    7,
    4,
    3,
    NOW(),
    1108
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
    6,
    12,
    3,
    NOW(),
    7556
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
    2,
    8,
    2,
    NOW(),
    7117
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
    4,
    8,
    0,
    NOW(),
    9784
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
    9,
    9,
    2,
    NOW(),
    3730
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
    9,
    9,
    2,
    NOW(),
    2981
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
    3,
    0,
    1,
    NOW(),
    8678
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
    8,
    10,
    0,
    NOW(),
    7985
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
    7,
    12,
    0,
    NOW(),
    684
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
    2,
    2,
    1,
    NOW(),
    520
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
    7,
    19,
    2,
    NOW(),
    9887
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
    1,
    0,
    NOW(),
    4158
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
    8,
    2,
    2,
    NOW(),
    5178
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
    4,
    12,
    0,
    NOW(),
    1885
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
    2,
    8,
    3,
    NOW(),
    4918
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
    4,
    8,
    2,
    NOW(),
    3453
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
    3,
    16,
    0,
    NOW(),
    7241
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
    2,
    19,
    2,
    NOW(),
    5973
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
    5,
    1,
    1,
    NOW(),
    7687
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
    3,
    12,
    1,
    NOW(),
    1034
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
    5,
    19,
    2,
    NOW(),
    4465
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
    10,
    1,
    NOW(),
    9153
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
    8,
    19,
    1,
    NOW(),
    8087
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
    7,
    0,
    0,
    NOW(),
    1951
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
    9,
    3,
    3,
    NOW(),
    4039
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
    0,
    1,
    1,
    NOW(),
    3722
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
    6,
    3,
    0,
    NOW(),
    2150
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
    6,
    9,
    0,
    NOW(),
    7512
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
    9,
    14,
    3,
    NOW(),
    6316
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
    3,
    1,
    1,
    NOW(),
    8432
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
    2,
    14,
    2,
    NOW(),
    4209
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
    9,
    2,
    0,
    NOW(),
    154
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
    8,
    5,
    3,
    NOW(),
    8423
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
    2,
    3,
    3,
    NOW(),
    1419
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
    8,
    18,
    1,
    NOW(),
    2127
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
    6,
    8,
    0,
    NOW(),
    9751
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
    6,
    8,
    1,
    NOW(),
    2744
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
    6,
    9,
    2,
    NOW(),
    7319
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
    3,
    10,
    0,
    NOW(),
    8355
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
    4,
    15,
    0,
    NOW(),
    6401
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
    5,
    17,
    2,
    NOW(),
    4290
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
    8,
    4,
    1,
    NOW(),
    2885
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
    8,
    15,
    2,
    NOW(),
    7999
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
    3,
    8,
    1,
    NOW(),
    9543
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
    9,
    19,
    3,
    NOW(),
    4489
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
    0,
    5,
    3,
    NOW(),
    3620
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
    3,
    11,
    3,
    NOW(),
    5071
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
    6,
    19,
    2,
    NOW(),
    3292
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
    0,
    19,
    0,
    NOW(),
    6950
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
    8,
    12,
    3,
    NOW(),
    3672
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
    2,
    17,
    0,
    NOW(),
    1532
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
    8,
    7,
    3,
    NOW(),
    7530
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
    4,
    11,
    3,
    NOW(),
    8655
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
    5,
    18,
    1,
    NOW(),
    5237
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
    8,
    3,
    1,
    NOW(),
    3440
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
    4,
    18,
    3,
    NOW(),
    5534
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
    2,
    19,
    3,
    NOW(),
    9425
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
    6,
    14,
    1,
    NOW(),
    5016
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
    5,
    16,
    1,
    NOW(),
    390
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
    3,
    11,
    3,
    NOW(),
    5771
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
    2,
    6,
    1,
    NOW(),
    9884
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
    4,
    7,
    0,
    NOW(),
    9240
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
    2,
    17,
    2,
    NOW(),
    969
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
    4,
    2,
    NOW(),
    7085
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
    3,
    13,
    0,
    NOW(),
    1280
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
    5,
    3,
    1,
    NOW(),
    3409
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
    19,
    1,
    NOW(),
    2292
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
    6,
    13,
    0,
    NOW(),
    2384
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
    6,
    4,
    0,
    NOW(),
    1601
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
    2,
    11,
    0,
    NOW(),
    2230
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
    7,
    1,
    NOW(),
    8955
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
    4,
    4,
    2,
    NOW(),
    731
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
    5,
    4,
    0,
    NOW(),
    8898
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
    10,
    3,
    NOW(),
    5981
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
    16,
    2,
    NOW(),
    8219
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
    2,
    1,
    1,
    NOW(),
    3091
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
    0,
    8,
    0,
    NOW(),
    6881
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
    3,
    2,
    2,
    NOW(),
    386
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
    3,
    9,
    2,
    NOW(),
    8638
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
    12,
    1,
    NOW(),
    1663
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
    4,
    16,
    2,
    NOW(),
    8509
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
    2,
    9,
    0,
    NOW(),
    3890
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
    0,
    12,
    0,
    NOW(),
    8121
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
    4,
    7,
    3,
    NOW(),
    7044
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
    3,
    NOW(),
    7928
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
    5,
    19,
    2,
    NOW(),
    8784
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
    6,
    3,
    0,
    NOW(),
    9455
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
    4,
    13,
    3,
    NOW(),
    9186
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
    6,
    0,
    1,
    NOW(),
    4961
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
    2,
    6,
    2,
    NOW(),
    885
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
    0,
    15,
    3,
    NOW(),
    5244
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
    0,
    12,
    3,
    NOW(),
    604
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
    19,
    0,
    NOW(),
    7227
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
    6,
    18,
    3,
    NOW(),
    1886
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
    15,
    0,
    NOW(),
    1175
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
    9,
    5,
    0,
    NOW(),
    2724
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
    3,
    2,
    0,
    NOW(),
    7366
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
    2,
    11,
    1,
    NOW(),
    7305
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
    4,
    11,
    0,
    NOW(),
    2343
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
    3,
    19,
    1,
    NOW(),
    5647
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
    12,
    2,
    NOW(),
    9584
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
    5,
    11,
    3,
    NOW(),
    4107
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
    5,
    18,
    2,
    NOW(),
    3755
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
    4,
    14,
    3,
    NOW(),
    4681
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
    8,
    0,
    NOW(),
    8727
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
    2,
    14,
    1,
    NOW(),
    4042
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
    9,
    16,
    2,
    NOW(),
    6702
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
    13,
    2,
    NOW(),
    8627
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
    6,
    0,
    1,
    NOW(),
    6580
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
    5,
    7,
    0,
    NOW(),
    6075
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
    3,
    3,
    2,
    NOW(),
    1970
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
    0,
    19,
    0,
    NOW(),
    4076
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
    6,
    3,
    0,
    NOW(),
    9558
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
    6,
    13,
    0,
    NOW(),
    8191
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
    3,
    19,
    0,
    NOW(),
    1882
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
    6,
    11,
    2,
    NOW(),
    2024
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
    0,
    6,
    2,
    NOW(),
    5299
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
    7,
    8,
    3,
    NOW(),
    8502
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
    6,
    5,
    2,
    NOW(),
    3818
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
    3,
    10,
    1,
    NOW(),
    4100
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
    4,
    6,
    1,
    NOW(),
    4756
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
    4,
    12,
    0,
    NOW(),
    7565
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
    7,
    3,
    NOW(),
    7644
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
    5,
    4,
    0,
    NOW(),
    7559
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
    0,
    10,
    1,
    NOW(),
    8846
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
    9,
    0,
    1,
    NOW(),
    2716
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
    3,
    10,
    2,
    NOW(),
    7240
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
    0,
    7,
    3,
    NOW(),
    7437
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
    8,
    10,
    2,
    NOW(),
    4545
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
    8,
    2,
    NOW(),
    5997
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
    8,
    18,
    0,
    NOW(),
    4999
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
    4,
    19,
    3,
    NOW(),
    4742
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
    9,
    4,
    0,
    NOW(),
    6090
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
    6,
    1,
    3,
    NOW(),
    5782
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
    4,
    13,
    0,
    NOW(),
    8287
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
    5,
    8,
    2,
    NOW(),
    725
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
    9,
    6,
    2,
    NOW(),
    9377
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
    5,
    7,
    2,
    NOW(),
    7866
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
    8,
    6,
    0,
    NOW(),
    8979
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
    5,
    17,
    0,
    NOW(),
    9087
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
    5,
    18,
    3,
    NOW(),
    3102
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
    5,
    15,
    3,
    NOW(),
    2576
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
    6,
    3,
    0,
    NOW(),
    6984
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
    4,
    14,
    2,
    NOW(),
    8903
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
    0,
    3,
    3,
    NOW(),
    1367
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
    4,
    19,
    3,
    NOW(),
    2082
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
    9,
    10,
    0,
    NOW(),
    8156
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
    5,
    19,
    1,
    NOW(),
    6476
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
    6,
    3,
    3,
    NOW(),
    6885
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
    9,
    18,
    0,
    NOW(),
    8943
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
    6,
    19,
    0,
    NOW(),
    8755
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
    19,
    1,
    NOW(),
    4356
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
    9,
    2,
    0,
    NOW(),
    1036
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
    2,
    11,
    1,
    NOW(),
    1823
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
    5,
    9,
    2,
    NOW(),
    8413
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
    0,
    0,
    1,
    NOW(),
    6915
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
    9,
    2,
    0,
    NOW(),
    8522
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
    7,
    11,
    1,
    NOW(),
    5894
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
    7,
    18,
    3,
    NOW(),
    2265
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
    2,
    14,
    3,
    NOW(),
    2950
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
    7,
    18,
    2,
    NOW(),
    5118
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
    6,
    8,
    3,
    NOW(),
    7329
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
    2,
    14,
    1,
    NOW(),
    8453
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
    7,
    10,
    0,
    NOW(),
    1760
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
    8,
    2,
    0,
    NOW(),
    8566
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
    3,
    0,
    2,
    NOW(),
    3508
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
    4,
    13,
    3,
    NOW(),
    2789
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
    2,
    15,
    3,
    NOW(),
    9977
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
    2,
    NOW(),
    3991
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
    0,
    9,
    2,
    NOW(),
    8201
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
    4,
    13,
    2,
    NOW(),
    4384
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
    0,
    9,
    3,
    NOW(),
    7529
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
    3,
    13,
    3,
    NOW(),
    466
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
    11,
    2,
    NOW(),
    8957
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
    6,
    8,
    0,
    NOW(),
    8746
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
    0,
    4,
    0,
    NOW(),
    7487
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
    4,
    13,
    0,
    NOW(),
    1793
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
    8,
    0,
    2,
    NOW(),
    8135
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
    3,
    16,
    2,
    NOW(),
    4286
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
    8,
    7,
    1,
    NOW(),
    2094
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
    9,
    7,
    1,
    NOW(),
    8911
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
    8,
    3,
    3,
    NOW(),
    3404
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
    3,
    4,
    3,
    NOW(),
    7603
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
    0,
    0,
    NOW(),
    9915
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
    6,
    8,
    1,
    NOW(),
    6335
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
    9,
    1,
    3,
    NOW(),
    2169
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
    4,
    2,
    NOW(),
    2883
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
    1,
    2,
    NOW(),
    1220
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
    3,
    9,
    0,
    NOW(),
    2359
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
    7,
    0,
    0,
    NOW(),
    4134
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
    0,
    1,
    3,
    NOW(),
    6210
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
    0,
    8,
    2,
    NOW(),
    7137
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
    3,
    8,
    0,
    NOW(),
    6940
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
    9,
    5,
    3,
    NOW(),
    7616
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
    3,
    14,
    3,
    NOW(),
    1142
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
    5,
    5,
    0,
    NOW(),
    1786
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
    9,
    13,
    2,
    NOW(),
    6362
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
    6,
    18,
    1,
    NOW(),
    5174
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
    2,
    10,
    1,
    NOW(),
    8285
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
    3,
    3,
    0,
    NOW(),
    7886
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
    7,
    17,
    3,
    NOW(),
    6027
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
    6,
    8,
    1,
    NOW(),
    378
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
    9,
    9,
    2,
    NOW(),
    1239
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
    0,
    9,
    1,
    NOW(),
    3763
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
    5,
    0,
    0,
    NOW(),
    7447
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
    0,
    12,
    2,
    NOW(),
    4352
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
    8,
    1,
    1,
    NOW(),
    2978
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
    1,
    2,
    NOW(),
    521
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
    6,
    5,
    0,
    NOW(),
    6347
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
    6,
    0,
    1,
    NOW(),
    3674
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
    2,
    2,
    NOW(),
    4769
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
    5,
    10,
    2,
    NOW(),
    8104
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
    8,
    10,
    3,
    NOW(),
    5467
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
    7,
    10,
    1,
    NOW(),
    4017
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
    3,
    18,
    3,
    NOW(),
    8783
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
    9,
    13,
    0,
    NOW(),
    8844
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
    0,
    12,
    0,
    NOW(),
    7259
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
    4,
    8,
    0,
    NOW(),
    1995
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
    7,
    16,
    0,
    NOW(),
    7908
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
    8,
    19,
    3,
    NOW(),
    2478
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
    2,
    17,
    0,
    NOW(),
    6861
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
    4,
    0,
    1,
    NOW(),
    6462
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
    4,
    12,
    0,
    NOW(),
    7355
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
    8,
    0,
    2,
    NOW(),
    2087
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
    5,
    14,
    0,
    NOW(),
    988
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
    3,
    2,
    3,
    NOW(),
    8708
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
    3,
    6,
    2,
    NOW(),
    4665
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
    4,
    6,
    3,
    NOW(),
    9780
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
    0,
    14,
    1,
    NOW(),
    5583
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
    0,
    12,
    2,
    NOW(),
    6234
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
    0,
    14,
    0,
    NOW(),
    6979
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
    5,
    8,
    1,
    NOW(),
    716
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
    17,
    0,
    NOW(),
    50
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
    0,
    0,
    1,
    NOW(),
    718
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
    0,
    18,
    2,
    NOW(),
    5562
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
    3,
    13,
    1,
    NOW(),
    5256
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
    9,
    7,
    2,
    NOW(),
    3631
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
    8,
    11,
    0,
    NOW(),
    9040
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
    0,
    18,
    1,
    NOW(),
    4210
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
    8,
    13,
    3,
    NOW(),
    5790
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
    9,
    11,
    3,
    NOW(),
    5392
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
    9,
    1,
    NOW(),
    1394
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
    7,
    2,
    2,
    NOW(),
    6130
  );
