package model;

public class ImportBatch {
    private String batchId;
    private String employeeId;
    private String ingredientId;
    private String importDate;
    private String expirationDate;
    private double batchPrice;
    private double stockQuantity;
    
    // THÊM 2 BIẾN ĐỂ HIỂN THỊ TÊN LÊN WEB
    private String employeeName;
    private String ingredientName;

    public ImportBatch() {}

    // Constructor cũ (Giữ nguyên để hàm Thêm Mới không bị lỗi)
    public ImportBatch(String batchId, String employeeId, String ingredientId, String importDate, String expirationDate, double batchPrice, double stockQuantity) {
        this.batchId = batchId;
        this.employeeId = employeeId;
        this.ingredientId = ingredientId;
        this.importDate = importDate;
        this.expirationDate = expirationDate;
        this.batchPrice = batchPrice;
        this.stockQuantity = stockQuantity;
    }

    // Constructor mới (Dùng để lấy dữ liệu có cả Tên hiển thị lên Bảng)
    public ImportBatch(String batchId, String employeeId, String ingredientId, String importDate, String expirationDate, double batchPrice, double stockQuantity, String employeeName, String ingredientName) {
        this.batchId = batchId;
        this.employeeId = employeeId;
        this.ingredientId = ingredientId;
        this.importDate = importDate;
        this.expirationDate = expirationDate;
        this.batchPrice = batchPrice;
        this.stockQuantity = stockQuantity;
        this.employeeName = employeeName;
        this.ingredientName = ingredientName;
    }

    // ... CÁC GETTER VÀ SETTER CŨ ...
    public String getBatchId() { return batchId; }
    public void setBatchId(String batchId) { this.batchId = batchId; }
    public String getEmployeeId() { return employeeId; }
    public void setEmployeeId(String employeeId) { this.employeeId = employeeId; }
    public String getIngredientId() { return ingredientId; }
    public void setIngredientId(String ingredientId) { this.ingredientId = ingredientId; }
    public String getImportDate() { return importDate; }
    public void setImportDate(String importDate) { this.importDate = importDate; }
    public String getExpirationDate() { return expirationDate; }
    public void setExpirationDate(String expirationDate) { this.expirationDate = expirationDate; }
    public double getBatchPrice() { return batchPrice; }
    public void setBatchPrice(double batchPrice) { this.batchPrice = batchPrice; }
    public double getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(double stockQuantity) { this.stockQuantity = stockQuantity; }

    // GETTER VÀ SETTER CHO 2 BIẾN TÊN MỚI
    public String getEmployeeName() { return employeeName; }
    public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }
    public String getIngredientName() { return ingredientName; }
    public void setIngredientName(String ingredientName) { this.ingredientName = ingredientName; }
}