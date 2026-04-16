package model;

public class BillDetail {
    private String dishName;
    private int quantity;
    private double price;
    private double subTotal;

    public BillDetail() {}
    public BillDetail(String dishName, int quantity, double price, double subTotal) {
        this.dishName = dishName; this.quantity = quantity; this.price = price; this.subTotal = subTotal;
    }
    public String getDishName() { return dishName; }
    public int getQuantity() { return quantity; }
    public double getPrice() { return price; }
    public double getSubTotal() { return subTotal; }
}