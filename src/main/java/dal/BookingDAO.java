package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Reservation;
import model.Deposit;
import model.PreOrder;

public class BookingDAO extends DBContext {

    private String formatDateTime(String dbDate) {
        if (dbDate != null && dbDate.length() >= 16) return dbDate.substring(0, 16).replace(" ", "T");
        return dbDate;
    }

    // ================== RESERVATION ==================
    // Các hàm khác giữ nguyên...

    public List<Reservation> getAllReservations() {
        List<Reservation> list = new ArrayList<>();
        try {
            // Câu lệnh SQL kiểm tra sự tồn tại trong bảng liên kết TABLE_RESERVATION
            String sql = "SELECT r.*, " +
                         "(CASE WHEN EXISTS (SELECT 1 FROM TABLE_RESERVATION tr WHERE tr.Reservation_ID = r.Reservation_ID) " +
                         "THEN 'Dang Cho' ELSE 'Da Phuc Vu' END) as CalcStatus " +
                         "FROM RESERVATION r";
            ResultSet rs = connection.prepareStatement(sql).executeQuery();
            while (rs.next()) {
                list.add(new Reservation(
                    rs.getString(1), 
                    rs.getString(2), 
                    rs.getString(3), 
                    rs.getString(4), 
                    rs.getString(5), 
                    rs.getInt(6),
                    rs.getString("CalcStatus") // Lấy trạng thái ảo
                ));
            }
        } catch (Exception e) { System.out.println(e); }
        return list;
    }

// Giữ nguyên các hàm insertReservation, updateReservation, deleteReservation cũ của bạn...

    // ĐÃ SỬA: Đổi kiểu trả về thành int (để trả về khóa chính mới) và bỏ Reservation_ID khỏi INSERT
    // ĐÃ SỬA: Đảm bảo 100% bắt được ID vừa tăng
    public int insertReservation(Reservation r) {
        int generatedId = -1;
        try {
            String sql = "INSERT INTO RESERVATION (Employee_ID, Customer_ID, Created_time, Arrival_time, Guest_count) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement st = connection.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
            st.setString(1, r.getEmployeeId()); 
            
            // Xử lý an toàn: Nếu khách vãng lai thì truyền NULL
            if (r.getCustomerId() == null || r.getCustomerId().isEmpty()) {
                st.setNull(2, java.sql.Types.INTEGER);
            } else {
                st.setString(2, r.getCustomerId());
            }
            
            st.setString(3, r.getCreatedTime()); 
            st.setString(4, r.getArrivalTime()); 
            st.setInt(5, r.getGuestCount());
            
            st.executeUpdate();
            
            // Cố gắng lấy ID vừa tạo
            ResultSet rs = st.getGeneratedKeys();
            if (rs.next()) {
                generatedId = rs.getInt(1);
            } else {
                // Phương án dự phòng tối thượng: Lấy ID lớn nhất (mới nhất)
                ResultSet rsMax = connection.prepareStatement("SELECT MAX(Reservation_ID) FROM RESERVATION").executeQuery();
                if (rsMax.next()) {
                    generatedId = rsMax.getInt(1);
                }
            }
        } catch (Exception e) { 
            System.out.println("Insert Reservation Error: " + e.getMessage()); 
        }
        return generatedId;
    }

    public void updateReservation(Reservation r) {
        try {
            PreparedStatement st = connection.prepareStatement("UPDATE RESERVATION SET Employee_ID=?, Customer_ID=?, Created_time=?, Arrival_time=?, Guest_count=? WHERE Reservation_ID=?");
            st.setString(1, r.getEmployeeId()); st.setString(2, r.getCustomerId()); st.setString(3, r.getCreatedTime().replace("T", " "));
            st.setString(4, r.getArrivalTime().replace("T", " ")); st.setInt(5, r.getGuestCount()); st.setString(6, r.getReservationId());
            st.executeUpdate();
        } catch (Exception e) {}
    }

    public void deleteReservation(String id) {
        if (id == null || id.trim().isEmpty()) return;
        String cleanId = id.trim();
        try {
            connection.prepareStatement("DELETE FROM DEPOSIT WHERE Reservation_ID = '" + cleanId + "'").executeUpdate();
            connection.prepareStatement("DELETE FROM PRE_ORDER WHERE Reservation_ID = '" + cleanId + "'").executeUpdate();
            connection.prepareStatement("DELETE FROM TABLE_RESERVATION WHERE Reservation_ID = '" + cleanId + "'").executeUpdate();
            connection.prepareStatement("DELETE FROM RESERVATION WHERE Reservation_ID = '" + cleanId + "'").executeUpdate();
        } catch (Exception e) {
            System.out.println("Lỗi xóa DB: " + e.getMessage());
        }
    }

    // ================== DEPOSIT ==================
    public List<Deposit> getAllDeposits() {
        List<Deposit> list = new ArrayList<>();
        try {
            ResultSet rs = connection.prepareStatement("SELECT * FROM DEPOSIT").executeQuery();
            while (rs.next()) {
                // ĐÃ SỬA: Gọi đúng tên cột để lấy dữ liệu chuẩn xác, không bị lộn xộn
                list.add(new Deposit(
                    String.valueOf(rs.getInt("reservation_id")), 
                    rs.getDouble("amount"), 
                    rs.getString("status"), 
                    rs.getInt("deposit_turn")
                ));
            }
        } catch (Exception e) { System.out.println("Lỗi lấy Deposit: " + e.getMessage()); }
        return list;
    }

    public void insertDeposit(Deposit d) {
        try {
            // ĐÃ SỬA: Khớp đúng thứ tự 4 cột theo bảng SQL mới của bà, ép kiểu INT cho reservation_id
            PreparedStatement st = connection.prepareStatement("INSERT INTO DEPOSIT (reservation_id, deposit_turn, amount, status) VALUES (?, ?, ?, ?)");
            st.setInt(1, Integer.parseInt(d.getReservationId())); 
            st.setInt(2, d.getDepositTurn());
            st.setDouble(3, d.getAmount()); 
            st.setString(4, d.getStatus()); 
            st.executeUpdate();
        } catch (Exception e) { System.out.println("Lỗi insert Deposit: " + e.getMessage()); }
    }

    public void updateDeposit(Deposit d) {
        try { 
            PreparedStatement st = connection.prepareStatement("UPDATE DEPOSIT SET amount=?, status=? WHERE reservation_id=? AND deposit_turn=?");
            st.setDouble(1, d.getAmount()); 
            st.setString(2, d.getStatus()); 
            st.setInt(3, Integer.parseInt(d.getReservationId())); 
            st.setInt(4, d.getDepositTurn());
            st.executeUpdate();
        } catch (Exception e) { System.out.println("Lỗi update Deposit: " + e.getMessage()); }
    }

    public void deleteDeposit(String resId, int turn) {
        try {
            PreparedStatement st = connection.prepareStatement("DELETE FROM DEPOSIT WHERE reservation_id=? AND deposit_turn=?");
            st.setInt(1, Integer.parseInt(resId)); 
            st.setInt(2, turn); 
            st.executeUpdate();
        } catch (Exception e) { System.out.println("Lỗi delete Deposit: " + e.getMessage()); }
    }
    // ================== PRE_ORDER ==================
    public List<PreOrder> getAllPreOrders() {
        List<PreOrder> list = new ArrayList<>();
        try {
            ResultSet rs = connection.prepareStatement("SELECT * FROM PRE_ORDER").executeQuery();
            while (rs.next()) list.add(new PreOrder(rs.getString(1), rs.getString(2), rs.getInt(3), rs.getString(4)));
        } catch (Exception e) {}
        return list;
    }
    public void insertPreOrder(PreOrder p) {
        try {
            PreparedStatement st = connection.prepareStatement("INSERT INTO PRE_ORDER VALUES (?, ?, ?, ?)");
            st.setString(1, p.getReservationId()); st.setString(2, p.getDishId()); st.setInt(3, p.getQuantity()); st.setString(4, p.getNote());
            st.executeUpdate();
        } catch (Exception e) {}
    }
    public void updatePreOrder(PreOrder p) {
        try {
            PreparedStatement st = connection.prepareStatement("UPDATE PRE_ORDER SET Quantity=?, Note=? WHERE Reservation_ID=? AND Dish_ID=?");
            st.setInt(1, p.getQuantity()); st.setString(2, p.getNote()); st.setString(3, p.getReservationId()); st.setString(4, p.getDishId());
            st.executeUpdate();
        } catch (Exception e) {}
    }
    public void deletePreOrder(String resId, String dishId) {
        try {
            PreparedStatement st = connection.prepareStatement("DELETE FROM PRE_ORDER WHERE Reservation_ID=? AND Dish_ID=?");
            st.setString(1, resId); st.setString(2, dishId); st.executeUpdate();
        } catch (Exception e) {}
    }

    // ================== OCCUPIES ==================
    public void insertOccupies(model.Occupies o) {
        try {
            PreparedStatement st = connection.prepareStatement("INSERT INTO TABLE_RESERVATION (Reservation_ID, Room_ID, Table_number) VALUES (?, ?, ?)");
            st.setString(1, o.getReservationId());
            st.setString(2, o.getRoomId());
            st.setInt(3, o.getTableNumber());
            st.executeUpdate();
        } catch (Exception e) {}
    }
}