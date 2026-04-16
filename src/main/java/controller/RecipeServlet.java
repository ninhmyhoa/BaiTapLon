package controller;
import dal.InventoryDAO; import dal.MenuDAO; import java.io.IOException; import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet; import javax.servlet.http.*; import model.Recipe;

@WebServlet(name = "RecipeServlet", urlPatterns = {"/recipe-manager"})
public class RecipeServlet extends HttpServlet {
    @Override protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); InventoryDAO dao = new InventoryDAO(); MenuDAO menuDao = new MenuDAO();
        if ("delete".equals(request.getParameter("action"))) { dao.deleteRecipe(request.getParameter("dishId"), request.getParameter("ingId")); response.sendRedirect("recipe-manager"); return; }
        request.setAttribute("recipeList", dao.getAllRecipes());
        request.setAttribute("dishList", menuDao.getAllDishes()); // Đổ dropdown Món ăn
        request.setAttribute("ingList", dao.getAllIngredients()); // Đổ dropdown Nguyên liệu
        request.getRequestDispatcher("recipe_manager.jsp").forward(request, response);
    }
    @Override 
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        InventoryDAO dao = new InventoryDAO();
        
        String action = request.getParameter("action");
        String dishId = request.getParameter("dishId");
        String ingredientId = request.getParameter("ingredientId");
        double inputQty = Double.parseDouble(request.getParameter("quantity"));
        
        // 1. Lấy đơn vị người dùng chọn trên giao diện (g, ml, kg...)
        String recipeUnit = request.getParameter("recipeUnit"); 

        // 2. TÌM ĐƠN VỊ GỐC CỦA NGUYÊN LIỆU TRONG KHO (Để biết đang dùng kg hay lít)
        String baseUnit = "";
        for (model.Ingredient i : dao.getAllIngredients()) {
            if (i.getIngredientId().equals(ingredientId)) {
                baseUnit = i.getUnit();
                break;
            }
        }

        // 3. LOGIC TỰ ĐỘNG QUY ĐỔI NGẦM (Khỏi cần đụng CSDL)
        double finalQty = inputQty; // Mặc định giữ nguyên
        if (recipeUnit != null && baseUnit != null) {
            String rU = recipeUnit.toLowerCase();
            String bU = baseUnit.toLowerCase();
            
            // Nếu khách nhập Gram (g), nhưng trong kho tính bằng Kilogram (kg) -> Chia 1000
            if (rU.equals("g") && bU.equals("kg")) {
                finalQty = inputQty / 1000.0;
            } 
            // Nếu khách nhập Mililit (ml), nhưng trong kho tính bằng Lít (l) -> Chia 1000
            else if (rU.equals("ml") && bU.equals("l")) {
                finalQty = inputQty / 1000.0;
            }
            // Các trường hợp khác (ví dụ: kg nhập kg, cái nhập cái) thì giữ nguyên con số
        }

        // 4. Lưu con số ĐÃ QUY ĐỔI vào đối tượng Recipe
        Recipe r = new Recipe(dishId, ingredientId, finalQty);

        if ("add".equals(action)) {
            dao.insertRecipe(r);
        } else if ("edit".equals(action)) {
            dao.updateRecipe(r);
        }
        
        response.sendRedirect("recipe-manager");
    }
}