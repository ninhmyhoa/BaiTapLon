package controller;

import dal.EmployeeDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Employee;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiển thị trang đăng nhập
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // ĐỔI TỪ employeeId SANG email ĐỂ KHỚP VỚI FORM login.jsp
        String email = request.getParameter("email"); 
        String pass = request.getParameter("password");
        
        EmployeeDAO dao = new EmployeeDAO();
        // Giả định hàm checkLogin trong EmployeeDAO giờ sẽ nhận (email, password)
        Employee emp = dao.checkLogin(email, pass);
        
        if (emp != null) {
            // Đăng nhập thành công, lưu vào session
            HttpSession session = request.getSession();
            session.setAttribute("user", emp);
            
            // Phân quyền điều hướng dựa trên vị trí (Position)
            String role = emp.getPosition().toUpperCase();
            if (role.equals("MANAGER")) {
                response.sendRedirect("manager_dashboard.jsp");
            } else if (role.equals("WAITER")) {
                response.sendRedirect("waiter_dashboard.jsp");
            } else if (role.equals("CHEF")) {
                response.sendRedirect("chef_dashboard.jsp");
            } else {
                request.setAttribute("error", "Vai trò không hợp lệ trong hệ thống!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else {
            // Thông báo lỗi nếu sai tài khoản
            request.setAttribute("error", "Email hoặc Mật khẩu không chính xác!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}