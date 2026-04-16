package model;

public class WorkShift {
    private String employeeId;
    private String loginTime;
    private String logoutTime;

    public WorkShift() {}
    public WorkShift(String employeeId, String loginTime, String logoutTime) {
        this.employeeId = employeeId; this.loginTime = loginTime; this.logoutTime = logoutTime;
    }
    public String getEmployeeId() { return employeeId; } public void setEmployeeId(String employeeId) { this.employeeId = employeeId; }
    public String getLoginTime() { return loginTime; } public void setLoginTime(String loginTime) { this.loginTime = loginTime; }
    public String getLogoutTime() { return logoutTime; } public void setLogoutTime(String logoutTime) { this.logoutTime = logoutTime; }
}