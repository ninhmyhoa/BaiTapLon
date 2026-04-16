package controller;

import dal.MenuDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Category;

@WebServlet(name = "CategoryServlet", urlPatterns = {"/category-manager"})
public class CategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        MenuDAO dao = new MenuDAO();
        String action = request.getParameter("action");

        if (action != null && action.equals("delete")) {
            dao.deleteCategory(request.getParameter("id"));
            response.sendRedirect("category-manager");
            return;
        }

        request.setAttribute("catList", dao.getAllCategories());
        request.getRequestDispatcher("category_manager.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        MenuDAO dao = new MenuDAO();
        String action = request.getParameter("action");

        // Khi action="add", tham số categoryId sẽ tự nhận null từ form.
        Category c = new Category(request.getParameter("categoryId"), request.getParameter("categoryName"));

        if (action.equals("add")) {
            dao.insertCategory(c);
        } else if (action.equals("edit")) {
            dao.updateCategory(c);
        }

        response.sendRedirect("category-manager");
    }
}