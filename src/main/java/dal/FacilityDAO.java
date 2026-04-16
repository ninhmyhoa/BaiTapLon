package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Customer;
import model.Room;
import model.DiningTable;

public class FacilityDAO extends DBContext {

    // ================== CUSTOMER ==================
public List<Customer> getAllCustomers() {
        List<Customer> list = new ArrayList<>();
        try {
            // Lấy từ CSDL và tự động gộp last_name + first_name thành fullName
            ResultSet rs = connection.prepareStatement("SELECT * FROM CUSTOMER ORDER BY customer_id DESC").executeQuery();
            while (rs.next()) {
                String fName = rs.getString("first_name");
                String lName = rs.getString("last_name");
                String fullName = (lName != null ? lName : "") + " " + (fName != null ? fName : "");
                
                list.add(new Customer(
                    rs.getString("customer_id"), 
                    fullName.trim(), 
                    rs.getString("phone"), 
                    rs.getString("email")
                ));
            }
        } catch (Exception e) { 
            System.out.println("======> LỖI KÉO DS KHÁCH HÀNG: " + e.getMessage()); 
        }
        return list;
    }

    public void insertCustomer(Customer c) {
        try {
            // Thuật toán tách chuỗi fullName thành first_name và last_name
            String fullName = c.getFullName().trim();
            String firstName = fullName;
            String lastName = "";
            int lastSpace = fullName.lastIndexOf(" ");
            if (lastSpace != -1) {
                lastName = fullName.substring(0, lastSpace);
                firstName = fullName.substring(lastSpace + 1);
            }

            // ĐÃ SỬA: Dùng đúng tên cột first_name, last_name, phone, email như trong DB
            PreparedStatement st = connection.prepareStatement("INSERT INTO CUSTOMER (first_name, last_name, phone, email) VALUES (?, ?, ?, ?)");
            st.setString(1, firstName); 
            st.setString(2, lastName); 
            st.setString(3, c.getPhone()); 
            st.setString(4, c.getEmail());
            st.executeUpdate();
            System.out.println("======> THÊM KHÁCH HÀNG THÀNH CÔNG!");
        } catch (Exception e) { 
            System.out.println("======> LỖI THÊM KHÁCH HÀNG: " + e.getMessage()); 
        }
    }

    public void updateCustomer(Customer c) {
        try {
            // Tách chuỗi tương tự như hàm Insert
            String fullName = c.getFullName().trim();
            String firstName = fullName;
            String lastName = "";
            int lastSpace = fullName.lastIndexOf(" ");
            if (lastSpace != -1) {
                lastName = fullName.substring(0, lastSpace);
                firstName = fullName.substring(lastSpace + 1);
            }

            PreparedStatement st = connection.prepareStatement("UPDATE CUSTOMER SET first_name=?, last_name=?, phone=?, email=? WHERE customer_id=?");
            st.setString(1, firstName); 
            st.setString(2, lastName); 
            st.setString(3, c.getPhone()); 
            st.setString(4, c.getEmail()); 
            st.setString(5, c.getCustomerId());
            st.executeUpdate();
        } catch (Exception e) { 
            System.out.println("======> LỖI CẬP NHẬT KHÁCH HÀNG: " + e.getMessage()); 
        }
    }

    public void deleteCustomer(String id) {
        try {
            PreparedStatement st = connection.prepareStatement("DELETE FROM CUSTOMER WHERE customer_id=?");
            st.setString(1, id); 
            st.executeUpdate();
        } catch (Exception e) { 
            System.out.println("======> LỖI XÓA KHÁCH HÀNG: " + e.getMessage()); 
        }
    }
    // ================== ROOM ==================
    // ================== ROOM ==================
    public List<Room> getAllRooms() {
        List<Room> list = new ArrayList<>();
        try {
            java.sql.ResultSet rs = connection.prepareStatement("SELECT * FROM ROOM").executeQuery();
            while (rs.next()) {
                // CHÚ Ý: Đảm bảo 2 chữ Room_ID và Max_capacity khớp chính xác với tên cột trong MySQL của bà nha!
                list.add(new Room(
                    rs.getString("Room_ID"), 
                    rs.getInt("Max_capacity") 
                ));
            }
        } catch (Exception e) { 
            // IN LỖI RA ĐỂ BẮT TẬN TAY
            System.out.println("======> LỖI KÉO DỮ LIỆU PHÒNG: " + e.getMessage());
            e.printStackTrace(); 
        }
        return list;
    }

    public void insertRoom(Room r) {
        try {
            PreparedStatement st = connection.prepareStatement("INSERT INTO ROOM VALUES (?, ?)");
            st.setString(1, r.getRoomId()); st.setInt(2, r.getMaxCapacity()); st.executeUpdate();
        } catch (Exception e) { System.out.println(e); }
    }

    public void updateRoom(Room r) {
        try {
            PreparedStatement st = connection.prepareStatement("UPDATE ROOM SET Max_capicity=? WHERE Room_ID=?");
            st.setInt(1, r.getMaxCapacity()); st.setString(2, r.getRoomId()); st.executeUpdate();
        } catch (Exception e) { System.out.println(e); }
    }

    public void deleteRoom(String id) {
        try {
            PreparedStatement st = connection.prepareStatement("DELETE FROM ROOM WHERE Room_ID=?");
            st.setString(1, id); st.executeUpdate();
        } catch (Exception e) { System.out.println(e); }
    }

    // ================== DINING TABLE ==================
    public List<DiningTable> getAllTables() {
        List<DiningTable> list = new ArrayList<>();
        try {
            ResultSet rs = connection.prepareStatement("SELECT * FROM DINING_TABLE").executeQuery();
            while (rs.next()) {
                // Đã sửa: Khởi tạo đối tượng chỉ với 3 tham số (bỏ Reservation_ID)
                list.add(new DiningTable(rs.getString("Room_ID"), rs.getInt("Table_number"), rs.getString("Status")));
            }
        } catch (Exception e) { System.out.println(e); }
        return list;
    }

public void insertTable(DiningTable t) {
    try {
        String sql = "INSERT INTO DINING_TABLE (Room_ID, Table_number, Status) VALUES (?, ?, ?)";
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, t.getRoomId());
        st.setInt(2, t.getTableNumber());
        
        // NẾU TRẠNG THÁI TRỐNG HOẶC NULL THÌ MẶC ĐỊNH LÀ 'Trống'
        if (t.getStatus() == null || t.getStatus().trim().isEmpty()) {
            st.setString(3, "Trống");
        } else {
            st.setString(3, t.getStatus());
        }
        st.executeUpdate();
    } catch (Exception e) {
        System.out.println(e);
    }
}

    public void updateTable(DiningTable t) {
        try {
            // Đã sửa: Chỉ update Status, bỏ Reservation_ID
            PreparedStatement st = connection.prepareStatement("UPDATE DINING_TABLE SET Status=? WHERE Room_ID=? AND Table_number=?");
            st.setString(1, t.getStatus()); 
            st.setString(2, t.getRoomId()); 
            st.setInt(3, t.getTableNumber());
            st.executeUpdate();
        } catch (Exception e) { 
            System.out.println("Lỗi Sửa Bàn: " + e); 
        }
    }

    public void deleteTable(String roomId, int tableNumber) {
        try {
            PreparedStatement st = connection.prepareStatement("DELETE FROM DINING_TABLE WHERE Room_ID=? AND Table_number=?");
            st.setString(1, roomId); st.setInt(2, tableNumber); st.executeUpdate();
        } catch (Exception e) { System.out.println(e); }
    }
   /* public DiningTable getTableByInvoice(int invoiceId) {
    // Câu lệnh này tìm thông tin bàn dựa trên hóa đơn. 
    // Lưu ý: Tên cột (Room_ID, Table_number) phải khớp với DB của bạn
        String sql = "SELECT Room_ID, Table_number FROM INVOICE WHERE Invoice_ID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, invoiceId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                // Trả về đối tượng bàn để Servlet sử dụng
                return new DiningTable(rs.getString("Room_ID"), rs.getInt("Table_number"), "");
            }
        } catch (Exception e) {
            System.out.println("Lỗi getTableByInvoice: " + e);
        }
        return null;
    }*/
    // ================== THÊM HÀM LẤY GIỜ ĐẶT BÀN ==================
    // ================== THÊM HÀM LẤY GIỜ ĐẶT BÀN ==================
    public java.util.HashMap<String, String> getUpcomingReservations() {
        java.util.HashMap<String, String> map = new java.util.HashMap<>();
        
        String sql = "SELECT o.Room_ID, o.Table_number, r.Arrival_time " +
                     "FROM RESERVATION r " +
                     "JOIN TABLE_RESERVATION o ON r.Reservation_ID = o.Reservation_ID " +
                     "WHERE r.Arrival_time != r.Created_time " +
                     "ORDER BY r.Arrival_time ASC";
        try {
            java.sql.PreparedStatement st = connection.prepareStatement(sql);
            java.sql.ResultSet rs = st.executeQuery();
            
            while (rs.next()) {
                // ĐÃ SỬA: Thêm .trim() để gọt sạch sẽ khoảng trắng từ Database
                String key = rs.getString("Room_ID").trim() + "-" + rs.getInt("Table_number");
                String rawTime = rs.getString("Arrival_time"); 
                
                if (rawTime != null && rawTime.length() >= 16) {
                    String time = rawTime.substring(11, 16); 
                    String day = rawTime.substring(8, 10);   
                    String month = rawTime.substring(5, 7);  
                    
                    String displayMsg = time + " (" + day + "/" + month + ")";
                    
                    if (!map.containsKey(key)) {
                        map.put(key, displayMsg);
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi getUpcomingReservations: " + e.getMessage());
        }
        return map;
    }
}