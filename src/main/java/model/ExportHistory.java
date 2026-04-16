package model;

public class ExportHistory {
    private String exportDate;
    private String employeeId;
    private String batchId;
    private double exportQuantity;
    private String exportPurpose;
    
    // THÊM 3 BIẾN NÀY ĐỂ HIỂN THỊ LÊN BẢNG GIAO DIỆN
    private String employeeName;
    private String ingredientName;
    private String unit;

    public ExportHistory() {}

    // Constructor 1: Dùng để Insert vào Database
    public ExportHistory(String exportDate, String employeeId, String batchId, double exportQuantity, String exportPurpose) {
        this.exportDate = exportDate; 
        this.employeeId = employeeId; 
        this.batchId = batchId; 
        this.exportQuantity = exportQuantity; 
        this.exportPurpose = exportPurpose;
    }

    // Constructor 2: Dùng để kéo dữ liệu đầy đủ lên Web
    public ExportHistory(String exportDate, String employeeId, String batchId, double exportQuantity, String exportPurpose, String employeeName, String ingredientName, String unit) {
        this.exportDate = exportDate;
        this.employeeId = employeeId;
        this.batchId = batchId;
        this.exportQuantity = exportQuantity;
        this.exportPurpose = exportPurpose;
        this.employeeName = employeeName;
        this.ingredientName = ingredientName;
        this.unit = unit;
    }

    // Getters & Setters cũ
    public String getExportDate(){return exportDate;} public void setExportDate(String d){exportDate=d;}
    public String getEmployeeId(){return employeeId;} public void setEmployeeId(String e){employeeId=e;}
    public String getBatchId(){return batchId;} public void setBatchId(String b){batchId=b;}
    public double getExportQuantity(){return exportQuantity;} public void setExportQuantity(double q){exportQuantity=q;}
    public String getExportPurpose(){return exportPurpose;} public void setExportPurpose(String p){exportPurpose=p;}
    
    // Getters & Setters mới
    public String getEmployeeName() { return employeeName; } public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }
    public String getIngredientName() { return ingredientName; } public void setIngredientName(String ingredientName) { this.ingredientName = ingredientName; }
    public String getUnit() { return unit; } public void setUnit(String unit) { this.unit = unit; }
}