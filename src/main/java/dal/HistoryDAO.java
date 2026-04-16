package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.WorkShift;
import model.PriceHistory;
import model.ExportHistory;

public class HistoryDAO extends DBContext {
    
    // Hàm hỗ trợ format ngày giờ từ MySQL (Bỏ đi phần .0 mili giây) để gắn vào HTML
    private String formatDateTime(String dbDate) {
        if (dbDate != null && dbDate.length() >= 16) {
            return dbDate.substring(0, 16).replace(" ", "T");
        }
        return dbDate;
    }

    // ================== WORK_SHIFT ==================
    public List<WorkShift> getAllWorkShifts() {
        List<WorkShift> list = new ArrayList<>();
        try {
            ResultSet rs = connection.prepareStatement("SELECT * FROM WORK_SHIFT").executeQuery();
            while (rs.next()) list.add(new WorkShift(rs.getString("Employee_ID"), formatDateTime(rs.getString("Login_time")), formatDateTime(rs.getString("logout_time"))));
        } catch (Exception e) {}
        return list;
    }
    // Lấy danh sách ca làm của riêng 1 nhân viên
    public List<WorkShift> getWorkShiftsByEmployeeId(String empId) {
        List<WorkShift> list = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement("SELECT * FROM WORK_SHIFT WHERE Employee_ID = ? ORDER BY Login_time DESC");
            st.setString(1, empId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) list.add(new WorkShift(rs.getString("Employee_ID"), formatDateTime(rs.getString("Login_time")), formatDateTime(rs.getString("logout_time"))));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // Nhân viên tự tan ca (Cập nhật giờ ra cho ca làm chưa kết thúc)
    public void clockOutEmployee(String empId, String logoutTime) {
        try {
            // Chỉ cập nhật dòng nào mà logout_time đang rỗng (nghĩa là đang trực)
            PreparedStatement st = connection.prepareStatement("UPDATE WORK_SHIFT SET logout_time=? WHERE Employee_ID=? AND logout_time IS NULL");
            st.setString(1, logoutTime.replace("T", " ")); 
            st.setString(2, empId);
            st.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
    public void insertWorkShift(WorkShift w) {
        try {
            // Chỉ định rõ cột để tránh lệch dữ liệu, xử lý an toàn giá trị null
            PreparedStatement st = connection.prepareStatement("INSERT INTO WORK_SHIFT (employee_id, login_time, logout_time) VALUES (?, ?, ?)");
            st.setString(1, w.getEmployeeId()); 
            st.setString(2, w.getLoginTime().replace("T", " ")); 
            
            // Xử lý chuẩn cho MySQL DATETIME khi giờ ra bị bỏ trống (null)
            if (w.getLogoutTime() != null && !w.getLogoutTime().isEmpty()) {
                st.setString(3, w.getLogoutTime().replace("T", " "));
            } else {
                st.setNull(3, java.sql.Types.TIMESTAMP); 
            }
            st.executeUpdate();
        } catch (Exception e) { 
            System.out.println("Lỗi Insert WorkShift: " + e.getMessage());
            e.printStackTrace(); 
        }
    }
    public void updateWorkShift(WorkShift w) {
        try { // Chỉ cho phép cập nhật giờ logout
            PreparedStatement st = connection.prepareStatement("UPDATE WORK_SHIFT SET logout_time=? WHERE Employee_ID=? AND Login_time=?");
            st.setString(1, w.getLogoutTime().replace("T", " ")); st.setString(2, w.getEmployeeId()); st.setString(3, w.getLoginTime().replace("T", " "));
            st.executeUpdate();
        } catch (Exception e) {}
    }
    public void deleteWorkShift(String empId, String loginTime) {
        try {
            PreparedStatement st = connection.prepareStatement("DELETE FROM WORK_SHIFT WHERE Employee_ID=? AND Login_time=?");
            st.setString(1, empId); st.setString(2, loginTime.replace("T", " ")); st.executeUpdate();
        } catch (Exception e) {}
    }

    // ================== PRICE HISTORY ==================
// ================== PRICE HISTORY ==================
    public List<PriceHistory> getAllPriceHistories() {
        List<PriceHistory> list = new ArrayList<>();
        
        String sql = "SELECT p.Dish_ID, p.Applied_Time, p.Price, p.Employee_ID, " +
                     "d.dish_name, e.first_name, e.last_name " +
                     "FROM PRICE_HISTORY p " +
                     "JOIN DISH d ON p.Dish_ID = d.dish_id " +
                     "JOIN EMPLOYEE e ON p.Employee_ID = e.employee_id " +
                     "ORDER BY p.Applied_Time DESC";
                     
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                String fullName = rs.getString("first_name") + " " + rs.getString("last_name");
                list.add(new PriceHistory(
                    rs.getString("Employee_ID"), 
                    formatDateTime(rs.getString("Applied_Time")), 
                    rs.getString("Dish_ID"), 
                    rs.getDouble("Price"),
                    rs.getString("dish_name"),
                    fullName
                ));
            }
        } catch (Exception e) { 
            System.out.println("LỖI LẤY LỊCH SỬ GIÁ: " + e.getMessage());
            e.printStackTrace(); 
        }
        return list;
    }

    public void insertPriceHistory(PriceHistory h) {
        try {
            String sql1 = "INSERT INTO PRICE_HISTORY (Dish_ID, Applied_Time, Price, Employee_ID) VALUES (?, ?, ?, ?)";
            PreparedStatement st1 = connection.prepareStatement(sql1);
            st1.setString(1, h.getDishId());
            
            // BẮT BUỘC PHẢI CÓ ĐOẠN NÀY ĐỂ MYSQL KHÔNG ĐÁ VĂNG DỮ LIỆU
            String time = h.getAppliedTime().replace("T", " ");
            if (time.length() == 16) { time += ":00"; }
            st1.setString(2, time); 
            
            st1.setDouble(3, h.getPrice());
            st1.setString(4, h.getEmployeeId());
            st1.executeUpdate();

            String sql2 = "UPDATE DISH SET Price = ? WHERE Dish_ID = ?";
            PreparedStatement st2 = connection.prepareStatement(sql2);
            st2.setDouble(1, h.getPrice()); 
            st2.setString(2, h.getDishId()); 
            st2.executeUpdate();
            System.out.println("=======> THÊM LỊCH SỬ GIÁ THÀNH CÔNG!");

        } catch (Exception e) { 
            // IN LỖI RA CONSOLE ĐỂ DỄ BẮT BỆNH
            System.out.println("=======> LỖI THÊM LỊCH SỬ GIÁ: " + e.getMessage()); 
            e.printStackTrace(); 
        }
    }

    public void updatePriceHistory(PriceHistory h) {
        try {
            String sql1 = "UPDATE PRICE_HISTORY SET Price = ?, Employee_ID = ? WHERE Dish_ID = ? AND Applied_Time = ?";
            PreparedStatement st1 = connection.prepareStatement(sql1);
            st1.setDouble(1, h.getPrice());
            st1.setString(2, h.getEmployeeId());
            st1.setString(3, h.getDishId());
            
            // XỬ LÝ LỖI NGÀY GIỜ
            String time = h.getAppliedTime().replace("T", " ");
            if (time.length() == 16) { time += ":00"; }
            st1.setString(4, time);
            st1.executeUpdate();

            String sql2 = "UPDATE DISH SET Price = ? WHERE Dish_ID = ?";
            PreparedStatement st2 = connection.prepareStatement(sql2);
            st2.setDouble(1, h.getPrice()); 
            st2.setString(2, h.getDishId());
            st2.executeUpdate();

        } catch (Exception e) { 
            System.out.println("=======> LỖI SỬA LỊCH SỬ GIÁ: " + e.getMessage());
            e.printStackTrace(); 
        }
    }

    public void deletePriceHistory(String dishId, String appliedTime) {
        try {
            PreparedStatement st = connection.prepareStatement("DELETE FROM PRICE_HISTORY WHERE Dish_ID=? AND Applied_time=?");
            st.setString(1, dishId); 
            
            String time = appliedTime.replace("T", " ");
            if (time.length() == 16) { time += ":00"; }
            st.setString(2, time); 
            
            st.executeUpdate();
        } catch (Exception e) {}
    }
    // ================== EXPORT HISTORY ==================
    // ================== EXPORT HISTORY ==================
    public List<ExportHistory> getAllExportHistories() {
        List<ExportHistory> list = new ArrayList<>();
        
        // DÙNG LỆNH JOIN ĐỂ LẤY TÊN NHÂN VIÊN, TÊN NGUYÊN LIỆU VÀ ĐƠN VỊ
        String sql = "SELECT e.Export_date, e.Employee_ID, e.Batch_ID, e.Export_quantity, e.Export_purpose, " +
                     "emp.first_name, emp.last_name, ing.ingredient_name, ing.unit " +
                     "FROM EXPORT_HISTORY e " +
                     "JOIN EMPLOYEE emp ON e.Employee_ID = emp.employee_id " +
                     "JOIN IMPORT_BATCH ib ON e.Batch_ID = ib.batch_id " +
                     "JOIN INGREDIENT ing ON ib.ingredient_id = ing.ingredient_id " +
                     "ORDER BY e.Export_date DESC";
                     
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                String fullName = rs.getString("first_name") + " " + rs.getString("last_name");
                list.add(new ExportHistory(
                    formatDateTime(rs.getString("Export_date")), 
                    rs.getString("Employee_ID"), 
                    rs.getString("Batch_ID"), 
                    rs.getDouble("Export_quantity"), 
                    rs.getString("Export_purpose"),
                    fullName, // Truyền tên nhân viên vào
                    rs.getString("ingredient_name"), // Truyền tên nguyên liệu vào
                    rs.getString("unit") // Truyền đơn vị vào
                ));
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    // ==========================================
    // THÊM PHIẾU XUẤT: TRỪ TRỰC TIẾP VÀO KHO NGUYÊN LIỆU (INGREDIENT)
    // ==========================================
   // ==========================================
    // THÊM PHIẾU XUẤT: TRỪ TRỰC TIẾP VÀO KHO
    // ==========================================
public void insertExportHistory(ExportHistory h) {
        try {
            // Chỉ cần lưu vào bảng EXPORT_HISTORY (Việc trừ kho ở bảng Lô nhập đã có Servlet gọi riêng)
            PreparedStatement st = connection.prepareStatement("INSERT INTO EXPORT_HISTORY VALUES (?, ?, ?, ?, ?)");
            st.setString(1, h.getExportDate().replace("T", " ")); 
            st.setString(2, h.getEmployeeId()); 
            st.setString(3, h.getBatchId()); 
            st.setDouble(4, h.getExportQuantity()); 
            st.setString(5, h.getExportPurpose());
            st.executeUpdate();
            
            // ĐÃ XÓA ĐOẠN UPDATE MIN_STOCK Ở ĐÂY
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
    }

    // ==========================================
    // SỬA PHIẾU XUẤT (Vá lỗi ngày tháng)
    // ==========================================
    public void updateExportHistory(ExportHistory h) {
        try {
            PreparedStatement st = connection.prepareStatement("UPDATE EXPORT_HISTORY SET Export_quantity=?, Export_purpose=? WHERE Employee_ID=? AND Batch_ID=? AND Export_date=?");
            st.setDouble(1, h.getExportQuantity()); 
            st.setString(2, h.getExportPurpose()); 
            st.setString(3, h.getEmployeeId());
            st.setString(4, h.getBatchId());
            
            String time = h.getExportDate().replace("T", " ");
            if (time.length() == 16) { time += ":00"; }
            st.setString(5, time); 
            
            st.executeUpdate();
        } catch (Exception e) {
            System.out.println("LỖI SỬA XUẤT KHO: " + e.getMessage());
        }
    }

    // ==========================================
    // XÓA PHIẾU XUẤT: HOÀN TRẢ LẠI KHO (Vá lỗi ngày tháng)
    // ==========================================
    public void deleteExportHistory(String date, String batchId) {
        try {
            // Bước 1: Lấy số lượng của phiếu xuất chuẩn bị xóa để hoàn trả
            double qtyToReturn = 0;
            PreparedStatement stGetQty = connection.prepareStatement("SELECT Export_quantity FROM EXPORT_HISTORY WHERE Export_date=? AND Batch_ID=?");
            stGetQty.setString(1, date.replace("T", " "));
            stGetQty.setString(2, batchId);
            ResultSet rsQty = stGetQty.executeQuery();
            if (rsQty.next()) {
                qtyToReturn = rsQty.getDouble("Export_quantity");
            }

            // Bước 2: CỘNG THẲNG TRẢ LẠI vào đúng Lô nhập kho đó (IMPORT_BATCH)
            if (qtyToReturn > 0) {
                PreparedStatement updateSt = connection.prepareStatement("UPDATE IMPORT_BATCH SET Stock_quantity = Stock_quantity + ? WHERE Batch_ID = ?");
                updateSt.setDouble(1, qtyToReturn);
                updateSt.setString(2, batchId);
                updateSt.executeUpdate();
            }

            // Bước 3: Xóa phiếu xuất khỏi lịch sử
            PreparedStatement st = connection.prepareStatement("DELETE FROM EXPORT_HISTORY WHERE Export_date=? AND Batch_ID=?");
            st.setString(1, date.replace("T", " ")); 
            st.setString(2, batchId); 
            st.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}