package model;

public class PriceHistory {
    private String employeeId; 
    private String appliedTime;
    private String dishId;
    private double price;
    
    // THÊM 2 BIẾN NÀY ĐỂ HIỂN THỊ LÊN BẢNG WEB CHO ĐẸP
    private String dishName;
    private String employeeName;

    public PriceHistory() {}

    // Constructor chuẩn để lưu database
    public PriceHistory(String employeeId, String appliedTime, String dishId, double price) {
        this.employeeId = employeeId; 
        this.appliedTime = appliedTime; 
        this.dishId = dishId; 
        this.price = price;
    }

    // Constructor mở rộng dùng để kéo dữ liệu lên Web
    public PriceHistory(String employeeId, String appliedTime, String dishId, double price, String dishName, String employeeName) {
        this.employeeId = employeeId;
        this.appliedTime = appliedTime;
        this.dishId = dishId;
        this.price = price;
        this.dishName = dishName;
        this.employeeName = employeeName;
    }

    public String getEmployeeId() { return employeeId; } public void setEmployeeId(String employeeId) { this.employeeId = employeeId; }
    public String getAppliedTime() { return appliedTime; } public void setAppliedTime(String appliedTime) { this.appliedTime = appliedTime; }
    public String getDishId() { return dishId; } public void setDishId(String dishId) { this.dishId = dishId; }
    public double getPrice() { return price; } public void setPrice(double price) { this.price = price; }
    
    // Getter & Setter cho 2 biến mới
    public String getDishName() { return dishName; } public void setDishName(String dishName) { this.dishName = dishName; }
    public String getEmployeeName() { return employeeName; } public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }
}