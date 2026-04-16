package controller;
import dal.HistoryDAO; 
import dal.EmployeeDAO; 
import dal.MenuDAO; 
import java.io.IOException; 
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet; 
import javax.servlet.http.*; 
import model.PriceHistory;

@WebServlet(name = "PriceHistoryServlet", urlPatterns = {"/price-history-manager"})
public class PriceHistoryServlet extends HttpServlet {
    @Override 
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        HistoryDAO dao = new HistoryDAO(); 
        EmployeeDAO empDao = new EmployeeDAO(); 
        MenuDAO menuDao = new MenuDAO();
        
        if ("delete".equals(request.getParameter("action"))) { 
            dao.deletePriceHistory(request.getParameter("dishId"), request.getParameter("time")); 
            response.sendRedirect("price-history-manager"); 
            return; 
        }
        
        // SỬA "historyList" THÀNH "priceList" Ở ĐÂY NÈ BÀ
        request.setAttribute("priceList", dao.getAllPriceHistories()); 
        
        request.setAttribute("empList", empDao.getAllEmployees()); 
        request.setAttribute("dishList", menuDao.getAllDishes());
        request.getRequestDispatcher("price_history_manager.jsp").forward(request, response);
    }
    
    @Override 
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        HistoryDAO dao = new HistoryDAO();
        PriceHistory p = new PriceHistory(request.getParameter("employeeId"), request.getParameter("appliedTime"), request.getParameter("dishId"), Double.parseDouble(request.getParameter("price")));
        if ("add".equals(request.getParameter("action"))) dao.insertPriceHistory(p);
        else if ("edit".equals(request.getParameter("action"))) dao.updatePriceHistory(p);
        response.sendRedirect("price-history-manager");
    }
}