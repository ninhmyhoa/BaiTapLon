package model;

public class DiningTable {
    private String roomId;
    private int tableNumber;
    private String status;

    public DiningTable() {}
    public DiningTable(String roomId, int tableNumber, String status) {
        this.roomId = roomId; 
        this.tableNumber = tableNumber; 
        this.status = status;
    }

    public String getRoomId() { return roomId; } 
    public void setRoomId(String roomId) { this.roomId = roomId; }
    public int getTableNumber() { return tableNumber; } 
    public void setTableNumber(int tableNumber) { this.tableNumber = tableNumber; }
    public String getStatus() { return status; } 
    public void setStatus(String status) { this.status = status; }
}