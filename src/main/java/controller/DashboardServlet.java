package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Employee;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Employee emp = (Employee) session.getAttribute("user");
        
        // Nếu bị mất session (hết hạn đăng nhập), đuổi về trang Login
        if (emp == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Lấy chức vụ, in hoa toàn bộ và xóa khoảng trắng thừa để so sánh cho chuẩn
        String role = emp.getPosition().toUpperCase().trim();
        
        if (role.equals("MANAGER")) {
            response.sendRedirect("manager_dashboard.jsp");
        } else if (role.equals("WAITER")) {
            response.sendRedirect("waiter_dashboard.jsp");
        } else if (role.equals("CHEF")) {
            response.sendRedirect("chef_dashboard.jsp");
        } else {
            response.sendRedirect("login.jsp"); // Đề phòng lỗi lạ
        }
    }
}