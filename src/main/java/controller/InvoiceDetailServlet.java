package controller;
import dal.BillingDAO; import dal.EmployeeDAO; import dal.MenuDAO; import dal.FacilityDAO; import java.io.IOException; import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet; import javax.servlet.http.*; import model.InvoiceDetail;

@WebServlet(name = "InvoiceDetailServlet", urlPatterns = {"/invoice-detail-manager"})
public class InvoiceDetailServlet extends HttpServlet {
   @Override 
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        BillingDAO dao = new BillingDAO();
        
        if ("delete".equals(request.getParameter("action"))) { 
            // ĐÃ SỬA: Ép kiểu int cho dishId và roomId
            dao.deleteInvoiceDetail(
                Integer.parseInt(request.getParameter("invId")), 
                Integer.parseInt(request.getParameter("dishId")), 
                Integer.parseInt(request.getParameter("roomId")), 
                Integer.parseInt(request.getParameter("tableNum"))
            ); 
            response.sendRedirect("invoice-detail-manager"); return; 
        }
        
        // 1. Kéo các dữ liệu cũ của bạn
        request.setAttribute("detailList", dao.getAllInvoiceDetails());
        request.setAttribute("invList", dao.getAllInvoices()); 
        request.setAttribute("empList", new EmployeeDAO().getAllEmployees());
        
        // 2. BỔ SUNG: Kéo dữ liệu Phòng và Bàn từ FacilityDAO
        FacilityDAO facilityDao = new FacilityDAO();
        request.setAttribute("roomList", facilityDao.getAllRooms());     // Tên hàm getAllRooms() tuỳ thuộc vào cách bạn viết trong DAO
        request.setAttribute("tableList", facilityDao.getAllTables());   // Tên hàm getAllTables() tuỳ thuộc vào cách bạn viết trong DAO

        // 3. Kéo dữ liệu Món ăn & Định lượng
        MenuDAO menuDao = new MenuDAO();
        java.util.List<model.Dish> dishes = menuDao.getAllDishes();
        java.util.HashMap<String, Integer> maxPortionsMap = new java.util.HashMap<>();
        
        for(model.Dish d : dishes) {
            // Lấy số lượng dĩa tối đa nấu được từ hàm bà vừa viết
            maxPortionsMap.put(d.getDishId(), menuDao.getMaxPortions(d.getDishId()));
        }
        
        request.setAttribute("dishList", dishes);
        request.setAttribute("maxPortionsMap", maxPortionsMap); 
        
        request.getRequestDispatcher("invoice_detail_manager.jsp").forward(request, response);
    }

    @Override 
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); BillingDAO dao = new BillingDAO(); MenuDAO menuDao = new MenuDAO();
        
        try {
            String invStr = request.getParameter("invoiceId");
            String tableStr = request.getParameter("tableNumber");
            String qtyStr = request.getParameter("quantity");
            
            int invoiceId = (invStr != null && !invStr.isEmpty()) ? Integer.parseInt(invStr) : 0;
            int tableNumber = (tableStr != null && !tableStr.isEmpty()) ? Integer.parseInt(tableStr) : 0;
            int quantity = (qtyStr != null && !qtyStr.isEmpty()) ? Integer.parseInt(qtyStr) : 0;

            InvoiceDetail d = new InvoiceDetail(
                invoiceId, 
                Integer.parseInt(request.getParameter("employeeId")), 
                Integer.parseInt(request.getParameter("dishId")),     
                Integer.parseInt(request.getParameter("roomId")),     
                tableNumber, 
                quantity, 
                request.getParameter("note"), 
                request.getParameter("kitchenStatus")
            );
            
            String action = request.getParameter("action");
            if ("add".equals(action)) {
                dao.insertInvoiceDetail(d); 
                
                // ĐÃ SỬA: Ép ngược từ Số về Chữ để hàm của MenuDAO không bị báo đỏ
                menuDao.deductInventoryForDish(String.valueOf(d.getDishId()), d.getQuantity());
                
            } else if ("edit".equals(action)) {
                dao.updateInvoiceDetail(d);
            }
        } catch (Exception e) {
            System.out.println("Lỗi xử lý Gọi món: " + e.getMessage());
        }
        
        response.sendRedirect("invoice-detail-manager");
    }
}