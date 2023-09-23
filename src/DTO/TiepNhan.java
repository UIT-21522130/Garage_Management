/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DTO;

import java.io.Serializable;
import java.util.Date;

/**
 *
 * @author ADMIN
 */
public class TiepNhan implements Serializable
{
    private String TenChuXe, BienSo, HieuXe, DiaChi;
    private float SDT;
    private Date NgayTiepNhan ;//dd/mm/yyy;
    private int stt;
    private static int Dem = 0;
    public TiepNhan() {
        this.stt = Dem++;
    }

    public TiepNhan(String TenChuXe, String BienSo, String HieuXe, String DiaChi, float SDT, Date NgayTiepNhan) {
        this.stt = Dem++;
        this.TenChuXe = TenChuXe;
        this.BienSo = BienSo;
        this.TenChuXe = HieuXe;
        this.BienSo = DiaChi;
        this.SDT = SDT;
        this.NgayTiepNhan = NgayTiepNhan;
        
    }
    public String getTenChuXe()
    {
        return TenChuXe;
    }
    
    public void setTenChuXe(String TenChuXe)
    {
        this.TenChuXe=TenChuXe;
    }
    
    public String getBienSo()
    {
        return BienSo;
    }
    
    public void setBienSo(String BienSo)
    {
        this.BienSo=BienSo;
    }
    
    public String getHieuXe()
    {
        return HieuXe;
    }
    
    public void setHieuXe(String HieuXe)
    {
        this.HieuXe=HieuXe;
    }
    
    public String getDiaChi()
    {
        return DiaChi;
    }
    
    public void setDiaChi(String DiaChi)
    {
        this.DiaChi=DiaChi;
    }
    
    public float getSDT()
    {
        return SDT;
    }
    
    public void setSDT(float SDT)
    {
        this.SDT=SDT;
    }
   
    public Date getNgayTiepNhan()
    {
        return NgayTiepNhan;
    }
    

    public void setNgayTiepNhan (Date NgayTiepNhan) {
        this.NgayTiepNhan = NgayTiepNhan;
    }
    
    public static int getstt() {
        return Dem;
    }

    public static void setstt(int sId) {
        TiepNhan.Dem = Dem;
    }

}