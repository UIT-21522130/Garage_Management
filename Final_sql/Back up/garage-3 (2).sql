-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 16, 2023 at 04:20 PM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 7.4.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `garage-3`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `	Update_receipt_v` (IN `i_Name` VARCHAR(255), IN `i_Address` VARCHAR(255), IN `i_Phone` VARCHAR(255), IN `i_RecptDate` DATE, IN `i_LicensePlate` VARCHAR(255), IN `i_Email` VARCHAR(255))  BEGIN
    UPDATE customer c
    LEFT JOIN receiption r ON c.CusID = r.CusID
    LEFT JOIN receipt rcpt ON r.ReceiptID = rcpt.RecptID
    SET c.Name = i_Name, c.Address = i_Address,
        rcpt.Phone = i_Phone, rcpt.RecptDate = i_RecptDate,
        r.LicensePlate = i_LicensePlate, rcpt.Email = i_Email
    WHERE c.Name = i_Name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_importgoods` (IN `i_ImportDate` DATE, IN `i_ImportToteMoney` VARCHAR(255), IN `i_ImportName` VARCHAR(255), IN `i_ImportAmount` VARCHAR(255), IN `i_ImportPrice` VARCHAR(255))  BEGIN 
    DECLARE count_ImportID INT unsigned DEFAULT 1;
    DECLARE count_PartsID INT unsigned DEFAULT 1;
    DECLARE new_PartsID int unsigned ;
  
    SELECT MAX(PartsID) INTO count_PartsID FROM autoparts;
    INSERT INTO autoparts (PartsID) VALUES (count_PartsID+1);
    
    SELECT MAX(PartsID) INTO new_PartsID FROM autoparts;
      
    SELECT COALESCE(MAX(ImportID), 0) INTO count_ImportID FROM importgoods;
    
    IF count_ImportID > 0 THEN
        INSERT INTO importgoods VALUES (count_ImportID + 1, new_PartsID, i_ImportDate, i_ImportPrice, i_ImportName, i_ImportAmount, i_ImportPrice);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_receipt_v` (IN `p_Name` VARCHAR(255), IN `p_Address` VARCHAR(255), IN `p_Phone` VARCHAR(255), IN `p_RecptDate` DATE, IN `p_LicensePlate` VARCHAR(255), IN `p_Email` VARCHAR(255))  BEGIN
    DECLARE v_CusID INT;
    DECLARE v_RecptID INT;
    
    -- Insert into customer table
    INSERT INTO customer (Name, Address) VALUES (p_Name, p_Address);
    SET v_CusID = LAST_INSERT_ID();
    
    -- Insert into receiption table
    INSERT INTO receiption (CusID, LicensePlate) VALUES (v_CusID, p_LicensePlate);
    SET v_RecptID = LAST_INSERT_ID();
    
    -- Insert into receipt table
    INSERT INTO receipt (RecptID, Phone, RecptDate, Email)
    VALUES (v_RecptID, p_Phone, p_RecptDate, p_Email);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_RepairList` (IN `i_BienSoXe` VARCHAR(255), IN `i_NgaySuaChua` DATE, IN `i_VatTuPhuTung` VARCHAR(255), IN `i_SoLuong` INT(255), IN `i_GiaVT` FLOAT, IN `i_LoaiTienCong` VARCHAR(255), IN `i_GiaTC` FLOAT)  NO SQL
BEGIN 
	DECLARE new_RepairID INT unsigned ;
    DECLARE new_ReceiptID INT unsigned ;
    DECLARE new_RepairID2 INT unsigned ;
    DECLARE count_RepairID INT unsigned ;
    DECLARE new_PartsID int unsigned ;
    DECLARE new_WageID int unsigned ;
    DECLARE new_WageID2 int unsigned ;
    
    DECLARE new_RepairDeID int unsigned ;
  
  	SET new_PartsID = (SELECT PartsID
  	FROM importgoods
    WHERE importgoods.ImportName = i_VatTuPhuTung);
    
    SET new_WageID2 = (SELECT WageID from wage WHERE WageName = i_LoaiTienCong);
    
    SET new_ReceiptID = (SELECT ReceiptID FROM receiption WHERE receiption.LicensePlate = i_BienSoXe);
    
    SELECT max(WageID) 
    INTO new_WageID
  	FROM wage;
    
    SELECT max(RepairDetailID) 
    INTO new_RepairDeID
  	FROM repairdetail;
     
    /*SELECT RepairID
    INTO new_RepairID
    FROM repair INNER JOIN receiption
    ON repair.ReceiptID = receiption.ReceiptID
   	WHERE receiption.LicensePlate = i_BienSoXe;*/
    
    SELECT COUNT(*) 
    INTO count_RepairID
    from repairdetail
    WHERE repairdetail.RepairID = new_RepairID2;
    
    SELECT max(RepairID)
    INTO new_RepairID2
    from repair;
    
    INSERT INTO repair(RepairID, ReceiptID, RepairDate, TotalRepair) VALUES(new_RepairID2 + 1, new_ReceiptID, i_NgaySuaChua, count_RepairID);
	
    IF NOT EXISTS(SELECT * FROM wage WHERE WageName = i_LoaiTienCong) THEN
    INSERT INTO wage VALUES(new_WageID + 1, i_LoaiTienCong, i_GiaTC);
    INSERT into repairdetail(RepairDetailID, RepairID, WageID, PartsID, PartsAmount, PartsPrice, WageValue, TotalMoney) VALUES(new_RepairDeID + 1, new_RepairID2 + 1, new_WageID + 1, new_PartsID, i_SoLuong, i_GiaVT, i_GiaTC,i_SoLuong * i_GiaVT + i_GiaTC);
    END IF;
    
    IF EXISTS (SELECT * FROM wage WHERE WageName = i_LoaiTienCong) THEN
    INSERT into repairdetail(RepairDetailID, RepairID, WageID, PartsID, PartsAmount, PartsPrice, WageValue, TotalMoney) VALUES(new_RepairDeID + 1, new_RepairID2 + 1, new_WageID2, new_PartsID, i_SoLuong, i_GiaVT, i_GiaTC,i_SoLuong * i_GiaVT + i_GiaTC);
    END IF;
End$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Bill_Delete` (IN `i_name` VARCHAR(255), IN `i_phone` INT, IN `i_recpt_date` DATE, IN `i_license_plate` VARCHAR(255), IN `i_email` VARCHAR(255), IN `i_received_money` INT)  Begin
	DECLARE rptID VARCHAR(255) DEFAULT '';
    DECLARE rptionid VARCHAR(255) DEFAULT '';
    DECLARE m_cusid VARCHAR(255) DEFAULT '';
    
	

    SELECT DISTINCT ReceiptID
    INTO rptID
    FROM receipt
    WHERE RecptDate = i_recpt_date;   
    
    SELECT DISTINCT ReceiptID
    INTO rptionid
    FROM receiption
    WHERE LicensePlate = i_license_plate;

    SELECT DISTINCT CusID
    into m_cusid
    FROM customer
    WHERE Name = i_name AND Phone = i_phone ;    
    IF rptID is not null and rptionid is not null THEN
        DELETE from customer 
   		where CusID = m_cusid;
    end if;

end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BSX_Com` (IN `i_CusName` VARCHAR(255) CHARSET utf8)  BEGIN
    SELECT ReceiptID
    FROM receiption INNER JOIN customer
    ON receiption.CusID = customer.CusID
   	WHERE customer.Name = i_CusName;    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `BSX_Com2` (IN `i_BienSoXe` VARCHAR(255))  BEGIN
	SELECT Name, customer.Phone AS Phon3
    FROM receiption INNER JOIN customer
    ON customer.CusID = receiption.CusID
    WHERE receiption.LicensePlate = i_BienSoXe;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `carList` (IN `i_licensePlate` VARCHAR(50) CHARSET utf8)  BEGIN
Select ROW_NUMBER() OVER (ORDER BY LicensePlate) AS STT, LicensePlate,  Name, MoneyReceived from receiption, receipt, customer 
where receiption.ReceiptID = receipt.ReceiptID and receiption.CusID = customer.CusID and LicensePlate LIKE concat(concat('%',i_licensePlate),'%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteWage` (IN `i_WageID` INT(11))  BEGIN

delete from wage
where wage.WageID = i_WageID;
delete from repairdetail
where repairdetail.WageID = i_WageID;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DELETE_DATA` (IN `i_ImportName` VARCHAR(255))  BEGIN
    DELETE FROM importgoods 
    WHERE ImportName = i_ImportName;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DELETE_Ve` (IN `i_CusID` INT, IN `i_RecptID` INT, IN `i_ReceiptID` INT, IN `i_LicensePlate` VARCHAR(255))  BEGIN
    DELETE FROM receiption WHERE 
    ReceiptID = i_RecptID AND CusID = i_CusID AND LicensePlate = i_LicensePlate;

    DELETE FROM receipt WHERE 
    RecptID = i_RecptID AND ReceiptID = i_ReceiptID;

    DELETE FROM customer WHERE 
    CusID = i_CusID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Del_RepairList` (IN `i_BienSoXe` VARCHAR(255), IN `i_NgaySuaChua` DATE, IN `i_VatTuPhuTung` VARCHAR(255), IN `i_SoLuong` INT, IN `i_GiaVT` FLOAT, IN `i_LoaiTienCong` VARCHAR(255), IN `i_GiaTC` FLOAT)  NO SQL
BEGIN 
    DECLARE new_Count INT unsigned ;
    DECLARE new_RepairDeID INT unsigned ;
    DECLARE new_WageID INT unsigned ;
    DECLARE new_PartsID INT unsigned ;
                        
    /* SET new_Count = (SELECT COUNT(*) 
                    from repairdetail
                    WHERE repairdetail.RepairID = new_RepairID);   */
                      
	DELETE FROM repair
    WHERE RepairID IN (SELECT RepairID FROM repair INNER JOIN receiption
                        ON repair.ReceiptID = receiption.ReceiptID
                        WHERE receiption.LicensePlate = i_BienSoXe) AND ReceiptID In (SELECT ReceiptID FROM receiption                       
                        WHERE LicensePlate = i_BienSoXe) AND
    RepairDate = i_NgaySuaChua /*AND TotalRepair = new_Count*/;
    
    DELETE FROM repairdetail
    WHERE RepairDetailID IN ( SELECT RepairDetailID FROM repairdetail WHERE RepairID IN 
                        (SELECT RepairID FROM repair INNER JOIN receiption
                        ON repair.ReceiptID = receiption.ReceiptID
                        WHERE receiption.LicensePlate = i_BienSoXe)) AND RepairID IN (SELECT RepairID FROM repair INNER JOIN receiption
                        ON repair.ReceiptID = receiption.ReceiptID
                        WHERE receiption.LicensePlate = i_BienSoXe) AND  WageID IN ( SELECT WageID from wage where WageName = i_LoaiTienCong) 
                        AND PartsID IN ( SELECT PartsID from importgoods WHERE ImportName = i_VatTuPhuTung) 
                        AND PartsAmount = i_SoLuong
                        AND PartsPrice = i_GiaVT AND WageValue = i_GiaTC;
    
End$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `findCarBrands` (IN `i_LicensePlate` VARCHAR(255) CHARSET utf8)  BEGIN
Select ROW_NUMBER() OVER (ORDER BY LicensePlate) AS STT, LicensePlate,  Name, MoneyReceived, RecptDate from receiption, receipt, customer 
where receiption.ReceiptID = receipt.ReceiptID and receiption.CusID = customer.CusID and LicensePlate LIKE concat(concat('%',i_licensePlate),'%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `findWage` (IN `i_WageName` VARCHAR(255) CHARSET utf8)  BEGIN
Select WageID, WageName, WageValue from wage
where WageName like concat(concat('%',i_WageName),'%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `find_Repair1` (IN `i_BienSoXe` VARCHAR(255))  BEGIN
SELECT LicensePlate, RepairDate, PartsPrice, wage.WageValue, TotalMoney FROM 
    receiption INNER JOIN repair
    ON receiption.ReceiptID = repair.ReceiptID
    INNER JOIN repairdetail
    ON repair.RepairID = repairdetail.RepairID
    INNER JOIN wage
    ON wage.WageID = repairdetail.WageID
    INNER JOIN importgoods
    ON importgoods.PartsID = repairdetail.PartsID
    WHERE receiption.LicensePlate like i_BienSoXe;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `find_Repair2` (IN `i_BienSoXe` VARCHAR(255) CHARSET utf8, IN `i_NgaySuaChua` DATE)  BEGIN
	SELECT LicensePlate, RepairDate, PartsPrice, wage.WageValue, TotalMoney FROM 
    receiption INNER JOIN repair
    ON receiption.ReceiptID = repair.ReceiptID
    INNER JOIN repairdetail
    ON repair.RepairID = repairdetail.RepairID
    INNER JOIN wage
    ON wage.WageID = repairdetail.WageID
    INNER JOIN importgoods
    ON importgoods.PartsID = repairdetail.PartsID
    WHERE receiption.LicensePlate like i_BienSoXe AND repair.RepairDate = i_NgaySuaChua;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `find_Repair3` (IN `i_NgaySuaChua` DATE)  BEGIN 
	SELECT LicensePlate, RepairDate, PartsPrice, wage.WageValue, TotalMoney FROM 
    receiption INNER JOIN repair
    ON receiption.ReceiptID = repair.ReceiptID
    INNER JOIN repairdetail
    ON repair.RepairID = repairdetail.RepairID
    INNER JOIN wage
    ON wage.WageID = repairdetail.WageID
    INNER JOIN importgoods
    ON importgoods.PartsID = repairdetail.PartsID
	WHERE repair.RepairDate like i_NgaySuaChua;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `find_reportInv` (IN `i_MonthReport` INT(255), IN `i_YearReport` INT(255))  BEGIN
	SELECT InvReportID, ImportName, TonDau, PhatSinh, TonCuoi
    FROM inventoryreportdetail INNER JOIN inventory
    ON inventoryreportdetail.InvID = inventory.InvID
    INNER JOIN importgoods
    ON inventory.PartsID = importgoods.PartsID
    WHERE MONTH(InvReportDate) like i_MonthReport AND YEAR(InvReportDate) like i_YearReport;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `find_reportlist2` (IN `i_MonthSale` INT(255), IN `i_YearSale` INT(255))  BEGIN 
	SELECT SaleReportID, CarName, AmountOfTurn, TotalMoney, Rate
    FROM salereportdetail
    INNER JOIN carbrand 
    ON salereportdetail.CarBrandID = carbrand.CarBrandID
    INNER JOIN salereport 
    ON salereportdetail.SaleID = salereport.SaleID
    WHERE MONTH(SaleDate) like i_MonthSale AND YEAR(SaleDate) like i_YearSale;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `find_reportlist3` (IN `i_MonthSale` INT, IN `i_YearSale` INT, IN `i_sale` INT)  BEGIN
	DECLARE new_Count INT unsigned ;
	
    SET new_Count = (SELECT SUM(TotalMoney) FROM salereportdetail INNER JOIN salereport
                     ON salereportdetail.SaleID = salereport.SaleID 
                     WHERE MONTH(SaleDate) = i_MonthSale AND YEAR(SaleDate) = i_YearSale);

	SELECT SaleReportID, CarName, AmountOfTurn, TotalMoney, Rate
    FROM salereportdetail
    INNER JOIN carbrand 
    ON salereportdetail.CarBrandID = carbrand.CarBrandID
    INNER JOIN salereport 
    ON salereportdetail.SaleID = salereport.SaleID
    WHERE MONTH(SaleDate) like i_MonthSale AND YEAR(SaleDate) like i_YearSale AND new_Count like i_sale;
END$$

CREATE DEFINER=`'root' `@` 'localhost'` PROCEDURE `insertCarBrands` (IN `i_LicensePlate` VARCHAR(50) CHARSET utf8, IN `i_CarName` VARCHAR(255) CHARSET utf8, IN `i_CusName` VARCHAR(255) CHARSET utf8, IN `i_MoneyReceived` VARCHAR(50), IN `i_RecptDate` DATE)  BEGIN

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertWage` (IN `i_WageID` INT(11), IN `i_WageName` VARCHAR(255) CHARSET utf8, IN `i_WageValue` VARCHAR(255) CHARSET utf8)  BEGIN
insert into wage(WageID, WageName, WageValue) values (i_WageID, i_WageName, i_WageValue);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pro_ViewCustomer` (IN `i_name` VARCHAR(255), IN `i_phone` INT(255), IN `i_recpt_date` DATE, IN `i_license_plate` VARCHAR(255), IN `i_email` VARCHAR(255), IN `i_received_money` FLOAT)  Begin
	DECLARE new_receiptID INT unsigned ;
	DECLARE count_recptID INT unsigned ;

   	SELECT receiption.ReceiptID 
    INTO new_receiptID
    from receiption
    WHERE receiption.LicensePlate = i_license_plate;
    
    SELECT max(receipt.RecptID)
    INTO count_recptID
    FROM receipt;
	
    INSERT INTO receipt VALUES(count_recptID + 1, new_receiptID, i_recpt_date, i_received_money, i_email, i_phone);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ReportInv` (IN `i_vattuphutung` VARCHAR(255))  BEGIN 
	
    DECLARE new_PartsID INT unsigned ;

	SELECT MONTH(InvReportDate) AS MonthReport, YEAR(InvReportDate) AS YearReport
    FROM inventory INNER JOIN importgoods
    ON inventory.PartsID = importgoods.PartsID
    WHERE ImportName = i_vattuphutung;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reportlist` (IN `i_HieuXe` VARCHAR(255))  BEGIN   
    SELECT MONTH(SaleDate) AS MonthSale, YEAR(SaleDate) AS YearSale, SUM(TotalMoney) AS TotalSale
    FROM salereportdetail INNER JOIN salereport
    ON salereportdetail.SaleID = salereport.SaleID 
    INNER JOIN carbrand
    ON salereportdetail.CarBrandID = carbrand.CarBrandID
    WHERE CarName = i_HieuXe;    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_Bill` ()  BEGIN
	SELECT Name, customer.Phone AS Phon3, RecptDate, LicensePlate, Email, MoneyReceived
    FROM receipt INNER JOIN receiption
    ON receipt.ReceiptID = receiption.ReceiptID
    INNER JOIN customer
    ON receiption.CusID = customer.CusID;
ENd$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_Repair` ()  BEGIN
	SELECT LicensePlate, RepairDate, PartsPrice, wage.WageValue, TotalMoney FROM 
    receiption INNER JOIN repair
    ON receiption.ReceiptID = repair.ReceiptID
    INNER JOIN repairdetail
    ON repair.RepairID = repairdetail.RepairID
    INNER JOIN wage
    ON wage.WageID = repairdetail.WageID
    INNER JOIN importgoods
    ON importgoods.PartsID = repairdetail.PartsID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_salereport` ()  BEGIN
	SELECT InvReportID, ImportName, TonDau, PhatSinh, TonCuoi
    FROM inventoryreportdetail INNER JOIN inventory
    ON inventoryreportdetail.InvID = inventory.InvID
    INNER JOIN importgoods
    ON inventory.PartsID = importgoods.PartsID; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `show_salereportdetail` ()  BEGIN
	SELECT SaleReportID, CarName, AmountOfTurn, TotalMoney, Rate
    FROM salereportdetail
    INNER JOIN carbrand 
    ON salereportdetail.CarBrandID = carbrand.CarBrandID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateWage` (IN `i_WageID` INT(11), IN `i_WageName` VARCHAR(255) CHARSET utf8, IN `i_WageValue` VARCHAR(255) CHARSET utf8)  BEGIN
UPDATE wage 
SET WageName = i_WageName, WageValue = i_WageValue
WHERE WageID = i_WageID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Upd_RepairList` (IN `i_BienSoXe` VARCHAR(255), IN `i_NgaySuaChua` DATE, IN `i_VatTuPhuTung` VARCHAR(255), IN `i_SoLuong` INT(255), IN `i_GiaVT` FLOAT, IN `i_LoaiTienCong` VARCHAR(255), IN `i_GiaTC` FLOAT)  BEGIN

	DECLARE new_idvtpt INT unsigned;
    DECLARE new_wageid INT unsigned;
	
    SET new_idvtpt = (SELECT PartsID from importgoods where importgoods.ImportName = i_VatTuPhuTung);
    SET new_wageid = (SELECT WageID from wage where wage.WageName = i_LoaiTienCong);
    
	UPDATE receiption INNER JOIN repair
    ON receiption.ReceiptID = repair.ReceiptID
    INNER JOIN repairdetail
    ON repair.RepairID = repairdetail.RepairID
    INNER JOIN wage
    ON wage.WageID = repairdetail.WageID
    INNER JOIN importgoods
    ON importgoods.PartsID = repairdetail.PartsID
    SET receiption.LicensePlate = i_BienSoXe, repair.RepairDate = i_NgaySuaChua, repairdetail.PartsID = new_idvtpt, 
    repairdetail.PartsAmount = i_SoLuong, repairdetail.PartsPrice = i_GiaVT, repairdetail.WageID = new_wageid, repairdetail.WageValue = i_GiaTC
    WHERE receiption.LicensePlate like i_BienSoXe AND repair.RepairDate like i_NgaySuaChua AND repairdetail.PartsID like new_idvtpt AND 
    repairdetail.PartsAmount like i_SoLuong AND repairdetail.PartsPrice like i_GiaVT AND repairdetail.WageValue like i_GiaTC AND
    repairdetail.WageID like new_wageid;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Vtpt_combobox` (IN `i_BienSoXe` VARCHAR(255) CHARSET utf8, IN `i_NgaySuaChua` DATE, IN `i_GiaPT` VARCHAR(255), IN `i_GiaTC` VARCHAR(255))  NO SQL
BEGIN

DECLARE new_Count INT unsigned ;
    DECLARE new_RepairID INT unsigned ;
    DECLARE new_WageID INT unsigned ;
    DECLARE new_PartsID INT unsigned ;
    DECLARE new_GiaPT Float unsigned ;
    DECLARE new_GiaTC Float unsigned ;

SET new_RepairID = (SELECT RepairID FROM repair
                INNER JOIN receiption
                ON repair.ReceiptID = receiption.ReceiptID
                WHERE receiption.LicensePlate = i_BienSoXe AND repair.RepairDate = i_NgaySuaChua);

Select ImportID, PartsAmount, WageName from importgoods 
inner join repairdetail 
on importgoods.PartsID = repairdetail.PartsID
inner join wage
on wage.WageID = repairdetail.WageID
where repairdetail.RepairID = new_RepairID AND repairdetail.PartsPrice = i_GiaPT
AND repairdetail.WageValue  = i_GiaTC;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `autoparts`
--

CREATE TABLE `autoparts` (
  `PartsID` int(11) NOT NULL,
  `PartsName` varchar(255) NOT NULL,
  `Number` varchar(255) NOT NULL,
  `Price` varchar(255) NOT NULL,
  `UnitsOfCalculation` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `autoparts`
--

INSERT INTO `autoparts` (`PartsID`, `PartsName`, `Number`, `Price`, `UnitsOfCalculation`) VALUES
(1, 'Vit_xe', '5000', '2000', 'cái'),
(2, 'yên xe', '5000', '100000', 'cái'),
(3, 'Guong', '5000', '70000', 'cái'),
(4, 'Lốp xe', '5000', '50000', 'cái'),
(5, 'khung xe', '5000', '50000', 'cái'),
(6, 'ống bô', '5000', '300000', 'cái'),
(7, 'tăm xe', '5000', '200000', 'cái'),
(8, 'ắc quy', '5000', '5000000', 'cái'),
(9, 'Má phanh', '5000', '50000', 'cái'),
(10, 'Động cơ', '5000', '500000', 'cái');

-- --------------------------------------------------------

--
-- Table structure for table `carbrand`
--

CREATE TABLE `carbrand` (
  `CarBrandID` int(11) NOT NULL,
  `CarName` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `carbrand`
--

INSERT INTO `carbrand` (`CarBrandID`, `CarName`) VALUES
(1, 'Honda2018'),
(2, 'Honda2010'),
(3, 'Wave4554'),
(4, 'Wave4556'),
(5, 'Wave4557'),
(6, 'Wave4558'),
(7, 'Wave4559'),
(8, 'Wave4550'),
(9, 'Wave4551'),
(10, 'Honda2017');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `CusID` int(11) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `Address` varchar(1500) NOT NULL,
  `Phone` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`CusID`, `Name`, `Address`, `Phone`) VALUES
(1, 'Phan Khánh An', 'eTown 1 Building, 6th Floor 364 Cong Hoa Street.', 238125167),
(2, 'Lưu Quốc Việt', '30 Ngo 183 Hoang Van Thai, Khuong Mai Ward', 356597162),
(3, 'Tôn Hạo Nhiên', '214 Nguyen An Ninh Street', 962375286),
(4, 'Nguyễn Hữu Huyến\r\n', 'Hồ Chí Minh', 987746337),
(5, 'Nguyễn Phúc Tinh', 'ĐakLak', 847463645),
(6, 'Nguyễn Huỳnh Tuấn Anh', 'Hồ Chí Minh', 123456789),
(7, 'Bùi Thị Hương', 'Quảng Bình', 986313973),
(8, 'Nguyễn Thị Thúy Hằng', 'ĐakLak', 912345678),
(9, 'Nguyễn Bảo Thi', 'Lâm Đồng', 845612378),
(10, 'Vũ Minh Tuấn', 'Biên Hòa', 345678945),
(11, 'Nguyễn Thị Thúy Vy', 'Bình Định', 812345677);

-- --------------------------------------------------------

--
-- Table structure for table `importgoods`
--

CREATE TABLE `importgoods` (
  `ImportID` int(11) NOT NULL,
  `PartsID` int(11) NOT NULL,
  `ImportDate` date NOT NULL,
  `ImportTotelMoney` varchar(255) NOT NULL,
  `ImportName` varchar(255) NOT NULL,
  `ImportAmount` varchar(255) NOT NULL,
  `ImportPrice` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `importgoods`
--

INSERT INTO `importgoods` (`ImportID`, `PartsID`, `ImportDate`, `ImportTotelMoney`, `ImportName`, `ImportAmount`, `ImportPrice`) VALUES
(1, 3, '2021-04-01', '5000000', 'Guong', '100', '50000'),
(2, 1, '2021-03-01', '300000', 'Vít xe', '200', '1500'),
(3, 2, '2021-01-04', '8000000', 'Yên xe', '100', '80000'),
(4, 4, '2022-01-01', '4500000', 'Lốp xe', '100', '45000'),
(5, 5, '2022-02-02', '4000000', 'Khung xe', '100', '40000'),
(6, 6, '2022-04-07', '28000000', 'Ống bô', '100', '280000'),
(7, 7, '2022-03-16', '17000000', 'Tăm xe', '100', '170000'),
(8, 8, '2021-05-21', '460000000', 'Ắc quy', '100', '4600000'),
(9, 9, '2021-08-19', '4000000', 'Má phanh', '100', '40000'),
(10, 10, '2022-01-29', '45000000', 'Động cơ', '100', '450000');

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `InvID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `PartsID` int(11) NOT NULL,
  `InvReportDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `inventory`
--

INSERT INTO `inventory` (`InvID`, `UserID`, `PartsID`, `InvReportDate`) VALUES
(1, 2, 3, '2021-04-05'),
(2, 5, 10, '2022-03-22'),
(3, 3, 7, '2023-02-06'),
(4, 4, 2, '2021-04-12'),
(5, 1, 8, '2023-03-15'),
(6, 2, 4, '2020-04-04'),
(7, 4, 5, '2022-07-07');

-- --------------------------------------------------------

--
-- Table structure for table `inventoryreportdetail`
--

CREATE TABLE `inventoryreportdetail` (
  `InvReportID` int(11) NOT NULL,
  `InvID` int(11) NOT NULL,
  `TonDau` varchar(255) NOT NULL,
  `PhatSinh` varchar(255) NOT NULL,
  `TonCuoi` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `inventoryreportdetail`
--

INSERT INTO `inventoryreportdetail` (`InvReportID`, `InvID`, `TonDau`, `PhatSinh`, `TonCuoi`) VALUES
(1, 1, '3', '0', '5'),
(2, 2, '4', '0', '0'),
(3, 3, '6', '10', '3'),
(4, 4, '0', '8', '1'),
(5, 5, '0', '11', '1'),
(6, 6, '3', '2', '1'),
(7, 7, '0', '0', '0');

-- --------------------------------------------------------

--
-- Stand-in structure for view `invreportdtl_v`
-- (See below for the actual view)
--
CREATE TABLE `invreportdtl_v` (
`SUM(inv.TonDau)` double
);

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE `login` (
  `UserID` int(11) NOT NULL,
  `Username` varchar(20) NOT NULL,
  `Password` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`UserID`, `Username`, `Password`) VALUES
(1, 'manhhc', '123456'),
(2, 'hangntt', '123456'),
(3, 'khoiptx', '123456'),
(4, 'huongbt', '123456'),
(5, 'hans', '123456');

-- --------------------------------------------------------

--
-- Table structure for table `receipt`
--

CREATE TABLE `receipt` (
  `RecptID` int(11) NOT NULL,
  `ReceiptID` int(11) NOT NULL,
  `RecptDate` date NOT NULL,
  `MoneyReceived` varchar(255) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Phone` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `receipt`
--

INSERT INTO `receipt` (`RecptID`, `ReceiptID`, `RecptDate`, `MoneyReceived`, `Email`, `Phone`) VALUES
(1, 3, '2023-04-05', '150000', 'Abfdjfdfj@gmail.com', 986313973),
(2, 7, '2023-03-06', '1000000', 'thuyhang234@gmail.com', 962375286),
(3, 4, '2023-06-03', '567000', 'adadas@gmail.com', 356597162),
(4, 1, '2023-08-31', '450666', 'adasda@gmail.com', 238125167);

-- --------------------------------------------------------

--
-- Table structure for table `receiption`
--

CREATE TABLE `receiption` (
  `ReceiptID` int(11) NOT NULL,
  `CusID` int(11) NOT NULL,
  `LicensePlate` varchar(50) NOT NULL,
  `ReceiptDate` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `receiption`
--

INSERT INTO `receiption` (`ReceiptID`, `CusID`, `LicensePlate`, `ReceiptDate`) VALUES
(1, 1, '51F-11111', '2023-03-01'),
(2, 2, '59A-123456', '2023-04-01'),
(3, 7, '38N1-00234', '2022-04-18'),
(4, 2, '45K7-23456', '2023-04-19'),
(5, 8, '57N2-33445', '2022-04-30'),
(6, 11, '67K5-73456', '2021-05-11'),
(7, 3, '59F4-10934', '2022-07-17'),
(8, 10, '03H5-67543', '2022-03-14');

-- --------------------------------------------------------

--
-- Stand-in structure for view `receipt_v`
-- (See below for the actual view)
--
CREATE TABLE `receipt_v` (
`Name` varchar(255)
,`Phone` int(11)
,`RecptDate` date
,`LicensePlate` varchar(50)
,`Email` varchar(255)
,`MoneyReceived` varchar(255)
);

-- --------------------------------------------------------

--
-- Table structure for table `repair`
--

CREATE TABLE `repair` (
  `RepairID` int(11) NOT NULL,
  `ReceiptID` int(11) NOT NULL,
  `RepairDate` date NOT NULL,
  `TotalRepair` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `repair`
--

INSERT INTO `repair` (`RepairID`, `ReceiptID`, `RepairDate`, `TotalRepair`) VALUES
(1, 3, '2023-05-05', '0'),
(2, 7, '2023-03-07', '56'),
(3, 4, '2023-06-06', '233'),
(4, 1, '2023-09-06', '2323');

-- --------------------------------------------------------

--
-- Table structure for table `repairdetail`
--

CREATE TABLE `repairdetail` (
  `RepairDetailID` int(11) NOT NULL,
  `RepairID` int(11) NOT NULL,
  `WageID` int(11) NOT NULL,
  `PartsID` int(11) NOT NULL,
  `Content` varchar(255) NOT NULL,
  `PartsAmount` varchar(255) NOT NULL,
  `PartsPrice` varchar(255) NOT NULL,
  `WageValue` varchar(255) NOT NULL,
  `TotalMoney` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `repairdetail`
--

INSERT INTO `repairdetail` (`RepairDetailID`, `RepairID`, `WageID`, `PartsID`, `Content`, `PartsAmount`, `PartsPrice`, `WageValue`, `TotalMoney`) VALUES
(1, 1, 1, 7, 'Thay tăm xe', '2', '200000', '50000', '450000'),
(2, 2, 4, 9, 'Thay má phanh', '2', '50000', '40000', '140000'),
(3, 1, 4, 9, 'Thay má phanh', '2', '50000', '40000', '140000'),
(4, 3, 3, 3, 'Thay gương', '1', '70000', '70000', '210000'),
(5, 4, 2, 4, 'Thay lốp xe', '2', '50000', '100000', '200000');

-- --------------------------------------------------------

--
-- Table structure for table `salereport`
--

CREATE TABLE `salereport` (
  `SaleID` int(11) NOT NULL,
  `UserID` int(11) NOT NULL,
  `SaleDate` date NOT NULL,
  `SaleRevenue` varchar(255) NOT NULL,
  `SaleName` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `salereport`
--

INSERT INTO `salereport` (`SaleID`, `UserID`, `SaleDate`, `SaleRevenue`, `SaleName`) VALUES
(1, 2, '2023-05-05', '10000', 'Banh_xe'),
(2, 5, '2023-04-04', '10000', 'Lop_xe'),
(3, 4, '2023-03-01', '20000', 'Yen_xe'),
(4, 3, '2023-06-01', '6000', 'Gương');

-- --------------------------------------------------------

--
-- Table structure for table `salereportdetail`
--

CREATE TABLE `salereportdetail` (
  `SaleReportID` int(11) NOT NULL,
  `SaleID` int(11) NOT NULL,
  `CarBrandID` int(11) NOT NULL,
  `AmountOfTurn` varchar(255) NOT NULL,
  `TotalMoney` varchar(255) NOT NULL,
  `Rate` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `salereportdetail`
--

INSERT INTO `salereportdetail` (`SaleReportID`, `SaleID`, `CarBrandID`, `AmountOfTurn`, `TotalMoney`, `Rate`) VALUES
(7, 4, 2, '0', '200000', '5'),
(8, 1, 4, '9000', '40000', '4'),
(9, 2, 9, '56000', '78000', '5'),
(10, 2, 10, '0', '500000', '5');

-- --------------------------------------------------------

--
-- Table structure for table `wage`
--

CREATE TABLE `wage` (
  `WageID` int(11) NOT NULL,
  `WageName` varchar(255) NOT NULL,
  `WageValue` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `wage`
--

INSERT INTO `wage` (`WageID`, `WageName`, `WageValue`) VALUES
(1, 'Tăm xe', '50000'),
(2, 'Lop_xe', '100000'),
(3, 'Guong', '70000'),
(4, 'Má phanh', '40000');

-- --------------------------------------------------------

--
-- Structure for view `invreportdtl_v`
--
DROP TABLE IF EXISTS `invreportdtl_v`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `invreportdtl_v`  AS SELECT sum(`inv`.`TonDau`) AS `SUM(inv.TonDau)` FROM `inventoryreportdetail` AS `inv` WHERE `inv`.`TonDau` > 0 ;

-- --------------------------------------------------------

--
-- Structure for view `receipt_v`
--
DROP TABLE IF EXISTS `receipt_v`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `receipt_v`  AS SELECT `c`.`Name` AS `Name`, `rcpt`.`Phone` AS `Phone`, `rcpt`.`RecptDate` AS `RecptDate`, `r`.`LicensePlate` AS `LicensePlate`, `rcpt`.`Email` AS `Email`, `rcpt`.`MoneyReceived` AS `MoneyReceived` FROM ((`customer` `c` left join `receiption` `r` on(`c`.`CusID` = `r`.`CusID`)) left join `receipt` `rcpt` on(`r`.`ReceiptID` = `rcpt`.`RecptID`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `autoparts`
--
ALTER TABLE `autoparts`
  ADD PRIMARY KEY (`PartsID`);

--
-- Indexes for table `carbrand`
--
ALTER TABLE `carbrand`
  ADD PRIMARY KEY (`CarBrandID`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`CusID`);

--
-- Indexes for table `importgoods`
--
ALTER TABLE `importgoods`
  ADD PRIMARY KEY (`ImportID`),
  ADD KEY `FK_IMPORT_GOODS_AUTO_PARTS` (`PartsID`);

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`InvID`),
  ADD KEY `FK_INVENTORY_AUTO_PARTS` (`PartsID`),
  ADD KEY `FK_INVENTORY_LOGIN` (`UserID`);

--
-- Indexes for table `inventoryreportdetail`
--
ALTER TABLE `inventoryreportdetail`
  ADD PRIMARY KEY (`InvReportID`),
  ADD KEY `FK_INVENTORY_DETAILS_INVENTORY` (`InvID`);

--
-- Indexes for table `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`UserID`);

--
-- Indexes for table `receipt`
--
ALTER TABLE `receipt`
  ADD PRIMARY KEY (`RecptID`),
  ADD KEY `FK_RECEIPT_RECEIPTION` (`ReceiptID`);

--
-- Indexes for table `receiption`
--
ALTER TABLE `receiption`
  ADD PRIMARY KEY (`ReceiptID`),
  ADD KEY `FK_RECEIPTION_CUSTOMER` (`CusID`);

--
-- Indexes for table `repair`
--
ALTER TABLE `repair`
  ADD PRIMARY KEY (`RepairID`),
  ADD KEY `FK_REPAIR_RECEIPTION` (`ReceiptID`);

--
-- Indexes for table `repairdetail`
--
ALTER TABLE `repairdetail`
  ADD PRIMARY KEY (`RepairDetailID`),
  ADD KEY `FK_REPAIR_DETAILS_REPAIR` (`RepairID`),
  ADD KEY `FK_REPAIR_DETAILS_WAGE` (`WageID`),
  ADD KEY `FK_REPAIR_DETAILS_AUTO_PARTS` (`PartsID`);

--
-- Indexes for table `salereport`
--
ALTER TABLE `salereport`
  ADD PRIMARY KEY (`SaleID`),
  ADD KEY `FK_SALE_REPORT_LOGIN` (`UserID`);

--
-- Indexes for table `salereportdetail`
--
ALTER TABLE `salereportdetail`
  ADD PRIMARY KEY (`SaleReportID`),
  ADD KEY `FK_SALE_REPORT_DETAILS_SALE_REPORT` (`SaleID`),
  ADD KEY `FK_SALE_REPORT_DETAILS_CAR_BRAND` (`CarBrandID`);

--
-- Indexes for table `wage`
--
ALTER TABLE `wage`
  ADD PRIMARY KEY (`WageID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `autoparts`
--
ALTER TABLE `autoparts`
  MODIFY `PartsID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `carbrand`
--
ALTER TABLE `carbrand`
  MODIFY `CarBrandID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `CusID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `importgoods`
--
ALTER TABLE `importgoods`
  MODIFY `ImportID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `InvID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `inventoryreportdetail`
--
ALTER TABLE `inventoryreportdetail`
  MODIFY `InvReportID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `login`
--
ALTER TABLE `login`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `receipt`
--
ALTER TABLE `receipt`
  MODIFY `RecptID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `receiption`
--
ALTER TABLE `receiption`
  MODIFY `ReceiptID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `repair`
--
ALTER TABLE `repair`
  MODIFY `RepairID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `repairdetail`
--
ALTER TABLE `repairdetail`
  MODIFY `RepairDetailID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `salereport`
--
ALTER TABLE `salereport`
  MODIFY `SaleID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `salereportdetail`
--
ALTER TABLE `salereportdetail`
  MODIFY `SaleReportID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `wage`
--
ALTER TABLE `wage`
  MODIFY `WageID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `importgoods`
--
ALTER TABLE `importgoods`
  ADD CONSTRAINT `FK_IMPORT_GOODS_AUTO_PARTS` FOREIGN KEY (`PartsID`) REFERENCES `autoparts` (`PartsID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `inventory`
--
ALTER TABLE `inventory`
  ADD CONSTRAINT `FK_INVENTORY_AUTO_PARTS` FOREIGN KEY (`PartsID`) REFERENCES `autoparts` (`PartsID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_INVENTORY_LOGIN` FOREIGN KEY (`UserID`) REFERENCES `login` (`UserID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `inventoryreportdetail`
--
ALTER TABLE `inventoryreportdetail`
  ADD CONSTRAINT `FK_INVENTORY_DETAILS_INVENTORY` FOREIGN KEY (`InvID`) REFERENCES `inventory` (`InvID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `receipt`
--
ALTER TABLE `receipt`
  ADD CONSTRAINT `FK_RECEIPT_RECEIPTION` FOREIGN KEY (`ReceiptID`) REFERENCES `receiption` (`ReceiptID`);

--
-- Constraints for table `receiption`
--
ALTER TABLE `receiption`
  ADD CONSTRAINT `FK_RECEIPTION_CUSTOMER` FOREIGN KEY (`CusID`) REFERENCES `customer` (`CusID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `repair`
--
ALTER TABLE `repair`
  ADD CONSTRAINT `FK_REPAIR_RECEIPTION` FOREIGN KEY (`ReceiptID`) REFERENCES `receiption` (`ReceiptID`);

--
-- Constraints for table `repairdetail`
--
ALTER TABLE `repairdetail`
  ADD CONSTRAINT `FK_REPAIR_DETAILS_AUTO_PARTS` FOREIGN KEY (`PartsID`) REFERENCES `autoparts` (`PartsID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_REPAIR_DETAILS_REPAIR` FOREIGN KEY (`RepairID`) REFERENCES `repair` (`RepairID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_REPAIR_DETAILS_WAGE` FOREIGN KEY (`WageID`) REFERENCES `wage` (`WageID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `salereport`
--
ALTER TABLE `salereport`
  ADD CONSTRAINT `FK_SALE_REPORT_LOGIN` FOREIGN KEY (`UserID`) REFERENCES `login` (`UserID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `salereportdetail`
--
ALTER TABLE `salereportdetail`
  ADD CONSTRAINT `FK_SALE_REPORT_DETAILS_CAR_BRAND` FOREIGN KEY (`CarBrandID`) REFERENCES `carbrand` (`CarBrandID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_SALE_REPORT_DETAILS_SALE_REPORT` FOREIGN KEY (`SaleID`) REFERENCES `salereport` (`SaleID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
