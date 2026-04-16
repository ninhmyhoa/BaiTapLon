package model;

public class InvoiceDetail {
    private int invoiceId;
    private int employeeId;  
    private int dishId;      
    private int roomId;      
    private int tableNumber;
    private int quantity;
    private String note;
    private String kitchenStatus;
    
    // THÊM 2 BIẾN ĐỂ HIỂN THỊ TÊN LÊN GIAO DIỆN
    private String dishName;
    private String employeeName;

    public InvoiceDetail() {}
    
    // Constructor cũ (Giữ lại để các chức năng thêm/sửa/xóa không bị lỗi)
    public InvoiceDetail(int invoiceId, int employeeId, int dishId, int roomId, int tableNumber, int quantity, String note, String kitchenStatus) {
        this.invoiceId = invoiceId; 
        this.employeeId = employeeId; 
        this.dishId = dishId; 
        this.roomId = roomId; 
        this.tableNumber = tableNumber; 
        this.quantity = quantity; 
        this.note = note; 
        this.kitchenStatus = kitchenStatus;
    }

    // Constructor mới đầy đủ (Dùng để lấy dữ liệu có chứa Tên hiển thị lên Bảng)
    public InvoiceDetail(int invoiceId, int employeeId, int dishId, int roomId, int tableNumber, int quantity, String note, String kitchenStatus, String dishName, String employeeName) {
        this.invoiceId = invoiceId;
        this.employeeId = employeeId;
        this.dishId = dishId;
        this.roomId = roomId;
        this.tableNumber = tableNumber;
        this.quantity = quantity;
        this.note = note;
        this.kitchenStatus = kitchenStatus;
        this.dishName = dishName;
        this.employeeName = employeeName;
    }
    
    // Getters & Setters gốc
    public int getInvoiceId(){return invoiceId;} public void setInvoiceId(int i){invoiceId=i;}
    public int getEmployeeId(){return employeeId;} public void setEmployeeId(int e){employeeId=e;}
    public int getDishId(){return dishId;} public void setDishId(int d){dishId=d;}
    public int getRoomId(){return roomId;} public void setRoomId(int r){roomId=r;}
    public int getTableNumber(){return tableNumber;} public void setTableNumber(int t){tableNumber=t;}
    public int getQuantity(){return quantity;} public void setQuantity(int q){quantity=q;}
    public String getNote(){return note;} public void setNote(String n){note=n;}
    public String getKitchenStatus(){return kitchenStatus;} public void setKitchenStatus(String k){kitchenStatus=k;}

    // Getters & Setters cho 2 biến Tên mới
    public String getDishName() { return dishName; } public void setDishName(String dishName) { this.dishName = dishName; }
    public String getEmployeeName() { return employeeName; } public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }
}