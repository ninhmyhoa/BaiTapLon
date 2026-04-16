package controller;

import dal.MenuDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Dish;

@WebServlet(name = "DishServlet", urlPatterns = {"/dish-manager"})
public class DishServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        MenuDAO dao = new MenuDAO();
        String action = request.getParameter("action");

        if (action != null && action.equals("delete")) {
            dao.deleteDish(request.getParameter("id"));
            response.sendRedirect("dish-manager");
            return;
        }

        // Gửi cả danh sách Món ăn và Danh mục (để làm dropdown chọn Category khi thêm món)
        request.setAttribute("dishList", dao.getAllDishes());
        request.setAttribute("catList", dao.getAllCategories()); 
        request.getRequestDispatcher("dish_manager.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        MenuDAO dao = new MenuDAO();
        String action = request.getParameter("action");

        // Chỉ xử lý nghiệp vụ THÊM MỚI (add)
        if (action != null && action.equals("add")) {
            // Lúc này request.getParameter("dishId") sẽ là null, ta giao quyền cấp ID cho Database
            Dish d = new Dish(
                request.getParameter("dishId"),
                request.getParameter("categoryId"),
                request.getParameter("dishName"),
                Double.parseDouble(request.getParameter("price"))
            );
            dao.insertDish(d);
        }

        response.sendRedirect("dish-manager");
    }
}