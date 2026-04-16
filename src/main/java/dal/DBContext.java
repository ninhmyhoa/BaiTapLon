package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    protected Connection connection;

    public DBContext() {
        try {
            // Thay bằng pass MySQL của bà (hồi nãy tui thấy trong file cũ là 241006)
            String user = "root";
            String pass = "241006"; 
            // Đã đổi đúng tên Database chuẩn của mình
            String url = "jdbc:mysql://localhost:3306/quanlynhahang";
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(url, user, pass);
            System.out.println("KẾT NỐI DATABASE THÀNH CÔNG!"); // In ra nếu thành công
            
        } catch (ClassNotFoundException ex) {
            System.out.println("LỖI SỐ 1: BÀ CHƯA BỎ FILE MYSQL-CONNECTOR VÀO THƯ MỤC WEB-INF/lib !");
        } catch (SQLException ex) {
            System.out.println("LỖI SỐ 2: SAI PASSWORD HOẶC CHƯA BẬT XAMPP/MYSQL ! Lỗi chi tiết: " + ex.getMessage());
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