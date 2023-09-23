/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.raven.form;

import DAL.DBConnection;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

/**
 *
 * @author RAVEN
 */
public class Form_10 extends javax.swing.JPanel {

    /**
     * Creates new form Form_1
     */
    DBConnection a=new DBConnection();
    Connection conn= a.ConnectDb();
    public int ketqua = 0;
    public String msg = "";
    String hieuxe = "";
    String ghichu = "";
    int id =0;
    int soluongxesua = 0;
    public Form_10() {
        initComponents();
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jLayeredPane1 = new javax.swing.JLayeredPane();
        jPanel1 = new javax.swing.JPanel();
        jTabbedPane1 = new javax.swing.JTabbedPane();
        jPanel3 = new javax.swing.JPanel();
        jScrollPane2 = new javax.swing.JScrollPane();
        hieu_xe = new javax.swing.JTable();
        TimHieuXe = new javax.swing.JButton();
        txt_HieuXe = new javax.swing.JTextField();
        jLabel7 = new javax.swing.JLabel();
        SuaHieuXe = new javax.swing.JButton();
        txt_GhiChu = new javax.swing.JTextField();
        jLabel8 = new javax.swing.JLabel();
        jPanel2 = new javax.swing.JPanel();
        jScrollPane3 = new javax.swing.JScrollPane();
        SoluongXe = new javax.swing.JTable();
        txt_SLXeSuaTrongNgay = new javax.swing.JTextField();
        SuaTC = new javax.swing.JButton();
        jLabel3 = new javax.swing.JLabel();
        panel2 = new java.awt.Panel();
        jLabel6 = new javax.swing.JLabel();

        javax.swing.GroupLayout jLayeredPane1Layout = new javax.swing.GroupLayout(jLayeredPane1);
        jLayeredPane1.setLayout(jLayeredPane1Layout);
        jLayeredPane1Layout.setHorizontalGroup(
            jLayeredPane1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 100, Short.MAX_VALUE)
        );
        jLayeredPane1Layout.setVerticalGroup(
            jLayeredPane1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 100, Short.MAX_VALUE)
        );

        setBackground(new java.awt.Color(242, 242, 242));

        jPanel1.setBackground(new java.awt.Color(255, 255, 255));

        jTabbedPane1.setBackground(new java.awt.Color(176, 196, 222));
        jTabbedPane1.setForeground(new java.awt.Color(255, 255, 255));
        jTabbedPane1.setTabLayoutPolicy(javax.swing.JTabbedPane.SCROLL_TAB_LAYOUT);
        jTabbedPane1.setFont(new java.awt.Font("Segoe UI Semibold", 0, 12)); // NOI18N
        jTabbedPane1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jTabbedPane1MouseClicked(evt);
            }
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTabbedPane1MousePressed(evt);
            }
        });

        hieu_xe.setFont(new java.awt.Font("sansserif", 1, 18)); // NOI18N
        hieu_xe.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "Tên Hiệu Xe", "Ghi chú", "ID"
            }
        ));
        hieu_xe.setRowHeight(30);
        hieu_xe.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                hieu_xeMouseClicked(evt);
            }
        });
        jScrollPane2.setViewportView(hieu_xe);

        TimHieuXe.setBackground(new java.awt.Color(255, 255, 255));
        TimHieuXe.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        TimHieuXe.setText("Tìm");
        TimHieuXe.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                TimHieuXeActionPerformed(evt);
            }
        });

        txt_HieuXe.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        txt_HieuXe.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                txt_HieuXeActionPerformed(evt);
            }
        });

        jLabel7.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jLabel7.setText("Nhập hiệu xe");

        SuaHieuXe.setBackground(new java.awt.Color(255, 255, 255));
        SuaHieuXe.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        SuaHieuXe.setText("Sửa");
        SuaHieuXe.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                SuaHieuXeActionPerformed(evt);
            }
        });

        txt_GhiChu.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        txt_GhiChu.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                txt_GhiChuActionPerformed(evt);
            }
        });

        jLabel8.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jLabel8.setText("Nhập ghi chú");

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane2)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(txt_HieuXe, javax.swing.GroupLayout.PREFERRED_SIZE, 280, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel7, javax.swing.GroupLayout.PREFERRED_SIZE, 220, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(18, 18, 18)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel8, javax.swing.GroupLayout.PREFERRED_SIZE, 220, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(txt_GhiChu, javax.swing.GroupLayout.PREFERRED_SIZE, 280, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(0, 208, Short.MAX_VALUE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(TimHieuXe, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(SuaHieuXe, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(36, 36, 36))
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel7)
                    .addComponent(jLabel8))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(txt_HieuXe, javax.swing.GroupLayout.PREFERRED_SIZE, 35, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(txt_GhiChu, javax.swing.GroupLayout.PREFERRED_SIZE, 35, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addComponent(TimHieuXe, javax.swing.GroupLayout.PREFERRED_SIZE, 75, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(18, 18, 18)
                        .addComponent(SuaHieuXe, javax.swing.GroupLayout.PREFERRED_SIZE, 75, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 396, Short.MAX_VALUE))
                .addGap(12, 12, 12))
        );

        jTabbedPane1.addTab("Hiệu xe", jPanel3);

        jPanel2.setPreferredSize(new java.awt.Dimension(990, 500));

        SoluongXe.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "Số Lượng Xe Cho Phép Sửa Chữa"
            }
        ));
        SoluongXe.setRowHeight(30);
        SoluongXe.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                SoluongXeMouseClicked(evt);
            }
        });
        jScrollPane3.setViewportView(SoluongXe);

        txt_SLXeSuaTrongNgay.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        txt_SLXeSuaTrongNgay.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                txt_SLXeSuaTrongNgayActionPerformed(evt);
            }
        });

        SuaTC.setBackground(new java.awt.Color(255, 255, 255));
        SuaTC.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        SuaTC.setText("Sửa");
        SuaTC.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                SuaTCActionPerformed(evt);
            }
        });

        jLabel3.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jLabel3.setText("Nhập số lượng xe cho phép sửa trong ngày");

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(txt_SLXeSuaTrongNgay, javax.swing.GroupLayout.PREFERRED_SIZE, 280, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(jLabel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addGap(681, 681, 681))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(jScrollPane3)
                        .addGap(18, 18, 18)
                        .addComponent(SuaTC, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(32, 32, 32))))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(txt_SLXeSuaTrongNgay)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 406, Short.MAX_VALUE)
                        .addGap(6, 6, 6))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(SuaTC, javax.swing.GroupLayout.PREFERRED_SIZE, 75, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))))
        );

        jTabbedPane1.addTab("Số lượng Xe Sửa Trong Ngày", jPanel2);

        panel2.setBackground(new java.awt.Color(176, 196, 222));

        jLabel6.setFont(new java.awt.Font("Segoe UI", 1, 24)); // NOI18N
        jLabel6.setForeground(new java.awt.Color(255, 255, 255));
        jLabel6.setText("Thay đổi quy định");

        javax.swing.GroupLayout panel2Layout = new javax.swing.GroupLayout(panel2);
        panel2.setLayout(panel2Layout);
        panel2Layout.setHorizontalGroup(
            panel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(panel2Layout.createSequentialGroup()
                .addComponent(jLabel6, javax.swing.GroupLayout.PREFERRED_SIZE, 242, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
        );
        panel2Layout.setVerticalGroup(
            panel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jLabel6, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane1)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(panel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                .addComponent(panel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTabbedPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 510, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 990, Short.MAX_VALUE)
            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(layout.createSequentialGroup()
                    .addGap(0, 0, Short.MAX_VALUE)
                    .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, Short.MAX_VALUE)))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 552, Short.MAX_VALUE)
            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(layout.createSequentialGroup()
                    .addGap(0, 0, Short.MAX_VALUE)
                    .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGap(0, 0, Short.MAX_VALUE)))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void SuaTCActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_SuaTCActionPerformed
        check_soluongxesuatrongngay();
    }//GEN-LAST:event_SuaTCActionPerformed

    private void txt_SLXeSuaTrongNgayActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_txt_SLXeSuaTrongNgayActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_txt_SLXeSuaTrongNgayActionPerformed

    private void SuaHieuXeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_SuaHieuXeActionPerformed
        // TODO add your handling code here:
        change_brandcar ();
    }//GEN-LAST:event_SuaHieuXeActionPerformed

    private void txt_HieuXeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_txt_HieuXeActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_txt_HieuXeActionPerformed

    private void TimHieuXeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_TimHieuXeActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_TimHieuXeActionPerformed

    private void jTabbedPane1MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTabbedPane1MouseClicked
        // TODO add your handling code here:

    }//GEN-LAST:event_jTabbedPane1MouseClicked

    private void jTabbedPane1MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTabbedPane1MousePressed
        // TODO add your handling code here:
        loadSLXeSuaChua();
    }//GEN-LAST:event_jTabbedPane1MousePressed

    private void txt_GhiChuActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_txt_GhiChuActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_txt_GhiChuActionPerformed

    private void hieu_xeMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_hieu_xeMouseClicked
        // TODO add your handling code here:
        hieuxe = (String) hieu_xe.getValueAt(hieu_xe.getSelectedRow(), 0);
        ghichu = (String) hieu_xe.getValueAt(hieu_xe.getSelectedRow(), 1);
        if(id != 0 ){
            id = (int) hieu_xe.getValueAt(hieu_xe.getSelectedRow(), 2);
        }
        txt_HieuXe.setText(hieuxe);
        txt_GhiChu.setText(ghichu);
    }//GEN-LAST:event_hieu_xeMouseClicked

    private void SoluongXeMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_SoluongXeMouseClicked
        // TODO add your handling code here:
//        soluongxesua = (int) SoluongXe.getValueAt(SoluongXe.getSelectedRow(), 0);
//        System.out.println("soluong" + soluongxesua);
    }//GEN-LAST:event_SoluongXeMouseClicked

    public void check_soluongxesuatrongngay () {
        DefaultTableModel tbl_mod = (DefaultTableModel) SoluongXe.getModel();
        tbl_mod.setRowCount(0);
        int row_count = 0;
        try {
            Statement st = conn.createStatement();
            CallableStatement cs = conn.prepareCall("{call P_Check_SoLuongXeSuaTrongNgay(?, ?, ?)}");
            cs.setInt(1, Integer.valueOf(txt_SLXeSuaTrongNgay.getText()));
            ResultSet rs = cs.executeQuery();
            ketqua = cs.getInt(2);
            msg = cs.getString(3);
            if(ketqua == 0){
               JOptionPane.showMessageDialog(this, msg);
               txt_SLXeSuaTrongNgay.setText("");
               loadSLXeSuaChua();
               return;
            }else{
                JOptionPane.showMessageDialog(this, msg);
                loadSLXeSuaChua();
            }
        } catch (SQLException ex) {
            Logger.getLogger(Form_1.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public void change_brandcar () {
        DefaultTableModel tbl_mod = (DefaultTableModel) hieu_xe.getModel();
        tbl_mod.setRowCount(0);
        int row_count = 0;
        try {
            Statement st = conn.createStatement();
            CallableStatement cs = conn.prepareCall("{call P_Change_BrandCar(?, ?, ?,?)}");
            System.out.println("hieuxe:" + hieuxe);
            cs.setString(1, hieuxe);
            cs.setString(2, txt_GhiChu.getText());
            cs.setInt(3, id);
            cs.registerOutParameter(4, java.sql.Types.INTEGER);
            cs.registerOutParameter(5, java.sql.Types.VARCHAR);
            ResultSet rs = cs.executeQuery();
            ketqua = cs.getInt(4);
            msg = cs.getString(5);
            if(ketqua == 0){
               JOptionPane.showMessageDialog(this, msg);
               txt_SLXeSuaTrongNgay.setText("");
               loadHieuXe();
               return;
            }else{
                JOptionPane.showMessageDialog(this, msg);
                loadHieuXe();
            }
        } catch (SQLException ex) {
            Logger.getLogger(Form_1.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public void loadSLXeSuaChua() {
        DefaultTableModel tbl_mod = (DefaultTableModel) SoluongXe.getModel();
        tbl_mod.setRowCount(0);
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select * from v_soluongxesuachua");
            while(rs.next()){
                String tbData[]=
                        {
                            rs.getString(2)
                        };
                tbl_mod.addRow(tbData);
             }
            System.out.println("count " + tbl_mod.getRowCount());
            soluongxesua = (int) SoluongXe.getValueAt(SoluongXe.getSelectedRow(), 0);
            System.out.println("soluong" + soluongxesua);
        } catch (SQLException ex) {
            Logger.getLogger(Form_1.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public void loadHieuXe() {
        DefaultTableModel tbl_mod = (DefaultTableModel) hieu_xe.getModel();
        tbl_mod.setRowCount(0);
        int row_count = 0;
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("select * from v_hieuxe");
            while(rs.next()){
                String tbData[]=
                        {
                            rs.getString(1),
                            rs.getString(2),
                            rs.getString(3)
                        };
                tbl_mod.addRow(tbData);
             }
            System.out.println("count " + tbl_mod.getRowCount());
        } catch (SQLException ex) {
            Logger.getLogger(Form_1.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public int getSL(){
        return soluongxesua;
    }
    

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JTable SoluongXe;
    private javax.swing.JButton SuaHieuXe;
    private javax.swing.JButton SuaTC;
    private javax.swing.JButton TimHieuXe;
    private javax.swing.JTable hieu_xe;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLayeredPane jLayeredPane1;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JTabbedPane jTabbedPane1;
    private java.awt.Panel panel2;
    private javax.swing.JTextField txt_GhiChu;
    private javax.swing.JTextField txt_HieuXe;
    private javax.swing.JTextField txt_SLXeSuaTrongNgay;
    // End of variables declaration//GEN-END:variables
}