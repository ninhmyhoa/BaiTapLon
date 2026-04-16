package model;

public class Recipe {
    private String dishId;
    private String ingredientId;
    private double quantity;
    
    // THÊM 3 BIẾN LƯU TÊN VÀ ĐƠN VỊ ĐỂ HIỂN THỊ LÊN WEB
    private String dishName;
    private String ingredientName;
    private String unit;

    public Recipe() {}

    // Constructor cũ (giữ lại để thêm/sửa/xóa không bị lỗi)
    public Recipe(String dishId, String ingredientId, double quantity) {
        this.dishId = dishId;
        this.ingredientId = ingredientId;
        this.quantity = quantity;
    }

    // Constructor mới (dùng để lấy dữ liệu có cả tên và đơn vị hiển thị)
    public Recipe(String dishId, String ingredientId, double quantity, String dishName, String ingredientName, String unit) {
        this.dishId = dishId;
        this.ingredientId = ingredientId;
        this.quantity = quantity;
        this.dishName = dishName;
        this.ingredientName = ingredientName;
        this.unit = unit; // Gán thêm đơn vị
    }

    public String getDishId() { return dishId; }
    public void setDishId(String dishId) { this.dishId = dishId; }
    
    public String getIngredientId() { return ingredientId; }
    public void setIngredientId(String ingredientId) { this.ingredientId = ingredientId; }
    
    public double getQuantity() { return quantity; }
    public void setQuantity(double quantity) { this.quantity = quantity; }

    // GETTER & SETTER CHO CÁC BIẾN HIỂN THỊ
    public String getDishName() { return dishName; }
    public void setDishName(String dishName) { this.dishName = dishName; }
    
    public String getIngredientName() { return ingredientName; }
    public void setIngredientName(String ingredientName) { this.ingredientName = ingredientName; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
}