/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/GUIForms/JFrame.java to edit this template
 */
package GUI;

import raven.cell.TableActionCellRender;
import DTO.UserLoginDTO;
import com.toedter.calendar.JDateChooser;
import java.awt.Color;
import java.awt.HeadlessException;
import java.awt.Panel;
import java.awt.ScrollPane;
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
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.JTextField;
import javax.swing.table.*;
import net.proteanit.sql.DbUtils;
/**
 *      
 * @author huynh
 */

public final class RepairGUI extends javax.swing.JFrame {

    private static void SuaChua(String BSX, Date date, String LoaiVT, int sl, float giaP, String LoaiTC, float giaTC) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    /**
     * Creates new form RepairGUI
     */
    String strFind = "";
    UserLoginDTO dtoUserLogin = null;
    public RepairGUI(UserLoginDTO user) {
        initComponents();
        setLocationRelativeTo(null);
        this.setLocationRelativeTo(null);
        this.setVisible(true);
        dtoUserLogin = user;
        //setExtendedState(JFrame.MAXIMIZED_BOTH);  
        this.setSize(1000, 600);
        ConnectDB();    
        updateComboBoxVTPT();
        updateComboBoxTC();
        updateComboBoxBSX();
    }
    
    public void resetForm()
    {
        BienSoXe.setSelectedIndex(0);
        NgaySuaChua.setDate(null);
        giaPT.setText("");
        vattuphutung.setSelectedIndex(0);
        soluong.setText("");
        solan.setText("");
        loaitiencong.setSelectedIndex(0);
        giaTC.setText("");
        NoidungSC.setText("");
    }

    public int checkMaxSC()
    {
       int count = 0;
       try {
            Connection conn;
            PreparedStatement st;
            ResultSet rs;
            java.util.Date utilStartDate = NgaySuaChua.getDate();
            java.sql.Date date2 = new java.sql.Date(utilStartDate.getTime());
            conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            String sql = "CALL P_CheckMaxSC(?)";
            st = conn.prepareStatement(sql);
            st.setDate(1, date2);
            rs = st.executeQuery();
            while (rs.next())
            {
                count   = rs.getInt("DEM");
            }
           
        } catch (SQLException ex) {
            Logger.getLogger(RepairGUI.class.getName()).log(Level.SEVERE, null, ex);
        } 
       return count;
    }
    
    /*public int checkToInsert()
    {
       int count = 0;
       try {
            Connection conn;
            PreparedStatement st;
            ResultSet rs;
            conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            String sql = "SELECT GiaTri FROM thamso WHERE TenThamSo = 'SoXeSuaChuaTrongNgay'";
            st = conn.prepareStatement(sql);
            rs = st.executeQuery();
            while (rs.next())
            {
                count   = rs.getInt("GiaTri");
            }
           
        } catch (SQLException ex) {
            Logger.getLogger(RepairGUI.class.getName()).log(Level.SEVERE, null, ex);
        } 
       return count; 
    }*/
    
    
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
                Object objList[] = {rs.getString("BienSo"), rs.getString("NgaySuaChua"), rs.getString("NoiDungSC"), 
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
                Object objList[] = {rs.getString("BienSo"), rs.getString("NgaySuaChua"), rs.getString("NoiDungSC"), 
                    rs.getString("TenVTPT"), rs.getString("SoLuong"), rs.getString("TenTC"), 
                    rs.getString("SoLan"), rs.getString("TongTien")};
                model.addRow(objList);
            }
        } catch (SQLException ex) {
            System.out.print(ex.getMessage());
        }
    }
    
    
    
    public int insertSuaChua() {
        Connection conn;
        PreparedStatement st;
        ResultSet rs;
        try {  
            
            conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            java.util.Date utilStartDate = NgaySuaChua.getDate();
            java.sql.Date date = new java.sql.Date(utilStartDate.getTime());
            String sql = "CALL P_AddRepairList(?,?,?,?,?,?,?,?,?)";
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
        //Finish Show Students

    public RepairGUI(JComboBox<String> BienSoXe, JDateChooser NgaySuaChua, JTextField NoidungSC, JTable Repair_List, JTextField giaPT, JTextField giaTC, JButton jButton1, JButton jButton3, JButton jButton4, JButton jButton5, JLabel jLabel10, JLabel jLabel12, JLabel jLabel14, JLabel jLabel3, JLabel jLabel9, JMenu jMenu1, JMenu jMenu2, JMenu jMenu3, JMenu jMenu4, JMenuBar jMenuBar1, JPanel jPanel1, JPanel jPanel14, JScrollPane jScrollPane3, JComboBox<String> loaitiencong, Panel panel1, ScrollPane scrollPane1, JTextField solan, JTextField soluong, JComboBox<String> vattuphutung) throws HeadlessException {
        this.BienSoXe = BienSoXe;
        this.NgaySuaChua = NgaySuaChua;
        this.NoidungSC = NoidungSC;
        this.Repair_List = Repair_List;
        this.giaPT = giaPT;
        this.giaTC = giaTC;
        this.jButton1 = jButton1;
        this.jButton3 = jButton3;
        this.jButton4 = jButton4;
        this.jButton5 = jButton5;
        this.jLabel10 = jLabel10;
        this.jLabel12 = jLabel12;
        this.jLabel14 = jLabel14;
        this.jLabel3 = jLabel3;
        this.jLabel9 = jLabel9;
        this.jMenu1 = jMenu1;
        this.jMenu2 = jMenu2;
        this.jMenu3 = jMenu3;
        this.jMenu4 = jMenu4;
        this.jMenuBar1 = jMenuBar1;
        this.jPanel1 = jPanel1;
        this.jPanel14 = jPanel14;
        this.jScrollPane3 = jScrollPane3;
        this.loaitiencong = loaitiencong;
        this.panel1 = panel1;
        this.scrollPane1 = scrollPane1;
        this.solan = solan;
        this.soluong = soluong;
        this.vattuphutung = vattuphutung;
    }
    
    public int DeleteSuaChua() {
        Connection conn;
        PreparedStatement st;
        ResultSet rs;
        try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            java.util.Date utilStartDate = NgaySuaChua.getDate();
            java.sql.Date date = new java.sql.Date(utilStartDate.getTime());
            String sql = "CALL 	P_DelRepairList(?,?,?,?,?,?,?,?,?)";
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
    
    public void UpdateSuaChua(){
    Connection conn;
        PreparedStatement st;
        String sql;
        try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            sql = "CALL P_UpdatePSC(?,?,?,?,?,?,?,?,?)";
            st = conn.prepareCall(sql);
            java.util.Date utilStartDate = NgaySuaChua.getDate();
            java.sql.Date date = new java.sql.Date(utilStartDate.getTime());
            st.setString(1, getSelectedValue(BienSoXe));
            st.setDate(2, date);
            st.setString(3, getSelectedValue(vattuphutung));
            st.setFloat(4, getIntValueFromTextField(soluong));
            st.setFloat(5, getFloatValueFromTextField(giaPT));
            st.setString(6, getSelectedValue(loaitiencong));
            st.setString(7, solan.getText());
            st.setFloat(8, getFloatValueFromTextField(giaTC));
            st.setString(9, NoidungSC.getText());
            st.executeUpdate();
            JOptionPane.showMessageDialog(null, "Data updated succesfully");
        } catch (SQLException | HeadlessException ex) {
            JOptionPane.showMessageDialog(null, ex);
        }
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
    
    private void updateComboBoxVTPT()
    {
        Connection conn; 
       
        try {     
            conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            String sql = "Select * from vattuphutung";
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while(rs.next())
            {
                vattuphutung.addItem(rs.getString("TenVTPT"));
            }
        } catch (Exception e) {
        }
    }
    
    private void updateComboBoxTC()
    {
        Connection conn; 
       
        try {     
            conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            String sql = "Select * from tiencong";
            PreparedStatement st = conn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while(rs.next())
            {
                loaitiencong.addItem(rs.getString("TenTC"));
            }
        } catch (Exception e) {
        }
    }
    
    private void updateComboBoxBSX()
    {
        Connection conn; 
       
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
    
    public RepairGUI(){
        initComponents();
        Repair_List.getColumnModel().getColumn(5).setCellRenderer(new TableActionCellRender());
    }
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        scrollPane1 = new java.awt.ScrollPane();
        jPanel1 = new javax.swing.JPanel();
        panel1 = new java.awt.Panel();
        jLabel14 = new javax.swing.JLabel();
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
        test = new javax.swing.JTextField();
        BienSoXe = new javax.swing.JComboBox<>();
        jMenuBar1 = new javax.swing.JMenuBar();
        jMenu1 = new javax.swing.JMenu();
        jMenu2 = new javax.swing.JMenu();
        jMenu3 = new javax.swing.JMenu();
        jMenu4 = new javax.swing.JMenu();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setUndecorated(true);
        setResizable(false);

        jPanel1.setBackground(new java.awt.Color(204, 204, 204));

        panel1.setBackground(new java.awt.Color(159, 182, 205));

        jLabel14.setFont(new java.awt.Font("Segoe UI", 1, 24)); // NOI18N
        jLabel14.setForeground(new java.awt.Color(255, 255, 255));
        jLabel14.setText("Phiếu sửa chữa");

        javax.swing.GroupLayout panel1Layout = new javax.swing.GroupLayout(panel1);
        panel1.setLayout(panel1Layout);
        panel1Layout.setHorizontalGroup(
            panel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(panel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel14)
                .addContainerGap(87, Short.MAX_VALUE))
        );
        panel1Layout.setVerticalGroup(
            panel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jLabel14, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 41, Short.MAX_VALUE)
        );

        jPanel14.setBackground(new java.awt.Color(130, 130, 130));

        jButton4.setBackground(new java.awt.Color(159, 182, 205));
        jButton4.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        jButton4.setText("Tìm kiếm");
        jButton4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton4ActionPerformed(evt);
            }
        });

        jButton1.setBackground(new java.awt.Color(159, 182, 205));
        jButton1.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        jButton1.setText("Thêm");
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        jButton5.setBackground(new java.awt.Color(159, 182, 205));
        jButton5.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        jButton5.setText("Sửa");
        jButton5.setToolTipText("");
        jButton5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton5ActionPerformed(evt);
            }
        });

        jButton3.setBackground(new java.awt.Color(159, 182, 205));
        jButton3.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        jButton3.setText("Xóa");
        jButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton3ActionPerformed(evt);
            }
        });

        jLabel3.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jLabel3.setForeground(new java.awt.Color(255, 255, 255));
        jLabel3.setText("Biển số xe:");

        jLabel9.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jLabel9.setForeground(new java.awt.Color(255, 255, 255));
        jLabel9.setText("Ngày sửa chữa:");

        jLabel10.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jLabel10.setForeground(new java.awt.Color(255, 255, 255));
        jLabel10.setText("Vật tư phụ tùng:");

        vattuphutung.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        vattuphutung.setModel(new javax.swing.DefaultComboBoxModel<>(new String[] { " " }));
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

        giaTC.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        giaTC.setForeground(new java.awt.Color(204, 204, 204));
        giaTC.setText("Giá TC");
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

        jLabel12.setFont(new java.awt.Font("sansserif", 1, 14)); // NOI18N
        jLabel12.setForeground(new java.awt.Color(255, 255, 255));
        jLabel12.setText("Tiền công:");

        Repair_List.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        Repair_List.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {

            },
            new String [] {
                "Biển số xe", "Ngày sửa chữa", "Nội dung", "Tên phụ tùng", "Số lượng", "Tên tiền công", "Số lần", "Thành tiền"
            }
        ) {
            boolean[] canEdit = new boolean [] {
                false, false, false, false, false, false, false, false
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
        loaitiencong.setModel(new javax.swing.DefaultComboBoxModel<>(new String[] { " " }));
        loaitiencong.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                loaitiencongItemStateChanged(evt);
            }
        });

        solan.setFont(new java.awt.Font("sansserif", 0, 14)); // NOI18N
        solan.setForeground(new java.awt.Color(204, 204, 204));
        solan.setText("SL");
        solan.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusGained(java.awt.event.FocusEvent evt) {
                solanFocusGained(evt);
            }
            public void focusLost(java.awt.event.FocusEvent evt) {
                solanFocusLost(evt);
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

        test.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusGained(java.awt.event.FocusEvent evt) {
                testFocusGained(evt);
            }
        });

        BienSoXe.setModel(new javax.swing.DefaultComboBoxModel<>(new String[] { " " }));

        javax.swing.GroupLayout jPanel14Layout = new javax.swing.GroupLayout(jPanel14);
        jPanel14.setLayout(jPanel14Layout);
        jPanel14Layout.setHorizontalGroup(
            jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane3)
            .addGroup(jPanel14Layout.createSequentialGroup()
                .addGap(32, 32, 32)
                .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel9)
                    .addComponent(jLabel3)
                    .addComponent(jLabel10)
                    .addComponent(jLabel12))
                .addGap(22, 22, 22)
                .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(NgaySuaChua, javax.swing.GroupLayout.PREFERRED_SIZE, 344, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel14Layout.createSequentialGroup()
                        .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 141, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(66, 66, 66)
                        .addComponent(jButton5, javax.swing.GroupLayout.PREFERRED_SIZE, 141, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel14Layout.createSequentialGroup()
                        .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(loaitiencong, javax.swing.GroupLayout.PREFERRED_SIZE, 199, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(vattuphutung, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 199, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(solan)
                            .addComponent(soluong, javax.swing.GroupLayout.PREFERRED_SIZE, 141, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addComponent(BienSoXe, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                    .addComponent(giaPT)
                    .addComponent(jButton4, javax.swing.GroupLayout.DEFAULT_SIZE, 128, Short.MAX_VALUE)
                    .addComponent(giaTC))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(NoidungSC, javax.swing.GroupLayout.PREFERRED_SIZE, 305, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButton3, javax.swing.GroupLayout.PREFERRED_SIZE, 141, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(test, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );
        jPanel14Layout.setVerticalGroup(
            jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel14Layout.createSequentialGroup()
                .addGap(11, 11, 11)
                .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
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
                        .addGap(17, 17, 17)
                        .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(vattuphutung, javax.swing.GroupLayout.PREFERRED_SIZE, 32, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(soluong, javax.swing.GroupLayout.PREFERRED_SIZE, 34, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel10)
                                .addComponent(giaPT, javax.swing.GroupLayout.PREFERRED_SIZE, 34, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGap(6, 6, 6)
                        .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(loaitiencong, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 31, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(giaTC, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel12)
                                .addComponent(solan, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                    .addComponent(NoidungSC))
                .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel14Layout.createSequentialGroup()
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 34, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButton5, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButton3, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED))
                    .addGroup(jPanel14Layout.createSequentialGroup()
                        .addGap(27, 27, 27)
                        .addComponent(test, javax.swing.GroupLayout.PREFERRED_SIZE, 19, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                .addComponent(jScrollPane3, javax.swing.GroupLayout.PREFERRED_SIZE, 286, javax.swing.GroupLayout.PREFERRED_SIZE))
        );

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(panel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jPanel14, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(panel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel14, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
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

        jMenu2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Images/refresh.png"))); // NOI18N
        jMenu2.setText("Làm mới");
        jMenu2.setFont(new java.awt.Font("Segoe UI", 0, 18)); // NOI18N
        jMenu2.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jMenu2MouseClicked(evt);
            }
        });
        jMenuBar1.add(jMenu2);

        jMenu3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/Images/printing.png"))); // NOI18N
        jMenu3.setText("In Phiếu Sửa Chữa");
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
        jMenuBar1.add(jMenu4);

        setJMenuBar(jMenuBar1);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents
    
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
    
    private void Repair_ListMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_Repair_ListMouseClicked
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/garage_final", "root", "");
            DefaultTableModel model = (DefaultTableModel) Repair_List.getModel();
            int selectedrowindex = Repair_List.getSelectedRow();
            BienSoXe.setSelectedItem(model.getValueAt(selectedrowindex, 0).toString());
            Date date = new SimpleDateFormat("yyyy-MM-dd").parse((String)model.getValueAt(selectedrowindex, 1));
            NgaySuaChua.setDate(date);
            NoidungSC.setText(model.getValueAt(selectedrowindex, 2).toString());
            NoidungSC.setForeground(new Color(0,0,0));
            vattuphutung.setSelectedItem(model.getValueAt(selectedrowindex, 3).toString());
            soluong.setText(model.getValueAt(selectedrowindex, 4).toString());
            soluong.setForeground(new Color(0,0,0));
            loaitiencong.setSelectedItem(model.getValueAt(selectedrowindex, 5).toString());
            solan.setText(model.getValueAt(selectedrowindex, 6).toString());
            solan.setForeground(new Color(0,0,0));
            java.util.Date utilStartDate = NgaySuaChua.getDate();
            java.sql.Date date2 = new java.sql.Date(utilStartDate.getTime());
            
            String sql = "CALL P_ClickedForPrice(?,?,?,?)";
            PreparedStatement st = conn.prepareStatement(sql);
            st.setString(1, getSelectedValue(BienSoXe));
            st.setDate(2, date2); 
            st.setString(3, getSelectedValue(vattuphutung));
            st.setString(4, getSelectedValue(loaitiencong));
            ResultSet rs = st.executeQuery();
            while (rs.next())
            {
                /*vattuphutung.setSelectedIndex(rs.getInt("ImportID"));
                loaitiencong.setSelectedIndex(rs.getInt("ImportID"));
                soluong.setText(Integer.toString(rs.getInt("PartsAmount")));
                solan.setText(rs.getString("WageName"))*/
                giaPT.setText(rs.getString("DonGia"));
                giaPT.setForeground(new Color(0,0,0));
                giaTC.setText(rs.getString("GiaTien"));
                giaTC.setForeground(new Color(0,0,0));
            }
        } catch (ParseException | SQLException ex) {
            Logger.getLogger(RepairGUI.class.getName()).log(Level.SEVERE, null, ex);
        }
    }//GEN-LAST:event_Repair_ListMouseClicked

    private void Repair_ListComponentAdded(java.awt.event.ContainerEvent evt) {//GEN-FIRST:event_Repair_ListComponentAdded

    }//GEN-LAST:event_Repair_ListComponentAdded

    private void jMenu1MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jMenu1MouseClicked
               if(!dtoUserLogin.equals(null)){
            HomeGUI home = new HomeGUI(dtoUserLogin);
            this.dispose();
        }
    }//GEN-LAST:event_jMenu1MouseClicked

    private void jMenu4MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jMenu4MouseClicked
                this.dispose();
    }//GEN-LAST:event_jMenu4MouseClicked

    private void giaPTActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_giaPTActionPerformed

    }//GEN-LAST:event_giaPTActionPerformed

    private void giaPTFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_giaPTFocusLost
        if(giaPT.getText().equals(""))
        {
            giaPT.setText("Giá PT");
            giaPT.setForeground(new Color(204, 204, 204));
        }
    }//GEN-LAST:event_giaPTFocusLost

    private void giaPTFocusGained(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_giaPTFocusGained
        if(giaPT.getText().equals("Giá PT"))
        {
            giaPT.setText("");
            giaPT.setForeground(new Color(0,0,0));
        }
    }//GEN-LAST:event_giaPTFocusGained

    private void giaTCFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_giaTCFocusLost
        if(giaTC.getText().equals(""))
        {
            giaTC.setText("Giá TC");
            giaTC.setForeground(new Color(204, 204, 204));
        }
    }//GEN-LAST:event_giaTCFocusLost

    private void giaTCFocusGained(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_giaTCFocusGained
        if(giaTC.getText().equals("Giá TC"))
        {
            giaTC.setText("");
            giaTC.setForeground(new Color(0,0,0));
        }
    }//GEN-LAST:event_giaTCFocusGained

    private void soluongActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_soluongActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_soluongActionPerformed

    private void soluongFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_soluongFocusLost
        if(soluong.getText().equals(""))
        {
            soluong.setText("SL");
            soluong.setForeground(new Color(204, 204, 204));
        }
    }//GEN-LAST:event_soluongFocusLost

    private void soluongFocusGained(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_soluongFocusGained
        if(soluong.getText().equals("SL"))
        {
            soluong.setText("");
            soluong.setForeground(new Color(0,0,0));
        }
    }//GEN-LAST:event_soluongFocusGained

    private void vattuphutungActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_vattuphutungActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_vattuphutungActionPerformed

    private void jButton3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton3ActionPerformed
        DeleteSuaChua();
        ConnectDB();
    }//GEN-LAST:event_jButton3ActionPerformed

    private void jButton5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton5ActionPerformed
        
        strFind = getSelectedValue(BienSoXe);
        String strNoiDungSC = NoidungSC.getText();
        java.util.Date utilStartDate = NgaySuaChua.getDate();
        java.sql.Date date = new java.sql.Date(utilStartDate.getTime());
        
        if (!checkValidationForm()){
        JOptionPane.showMessageDialog(this, "Bạn chưa nhập đầy đủ thông tin!");
            }
                    
        else if (checkOverwritten(strFind, date ,strNoiDungSC) > 0)
        {
            JOptionPane.showMessageDialog(this, "Bạn không được phép sửa trùng thông tin với Biển số xe, ngáy sửa chữa và nội dung sửa chữa");
        }
        
        else {
            UpdateSuaChua();
            updateTableData();
            ConnectDB();
        }
    }//GEN-LAST:event_jButton5ActionPerformed

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
            JOptionPane.showMessageDialog(this, "Bạn không được phép nhập trùng thông tin với Biển số xe, ngáy sửa chữa và nội dung sửa chữa");
        }
        else {
            insertSuaChua();
            ConnectDB();
        }   
    }//GEN-LAST:event_jButton1ActionPerformed

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

    private void jMenu2MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jMenu2MouseClicked
                ConnectDB();
        resetForm();        // TODO add your handling code here:
    }//GEN-LAST:event_jMenu2MouseClicked

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

    private void testFocusGained(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_testFocusGained
        // TODO add your handling code here:
    }//GEN-LAST:event_testFocusGained
    
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
    
    public String getSelectedValue(JComboBox comboBox) {
    Object selectedItem = comboBox.getSelectedItem();
    if (selectedItem != null) {
        String selectedValue = selectedItem.toString();
        return selectedValue;
    } else {
        return null;
    }
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
            
    /**
     * @param args the command line arguments
     */
//    public static void main(String args[]) {
//        /* Set the Nimbus look and feel */
//        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
//        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
//         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
//         */
//        try {
//            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
//                if ("Nimbus".equals(info.getName())) {
//                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
//                    break;
//                }
//            }
//        } catch (ClassNotFoundException ex) {
//            java.util.logging.Logger.getLogger(RepairGUI.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
//        } catch (InstantiationException ex) {
//            java.util.logging.Logger.getLogger(RepairGUI.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
//        } catch (IllegalAccessException ex) {
//            java.util.logging.Logger.getLogger(RepairGUI.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
//        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
//            java.util.logging.Logger.getLogger(RepairGUI.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
//        }
//        //</editor-fold>
//
//        /* Create and display the form */
//        java.awt.EventQueue.invokeLater(new Runnable() {
//            public void run() {
//                new RepairGUI().setVisible(true);
//            }
//        });
//    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JComboBox<String> BienSoXe;
    private com.toedter.calendar.JDateChooser NgaySuaChua;
    private javax.swing.JTextField NoidungSC;
    private javax.swing.JTable Repair_List;
    private javax.swing.JTextField giaPT;
    private javax.swing.JTextField giaTC;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton3;
    private javax.swing.JButton jButton4;
    private javax.swing.JButton jButton5;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel14;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JMenu jMenu1;
    private javax.swing.JMenu jMenu2;
    private javax.swing.JMenu jMenu3;
    private javax.swing.JMenu jMenu4;
    private javax.swing.JMenuBar jMenuBar1;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel14;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JComboBox<String> loaitiencong;
    private java.awt.Panel panel1;
    private java.awt.ScrollPane scrollPane1;
    private javax.swing.JTextField solan;
    private javax.swing.JTextField soluong;
    private javax.swing.JTextField test;
    private javax.swing.JComboBox<String> vattuphutung;
    // End of variables declaration//GEN-END:variables

    
}
        

