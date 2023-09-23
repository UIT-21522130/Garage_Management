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
public class PhuTung implements Serializable{
    private String MASP, TENSP;
    private int SL;
    private float DonGia;
    private Date NgayNhap;
    
    public String getMASP()
    {
        return MASP;
    }
    public void  setMASP( String MASP)
    {
        this.MASP=MASP;
    }
    
    public String getTENSP()
    {
        return MASP;
    }
    public void  setTENSP( String TENSP)
    {
        this.TENSP=TENSP;
    }
    
    public int getSL()
    {
        return SL;
    }
    public void  setSL( int SL)
    {
        this.SL=SL;
    }
    
    public float getDonGia()
    {
        return DonGia;
    }
    public void  setDonGia (float DonGia)
    {
        this.DonGia=DonGia;
    }
     
    
    public Date getNgayNhap()
    {
        return NgayNhap;
    }
    public void  setNgayNhap (Date NgayNhap)
    {
        this.NgayNhap=NgayNhap;
    }
    // constructor
    public PhuTung()
    {
    
    }
     public PhuTung(String MASP, String TENSP, int SL, float DonGia, Date NgayNhap){
         this.MASP =MASP;
         this.TENSP= TENSP;
         this.SL=SL;
         this.DonGia=DonGia;
         this.NgayNhap= NgayNhap;
     }
     
        
}
