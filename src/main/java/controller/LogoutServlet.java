package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// Cái urlPatterns = {"/logout"} này chính là thứ Tomcat đang tìm kiếm đấy!
@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        // 1. Lấy session hiện tại (truyền false để không tự động tạo mới nếu chưa có)
        HttpSession session = request.getSession(false);
        
        // 2. Nếu session tồn tại, tiến hành hủy nó đi
        if (session != null) {
            session.invalidate(); 
            // Lệnh invalidate() cực kỳ quan trọng, nó sẽ xóa sạch:
            // - Tài khoản người dùng đang đăng nhập
            // - Các dữ liệu tạm (như tiền cọc, giỏ hàng, bàn đang gộp...)
        }
        
        // 3. Đá người dùng về lại trang đăng nhập
        // Lưu ý: Đổi "login.jsp" thành đúng tên file trang đăng nhập của bạn nhé!
        response.sendRedirect("login.jsp"); 
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Đăng xuất thường chỉ dùng phương thức GET qua thẻ <a> nên có thể gọi thẳng doGet
        doGet(request, response);
    }
}