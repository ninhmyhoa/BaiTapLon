package controller;

import dal.BillingDAO; 
import dal.EmployeeDAO; 
import dal.FacilityDAO; 
import java.io.IOException; 
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet; 
import javax.servlet.http.*; 
import model.Invoice;

@WebServlet(name = "InvoiceServlet", urlPatterns = {"/invoice-manager"})
public class InvoiceServlet extends HttpServlet {
    
    @Override 
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        BillingDAO dao = new BillingDAO(); 
        EmployeeDAO empDao = new EmployeeDAO(); 
        FacilityDAO facDao = new FacilityDAO();

        // LOGIC LIÊN KẾT: Cất tạm tọa độ bàn từ TableServlet gửi sang
        String rId = request.getParameter("roomId");
        String tNum = request.getParameter("tableNumber");
        if (rId != null && tNum != null) {
            HttpSession session = request.getSession();
            session.setAttribute("TEMP_ROOM", rId);
            session.setAttribute("TEMP_TABLE", tNum);
        }

        if ("delete".equals(request.getParameter("action"))) { 
            dao.deleteInvoice(Integer.parseInt(request.getParameter("id"))); 
            response.sendRedirect("invoice-manager"); 
            return; 
        }
        
        // ==============================================================
        // ĐÃ SỬA CHỖ NÀY: Đổi "invList" thành "invoiceList" cho khớp JSP
        // ==============================================================
        request.setAttribute("invoiceList", dao.getAllInvoices()); 
        request.setAttribute("empList", empDao.getAllEmployees()); 
        request.setAttribute("custList", facDao.getAllCustomers());
        request.getRequestDispatcher("invoice_manager.jsp").forward(request, response);
    }
    
    @Override 
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        BillingDAO dao = new BillingDAO();
        String action = request.getParameter("action");
        
        int id = request.getParameter("invoiceId") != null && !request.getParameter("invoiceId").isEmpty() ? Integer.parseInt(request.getParameter("invoiceId")) : 0;
        
        String createdTime = request.getParameter("createdTime");
        if (createdTime != null) {
            createdTime = createdTime.replace("T", " ");
        }

        Invoice inv = new Invoice(id, request.getParameter("customerId"), request.getParameter("employeeId"), createdTime);
        
        if ("add".equals(action)) {
            int newInvId = -1;
            try {
                class LocalDAO extends dal.DBContext { public java.sql.Connection getC() { return this.connection; } }
                java.sql.Connection conn = new LocalDAO().getC();
                java.sql.PreparedStatement ps = conn.prepareStatement("INSERT INTO INVOICE (Customer_ID, Employee_ID, Created_time) VALUES (?, ?, ?)", java.sql.Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, (inv.getCustomerId() == null || inv.getCustomerId().isEmpty()) ? null : inv.getCustomerId());
                ps.setString(2, inv.getEmployeeId());
                ps.setString(3, inv.getCreatedTime());
                ps.executeUpdate();
                
                java.sql.ResultSet rs = ps.getGeneratedKeys();
                if(rs.next()) newInvId = rs.getInt(1);
            } catch (Exception e) { 
                e.printStackTrace(); 
                dao.insertInvoice(inv); 
            }
            
            HttpSession session = request.getSession();
            String rId = (String) session.getAttribute("TEMP_ROOM");
            String tNum = (String) session.getAttribute("TEMP_TABLE");
            
            session.removeAttribute("TEMP_ROOM");
            session.removeAttribute("TEMP_TABLE");
            session.removeAttribute("MERGED_TABLES");

            if (newInvId != -1 && rId != null && tNum != null) {
                response.sendRedirect("invoice-detail-manager?invoiceId=" + newInvId + "&roomId=" + rId + "&tableNumber=" + tNum);
                return;
            }
        } 
        else if ("edit".equals(action)) { 
            dao.updateInvoice(inv); 
        }
        
        response.sendRedirect("invoice-manager"); // Sửa lại redirect về đúng trang hóa đơn
    }
}