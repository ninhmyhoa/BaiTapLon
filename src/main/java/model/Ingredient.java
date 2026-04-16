package model;

public class Ingredient {
    private String ingredientId;
    private String ingredientName;
    private double minStock;
    private String unit;
    
    // THÊM BIẾN NÀY ĐỂ CHỨA TỔNG HÀNG (ĐƯỢC TÍNH TỪ CÁC LÔ)
    private double totalStock;

    public Ingredient() {}
    
    // Constructor cũ cho các chức năng Thêm/Sửa
    public Ingredient(String ingredientId, String ingredientName, double minStock, String unit) {
        this.ingredientId = ingredientId; 
        this.ingredientName = ingredientName; 
        this.minStock = minStock; 
        this.unit = unit;
    }

    // CONSTRUCTOR MỚI ĐỂ HIỂN THỊ LÊN BẢNG (Có thêm totalStock)
    public Ingredient(String ingredientId, String ingredientName, double minStock, String unit, double totalStock) {
        this.ingredientId = ingredientId;
        this.ingredientName = ingredientName;
        this.minStock = minStock;
        this.unit = unit;
        this.totalStock = totalStock;
    }

    public String getIngredientId() { return ingredientId; } public void setIngredientId(String id) { this.ingredientId = id; }
    public String getIngredientName() { return ingredientName; } public void setIngredientName(String name) { this.ingredientName = name; }
    public double getMinStock() { return minStock; } public void setMinStock(double minStock) { this.minStock = minStock; }
    public String getUnit() { return unit; } public void setUnit(String unit) { this.unit = unit; }
    
    // Getter & Setter cho Tổng hàng
    public double getTotalStock() { return totalStock; } public void setTotalStock(double totalStock) { this.totalStock = totalStock; }
}