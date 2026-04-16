package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Ingredient;
import model.Recipe;
import model.ImportBatch;

public class InventoryDAO extends DBContext {

    // ================== INGREDIENT ==================
    // ... Giữ nguyên các hàm khác ...

    // ================== INGREDIENT ==================
    public List<Ingredient> getAllIngredients() {
        List<Ingredient> list = new ArrayList<>();
        try {
            // LỆNH SQL ĐỈNH CAO: Nối bảng và Cộng tổng số lượng từ các Lô hàng
            String sql = "SELECT ig.ingredient_id, ig.ingredient_name, ig.min_stock, ig.unit, " +
                         "COALESCE(SUM(ib.stock_quantity), 0) AS total_stock " +
                         "FROM INGREDIENT ig " +
                         "LEFT JOIN IMPORT_BATCH ib ON ig.ingredient_id = ib.ingredient_id " +
                         "GROUP BY ig.ingredient_id, ig.ingredient_name, ig.min_stock, ig.unit";
                         
            ResultSet rs = connection.prepareStatement(sql).executeQuery();
            
            while (rs.next()) {
                list.add(new Ingredient(
                    rs.getString("ingredient_id"), 
                    rs.getString("ingredient_name"), 
                    rs.getDouble("min_stock"), 
                    rs.getString("unit"),
                    rs.getDouble("total_stock") // Lấy tổng hàng đã được SQL tính toán
                ));
            }
        } catch (Exception e) { 
            System.out.println("Lỗi lấy nguyên liệu: " + e.getMessage());
            e.printStackTrace(); 
        }
        return list;
    }

    // ĐÃ SỬA: Lược bỏ Ingredient_ID để hệ thống tự tăng
    public void insertIngredient(Ingredient i) {
        try {
            // Chỉ insert Name, Min_Stock và Unit
            PreparedStatement st = connection.prepareStatement("INSERT INTO INGREDIENT (Ingredient_name, Min_stock, Unit) VALUES (?, ?, ?)");
            st.setString(1, i.getIngredientName()); 
            st.setDouble(2, i.getMinStock()); 
            st.setString(3, i.getUnit());
            st.executeUpdate();
        } catch (Exception e) { 
            System.out.println(e); 
        }
    }

    public void updateIngredient(Ingredient i) {
        try {
            PreparedStatement st = connection.prepareStatement("UPDATE INGREDIENT SET Ingredient_name=?, Min_stock=?, Unit=? WHERE Ingredient_ID=?");
            st.setString(1, i.getIngredientName()); 
            st.setDouble(2, i.getMinStock()); 
            st.setString(3, i.getUnit()); 
            st.setString(4, i.getIngredientId());
            st.executeUpdate();
        } catch (Exception e) { 
            System.out.println(e); 
        }
    }

    public void deleteIngredient(String id) {
        try { 
            connection.prepareStatement("DELETE FROM INGREDIENT WHERE Ingredient_ID='" + id + "'").executeUpdate(); 
        } catch (Exception e) {
            System.out.println(e); 
        }
    }


    // ================== RECIPE ==================
    public List<Recipe> getAllRecipes() {
        List<Recipe> list = new ArrayList<>();
        try {
            // DÙNG JOIN ĐỂ LẤY THÊM TÊN MÓN, TÊN NGUYÊN LIỆU VÀ ĐƠN VỊ TÍNH
            String sql = "SELECT r.dish_id, r.ingredient_id, r.quantity, d.dish_name, i.ingredient_name, i.unit " +
                         "FROM RECIPE r " +
                         "JOIN DISH d ON r.dish_id = d.dish_id " +
                         "JOIN INGREDIENT i ON r.ingredient_id = i.ingredient_id";
                         
            ResultSet rs = connection.prepareStatement(sql).executeQuery();
            
            while (rs.next()) {
                list.add(new Recipe(
                    rs.getString("dish_id"), 
                    rs.getString("ingredient_id"), 
                    rs.getDouble("quantity"),
                    rs.getString("dish_name"),       // Lấy tên món
                    rs.getString("ingredient_name"), // Lấy tên nguyên liệu
                    rs.getString("unit")             // Lấy đơn vị tính
                ));
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }
    public void insertRecipe(Recipe r) {
        try {
            PreparedStatement st = connection.prepareStatement("INSERT INTO RECIPE VALUES (?, ?, ?)");
            st.setString(1, r.getDishId()); st.setString(2, r.getIngredientId()); st.setDouble(3, r.getQuantity()); st.executeUpdate();
        } catch (Exception e) { System.out.println(e); }
    }
    public void updateRecipe(Recipe r) {
        try {
            PreparedStatement st = connection.prepareStatement("UPDATE RECIPE SET Quantity=? WHERE Dish_ID=? AND Ingredient_ID=?");
            st.setDouble(1, r.getQuantity()); st.setString(2, r.getDishId()); st.setString(3, r.getIngredientId()); st.executeUpdate();
        } catch (Exception e) { System.out.println(e); }
    }
    public void deleteRecipe(String dishId, String ingredientId) {
        try {
            PreparedStatement st = connection.prepareStatement("DELETE FROM RECIPE WHERE Dish_ID=? AND Ingredient_ID=?");
            st.setString(1, dishId); st.setString(2, ingredientId); st.executeUpdate();
        } catch (Exception e) {}
    }

    // ================== IMPORT BATCH ==================
    // ... Giữ nguyên các hàm khác ở trên và dưới ...

    // HÀM LẤY DANH SÁCH LÔ NHẬP
// HÀM LẤY DANH SÁCH LÔ NHẬP (ĐÃ SỬA LỖI LỘN CỘT DỮ LIỆU)
// HÀM LẤY DANH SÁCH LÔ NHẬP (ĐÃ CẬP NHẬT ĐỂ HIỂN THỊ TÊN)
    public List<ImportBatch> getAllImportBatches() {
        List<ImportBatch> list = new ArrayList<>();
        try {
            // DÙNG JOIN ĐỂ LẤY TÊN NGUYÊN LIỆU VÀ GỘP HỌ TÊN NHÂN VIÊN
            String sql = "SELECT ib.batch_id, ib.employee_id, ib.ingredient_id, ib.import_date, ib.expiration_date, ib.batch_price, ib.stock_quantity, " +
                         "ig.ingredient_name, CONCAT(e.last_name, ' ', e.first_name) AS employee_name " +
                         "FROM IMPORT_BATCH ib " +
                         "JOIN INGREDIENT ig ON ib.ingredient_id = ig.ingredient_id " +
                         "JOIN EMPLOYEE e ON ib.employee_id = e.employee_id " +
                         "ORDER BY ib.import_date DESC";
                         
            ResultSet rs = connection.prepareStatement(sql).executeQuery();
            
            while (rs.next()) {
                list.add(new ImportBatch(
                    rs.getString("batch_id"), 
                    rs.getString("employee_id"), 
                    rs.getString("ingredient_id"), 
                    rs.getString("import_date") != null ? rs.getString("import_date").replace(" ", "T") : null, 
                    rs.getString("expiration_date") != null ? rs.getString("expiration_date").replace(" ", "T") : null, 
                    rs.getDouble("batch_price"), 
                    rs.getDouble("stock_quantity"),
                    rs.getString("employee_name"),      // Lấy tên Nhân viên
                    rs.getString("ingredient_name")     // Lấy tên Nguyên liệu
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ĐÃ SỬA: BỎ CỘT BATCH_ID VÀ CHỈ INSERT 6 CỘT ĐỂ MYSQL TỰ TĂNG ID LÔ HÀNG
    public void insertImportBatch(ImportBatch b) {
        try {
            PreparedStatement st = connection.prepareStatement("INSERT INTO IMPORT_BATCH (Employee_ID, Ingredient_ID, Import_date, Expiration_date, Batch_price, Stock_quantity) VALUES (?, ?, ?, ?, ?, ?)");
            st.setString(1, b.getEmployeeId()); 
            st.setString(2, b.getIngredientId());
            st.setString(3, b.getImportDate() != null ? b.getImportDate().replace("T", " ") : null); 
            st.setString(4, b.getExpirationDate() != null ? b.getExpirationDate().replace("T", " ") : null); 
            st.setDouble(5, b.getBatchPrice()); 
            st.setDouble(6, b.getStockQuantity());
            st.executeUpdate();

            // ĐÃ XÓA LỆNH UPDATE CỘNG MIN_STOCK Ở ĐÂY

        } catch (Exception e) { 
            e.printStackTrace(); 
        }
    }

    // Hàm processExportDeduction và các hàm khác vẫn được giữ nguyên.

    public void updateImportBatch(ImportBatch b) {
        try {
            PreparedStatement st = connection.prepareStatement("UPDATE IMPORT_BATCH SET Employee_ID=?, Ingredient_ID=?, Import_date=?, Expiration_date=?, Batch_price=?, Stock_quantity=? WHERE Batch_ID=?");
            st.setString(1, b.getEmployeeId()); 
            st.setString(2, b.getIngredientId()); 
            st.setString(3, b.getImportDate() != null ? b.getImportDate().replace("T", " ") : null); 
            st.setString(4, b.getExpirationDate() != null ? b.getExpirationDate().replace("T", " ") : null); 
            st.setDouble(5, b.getBatchPrice()); 
            st.setDouble(6, b.getStockQuantity()); 
            st.setString(7, b.getBatchId());
            st.executeUpdate();
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
    }

public void deleteImportBatch(String id) {
        try {
            // ĐÃ XÓA LỆNH UPDATE TRỪ MIN_STOCK Ở ĐÂY
            connection.prepareStatement("DELETE FROM IMPORT_BATCH WHERE Batch_ID='" + id + "'").executeUpdate(); 
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ==========================================================
    // HÀM MỚI ĐƯỢC THÊM: XỬ LÝ TRỪ SỐ LƯỢNG KHI XUẤT KHO
    // ==========================================================
 public void processExportDeduction(String batchId, double exportQty) {
        try {
            // CHỈ TRỪ số lượng xuất khỏi kho của đúng Lô nhập đó (IMPORT_BATCH)
            PreparedStatement stUpdateBatch = connection.prepareStatement("UPDATE IMPORT_BATCH SET Stock_quantity = Stock_quantity - ? WHERE Batch_ID = ?");
            stUpdateBatch.setDouble(1, exportQty);
            stUpdateBatch.setString(2, batchId);
            stUpdateBatch.executeUpdate();

            // ĐÃ XÓA LỆNH TRỪ MIN_STOCK Ở ĐÂY
            
        } catch (Exception e) {
            System.out.println("Lỗi khi trừ tồn kho lô nhập: " + e.getMessage());
            e.printStackTrace();
        }
    }
}