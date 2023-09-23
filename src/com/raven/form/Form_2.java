/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.raven.form;

import GUI.RepairGUI;
import java.awt.Color;
import java.awt.HeadlessException;
import java.awt.event.KeyEvent;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JComboBox;
import javax.swing.JOptionPane;
import javax.swing.JTextField;
import javax.swing.table.DefaultTableModel;
import net.proteanit.sql.DbUtils;

/**
 *
 * @author RAVEN
 */
public class Form_2 extends javax.swing.JPanel {

    /**
     * Creates new form Form_1
     */
    String strFind = "";
    public Form_2() {
        initComponents();
        ConnectDB();
        giaPT.setEditable(false);
        giaTC.setEditable(false);
    }
    
    public void updateTableData() {
        Connection conn;
        PreparedStatement st = null;
        ResultSet rs = null;
        try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            String sql = "CALL P_ShowRepair()";         
            st = conn.prepareStatement(sql);
            rs = st.executeQuery();
            Repair_List.setModel(DbUtils.resultSetToTableModel(rs));
        } catch (SQLException | HeadlessException ex) {
            JOptionPane.showMessageDialog(null, ex);
        } finally {
            try {
                rs.close();
                st.close();
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(null, ex);
            }
        }
    }
    
    public void updateComboBoxVTPT()
    {
        Connection conn; 
       
        try {     
            conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            String sql = "Select * from vattuphutung order by TenVTPT";
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while(rs.next())
            {
                vattuphutung.addItem(rs.getString("TenVTPT"));
            }
        } catch (Exception e) {
        }
    }
    
    public void updateComboBoxTC()
    {
        Connection conn; 
       
        try {     
            conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            String sql = "Select * from tiencong order by TenTC";
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while(rs.next())
            {
                loaitiencong.addItem(rs.getString("TenTC"));
            }
        } catch (Exception e) {
        }
    }
    
    public void resetform()
    {
        BienSoXe.removeAllItems();
        vattuphutung.removeAllItems();
        loaitiencong.removeAllItems();
    }
    
    public void resetformComboBox()
    {
        BienSoXe.setSelectedItem(null);
        vattuphutung.setSelectedItem(null);
        loaitiencong.setSelectedItem(null);
        NgaySuaChua.setDate(null);
        giaPT.setText("");
        giaTC.setText("");
    }
    
    public void resetformList()
    {
        BienSoXe.setSelectedItem(null);
        vattuphutung.setSelectedItem(null);
        loaitiencong.setSelectedItem(null);
        NgaySuaChua.setDate(null);
        solan.setText("");
        soluong.setText("");
        NoidungSC.setText("");
        giaPT.setText("");
        giaTC.setText("");
    }
    
    public void updateComboBoxBSX()
    {
        Connection conn; 
       
        try {     
            conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            String sql = "Select * from xe order by BienSo";
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while(rs.next())
            {
                BienSoXe.addItem(rs.getString("BienSo"));
            }
        } catch (Exception e) {
        }
    }
    
    private int checkUpOverwritten()
    {
        int outputValue = 0;
        try {
            Connection conn;
            CallableStatement st;
            ResultSet rs;
            java.util.Date utilStartDate = NgaySuaChua.getDate();
            java.sql.Date date2 = new java.sql.Date(utilStartDate.getTime());
            conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            String sql = "CALL P_CheckUpwritten(?,?,?,?,?)";
            st = conn.prepareCall(sql);
            String stt = (String) Repair_List.getModel().getValueAt(Repair_List.getSelectedRow(), 0);
            st.setInt(1,Integer.valueOf(stt));
            st.setString(2, getSelectedValue(BienSoXe));
            st.setDate(3, date2);
            st.setString(4, NoidungSC.getText());
            st.registerOutParameter(5, java.sql.Types.INTEGER);
            rs = st.executeQuery();
            outputValue = st.getInt(5);
        } catch (SQLException ex) {
            Logger.getLogger(RepairGUI.class.getName()).log(Level.SEVERE, null, ex);
        }
        return outputValue;  
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jProgressBar1 = new javax.swing.JProgressBar();
        jMenuBar1 = new javax.swing.JMenuBar();
        jMenu1 = new javax.swing.JMenu();
        jMenu2 = new javax.swing.JMenu();
        jCheckBox1 = new javax.swing.JCheckBox();
        jPanel1 = new javax.swing.JPanel();
        jPanel14 = new javax.swing.JPanel();
        jButton4 = new javax.swing.JButton();
        jButton1 = new javax.swing.JButton();
        jButton5 = new javax.swing.JButton();
        jButton3 = new javax.swing.JButton();
        jLabel3 = new javax.swing.JLabel();
        jLabel9 = new javax.swing.JLabel();
        jLabel10 = new javax.swing.JLabel();
        vattuphutung = new javax.swing.JComboBox<>();
        soluong = new javax.swing.JTextField();
        giaTC = new javax.swing.JTextField();
        giaPT = new javax.swing.JTextField();
        jLabel12 = new javax.swing.JLabel();
        jScrollPane3 = new javax.swing.JScrollPane();
        Repair_List = new javax.swing.JTable();
        NgaySuaChua = new com.toedter.calendar.JDateChooser();
        loaitiencong = new javax.swing.JComboBox<>();
        solan = new javax.swing.JTextField();
        NoidungSC = new javax.swing.JTextField();
        BienSoXe = new javax.swing.JComboBox<>();
        jButton2 = new javax.swing.JButton();
        jLabel14 = new javax.swing.JLabel();

        jMenu1.setText("File");
        jMenuBar1.add(jMenu1);

        jMenu2.setText("Edit");
        jMenuBar1.add(jMenu2);

        jCheckBox1.setText("jCheckBox1");

        setBackground(new java.awt.Color(242, 242, 242));

        jPanel1.setBackground(new java.awt.Color(255, 255, 255));

        jPanel14.setBackground(new java.awt.Color(176, 196, 222));

        jButton4.setBackground(new java.awt.Color(255, 255, 255));
        jButton4.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jButton4.setText("Tìm kiếm");
        jButton4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton4ActionPerformed(evt);
            }
        });

        jButton1.setBackground(new java.awt.Color(255, 255, 255));
        jButton1.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jButton1.setText("Thêm");
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        jButton5.setBackground(new java.awt.Color(255, 255, 255));
        jButton5.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jButton5.setText("Sửa");
        jButton5.setToolTipText("");
        jButton5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton5ActionPerformed(evt);
            }
        });

        jButton3.setBackground(new java.awt.Color(255, 255, 255));
        jButton3.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jButton3.setText("Xóa");
        jButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton3ActionPerformed(evt);
            }
        });

        jLabel3.setBackground(new java.awt.Color(0, 0, 0));
        jLabel3.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jLabel3.setText("Biển số xe:");

        jLabel9.setBackground(new java.awt.Color(0, 0, 0));
        jLabel9.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jLabel9.setText("Ngày sửa chữa:");

        jLabel10.setBackground(new java.awt.Color(0, 0, 0));
        jLabel10.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jLabel10.setText("Vật tư phụ tùng:");

        vattuphutung.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        vattuphutung.setModel(new javax.swing.DefaultComboBoxModel<>(new String[] { " ", " ", " ", " " }));
        vattuphutung.setMinimumSize(new java.awt.Dimension(34, 31));
        vattuphutung.setPreferredSize(new java.awt.Dimension(34, 31));
        vattuphutung.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                vattuphutungItemStateChanged(evt);
            }
        });
        vattuphutung.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                vattuphutungActionPerformed(evt);
            }
        });

        soluong.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        soluong.setForeground(new java.awt.Color(204, 204, 204));
        soluong.setText("SL");
        soluong.setPreferredSize(new java.awt.Dimension(34, 31));
        soluong.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusGained(java.awt.event.FocusEvent evt) {
                soluongFocusGained(evt);
            }
            public void focusLost(java.awt.event.FocusEvent evt) {
                soluongFocusLost(evt);
            }
        });
        soluong.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                soluongActionPerformed(evt);
            }
        });
        soluong.addPropertyChangeListener(new java.beans.PropertyChangeListener() {
            public void propertyChange(java.beans.PropertyChangeEvent evt) {
                soluongPropertyChange(evt);
            }
        });
        soluong.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                soluongKeyPressed(evt);
            }
        });

        giaTC.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        giaTC.setForeground(new java.awt.Color(204, 204, 204));
        giaTC.setText("Giá TC");
        giaTC.setPreferredSize(new java.awt.Dimension(34, 31));
        giaTC.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusGained(java.awt.event.FocusEvent evt) {
                giaTCFocusGained(evt);
            }
            public void focusLost(java.awt.event.FocusEvent evt) {
                giaTCFocusLost(evt);
            }
        });

        giaPT.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        giaPT.setForeground(new java.awt.Color(204, 204, 204));
        giaPT.setText("Giá PT");
        giaPT.setPreferredSize(new java.awt.Dimension(34, 31));
        giaPT.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusGained(java.awt.event.FocusEvent evt) {
                giaPTFocusGained(evt);
            }
            public void focusLost(java.awt.event.FocusEvent evt) {
                giaPTFocusLost(evt);
            }
        });
        giaPT.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                giaPTActionPerformed(evt);
            }
        });

        jLabel12.setBackground(new java.awt.Color(0, 0, 0));
        jLabel12.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jLabel12.setText("Tiền công:");

        Repair_List.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        Repair_List.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "STT", "Biển số xe", "Ngày sửa chữa", "Nội dung", "Tên phụ tùng", "Số lượng", "Tên tiền công", "Số lần", "Thành tiền"
            }
        ) {
            boolean[] canEdit = new boolean [] {
                true, false, false, false, false, false, false, false, false
            };

            public boolean isCellEditable(int rowIndex, int columnIndex) {
                return canEdit [columnIndex];
            }
        });
        Repair_List.setRowHeight(40);
        Repair_List.addContainerListener(new java.awt.event.ContainerAdapter() {
            public void componentAdded(java.awt.event.ContainerEvent evt) {
                Repair_ListComponentAdded(evt);
            }
        });
        Repair_List.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                Repair_ListMouseClicked(evt);
            }
        });
        jScrollPane3.setViewportView(Repair_List);

        NgaySuaChua.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N

        loaitiencong.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        loaitiencong.setModel(new javax.swing.DefaultComboBoxModel<>(new String[] { " ", " " }));
        loaitiencong.setMinimumSize(new java.awt.Dimension(34, 31));
        loaitiencong.setPreferredSize(new java.awt.Dimension(34, 31));
        loaitiencong.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                loaitiencongItemStateChanged(evt);
            }
        });

        solan.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        solan.setForeground(new java.awt.Color(204, 204, 204));
        solan.setText("SL");
        solan.setPreferredSize(new java.awt.Dimension(34, 31));
        solan.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusGained(java.awt.event.FocusEvent evt) {
                solanFocusGained(evt);
            }
            public void focusLost(java.awt.event.FocusEvent evt) {
                solanFocusLost(evt);
            }
        });
        solan.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                solanActionPerformed(evt);
            }
        });

        NoidungSC.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        NoidungSC.setForeground(new java.awt.Color(204, 204, 204));
        NoidungSC.setHorizontalAlignment(javax.swing.JTextField.CENTER);
        NoidungSC.setText("Nội dung sửa chữa");
        NoidungSC.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusGained(java.awt.event.FocusEvent evt) {
                NoidungSCFocusGained(evt);
            }
            public void focusLost(java.awt.event.FocusEvent evt) {
                NoidungSCFocusLost(evt);
            }
        });

        BienSoXe.setModel(new javax.swing.DefaultComboBoxModel<>(new String[] { " " }));

        jButton2.setBackground(new java.awt.Color(255, 255, 255));
        jButton2.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jButton2.setText("Làm mới");
        jButton2.setMaximumSize(new java.awt.Dimension(54, 31));
        jButton2.setMinimumSize(new java.awt.Dimension(54, 31));
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel14Layout = new javax.swing.GroupLayout(jPanel14);
        jPanel14.setLayout(jPanel14Layout);
        jPanel14Layout.setHorizontalGroup(
            jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel14Layout.createSequentialGroup()
                .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel14Layout.createSequentialGroup()
                        .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel14Layout.createSequentialGroup()
                                .addGap(32, 32, 32)
                                .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel10)
                                    .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                        .addComponent(jLabel3)
                                        .addComponent(jLabel9))))
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel14Layout.createSequentialGroup()
                                .addContainerGap()
                                .addComponent(jLabel12)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel14Layout.createSequentialGroup()
                                .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 141, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jButton5, javax.swing.GroupLayout.PREFERRED_SIZE, 141, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jButton3, javax.swing.GroupLayout.PREFERRED_SIZE, 141, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jButton2, javax.swing.GroupLayout.PREFERRED_SIZE, 141, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(0, 185, Short.MAX_VALUE))
                            .addGroup(jPanel14Layout.createSequentialGroup()
                                .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(NgaySuaChua, javax.swing.GroupLayout.PREFERRED_SIZE, 344, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGroup(jPanel14Layout.createSequentialGroup()
                                        .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                            .addComponent(loaitiencong, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 199, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(vattuphutung, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 199, javax.swing.GroupLayout.PREFERRED_SIZE))
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                        .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                            .addComponent(solan, javax.swing.GroupLayout.PREFERRED_SIZE, 141, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(soluong, javax.swing.GroupLayout.PREFERRED_SIZE, 141, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                    .addComponent(BienSoXe, javax.swing.GroupLayout.PREFERRED_SIZE, 348, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addGap(12, 12, 12)
                                .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                    .addComponent(giaPT, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                    .addComponent(jButton4, javax.swing.GroupLayout.DEFAULT_SIZE, 128, Short.MAX_VALUE)
                                    .addComponent(giaTC, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(NoidungSC))))
                    .addComponent(jScrollPane3))
                .addContainerGap())
        );
        jPanel14Layout.setVerticalGroup(
            jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel14Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel14Layout.createSequentialGroup()
                        .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel3)
                            .addComponent(jButton4, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(BienSoXe, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel14Layout.createSequentialGroup()
                                .addGap(16, 16, 16)
                                .addComponent(jLabel9))
                            .addGroup(jPanel14Layout.createSequentialGroup()
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(NgaySuaChua, javax.swing.GroupLayout.PREFERRED_SIZE, 32, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(soluong, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel10)
                                .addComponent(giaPT, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(vattuphutung, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                        .addGap(12, 12, 12)
                        .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(loaitiencong, javax.swing.GroupLayout.PREFERRED_SIZE, 29, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(solan, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(giaTC, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel12)))
                    .addComponent(NoidungSC, javax.swing.GroupLayout.PREFERRED_SIZE, 167, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(13, 13, 13)
                .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jButton3, javax.swing.GroupLayout.DEFAULT_SIZE, 39, Short.MAX_VALUE)
                    .addComponent(jButton5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jButton2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jButton1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jScrollPane3, javax.swing.GroupLayout.PREFERRED_SIZE, 341, javax.swing.GroupLayout.PREFERRED_SIZE))
        );

        jLabel14.setBackground(new java.awt.Color(0, 0, 0));
        jLabel14.setFont(new java.awt.Font("Segoe UI", 1, 24)); // NOI18N
        jLabel14.setText("Phiếu sửa chữa");
        jLabel14.setMaximumSize(new java.awt.Dimension(173, 31));
        jLabel14.setMinimumSize(new java.awt.Dimension(173, 31));
        jLabel14.setPreferredSize(new java.awt.Dimension(173, 31));

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel14, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel14, javax.swing.GroupLayout.PREFERRED_SIZE, 195, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel14, javax.swing.GroupLayout.PREFERRED_SIZE, 47, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel14, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jButton4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton4ActionPerformed
        strFind = getSelectedValue(BienSoXe);
        java.util.Date utilStartDate = NgaySuaChua.getDate();
        java.sql.Date date = null;
        if(utilStartDate != null)
        {
            date = new java.sql.Date(utilStartDate.getTime());
        }
        loadData(strFind, date);
    }//GEN-LAST:event_jButton4ActionPerformed

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed

        strFind = getSelectedValue(BienSoXe);
        String strNoiDungSC = NoidungSC.getText();
        java.util.Date utilStartDate = NgaySuaChua.getDate();
        java.sql.Date date = new java.sql.Date(utilStartDate.getTime());

        if (!checkValidationForm()){
            JOptionPane.showMessageDialog(this, "Bạn chưa nhập đầy đủ thông tin!");
        }

        else if (checkOverwritten(strFind, date ,strNoiDungSC) > 0)
        {
            JOptionPane.showMessageDialog(this, "Bạn không được phép nhập trùng thông tin với Biển số xe, ngày sửa chữa và nội dung sửa chữa");
        }
        else {
            insertSuaChua();
            resetformList();
            ConnectDB();
        }
    }//GEN-LAST:event_jButton1ActionPerformed

    private void jButton5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton5ActionPerformed
        System.out.println(checkUpOverwritten());  
        if (!checkValidationForm()){
            JOptionPane.showMessageDialog(this, "Bạn chưa nhập đầy đủ thông tin!");
        }
        
        else if(checkUpOverwritten() == 0)
        {
            JOptionPane.showMessageDialog(this, "Không được sửa thành thông tin trùng Biển số xe, ngày sửa chữa và Nội dung sửa chữa!");
        }
        else {
            UpdateSuaChua();
            updateTableData();
            resetformList();
            ConnectDB();
        }
    }//GEN-LAST:event_jButton5ActionPerformed

    private void jButton3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton3ActionPerformed
        DeleteSuaChua();
        JOptionPane.showMessageDialog(null,"Xoá thông tin thành công!");
        resetformList();
        ConnectDB();
    }//GEN-LAST:event_jButton3ActionPerformed

    private void vattuphutungItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_vattuphutungItemStateChanged
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            String sql = "CALL P_CPT(?)";
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, (String)vattuphutung.getSelectedItem());
            ResultSet rs = st.executeQuery();
            while (rs.next())
            {
                giaPT.setText(rs.getString("DonGiaBan"));
                giaPT.setForeground(new Color(0,0,0));
            }
        }
        catch (SQLException ex) {
            Logger.getLogger(RepairGUI.class.getName()).log(Level.SEVERE, null, ex);
        }
    }//GEN-LAST:event_vattuphutungItemStateChanged

    private void vattuphutungActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_vattuphutungActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_vattuphutungActionPerformed

    private void soluongFocusGained(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_soluongFocusGained
        if(soluong.getText().equals("SL"))
        {
            soluong.setText("");
            soluong.setForeground(new Color(0,0,0));
        }
    }//GEN-LAST:event_soluongFocusGained

    private void soluongFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_soluongFocusLost
        if(soluong.getText().equals(""))
        {
            soluong.setText("SL");
            soluong.setForeground(new Color(204, 204, 204));
        }
    }//GEN-LAST:event_soluongFocusLost

    private void soluongActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_soluongActionPerformed
        String sl = soluong.getText();
        if(sl.equals("0")){
            JOptionPane.showMessageDialog(this, "Vui lòng nhập số lượng lớn hơn 0");
            soluong.setText("");
        }
    }//GEN-LAST:event_soluongActionPerformed

    private void giaTCFocusGained(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_giaTCFocusGained
        if(giaTC.getText().equals("Giá TC"))
        {
            giaTC.setText("");
            giaTC.setForeground(new Color(0,0,0));
        }
    }//GEN-LAST:event_giaTCFocusGained

    private void giaTCFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_giaTCFocusLost
        if(giaTC.getText().equals(""))
        {
            giaTC.setText("Giá TC");
            giaTC.setForeground(new Color(204, 204, 204));
        }
    }//GEN-LAST:event_giaTCFocusLost

    private void giaPTFocusGained(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_giaPTFocusGained
        if(giaPT.getText().equals("Giá PT"))
        {
            giaPT.setText("");
            giaPT.setForeground(new Color(0,0,0));
        }
    }//GEN-LAST:event_giaPTFocusGained

    private void giaPTFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_giaPTFocusLost
        if(giaPT.getText().equals(""))
        {
            giaPT.setText("Giá PT");
            giaPT.setForeground(new Color(204, 204, 204));
        }
    }//GEN-LAST:event_giaPTFocusLost

    private void giaPTActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_giaPTActionPerformed

    }//GEN-LAST:event_giaPTActionPerformed

    private void Repair_ListComponentAdded(java.awt.event.ContainerEvent evt) {//GEN-FIRST:event_Repair_ListComponentAdded

    }//GEN-LAST:event_Repair_ListComponentAdded

    private void Repair_ListMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_Repair_ListMouseClicked
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            DefaultTableModel model = (DefaultTableModel) Repair_List.getModel();
            int selectedrowindex = Repair_List.getSelectedRow();
            BienSoXe.setSelectedItem(model.getValueAt(selectedrowindex, 1).toString());
            Date date = new SimpleDateFormat("yyyy-MM-dd").parse((String)model.getValueAt(selectedrowindex, 2));
            NgaySuaChua.setDate(date);
            NoidungSC.setText(model.getValueAt(selectedrowindex, 3).toString());
            NoidungSC.setForeground(new Color(0,0,0));
            vattuphutung.setSelectedItem(model.getValueAt(selectedrowindex, 4).toString());
            soluong.setText(model.getValueAt(selectedrowindex, 5).toString());
            soluong.setForeground(new Color(0,0,0));
            loaitiencong.setSelectedItem(model.getValueAt(selectedrowindex, 6).toString());
            solan.setText(model.getValueAt(selectedrowindex, 7).toString());
            solan.setForeground(new Color(0,0,0));

            String sql = "CALL P_ClickedForPrice(?)";
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, model.getValueAt(selectedrowindex, 0).toString());
            ResultSet rs = st.executeQuery();
            while (rs.next())
            {
                giaPT.setText(rs.getString("DonGia"));
                giaPT.setForeground(new Color(0,0,0));
                giaTC.setText(rs.getString("GiaTien"));
                giaTC.setForeground(new Color(0,0,0));
            }
        } catch (ParseException | SQLException ex) {
            Logger.getLogger(RepairGUI.class.getName()).log(Level.SEVERE, null, ex);
        }
    }//GEN-LAST:event_Repair_ListMouseClicked

    private void loaitiencongItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_loaitiencongItemStateChanged
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            String sql = "CALL P_CTC(?)";
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, (String)loaitiencong.getSelectedItem());
            ResultSet rs = st.executeQuery();
            while (rs.next())
            {
                giaTC.setText(rs.getString("GiaTien"));
                giaTC.setForeground(new Color(0,0,0));
            }
        }
        catch (SQLException ex) {
            Logger.getLogger(RepairGUI.class.getName()).log(Level.SEVERE, null, ex);
        }
    }//GEN-LAST:event_loaitiencongItemStateChanged

    private void solanFocusGained(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_solanFocusGained
        if(solan.getText().equals("SL"))
        {
            solan.setText("");
            solan.setForeground(new Color(0,0,0));
        }
    }//GEN-LAST:event_solanFocusGained

    private void solanFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_solanFocusLost
        if(solan.getText().equals(""))
        {
            solan.setText("SL");
            solan.setForeground(new Color(204, 204, 204));
        }
    }//GEN-LAST:event_solanFocusLost

    private void NoidungSCFocusGained(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_NoidungSCFocusGained
        if(NoidungSC.getText().equals("Nội dung sửa chữa"))
        {
            NoidungSC.setText("");
            NoidungSC.setForeground(new Color(0,0,0));
        }
    }//GEN-LAST:event_NoidungSCFocusGained

    private void NoidungSCFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_NoidungSCFocusLost
        if(NoidungSC.getText().equals(""))
        {
            NoidungSC.setText("Nội dung sửa chữa");
            NoidungSC.setForeground(new Color(204, 204, 204));
        }
    }//GEN-LAST:event_NoidungSCFocusLost

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        resetformList();
        ConnectDB();
    }//GEN-LAST:event_jButton2ActionPerformed

    private void soluongKeyPressed(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_soluongKeyPressed

    }//GEN-LAST:event_soluongKeyPressed

    private void soluongPropertyChange(java.beans.PropertyChangeEvent evt) {//GEN-FIRST:event_soluongPropertyChange

    }//GEN-LAST:event_soluongPropertyChange

    private void solanActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_solanActionPerformed
        String sl = solan.getText();
        if(sl.equals("0")){
            JOptionPane.showMessageDialog(this, "Vui lòng nhập số lần lớn hơn 0");
            solan.setText("");
        }
    }//GEN-LAST:event_solanActionPerformed
    
    public void ConnectDB() //load data to table
    {
            Connection conn;     
        try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            String sql = "CALL P_ShowRepair()";         
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            DefaultTableModel model = (DefaultTableModel) Repair_List.getModel();
            model.setRowCount(0);
            while (rs.next()){
                Object objList[] = {rs.getString("SoPSC"), rs.getString("BienSo"), rs.getString("NgaySuaChua"), rs.getString("NoiDungSC"), 
                    rs.getString("TenVTPT"), rs.getString("SoLuong"), rs.getString("TenTC"), 
                    rs.getString("SoLan"), rs.getString("TongTien")};
                model.addRow(objList);
            }
           
        } catch (SQLException ex) {
            Logger.getLogger(RepairGUI.class.getName()).log(Level.SEVERE, null, ex);
        }     
    }
    
    public void loadData(String str, Date date2) // find information
    {
        try {
            ResultSet rs;
            PreparedStatement st = null;
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            if(date2 != null){
                    java.util.Date date1 = date2;
                    java.sql.Date date3 = new java.sql.Date(date1.getTime());
                if(str == "")
                {
                    st = conn.prepareStatement("CALL P_findRepair2(?,?)");
                    st.setString(1, str);
                    st.setDate(2, (java.sql.Date) date3);
                }
                else
                {
                    st = conn.prepareStatement("CALL P_findRepair3(?)");
                    st.setDate(1, (java.sql.Date) date3);
                }
            }
            else{
                if(str == "")
                {
                    ConnectDB();
                }
                else
                {
                    st = conn.prepareStatement("CALL P_findRepair1(?)");
                    st.setString(1, str);          
                }
            }
            rs = st.executeQuery();
            DefaultTableModel model = (DefaultTableModel) Repair_List.getModel();
            model.setRowCount(0);
            while (rs.next()){    
                Object objList[] = {rs.getString("SoPSC"), rs.getString("BienSo"), rs.getString("NgaySuaChua"), rs.getString("NoiDungSC"), 
                    rs.getString("TenVTPT"), rs.getString("SoLuong"), rs.getString("TenTC"), 
                    rs.getString("SoLan"), rs.getString("TongTien")};
                model.addRow(objList);
            }
        } catch (SQLException ex) {
            System.out.print(ex.getMessage());
        }
    }
    
    public String getSelectedValue(JComboBox comboBox) {
    Object selectedItem = comboBox.getSelectedItem();
    if (selectedItem != null) {
        String selectedValue = selectedItem.toString();
        return selectedValue;
    } else {
        return null;
    }
    }
    
    public boolean checkValidationForm(){
        if (getSelectedValue(BienSoXe).isEmpty() 
                || soluong.getText().isEmpty() 
                || giaPT.getText().isEmpty()
                || solan.getText().isEmpty()
                || giaTC.getText().isEmpty())
            {
                return false;
            }
        return true;
    }
    
    
    public int checkOverwritten(String bienSoXe, Date date, String noiDung) {
        int count = 0;
        try {
            
            Connection conn;
            PreparedStatement st;
            ResultSet rs;
            java.util.Date utilStartDate = NgaySuaChua.getDate();
            java.sql.Date date2 = new java.sql.Date(utilStartDate.getTime());
            conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            String sql = "CALL P_CheckOverwritten(?,?,?)";
            st = conn.prepareStatement(sql);
            st.setString(1, getSelectedValue(BienSoXe));
            st.setDate(2, date2);
            st.setString(3, NoidungSC.getText());
            rs = st.executeQuery();
            while (rs.next())
            {
                count = rs.getInt("DEM");
            }
                      
        } catch (SQLException ex) {
            Logger.getLogger(RepairGUI.class.getName()).log(Level.SEVERE, null, ex);
        }
        return count;  
    }
    
    public int insertSuaChua() {
        Connection conn;
        CallableStatement st;
        ResultSet rs;
        int output = 0;
        try {  
            
            conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            java.util.Date utilStartDate = NgaySuaChua.getDate();
            java.sql.Date date = new java.sql.Date(utilStartDate.getTime());
            String sql = "CALL P_AddRepairList(?,?,?,?,?,?,?,?,?,?)";
            st = conn.prepareCall(sql);
            st.setString(1, getSelectedValue(BienSoXe));
            st.setDate(2, date);
            st.setString(3, getSelectedValue(vattuphutung));
            st.setFloat(4, getIntValueFromTextField(soluong));
            st.setFloat(5, getFloatValueFromTextField(giaPT));
            st.setString(6, getSelectedValue(loaitiencong));
            st.setString(7, solan.getText());
            st.setFloat(8, getFloatValueFromTextField(giaTC));
            st.setString(9, NoidungSC.getText());
            st.registerOutParameter(10, java.sql.Types.INTEGER);
            st.executeQuery();
            output = st.getInt(10);
            rs = st.getGeneratedKeys();
            int generatedKey = 0;
            if (rs.next()) {
                generatedKey = rs.getInt(1);
            }
                st.close();
                conn.close();
            if(output == 0 ){
                JOptionPane.showMessageDialog(null,"Không được phép thêm ngày sửa chữa nhỏ hơn ngày tiếp nhận!");
            }
            else
            {
            JOptionPane.showMessageDialog(null, "Thêm thành công!");
        }
          
            return generatedKey;
            
        } catch (Exception ex) {
        }
            return output;
        }
    
    public int getIntValueFromTextField(JTextField textField) {
    String text = textField.getText();
    int intValue = 0; // giá trị mặc định nếu không thể chuyển đổi chuỗi thành số nguyên

    try {
        intValue = Integer.parseInt(text);
    } catch (NumberFormatException e) {
        // Xử lý ngoại lệ nếu không thể chuyển đổi chuỗi thành số nguyên

    }
    return intValue;
    }
    
    public float getFloatValueFromTextField(JTextField textField) {
    String text = textField.getText();
    float floatValue = 0.0f; // giá trị mặc định nếu không thể chuyển đổi chuỗi thành số thực

    try {
        floatValue = Float.parseFloat(text);
    } catch (NumberFormatException e) {
        // Xử lý ngoại lệ nếu không thể chuyển đổi chuỗi thành số thực

    }
    return floatValue;
    }
    
    public void UpdateSuaChua(){
    Connection conn;
        CallableStatement st;
        String sql;
        int output = 0;
        try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            sql = "CALL P_UpdatePSC(?,?,?,?,?,?,?,?,?,?,?)";
            st = conn.prepareCall(sql);
            int selectedrowindex = Repair_List.getSelectedRow();
            java.util.Date utilStartDate = NgaySuaChua.getDate();
            DefaultTableModel model = (DefaultTableModel) Repair_List.getModel();
            java.sql.Date date = new java.sql.Date(utilStartDate.getTime());
            st.setString(1, model.getValueAt(selectedrowindex, 0).toString());
            st.setString(2, getSelectedValue(BienSoXe));
            st.setDate(3, date);
            st.setString(4, getSelectedValue(vattuphutung));
            st.setFloat(5, getIntValueFromTextField(soluong));
            st.setFloat(6, getFloatValueFromTextField(giaPT));
            st.setString(7, getSelectedValue(loaitiencong));
            st.setString(8, solan.getText());
            st.setFloat(9, getFloatValueFromTextField(giaTC));
            st.setString(10, NoidungSC.getText());
            st.registerOutParameter(11, java.sql.Types.INTEGER);
            st.executeUpdate();
            output = st.getInt(11);
            if(output == 0 ){
                JOptionPane.showMessageDialog(null,"Không được phép sửa ngày sửa chữa nhỏ hơn ngày tiếp nhận!");
            }
            else
            {
            JOptionPane.showMessageDialog(null, "Sửa thành công!");
        }} catch (SQLException | HeadlessException ex) {
            JOptionPane.showMessageDialog(null, ex);
        }
    }
   
    
    public int DeleteSuaChua() {
        Connection conn;
        PreparedStatement st;
        ResultSet rs;
        try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            String sql = "CALL 	P_DelRepairList(?,?)";
            st = conn.prepareCall(sql);
            int selectedrowindex = Repair_List.getSelectedRow();
            DefaultTableModel model = (DefaultTableModel) Repair_List.getModel();
            st.setString(1, model.getValueAt(selectedrowindex, 0).toString());
            st.setString(2, soluong.getText());
            st.executeQuery();
            rs = st.getGeneratedKeys();
            int generatedKey = 0;
            if (rs.next()) {
                generatedKey = rs.getInt(1);
            }
                st.close();
                conn.close();
            return generatedKey;
        } catch (Exception ex) {
        }
            return 0;
        }
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JComboBox<String> BienSoXe;
    private com.toedter.calendar.JDateChooser NgaySuaChua;
    private javax.swing.JTextField NoidungSC;
    private javax.swing.JTable Repair_List;
    private javax.swing.JTextField giaPT;
    private javax.swing.JTextField giaTC;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButton3;
    private javax.swing.JButton jButton4;
    private javax.swing.JButton jButton5;
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel14;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JMenu jMenu1;
    private javax.swing.JMenu jMenu2;
    private javax.swing.JMenuBar jMenuBar1;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel14;
    private javax.swing.JProgressBar jProgressBar1;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JComboBox<String> loaitiencong;
    private javax.swing.JTextField solan;
    private javax.swing.JTextField soluong;
    private javax.swing.JComboBox<String> vattuphutung;
    // End of variables declaration//GEN-END:variables
}
