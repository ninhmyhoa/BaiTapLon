package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Category;
import model.Dish;

public class MenuDAO extends DBContext {

    // ================== CATEGORY ==================
    // ... Các code khác của file MenuDAO giữ nguyên ...

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        try {
            PreparedStatement st = connection.prepareStatement("SELECT * FROM CATEGORY");
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Category(rs.getString("Category_ID"), rs.getString("Category_name")));
            }
        } catch (Exception e) { 
            System.out.println(e); 
        }
        return list;
    }

    // ĐÃ SỬA: Chỉ INSERT Tên danh mục, để hệ thống tự động cấp Mã danh mục
    public void insertCategory(Category c) {
        try {
            // Lược bỏ cột ID và 1 dấu ?
            PreparedStatement st = connection.prepareStatement("INSERT INTO CATEGORY (Category_name) VALUES (?)");
            st.setString(1, c.getCategoryName());
            st.executeUpdate();
        } catch (Exception e) { 
            System.out.println(e); 
        }
    }

    public void updateCategory(Category c) {
        try {
            PreparedStatement st = connection.prepareStatement("UPDATE CATEGORY SET Category_name=? WHERE Category_ID=?");
            st.setString(1, c.getCategoryName());
            st.setString(2, c.getCategoryId());
            st.executeUpdate();
        } catch (Exception e) { 
            System.out.println(e); 
        }
    }

    public void deleteCategory(String id) {
        try {
            PreparedStatement st = connection.prepareStatement("DELETE FROM CATEGORY WHERE Category_ID=?");
            st.setString(1, id);
            st.executeUpdate();
        } catch (Exception e) { 
            System.out.println(e); 
        }
    }
    // ================== DISH ==================
    // ... Giữ nguyên các hàm khác ...

   public List<Dish> getAllDishes() {
        List<Dish> list = new ArrayList<>();
        try {
            // ĐÃ SỬA: Dùng JOIN để móc nối 2 bảng, lấy thêm cột Category_name
            String sql = "SELECT d.Dish_ID, d.Category_ID, d.Dish_name, d.Price, c.Category_name " +
                         "FROM DISH d JOIN CATEGORY c ON d.Category_ID = c.Category_ID";
                         
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            
            while (rs.next()) {
                // ĐÃ SỬA: Dùng Constructor 5 tham số, lấy category_name từ ResultSet gán vào
                list.add(new Dish(
                    rs.getString("Dish_ID"), 
                    rs.getString("Category_ID"), 
                    rs.getString("Dish_name"), 
                    rs.getDouble("Price"),
                    rs.getString("Category_name") 
                ));
            }
        } catch (Exception e) { 
            System.out.println(e); 
        }
        return list;
    }

    // ĐÃ SỬA: Lược bỏ Dish_ID để hệ thống tự tăng
    public void insertDish(Dish d) {
        try {
            // Lược bỏ cột Dish_ID và 1 dấu ? ở Values
            PreparedStatement st = connection.prepareStatement("INSERT INTO DISH (Category_ID, Dish_name, Price) VALUES (?, ?, ?)");
            st.setString(1, d.getCategoryId());
            st.setString(2, d.getDishName());
            st.setDouble(3, d.getPrice());
            st.executeUpdate();
        } catch (Exception e) { 
            System.out.println(e); 
        }
    }

    public void deleteDish(String id) {
        try {
            PreparedStatement st = connection.prepareStatement("DELETE FROM DISH WHERE Dish_ID=?");
            st.setString(1, id);
            st.executeUpdate();
        } catch (Exception e) { 
            System.out.println(e); 
        }
    }

    // ================== HỆ THỐNG TRỪ KHO TỰ ĐỘNG (BOM) ==================

    // 1. Hàm hỗ trợ quy đổi đơn vị thông minh (gram <-> kg, ml <-> lít)
    public double convertUnit(double amount, String recipeUnit, String inventoryUnit) {
        if (recipeUnit == null || inventoryUnit == null) return amount;
        
        recipeUnit = recipeUnit.toLowerCase().trim();
        inventoryUnit = inventoryUnit.toLowerCase().trim();

        // Nếu cùng đơn vị (lon -> lon, chai -> chai, hộp -> hộp...) thì tỷ lệ 1:1
        if (recipeUnit.equals(inventoryUnit)) {
            return amount;
        }

        // Đổi khối lượng (Công thức dùng gram, Kho lưu bằng kg -> chia 1000)
        if ((recipeUnit.equals("gram") || recipeUnit.equals("g")) && inventoryUnit.equals("kg")) {
            return amount / 1000.0;
        }
        // Công thức dùng kg, Kho lưu bằng gram -> nhân 1000
        if (recipeUnit.equals("kg") && (inventoryUnit.equals("gram") || inventoryUnit.equals("g"))) {
            return amount * 1000.0;
        }

        // Đổi thể tích (Công thức dùng ml, Kho lưu bằng lít -> chia 1000)
        if (recipeUnit.equals("ml") && (inventoryUnit.equals("lít") || inventoryUnit.equals("lit") || inventoryUnit.equals("l"))) {
            return amount / 1000.0;
        }
        if ((recipeUnit.equals("lít") || recipeUnit.equals("lit") || recipeUnit.equals("l")) && recipeUnit.equals("ml")) {
            return amount * 1000.0;
        }

        return amount; // Mặc định giữ nguyên nếu không khớp quy tắc nào
    }

    // 2. Hàm trừ kho chính: Gọi khi Khách đặt món / Chốt đơn
    // 2. Hàm trừ kho chính: Gọi khi Khách đặt món / Chốt đơn
    // 2. Hàm trừ kho chính (Phiên bản Báo lỗi chi tiết)
    // Hàm trừ kho chính (Chuẩn xác theo cấu trúc Database của bạn)
    public void deductInventoryForDish(String dishId, int orderedPortions) {
    System.out.println("\n========== BẮT ĐẦU KÍCH HOẠT TRỪ KHO TỪ LÔ NHẬP ==========");
    System.out.println("=> Món khách gọi: [" + dishId + "] - Số lượng suất: " + orderedPortions);
    
    try {
        // BƯỚC 1: LẤY CÔNG THỨC MÓN ĂN VÀ ĐƠN VỊ TÍNH CHUNG TỪ BẢNG INGREDIENT
        String recipeSql = "SELECT r.Ingredient_ID, r.Quantity as RecipeQty, i.Unit as InvUnit " +
                           "FROM RECIPE r " +
                           "JOIN INGREDIENT i ON r.Ingredient_ID = i.Ingredient_ID " +
                           "WHERE r.Dish_ID = ?";
        PreparedStatement recipeSt = connection.prepareStatement(recipeSql);
        recipeSt.setString(1, dishId);
        ResultSet rsRecipe = recipeSt.executeQuery();

        boolean hasRecipe = false;

        while (rsRecipe.next()) {
            hasRecipe = true;
            String ingredientId = rsRecipe.getString("Ingredient_ID");
            double recipeQty = rsRecipe.getDouble("RecipeQty");
            String invUnit = rsRecipe.getString("InvUnit");
            String recipeUnit = invUnit; // Giả định công thức dùng cùng đơn vị với kho
            
            // Tính tổng lượng nguyên liệu cần dùng cho số suất khách gọi
            double totalNeededQty = convertUnit(recipeQty * orderedPortions, recipeUnit, invUnit);
            System.out.println("  -> Cần " + totalNeededQty + " " + invUnit + " của Nguyên liệu: [" + ingredientId + "]");

            // BƯỚC 2: TÌM CÁC LÔ HÀNG (IMPORT_BATCH) CÒN HÀNG CỦA NGUYÊN LIỆU NÀY (Ưu tiên lô cũ nhất)
            String batchSql = "SELECT Batch_ID, Stock_quantity FROM IMPORT_BATCH " +
                              "WHERE Ingredient_ID = ? AND Stock_quantity > 0 " +
                              "ORDER BY Import_date ASC"; // Nhập trước trừ trước (FIFO)
            PreparedStatement batchSt = connection.prepareStatement(batchSql);
            batchSt.setString(1, ingredientId);
            ResultSet rsBatch = batchSt.executeQuery();

            double remainingNeeded = totalNeededQty;

            // BƯỚC 3: RÚT DẦN TỪ CÁC LÔ HÀNG ĐẾN KHI ĐỦ SỐ LƯỢNG CẦN THIẾT
            while (rsBatch.next() && remainingNeeded > 0) {
                String batchId = rsBatch.getString("Batch_ID");
                double currentBatchStock = rsBatch.getDouble("Stock_quantity");
                
                double amountToDeductFromThisBatch = 0;
                double newBatchStock = 0;

                if (currentBatchStock >= remainingNeeded) {
                    // Lô này đủ hàng để trừ
                    amountToDeductFromThisBatch = remainingNeeded;
                    newBatchStock = currentBatchStock - remainingNeeded;
                    remainingNeeded = 0; // Đã lấy đủ hàng
                } else {
                    // Lô này không đủ, lấy hết kho của lô này rồi tìm lô tiếp theo
                    amountToDeductFromThisBatch = currentBatchStock;
                    newBatchStock = 0;
                    remainingNeeded -= currentBatchStock; 
                }

                // Cập nhật lại số lượng tồn kho của chính Lô hàng đó
                String updateBatchSql = "UPDATE IMPORT_BATCH SET Stock_quantity = ? WHERE Batch_ID = ?";
                PreparedStatement updateBatchSt = connection.prepareStatement(updateBatchSql);
                updateBatchSt.setDouble(1, newBatchStock);
                updateBatchSt.setString(2, batchId);
                updateBatchSt.executeUpdate();

                System.out.println("     => Đã trừ " + amountToDeductFromThisBatch + " từ Lô hàng: [" + batchId + "] | Lô này còn: " + newBatchStock);
            }

            if (remainingNeeded > 0) {
                System.out.println("     [CẢNH BÁO]: KHO KHÔNG ĐỦ HÀNG! Còn thiếu " + remainingNeeded + " " + invUnit);
            }
        }
        
        if (!hasRecipe) {
            System.out.println("=> [CẢNH BÁO]: Món [" + dishId + "] CHƯA CÓ CÔNG THỨC TRONG BẢNG 'RECIPE'!");
        }
        System.out.println("========================================================\n");

    } catch (Exception e) {
        System.out.println("LỖI TRỪ KHO THEO LÔ: " + e.getMessage());
        e.printStackTrace();
    }
}
    // ==========================================================
    // HÀM KIỂM TRA SỐ LƯỢNG TỐI ĐA CÓ THỂ NẤU (SOI KHO)
   // ==========================================================
    // HÀM KIỂM TRA SỐ LƯỢNG TỐI ĐA CÓ THỂ NẤU (SOI KHO TỪ LÔ NHẬP)
    // ==========================================================
    public int getMaxPortions(String dishId) {
        int maxPortions = 9999; // Giả sử ban đầu nấu được vô hạn
        try {
            // ĐÃ SỬA: Lấy tổng tồn kho thực tế từ bảng IMPORT_BATCH
            String sql = "SELECT r.Quantity as RecipeQty, " +
                         "COALESCE((SELECT SUM(Stock_quantity) FROM IMPORT_BATCH WHERE Ingredient_ID = r.Ingredient_ID AND Stock_quantity > 0), 0) as ActualStock " +
                         "FROM RECIPE r " +
                         "JOIN INGREDIENT i ON r.Ingredient_ID = i.Ingredient_ID " +
                         "WHERE r.Dish_ID = ?";
                         
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, dishId);
            ResultSet rs = st.executeQuery();

            boolean hasRecipe = false;
            while (rs.next()) {
                hasRecipe = true;
                double recipeQty = rs.getDouble("RecipeQty"); // Lượng cần cho 1 món
                double actualStock = rs.getDouble("ActualStock"); // Tổng tồn kho thực tế từ các lô

                // Nếu trong kho sạch bách nguyên liệu này, thì dĩ nhiên là tạch, không nấu được phần nào
                if (actualStock <= 0) {
                    return 0;
                }

                if (recipeQty > 0) {
                    // Tính xem nguyên liệu này làm được mấy dĩa (Chia lấy phần nguyên)
                    int portions = (int) (actualStock / recipeQty);
                    
                    // Lấy thằng nhỏ nhất làm chuẩn (Nút thắt cổ chai)
                    if (portions < maxPortions) {
                        maxPortions = portions;
                    }
                }
            }
            
            // Nếu món không có công thức (VD: Nước ngọt lon bán sẵn) thì cho bán thoải mái (999)
            if (!hasRecipe) return 999; 

        } catch (Exception e) {
            System.out.println("Lỗi getMaxPortions: " + e.getMessage());
        }
        return (maxPortions == 9999) ? 0 : maxPortions;
    }
}