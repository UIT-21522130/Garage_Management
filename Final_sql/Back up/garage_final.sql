-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 21, 2023 at 05:03 AM
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
-- Database: `garage_final`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCarBrand` (IN `i_HieuXe` VARCHAR(255) CHARSET utf8)  BEGIN
delete from hieuxe
where HieuXe = i_HieuXe;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteWage` (IN `i_MaTC` INT(11))  BEGIN
DECLARE i_SoPSC int;
DECLARE i_SoLuong int;

SET i_SoPSC = (SELECT SoPSC from ct_phieusuachua where ct_phieusuachua.MaTC = i_MaTC);
SET i_SoLuong = (SELECT SoLuong from ct_sudungvtpt join ct_phieusuachua WHERE ct_sudungvtpt.MaCT_PSC = ct_phieusuachua.MaCT_PSC AND MaTC = i_MaTC);

CALL P_DelRepairList(i_SoPSC, i_SoLuong);

delete from tiencong
where MaTC = i_MaTC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `findCar` (IN `i_BienSo` VARCHAR(255) CHARSET utf8)  BEGIN
Select ROW_NUMBER() OVER (ORDER BY BienSo) AS STT, BienSo, HieuXe, TenChuXe, TienNo from xe
where BienSo like concat(concat('%',i_BienSo),'%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `findCarBrand` (IN `i_HieuXe` VARCHAR(255) CHARSET utf8)  BEGIN
SELECT HieuXe, GhiChu from hieuxe 
WHERE HieuXe like concat(concat('%',i_HieuXe),'%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `findWage` (IN `i_TenTC` VARCHAR(255))  BEGIN
Select MaTC, TenTC, GiaTien from tiencong
where TenTC like concat(concat('%',i_TenTC),'%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertCarBrand` (IN `i_HieuXe` VARCHAR(255) CHARSET utf8, IN `i_GhiChu` VARCHAR(255) CHARSET utf8)  BEGIN
insert into hieuxe(HieuXe, GhiChu) values (i_HieuXe, i_GhiChu);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertWage` (IN `i_MaTC` INT(11), IN `i_TenTC` VARCHAR(255), IN `i_Gia` DOUBLE)  BEGIN
insert into tiencong(MaTC, TenTC, GiaTien) values (i_MaTC, i_TenTC, i_Gia);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_AddBCSale` (IN `i_MonthSale` INT(255), IN `i_YearSale` INT(255))  BEGIN
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
        t_HieuXe VARCHAR(255) NOT NULL,
        t_SLSC INT UNSIGNED DEFAULT 0,
        t_ThanhTien INT UNSIGNED DEFAULT 0,
        t_TiLe FLOAT
    );
  
    WHILE counter_t < count_SHX DO
        INSERT INTO t_hieuxe (t_MaHX, t_HieuXe, t_SLSC, t_ThanhTien)
        SELECT new_MaBC , HieuXe, (
            SELECT COUNT(SoPSC)
            FROM xe
            INNER JOIN phieusuachua ON xe.BienSo = phieusuachua.BienSo
            WHERE MONTH(NgaySuaChua) = i_MonthSale AND YEAR(NgaySuaChua) = i_YearSale
            GROUP BY HieuXe
            ORDER BY MONTH(NgaySuaChua)
            LIMIT counter_R, 1
        ), (
            SELECT SUM(TongTien)
            FROM phieusuachua
            INNER JOIN xe ON phieusuachua.BienSo = xe.BienSo 
            WHERE MONTH(NgaySuaChua) = i_MonthSale AND YEAR(NgaySuaChua) = i_YearSale
            GROUP BY HieuXe
            ORDER BY MONTH(NgaySuaChua)
            LIMIT counter_R, 1
        )
        FROM (
            SELECT DISTINCT new_MaBC , HieuXe
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
    
    INSERT INTO ct_bcdoanhso(MaBC, HieuXe, SoLuongSua, ThanhTien, TiLe)
    SELECT new_MaBC, t_HieuXe, t_SLSC, t_ThanhTien, t_TiLe FROM t_hieuxe;
    
    DROP TEMPORARY TABLE IF EXISTS t_hieuxe;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_AddBCTon` (IN `i_MonthTon` INT(255), IN `i_YearTon` INT(255))  BEGIN
DECLARE counter_t INT DEFAULT 0;
DECLARE counter_R INT DEFAULT 0;
DECLARE counter_VTPT INT DEFAULT 0;
DECLARE check_Month INT DEFAULT 0;
DECLARE check_Year INT DEFAULT 0;

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

SET counter_VTPT = (SELECT COUNT(vattuphutung.MaVTPT) FROM vattuphutung 
                    INNER JOIN ct_phieunhap
                    ON vattuphutung.MaVTPT = ct_phieunhap.MaVTPT
                    INNER JOIN phieunhapvtpt 
                    ON ct_phieunhap.MaPN = phieunhapvtpt.MaPN
                    WHERE MONTH(NgayNhap) = i_MonthTon AND YEAR(NgayNhap) = i_YearTon);

WHILE counter_t < counter_VTPT DO
	INSERT INTO t_baocaoton(t_thang, t_nam, t_Mavtpt, t_TonDau, t_PhatSinh, t_TonCuoi)
    SELECT i_MonthTon, i_YearTon,
      (SELECT vattuphutung.MaVTPT
       FROM vattuphutung
       INNER JOIN ct_phieunhap ON vattuphutung.MaVTPT = ct_phieunhap.MaVTPT
       INNER JOIN phieunhapvtpt ON phieunhapvtpt.MaPN = ct_phieunhap.MaPN
       WHERE MONTH(NgayNhap) = i_MonthTon AND YEAR(NgayNhap) = i_YearTon
       ORDER BY vattuphutung.MaVTPT
       LIMIT counter_R, 1),
      (SELECT SoLuongTon
       FROM vattuphutung
       INNER JOIN ct_phieunhap ON vattuphutung.MaVTPT = ct_phieunhap.MaVTPT
       INNER JOIN phieunhapvtpt ON phieunhapvtpt.MaPN = ct_phieunhap.MaPN
       WHERE MONTH(NgayNhap) = check_Month - 1 AND YEAR(NgayNhap) = i_YearTon
       ORDER BY vattuphutung.MaVTPT
       LIMIT counter_R, 1),
      (SELECT SUM(SoLuongNhap)
       FROM ct_phieunhap
       INNER JOIN phieunhapvtpt ON ct_phieunhap.MaPN = phieunhapvtpt.MaPN
       WHERE MONTH(NgayNhap) = i_MonthTon AND YEAR(NgayNhap) = i_YearTon
       GROUP BY MaVTPT
       ORDER BY MaVTPT
       LIMIT counter_R, 1),
      (SELECT SoLuongTon
       FROM vattuphutung
       INNER JOIN ct_phieunhap ON vattuphutung.MaVTPT = ct_phieunhap.MaVTPT
       INNER JOIN phieunhapvtpt ON phieunhapvtpt.MaPN = ct_phieunhap.MaPN
       WHERE MONTH(NgayNhap) = i_MonthTon AND YEAR(NgayNhap) = i_YearTon
       ORDER BY vattuphutung.MaVTPT
       LIMIT counter_R, 1);
   
   SET counter_t = counter_t + 1;
   SET counter_R = counter_R + 1;
   END WHILE;
   
   INSERT INTO baocaoton(Thang, Nam, MaVTPT, TonDau, PhatSinh, TonCuoi) 
   SELECT t_thang, t_nam, t_Mavtpt, t_TonDau, t_PhatSinh, t_TonCuoi FROM t_baocaoton;
   
   DROP TEMPORARY TABLE IF EXISTS t_baocaoton;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_AddRepairList` (IN `i_BienSoXe` VARCHAR(255), IN `i_NgaySuaChua` DATE, IN `i_VatTuPhuTung` VARCHAR(255), IN `i_SoLuong` INT(255), IN `i_GiaVT` FLOAT, IN `i_LoaiTienCong` VARCHAR(255), IN `i_SoLan` INT(255), IN `i_GiaTC` FLOAT, IN `i_NoiDungSC` VARCHAR(255))  NO SQL
BEGIN 
    DECLARE max_SoPSC INT unsigned DEFAULT 0;
    DECLARE max_MaSPSC INT unsigned DEFAULT 0;
    DECLARE new_SoPSC INT unsigned DEFAULT 0;
    DECLARE new_MaSPSC INT unsigned DEFAULT 0;
    DECLARE new_MaTC INT unsigned DEFAULT 0;
    DECLARE new_GiaTC INT unsigned DEFAULT 0;
    DECLARE new_TongTC INT unsigned DEFAULT 0;
    DECLARE new_MaVTPT INT unsigned DEFAULT 0;
    DECLARE new_TongPT INT unsigned DEFAULT 0;
    
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
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_BCSale` (IN `i_HieuXe` VARCHAR(255))  BEGIN   
    SELECT Thang AS MonthSale, Nam AS YearSale, SUM(ThanhTien) AS TotalSale
   FROM ct_bcdoanhso INNER JOIN baocaodoanhso
   ON ct_bcdoanhso.MaBC = baocaodoanhso.MaBC
    WHERE HieuXe = i_HieuXe;    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_BCTon` (IN `i_vattuphutung` VARCHAR(255))  BEGIN 

	SELECT Thang AS MonthReport, Nam AS YearReport
    FROM baocaoton INNER JOIN vattuphutung
    ON baocaoton.MaVTPT = vattuphutung.MaVTPT
    WHERE vattuphutung.TenVTPT = i_vattuphutung;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Bill_Delete` (IN `i_BienSoXe` VARCHAR(255) CHARSET utf8, IN `i_ngaythutien` DATE)  BEGIN
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
        end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Bill_Insert` (IN `i_BienSoXe` VARCHAR(255) CHARSET utf8, IN `i_ngaythutien` DATE, IN `i_sotienthu` FLOAT)  BEGIN
    DECLARE max_SP INT UNSIGNED;

    -- Check if the provided BienSo exists in the xe table
    SELECT MAX(SoPhieu) INTO max_SP
    FROM phieuthutien;
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
        VALUES (max_SP + 1, i_BienSoXe, i_ngaythutien, i_sotienthu);
        SET max_SP = max_SP + 1; -- Update the value of max_SP
    END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Bill_Update` (IN `i_SP` INT, IN `i_BienSoXe` VARCHAR(255) CHARSET utf8, IN `i_ngaythutien` DATE, IN `i_sotienthu` FLOAT)  BEGIN    
    UPDATE phieuthutien
    SET SoTienThu = i_sotienthu,
        NgayThu = i_ngaythutien,
        BienSo = i_BienSoXe
    WHERE SoPhieu = i_SP
    LIMIT 1;

    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_BSX_Com2` (IN `i_BienSoXe` VARCHAR(255) CHARSET utf8)  BEGIN
	SELECT TenChuXe, DienThoai, Email
    from xe
    where BienSo = i_BienSoXe;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_CapNhap_VTPT` (IN `i_NgayNhap` DATE, IN `i_TenVTPT` VARCHAR(255), IN `i_SoLuongNhap` INT(11), IN `i_DonGiaNhap` DOUBLE, IN `i_MaPN` INT(11), IN `i_MaVTPT` INT(11))  BEGIN
    -- Update the record in the phieunhapvtpt table
    UPDATE phieunhapvtpt
    SET NgayNhap = i_NgayNhap
    WHERE MaPN = i_MaPN;



    
    -- Update the record in the vattuphutung table
    UPDATE vattuphutung
    SET TenVTPT = i_TenVTPT,
        DonGiaNhap = i_DonGiaNhap,
        SoLuongTon = i_SoLuongNhap
    WHERE MaVTPT = i_MaVTPT;
    
    -- Update the record in the ct_phieunhap table
    UPDATE ct_phieunhap
    SET DonGiaNhap = i_DonGiaNhap,
        SoLuongNhap = i_SoLuongNhap,
        ThanhTien = i_DonGiaNhap * i_SoLuongNhap
    WHERE MaPN = i_MaPN AND MaVTPT = i_MaVTPT;
    
    UPDATE phieunhapvtpt
    SET TongTien = (SELECT SUM(ThanhTien) FROM ct_phieunhap);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_CapNhap_Xe` (IN `i_TenChuXe` VARCHAR(255), IN `i_HieuXe` VARCHAR(255), IN `i_DiaChi` VARCHAR(255), IN `i_DienThoai` INT(11), IN `i_NgayTiepNhan` DATE, IN `i_BienSo` VARCHAR(255))  BEGIN
    DECLARE i_TongTien INT;
    DECLARE i_SoTienThu INT;
    DECLARE i_TienNo INT;

    -- Check if the 'BienSo' value already exists in the 'Xe' table
    IF EXISTS (SELECT 1 FROM Xe WHERE BienSo = i_BienSo) THEN
        -- Load all the information related to the existing 'BienSo'
        SELECT TongTien INTO i_TongTien FROM PhieuSuaChua WHERE BienSo = i_BienSo;
        SELECT SoTienThu INTO i_SoTienThu FROM PhieuThuTien WHERE BienSo = i_BienSo;
        
        -- Update the existing record in the Xe table
        UPDATE Xe
        SET TenChuXe = i_TenChuXe,
            HieuXe = i_HieuXe,
            DiaChi = i_DiaChi,
            DienThoai = i_DienThoai,
            NgayTiepNhan = i_NgayTiepNhan
        WHERE BienSo = i_BienSo;
        
        -- Calculate the TienNo
        SET i_TienNo = i_TongTien - i_SoTienThu;

        -- Update the TienNo in the Xe table
        UPDATE Xe
        SET TienNo = i_TienNo
        WHERE BienSo = i_BienSo;
    ELSE
        -- Insert the record into the Xe table
        INSERT INTO Xe (BienSo, TenChuXe, HieuXe, DiaChi, DienThoai, NgayTiepNhan)
        VALUES (i_BienSo, i_TenChuXe, i_HieuXe, i_DiaChi, i_DienThoai, i_NgayTiepNhan);
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Change_BrandCar` (IN `i_hieuxecu` VARCHAR(255), IN `i_hieuxemoi` VARCHAR(255), IN `i_ghichu` VARCHAR(255), OUT `o_ketqua` INT, OUT `o_msg` VARCHAR(255))  BEGIN    
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_CheckBCOverwritten` (IN `i_MonthSale` INT, IN `i_YearSale` INT)  BEGIN
SELECT COUNT(*) AS DEM
    FROM baocaodoanhso
    WHERE Thang = i_MonthSale AND Nam = i_YearSale;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_CheckOverwritten` (IN `i_BienSoXe` VARCHAR(255) CHARSET utf8, IN `i_NgaySuaChua` DATE, IN `i_NoiDung` VARCHAR(255))  NO SQL
BEGIN
	SELECT COUNT(*) AS DEM
    FROM phieusuachua
    INNER JOIN ct_phieusuachua
    ON phieusuachua.SoPSC = ct_phieusuachua.SoPSC  	
    WHERE phieusuachua.BienSo = i_BienSoXe AND phieusuachua.NgaySuaChua = i_NgaySuaChua AND ct_phieusuachua.NoiDungSC = i_NoiDung;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Checkoverwritten_Bill` (IN `i_SP` INT, IN `i_BienSoXe` VARCHAR(255) CHARSET utf8, IN `i_ngaythutien` DATE, OUT `o_output` INT)  BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_CheckTonOverwritten` (IN `i_MonthReport` INT, IN `i_YearReport` INT)  BEGIN
SELECT COUNT(*) AS DEM
    FROM baocaoton
    WHERE Thang = i_MonthReport AND Nam = i_YearReport;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_CheckUpwritten` (IN `i_SoPSC` INT, IN `i_BienSoXe` VARCHAR(255) CHARSET utf8, IN `i_NgaySuaChua` DATE, IN `i_NoiDung` VARCHAR(255) CHARSET utf8, OUT `o_ouput` INT)  BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Check_SoLuongTienCong` (IN `i_soluong` INT, OUT `o_ketqua` INT, OUT `o_msg` VARCHAR(255))  BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Check_SoLuongVTPT` (IN `i_soluong` INT, OUT `o_ketqua` INT, OUT `o_msg` VARCHAR(255))  BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Check_SoLuongXeSuaTrongNgay` (IN `i_soluong` INT, OUT `o_ketqua` INT, OUT `o_msg` VARCHAR(255))  BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_ClickedForPrice` (IN `i_SoPSC` TINYINT(255))  BEGIN
	SELECT DonGia, GiaTien From ct_sudungvtpt
    INNER JOIN ct_phieusuachua
    ON ct_phieusuachua.MaCT_PSC = ct_sudungvtpt.MaCT_PSC
    INNER JOIN phieusuachua
    ON phieusuachua.SoPSC = ct_phieusuachua.SoPSC
    INNER JOIN tiencong
    ON tiencong.MaTC = ct_phieusuachua.MaTC
    WHERE phieusuachua.SoPSC = i_SoPSC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_CPT` (IN `i_VTPT` VARCHAR(255))  BEGIN
	SELECT DonGiaBan FROM vattuphutung 
    WHERE vattuphutung.TenVTPT = i_VTPT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_CTC` (IN `i_TC` VARCHAR(255))  BEGIN
	SELECT GiaTien FROM tiencong
    WHERE tiencong.TenTC = i_TC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_DelRepairList` (IN `i_SoPSC` INT, IN `i_SoLuong` INT(255))  NO SQL
BEGIN 
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_FindBCSale` (IN `i_MonthSale` INT, IN `i_YearSale` INT)  BEGIN
	DECLARE new_Count INT unsigned ;
	
	SELECT baocaodoanhso.MaBC, HieuXe, SoLuongSua, ThanhTien, FORMAT(TiLe,1) AS TiLe FROM ct_bcdoanhso
    INNER JOIN baocaodoanhso
    ON ct_bcdoanhso.MaBC = baocaodoanhso.MaBC
    WHERE Thang like i_MonthSale AND Nam like i_YearSale;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_FindBCTon` (IN `i_MonthReport` INT(255), IN `i_YearReport` INT(255))  BEGIN
	SELECT TenVTPT, TonDau, PhatSinh, TonCuoi
    FROM baocaoton INNER JOIN vattuphutung
    ON baocaoton.MaVTPT = vattuphutung.MaVTPT
    WHERE Thang like i_MonthReport AND Nam like i_YearReport;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_findRepair1` (IN `i_BienSoXe` VARCHAR(255))  BEGIN
SELECT BienSo, NgaySuaChua, NoiDungSC, TenVTPT, SoLuong, TenTC, SoLan, TongTien
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_findRepair2` (IN `i_BienSoXe` VARCHAR(255) CHARSET utf8, IN `i_NgaySuaChua` DATE)  BEGIN
	SELECT BienSo, NgaySuaChua, NoiDungSC, TenVTPT, SoLuong, TenTC, SoLan, TongTien
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_findRepair3` (IN `i_NgaySuaChua` DATE)  BEGIN 
	SELECT BienSo, NgaySuaChua, NoiDungSC, TenVTPT, SoLuong, TenTC, SoLan, TongTien
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_PhieuThuTien` (IN `i_name` VARCHAR(255), IN `i_phone` INT, IN `i_recpt_date` DATE, IN `i_license_plate` VARCHAR(255), IN `i_email` VARCHAR(255), IN `i_received_money` DOUBLE)  Begin
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_ShowBCSale` ()  BEGIN
	SELECT HieuXe, SoLuongSua, ThanhTien, FORMAT(TiLe,1) AS TiLe FROM ct_bcdoanhso;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_ShowBCTon` ()  BEGIN
	SELECT TenVTPT, TonDau, PhatSinh, TonCuoi FROM baocaoton
    INNER JOIN vattuphutung
    ON baocaoton.MaVTPT = vattuphutung.MaVTPT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_ShowRepair` ()  BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_ShowSaleText` (IN `i_MonthSale` INT(255), IN `i_YearSale` INT(255))  BEGIN 
	Select TongDoanhThu FROM baocaodoanhso
    WHERE Thang = i_MonthSale AND Nam = i_YearSale;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_show_Bill` ()  BEGIN
	SELECT SoPhieu, TenChuXe, xe.DienThoai AS Phon3, NgayThu, xe.BienSo, Email, SoTienThu
    FROM xe join phieuthutien
    on xe.BienSo = phieuthutien.BienSo
    order by SoPhieu;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Them_VTPT` (IN `i_NgayNhap` DATE, IN `i_TenVTPT` VARCHAR(255), IN `i_SoLuongNhap` INT(11), IN `i_DonGiaNhap` INT(11))  BEGIN
    DECLARE i_MaVTPT INT;
    DECLARE i_MaPN INT;
    DECLARE i_ThanhTien INT;
    
    -- Insert the record into the vattuphutung table
    INSERT INTO vattuphutung (TenVTPT, DonGiaNhap) VALUES (i_TenVTPT, i_DonGiaNhap);
    SET i_MaVTPT = LAST_INSERT_ID();
    
    -- Calculate the ThanhTien
    SET i_ThanhTien = i_SoLuongNhap * i_DonGiaNhap;
    
    -- Insert the record into the phieunhapvtpt table with calculated TongTien
    INSERT INTO phieunhapvtpt (NgayNhap, TongTien) VALUES (i_NgayNhap, i_ThanhTien);
    SET i_MaPN = LAST_INSERT_ID();
    
    -- Insert the record into the ct_phieunhap table
    INSERT INTO ct_phieunhap (MaVTPT, MaPN, SoLuongNhap, DonGiaNhap, ThanhTien)
    VALUES (i_MaVTPT, i_MaPN, i_SoLuongNhap, i_DonGiaNhap, i_ThanhTien);
    
    -- Update the TongTien in the phieunhapvtpt table
    UPDATE phieunhapvtpt 
SET TongTien = (SELECT SUM(ThanhTien) FROM ct_phieunhap) ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Them_Xe` (IN `i_BienSo` VARCHAR(255), IN `i_TenChuXe` VARCHAR(255), IN `i_HieuXe` VARCHAR(255), IN `i_DiaChi` VARCHAR(255), IN `i_DienThoai` INT(11), IN `i_NgayTiepNhan` DATE)  BEGIN
    DECLARE i_TongTien INT;
    DECLARE i_SoTienThu INT;
    DECLARE i_TienNo INT;

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
    INSERT INTO Xe (BienSo, TenChuXe, HieuXe, DiaChi, DienThoai, NgayTiepNhan)
    VALUES (i_BienSo, i_TenChuXe, i_HieuXe, i_DiaChi, i_DienThoai, i_NgayTiepNhan);

    -- Insert the record into the PhieuThuTien table
    INSERT INTO PhieuThuTien (BienSo, SoTienThu)
    VALUES (i_BienSo, i_SoTienThu);

    -- Insert the record into the PhieuSuaChua table
    INSERT INTO PhieuSuaChua (BienSo, TongTien)
    VALUES (i_BienSo, i_TongTien);

    -- Calculate the TienNo
    SET i_TienNo = i_TongTien - i_SoTienThu;

    -- Update the TienNo in the Xe table
    UPDATE Xe
    SET TienNo = i_TienNo
    WHERE BienSo = i_BienSo;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_TimKiem` (IN `i_BienSo` VARCHAR(255))  BEGIN
    -- Declare a variable to store the result
    DECLARE Result VARCHAR(255) DEFAULT '';

    -- Check if the record with the specified 'BienSo' exists
    IF EXISTS (SELECT 1 FROM view_xe WHERE BienSo = i_BienSo) THEN
        -- Set the result to indicate record found
        SET Result = 'Record found.';

        -- Select the record with the specified 'BienSo'
        SELECT *, Result AS Result FROM view_xe WHERE BienSo = i_BienSo;
    ELSE
        -- Set the result to indicate record not found
        SET Result = 'Record not found.';
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_UpdatePSC` (IN `i_SoPSC` TINYINT, IN `i_BienSoXe` VARCHAR(255), IN `i_NgaySuaChua` DATE, IN `i_VatTuPhuTung` VARCHAR(255), IN `i_SoLuong` INT(255), IN `i_GiaVT` FLOAT, IN `i_LoaiTienCong` VARCHAR(255), IN `i_SoLan` INT(255), IN `i_GiaTC` FLOAT, IN `i_NoiDungSC` VARCHAR(255))  NO SQL
BEGIN 
    DECLARE count_FSL INT unsigned DEFAULT 0;
    DECLARE new_MaSPSC INT unsigned DEFAULT 0;
    DECLARE new_MaTC INT unsigned DEFAULT 0;
    DECLARE new_GiaTC INT unsigned DEFAULT 0;
    DECLARE new_TongTC INT unsigned DEFAULT 0;
    DECLARE new_MaVTPT INT unsigned DEFAULT 0;
    DECLARE new_TongPT INT unsigned DEFAULT 0;
    
    SET new_MaTC = (SELECT MaTC FROM tiencong WHERE tiencong.TenTC = i_LoaiTienCong);
    SET new_GiaTC = (SELECT GiaTien FROM tiencong WHERE tiencong.TenTC = i_LoaiTienCong);
    SET new_TongTC = i_SoLan * i_GiaTC;
    SET new_TongPT = i_SoLuong * i_GiaVT;
    SET new_MaVTPT = (SELECT MaVTPT FROM vattuphutung WHERE TenVTPT = i_VatTuPhuTung);
    SET new_MaSPSC = (SELECT ct_phieusuachua.MaCT_PSC FROM ct_phieusuachua WHERE ct_phieusuachua.SoPSC = i_SoPSC);
    SET count_FSL = (SELECT SoLuong FROM ct_sudungvtpt WHERE ct_sudungvtpt.MaCT_PSC = new_MaSPSC
                    AND ct_sudungvtpt.MaVTPT = new_MaVTPT);  
    
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
  
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Xoa_VTPT` (IN `i_MAPN` INT(11), IN `i_MAVTPT` INT(11))  BEGIN
    -- Delete the record from the ct_phieunhap table based on MAPN and MAVTPT
    DELETE FROM ct_phieunhap WHERE MaPN = i_MAPN AND MaVTPT = i_MAVTPT;
UPDATE phieunhapvtpt
    SET TongTien = (SELECT SUM(ThanhTien) FROM ct_phieunhap);
    -- Check if there are any remaining records with the same MaPN in the ct_phieunhap table
    SET @count_ct_phieunhap = (SELECT COUNT(*) FROM ct_phieunhap WHERE MaPN = i_MAPN);

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `P_Xoa_Xe` (IN `i_BienSo` VARCHAR(255))  BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCarBrand` (IN `i_HieuXe` VARCHAR(255) CHARSET utf8, IN `i_GhiChu` VARCHAR(255) CHARSET utf8)  BEGIN
UPDATE hieuxe
SET GhiChu = i_GhiChu
WHERE HieuXe = i_HieuXe;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateWage` (IN `i_MaTC` INT(11), IN `i_TenTC` VARCHAR(255), IN `i_Gia` DOUBLE)  BEGIN
UPDATE tiencong
SET TenTC = i_TenTC, GiaTien = i_Gia
WHERE MaTC = i_MaTC;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `baocaodoanhso`
--

CREATE TABLE `baocaodoanhso` (
  `MaBC` int(11) NOT NULL,
  `Thang` int(11) NOT NULL,
  `Nam` int(11) NOT NULL,
  `TongDoanhThu` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `baocaoton`
--

CREATE TABLE `baocaoton` (
  `Thang` int(11) NOT NULL,
  `Nam` int(11) NOT NULL,
  `MaVTPT` int(11) NOT NULL,
  `TonDau` int(11) NOT NULL,
  `PhatSinh` int(11) NOT NULL,
  `TonCuoi` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `ct_bcdoanhso`
--

CREATE TABLE `ct_bcdoanhso` (
  `MaBC` int(11) NOT NULL,
  `HieuXe` varchar(255) NOT NULL,
  `SoLuongSua` int(11) NOT NULL,
  `ThanhTien` double NOT NULL,
  `TiLe` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `ct_phieunhap`
--

CREATE TABLE `ct_phieunhap` (
  `MaPN` int(11) NOT NULL,
  `MaVTPT` int(11) NOT NULL,
  `SoLuongNhap` int(11) NOT NULL,
  `DonGiaNhap` double NOT NULL,
  `ThanhTien` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `ct_phieunhap`
--

INSERT INTO `ct_phieunhap` (`MaPN`, `MaVTPT`, `SoLuongNhap`, `DonGiaNhap`, `ThanhTien`) VALUES
(2, 19, 1, 321321, 321321),
(3, 20, 1, 2222, 2222),
(4, 21, 1, 2222, 2222),
(5, 22, 1, 2222, 2222);

-- --------------------------------------------------------

--
-- Table structure for table `ct_phieusuachua`
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `ct_sudungvtpt`
--

CREATE TABLE `ct_sudungvtpt` (
  `MaCT_PSC` int(11) NOT NULL,
  `MaVTPT` int(11) NOT NULL,
  `SoLuong` int(11) NOT NULL,
  `DonGia` double NOT NULL,
  `ThanhTien` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `dangnhap`
--

CREATE TABLE `dangnhap` (
  `UserID` int(11) NOT NULL,
  `Username` varchar(20) NOT NULL,
  `Password` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `dangnhap`
--

INSERT INTO `dangnhap` (`UserID`, `Username`, `Password`) VALUES
(1, 'manhhc', '1'),
(2, 'hangntt', '1'),
(3, 'khoiptx', '1'),
(4, 'huongbt', '1'),
(5, 'hans', '1');

-- --------------------------------------------------------

--
-- Table structure for table `hieuxe`
--

CREATE TABLE `hieuxe` (
  `HieuXe` varchar(255) NOT NULL,
  `GhiChu` varchar(255) NOT NULL,
  `ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `hieuxe`
--

INSERT INTO `hieuxe` (`HieuXe`, `GhiChu`, `ID`) VALUES
('Honda2010', '', 1),
('Honda2017', '', 2),
('Honda2018', '', 3),
('Wave4550', '', 4),
('Wave4551', '', 5),
('Wave4554', '', 6),
('Wave4556', '', 7),
('Wave4557', '', 8),
('Wave4558', '', 9),
('Wave4559', '', 10);

-- --------------------------------------------------------

--
-- Table structure for table `phieunhapvtpt`
--

CREATE TABLE `phieunhapvtpt` (
  `MaPN` int(11) NOT NULL,
  `NgayNhap` date NOT NULL,
  `TongTien` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `phieunhapvtpt`
--

INSERT INTO `phieunhapvtpt` (`MaPN`, `NgayNhap`, `TongTien`) VALUES
(1, '2023-06-08', 327987),
(2, '2023-06-20', 327987),
(3, '2023-06-21', 327987),
(4, '2023-06-21', 327987),
(5, '2023-06-22', 327987);

-- --------------------------------------------------------

--
-- Table structure for table `phieusuachua`
--

CREATE TABLE `phieusuachua` (
  `SoPSC` int(11) NOT NULL,
  `BienSo` varchar(255) NOT NULL,
  `NgaySuaChua` date NOT NULL,
  `TongTien` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `phieusuachua`
--

INSERT INTO `phieusuachua` (`SoPSC`, `BienSo`, `NgaySuaChua`, `TongTien`) VALUES
(31, '5345345', '0000-00-00', 0),
(32, '213213', '0000-00-00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `phieuthutien`
--

CREATE TABLE `phieuthutien` (
  `SoPhieu` int(11) NOT NULL,
  `BienSo` varchar(255) NOT NULL,
  `NgayThu` date NOT NULL,
  `SoTienThu` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `phieuthutien`
--

INSERT INTO `phieuthutien` (`SoPhieu`, `BienSo`, `NgayThu`, `SoTienThu`) VALUES
(1, '51F-11111', '2023-06-02', 1200000),
(2, '51F-11111', '2023-06-01', 20000),
(4, '59H-123455', '0000-00-00', 0),
(28, '565656', '0000-00-00', 0),
(29, '432432', '0000-00-00', 0),
(30, '56565654543', '0000-00-00', 0),
(31, '324324', '0000-00-00', 0),
(32, '5345345', '0000-00-00', 0),
(33, '213213', '0000-00-00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `thamso`
--

CREATE TABLE `thamso` (
  `TenThamSo` varchar(255) NOT NULL,
  `GiaTri` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `thamso`
--

INSERT INTO `thamso` (`TenThamSo`, `GiaTri`) VALUES
('SoLuongTienCong', 1),
('SoLuongVTPT', 5),
('SoXeSuaChuaTrongNgay', 4),
('TenHieuXe', 10);

-- --------------------------------------------------------

--
-- Table structure for table `tiencong`
--

CREATE TABLE `tiencong` (
  `MaTC` int(11) NOT NULL,
  `TenTC` varchar(255) NOT NULL,
  `GiaTien` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tiencong`
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
-- Table structure for table `vattuphutung`
--

CREATE TABLE `vattuphutung` (
  `MaVTPT` int(11) NOT NULL,
  `TenVTPT` varchar(255) NOT NULL,
  `DonGiaNhap` double NOT NULL,
  `DonGiaBan` double NOT NULL,
  `SoLuongTon` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `vattuphutung`
--

INSERT INTO `vattuphutung` (`MaVTPT`, `TenVTPT`, `DonGiaNhap`, `DonGiaBan`, `SoLuongTon`) VALUES
(1, 'Vỏ xe', 50000, 70000, 100),
(2, 'Lốp xe', 45000, 70000, 45),
(3, 'gương', 200000, 250000, 53),
(4, 'má phanh', 300000, 350000, 25),
(5, 'đèn pha', 400000, 450000, 69),
(7, 'bình nước', 600000, 650000, 64),
(8, 'thắng sau', 700000, 750000, 48),
(9, 'bơm dầu', 800000, 850000, 28),
(10, 'cáp điều khiển', 900000, 950000, 60),
(11, 'van xả', 1000000, 1050000, 49),
(12, 'Bình acquy', 100000, 1000000, 10),
(13, 'Bộ bánh xe', 100000, 1000000, 10),
(14, 'Dây curoa động cơ', 100000, 1000005, 10),
(15, 'Bộ thắng đĩa', 100000, 1000004, 10),
(16, 'Lọc gió', 100000, 1000002, 10),
(17, 'Bộ hộp số', 100000, 100021, 10),
(18, 'Lọc nhiên liệu', 100000, 1000005, 10),
(19, 'test', 321321, 0, 0),
(20, 'tst', 2222, 0, 0),
(21, 'tst1', 2222, 0, 0),
(22, 'tst1', 2222, 0, 0);

-- --------------------------------------------------------

--
-- Stand-in structure for view `view_phieunhap`
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
-- Stand-in structure for view `view_xe`
-- (See below for the actual view)
--
CREATE TABLE `view_xe` (
`BienSo` varchar(255)
,`TongTien` double
,`SoTienThu` double
,`TenChuXe` varchar(255)
,`HieuXe` varchar(255)
,`DiaChi` varchar(255)
,`DienThoai` int(11)
,`NgayTiepNhan` date
,`TienNo` double
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_doanhthu`
-- (See below for the actual view)
--
CREATE TABLE `v_doanhthu` (
`total_product2` double
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_hieuxe`
-- (See below for the actual view)
--
CREATE TABLE `v_hieuxe` (
`HieuXe` varchar(255)
,`GhiChu` varchar(255)
,`ID` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_sanpham`
-- (See below for the actual view)
--
CREATE TABLE `v_sanpham` (
`total_product` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_slsua`
-- (See below for the actual view)
--
CREATE TABLE `v_slsua` (
`total_product1` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_soluongtiencong`
-- (See below for the actual view)
--
CREATE TABLE `v_soluongtiencong` (
`TenThamSo` varchar(255)
,`GiaTri` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_soluongvtpt`
-- (See below for the actual view)
--
CREATE TABLE `v_soluongvtpt` (
`TenThamSo` varchar(255)
,`GiaTri` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_soluongxesuachua`
-- (See below for the actual view)
--
CREATE TABLE `v_soluongxesuachua` (
`TenThamSo` varchar(255)
,`GiaTri` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `xe`
--

CREATE TABLE `xe` (
  `BienSo` varchar(255) NOT NULL,
  `TenChuXe` varchar(255) NOT NULL,
  `HieuXe` varchar(255) NOT NULL,
  `DiaChi` varchar(255) NOT NULL,
  `DienThoai` int(11) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `NgayTiepNhan` date NOT NULL,
  `TienNo` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `xe`
--

INSERT INTO `xe` (`BienSo`, `TenChuXe`, `HieuXe`, `DiaChi`, `DienThoai`, `Email`, `NgayTiepNhan`, `TienNo`) VALUES
('19C7-69716', 'Nguyễn Thị Thúy Vy', 'Honda2017', '183/5A Bui Vien, Bình Định', 812345677, 'emailsample999@example.com', '2023-06-09', 0),
('213213', 'tesst12', 'Honda2018', 'bdfbgfh', 54543543, '', '2023-06-22', 0),
('22D9-77951', 'Nguyễn Bảo Thi', 'Honda2010', '181 Huynh Van Banh, Lâm Đồng', 845612378, 'emailtest555@example.com', '2023-05-31', 3250000),
('324324', '4234324', 'Honda2010', '432432', 55653, '', '2023-06-20', 0),
('38N1-00234', 'Tôn Hạo Nhiên', 'Wave4554', '214 Nguyen An Ninh Street', 962375286, 'sampleemail5678@example.com', '2023-06-02', 19750000),
('432432', '423423', 'Honda2010', '432423', 4324324, '', '2023-06-20', 0),
('45K7-23456', 'Nguyễn Hữu Huyến', 'Wave4557', '13 Hang Khoai, Hồ Chí Minh', 987746337, 'testemail987@example.com', '2023-04-30', 11160000),
('49A1-64481', 'Nguyễn Thị Thúy Hằng', 'Wave4559', '648/43, Cach Mang Thang Tam, ĐakLak', 912345678, 'random123email@example.com', '2023-05-07', 47250000),
('51F-11111', 'Phan Khánh An', 'Honda2010', 'eTown 1 Building, 6th Floor 364 Cong Hoa Street.\r\n', 238125167, 'Abfdjfdfj@gmail.com', '2023-06-01', 0),
('51F-123434', 'Phan Thị Anh', 'Honda2010', '58 Hung Vuong, Hồ Chí Minh', 369306829, 'randomuser1@example.com', '2023-04-27', 3180000),
('5345345', 'test', 'Honda2010', 'fdsfsdf', 534534, '', '2023-06-21', 0),
('565656', 'w3434324', 'Honda2010', '4324324', 656575, '', '2023-06-20', 0),
('56565654543', 'w3434324', 'Honda2010', '4324324', 656575, '', '2023-06-20', 0),
('57N2-33445', 'Nguyễn Phúc Tinh', 'Wave4556', '93 Tran Quang Dieu, ĐakLak', 847463645, 'randomemail2023@example.com', '2023-05-23', 49760000),
('59A-123456', 'Lưu Quốc Việt', 'Honda2017', '30 Ngo 183 Hoang Van Thai, Khuong Mai Ward', 356597162, 'email12345@example.com', '2023-05-14', 58950000),
('59F4-10934', 'Bùi Thị Hương', 'Honda2017', '140/55 Su Van Hanh, Quảng Bình', 986313973, 'emailuser2468@example.com', '2023-04-18', 33000000),
('59H-123455', 'Hằng', 'Honda2018', 'test', 123459, '', '1970-01-01', 0),
('66F3-24562', 'Vũ Minh Tuấn', 'Wave4559', '58 Hung Vuong, Biên Hòa', 345678945, 'useremail777@example.com', '2023-04-25', 15085000),
('67K5-73456', 'Nguyễn Huỳnh Tuấn Anh', 'Wave4558', '242A Tan Son Nhi, Hồ Chí Minh', 123456789, 'exampleemail111@example.com', '2023-06-05', 7250000);

-- --------------------------------------------------------

--
-- Structure for view `view_phieunhap`
--
DROP TABLE IF EXISTS `view_phieunhap`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_phieunhap`  AS SELECT `ct`.`MaPN` AS `MaPN`, `ct`.`MaVTPT` AS `MaVTPT`, `ct`.`SoLuongNhap` AS `SoLuongNhap`, `ct`.`DonGiaNhap` AS `DonGiaNhap`, `ct`.`ThanhTien` AS `ThanhTien`, `vt`.`TenVTPT` AS `TenVTPT`, `pn`.`NgayNhap` AS `NgayNhap`, `pn`.`TongTien` AS `TongTien` FROM ((`ct_phieunhap` `ct` join `vattuphutung` `vt` on(`ct`.`MaVTPT` = `vt`.`MaVTPT`)) join `phieunhapvtpt` `pn` on(`ct`.`MaPN` = `pn`.`MaPN`)) ;

-- --------------------------------------------------------

--
-- Structure for view `view_xe`
--
DROP TABLE IF EXISTS `view_xe`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_xe`  AS SELECT `ps`.`BienSo` AS `BienSo`, `ps`.`TongTien` AS `TongTien`, `pt`.`SoTienThu` AS `SoTienThu`, `x`.`TenChuXe` AS `TenChuXe`, `x`.`HieuXe` AS `HieuXe`, `x`.`DiaChi` AS `DiaChi`, `x`.`DienThoai` AS `DienThoai`, `x`.`NgayTiepNhan` AS `NgayTiepNhan`, `x`.`TienNo` AS `TienNo` FROM ((`phieusuachua` `ps` join `xe` `x` on(`ps`.`BienSo` = `x`.`BienSo`)) left join `phieuthutien` `pt` on(`x`.`BienSo` = `pt`.`BienSo`)) ;

-- --------------------------------------------------------

--
-- Structure for view `v_doanhthu`
--
DROP TABLE IF EXISTS `v_doanhthu`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_doanhthu`  AS SELECT sum(`ct_bcdoanhso`.`ThanhTien`) AS `total_product2` FROM `ct_bcdoanhso` ;

-- --------------------------------------------------------

--
-- Structure for view `v_hieuxe`
--
DROP TABLE IF EXISTS `v_hieuxe`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_hieuxe`  AS SELECT `hieuxe`.`HieuXe` AS `HieuXe`, `hieuxe`.`GhiChu` AS `GhiChu`, `hieuxe`.`ID` AS `ID` FROM `hieuxe` ;

-- --------------------------------------------------------

--
-- Structure for view `v_sanpham`
--
DROP TABLE IF EXISTS `v_sanpham`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_sanpham`  AS SELECT sum(`vattuphutung`.`SoLuongTon`) AS `total_product` FROM `vattuphutung` ;

-- --------------------------------------------------------

--
-- Structure for view `v_slsua`
--
DROP TABLE IF EXISTS `v_slsua`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_slsua`  AS SELECT sum(`ct_bcdoanhso`.`SoLuongSua`) AS `total_product1` FROM `ct_bcdoanhso` ;

-- --------------------------------------------------------

--
-- Structure for view `v_soluongtiencong`
--
DROP TABLE IF EXISTS `v_soluongtiencong`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_soluongtiencong`  AS SELECT `ts`.`TenThamSo` AS `TenThamSo`, `ts`.`GiaTri` AS `GiaTri` FROM `thamso` AS `ts` WHERE `ts`.`TenThamSo` like 'SoLuongTienCong' ;

-- --------------------------------------------------------

--
-- Structure for view `v_soluongvtpt`
--
DROP TABLE IF EXISTS `v_soluongvtpt`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_soluongvtpt`  AS SELECT `ts`.`TenThamSo` AS `TenThamSo`, `ts`.`GiaTri` AS `GiaTri` FROM `thamso` AS `ts` WHERE `ts`.`TenThamSo` like 'SoLuongVTPT' ;

-- --------------------------------------------------------

--
-- Structure for view `v_soluongxesuachua`
--
DROP TABLE IF EXISTS `v_soluongxesuachua`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_soluongxesuachua`  AS SELECT `ts`.`TenThamSo` AS `TenThamSo`, `ts`.`GiaTri` AS `GiaTri` FROM `thamso` AS `ts` WHERE `ts`.`TenThamSo` like 'SoXeSuaChuaTrongNgay' ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `baocaodoanhso`
--
ALTER TABLE `baocaodoanhso`
  ADD PRIMARY KEY (`MaBC`);

--
-- Indexes for table `baocaoton`
--
ALTER TABLE `baocaoton`
  ADD PRIMARY KEY (`Thang`,`Nam`,`MaVTPT`),
  ADD KEY `FK_BCTON_VTPT` (`MaVTPT`);

--
-- Indexes for table `ct_bcdoanhso`
--
ALTER TABLE `ct_bcdoanhso`
  ADD PRIMARY KEY (`MaBC`,`HieuXe`),
  ADD KEY `FK_CTBCDS_HX` (`HieuXe`);

--
-- Indexes for table `ct_phieunhap`
--
ALTER TABLE `ct_phieunhap`
  ADD PRIMARY KEY (`MaPN`,`MaVTPT`),
  ADD KEY `FK_CTPN_VTPT` (`MaVTPT`);

--
-- Indexes for table `ct_phieusuachua`
--
ALTER TABLE `ct_phieusuachua`
  ADD PRIMARY KEY (`MaCT_PSC`),
  ADD KEY `FK_CTPSC_PSC` (`SoPSC`);

--
-- Indexes for table `ct_sudungvtpt`
--
ALTER TABLE `ct_sudungvtpt`
  ADD PRIMARY KEY (`MaCT_PSC`,`MaVTPT`) USING BTREE,
  ADD KEY `FK_CTSDVTPT_VTPT` (`MaVTPT`);

--
-- Indexes for table `dangnhap`
--
ALTER TABLE `dangnhap`
  ADD PRIMARY KEY (`UserID`);

--
-- Indexes for table `hieuxe`
--
ALTER TABLE `hieuxe`
  ADD PRIMARY KEY (`HieuXe`);

--
-- Indexes for table `phieunhapvtpt`
--
ALTER TABLE `phieunhapvtpt`
  ADD PRIMARY KEY (`MaPN`);

--
-- Indexes for table `phieusuachua`
--
ALTER TABLE `phieusuachua`
  ADD PRIMARY KEY (`SoPSC`),
  ADD KEY `FK_PHIEUSUACHUA_XE` (`BienSo`);

--
-- Indexes for table `phieuthutien`
--
ALTER TABLE `phieuthutien`
  ADD PRIMARY KEY (`SoPhieu`),
  ADD KEY `FK_PHIEUTHUTIEN` (`BienSo`);

--
-- Indexes for table `thamso`
--
ALTER TABLE `thamso`
  ADD PRIMARY KEY (`TenThamSo`);

--
-- Indexes for table `tiencong`
--
ALTER TABLE `tiencong`
  ADD PRIMARY KEY (`MaTC`);

--
-- Indexes for table `vattuphutung`
--
ALTER TABLE `vattuphutung`
  ADD PRIMARY KEY (`MaVTPT`);

--
-- Indexes for table `xe`
--
ALTER TABLE `xe`
  ADD PRIMARY KEY (`BienSo`),
  ADD KEY `FK_XE_HIEUXE` (`HieuXe`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `baocaodoanhso`
--
ALTER TABLE `baocaodoanhso`
  MODIFY `MaBC` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `ct_phieusuachua`
--
ALTER TABLE `ct_phieusuachua`
  MODIFY `MaCT_PSC` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ct_sudungvtpt`
--
ALTER TABLE `ct_sudungvtpt`
  MODIFY `MaCT_PSC` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dangnhap`
--
ALTER TABLE `dangnhap`
  MODIFY `UserID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `phieunhapvtpt`
--
ALTER TABLE `phieunhapvtpt`
  MODIFY `MaPN` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `phieusuachua`
--
ALTER TABLE `phieusuachua`
  MODIFY `SoPSC` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `phieuthutien`
--
ALTER TABLE `phieuthutien`
  MODIFY `SoPhieu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `tiencong`
--
ALTER TABLE `tiencong`
  MODIFY `MaTC` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `vattuphutung`
--
ALTER TABLE `vattuphutung`
  MODIFY `MaVTPT` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `baocaoton`
--
ALTER TABLE `baocaoton`
  ADD CONSTRAINT `FK_BCTON_VTPT` FOREIGN KEY (`MaVTPT`) REFERENCES `vattuphutung` (`MaVTPT`);

--
-- Constraints for table `ct_bcdoanhso`
--
ALTER TABLE `ct_bcdoanhso`
  ADD CONSTRAINT `FK_CTBCDS_BCDS` FOREIGN KEY (`MaBC`) REFERENCES `baocaodoanhso` (`MaBC`),
  ADD CONSTRAINT `FK_CTBCDS_HX` FOREIGN KEY (`HieuXe`) REFERENCES `hieuxe` (`HieuXe`);

--
-- Constraints for table `ct_phieunhap`
--
ALTER TABLE `ct_phieunhap`
  ADD CONSTRAINT `FK_CTPN_PNVTPT` FOREIGN KEY (`MaPN`) REFERENCES `phieunhapvtpt` (`MaPN`),
  ADD CONSTRAINT `FK_CTPN_VTPT` FOREIGN KEY (`MaVTPT`) REFERENCES `vattuphutung` (`MaVTPT`);

--
-- Constraints for table `ct_phieusuachua`
--
ALTER TABLE `ct_phieusuachua`
  ADD CONSTRAINT `FK_CTPSC_PSC` FOREIGN KEY (`SoPSC`) REFERENCES `phieusuachua` (`SoPSC`);

--
-- Constraints for table `ct_sudungvtpt`
--
ALTER TABLE `ct_sudungvtpt`
  ADD CONSTRAINT `FK_CTSDVTPT_CTPSC` FOREIGN KEY (`MaCT_PSC`) REFERENCES `ct_phieusuachua` (`MaCT_PSC`),
  ADD CONSTRAINT `FK_CTSDVTPT_VTPT` FOREIGN KEY (`MaVTPT`) REFERENCES `vattuphutung` (`MaVTPT`);

--
-- Constraints for table `phieusuachua`
--
ALTER TABLE `phieusuachua`
  ADD CONSTRAINT `FK_PHIEUSUACHUA_XE` FOREIGN KEY (`BienSo`) REFERENCES `xe` (`BienSo`);

--
-- Constraints for table `phieuthutien`
--
ALTER TABLE `phieuthutien`
  ADD CONSTRAINT `FK_PHIEUTHUTIEN` FOREIGN KEY (`BienSo`) REFERENCES `xe` (`BienSo`);

--
-- Constraints for table `xe`
--
ALTER TABLE `xe`
  ADD CONSTRAINT `FK_XE_HIEUXE` FOREIGN KEY (`HieuXe`) REFERENCES `hieuxe` (`HieuXe`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
