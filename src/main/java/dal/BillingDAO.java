package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.BillDetail;
import model.DiningTable;
import model.Invoice;
import model.InvoiceDetail;

public class BillingDAO extends DBContext {

    // ==========================================
    // 1. QUẢN LÝ TRẠNG THÁI BÀN
    // ==========================================
    public void updateTableStatus(int roomId, int tableNumber, String status) {
        String sql = "UPDATE DINING_TABLE SET Status = ? WHERE Room_ID = ? AND Table_number = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, status);
            st.setInt(2, roomId);
            st.setInt(3, tableNumber);
            st.executeUpdate();
        } catch (Exception e) { 
            System.out.println("Lỗi updateTableStatus: " + e.getMessage()); 
        }
    }

    // ==========================================
    // 2. QUẢN LÝ HÓA ĐƠN (INVOICE)
    // ==========================================
    public List<Invoice> getAllInvoices() {
        List<Invoice> list = new ArrayList<>();
        // ĐÃ SỬA: Thêm câu lệnh Sub-Query để lấy vị trí phòng và bàn
        String sql = "SELECT i.*, e.first_name, e.last_name, " +
                     "(SELECT GROUP_CONCAT(DISTINCT CONCAT('P', Room_ID, '-B', Table_number) SEPARATOR ', ') " +
                     " FROM INVOICE_DETAIL id WHERE id.Invoice_ID = i.Invoice_ID) as serving_location " +
                     "FROM INVOICE i " +
                     "LEFT JOIN EMPLOYEE e ON i.Employee_ID = e.employee_id " +
                     "ORDER BY i.Invoice_ID DESC";
        try {
            java.sql.PreparedStatement st = connection.prepareStatement(sql);
            java.sql.ResultSet rs = st.executeQuery();
            while (rs.next()) {
                String firstName = rs.getString("first_name");
                String lastName = rs.getString("last_name");
                String fullName = (firstName != null && lastName != null) ? (firstName + " " + lastName) : "Chưa cập nhật";
                
                String rawDate = rs.getString("Created_time");
                String formattedDate = (rawDate == null || rawDate.startsWith("0000")) ? "Chưa xác định" : rawDate.substring(0, 16);
                
                // Lấy vị trí bàn từ SQL
                String servingLocation = rs.getString("serving_location");
                
                // ĐÃ SỬA: Truyền đủ 7 tham số vào Invoice (Thêm tham số servingLocation ở cuối cùng)
                list.add(new Invoice(
                    rs.getInt("Invoice_ID"), 
                    rs.getString("Customer_ID"), 
                    rs.getString("Employee_ID"), 
                    formattedDate, 
                    "Đã thanh toán",  
                    fullName,          
                    servingLocation   // <--- Gắn vị trí bàn vào đây
                ));
            }
        } catch (Exception e) { 
            System.out.println("======> LỖI KÉO DS HÓA ĐƠN: " + e.getMessage()); 
            e.printStackTrace(); 
        }
        return list;
    }

    public void insertInvoice(Invoice i) {
        try {
            PreparedStatement st = connection.prepareStatement("INSERT INTO INVOICE (Customer_ID, Employee_ID, Created_time) VALUES (?, ?, ?)");
            st.setString(1, i.getCustomerId()); 
            st.setString(2, i.getEmployeeId()); 
            st.setString(3, i.getCreatedTime().replace("T", " "));
            st.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void updateInvoice(Invoice i) {
        try {
            PreparedStatement st = connection.prepareStatement("UPDATE INVOICE SET Customer_ID=?, Employee_ID=?, Created_time=? WHERE Invoice_ID=?");
            st.setString(1, i.getCustomerId()); 
            st.setString(2, i.getEmployeeId()); 
            st.setString(3, i.getCreatedTime().replace("T", " ")); 
            st.setInt(4, i.getInvoiceId());
            st.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void deleteInvoice(int id) {
        try { 
            connection.prepareStatement("DELETE FROM INVOICE WHERE Invoice_ID=" + id).executeUpdate(); 
        } catch (Exception e) { e.printStackTrace(); }
    }

    // ==========================================
    // 3. CHI TIẾT GỌI MÓN (INVOICE_DETAIL)
    // ==========================================
    public List<InvoiceDetail> getAllInvoiceDetails() {
        List<InvoiceDetail> list = new ArrayList<>();
        try {
            String sql = "SELECT id.invoice_id, id.employee_id, id.dish_id, id.room_id, id.table_number, id.quantity, id.note, id.kitchen_status, " +
                         "d.dish_name, CONCAT(e.last_name, ' ', e.first_name) AS employee_name " +
                         "FROM INVOICE_DETAIL id " +
                         "JOIN DISH d ON id.dish_id = d.dish_id " +
                         "JOIN EMPLOYEE e ON id.employee_id = e.employee_id";
                         
            ResultSet rs = connection.prepareStatement(sql).executeQuery();
            
            while (rs.next()) {
                list.add(new InvoiceDetail(
                    rs.getInt("invoice_id"),
                    rs.getInt("employee_id"),
                    rs.getInt("dish_id"),
                    rs.getInt("room_id"),
                    rs.getInt("table_number"),
                    rs.getInt("quantity"),
                    rs.getString("note"),
                    rs.getString("kitchen_status"),
                    rs.getString("dish_name"),      
                    rs.getString("employee_name")   
                ));
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    public List<InvoiceDetail> getInvoiceDetailsByInvoice(int invoiceId) {
        List<InvoiceDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM INVOICE_DETAIL WHERE Invoice_ID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, invoiceId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new InvoiceDetail(
                    rs.getInt("Invoice_ID"), rs.getInt("Employee_ID"), rs.getInt("Dish_ID"), 
                    rs.getInt("Room_ID"), rs.getInt("Table_number"), rs.getInt("Quantity"), 
                    rs.getString("Note"), rs.getString("Kitchen_status")
                ));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public void insertInvoiceDetail(InvoiceDetail d) {
        String sql = "INSERT INTO INVOICE_DETAIL (invoice_id, employee_id, dish_id, room_id, table_number, quantity, note, kitchen_status, order_time) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, d.getInvoiceId());
            st.setInt(2, d.getEmployeeId());
            st.setInt(3, d.getDishId());
            st.setInt(4, d.getRoomId());
            st.setInt(5, d.getTableNumber());
            st.setInt(6, d.getQuantity());
            st.setString(7, d.getNote());
            st.setString(8, d.getKitchenStatus());
            st.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void updateInvoiceDetail(InvoiceDetail d) {
        String sql = "UPDATE INVOICE_DETAIL SET Quantity=?, Note=?, Kitchen_status=?, Employee_ID=? WHERE Invoice_ID=? AND Room_ID=? AND Table_number=? AND Dish_ID=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, d.getQuantity());
            st.setString(2, d.getNote());
            st.setString(3, d.getKitchenStatus());
            st.setInt(4, d.getEmployeeId());
            st.setInt(5, d.getInvoiceId());
            st.setInt(6, d.getRoomId());
            st.setInt(7, d.getTableNumber());
            st.setInt(8, d.getDishId());
            st.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public void deleteInvoiceDetail(int invoiceId, int dishId, int roomId, int tableNumber) {
        String sql = "DELETE FROM INVOICE_DETAIL WHERE Invoice_ID=? AND Dish_ID=? AND Room_ID=? AND Table_number=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, invoiceId); st.setInt(2, dishId); st.setInt(3, roomId); st.setInt(4, tableNumber);
            st.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // ==========================================
    // 4. LOGIC NHÀ BẾP (KDS)
    // ==========================================
    public List<InvoiceDetail> getPendingOrders() {
        List<InvoiceDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM INVOICE_DETAIL WHERE Kitchen_status != 'Served' ORDER BY order_time ASC";
        try {
            ResultSet rs = connection.prepareStatement(sql).executeQuery();
            while (rs.next()) {
                list.add(new InvoiceDetail(
                    rs.getInt("Invoice_ID"), rs.getInt("Employee_ID"), rs.getInt("Dish_ID"), 
                    rs.getInt("Room_ID"), rs.getInt("Table_number"), rs.getInt("Quantity"), 
                    rs.getString("Note"), rs.getString("Kitchen_status")
                ));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public void updateKitchenStatus(int invId, int dishId, int roomId, int tableNum, String status) {
        String sql = "UPDATE INVOICE_DETAIL SET Kitchen_status = ? WHERE Invoice_ID=? AND Dish_ID=? AND Room_ID=? AND Table_number=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, status);
            st.setInt(2, invId); st.setInt(3, dishId); st.setInt(4, roomId); st.setInt(5, tableNum);
            st.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // ==========================================
    // 5. THANH TOÁN & IN BILL
    // ==========================================
    public double getTotalBill(int invoiceId) {
        double total = 0;
        String sql = "SELECT SUM(d.Price * id.Quantity) as Total FROM INVOICE_DETAIL id " +
                     "JOIN DISH d ON id.Dish_ID = d.dish_id WHERE id.Invoice_ID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, invoiceId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) total = rs.getDouble("Total");
        } catch (Exception e) { e.printStackTrace(); }
        return total;
    }

    public List<BillDetail> getBillDetails(int invoiceId) {
        List<BillDetail> list = new ArrayList<>();
        String sql = "SELECT d.dish_name, id.quantity, d.price, (id.quantity * d.price) as subTotal " +
                     "FROM INVOICE_DETAIL id " +
                     "JOIN DISH d ON id.dish_id = d.dish_id " +
                     "WHERE id.invoice_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, invoiceId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new BillDetail(
                    rs.getString("dish_name"),
                    rs.getInt("quantity"),
                    rs.getDouble("price"),
                    rs.getDouble("subTotal")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // === HÀM HỖ TRỢ GIẢI PHÓNG BÀN ===
    public List<DiningTable> getTablesByInvoiceList(int invoiceId) {
        List<DiningTable> list = new ArrayList<>();
        String sql = "SELECT DISTINCT Room_ID, Table_number FROM INVOICE_DETAIL WHERE Invoice_ID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, invoiceId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new DiningTable(String.valueOf(rs.getInt("Room_ID")), rs.getInt("Table_number"), ""));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}