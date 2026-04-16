package controller;

import dal.InventoryDAO; 
import java.io.IOException; 
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet; 
import javax.servlet.http.*; 
import model.Ingredient;

@WebServlet(name = "IngredientServlet", urlPatterns = {"/ingredient-manager"})
public class IngredientServlet extends HttpServlet {
    @Override 
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        InventoryDAO dao = new InventoryDAO();
        if ("delete".equals(request.getParameter("action"))) { 
            dao.deleteIngredient(request.getParameter("id")); 
            response.sendRedirect("ingredient-manager"); 
            return; 
        }
        request.setAttribute("ingList", dao.getAllIngredients());
        request.getRequestDispatcher("ingredient_manager.jsp").forward(request, response);
    }
    
    @Override 
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        InventoryDAO dao = new InventoryDAO();
        
        // Khi tạo mới (add), tham số ingredientId sẽ là null, giao cho DB tự sinh số.
        Ingredient i = new Ingredient(
            request.getParameter("ingredientId"), 
            request.getParameter("ingredientName"), 
            Double.parseDouble(request.getParameter("minStock")), 
            request.getParameter("unit")
        );
        
        if ("add".equals(request.getParameter("action"))) {
            dao.insertIngredient(i);
        } else if ("edit".equals(request.getParameter("action"))) {
            dao.updateIngredient(i);
        }
        
        response.sendRedirect("ingredient-manager");
    }
}