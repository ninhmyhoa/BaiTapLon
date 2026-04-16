package model;

public class Room {
    private String roomId;
    private int maxCapacity;

    public Room() {}
    public Room(String roomId, int maxCapacity) {
        this.roomId = roomId; this.maxCapacity = maxCapacity;
    }

    public String getRoomId() { return roomId; } public void setRoomId(String roomId) { this.roomId = roomId; }
    public int getMaxCapacity() { return maxCapacity; } public void setMaxCapacity(int maxCapacity) { this.maxCapacity = maxCapacity; }
}