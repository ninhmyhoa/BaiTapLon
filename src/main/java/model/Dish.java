package model;

public class Dish {
    private String dishId;
    private String categoryId;
    private String dishName;
    private double price;
    
    // 1. THÊM BIẾN LƯU TÊN DANH MỤC
    private String categoryName; 

    public Dish() {}

    // 2. CONSTRUCTOR CŨ (Giữ lại để không bị lỗi lúc Insert món mới vào CSDL)
    public Dish(String dishId, String categoryId, String dishName, double price) {
        this.dishId = dishId;
        this.categoryId = categoryId;
        this.dishName = dishName;
        this.price = price;
    }

    // 3. CONSTRUCTOR MỚI ĐẦY ĐỦ (Dùng để lấy dữ liệu có cả Tên danh mục hiển thị lên Web)
    public Dish(String dishId, String categoryId, String dishName, double price, String categoryName) {
        this.dishId = dishId;
        this.categoryId = categoryId;
        this.dishName = dishName;
        this.price = price;
        this.categoryName = categoryName;
    }

    public String getDishId() { return dishId; }
    public void setDishId(String dishId) { this.dishId = dishId; }
    
    public String getCategoryId() { return categoryId; }
    public void setCategoryId(String categoryId) { this.categoryId = categoryId; }
    
    public String getDishName() { return dishName; }
    public void setDishName(String dishName) { this.dishName = dishName; }
    
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    
    // 4. GETTER & SETTER CHO TÊN DANH MỤC
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
}