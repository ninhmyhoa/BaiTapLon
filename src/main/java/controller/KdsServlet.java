package controller;

import dal.BillingDAO;
import dal.MenuDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "KdsServlet", urlPatterns = {"/chef-kds"})
public class KdsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        BillingDAO dao = new BillingDAO();

        // Xử lý khi Chef bấm nút "Đang nấu" hoặc "Đã xong"
        if ("updateStatus".equals(action)) {
            int invId = Integer.parseInt(request.getParameter("invId"));
            
            // ĐÃ SỬA: Ép kiểu sang số nguyên (int) để không bị lỗi đỏ
            int dishId = Integer.parseInt(request.getParameter("dishId")); 
            int roomId = Integer.parseInt(request.getParameter("roomId")); 
            
            int tableNum = Integer.parseInt(request.getParameter("tableNum"));
            String newStatus = request.getParameter("status");
            
            dao.updateKitchenStatus(invId, dishId, roomId, tableNum, newStatus);
            response.sendRedirect("chef-kds"); // Load lại màn hình
            return;
        }

        // Truyền danh sách món chờ nấu và danh sách tên món ăn sang JSP
        request.setAttribute("pendingList", dao.getPendingOrders());
        request.setAttribute("dishList", new MenuDAO().getAllDishes());
        request.getRequestDispatcher("chef_kds.jsp").forward(request, response);
    }
}