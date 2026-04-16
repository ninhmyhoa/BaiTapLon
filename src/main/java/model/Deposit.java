package model;

public class Deposit {
    private String reservationId;
    private double amount;
    private String status;
    private int depositTurn;

    public Deposit() {}
    public Deposit(String reservationId, double amount, String status, int depositTurn) {
        this.reservationId = reservationId; this.amount = amount; this.status = status; this.depositTurn = depositTurn;
    }
    public String getReservationId() { return reservationId; } public void setReservationId(String r) { reservationId = r; }
    public double getAmount() { return amount; } public void setAmount(double a) { amount = a; }
    public String getStatus() { return status; } public void setStatus(String s) { status = s; }
    public int getDepositTurn() { return depositTurn; } public void setDepositTurn(int d) { depositTurn = d; }
}