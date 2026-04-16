package model;

public class PreOrder {
    private String reservationId;
    private String dishId;
    private int quantity;
    private String note;

    public PreOrder() {}
    public PreOrder(String reservationId, String dishId, int quantity, String note) {
        this.reservationId = reservationId; this.dishId = dishId; this.quantity = quantity; this.note = note;
    }
    public String getReservationId() { return reservationId; } public void setReservationId(String r) { reservationId = r; }
    public String getDishId() { return dishId; } public void setDishId(String d) { dishId = d; }
    public int getQuantity() { return quantity; } public void setQuantity(int q) { quantity = q; }
    public String getNote() { return note; } public void setNote(String n) { note = n; }
}