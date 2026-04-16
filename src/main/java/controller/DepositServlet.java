package controller;
import dal.BookingDAO; import java.io.IOException; import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet; import javax.servlet.http.*; import model.Deposit;

@WebServlet(name = "DepositServlet", urlPatterns = {"/deposit-manager"})
public class DepositServlet extends HttpServlet {
    @Override protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); BookingDAO dao = new BookingDAO();
        if ("delete".equals(request.getParameter("action"))) { dao.deleteDeposit(request.getParameter("resId"), Integer.parseInt(request.getParameter("turn"))); response.sendRedirect("deposit-manager"); return; }
        request.setAttribute("depList", dao.getAllDeposits()); request.setAttribute("resList", dao.getAllReservations());
        request.getRequestDispatcher("deposit_manager.jsp").forward(request, response);
    }
    @Override protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); BookingDAO dao = new BookingDAO();
        Deposit d = new Deposit(request.getParameter("reservationId"), Double.parseDouble(request.getParameter("amount")), request.getParameter("status"), Integer.parseInt(request.getParameter("depositTurn")));
        if ("add".equals(request.getParameter("action"))) dao.insertDeposit(d);
        else if ("edit".equals(request.getParameter("action"))) dao.updateDeposit(d);
        response.sendRedirect("deposit-manager");
    }
}