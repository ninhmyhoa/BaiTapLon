package model;

public class Invoice {
    private int invoiceId;
    private String customerId;
    private String employeeId;
    private String createdTime;
    private String status; 
    private String employeeName; 
    
    // === BIẾN MỚI THÊM: CHỨA VỊ TRÍ PHÒNG/BÀN ===
    private String servingLocation; 

    public Invoice() {}

    // Constructor cũ 1 (giữ nguyên để tránh lỗi)
    public Invoice(int invoiceId, String customerId, String employeeId, String createdTime) {
        this.invoiceId = invoiceId; 
        this.customerId = customerId; 
        this.employeeId = employeeId; 
        this.createdTime = createdTime;
    }

    // Constructor cũ 2 (giữ nguyên để các form khác không bị lỗi)
    public Invoice(int invoiceId, String customerId, String employeeId, String createdTime, String status, String employeeName) {
        this.invoiceId = invoiceId;
        this.customerId = customerId;
        this.employeeId = employeeId;
        this.createdTime = createdTime;
        this.status = status;
        this.employeeName = employeeName;
    }

    // === CONSTRUCTOR MỚI NHẤT (Dùng để hiển thị lên bảng có kèm Vị trí bàn) ===
    public Invoice(int invoiceId, String customerId, String employeeId, String createdTime, String status, String employeeName, String servingLocation) {
        this.invoiceId = invoiceId;
        this.customerId = customerId;
        this.employeeId = employeeId;
        this.createdTime = createdTime;
        this.status = status;
        this.employeeName = employeeName;
        this.servingLocation = servingLocation; // Gán giá trị vị trí
    }

    // Các Get/Set gốc của bà
    public int getInvoiceId() { return invoiceId; } 
    public void setInvoiceId(int invoiceId) { this.invoiceId = invoiceId; }
    
    public String getCustomerId() { return customerId; } 
    public void setCustomerId(String customerId) { this.customerId = customerId; }
    
    public String getEmployeeId() { return employeeId; } 
    public void setEmployeeId(String employeeId) { this.employeeId = employeeId; }
    
    public String getCreatedTime() { return createdTime; } 
    public void setCreatedTime(String createdTime) { this.createdTime = createdTime; }
    
    public String getStatus() { return status; } 
    public void setStatus(String status) { this.status = status; }
    
    public String getEmployeeName() { return employeeName; } 
    public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }

    // === THÊM GET/SET CHO BIẾN VỊ TRÍ ===
    public String getServingLocation() { return servingLocation; }
    public void setServingLocation(String servingLocation) { this.servingLocation = servingLocation; }
}