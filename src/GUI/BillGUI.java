/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/GUIForms/JFrame.java to edit this template
 */
package GUI;

import DAL.DBConnection;
import DTO.UserLoginDTO;
import java.awt.Color;
import java.awt.TextField;
import java.awt.event.MouseEvent;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JComboBox;
import javax.swing.JOptionPane;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.swing.table.DefaultTableModel;

/**
 *
 * @author huynh
 */
public final class BillGUI extends javax.swing.JFrame 
{
    DBConnection a = new DBConnection();
    Connection conn ;
    DefaultTableModel tbn = new DefaultTableModel();
    long sotienthu = 0L;
    UserLoginDTO dtoUserLogin = null;
    public BillGUI(UserLoginDTO user)
        {
            initComponents();
            setLocationRelativeTo(null);
            this.setLocationRelativeTo(null);
            this.setVisible(true);
            dtoUserLogin = user;
            //setExtendedState(JFrame.MAXIMIZED_BOTH);  
            this.setSize(1000, 600);
            ConnectDB();
            updateBienSoXe();

        }
    
    public void ConnectDB() //load data to table
    {    
        try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            String sql = "CALL P_show_Bill()";         
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            DefaultTableModel model = (DefaultTableModel) tableBill.getModel();
            model.setRowCount(0);
            while (rs.next()){
                Object objList[] = {rs.getString("TenChuXe"), rs.getString("Phon3"), rs.getString("NgayThu"), 
                    rs.getString("BienSo"), rs.getString("Email"), rs.getString("SoTienThu")};
                model.addRow(objList);
            }
           
        } catch (SQLException ex) {
            Logger.getLogger(RepairGUI.class.getName()).log(Level.SEVERE, null, ex);
        }     
    }
    
    public void resetForm()
    {
        txtHoten.setText("");
        Ngaythutien.setDate(null);
        txtDienthoai.setText("");
        BienSoXe.setSelectedIndex(0);
        txtEmail.setText("");
        txtSotienthu.setText("");
    }
    
    public void updateBienSoXe()
    {       
        try {     
            conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            String sql = "Select * from xe";
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while(rs.next())
            {
                BienSoXe.addItem(rs.getString("BienSo"));
            }
        } catch (Exception e) {
        }   
    }
    
    /**
     * Creates new form RepairGUI
     */
    
    public int getIntValueFromTextField(TextField textField) {
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



/* Insert
    
    */
    
    public int insertHOADON() {
        PreparedStatement st;
        ResultSet rs;
        try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            java.util.Date utilStartDate = Ngaythutien.getDate();
            java.sql.Date date = new java.sql.Date(utilStartDate.getTime());
            String sql = "call P_Bill_Insert(?,?,?)";
            st = conn.prepareCall(sql);
            st.setString(1, getSelectedValue(BienSoXe));
            st.setDate(2, date);
            st.setFloat(3, getFloatValueFromTextField(txtSotienthu));
//            st.executeQuery();
            st.executeUpdate();


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
    
    public String getSelectedValue(JComboBox comboBox) {
    Object selectedItem = comboBox.getSelectedItem();
    if (selectedItem != null) {
        String selectedValue = selectedItem.toString();
        return selectedValue;
    } else {
        return null;
    }
    }
    
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        Jpanel = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        jLabel5 = new javax.swing.JLabel();
        jLabel6 = new javax.swing.JLabel();
        jLabel7 = new javax.swing.JLabel();
        jScrollPane2 = new javax.swing.JScrollPane();
        tableBill = new javax.swing.JTable();
        Ngaythutien = new com.toedter.calendar.JDateChooser();
        txtEmail = new javax.swing.JTextField();
        txtSotienthu = new javax.swing.JTextField();
        txtDienthoai = new javax.swing.JTextField();
        txtHoten = new javax.swing.JTextField();
        BienSoXe = new javax.swing.JComboBox<>();
        btnThem = new javax.swing.JButton();
        btnSua = new javax.swing.JButton();
        btnXoa = new javax.swing.JButton();
        panel1 = new java.awt.Panel();
        jLabel4 = new javax.swing.JLabel();
        jMenuBar1 = new javax.swing.JMenuBar();
        jMenu1 = new javax.swing.JMenu();
        jMenu2 = new javax.swing.JMenu();
        jMenu3 = new javax.swing.JMenu();
        jMenu4 = new javax.swing.JMenu();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setUndecorated(true);
        setResizable(false);

        jPanel1.setBackground(new java.awt.Color(204, 204, 204));

        Jpanel.setBackground(new java.awt.Color(130, 130, 130));

        jLabel1.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jLabel1.setForeground(new java.awt.Color(255, 255, 255));
        jLabel1.setText("Họ tên chủ xe:");

        jLabel2.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jLabel2.setForeground(new java.awt.Color(255, 255, 255));
        jLabel2.setText("Điện thoại:");

        jLabel3.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jLabel3.setForeground(new java.awt.Color(255, 255, 255));
        jLabel3.setText("Ngày thu tiền:");

        jLabel5.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jLabel5.setForeground(new java.awt.Color(255, 255, 255));
        jLabel5.setText("Biển số: ");

        jLabel6.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jLabel6.setForeground(new java.awt.Color(255, 255, 255));
        jLabel6.setText("Email: ");

        jLabel7.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jLabel7.setForeground(new java.awt.Color(255, 255, 255));
        jLabel7.setText("Số tiền thu:");

        tableBill.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        tableBill.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "Họ tên chủ xe", "Điện thoại", "Ngày thu tiền", "Biển số", "Email", "Số tiền thu"
            }
        ) {
            boolean[] canEdit = new boolean [] {
                false, false, false, false, false, false
            };

            public boolean isCellEditable(int rowIndex, int columnIndex) {
                return canEdit [columnIndex];
            }
        });
        tableBill.setCursor(new java.awt.Cursor(java.awt.Cursor.SW_RESIZE_CURSOR));
        tableBill.setRowHeight(40);
        tableBill.addAncestorListener(new javax.swing.event.AncestorListener() {
            public void ancestorMoved(javax.swing.event.AncestorEvent evt) {
            }
            public void ancestorAdded(javax.swing.event.AncestorEvent evt) {
                tableBillAncestorAdded(evt);
            }
            public void ancestorRemoved(javax.swing.event.AncestorEvent evt) {
            }
        });
        tableBill.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                tableBillMouseClicked(evt);
            }
        });
        jScrollPane2.setViewportView(tableBill);

        Ngaythutien.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N

        txtEmail.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        txtEmail.setForeground(new java.awt.Color(204, 204, 204));
        txtEmail.setText("Nhập địa chỉ email");
        txtEmail.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusGained(java.awt.event.FocusEvent evt) {
                txtEmailFocusGained(evt);
            }
            public void focusLost(java.awt.event.FocusEvent evt) {
                txtEmailFocusLost(evt);
            }
        });

        txtSotienthu.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        txtSotienthu.setForeground(new java.awt.Color(255, 255, 255));
        txtSotienthu.setText("Nhập số tiền thu");
        txtSotienthu.addHierarchyListener(new java.awt.event.HierarchyListener() {
            public void hierarchyChanged(java.awt.event.HierarchyEvent evt) {
                txtSotienthuHierarchyChanged(evt);
            }
        });
        txtSotienthu.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusGained(java.awt.event.FocusEvent evt) {
                txtSotienthuFocusGained(evt);
            }
            public void focusLost(java.awt.event.FocusEvent evt) {
                txtSotienthuFocusLost(evt);
            }
        });

        txtDienthoai.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        txtDienthoai.setForeground(new java.awt.Color(204, 204, 204));
        txtDienthoai.setText("Nhập số điện thoại");
        txtDienthoai.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusGained(java.awt.event.FocusEvent evt) {
                txtDienthoaiFocusGained(evt);
            }
            public void focusLost(java.awt.event.FocusEvent evt) {
                txtDienthoaiFocusLost(evt);
            }
        });
        txtDienthoai.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                txtDienthoaiActionPerformed(evt);
            }
        });

        txtHoten.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        txtHoten.setForeground(new java.awt.Color(204, 204, 204));
        txtHoten.setText("Nhập họ tên");
        txtHoten.addHierarchyListener(new java.awt.event.HierarchyListener() {
            public void hierarchyChanged(java.awt.event.HierarchyEvent evt) {
                txtHotenHierarchyChanged(evt);
            }
        });
        txtHoten.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusGained(java.awt.event.FocusEvent evt) {
                txtHotenFocusGained(evt);
            }
            public void focusLost(java.awt.event.FocusEvent evt) {
                txtHotenFocusLost(evt);
            }
        });

        BienSoXe.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        BienSoXe.setModel(new javax.swing.DefaultComboBoxModel<>(new String[] { " " }));
        BienSoXe.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                BienSoXeItemStateChanged(evt);
            }
        });
        BienSoXe.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                BienSoXeMouseClicked(evt);
            }
        });
        BienSoXe.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                BienSoXeActionPerformed(evt);
            }
        });

        btnThem.setBackground(new java.awt.Color(159, 182, 205));
        btnThem.setText("Thêm");
        btnThem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnThemActionPerformed(evt);
            }
        });

        btnSua.setBackground(new java.awt.Color(159, 182, 205));
        btnSua.setText("Sửa");
        btnSua.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnSuaActionPerformed(evt);
            }
        });

        btnXoa.setBackground(new java.awt.Color(159, 182, 205));
        btnXoa.setText("Xóa");
        btnXoa.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnXoaActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout JpanelLayout = new javax.swing.GroupLayout(Jpanel);
        Jpanel.setLayout(JpanelLayout);
        JpanelLayout.setHorizontalGroup(
            JpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(JpanelLayout.createSequentialGroup()
                .addGroup(JpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(JpanelLayout.createSequentialGroup()
                        .addContainerGap(34, Short.MAX_VALUE)
                        .addComponent(btnThem, javax.swing.GroupLayout.PREFERRED_SIZE, 100, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(51, 51, 51)
                        .addComponent(btnSua, javax.swing.GroupLayout.PREFERRED_SIZE, 101, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(46, 46, 46)
                        .addComponent(btnXoa, javax.swing.GroupLayout.PREFERRED_SIZE, 101, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, JpanelLayout.createSequentialGroup()
                        .addGroup(JpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel3)
                            .addComponent(jLabel1)
                            .addComponent(jLabel2))
                        .addGap(18, 18, 18)
                        .addGroup(JpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(txtHoten, javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(txtDienthoai)
                            .addComponent(Ngaythutien, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))))
                .addGap(51, 51, 51)
                .addGroup(JpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel6)
                    .addComponent(jLabel5)
                    .addComponent(jLabel7))
                .addGap(14, 14, 14)
                .addGroup(JpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(txtSotienthu, javax.swing.GroupLayout.PREFERRED_SIZE, 312, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(txtEmail, javax.swing.GroupLayout.PREFERRED_SIZE, 312, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(BienSoXe, javax.swing.GroupLayout.PREFERRED_SIZE, 312, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(116, Short.MAX_VALUE))
            .addGroup(JpanelLayout.createSequentialGroup()
                .addComponent(jScrollPane2)
                .addContainerGap())
        );
        JpanelLayout.setVerticalGroup(
            JpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(JpanelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(JpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(txtHoten, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel1)
                    .addComponent(jLabel5)
                    .addComponent(BienSoXe, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(JpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel2)
                    .addComponent(txtDienthoai, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(txtEmail, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel6))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 19, Short.MAX_VALUE)
                .addGroup(JpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, JpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(txtSotienthu, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel7))
                    .addComponent(Ngaythutien, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel3, javax.swing.GroupLayout.Alignment.LEADING))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(JpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(btnThem, javax.swing.GroupLayout.PREFERRED_SIZE, 37, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(JpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(btnSua, javax.swing.GroupLayout.PREFERRED_SIZE, 37, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(btnXoa, javax.swing.GroupLayout.PREFERRED_SIZE, 37, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(12, 12, 12)
                .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 411, javax.swing.GroupLayout.PREFERRED_SIZE))
        );

        panel1.setBackground(new java.awt.Color(159, 182, 205));

        jLabel4.setFont(new java.awt.Font("Segoe UI", 1, 24)); // NOI18N
        jLabel4.setForeground(new java.awt.Color(255, 255, 255));
        jLabel4.setText("Phiếu thu tiền");

        javax.swing.GroupLayout panel1Layout = new javax.swing.GroupLayout(panel1);
        panel1.setLayout(panel1Layout);
        panel1Layout.setHorizontalGroup(
            panel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(panel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel4)
                .addContainerGap(53, Short.MAX_VALUE))
        );
        panel1Layout.setVerticalGroup(
            panel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jLabel4, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 41, Short.MAX_VALUE)
        );

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(Jpanel, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(panel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                .addComponent(panel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(Jpanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
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
        jMenu1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenu1ActionPerformed(evt);
            }
        });
        jMenuBar1.add(jMenu1);

        jMenu2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Images/refresh.png"))); // NOI18N
        jMenu2.setText("Làm mới");
        jMenu2.setFont(new java.awt.Font("Segoe UI", 0, 18)); // NOI18N
        jMenu2.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jMenu2MouseClicked(evt);
            }
        });
        jMenu2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenu2ActionPerformed(evt);
            }
        });
        jMenuBar1.add(jMenu2);

        jMenu3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Images/printing.png"))); // NOI18N
        jMenu3.setText("In Hóa Đơn");
        jMenu3.setFont(new java.awt.Font("Segoe UI", 0, 18)); // NOI18N
        jMenuBar1.add(jMenu3);

        jMenu4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Images/sign-out-option.png"))); // NOI18N
        jMenu4.setText("Exit");
        jMenu4.setFont(new java.awt.Font("Segoe UI", 0, 18)); // NOI18N
        jMenu4.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jMenu4MouseClicked(evt);
            }
        });
        jMenu4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenu4ActionPerformed(evt);
            }
        });
        jMenuBar1.add(jMenu4);

        setJMenuBar(jMenuBar1);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    
    private void tableBillAncestorAdded(javax.swing.event.AncestorEvent evt) {//GEN-FIRST:event_tableBillAncestorAdded
        // TODO add your handling code here:
    }//GEN-LAST:event_tableBillAncestorAdded
/* Xoa */
    private void deleteHoadon() {
        ResultSet rs ;    
        try{
            conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            java.util.Date utilStartDate = Ngaythutien.getDate();
            java.sql.Date date = new java.sql.Date(utilStartDate.getTime());
            PreparedStatement ps = null;
            PreparedStatement statement = conn.prepareCall("{call P_Bill_Delete(?)}");
//            statement.setString(1, tableBill.getValueAt(tableBill.getSelectedRow(), 0).toString());
            statement.setString(1, getSelectedValue(BienSoXe));
//            statement.setDate(2, date); 
            if (JOptionPane.showConfirmDialog(this, "Delete this bill","Confirm",
                JOptionPane.YES_NO_OPTION)==JOptionPane.YES_OPTION){
            statement.executeQuery();
            rs = statement.getGeneratedKeys();
            int generatedKey = 0;
            if (rs.next()) {
                generatedKey = rs.getInt(1);
            }}
                statement.close();
                conn.close();
//            return generatedKey;
        } catch (Exception ex) {}
    }
   
    private void txtDienthoaiActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_txtDienthoaiActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_txtDienthoaiActionPerformed

    private void tableBillMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_tableBillMouseClicked
       try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            DefaultTableModel model = (DefaultTableModel) tableBill.getModel();
            int selectedrowindex = tableBill.getSelectedRow();
                txtHoten.setText(model.getValueAt(selectedrowindex, 0).toString());
                txtHoten.setForeground(new Color(0,0,0));
                txtDienthoai.setText(model.getValueAt(selectedrowindex, 1).toString());
                txtDienthoai.setForeground(new Color(0,0,0));
            Date date = new SimpleDateFormat("yyyy-MM-dd").parse((String)model.getValueAt(selectedrowindex, 2));
                Ngaythutien.setDate(date);
                txtEmail.setText(model.getValueAt(selectedrowindex, 4).toString());
                txtEmail.setForeground(new Color(0,0,0));
                txtSotienthu.setText(model.getValueAt(selectedrowindex, 5).toString());
                txtSotienthu.setForeground(new Color(0,0,0));
            String sql = "CALL P_BSX_Com(?)";
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, txtHoten.getText());
            ResultSet rs = st.executeQuery();
            while (rs.next())
            {
                BienSoXe.setSelectedIndex(rs.getInt("SoPhieu"));   
            }
        } catch (ParseException | SQLException ex) {
            Logger.getLogger(RepairGUI.class.getName()).log(Level.SEVERE, null, ex);
        }
    }//GEN-LAST:event_tableBillMouseClicked

    private void txtHotenFocusGained(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_txtHotenFocusGained
       if(txtHoten.getText().equals("Nhập họ tên"))
       {
           txtHoten.setText("");
           txtHoten.setForeground(new Color(0,0,0));
       }
    }//GEN-LAST:event_txtHotenFocusGained

    private void txtHotenHierarchyChanged(java.awt.event.HierarchyEvent evt) {//GEN-FIRST:event_txtHotenHierarchyChanged
        // TODO add your handling code here:
    }//GEN-LAST:event_txtHotenHierarchyChanged

    private void txtHotenFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_txtHotenFocusLost
        if(txtHoten.getText().equals(""))
       {
           txtHoten.setText("Nhập họ tên");
           txtHoten.setForeground(new Color(204, 204, 204));
       }
    }//GEN-LAST:event_txtHotenFocusLost

    private void txtDienthoaiFocusGained(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_txtDienthoaiFocusGained
        if(txtDienthoai.getText().equals("Nhập số điện thoại"))
       {
           txtDienthoai.setText("");
           txtDienthoai.setForeground(new Color(0,0,0));
       }
    }//GEN-LAST:event_txtDienthoaiFocusGained

    private void txtDienthoaiFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_txtDienthoaiFocusLost
        if(txtDienthoai.getText().equals(""))
       {
           txtDienthoai.setText("Nhập số điện thoại");
           txtDienthoai.setForeground(new Color(204, 204, 204));
       }
    }//GEN-LAST:event_txtDienthoaiFocusLost

    private void txtEmailFocusGained(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_txtEmailFocusGained
        if(txtEmail.getText().equals("Nhập địa chỉ email"))
       {
           txtEmail.setText("");
           txtEmail.setForeground(new Color(0,0,0));
       }
    }//GEN-LAST:event_txtEmailFocusGained

    private void txtEmailFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_txtEmailFocusLost
        if(txtEmail.getText().equals(""))
       {
           txtEmail.setText("Nhập địa chỉ email");
           txtEmail.setForeground(new Color(204, 204, 204));
       }
    }//GEN-LAST:event_txtEmailFocusLost

    private void txtSotienthuFocusGained(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_txtSotienthuFocusGained
        if(txtSotienthu.getText().equals("Nhập số tiền thu"))
       {
           txtSotienthu.setText("");
           txtSotienthu.setForeground(new Color(0,0,0));
       }
    }//GEN-LAST:event_txtSotienthuFocusGained

    private void txtSotienthuHierarchyChanged(java.awt.event.HierarchyEvent evt) {//GEN-FIRST:event_txtSotienthuHierarchyChanged
        // TODO add your handling code here:
    }//GEN-LAST:event_txtSotienthuHierarchyChanged

    private void txtSotienthuFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_txtSotienthuFocusLost
        if(txtSotienthu.getText().equals(""))
        {
           txtSotienthu.setText("Nhập số tiền thu");
           txtSotienthu.setForeground(new Color(204, 204, 204));
        }
    }//GEN-LAST:event_txtSotienthuFocusLost

    private void btnThemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnThemActionPerformed
        
        insertHOADON();
        resetForm();
        ConnectDB();
    }//GEN-LAST:event_btnThemActionPerformed

    private void btnSuaActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnSuaActionPerformed
        try {   
    conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
    java.util.Date utilStartDate = Ngaythutien.getDate();
    java.sql.Date date = new java.sql.Date(utilStartDate.getTime());
    int selectedRow = tableBill.getSelectedRow();
    if (selectedRow >= 0) {
        PreparedStatement statement = conn.prepareCall("{call P_Bill_Update(?,?,?,?,?,?)}");
        statement.setString(1, getSelectedValue(BienSoXe));
        statement.setDate(2, date);
        statement.setFloat(3, getFloatValueFromTextField(txtSotienthu));
        statement.setInt(4, Integer.parseInt(txtDienthoai.getText()));
        statement.setString(5, txtEmail.getText());
        statement.setString(6, txtHoten.getText());

        statement.executeUpdate();
        tbn.setRowCount(0);
        ConnectDB();
    } else {
        JOptionPane.showMessageDialog(null, "Please select a row to update.");
    }
} catch (Exception ex) {
    System.out.println(ex.toString());
    JOptionPane.showMessageDialog(null, "Error updating data: " + ex.getMessage());
}
resetForm();
    }//GEN-LAST:event_btnSuaActionPerformed

    private void btnXoaActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnXoaActionPerformed
        deleteHoadon ();
        resetForm();
        ConnectDB();
    }//GEN-LAST:event_btnXoaActionPerformed

    private void jMenu1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenu1ActionPerformed

    }//GEN-LAST:event_jMenu1ActionPerformed

    private void jMenu2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenu2ActionPerformed

    }//GEN-LAST:event_jMenu2ActionPerformed

    private void jMenu4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenu4ActionPerformed
        
    }//GEN-LAST:event_jMenu4ActionPerformed

    private void jMenu1MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jMenu1MouseClicked
        if(!dtoUserLogin.equals(null)){
            HomeGUI home = new HomeGUI(dtoUserLogin);
            this.dispose();
            
        }
    }//GEN-LAST:event_jMenu1MouseClicked

    private void jMenu2MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jMenu2MouseClicked
        resetForm();
    }//GEN-LAST:event_jMenu2MouseClicked

    private void jMenu4MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jMenu4MouseClicked
       this.dispose();
    }//GEN-LAST:event_jMenu4MouseClicked

    private void BienSoXeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_BienSoXeActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_BienSoXeActionPerformed

    private void BienSoXeMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_BienSoXeMouseClicked
        // TODO add your handling code here:
    }//GEN-LAST:event_BienSoXeMouseClicked

    private void BienSoXeItemStateChanged(java.awt.event.ItemEvent evt) {//GEN-FIRST:event_BienSoXeItemStateChanged
        try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            DefaultTableModel model = (DefaultTableModel) tableBill.getModel();
            String sql = "CALL P_BSX_Com2(?)";
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, (String)BienSoXe.getSelectedItem());
            ResultSet rs = st.executeQuery();
            while (rs.next())
            {
                txtHoten.setText(rs.getString("TenChuXe"));
                txtHoten.setForeground(new Color(0,0,0));
                txtDienthoai.setText(Integer.toString(rs.getInt("DienThoai")));
                txtDienthoai.setForeground(new Color(0,0,0));
                txtEmail.setText(rs.getString("Email"));
                txtEmail.setForeground(new Color(0,0,0));
            }
        }
        catch (SQLException ex) {
            Logger.getLogger(RepairGUI.class.getName()).log(Level.SEVERE, null, ex);
        }
    }//GEN-LAST:event_BienSoXeItemStateChanged

    
    public void checkInfo(){
        if(txtHoten.getText().equals("")){
            JOptionPane.showMessageDialog(this,"Vui lòng điền họ tên",
               "Vui lòng kiểm tra lại thông tin!", JOptionPane.ERROR_MESSAGE);
            return;
        }
        if(txtDienthoai.getText().equals("")){
            JOptionPane.showMessageDialog(this, "Vui lòng điền số điện thoại",
               "Vui lòng kiểm tra lại thông tin!", JOptionPane.ERROR_MESSAGE);
            return;
        }
        if(Ngaythutien.getDate() == null){
            JOptionPane.showMessageDialog(this, "Vui lòng điền ngày thu tiền",
               "Vui lòng kiểm tra lại thông tin!", JOptionPane.ERROR_MESSAGE);
            return;
        }
        if(txtEmail.getText().equals("")){
            JOptionPane.showMessageDialog(this, "Vui lòng điền email",
               "Vui lòng kiểm tra lại thông tin!", JOptionPane.ERROR_MESSAGE);
            return;
        }
        if(txtSotienthu.getText().equals("")){
            JOptionPane.showMessageDialog(this,"Vui lòng điền số tiền thu" ,
               "Vui lòng kiểm tra lại thông tin!", JOptionPane.ERROR_MESSAGE);
            return;
        }
    }
    

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JComboBox<String> BienSoXe;
    private javax.swing.JPanel Jpanel;
    private com.toedter.calendar.JDateChooser Ngaythutien;
    private javax.swing.JButton btnSua;
    private javax.swing.JButton btnThem;
    private javax.swing.JButton btnXoa;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JMenu jMenu1;
    private javax.swing.JMenu jMenu2;
    private javax.swing.JMenu jMenu3;
    private javax.swing.JMenu jMenu4;
    private javax.swing.JMenuBar jMenuBar1;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JScrollPane jScrollPane2;
    private java.awt.Panel panel1;
    private javax.swing.JTable tableBill;
    private javax.swing.JTextField txtDienthoai;
    private javax.swing.JTextField txtEmail;
    private javax.swing.JTextField txtHoten;
    private javax.swing.JTextField txtSotienthu;
    // End of variables declaration//GEN-END:variables
}
