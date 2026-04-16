package controller;

import dal.FacilityDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import model.Customer;

@WebServlet(name = "CustomerServlet", urlPatterns = {"/customer-manager"})
public class CustomerServlet extends HttpServlet {
    @Override 
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        FacilityDAO dao = new FacilityDAO();
        String action = request.getParameter("action");
        if ("delete".equals(action)) { 
            dao.deleteCustomer(request.getParameter("id")); 
            response.sendRedirect("customer-manager"); 
            return; 
        }
        request.setAttribute("custList", dao.getAllCustomers());
        request.getRequestDispatcher("customer_manager.jsp").forward(request, response);
    }
    
    @Override 
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        FacilityDAO dao = new FacilityDAO();
        
        // Trong trường hợp 'add', tham số 'customerId' sẽ bị null vì JSP không còn input này nữa.
        // Đây chính xác là điều ta muốn để MySQL tự nhảy ID.
        Customer c = new Customer(
            request.getParameter("customerId"), 
            request.getParameter("fullName"), 
            request.getParameter("phone"), 
            request.getParameter("email")
        );
        
        if ("add".equals(request.getParameter("action"))) {
            dao.insertCustomer(c);
        } else if ("edit".equals(request.getParameter("action"))) {
            dao.updateCustomer(c);
        }
        
        response.sendRedirect("customer-manager");
    }
}