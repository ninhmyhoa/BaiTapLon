package controller;

import dal.InventoryDAO; 
import dal.EmployeeDAO; 
import java.io.IOException; 
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet; 
import javax.servlet.http.*; 
import model.ImportBatch;

@WebServlet(name = "ImportBatchServlet", urlPatterns = {"/batch-manager"})
public class ImportBatchServlet extends HttpServlet {
    
    @Override 
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        InventoryDAO dao = new InventoryDAO(); 
        EmployeeDAO empDao = new EmployeeDAO();
        
        // ĐÃ XÓA TÍNH NĂNG "DELETE" Ở ĐÂY 
        // Bất khả xâm phạm: Phiếu nhập kho đã tạo là không thể xóa
        
        request.setAttribute("batchList", dao.getAllImportBatches());
        request.setAttribute("empList", empDao.getAllEmployees()); 
        request.setAttribute("ingList", dao.getAllIngredients());  
        request.getRequestDispatcher("import_batch_manager.jsp").forward(request, response);
    }
    
    @Override 
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        InventoryDAO dao = new InventoryDAO();
        
        // request.getParameter("batchId") sẽ là null vì ta đã bỏ ô nhập mã ở form Add
        ImportBatch b = new ImportBatch(
                request.getParameter("batchId"), 
                request.getParameter("employeeId"), 
                request.getParameter("ingredientId"),
                request.getParameter("importDate"), 
                request.getParameter("expirationDate"), 
                Double.parseDouble(request.getParameter("batchPrice")), 
                Double.parseDouble(request.getParameter("stockQuantity")));
                
        // CHỈ CHO PHÉP HÀNH ĐỘNG THÊM MỚI (ADD)
        if ("add".equals(request.getParameter("action"))) {
            dao.insertImportBatch(b);
        }
        
        // ĐÃ XÓA TÍNH NĂNG "EDIT" Ở ĐÂY
        // Bất khả xâm phạm: Không một ai được phép sửa đổi số liệu lô hàng đã nhập
        
        response.sendRedirect("batch-manager");
    }
}