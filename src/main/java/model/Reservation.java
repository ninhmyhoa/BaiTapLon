package model;

public class Reservation {
    private String reservationId;
    private String employeeId;
    private String customerId;
    private String createdTime;
    private String arrivalTime;
    private int guestCount;
    
    // 1. CHẮC CHẮN PHẢI CÓ DÒNG NÀY
    private String status; 

    public Reservation() {}

    // Constructor 7 tham số (Hứng dữ liệu từ DAO)
    public Reservation(String reservationId, String employeeId, String customerId, String createdTime, String arrivalTime, int guestCount, String status) {
        this.reservationId = reservationId;
        this.employeeId = employeeId;
        this.customerId = customerId;
        this.createdTime = createdTime;
        this.arrivalTime = arrivalTime;
        this.guestCount = guestCount;
        this.status = status;
    }

    // Constructor 6 tham số (Cũ - giữ lại để không lỗi code khác)
    public Reservation(String reservationId, String employeeId, String customerId, String createdTime, String arrivalTime, int guestCount) {
        this.reservationId = reservationId;
        this.employeeId = employeeId;
        this.customerId = customerId;
        this.createdTime = createdTime;
        this.arrivalTime = arrivalTime;
        this.guestCount = guestCount;
    }

    // 2. QUAN TRỌNG NHẤT: PHẢI CÓ HÀM NÀY
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // ... Các hàm Getter/Setter cũ giữ nguyên ...
    public String getReservationId() { return reservationId; }
    public String getEmployeeId() { return employeeId; }
    public String getCustomerId() { return customerId; }
    public String getCreatedTime() { return createdTime; }
    public String getArrivalTime() { return arrivalTime; }
    public int getGuestCount() { return guestCount; }
}