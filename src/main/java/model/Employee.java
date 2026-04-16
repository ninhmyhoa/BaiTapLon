package model;

public class Employee {
    private String employeeId;
    private String firstName;
    private String lastName;
    private String street;
    private String district;
    private String city;
    private String phone;
    private String email;
    private String position;
    private String password;

    // Constructor rỗng
    public Employee() {
    }

    // Constructor đầy đủ tham số
    public Employee(String employeeId, String firstName, String lastName, String street, 
                    String district, String city, String phone, String email, 
                    String position, String password) {
        this.employeeId = employeeId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.street = street;
        this.district = district;
        this.city = city;
        this.phone = phone;
        this.email = email;
        this.position = position;
        this.password = password;
    }

    // Getters và Setters
    public String getEmployeeId() { return employeeId; }
    public void setEmployeeId(String employeeId) { this.employeeId = employeeId; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getStreet() { return street; }
    public void setStreet(String street) { this.street = street; }

    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    // Hàm gộp tên để hiển thị trên web cho lẹ (Không lưu vào CSDL)
    public String getFullName() {
        return this.lastName + " " + this.firstName;
    }
}