package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    protected Connection connection;

    public DBContext() {
        try {
    String url = "jdbc:mysql://metro.proxy.rlwy.net:34189/railway";
    String user = "root";
    String pass = "JiALDrsIRlvlXCUmJlGXIoosYJLMgggw";
    
    // BẮT BUỘC PHẢI CÓ DÒNG NÀY TRƯỚC KHI GET CONNECTION
    Class.forName("com.mysql.cj.jdbc.Driver"); 
    
    this.connection = DriverManager.getConnection(url, user, pass);
} catch (Exception e) {
    // Đừng để trống phần catch này, hãy in lỗi ra log để biết sai ở đâu
    System.out.println("LỖI KẾT NỐI DB: " + e.getMessage());
    e.printStackTrace();
}
    }
    // Hàm này dùng để đóng ống kết nối
    public void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException ex) {
            System.out.println("Lỗi khi đóng DB: " + ex.getMessage());
        }
    }
}
