package model;

public class Occupies {
    private String reservationId;
    private String roomId;
    private int tableNumber;

    public Occupies() {}

    public Occupies(String reservationId, String roomId, int tableNumber) {
        this.reservationId = reservationId;
        this.roomId = roomId;
        this.tableNumber = tableNumber;
    }

    public String getReservationId() { return reservationId; }
    public void setReservationId(String reservationId) { this.reservationId = reservationId; }
    public String getRoomId() { return roomId; }
    public void setRoomId(String roomId) { this.roomId = roomId; }
    public int getTableNumber() { return tableNumber; }
    public void setTableNumber(int tableNumber) { this.tableNumber = tableNumber; }
}