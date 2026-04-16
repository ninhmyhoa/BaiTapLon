package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Employee;

public class EmployeeDAO extends DBContext {

    // 1. Kiểm tra đăng nhập
    public Employee checkLogin(String email, String password) {
        String sql = "SELECT * FROM EMPLOYEE WHERE email = ? AND password = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            st.setString(2, password);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                // Bạn nhớ sửa constructor trong file Employee.java cho khớp các trường này nhé
                return new Employee(
                    rs.getString("employee_id"),
                    rs.getString("first_name"),
                    rs.getString("last_name"),
                    rs.getString("street"),
                    rs.getString("district"),
                    rs.getString("city"),
                    rs.getString("phone"),
                    rs.getString("email"),
                    rs.getString("position"),
                    rs.getString("password")
                );
            }
        } catch (SQLException e) { 
            System.out.println("Login error: " + e.getMessage()); 
        }
        return null;
    }

    // 3. Thêm nhân viên (Sử dụng Transaction để thêm vào cả 2 bảng)
    public void addEmployee(Employee emp) {
        String sqlEmp = "INSERT INTO EMPLOYEE (first_name, last_name, street, district, city, phone, email, position, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            // Tắt auto commit để chạy Transaction (Tránh việc chèn lỗi bảng này mà bảng kia vẫn lưu)
            connection.setAutoCommit(false);

            // Thêm Statement.RETURN_GENERATED_KEYS để lấy ID tự động tăng
            PreparedStatement st = connection.prepareStatement(sqlEmp, Statement.RETURN_GENERATED_KEYS);
            st.setString(1, emp.getFirstName());
            st.setString(2, emp.getLastName());
            st.setString(3, emp.getStreet());
            st.setString(4, emp.getDistrict());
            st.setString(5, emp.getCity());
            st.setString(6, emp.getPhone());
            st.setString(7, emp.getEmail());
            st.setString(8, emp.getPosition());
            st.setString(9, emp.getPassword()); // Đã băm Bcrypt từ Servlet
            st.executeUpdate();

            // Lấy employee_id vừa tạo ra
            ResultSet rs = st.getGeneratedKeys();
            if (rs.next()) {
                int newEmpId = rs.getInt(1);
                String role = emp.getPosition();
                String sqlRole = "";

                // Kiểm tra chức vụ để chèn vào bảng con tương ứng
                if ("Manager".equalsIgnoreCase(role)) {
                    sqlRole = "INSERT INTO MANAGER (employee_id) VALUES (?)";
                } else if ("Chef".equalsIgnoreCase(role)) {
                    sqlRole = "INSERT INTO CHEF (employee_id) VALUES (?)";
                } else if ("Waiter".equalsIgnoreCase(role) || "Cashier".equalsIgnoreCase(role)) {
                    sqlRole = "INSERT INTO WAITER (employee_id) VALUES (?)";
                }

                // Thực thi chèn vào bảng con
                if (!sqlRole.isEmpty()) {
                    PreparedStatement stRole = connection.prepareStatement(sqlRole);
                    stRole.setInt(1, newEmpId);
                    stRole.executeUpdate();
                }
            }
            connection.commit(); // Hoàn tất Transaction
        } catch (SQLException e) { 
            try { connection.rollback(); } catch (SQLException ex) {} // Nếu lỗi thì hoàn tác
            System.out.println("Insert error: " + e.getMessage()); 
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException ex) {}
        }
    }

    // 5. Xóa nhân viên (Phải xóa bảng con trước, bảng cha sau)
    public void deleteEmployee(String id) {
        try {
            connection.setAutoCommit(false); // Bắt đầu Transaction
            int empId = Integer.parseInt(id);

            // Xóa ở các bảng con (Bỏ qua lỗi nếu không tồn tại ở bảng đó)
            connection.prepareStatement("DELETE FROM MANAGER WHERE employee_id=" + empId).executeUpdate();
            connection.prepareStatement("DELETE FROM CHEF WHERE employee_id=" + empId).executeUpdate();
            connection.prepareStatement("DELETE FROM WAITER WHERE employee_id=" + empId).executeUpdate();

            // Cuối cùng mới xóa ở bảng gốc
            PreparedStatement st = connection.prepareStatement("DELETE FROM EMPLOYEE WHERE employee_id=?");
            st.setInt(1, empId);
            st.executeUpdate();

            connection.commit();
        } catch (SQLException e) { 
            try { connection.rollback(); } catch (SQLException ex) {}
            System.out.println("Delete error: " + e.getMessage()); 
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException ex) {}
        }
    }
    // Lấy danh sách tất cả nhân viên (Bổ sung lại cho các Servlet khác dùng)
    public List<Employee> getAllEmployees() {
        List<Employee> list = new ArrayList<>();
        String sql = "SELECT * FROM EMPLOYEE";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Employee(
                    rs.getString("employee_id"),
                    rs.getString("first_name"),
                    rs.getString("last_name"),
                    rs.getString("street"),
                    rs.getString("district"),
                    rs.getString("city"),
                    rs.getString("phone"),
                    rs.getString("email"),
                    rs.getString("position"),
                    rs.getString("password")
                ));
            }
        } catch (SQLException e) { 
            System.out.println("Get all error: " + e.getMessage()); 
        }
        return list;
    }

    // Cập nhật thông tin nhân viên
    public void updateEmployee(Employee emp) {
        String sql = "UPDATE EMPLOYEE SET first_name=?, last_name=?, street=?, district=?, city=?, phone=?, position=?, email=?, password=? WHERE employee_id=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, emp.getFirstName());
            st.setString(2, emp.getLastName());
            st.setString(3, emp.getStreet());
            st.setString(4, emp.getDistrict());
            st.setString(5, emp.getCity());
            st.setString(6, emp.getPhone());
            st.setString(7, emp.getPosition());
            st.setString(8, emp.getEmail());
            st.setString(9, emp.getPassword());
            st.setString(10, emp.getEmployeeId());
            st.executeUpdate();
        } catch (SQLException e) { 
            System.out.println("Update error: " + e.getMessage()); 
        }
    }
}