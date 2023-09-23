-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th6 25, 2023 lúc 06:10 AM
-- Phiên bản máy phục vụ: 10.4.28-MariaDB
-- Phiên bản PHP: 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `garage_final`
--

DELIMITER $$
--
-- Thủ tục
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkOverwrittenCarBrand` (IN `i_TenHieuXe` VARCHAR(255) CHARSET utf8)   BEGIN
SELECT COUNT(*) AS DEM FROM hieuxe
WHERE TenHieuXe = i_TenHieuXe;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `checkOverwrittenWage` (IN `i_TenTC` VARCHAR(255) CHARSET utf8)   BEGIN 
SELECT COUNT(*) AS DEM FROM tiencong
WHERE tiencong.TenTC = i_TenTC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCarBrand` (IN `i_TenHieuXe` VARCHAR(255) CHARSET utf8)   BEGIN
delete from hieuxe
where TenHieuXe = i_TenHieuXe;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteWage` (IN `i_MaTC` INT(11))   BEGIN
DECLARE i_SoPSC int;
DECLARE i_SoLuong int;

SET i_SoPSC = (SELECT SoPSC from ct_phieusuachua where ct_phieusuachua.MaTC = i_MaTC);
SET i_SoLuong = (SELECT SoLuong from ct_sudungvtpt join ct_phieusuachua WHERE ct_sudungvtpt.MaCT_PSC = ct_phieusuachua.MaCT_PSC AND MaTC = i_MaTC);

CALL P_DelRepairList(i_SoPSC, i_SoLuong);

delete from tiencong
where MaTC = i_MaTC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `findCar` (IN `i_BienSo` VARCHAR(255))   BEGIN
UPDATE xe INNER JOIN phieusuachua
ON xe.BienSo = phieusuachua.BienSo
INNER JOIN phieuthutien
ON phieuthutien.BienSo = phieusuachua.BienSo
set xe.TienNo = phieusuachua.TongTien - phieuthutien.SoTienThu
WHERE xe.BienSo = i_BienSo;
Select  BienSo, TenHieuXe, TenChuXe, TienNo from xe join hieuxe
where xe.MaHieuXe = hieuxe.MaHieuXe and BienSo like concat(concat('%',i_BienSo),'%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `findCarBrand` (IN `i_TenHieuXe` VARCHAR(255))   BEGIN
SELECT MaHieuXe, TenHieuXe from hieuxe 
WHERE TenHieuXe like concat(concat('%',i_TenHieuXe),'%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `findWage` (IN `i_TenTC` VARCHAR(255))   BEGIN
Select MaTC, TenTC, GiaTien from tiencong
where TenTC like concat(concat('%',i_TenTC),'%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertCarBrand` (IN `i_MaHieuXe` INT, IN `i_TenHieuXe` VARCHAR(255) CHARSET utf8)   BEGIN
insert into hieuxe(MaHieuXe, TenHieuXe) values (i_MaHieuXe, i_TenHieuXe);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertWage` (IN `i_TenTC` VARCHAR(255), IN `i_Gia` DOUBLE)   BEGIN
DECLARE i_MaTC INT;
IF NOT EXISTS(SELECT * FROM tiencong)
    THEN 
    	SET i_MaTC = 1;
    ELSE
        SET i_MaTC = (SELECT MAX(MaTC) FROM tiencong) + 1;
    END IF;
insert into tiencong(MaTC, TenTC, GiaTien) values (i_MaTC, i_TenTC, i_Gia);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_AddBCSale` (IN `i_MonthSale` INT(255), IN `i_YearSale` INT(255))   BEGIN
    DECLARE counter_t INT DEFAULT 0;
    DECLARE counter_R INT DEFAULT 0;
    DECLARE new_MaBC INT UNSIGNED DEFAULT 1;
    DECLARE count_SHX INT UNSIGNED DEFAULT 0;
    DECLARE sum_tem INT DEFAULT 0;
    
    IF EXISTS (SELECT * FROM baocaodoanhso) THEN
    	SELECT MAX(MaBC) + 1 FROM baocaodoanhso
        INTO new_MaBC;
    END IF;
    
    SET count_SHX = (SELECT COUNT(SoPSC) from xe
	INNER JOIN phieusuachua
	ON xe.BienSo = phieusuachua.BienSo
    WHERE MONTH(NgaySuaChua) = i_MonthSale AND YEAR(NgaySuaChua) = i_YearSale);
    
    CREATE TEMPORARY TABLE t_hieuxe (
        t_MaHX INT UNSIGNED DEFAULT 0,
        t_MaHieuXe INT(11) NOT NULL,
        t_SLSC INT UNSIGNED DEFAULT 0,
        t_ThanhTien INT UNSIGNED DEFAULT 0,
        t_TiLe FLOAT
    );
  
    WHILE counter_t < count_SHX DO
        INSERT INTO t_hieuxe (t_MaHX, t_MaHieuXe, t_SLSC, t_ThanhTien)
        SELECT new_MaBC , MaHieuXe, (
            SELECT COUNT(SoPSC)
            FROM xe
            INNER JOIN phieusuachua ON xe.BienSo = phieusuachua.BienSo
            WHERE MONTH(NgaySuaChua) = i_MonthSale AND YEAR(NgaySuaChua) = i_YearSale
            GROUP BY MaHieuXe
            ORDER BY MONTH(NgaySuaChua)
            LIMIT counter_R, 1
        ), (
            SELECT SUM(TongTien)
            FROM phieusuachua
            INNER JOIN xe ON phieusuachua.BienSo = xe.BienSo 
            WHERE MONTH(NgaySuaChua) = i_MonthSale AND YEAR(NgaySuaChua) = i_YearSale
            GROUP BY MaHieuXe
            ORDER BY MONTH(NgaySuaChua)
            LIMIT counter_R, 1
        )
        FROM (
            SELECT DISTINCT new_MaBC , MaHieuXe
            FROM xe
            INNER JOIN phieusuachua ON xe.BienSo = phieusuachua.BienSo
            WHERE MONTH(NgaySuaChua) = i_MonthSale AND YEAR(NgaySuaChua) = i_YearSale
            ORDER BY MONTH(NgaySuaChua)
            LIMIT counter_R, 1
        ) AS subquery;
        
        SET counter_R = counter_R + 1;
        SET counter_t = counter_t + 1;
    END WHILE;
    
    SET sum_tem = (SELECT SUM(t_ThanhTien) FROM t_hieuxe);
   
   	
    UPDATE t_hieuxe 
    SET t_TiLe = t_ThanhTien / sum_tem;
    
    /*SELECT t_MaHX, t_HieuXe, t_SLSC, t_ThanhTien FROM t_hieuxe;*/
    
    INSERT INTO baocaodoanhso(MaBC, Thang, Nam, TongDoanhThu) Values(new_MaBC, i_MonthSale, i_YearSale, sum_tem);
    
    INSERT INTO ct_bcdoanhso(MaBC, MaHieuXe, SoLuongSua, ThanhTien, TiLe)
    SELECT new_MaBC, t_MaHieuXe, t_SLSC, t_ThanhTien, t_TiLe FROM t_hieuxe;
    
    DROP TEMPORARY TABLE IF EXISTS t_hieuxe;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_AddBCTon` (IN `i_MonthTon` INT(255), IN `i_YearTon` INT(255))   BEGIN
DECLARE counter_t INT DEFAULT 0;
DECLARE counter_R INT DEFAULT 0;
DECLARE counter_E INT DEFAULT -1;
DECLARE counter_VTPT INT DEFAULT 0;
DECLARE check_Month INT DEFAULT 0;
DECLARE check_Year INT DEFAULT 0;
DECLARE new_Null INT;
DECLARE RowCount INT;

SET counter_R = 0;
SET counter_E = -1;

CREATE TEMPORARY TABLE t_baocaoton (
        t_thang INT UNSIGNED DEFAULT 0,
        t_nam INT UNSIGNED DEFAULT 0,
        t_Mavtpt VARCHAR(255) NOT NULL,
        t_TonDau INT UNSIGNED DEFAULT 0,
       	t_PhatSinh INT UNSIGNED DEFAULT 0,
    	t_TonCuoi INT UNSIGNED DEFAULT 0
    );

IF i_MonthTon = 1 THEN
SET check_Month = 12;
SET check_Year = i_YearTon - 1;
ELSE
SET check_Month = i_MonthTon;
SET check_Year = i_YearTon;
END IF;

SET counter_VTPT = (SELECT COUNT(DISTINCT vattuphutung.MaVTPT) FROM vattuphutung 
                    INNER JOIN ct_phieunhap
                    ON vattuphutung.MaVTPT = ct_phieunhap.MaVTPT
                    INNER JOIN phieunhapvtpt 
                    ON ct_phieunhap.MaPN = phieunhapvtpt.MaPN
                    WHERE MONTH(NgayNhap) = i_MonthTon AND YEAR(NgayNhap) = i_YearTon);

WHILE counter_t < counter_VTPT DO
	SET RowCount = 0;
    IF EXISTS (SELECT * FROM (SELECT vattuphutung.MaVTPT AS VTPT FROM vattuphutung
       INNER JOIN ct_phieunhap ON vattuphutung.MaVTPT = ct_phieunhap.MaVTPT
       INNER JOIN phieunhapvtpt ON phieunhapvtpt.MaPN = ct_phieunhap.MaPN
       WHERE MONTH(NgayNhap) = i_MonthTon - 1 AND YEAR(NgayNhap) = i_YearTon) AS A
       INNER JOIN (SELECT vattuphutung.MaVTPT AS VTPT FROM vattuphutung
       INNER JOIN ct_phieunhap ON vattuphutung.MaVTPT = ct_phieunhap.MaVTPT
       INNER JOIN phieunhapvtpt ON phieunhapvtpt.MaPN = ct_phieunhap.MaPN
       WHERE MONTH(NgayNhap) = i_MonthTon AND YEAR(NgayNhap) = i_YearTon LIMIT counter_R ,1) AS B
       ON A.VTPT = B.VTPT) THEN 
            SELECT COUNT(*) INTO RowCount FROM (SELECT vattuphutung.MaVTPT AS VTPT FROM vattuphutung
               INNER JOIN ct_phieunhap ON vattuphutung.MaVTPT = ct_phieunhap.MaVTPT
               INNER JOIN phieunhapvtpt ON phieunhapvtpt.MaPN = ct_phieunhap.MaPN
               WHERE MONTH(NgayNhap) = i_MonthTon - 1 AND YEAR(NgayNhap) = i_YearTon) AS A
               INNER JOIN (SELECT vattuphutung.MaVTPT AS VTPT FROM vattuphutung
               INNER JOIN ct_phieunhap ON vattuphutung.MaVTPT = ct_phieunhap.MaVTPT
               INNER JOIN phieunhapvtpt ON phieunhapvtpt.MaPN = ct_phieunhap.MaPN
               WHERE MONTH(NgayNhap) = i_MonthTon AND YEAR(NgayNhap) = i_YearTon LIMIT counter_R ,1) AS B
               ON A.VTPT = B.VTPT;
           SET counter_E = counter_E + 1;
        END IF;
               
	INSERT INTO t_baocaoton(t_thang, t_nam, t_Mavtpt, t_TonDau, t_PhatSinh, t_TonCuoi)
    SELECT i_MonthTon, i_YearTon,
      (SELECT vattuphutung.MaVTPT
       FROM vattuphutung
       INNER JOIN ct_phieunhap ON vattuphutung.MaVTPT = ct_phieunhap.MaVTPT
       INNER JOIN phieunhapvtpt ON phieunhapvtpt.MaPN = ct_phieunhap.MaPN
       WHERE MONTH(NgayNhap) = i_MonthTon AND YEAR(NgayNhap) = i_YearTon
       ORDER BY vattuphutung.MaVTPT ASC, phieunhapvtpt.MaPN DESC
       LIMIT counter_R, 1),
      (SELECT SoLuongTon
           FROM vattuphutung
           INNER JOIN ct_phieunhap ON vattuphutung.MaVTPT = ct_phieunhap.MaVTPT
           INNER JOIN phieunhapvtpt ON phieunhapvtpt.MaPN = ct_phieunhap.MaPN
           WHERE MONTH(NgayNhap) = check_Month - 1 AND YEAR(NgayNhap) = i_YearTon AND RowCount > 0
           ORDER BY vattuphutung.MaVTPT ASC, phieunhapvtpt.MaPN DESC LIMIT counter_E,1),
      (SELECT SUM(SoLuongNhap)
       FROM ct_phieunhap
       INNER JOIN phieunhapvtpt ON ct_phieunhap.MaPN = phieunhapvtpt.MaPN
       WHERE MONTH(NgayNhap) = i_MonthTon AND YEAR(NgayNhap) = i_YearTon
       GROUP BY MaVTPT
       ORDER BY MaVTPT ASC, phieunhapvtpt.MaPN DESC
       LIMIT counter_R, 1),
      (SELECT SoLuongTon
       FROM vattuphutung
       INNER JOIN ct_phieunhap ON vattuphutung.MaVTPT = ct_phieunhap.MaVTPT
       INNER JOIN phieunhapvtpt ON phieunhapvtpt.MaPN = ct_phieunhap.MaPN
       WHERE MONTH(NgayNhap) = i_MonthTon AND YEAR(NgayNhap) = i_YearTon
       ORDER BY vattuphutung.MaVTPT, phieunhapvtpt.MaPN DESC
       LIMIT counter_R, 1);
       
   /*IF EXISTS (SELECT * FROM (SELECT vattuphutung.MaVTPT AS VTPT, phieunhapvtpt.NgayNhap AS NN FROM vattuphutung INNER JOIN ct_phieunhap ON vattuphutung.MaVTPT = ct_phieunhap.MaVTPT
       INNER JOIN phieunhapvtpt ON phieunhapvtpt.MaPN = ct_phieunhap.MaPN
       WHERE MONTH(NgayNhap) = i_MonthTon AND YEAR(NgayNhap) = i_YearTon
       ORDER BY vattuphutung.MaVTPT, phieunhapvtpt.MaPN DESC
       LIMIT counter_R, 1) AS A
       INNER JOIN (SELECT vattuphutung.MaVTPT AS VTPT, phieunhapvtpt.NgayNhap AS NN FROM vattuphutung INNER JOIN ct_phieunhap ON vattuphutung.MaVTPT = ct_phieunhap.MaVTPT
       INNER JOIN phieunhapvtpt ON phieunhapvtpt.MaPN = ct_phieunhap.MaPN
       WHERE MONTH(NgayNhap) = i_MonthTon AND YEAR(NgayNhap) = i_YearTon
       ORDER BY vattuphutung.MaVTPT, phieunhapvtpt.MaPN DESC
       LIMIT counter_E, 1) AS B
       ON A.VTPT = B.VTPT
       WHERE A.NN = B.NN) THEN
   			SET counter_R = counter_R + 2;
   ELSE*/
   	SET counter_R = counter_R + 1;
   	SET counter_t = counter_t + 1;
   /*END IF;*/
   END WHILE;
   
   /*SELECT * FROM t_baocaoton;*/
   
   INSERT INTO baocaoton(Thang, Nam, MaVTPT, TonDau, PhatSinh, TonCuoi) 
   SELECT t_thang, t_nam, t_Mavtpt, t_TonDau, t_PhatSinh, t_TonCuoi FROM t_baocaoton;
   
   DROP TEMPORARY TABLE IF EXISTS t_baocaoton;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_AddRepairList` (IN `i_BienSoXe` VARCHAR(255), IN `i_NgaySuaChua` DATE, IN `i_VatTuPhuTung` VARCHAR(255), IN `i_SoLuong` INT(255), IN `i_GiaVT` FLOAT, IN `i_LoaiTienCong` VARCHAR(255), IN `i_SoLan` INT(255), IN `i_GiaTC` FLOAT, IN `i_NoiDungSC` VARCHAR(255), OUT `o_output` INT)  NO SQL BEGIN 
    DECLARE max_SoPSC INT unsigned DEFAULT 0;
    DECLARE max_MaSPSC INT unsigned DEFAULT 0;
    DECLARE new_SoPSC INT unsigned DEFAULT 0;
    DECLARE new_MaSPSC INT unsigned DEFAULT 0;
    DECLARE new_MaTC INT unsigned DEFAULT 0;
    DECLARE new_GiaTC INT unsigned DEFAULT 0;
    DECLARE new_TongTC INT unsigned DEFAULT 0;
    DECLARE new_MaVTPT INT unsigned DEFAULT 0;
    DECLARE new_TongPT INT unsigned DEFAULT 0;
    DECLARE new_NgayTN DATE;
    
    SET new_NgayTN = (SELECT NgayTiepNhan FROM xe WHERE BienSo =  i_BienSoXe);
    
    IF(i_NgaySuaChua >= new_NgayTN) THEN
    IF NOT EXISTS(SELECT * FROM phieusuachua) THEN
    	SET max_SoPSC = 1;
    ELSE 
    SELECT max(SoPSC) + 1 FROM phieusuachua
    INTO max_SoPSC;
    END IF;
    
    SELECT max(MaCT_PSC) + 1 FROM ct_phieusuachua
    INTO max_MaSPSC;
    
    SET new_MaTC = (SELECT MaTC FROM tiencong WHERE tiencong.TenTC = i_LoaiTienCong);
    SET new_GiaTC = (SELECT GiaTien FROM tiencong WHERE tiencong.TenTC = i_LoaiTienCong);
    SET new_TongTC = i_SoLan * i_GiaTC;
    SET new_TongPT = i_SoLuong * i_GiaVT;
    SET new_MaVTPT = (SELECT MaVTPT FROM vattuphutung WHERE TenVTPT = i_VatTuPhuTung);

	INSERT INTO phieusuachua (SoPSC, BienSo, NgaySuaChua)
    VALUES(max_SoPSC, i_BienSoXe, i_NgaySuaChua);
    
    INSERT INTO ct_phieusuachua (MaCT_PSC, SoPSC, NoiDungSC, MaTC, SoLan, TongTienCong)
	VALUES(max_MaSPSC, max_SoPSC, i_NoiDungSC, new_MaTC, i_SoLan, new_TongTC);
    
    INSERT INTO ct_sudungvtpt (MaCT_PSC, MaVTPT, SoLuong, DonGia, ThanhTien)
    VALUES(max_MaSPSC, new_MaVTPT, i_SoLuong, i_GiaVT, new_TongPT);
    
    SET new_SoPSC = (SELECT phieusuachua.SoPSC FROM phieusuachua INNER JOIN ct_phieusuachua
                     ON phieusuachua.SoPSC = ct_phieusuachua.SoPSC
                     WHERE BienSo = i_BienSoXe AND NgaySuaChua = i_NgaySuaChua AND ct_phieusuachua.NoiDungSC = i_NoiDungSC);
    SET new_MaSPSC = (SELECT ct_phieusuachua.MaCT_PSC FROM ct_phieusuachua WHERE ct_phieusuachua.SoPSC = new_SoPSC);
    
    UPDATE ct_phieusuachua
    SET ct_phieusuachua.TongTienVTPT = (SELECT SUM(ThanhTien) FROM ct_sudungvtpt WHERE ct_sudungvtpt.MaCT_PSC = new_MaSPSC),
    TongCong = TongTienVTPT + TongTienCong
    WHERE ct_phieusuachua.MaCT_PSC = new_MaSPSC;
    
    UPDATE phieusuachua 
    SET phieusuachua.TongTien = (SELECT SUM(TongCong) FROM ct_phieusuachua WHERE ct_phieusuachua.SoPSC = new_SoPSC)
    WHERE phieusuachua.SoPSC = new_SoPSC;
    
    UPDATE vattuphutung
    INNER JOIN ct_sudungvtpt
    ON vattuphutung.MaVTPT = ct_sudungvtpt.MaVTPT
    SET SoLuongTon = SoLuongTon - SoLuong
    WHERE ct_sudungvtpt.MaCT_PSC = new_MaSPSC;
    SET o_output = 1;
    
   	ELSE 
    	SET o_output = 0;
    END IF;
    
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_BCTon` (IN `i_vattuphutung` VARCHAR(255))   BEGIN 

	SELECT Thang AS MonthReport, Nam AS YearReport
    FROM baocaoton INNER JOIN vattuphutung
    ON baocaoton.MaVTPT = vattuphutung.MaVTPT
    WHERE vattuphutung.TenVTPT = i_vattuphutung;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Bill_Delete` (IN `i_BienSoXe` VARCHAR(255) CHARSET utf8, IN `i_ngaythutien` DATE, IN `i_Email` VARCHAR(255) CHARSET utf8)   BEGIN
		IF EXISTS (
        SELECT *
        FROM phieuthutien
        WHERE BienSo = i_BienSoXe 
        and NgayThu = i_ngaythutien
    ) THEN
        -- Delete from phieuthutien table
        DELETE FROM phieuthutien
        where BienSo = i_BienSoXe
        and NgayThu = i_ngaythutien
        limit 1;   
        
        UPDATE xe 
        SET Email = null
        WHERE BienSo = i_BienSoXe;
        end if;
        
        
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Bill_Insert` (IN `i_BienSoXe` VARCHAR(255) CHARSET utf8, IN `i_ngaythutien` DATE, IN `i_sotienthu` FLOAT, IN `i_Email` VARCHAR(255) CHARSET utf8, OUT `o_output` INT)   BEGIN
    DECLARE max_SP INT UNSIGNED;
   	DECLARE new_NgaySC DATE;
    DECLARE new_TongTienSC INT DEFAULT 0;
	
    if i_sotienthu <= 0 THEN
    	set o_output = 3; 
    ELSE
    
    SET new_TongTienSC = (SELECT TongTien FROM phieusuachua 
                      WHERE phieusuachua.BienSo = i_BienSoXe
                     	ORDER BY NgaySuaChua DESC
                     LIMIT 0,1);
    
	SET new_NgaySC = (SELECT NgaySuaChua FROM phieusuachua 
                      WHERE phieusuachua.BienSo = i_BienSoXe
                     	ORDER BY NgaySuaChua DESC
                     LIMIT 0,1);
                     
    IF(i_sotienthu > new_TongTienSC)THEN
    SET o_output = 2;
    
    ELSE 
    IF(i_ngaythutien >= new_NgaySC) THEN
    -- Check if the provided BienSo exists in the xe table
    IF EXISTS (SELECT * FROM phieuthutien) THEN
    	SELECT MAX(SoPhieu) + 1 INTO max_SP
    	FROM phieuthutien;
    ELSE 
    	SET max_SP = 1;
    END IF;
    	
    -- Update phieuthutien table    
	IF EXISTS (
        SELECT * FROM phieuthutien 
        WHERE BienSo = i_BienSoXe 
        AND NgayThu = i_ngaythutien
    ) THEN 
        UPDATE phieuthutien SET SoTienThu = SoTienThu + i_sotienthu 
        WHERE BienSo = i_BienSoXe 
        AND NgayThu = i_ngaythutien
        LIMIT 1;
        end if;
    -- Insert into phieuthutien table
    IF NOT EXISTS (
        SELECT * FROM phieuthutien 
        WHERE BienSo = i_BienSoXe 
        AND NgayThu = i_ngaythutien
    ) THEN 
        INSERT INTO phieuthutien (SoPhieu, BienSo, NgayThu, SoTienThu)
        VALUES (max_SP, i_BienSoXe, i_ngaythutien, i_sotienthu);
        
        UPDATE xe
        SET Email = i_Email
        WHERE BienSo = i_BienSoXe;
    END IF;
    SET o_output = 1;
    
   	ELSE 
    	SET o_output = 0;
    END IF;
    END IF;
    END if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Bill_Update` (IN `i_SP` INT, IN `i_BienSoXe` VARCHAR(255) CHARSET utf8, IN `i_ngaythutien` DATE, IN `i_sotienthu` FLOAT, IN `i_Email` VARCHAR(255) CHARSET utf8, OUT `o_output` INT)   BEGIN    
	DECLARE new_NgaySC DATE;
    DECLARE new_TongTienSC INT DEFAULT 0;
    
    if i_sotienthu <= 0 THEN
    	set o_output = 3; 
    ELSE
    SET new_NgaySC = (SELECT NgaySuaChua FROM phieusuachua 
                      WHERE phieusuachua.BienSo = i_BienSoXe
                     	ORDER BY NgaySuaChua DESC
                     LIMIT 0,1);
    SET new_TongTienSC = (SELECT TongTien FROM phieusuachua 
                      WHERE phieusuachua.BienSo = i_BienSoXe
                     	ORDER BY NgaySuaChua DESC
                     LIMIT 0,1);
    IF(i_sotienthu > new_TongTienSC)THEN
    SET o_output = 2;
    
    ELSE 
    IF(i_ngaythutien >= new_NgaySC) THEN
    UPDATE phieuthutien
    SET SoTienThu = i_sotienthu,
        NgayThu = i_ngaythutien,
        BienSo = i_BienSoXe
    WHERE SoPhieu = i_SP
    LIMIT 1;
	
    UPDATE xe 
    SET Email = i_Email
    WHERE BienSo = i_BienSoXe;
    SET o_output = 1;
    
   	ELSE 
    	SET o_output = 0;
    END IF;
    END IF;
    end if;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_BSX_Com2` (IN `i_BienSoXe` VARCHAR(255) CHARSET utf8)   BEGIN
	SELECT TenChuXe, DienThoai, Email
    from xe
    where BienSo = i_BienSoXe;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_CapNhap_VTPT` (IN `i_NgayNhap` DATE, IN `i_TenVTPT` VARCHAR(255), IN `i_SoLuongNhap` INT(11), IN `i_DonGiaNhap` DOUBLE, IN `i_MaPN` INT(11), IN `i_MaVTPT` INT(11), OUT `o_output` INT)   BEGIN
	DECLARE new_TiLe DOUBLE DEFAULT 0;
    
    SET new_TiLe = (SELECT GiaTri FROM thamso WHERE TenThamSo = 'TiLeGiaBan');
    IF(i_NgayNhap <= CURDATE()) THEN
    -- Update the record in the phieunhapvtpt table
    UPDATE phieunhapvtpt
    SET NgayNhap = i_NgayNhap
    WHERE MaPN = i_MaPN;

    -- Update the record in the vattuphutung table
    UPDATE vattuphutung
    SET TenVTPT = i_TenVTPT,
        DonGiaNhap = i_DonGiaNhap,
        DonGiaBan = i_DonGiaNhap * new_TiLe,
        SoLuongTon = i_SoLuongNhap
    WHERE MaVTPT = i_MaVTPT;

    -- Update the record in the ct_phieunhap table
    UPDATE ct_phieunhap
    SET DonGiaNhap = i_DonGiaNhap,
        SoLuongNhap = i_SoLuongNhap,
        ThanhTien = i_DonGiaNhap * i_SoLuongNhap
    WHERE MaPN = i_MaPN AND MaVTPT = i_MaVTPT;

   UPDATE phieunhapvtpt INNER JOIN ct_phieunhap
    ON phieunhapvtpt.MaPN = ct_phieunhap.MaPN
    SET TongTien = (SELECT SUM(ThanhTien) FROM ct_phieunhap INNER JOIN phieunhapvtpt
                    ON phieunhapvtpt.MaPN = ct_phieunhap.MaPN
                    WHERE NgayNhap = i_NgayNhap)
    WHERE NgayNhap = i_NgayNhap;
    SET o_output = 1;
    ELSE 
    SET o_output = 0;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_CapNhap_Xe` (IN `i_TenChuXe` VARCHAR(255), IN `i_TenHieuXe` VARCHAR(255), IN `i_DiaChi` VARCHAR(255), IN `i_DienThoai` VARCHAR(255), IN `i_NgayTiepNhan` DATE, IN `i_BienSo` VARCHAR(255), OUT `o_output` INT)   BEGIN
    DECLARE i_MaHieuXe INT;

	SET i_MaHieuXe = (SELECT MaHieuXe FROM hieuxe WHERE TenHieuXe = i_TenHieuXe LIMIT 0,1);
	
    IF(i_NgayTiepNhan <= curdate()) THEN
    -- Check if the 'BienSo' value already exists in the 'Xe' table
    IF EXISTS (SELECT 1 FROM Xe WHERE BienSo = i_BienSo) THEN
        
        -- Update the existing record in the Xe table
        UPDATE Xe
        SET TenChuXe = i_TenChuXe,
            MaHieuXe = i_MaHieuXe,
            DiaChi = i_DiaChi,
            DienThoai = i_DienThoai,
            NgayTiepNhan = i_NgayTiepNhan
        WHERE BienSo = i_BienSo;
    END IF;
    	SET o_output = 1;
    ELSE 
    	SET o_output = 0; 
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Change_BrandCar` (IN `i_hieuxecu` VARCHAR(255), IN `i_hieuxemoi` VARCHAR(255), IN `i_ghichu` VARCHAR(255), OUT `o_ketqua` INT, OUT `o_msg` VARCHAR(255))   BEGIN    
	DECLARE l_new_hieuxe VARCHAR(255);
    if i_hieuxecu is not null THEN
			update xe  
            set xe.HieuXe = i_hieuxemoi
            where xe.HieuXe = i_hieuxecu;
        set o_ketqua = 1;
        set o_msg = "Thay đổi thành công";
    ELSE
    	set o_ketqua = 0;
        set o_msg = "Vui lòng chọn hiệu xe cần thay đổi";
    END IF;    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_CheckBCOverwritten` (IN `i_MonthSale` INT, IN `i_YearSale` INT)   BEGIN
SELECT COUNT(*) AS DEM
    FROM baocaodoanhso
    WHERE Thang = i_MonthSale AND Nam = i_YearSale;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_CheckOverwritten` (IN `i_BienSoXe` VARCHAR(255) CHARSET utf8, IN `i_NgaySuaChua` DATE, IN `i_NoiDung` VARCHAR(255))  NO SQL BEGIN
	SELECT COUNT(*) AS DEM
    FROM phieusuachua
    INNER JOIN ct_phieusuachua
    ON phieusuachua.SoPSC = ct_phieusuachua.SoPSC  	
    WHERE phieusuachua.BienSo = i_BienSoXe AND phieusuachua.NgaySuaChua = i_NgaySuaChua AND ct_phieusuachua.NoiDungSC = i_NoiDung;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Checkoverwritten_Bill` (IN `i_SP` INT, IN `i_BienSoXe` VARCHAR(255) CHARSET utf8, IN `i_ngaythutien` DATE, OUT `o_output` INT)   BEGIN
	declare new_SoPhieu int default 0;	
    declare check_SP int default 0;    
    
    set new_SoPhieu = (select SoPhieu from phieuthutien
                      where BienSo = i_BienSoXe
                      AND NgayThu = i_ngaythutien);
    If not EXISTS (select * from phieuthutien
                      where BienSo = i_BienSoXe
                      AND NgayThu = i_ngaythutien) then
         set check_SP = 1;
         end if;
                      
     if (i_SP = new_SoPhieu or check_SP = 1) then
     	set o_output = 1;
     else 
     	set o_output = 0; end if;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Checkoverwritten_Bill_Add` (IN `i_BienSoXe` VARCHAR(255) CHARSET utf8, IN `i_NgayThuTien` DATE)   BEGIN 
    SELECT COUNT(*) AS DEM FROM phieuthutien WHERE BienSo = i_BienSoXe AND NgayThu = i_NgayThuTien;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Checkoverwritten_VTPT` (IN `i_TenVTPT` VARCHAR(255) CHARSET utf8, IN `i_NgayNhap` DATE)   BEGIN
	SELECT COUNT(*) AS DEM FROM vattuphutung
    INNER JOIN ct_phieunhap
    ON vattuphutung.MaVTPT = ct_phieunhap.MaVTPT
    INNER JOIN phieunhapvtpt
    ON ct_phieunhap.MaPN = phieunhapvtpt.MaPN
    WHERE TenVTPT = i_TenVTPT AND NgayNhap = i_NgayNhap;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_CheckTiLeDonGia` (IN `i_TLDonGiaBan` DOUBLE, OUT `o_ketqua` INT, OUT `o_msg` VARCHAR(255))   BEGIN
	DECLARE l_check INT DEFAULT 0;
    
	SELECT COUNT(*) AS soluong
    into l_check
    FROM thamso ts 	
    WHERE ts.TenThamSo like "TiLeDonGia";
   
        update thamso ts 
        set ts.GiaTri = i_TLDonGiaBan
    	WHERE ts.TenThamSo like "TiLeGiaBan";
        
        set o_ketqua = 1;
        set o_msg = "Thay đổi thành công";
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_CheckTonOverwritten` (IN `i_MonthReport` INT, IN `i_YearReport` INT)   BEGIN
SELECT COUNT(*) AS DEM
    FROM baocaoton
    WHERE Thang = i_MonthReport AND Nam = i_YearReport;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_CheckUpwritten` (IN `i_SoPSC` INT, IN `i_BienSoXe` VARCHAR(255) CHARSET utf8, IN `i_NgaySuaChua` DATE, IN `i_NoiDung` VARCHAR(255) CHARSET utf8, OUT `o_ouput` INT)   BEGIN
	DECLARE new_SoPSC INT DEFAULT 0; 
    DECLARE check_new_SoPSC INT DEFAULT 0; 
    SET new_SoPSC = (SELECT phieusuachua.SoPSC FROM phieusuachua INNER JOIN ct_phieusuachua
                     ON ct_phieusuachua.SoPSC = phieusuachua.SoPSC
                     WHERE phieusuachua.BienSo = i_BienSoXe AND phieusuachua.NgaySuaChua = i_NgaySuaChua AND ct_phieusuachua.NoiDungSC = i_NoiDung);
                     
    IF NOT EXISTS(SELECT * FROM phieusuachua INNER JOIN ct_phieusuachua
   	ON ct_phieusuachua.SoPSC = phieusuachua.SoPSC
   	WHERE phieusuachua.BienSo = i_BienSoXe AND phieusuachua.NgaySuaChua = i_NgaySuaChua AND ct_phieusuachua.NoiDungSC = i_NoiDung) THEN
                     SET check_new_SoPSC = 1;
                     END IF;
                     
    IF(i_SoPSC = new_SoPSC OR check_new_SoPSC = 1) THEN
    	SET o_ouput = 1;
   	ELSE
    	SET o_ouput = 0;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Check_SoLuongTienCong` (IN `i_soluong` INT, OUT `o_ketqua` INT, OUT `o_msg` VARCHAR(255))   BEGIN
	DECLARE l_check INT DEFAULT 0;
    
	SELECT COUNT(*) AS soluong
    into l_check
    FROM thamso ts 	
    WHERE ts.TenThamSo like "SoLuongTienCong";
   
        update thamso ts 
        set ts.GiaTri = i_soluong
    	WHERE ts.TenThamSo like "SoLuongTienCong";
        
        set o_ketqua = 1;
        set o_msg = "Thay đổi thành công";
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Check_SoLuongVTPT` (IN `i_soluong` INT, OUT `o_ketqua` INT, OUT `o_msg` VARCHAR(255))   BEGIN
	DECLARE l_check INT DEFAULT 0;
    
	SELECT COUNT(*) AS soluong
    into l_check
    FROM thamso ts 	
    WHERE ts.TenThamSo like "SoLuongVTPT";
   
        update thamso ts 
        set ts.GiaTri = i_soluong
    	WHERE ts.TenThamSo like "SoLuongVTPT";
        
        set o_ketqua = 1;
        set o_msg = "Thay đổi thành công";
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Check_SoLuongXeSuaTrongNgay` (IN `i_soluong` INT, OUT `o_ketqua` INT, OUT `o_msg` VARCHAR(255))   BEGIN
	DECLARE l_check INT DEFAULT 0;
    
	SELECT COUNT(*) AS soluong
    into l_check
    FROM thamso ts 	
    WHERE ts.TenThamSo like "SoXeSuaChuaTrongNgay";
   
        update thamso ts 
        set ts.GiaTri = i_soluong
    	WHERE ts.TenThamSo like "SoXeSuaChuaTrongNgay";
        
        set o_ketqua = 1;
        set o_msg = "Thay đổi thành công";
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_ClickedForPrice` (IN `i_SoPSC` TINYINT(255))   BEGIN
	SELECT DonGia, GiaTien From ct_sudungvtpt
    INNER JOIN ct_phieusuachua
    ON ct_phieusuachua.MaCT_PSC = ct_sudungvtpt.MaCT_PSC
    INNER JOIN phieusuachua
    ON phieusuachua.SoPSC = ct_phieusuachua.SoPSC
    INNER JOIN tiencong
    ON tiencong.MaTC = ct_phieusuachua.MaTC
    WHERE phieusuachua.SoPSC = i_SoPSC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_CPT` (IN `i_VTPT` VARCHAR(255))   BEGIN
	SELECT DonGiaBan FROM vattuphutung 
    WHERE vattuphutung.TenVTPT = i_VTPT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_CTC` (IN `i_TC` VARCHAR(255))   BEGIN
	SELECT GiaTien FROM tiencong
    WHERE tiencong.TenTC = i_TC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_DelRepairList` (IN `i_SoPSC` INT, IN `i_SoLuong` INT(255))  NO SQL BEGIN 
    DECLARE new_MaSPSC INT unsigned DEFAULT 0;
    
    SET new_MaSPSC = (SELECT ct_phieusuachua.MaCT_PSC FROM ct_phieusuachua WHERE ct_phieusuachua.SoPSC = i_SoPSC);
	
    DELETE FROM ct_sudungvtpt
	WHERE ct_sudungvtpt.MaCT_PSC = new_MaSPSC;
    
    DELETE FROM ct_phieusuachua
    WHERE ct_phieusuachua.MaCT_PSC = new_MaSPSC;
    
    DELETE FROM phieusuachua 
    WHERE phieusuachua.SoPSC = i_SoPSC;
    
    UPDATE vattuphutung
    INNER JOIN ct_sudungvtpt
    ON vattuphutung.MaVTPT = ct_sudungvtpt.MaVTPT
    SET SoLuongTon = SoLuongTon + i_SoLuong
    WHERE ct_sudungvtpt.MaCT_PSC = new_MaSPSC;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_FindBCSale` (IN `i_MonthSale` INT, IN `i_YearSale` INT)   BEGIN
	DECLARE new_Count INT unsigned ;
	
	SELECT TenHieuXe, SoLuongSua, ThanhTien, FORMAT(TiLe,1) AS TiLe FROM ct_bcdoanhso
    INNER JOIN baocaodoanhso
    ON ct_bcdoanhso.MaBC = baocaodoanhso.MaBC
    INNER JOIN hieuxe
    ON hieuxe.MaHieuXe = ct_bcdoanhso.MaHieuXe
    WHERE Thang like i_MonthSale AND Nam like i_YearSale;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_FindBCTon` (IN `i_MonthReport` INT(255), IN `i_YearReport` INT(255))   BEGIN
	SELECT TenVTPT, TonDau, PhatSinh, TonCuoi
    FROM baocaoton INNER JOIN vattuphutung
    ON baocaoton.MaVTPT = vattuphutung.MaVTPT
    WHERE Thang like i_MonthReport AND Nam like i_YearReport;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_findRepair1` (IN `i_BienSoXe` VARCHAR(255))   BEGIN
SELECT phieusuachua.SoPSC, BienSo, NgaySuaChua, NoiDungSC, TenVTPT, SoLuong, TenTC, SoLan, TongTien
    from phieusuachua INNER JOIN ct_phieusuachua
    ON phieusuachua.SoPSC = ct_phieusuachua.SoPSC
    INNER JOIN ct_sudungvtpt
    ON ct_sudungvtpt.MaCT_PSC = ct_phieusuachua.MaCT_PSC
    INNER JOIN vattuphutung
    ON vattuphutung.MaVTPT = ct_sudungvtpt.MaVTPT
    INNER JOIN tiencong
    ON ct_phieusuachua.MaTC = tiencong.MaTC
    WHERE BienSo like i_BienSoXe;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_findRepair2` (IN `i_BienSoXe` VARCHAR(255) CHARSET utf8, IN `i_NgaySuaChua` DATE)   BEGIN
	SELECT phieusuachua.SoPSC, BienSo, NgaySuaChua, NoiDungSC, TenVTPT, SoLuong, TenTC, SoLan, TongTien
    from phieusuachua INNER JOIN ct_phieusuachua
    ON phieusuachua.SoPSC = ct_phieusuachua.SoPSC
    INNER JOIN ct_sudungvtpt
    ON ct_sudungvtpt.MaCT_PSC = ct_phieusuachua.MaCT_PSC
    INNER JOIN vattuphutung
    ON vattuphutung.MaVTPT = ct_sudungvtpt.MaVTPT
    INNER JOIN tiencong
    ON ct_phieusuachua.MaTC = tiencong.MaTC
    WHERE BienSo like i_BienSoXe AND NgaySuaChua like i_NgaySuaChua;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_findRepair3` (IN `i_NgaySuaChua` DATE)   BEGIN 
	SELECT phieusuachua.SoPSC, BienSo, NgaySuaChua, NoiDungSC, TenVTPT, SoLuong, TenTC, SoLan, TongTien
    from phieusuachua INNER JOIN ct_phieusuachua
    ON phieusuachua.SoPSC = ct_phieusuachua.SoPSC
    INNER JOIN ct_sudungvtpt
    ON ct_sudungvtpt.MaCT_PSC = ct_phieusuachua.MaCT_PSC
    INNER JOIN vattuphutung
    ON vattuphutung.MaVTPT = ct_sudungvtpt.MaVTPT
    INNER JOIN tiencong
    ON ct_phieusuachua.MaTC = tiencong.MaTC
    WHERE NgaySuaChua like i_NgaySuaChua;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_findtestCAR` (IN `i_input` VARCHAR(255))   BEGIN
Select DISTINCT ROW_NUMBER() OVER (ORDER BY BienSo) AS STT, BienSo, TenHieuXe, TenChuXe, TienNo from xe join hieuxe
where xe.MaHieuXe = hieuxe.MaHieuXe or BienSo like concat(concat('%',i_input),'%') or xe.TenChuXe like  concat(concat('%',i_input),'%') or hieuxe.TenHieuXe like  concat(concat('%',i_input),'%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_FindXe` (IN `i_BienSoXe` VARCHAR(255) CHARSET utf8)   BEGIN
	SELECT * from xe
    INNER JOIN hieuxe
    ON hieuxe.MaHieuXe = xe.MaHieuXe
    WHERE BienSo like i_BienSoXe;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_PhieuThuTien` (IN `i_name` VARCHAR(255), IN `i_phone` INT, IN `i_recpt_date` DATE, IN `i_license_plate` VARCHAR(255), IN `i_email` VARCHAR(255), IN `i_received_money` DOUBLE)   Begin
	DECLARE new_receiptID INT unsigned ;
	DECLARE count_recptID INT unsigned ;

   	SELECT phieuthutien.BienSo 
    INTO new_receiptID
    from phieuthutien
    WHERE receiption.LicensePlate = i_license_plate;
    
    SELECT max(receipt.RecptID)
    INTO count_recptID
    FROM receipt;
	
    INSERT INTO xe VALUES(count_recptID + 1, new_receiptID, i_recpt_date, i_received_money, i_email, i_phone);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_ShowBCSale` ()   BEGIN
	SELECT TenHieuXe, SoLuongSua, ThanhTien, FORMAT(TiLe,1) AS TiLe FROM ct_bcdoanhso
    INNER JOIN xe 
    ON ct_bcdoanhso.MaHieuXe = xe.MaHieuXe
    INNER JOIN hieuxe
    ON hieuxe.MaHieuXe = ct_bcdoanhso.MaHieuXe;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_ShowBCTon` ()   BEGIN
	SELECT TenVTPT, TonDau, PhatSinh, TonCuoi FROM baocaoton
    INNER JOIN vattuphutung
    ON baocaoton.MaVTPT = vattuphutung.MaVTPT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_ShowRepair` ()   BEGIN
	SELECT phieusuachua.SoPSC, BienSo, NgaySuaChua, NoiDungSC, TenVTPT, SoLuong, TenTC, SoLan, TongTien
    from phieusuachua INNER JOIN ct_phieusuachua
    ON phieusuachua.SoPSC = ct_phieusuachua.SoPSC
    INNER JOIN ct_sudungvtpt
    ON ct_sudungvtpt.MaCT_PSC = ct_phieusuachua.MaCT_PSC
    INNER JOIN vattuphutung
    ON vattuphutung.MaVTPT = ct_sudungvtpt.MaVTPT
    INNER JOIN tiencong
    ON ct_phieusuachua.MaTC = tiencong.MaTC
    ORDER BY phieusuachua.SoPSC ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_ShowSaleText` (IN `i_MonthSale` INT(255), IN `i_YearSale` INT(255))   BEGIN 
	Select TongDoanhThu FROM baocaodoanhso
    WHERE Thang = i_MonthSale AND Nam = i_YearSale;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_show_Bill` ()   BEGIN
	SELECT SoPhieu, TenChuXe, xe.DienThoai AS Phon3, NgayThu, xe.BienSo, Email, SoTienThu
    FROM xe join phieuthutien
    on xe.BienSo = phieuthutien.BienSo
    order by SoPhieu;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Them_VTPT` (IN `i_NgayNhap` DATE, IN `i_TenVTPT` VARCHAR(255), IN `i_SoLuongNhap` INT(11), IN `i_DonGiaNhap` INT(11), OUT `o_output` INT)   BEGIN
    DECLARE i_MaVTPT INT DEFAULT 0;
    DECLARE i_MaPN INT DEFAULT 0;
    DECLARE i_ThanhTien INT DEFAULT 0;
    DECLARE new_TiLe DOUBLE DEFAULT 0;
    
    SET new_TiLe = (SELECT GiaTri FROM thamso WHERE TenThamSo = 'TiLeGiaBan');
    IF(i_NgayNhap <= CURDATE()) THEN
    IF NOT EXISTS(SELECT * FROM vattuphutung)
    THEN 
    	SET i_MaVTPT = 1;
    ELSEIF EXISTS (SELECT * FROM vattuphutung WHERE TenVTPT = i_TenVTPT) THEN
    	SET i_MaVTPT = (SELECT MaVTPT FROM vattuphutung WHERE TenVTPT = i_TenVTPT);
    ELSE
        SET i_MaVTPT = (SELECT MAX(MaVTPT) FROM vattuphutung) + 1;
    END IF;
 	
    -- Insert the record into the vattuphutung table
    IF EXISTS (SELECT * FROM vattuphutung WHERE TenVTPT = i_TenVTPT) THEN
    	UPDATE vattuphutung
        SET DonGiaNhap = i_DonGiaNhap, DonGiaBan = i_DonGiaNhap * new_TiLe, SoLuongTon = SoLuongTon + i_SoLuongNhap
        WHERE TenVTPT = i_TenVTPT;
    ELSE
        INSERT INTO vattuphutung (MaVTPT, TenVTPT, DonGiaNhap, DonGiaBan, SoLuongTon) 
            VALUES (i_MaVTPT, i_TenVTPT, i_DonGiaNhap, i_DonGiaNhap * new_TiLe, i_SoLuongNhap);	
   	END IF;
    
    -- Calculate the ThanhTien
    SET i_ThanhTien = i_SoLuongNhap * i_DonGiaNhap;
    
    IF NOT EXISTS(SELECT * FROM phieunhapvtpt)
    THEN 
    	SET i_MaPN = 1;
    ELSE
        SET i_MaPN = (SELECT MAX(MaPN) FROM phieunhapvtpt) + 1;
    END IF;
    
    -- Insert the record into the phieunhapvtpt table with calculated TongTien
    INSERT INTO phieunhapvtpt (MaPN, NgayNhap, TongTien) VALUES (i_MaPN, i_NgayNhap, i_ThanhTien);
    
    -- Insert the record into the ct_phieunhap table
    INSERT INTO ct_phieunhap (MaVTPT, MaPN, SoLuongNhap, DonGiaNhap, ThanhTien)
    	VALUES (i_MaVTPT, i_MaPN, i_SoLuongNhap, i_DonGiaNhap, i_ThanhTien);
    
    -- Update the TongTien in the phieunhapvtpt table
    UPDATE phieunhapvtpt INNER JOIN ct_phieunhap
    ON phieunhapvtpt.MaPN = ct_phieunhap.MaPN
    SET TongTien = (SELECT SUM(ThanhTien) FROM ct_phieunhap INNER JOIN phieunhapvtpt
                    ON phieunhapvtpt.MaPN = ct_phieunhap.MaPN
                    WHERE NgayNhap = i_NgayNhap)
    WHERE NgayNhap = i_NgayNhap;
    SET o_output = 1;
    ELSE 
    	SET o_output = 0;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Them_Xe` (IN `i_BienSo` VARCHAR(255), IN `i_TenChuXe` VARCHAR(255), IN `i_TenHieuXe` VARCHAR(255), IN `i_DiaChi` VARCHAR(255), IN `i_DienThoai` VARCHAR(255), IN `i_NgayTiepNhan` DATE, OUT `o_output` INT)   BEGIN
    DECLARE i_TongTien INT;
    DECLARE i_SoTienThu INT;
    DECLARE i_TienNo INT;
    DECLARE i_MaHieuXe INT;
 
    
    SET i_MaHieuXe = (SELECT MaHieuXe FROM hieuxe WHERE TenHieuXe = i_TenHieuXe);

	IF(i_NgayTiepNhan <= CURDATE()) THEN
    -- Check if the 'BienSo' value already exists in the 'Xe' table
    IF EXISTS (SELECT 1 FROM Xe WHERE BienSo = i_BienSo) THEN
        -- Load all the information related to the existing 'BienSo'
        SELECT TongTien INTO i_TongTien FROM PhieuSuaChua WHERE BienSo = i_BienSo;
        SELECT SoTienThu INTO i_SoTienThu FROM PhieuThuTien WHERE BienSo = i_BienSo;
    ELSE
        -- Set default values for i_TongTien and i_SoTienThu
        SET i_TongTien = 0;
        SET i_SoTienThu = 0;
    END IF;

    -- Insert the record into the Xe table
    INSERT INTO Xe (BienSo, TenChuXe, MaHieuXe, DiaChi, DienThoai, NgayTiepNhan)
    VALUES (i_BienSo, i_TenChuXe, i_MaHieuXe, i_DiaChi, i_DienThoai, i_NgayTiepNhan);

    -- Calculate the TienNo
    SET i_TienNo = i_TongTien - i_SoTienThu;

    -- Update the TienNo in the Xe table
    UPDATE Xe
    SET TienNo = i_TienNo
    WHERE BienSo = i_BienSo;
    SET o_output = 1;
    ELSE
    	SET o_output = 0;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_TimKiem` (IN `i_BienSo` VARCHAR(255))   BEGIN
    -- Declare a variable to store the result
    DECLARE Result VARCHAR(255) DEFAULT '';

    -- Check if the record with the specified 'BienSo' exists
    IF EXISTS (SELECT 1 FROM xe WHERE BienSo = i_BienSo) THEN
        -- Set the result to indicate record found
        SET Result = 'Record found.';

        -- Select the record with the specified 'BienSo'
        SELECT BienSo, TenChuXe, TenHieuXe, DiaChi, DienThoai,NgayTiepNhan, Result AS Result FROM xe
        INNER JOIN hieuxe
        ON hieuxe.MaHieuXe = xe.MaHieuXe
        WHERE BienSo = i_BienSo;
    ELSE
        -- Set the result to indicate record not found
        SET Result = 'Record not found.';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_UpdatePSC` (IN `i_SoPSC` TINYINT, IN `i_BienSoXe` VARCHAR(255), IN `i_NgaySuaChua` DATE, IN `i_VatTuPhuTung` VARCHAR(255), IN `i_SoLuong` INT(255), IN `i_GiaVT` FLOAT, IN `i_LoaiTienCong` VARCHAR(255), IN `i_SoLan` INT(255), IN `i_GiaTC` FLOAT, IN `i_NoiDungSC` VARCHAR(255), OUT `o_output` INT)  NO SQL BEGIN 
    DECLARE count_FSL INT unsigned DEFAULT 0;
    DECLARE new_MaSPSC INT unsigned DEFAULT 0;
    DECLARE new_MaTC INT unsigned DEFAULT 0;
    DECLARE new_GiaTC INT unsigned DEFAULT 0;
    DECLARE new_TongTC INT unsigned DEFAULT 0;
    DECLARE new_MaVTPT INT unsigned DEFAULT 0;
    DECLARE new_TongPT INT unsigned DEFAULT 0;
    DECLARE new_NgayTN DATE;
    
    SET new_NgayTN = (SELECT NgayTiepNhan FROM xe WHERE BienSo =  i_BienSoXe);
    
    SET new_MaTC = (SELECT MaTC FROM tiencong WHERE tiencong.TenTC = i_LoaiTienCong);
    SET new_GiaTC = (SELECT GiaTien FROM tiencong WHERE tiencong.TenTC = i_LoaiTienCong);
    SET new_TongTC = i_SoLan * i_GiaTC;
    SET new_TongPT = i_SoLuong * i_GiaVT;
    SET new_MaVTPT = (SELECT MaVTPT FROM vattuphutung WHERE TenVTPT = i_VatTuPhuTung);
    SET new_MaSPSC = (SELECT ct_phieusuachua.MaCT_PSC FROM ct_phieusuachua WHERE ct_phieusuachua.SoPSC = i_SoPSC);
    SET count_FSL = (SELECT SoLuong FROM ct_sudungvtpt WHERE ct_sudungvtpt.MaCT_PSC = new_MaSPSC
                    AND ct_sudungvtpt.MaVTPT = new_MaVTPT);  
    
    IF(i_NgaySuaChua >= new_NgayTN) THEN
    IF(i_SoLuong > count_FSL) THEN
        UPDATE vattuphutung
        INNER JOIN ct_sudungvtpt ON vattuphutung.MaVTPT = ct_sudungvtpt.MaVTPT
        SET SoLuongTon = SoLuongTon - (i_SoLuong - count_FSL)
        WHERE ct_sudungvtpt.MaCT_PSC = new_MaSPSC;
    END IF;
    
    IF(i_SoLuong < count_FSL) THEN
        UPDATE vattuphutung
        INNER JOIN ct_sudungvtpt ON vattuphutung.MaVTPT = ct_sudungvtpt.MaVTPT
        SET SoLuongTon = SoLuongTon + (count_FSL - i_SoLuong)
        WHERE ct_sudungvtpt.MaCT_PSC = new_MaSPSC;
    END IF;
    
    IF(i_SoLuong = count_FSL) THEN
        UPDATE vattuphutung
        INNER JOIN ct_sudungvtpt ON vattuphutung.MaVTPT = ct_sudungvtpt.MaVTPT
        SET SoLuongTon = SoLuongTon
        WHERE ct_sudungvtpt.MaCT_PSC = new_MaSPSC;
    END IF;
    
    UPDATE ct_sudungvtpt
    SET MaVTPT = new_MaVTPT, SoLuong = i_SoLuong, DonGia = i_GiaVT, ThanhTien = new_TongPT
    WHERE MaCT_PSC = new_MaSPSC;
    
    UPDATE ct_phieusuachua 
    SET NoiDungSC = i_NoiDungSC, MaTC = new_MaTC, SoLan = i_SoLan, TongTienCong = new_TongTC, TongTienVTPT = (SELECT SUM(ThanhTien) FROM ct_sudungvtpt WHERE MaCT_PSC = new_MaSPSC),
    TongCong = TongTienVTPT + TongTienCong
    WHERE MaCT_PSC = new_MaSPSC;
    
    UPDATE phieusuachua 
    INNER JOIN ct_phieusuachua ON phieusuachua.SoPSC = ct_phieusuachua.SoPSC
    SET BienSo = i_BienSoXe, NgaySuaChua = i_NgaySuaChua, TongTien = (SELECT SUM(TongCong) FROM ct_phieusuachua WHERE ct_phieusuachua.SoPSC = i_SoPSC)
    WHERE phieusuachua.SoPSC = i_SoPSC;
    SET o_output = 1;
    
   	ELSE 
    	SET o_output = 0;
    END IF;
  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Xoa_VTPT` (IN `i_MAPN` INT(11), IN `i_MAVTPT` INT(11), IN `i_NgayNhap` DATE)   BEGIN  

    DELETE FROM ct_phieunhap WHERE MaPN = i_MAPN AND MaVTPT = i_MAVTPT;


UPDATE phieunhapvtpt INNER JOIN ct_phieunhap

    ON phieunhapvtpt.MaPN = ct_phieunhap.MaPN

    SET TongTien = (SELECT SUM(ThanhTien) FROM ct_phieunhap INNER JOIN phieunhapvtpt

                    ON phieunhapvtpt.MaPN = ct_phieunhap.MaPN

                    WHERE NgayNhap = i_NgayNhap)

    WHERE NgayNhap = i_NgayNhap;

 

    -- Check if there are any remaining records with the same MaPN in the ct_phieunhap table

 

SELECT COUNT(*) INTO @count_ct_phieunhap FROM ct_phieunhap WHERE MaPN = i_MAPN;

 



    -- Delete the record from the phieunhapvtpt table if there are no remaining records with the same MaPN

    IF @count_ct_phieunhap = 0 THEN

        DELETE FROM phieunhapvtpt WHERE MaPN = i_MAPN;

    END IF;

 

    -- Check if there are any remaining records with the same MaVTPT in the ct_phieunhap table

    SET @count_ct_phieunhap = (SELECT COUNT(*) FROM ct_phieunhap WHERE MaVTPT = i_MAVTPT);

 

    -- Delete the record from the vattuphutung table if there are no remaining records with the same MaVTPT

    IF @count_ct_phieunhap = 0 THEN

        DELETE FROM vattuphutung WHERE MaVTPT = i_MAVTPT;

    END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Xoa_Xe` (IN `i_BienSo` VARCHAR(255))   BEGIN
    -- Check if the 'BienSo' value exists in the 'Xe' table
    IF EXISTS (SELECT 1 FROM Xe WHERE BienSo = i_BienSo) THEN
        -- Delete related records from PhieuSuaChua table
        DELETE FROM PhieuSuaChua WHERE BienSo = i_BienSo;

        -- Delete related records from PhieuThuTien table
        DELETE FROM PhieuThuTien WHERE BienSo = i_BienSo;

        -- Delete the record from the Xe table
        DELETE FROM Xe WHERE BienSo = i_BienSo;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCarBrand` (IN `i_MaHieuXe` INT, IN `i_TenHieuXe` VARCHAR(255) CHARSET utf8)   BEGIN
UPDATE hieuxe
SET TenHieuXe = i_TenHieuXe
WHERE MaHieuXe = i_MaHieuXe;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateWage` (IN `i_MaTC` INT(11), IN `i_TenTC` VARCHAR(255), IN `i_Gia` DOUBLE)   BEGIN
UPDATE tiencong
SET TenTC = i_TenTC, GiaTien = i_Gia
WHERE MaTC = i_MaTC;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `baocaodoanhso`
--

CREATE TABLE `baocaodoanhso` (
  `MaBC` int(11) NOT NULL,
  `Thang` int(11) NOT NULL,
  `Nam` int(11) NOT NULL,
  `TongDoanhThu` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `baocaodoanhso`
--

INSERT INTO `baocaodoanhso` (`MaBC`, `Thang`, `Nam`, `TongDoanhThu`) VALUES
(1, 6, 2023, 4780000);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `baocaoton`
--

CREATE TABLE `baocaoton` (
  `Thang` int(11) NOT NULL,
  `Nam` int(11) NOT NULL,
  `MaVTPT` int(11) NOT NULL,
  `TonDau` int(11) NOT NULL,
  `PhatSinh` int(11) NOT NULL,
  `TonCuoi` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `baocaoton`
--

INSERT INTO `baocaoton` (`Thang`, `Nam`, `MaVTPT`, `TonDau`, `PhatSinh`, `TonCuoi`) VALUES
(5, 2023, 7, 0, 10, 9),
(6, 2023, 2, 0, 53, 51),
(6, 2023, 6, 0, 5, 5),
(6, 2023, 7, 9, 5, 9);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `ct_bcdoanhso`
--

CREATE TABLE `ct_bcdoanhso` (
  `MaBC` int(11) NOT NULL,
  `MaHieuXe` int(11) NOT NULL,
  `SoLuongSua` int(11) NOT NULL,
  `ThanhTien` double NOT NULL,
  `TiLe` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `ct_bcdoanhso`
--

INSERT INTO `ct_bcdoanhso` (`MaBC`, `MaHieuXe`, `SoLuongSua`, `ThanhTien`, `TiLe`) VALUES
(1, 3, 2, 1857500, 0.38859832286834717),
(1, 5, 1, 1345000, 0.2813807427883148),
(1, 9, 2, 1577500, 0.330020934343338);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `ct_phieunhap`
--

CREATE TABLE `ct_phieunhap` (
  `MaPN` int(11) NOT NULL,
  `MaVTPT` int(11) NOT NULL,
  `SoLuongNhap` int(11) NOT NULL,
  `DonGiaNhap` double NOT NULL,
  `ThanhTien` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `ct_phieunhap`
--

INSERT INTO `ct_phieunhap` (`MaPN`, `MaVTPT`, `SoLuongNhap`, `DonGiaNhap`, `ThanhTien`) VALUES
(3, 2, 53, 200000, 10600000),
(9, 6, 5, 30000, 150000),
(10, 7, 5, 5000, 25000),
(11, 7, 10, 5000, 50000);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `ct_phieusuachua`
--

CREATE TABLE `ct_phieusuachua` (
  `MaCT_PSC` int(11) NOT NULL,
  `SoPSC` int(11) NOT NULL,
  `NoiDungSC` varchar(255) NOT NULL,
  `MaTC` int(11) NOT NULL,
  `SoLan` int(11) NOT NULL,
  `TongTienCong` double NOT NULL,
  `TongTienVTPT` double NOT NULL,
  `TongCong` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `ct_phieusuachua`
--

INSERT INTO `ct_phieusuachua` (`MaCT_PSC`, `SoPSC`, `NoiDungSC`, `MaTC`, `SoLan`, `TongTienCong`, `TongTienVTPT`, `TongCong`) VALUES
(5, 1, 'Sửa gương', 7, 5, 1000000, 157500, 1157500),
(6, 2, 'Sửa má phanh', 7, 2, 400000, 945000, 1345000),
(7, 3, 'Sửa vỏ xe', 1, 5, 500000, 367500, 867500),
(9, 5, 'Sửa vỏ xe', 1, 5, 500000, 210000, 710000),
(10, 6, '', 1, 1, 100000, 600000, 700000),
(11, 7, 'Nội dung sửa chữa', 1, 2, 200000, 6000, 206000);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `ct_sudungvtpt`
--

CREATE TABLE `ct_sudungvtpt` (
  `MaCT_PSC` int(11) NOT NULL,
  `MaVTPT` int(11) NOT NULL,
  `SoLuong` int(11) NOT NULL,
  `DonGia` double NOT NULL,
  `ThanhTien` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `ct_sudungvtpt`
--

INSERT INTO `ct_sudungvtpt` (`MaCT_PSC`, `MaVTPT`, `SoLuong`, `DonGia`, `ThanhTien`) VALUES
(5, 1, 3, 52500, 157500),
(6, 3, 3, 315000, 945000),
(7, 1, 7, 52500, 367500),
(9, 1, 4, 52500, 210000),
(10, 2, 2, 300000, 600000),
(11, 7, 1, 6000, 6000);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `dangnhap`
--

CREATE TABLE `dangnhap` (
  `UserID` int(11) NOT NULL,
  `Username` varchar(20) NOT NULL,
  `Password` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `dangnhap`
--

INSERT INTO `dangnhap` (`UserID`, `Username`, `Password`) VALUES
(1, 'manhhc', '1'),
(2, 'hangntt', '1'),
(3, 'khoiptx', '1'),
(4, 'huongbt', '1'),
(5, 'hans', '1'),
(6, 'q', 'q');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `hieuxe`
--

CREATE TABLE `hieuxe` (
  `MaHieuXe` int(11) NOT NULL,
  `TenHieuXe` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `hieuxe`
--

INSERT INTO `hieuxe` (`MaHieuXe`, `TenHieuXe`) VALUES
(1, 'Honda2017'),
(2, 'Honda2017'),
(3, 'Honda2018'),
(4, 'Wave4550'),
(5, 'Wave4551'),
(6, 'Wave4554'),
(7, 'Wave4556'),
(8, 'Wave4557'),
(9, 'Wave45555'),
(10, 'Wave4559');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `phieunhapvtpt`
--

CREATE TABLE `phieunhapvtpt` (
  `MaPN` int(11) NOT NULL,
  `NgayNhap` date NOT NULL,
  `TongTien` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `phieunhapvtpt`
--

INSERT INTO `phieunhapvtpt` (`MaPN`, `NgayNhap`, `TongTien`) VALUES
(3, '2023-06-22', 10600000),
(9, '2023-06-07', 175000),
(10, '2023-06-07', 175000),
(11, '2023-05-24', 50000);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `phieusuachua`
--

CREATE TABLE `phieusuachua` (
  `SoPSC` int(11) NOT NULL,
  `BienSo` varchar(255) NOT NULL,
  `NgaySuaChua` date NOT NULL,
  `TongTien` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `phieusuachua`
--

INSERT INTO `phieusuachua` (`SoPSC`, `BienSo`, `NgaySuaChua`, `TongTien`) VALUES
(1, '38N1-00234', '2023-06-30', 1157500),
(2, '22D9-00257', '2023-06-24', 1345000),
(3, '38N1-00236', '2023-06-25', 867500),
(5, '38N1-00238', '2023-06-26', 710000),
(6, '38N1-00234', '2023-06-27', 700000),
(7, '38N1-00236', '2023-06-23', 206000);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `phieuthutien`
--

CREATE TABLE `phieuthutien` (
  `SoPhieu` int(11) NOT NULL,
  `BienSo` varchar(255) NOT NULL,
  `NgayThu` date NOT NULL,
  `SoTienThu` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `phieuthutien`
--

INSERT INTO `phieuthutien` (`SoPhieu`, `BienSo`, `NgayThu`, `SoTienThu`) VALUES
(2, '38N1-00236', '2023-06-30', 582),
(3, '38N1-00236', '2024-06-22', 8);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `thamso`
--

CREATE TABLE `thamso` (
  `TenThamSo` varchar(255) NOT NULL,
  `GiaTri` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `thamso`
--

INSERT INTO `thamso` (`TenThamSo`, `GiaTri`) VALUES
('SoLuongTienCong', 11),
('SoLuongVTPT', 7),
('SoXeSuaChuaTrongNgay', 10),
('TenHieuXe', 10),
('TiLeGiaBan', 1.2);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tiencong`
--

CREATE TABLE `tiencong` (
  `MaTC` int(11) NOT NULL,
  `TenTC` varchar(255) NOT NULL,
  `GiaTien` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tiencong`
--

INSERT INTO `tiencong` (`MaTC`, `TenTC`, `GiaTien`) VALUES
(1, 'Sửa chữa lớn', 100000),
(2, 'Sửa chữa vừa', 50000),
(3, 'Sửa chữa nhỏ', 20000),
(4, 'Thay lọc gió', 200000),
(5, 'Thay dầu hộp số', 200000),
(6, 'Vệ sinh hệ thống làm mát', 200000),
(7, 'Kiểm tra và sửa chữa hệ thống phanh', 200000),
(8, 'Điều chỉnh và kiểm tra hệ thống treo', 200000),
(9, 'Thay dây curoa động cơ', 200000),
(10, 'Kiểm tra và sửa chữa hệ thống điện', 200000);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `vattuphutung`
--

CREATE TABLE `vattuphutung` (
  `MaVTPT` int(11) NOT NULL,
  `TenVTPT` varchar(255) NOT NULL,
  `DonGiaNhap` double NOT NULL,
  `DonGiaBan` double NOT NULL,
  `SoLuongTon` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `vattuphutung`
--

INSERT INTO `vattuphutung` (`MaVTPT`, `TenVTPT`, `DonGiaNhap`, `DonGiaBan`, `SoLuongTon`) VALUES
(1, 'Vỏ xe', 50000, 75000, 389),
(2, 'gương', 200000, 300000, 51),
(3, 'má phanh', 3000, 315000, 114),
(6, 'Bánh xe sau', 30000, 31500, 5),
(7, 'Đầu xe', 5000, 6000, 9);

-- --------------------------------------------------------

--
-- Cấu trúc đóng vai cho view `view_phieunhap`
-- (See below for the actual view)
--
CREATE TABLE `view_phieunhap` (
`MaPN` int(11)
,`MaVTPT` int(11)
,`SoLuongNhap` int(11)
,`DonGiaNhap` double
,`ThanhTien` double
,`TenVTPT` varchar(255)
,`NgayNhap` date
,`TongTien` double
);

-- --------------------------------------------------------

--
-- Cấu trúc đóng vai cho view `view_xe`
-- (See below for the actual view)
--
CREATE TABLE `view_xe` (
`BienSo` varchar(255)
,`TongTien` double
,`SoTienThu` double
,`TenChuXe` varchar(255)
,`MaHieuXe` int(11)
,`DiaChi` varchar(255)
,`DienThoai` varchar(255)
,`NgayTiepNhan` date
,`TienNo` double
);

-- --------------------------------------------------------

--
-- Cấu trúc đóng vai cho view `v_doanhthu`
-- (See below for the actual view)
--
CREATE TABLE `v_doanhthu` (
`sum(TongDoanhThu)` double
);

-- --------------------------------------------------------

--
-- Cấu trúc đóng vai cho view `v_hieuxe`
-- (See below for the actual view)
--
CREATE TABLE `v_hieuxe` (
`MaHieuXe` int(11)
,`TenHieuXe` varchar(255)
);

-- --------------------------------------------------------

--
-- Cấu trúc đóng vai cho view `v_sanpham`
-- (See below for the actual view)
--
CREATE TABLE `v_sanpham` (
`total_product` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Cấu trúc đóng vai cho view `v_slsua`
-- (See below for the actual view)
--
CREATE TABLE `v_slsua` (
`sum(SoLuongSua)` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Cấu trúc đóng vai cho view `v_soluongtiencong`
-- (See below for the actual view)
--
CREATE TABLE `v_soluongtiencong` (
`TenThamSo` varchar(255)
,`GiaTri` double
);

-- --------------------------------------------------------

--
-- Cấu trúc đóng vai cho view `v_soluongvtpt`
-- (See below for the actual view)
--
CREATE TABLE `v_soluongvtpt` (
`TenThamSo` varchar(255)
,`GiaTri` double
);

-- --------------------------------------------------------

--
-- Cấu trúc đóng vai cho view `v_soluongxesuachua`
-- (See below for the actual view)
--
CREATE TABLE `v_soluongxesuachua` (
`TenThamSo` varchar(255)
,`GiaTri` double
);

-- --------------------------------------------------------

--
-- Cấu trúc đóng vai cho view `v_tiledongia`
-- (See below for the actual view)
--
CREATE TABLE `v_tiledongia` (
`TenThamSo` varchar(255)
,`GiaTri` double
);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `xe`
--

CREATE TABLE `xe` (
  `BienSo` varchar(255) NOT NULL,
  `TenChuXe` varchar(255) NOT NULL,
  `MaHieuXe` int(11) NOT NULL,
  `DiaChi` varchar(255) NOT NULL,
  `DienThoai` varchar(255) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `NgayTiepNhan` date NOT NULL,
  `TienNo` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `xe`
--

INSERT INTO `xe` (`BienSo`, `TenChuXe`, `MaHieuXe`, `DiaChi`, `DienThoai`, `Email`, `NgayTiepNhan`, `TienNo`) VALUES
('22D9-00257', 'Nguyen Hang', 5, 'Dak Mil - n1', '0987654321', '', '2023-06-06', 0),
('38N1-00234', 'Nguyễn Sơn Hà', 3, '121/55/3a Ba Cu', '0838460994', '', '2023-06-23', 0),
('38N1-00236', 'Nguyễn Hằng', 9, '121/55/3a Ba Cu', '838460994', 'sdsd@dfd.fds', '2023-06-21', 866918),
('38N1-00237', 'Công Mạnh', 1, '121/55/3a Ba Cu', '0838852446', '21522029@gm.uit.edu.vn', '2023-06-26', 0),
('38N1-00238', 'Khôi Nguyễn', 9, '121/55/3a Ba Cu', '09957526445', '', '2023-06-21', 0);

-- --------------------------------------------------------

--
-- Cấu trúc cho view `view_phieunhap`
--
DROP TABLE IF EXISTS `view_phieunhap`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_phieunhap`  AS SELECT `ct`.`MaPN` AS `MaPN`, `ct`.`MaVTPT` AS `MaVTPT`, `ct`.`SoLuongNhap` AS `SoLuongNhap`, `ct`.`DonGiaNhap` AS `DonGiaNhap`, `ct`.`ThanhTien` AS `ThanhTien`, `vt`.`TenVTPT` AS `TenVTPT`, `pn`.`NgayNhap` AS `NgayNhap`, `pn`.`TongTien` AS `TongTien` FROM ((`ct_phieunhap` `ct` join `vattuphutung` `vt` on(`ct`.`MaVTPT` = `vt`.`MaVTPT`)) join `phieunhapvtpt` `pn` on(`ct`.`MaPN` = `pn`.`MaPN`)) ;

-- --------------------------------------------------------

--
-- Cấu trúc cho view `view_xe`
--
DROP TABLE IF EXISTS `view_xe`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_xe`  AS SELECT `ps`.`BienSo` AS `BienSo`, `ps`.`TongTien` AS `TongTien`, `pt`.`SoTienThu` AS `SoTienThu`, `x`.`TenChuXe` AS `TenChuXe`, `x`.`MaHieuXe` AS `MaHieuXe`, `x`.`DiaChi` AS `DiaChi`, `x`.`DienThoai` AS `DienThoai`, `x`.`NgayTiepNhan` AS `NgayTiepNhan`, `x`.`TienNo` AS `TienNo` FROM ((`phieusuachua` `ps` join `xe` `x` on(`ps`.`BienSo` = `x`.`BienSo`)) left join `phieuthutien` `pt` on(`x`.`BienSo` = `pt`.`BienSo`)) ;

-- --------------------------------------------------------

--
-- Cấu trúc cho view `v_doanhthu`
--
DROP TABLE IF EXISTS `v_doanhthu`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_doanhthu`  AS SELECT sum(`baocaodoanhso`.`TongDoanhThu`) AS `sum(TongDoanhThu)` FROM `baocaodoanhso` WHERE month(curdate()) = `baocaodoanhso`.`Thang` AND year(curdate()) = `baocaodoanhso`.`Nam` ;

-- --------------------------------------------------------

--
-- Cấu trúc cho view `v_hieuxe`
--
DROP TABLE IF EXISTS `v_hieuxe`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_hieuxe`  AS SELECT `hieuxe`.`MaHieuXe` AS `MaHieuXe`, `hieuxe`.`TenHieuXe` AS `TenHieuXe` FROM `hieuxe` ;

-- --------------------------------------------------------

--
-- Cấu trúc cho view `v_sanpham`
--
DROP TABLE IF EXISTS `v_sanpham`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_sanpham`  AS SELECT sum(`vattuphutung`.`SoLuongTon`) AS `total_product` FROM `vattuphutung` ;

-- --------------------------------------------------------

--
-- Cấu trúc cho view `v_slsua`
--
DROP TABLE IF EXISTS `v_slsua`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_slsua`  AS SELECT sum(`ct_bcdoanhso`.`SoLuongSua`) AS `sum(SoLuongSua)` FROM (`ct_bcdoanhso` join `baocaodoanhso` on(`ct_bcdoanhso`.`MaBC` = `baocaodoanhso`.`MaBC`)) WHERE month(curdate()) = `baocaodoanhso`.`Thang` AND year(curdate()) = `baocaodoanhso`.`Nam` ;

-- --------------------------------------------------------

--
-- Cấu trúc cho view `v_soluongtiencong`
--
DROP TABLE IF EXISTS `v_soluongtiencong`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_soluongtiencong`  AS SELECT `ts`.`TenThamSo` AS `TenThamSo`, `ts`.`GiaTri` AS `GiaTri` FROM `thamso` AS `ts` WHERE `ts`.`TenThamSo` like 'SoLuongTienCong' ;

-- --------------------------------------------------------

--
-- Cấu trúc cho view `v_soluongvtpt`
--
DROP TABLE IF EXISTS `v_soluongvtpt`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_soluongvtpt`  AS SELECT `ts`.`TenThamSo` AS `TenThamSo`, `ts`.`GiaTri` AS `GiaTri` FROM `thamso` AS `ts` WHERE `ts`.`TenThamSo` like 'SoLuongVTPT' ;

-- --------------------------------------------------------

--
-- Cấu trúc cho view `v_soluongxesuachua`
--
DROP TABLE IF EXISTS `v_soluongxesuachua`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_soluongxesuachua`  AS SELECT `ts`.`TenThamSo` AS `TenThamSo`, `ts`.`GiaTri` AS `GiaTri` FROM `thamso` AS `ts` WHERE `ts`.`TenThamSo` like 'SoXeSuaChuaTrongNgay' ;

-- --------------------------------------------------------

--
-- Cấu trúc cho view `v_tiledongia`
--
DROP TABLE IF EXISTS `v_tiledongia`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_tiledongia`  AS SELECT `thamso`.`TenThamSo` AS `TenThamSo`, `thamso`.`GiaTri` AS `GiaTri` FROM `thamso` WHERE `thamso`.`TenThamSo` like 'TiLeGiaBan' ;

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `baocaodoanhso`
--
ALTER TABLE `baocaodoanhso`
  ADD PRIMARY KEY (`MaBC`);

--
-- Chỉ mục cho bảng `baocaoton`
--
ALTER TABLE `baocaoton`
  ADD PRIMARY KEY (`Thang`,`Nam`,`MaVTPT`),
  ADD KEY `FK_BCTON_VTPT` (`MaVTPT`);

--
-- Chỉ mục cho bảng `ct_bcdoanhso`
--
ALTER TABLE `ct_bcdoanhso`
  ADD PRIMARY KEY (`MaBC`,`MaHieuXe`),
  ADD KEY `FK_CTBCDS_HX` (`MaHieuXe`);

--
-- Chỉ mục cho bảng `ct_phieunhap`
--
ALTER TABLE `ct_phieunhap`
  ADD PRIMARY KEY (`MaPN`,`MaVTPT`),
  ADD KEY `FK_CTPN_VTPT` (`MaVTPT`);

--
-- Chỉ mục cho bảng `ct_phieusuachua`
--
ALTER TABLE `ct_phieusuachua`
  ADD PRIMARY KEY (`MaCT_PSC`),
  ADD KEY `FK_CTPSC_PSC` (`SoPSC`);

--
-- Chỉ mục cho bảng `ct_sudungvtpt`
--
ALTER TABLE `ct_sudungvtpt`
  ADD PRIMARY KEY (`MaCT_PSC`,`MaVTPT`) USING BTREE,
  ADD KEY `FK_CTSDVTPT_VTPT` (`MaVTPT`);

--
-- Chỉ mục cho bảng `dangnhap`
--
ALTER TABLE `dangnhap`
  ADD PRIMARY KEY (`UserID`);

--
-- Chỉ mục cho bảng `hieuxe`
--
ALTER TABLE `hieuxe`
  ADD PRIMARY KEY (`MaHieuXe`);

--
-- Chỉ mục cho bảng `phieunhapvtpt`
--
ALTER TABLE `phieunhapvtpt`
  ADD PRIMARY KEY (`MaPN`);

--
-- Chỉ mục cho bảng `phieusuachua`
--
ALTER TABLE `phieusuachua`
  ADD PRIMARY KEY (`SoPSC`),
  ADD KEY `FK_PHIEUSUACHUA_XE` (`BienSo`);

--
-- Chỉ mục cho bảng `phieuthutien`
--
ALTER TABLE `phieuthutien`
  ADD PRIMARY KEY (`SoPhieu`),
  ADD KEY `FK_PHIEUTHUTIEN` (`BienSo`);

--
-- Chỉ mục cho bảng `thamso`
--
ALTER TABLE `thamso`
  ADD PRIMARY KEY (`TenThamSo`);

--
-- Chỉ mục cho bảng `tiencong`
--
ALTER TABLE `tiencong`
  ADD PRIMARY KEY (`MaTC`);

--
-- Chỉ mục cho bảng `vattuphutung`
--
ALTER TABLE `vattuphutung`
  ADD PRIMARY KEY (`MaVTPT`);

--
-- Chỉ mục cho bảng `xe`
--
ALTER TABLE `xe`
  ADD PRIMARY KEY (`BienSo`),
  ADD KEY `FK_XE_HIEUXE` (`MaHieuXe`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `baocaodoanhso`
--
ALTER TABLE `baocaodoanhso`
  MODIFY `MaBC` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `ct_phieusuachua`
--
ALTER TABLE `ct_phieusuachua`
  MODIFY `MaCT_PSC` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT cho bảng `ct_sudungvtpt`
--
ALTER TABLE `ct_sudungvtpt`
  MODIFY `MaCT_PSC` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT cho bảng `dangnhap`
--
ALTER TABLE `dangnhap`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `phieunhapvtpt`
--
ALTER TABLE `phieunhapvtpt`
  MODIFY `MaPN` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT cho bảng `phieusuachua`
--
ALTER TABLE `phieusuachua`
  MODIFY `SoPSC` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT cho bảng `phieuthutien`
--
ALTER TABLE `phieuthutien`
  MODIFY `SoPhieu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT cho bảng `tiencong`
--
ALTER TABLE `tiencong`
  MODIFY `MaTC` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT cho bảng `vattuphutung`
--
ALTER TABLE `vattuphutung`
  MODIFY `MaVTPT` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `baocaoton`
--
ALTER TABLE `baocaoton`
  ADD CONSTRAINT `FK_BCTON_VTPT` FOREIGN KEY (`MaVTPT`) REFERENCES `vattuphutung` (`MaVTPT`);

--
-- Các ràng buộc cho bảng `ct_bcdoanhso`
--
ALTER TABLE `ct_bcdoanhso`
  ADD CONSTRAINT `FK_CTBCDS_BCDS` FOREIGN KEY (`MaBC`) REFERENCES `baocaodoanhso` (`MaBC`),
  ADD CONSTRAINT `FK_CTBCDS_HX` FOREIGN KEY (`MaHieuXe`) REFERENCES `hieuxe` (`MaHieuXe`);

--
-- Các ràng buộc cho bảng `ct_phieunhap`
--
ALTER TABLE `ct_phieunhap`
  ADD CONSTRAINT `FK_CTPN_PNVTPT` FOREIGN KEY (`MaPN`) REFERENCES `phieunhapvtpt` (`MaPN`),
  ADD CONSTRAINT `FK_CTPN_VTPT` FOREIGN KEY (`MaVTPT`) REFERENCES `vattuphutung` (`MaVTPT`);

--
-- Các ràng buộc cho bảng `ct_phieusuachua`
--
ALTER TABLE `ct_phieusuachua`
  ADD CONSTRAINT `FK_CTPSC_PSC` FOREIGN KEY (`SoPSC`) REFERENCES `phieusuachua` (`SoPSC`);

--
-- Các ràng buộc cho bảng `ct_sudungvtpt`
--
ALTER TABLE `ct_sudungvtpt`
  ADD CONSTRAINT `FK_CTSDVTPT_CTPSC` FOREIGN KEY (`MaCT_PSC`) REFERENCES `ct_phieusuachua` (`MaCT_PSC`),
  ADD CONSTRAINT `FK_CTSDVTPT_VTPT` FOREIGN KEY (`MaVTPT`) REFERENCES `vattuphutung` (`MaVTPT`);

--
-- Các ràng buộc cho bảng `phieusuachua`
--
ALTER TABLE `phieusuachua`
  ADD CONSTRAINT `FK_PHIEUSUACHUA_XE` FOREIGN KEY (`BienSo`) REFERENCES `xe` (`BienSo`);

--
-- Các ràng buộc cho bảng `phieuthutien`
--
ALTER TABLE `phieuthutien`
  ADD CONSTRAINT `FK_PHIEUTHUTIEN` FOREIGN KEY (`BienSo`) REFERENCES `xe` (`BienSo`);

--
-- Các ràng buộc cho bảng `xe`
--
ALTER TABLE `xe`
  ADD CONSTRAINT `FK_XE_HIEUXE` FOREIGN KEY (`MaHieuXe`) REFERENCES `hieuxe` (`MaHieuXe`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
