package controller;
import dal.BookingDAO; import dal.MenuDAO; import java.io.IOException; import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet; import javax.servlet.http.*; import model.PreOrder;

@WebServlet(name = "PreOrderServlet", urlPatterns = {"/preorder-manager"})
public class PreOrderServlet extends HttpServlet {
    @Override protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); BookingDAO dao = new BookingDAO(); MenuDAO menuDao = new MenuDAO();
        if ("delete".equals(request.getParameter("action"))) { dao.deletePreOrder(request.getParameter("resId"), request.getParameter("dishId")); response.sendRedirect("preorder-manager"); return; }
        request.setAttribute("preList", dao.getAllPreOrders()); request.setAttribute("resList", dao.getAllReservations()); request.setAttribute("dishList", menuDao.getAllDishes());
        request.getRequestDispatcher("preorder_manager.jsp").forward(request, response);
    }
    @Override protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); BookingDAO dao = new BookingDAO();
        PreOrder p = new PreOrder(request.getParameter("reservationId"), request.getParameter("dishId"), Integer.parseInt(request.getParameter("quantity")), request.getParameter("note"));
        if ("add".equals(request.getParameter("action"))) dao.insertPreOrder(p);
        else if ("edit".equals(request.getParameter("action"))) dao.updatePreOrder(p);
        response.sendRedirect("preorder-manager");
    }
}