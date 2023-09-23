/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/GUIForms/JFrame.java to edit this template
 */
package GUI;

import DTO.UserLoginDTO;
//import java.util.Date;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.util.Vector;
import DAL.DBConnection;
import java.sql.CallableStatement;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Date;
import static javax.swing.JOptionPane.showMessageDialog;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.ListSelectionModel;


/**
 *
 * @author huynh
 */
public class InssertGUI extends javax.swing.JFrame {
    /*
    18/04
    Do du lieu vao bang từ sql
    */
    DBConnection a=new DBConnection();
    Connection conn= a.ConnectDb();
    DefaultTableModel model =new DefaultTableModel();
    long impTotalMoney = 0L;
    private int m_id = 0;
    public InssertGUI (){
        initComponents();
        JTable  table = new JTable();
        JScrollPane scrollPane = new JScrollPane(table);
        getContentPane().add(scrollPane);
        tablePN=table;
        loadData();
    }
    
    public void loadData(){

    try {
        int number;
        Vector<String> row, column = new Vector<>();
        row = new Vector();
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery("select * from view_phieunhap");

        ResultSetMetaData metadata = rs.getMetaData();
        number = metadata.getColumnCount(); // Trả về số cột

        for (int i = 1; i <= number; i++) {
            column.add(metadata.getColumnName(i)); // Lấy ra tiêu đề của các cột
        }

        DefaultTableModel model = (DefaultTableModel) tablePN.getModel();
        model.setColumnIdentifiers(column);
        model.setRowCount(0); // Xóa tất cả dữ liệu hiện có trong mô hình bảng

        while (rs.next()) {
            row = new Vector();
            for (int i = 1; i <= number; i++) {
                row.addElement(rs.getString(i));
            }
            model.addRow(row);
        }
    } catch (Exception ex) {
        System.out.println(ex.toString());
    }
    }
      

    /**
     * Creates new form SearchGUI
     */
    //có sẳn
    UserLoginDTO dtoUserLogin = null;
    public InssertGUI(UserLoginDTO user) {
        initComponents();
        setLocationRelativeTo(null);
        this.setLocationRelativeTo(null);
        this.setVisible(true);
        dtoUserLogin = user;
        //setExtendedState(JFrame.MAXIMIZED_BOTH);  
        this.setSize(1000, 600);
    }

    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        jPanel4 = new javax.swing.JPanel();
        jLabel2 = new javax.swing.JLabel();
        jLabel5 = new javax.swing.JLabel();
        jLabel7 = new javax.swing.JLabel();
        txtTENSP = new javax.swing.JTextField();
        txtSL = new javax.swing.JTextField();
        txtDonGia = new javax.swing.JTextField();
        txtThem = new javax.swing.JButton();
        jScrollPane1 = new javax.swing.JScrollPane();
        tablePN = new javax.swing.JTable();
        txtXoa = new javax.swing.JButton();
        txtNgayNhap = new com.toedter.calendar.JDateChooser();
        txtSua = new javax.swing.JButton();
        jLabel11 = new javax.swing.JLabel();
        jLabel12 = new javax.swing.JLabel();
        panel1 = new java.awt.Panel();
        jLabel6 = new javax.swing.JLabel();
        jMenuBar1 = new javax.swing.JMenuBar();
        jMenu1 = new javax.swing.JMenu();
        jMenu4 = new javax.swing.JMenu();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setUndecorated(true);

        jPanel1.setBackground(new java.awt.Color(204, 204, 204));

        jPanel4.setBackground(new java.awt.Color(130, 130, 130));

        jLabel2.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jLabel2.setForeground(new java.awt.Color(255, 255, 255));
        jLabel2.setText("Ngày nhập");

        jLabel5.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jLabel5.setForeground(new java.awt.Color(255, 255, 255));
        jLabel5.setText("Tên Sản Phẩm");

        jLabel7.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jLabel7.setForeground(new java.awt.Color(255, 255, 255));
        jLabel7.setText("Số Lượng");

        txtTENSP.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N

        txtSL.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N

        txtDonGia.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N

        txtThem.setBackground(new java.awt.Color(159, 182, 205));
        txtThem.setText("Thêm");
        txtThem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                txtThemActionPerformed(evt);
            }
        });

        tablePN.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        tablePN.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "ImportID", "PartsID", "ImportDate", "ImportToteMoney", "ImportName", "ImportAmount", "ImportPrice"
            }
        ));
        tablePN.setCursor(new java.awt.Cursor(java.awt.Cursor.SW_RESIZE_CURSOR));
        tablePN.setRowHeight(30);
        tablePN.addAncestorListener(new javax.swing.event.AncestorListener() {
            public void ancestorAdded(javax.swing.event.AncestorEvent evt) {
                tablePNAncestorAdded(evt);
            }
            public void ancestorRemoved(javax.swing.event.AncestorEvent evt) {
            }
            public void ancestorMoved(javax.swing.event.AncestorEvent evt) {
            }
        });
        tablePN.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                tablePNMouseClicked(evt);
            }
        });
        jScrollPane1.setViewportView(tablePN);
        tablePN.getAccessibleContext().setAccessibleDescription("");

        txtXoa.setBackground(new java.awt.Color(159, 182, 205));
        txtXoa.setText("Xóa");
        txtXoa.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                txtXoaActionPerformed(evt);
            }
        });

        txtNgayNhap.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N

        txtSua.setBackground(new java.awt.Color(159, 182, 205));
        txtSua.setText("Sửa");
        txtSua.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                txtSuaMouseClicked(evt);
            }
        });
        txtSua.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                txtSuaActionPerformed(evt);
            }
        });

        jLabel11.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jLabel11.setForeground(new java.awt.Color(255, 255, 255));
        jLabel11.setText("Đơn giá");

        jLabel12.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jLabel12.setForeground(new java.awt.Color(255, 255, 255));
        jLabel12.setText("VND");

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addGap(26, 26, 26)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel4Layout.createSequentialGroup()
                        .addComponent(jLabel2)
                        .addGap(47, 47, 47)
                        .addComponent(txtNgayNhap, javax.swing.GroupLayout.PREFERRED_SIZE, 312, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel4Layout.createSequentialGroup()
                        .addComponent(jLabel5)
                        .addGap(22, 22, 22)
                        .addComponent(txtTENSP, javax.swing.GroupLayout.PREFERRED_SIZE, 312, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(136, 136, 136)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel7)
                    .addComponent(jLabel11))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(jPanel4Layout.createSequentialGroup()
                        .addComponent(txtDonGia)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel12, javax.swing.GroupLayout.PREFERRED_SIZE, 34, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(txtSL, javax.swing.GroupLayout.PREFERRED_SIZE, 294, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addGap(194, 194, 194)
                .addComponent(txtThem, javax.swing.GroupLayout.PREFERRED_SIZE, 144, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(72, 72, 72)
                .addComponent(txtXoa, javax.swing.GroupLayout.PREFERRED_SIZE, 144, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(72, 72, 72)
                .addComponent(txtSua, javax.swing.GroupLayout.PREFERRED_SIZE, 168, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
            .addComponent(jScrollPane1)
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addGap(24, 24, 24)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, 24, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(txtNgayNhap, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(txtSL, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel7)))
                .addGap(41, 41, 41)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel5)
                    .addComponent(txtTENSP, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(txtDonGia, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel11)
                        .addComponent(jLabel12)))
                .addGap(31, 31, 31)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(txtSua, javax.swing.GroupLayout.PREFERRED_SIZE, 38, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                        .addComponent(txtXoa, javax.swing.GroupLayout.DEFAULT_SIZE, 38, Short.MAX_VALUE)
                        .addComponent(txtThem, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                .addGap(20, 20, 20)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 360, javax.swing.GroupLayout.PREFERRED_SIZE))
        );

        panel1.setBackground(new java.awt.Color(159, 182, 205));

        jLabel6.setFont(new java.awt.Font("Segoe UI", 1, 24)); // NOI18N
        jLabel6.setForeground(new java.awt.Color(255, 255, 255));
        jLabel6.setText("Nhập phụ tùng");

        javax.swing.GroupLayout panel1Layout = new javax.swing.GroupLayout(panel1);
        panel1.setLayout(panel1Layout);
        panel1Layout.setHorizontalGroup(
            panel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(panel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel6)
                .addContainerGap(53, Short.MAX_VALUE))
        );
        panel1Layout.setVerticalGroup(
            panel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jLabel6, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 41, Short.MAX_VALUE)
        );

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGap(2, 2, 2)
                .addComponent(panel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(750, 769, Short.MAX_VALUE))
            .addComponent(jPanel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(panel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel4, javax.swing.GroupLayout.PREFERRED_SIZE, 563, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );

        jMenu1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Images/home.png"))); // NOI18N
        jMenu1.setText("Home");
        jMenu1.setFont(new java.awt.Font("Segoe UI", 0, 18)); // NOI18N
        jMenu1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jMenu1MouseClicked(evt);
            }
        });
        jMenuBar1.add(jMenu1);

        jMenu4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Images/sign-out-option.png"))); // NOI18N
        jMenu4.setText("Exit");
        jMenu4.setFont(new java.awt.Font("sansserif", 0, 18)); // NOI18N
        jMenu4.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jMenu4MouseClicked(evt);
            }
        });
        jMenuBar1.add(jMenu4);

        setJMenuBar(jMenuBar1);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents
    
    
    private void txtThemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_txtThemActionPerformed
        /*
        18/04
        Them
        */  
        if(txtSL.getText().equals("")){
            txtSL.setText("0");
        }
        if(txtDonGia.getText().equals("")){
            txtDonGia.setText("0");
        }  
        checkInfo();
        impTotalMoney = Long.valueOf(txtSL.getText()) *  Long.valueOf(txtDonGia.getText());
        java.util.Date utilDate = txtNgayNhap.getDate();
        java.sql.Date sql_date = new java.sql.Date(utilDate.getTime());
        try{
            
            CallableStatement cs = conn.prepareCall("{call 	Add_importgoods(?,?,?,?,?)}");
            cs.setDate(1, sql_date);
            cs.setLong(2, impTotalMoney);
            cs.setString(3, txtTENSP.getText());      
            cs.setString(4, txtSL.getText());
            cs.setString(5, txtDonGia.getText());
            
            
            cs.execute();

                JOptionPane.showMessageDialog(this, "Them Thanh Cong!");
                model.setRowCount(0);
                loadData();// trc khi load data can chuyen so cot ve 0
                
            
        }
        catch(Exception ex){
           System.out.println(ex.toString());
        }       
        
    }//GEN-LAST:event_txtThemActionPerformed
//Xóa
    private void txtXoaActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_txtXoaActionPerformed
        // TODO add your handling code here:
        try {
            // Prepare the stored procedure call
            CallableStatement stmt = conn.prepareCall("{call DELETE_DATA(?)}");

            // Set the input parameter
            stmt.setString(1, txtTENSP.getText());

            // Execute the stored procedure
            stmt.executeUpdate();

            System.out.println("Record  deleted successfully");
          // Delete the selected row from the displayed table
            int selectedRow = tablePN.getSelectedRow();
            ((DefaultTableModel)tablePN.getModel()).removeRow(selectedRow);           

        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        
  
      
    }//GEN-LAST:event_txtXoaActionPerformed

    private void tablePNAncestorAdded(javax.swing.event.AncestorEvent evt) {//GEN-FIRST:event_tablePNAncestorAdded
        // TODO add your handling code here:
    }//GEN-LAST:event_tablePNAncestorAdded

    private void txtSuaActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_txtSuaActionPerformed
        //int result = 0;
        checkInfo();
        try {   
        CallableStatement statement = conn.prepareCall("{call Update_importgoods(?, ?, ?, ?, ?, ?)}");    
        statement.setDate(1, new java.sql.Date(txtNgayNhap.getDate().getTime()));
        statement.setString(2, txtTENSP.getText());
        statement.setString(3, txtSL.getText());
        statement.setString(4, txtDonGia.getText()); 
        statement.setInt(5, m_id);
        
        //register output parameter
        statement.registerOutParameter(6, java.sql.Types.INTEGER);

        //execute the stored procedure
        statement.execute();

        //get the result of output parameter
        int result = statement.getInt(6);
        
        if(result == 0)
            JOptionPane.showMessageDialog(this, "Update Thanh Cong!");
        else
            JOptionPane.showMessageDialog(this, "Update Khong Thanh Cong!");      
        loadData();
    } catch(Exception ex){
        JOptionPane.showMessageDialog(null, ex);
    }
    }//GEN-LAST:event_txtSuaActionPerformed

    private void tablePNMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_tablePNMouseClicked
        /*
        10/5
        Hang
        */
        boolean a=tablePN.isEditing();
        if (a==false){
            //JOptionPane.showMessageDialog(null, " ");
        }
        
        DefaultTableModel RecordTable = (DefaultTableModel) tablePN.getModel();
        int SelectRows=tablePN.getSelectedRow();
        txtNgayNhap.setDateFormatString(RecordTable.getValueAt(SelectRows, 2).toString());
        txtDonGia.setText(RecordTable.getValueAt(SelectRows, 3).toString());
        txtTENSP.setText(RecordTable.getValueAt(SelectRows, 4).toString());
        txtSL.setText(RecordTable.getValueAt(SelectRows, 5).toString());
        
        m_id = (int) RecordTable.getValueAt(SelectRows, 0);
        System.out.println("check lan dau"+m_id);
        
    }//GEN-LAST:event_tablePNMouseClicked

    private void txtSuaMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_txtSuaMouseClicked
        // TODO add your handling code here:
    }//GEN-LAST:event_txtSuaMouseClicked

    private void jMenu1MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jMenu1MouseClicked
//              if(!dtoUserLogin.equals(null)){
//            HomeGUI home = new HomeGUI(dtoUserLogin);
//            this.dispose();
//        }
    }//GEN-LAST:event_jMenu1MouseClicked

    private void jMenu4MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jMenu4MouseClicked
        this.dispose();
    }//GEN-LAST:event_jMenu4MouseClicked
    
    public void checkInfo(){
        if(txtTENSP.getText().equals("")){
            JOptionPane.showMessageDialog(this,"Vui lòng điền tên sản phẩm",
               "Vui lòng kiểm tra lại thông tin!", JOptionPane.ERROR_MESSAGE);
            return;
        }
        if(txtSL.getText().equals("")){
            JOptionPane.showMessageDialog(this, "Vui lòng điền số lượng",
               "Vui lòng kiểm tra lại thông tin!", JOptionPane.ERROR_MESSAGE);
            return;
        }
        if(txtNgayNhap.getDate() == null){
            JOptionPane.showMessageDialog(this, "Vui lòng điền ngày nhập hàng",
               "Vui lòng kiểm tra lại thông tin!", JOptionPane.ERROR_MESSAGE);
            return;
        }
        if(txtDonGia.getText().equals("")){
            JOptionPane.showMessageDialog(this, "Vui lòng điền đơn giá sản phẩm",
               "Vui lòng kiểm tra lại thông tin!", JOptionPane.ERROR_MESSAGE);
            return;
        }
    }
    
    /**
     * @param args the command line arguments
     */



    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JMenu jMenu1;
    private javax.swing.JMenu jMenu4;
    private javax.swing.JMenuBar jMenuBar1;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JScrollPane jScrollPane1;
    private java.awt.Panel panel1;
    private javax.swing.JTable tablePN;
    private javax.swing.JTextField txtDonGia;
    private com.toedter.calendar.JDateChooser txtNgayNhap;
    private javax.swing.JTextField txtSL;
    private javax.swing.JButton txtSua;
    private javax.swing.JTextField txtTENSP;
    private javax.swing.JButton txtThem;
    private javax.swing.JButton txtXoa;
    // End of variables declaration//GEN-END:variables


}
