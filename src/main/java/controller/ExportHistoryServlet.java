package controller;

import dal.HistoryDAO; 
import dal.EmployeeDAO; 
import dal.InventoryDAO; 
import java.io.IOException; 
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet; 
import javax.servlet.http.*; 
import model.ExportHistory;

@WebServlet(name = "ExportHistoryServlet", urlPatterns = {"/export-history-manager"})
public class ExportHistoryServlet extends HttpServlet {
    
    @Override 
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        HistoryDAO dao = new HistoryDAO(); 
        EmployeeDAO empDao = new EmployeeDAO(); 
        InventoryDAO invDao = new InventoryDAO();
        
        if ("delete".equals(request.getParameter("action"))) { 
            dao.deleteExportHistory(request.getParameter("time"), request.getParameter("batchId")); 
            response.sendRedirect("export-history-manager"); 
            return; 
        }
        
        request.setAttribute("exportList", dao.getAllExportHistories()); 
        request.setAttribute("empList", empDao.getAllEmployees()); 
        request.setAttribute("batchList", invDao.getAllImportBatches());
        request.getRequestDispatcher("export_history_manager.jsp").forward(request, response);
    }
    
    @Override 
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        HistoryDAO dao = new HistoryDAO();
        InventoryDAO invDao = new InventoryDAO(); // Đã thêm InventoryDAO để gọi hàm trừ kho
        
        // Chuẩn bị thông tin lấy từ form xuất kho
        String exportDate = request.getParameter("exportDate");
        // An toàn: Xử lý ký tự 'T' để MySQL không báo lỗi datetime
        if(exportDate != null) { exportDate = exportDate.replace("T", " "); }
        
        ExportHistory h = new ExportHistory(
            exportDate, 
            request.getParameter("employeeId"), 
            request.getParameter("batchId"), 
            Double.parseDouble(request.getParameter("exportQuantity")), 
            request.getParameter("exportPurpose")
        );
        
        String action = request.getParameter("action");

        // Khi người dùng bấm THÊM phiếu xuất kho mới
        if ("add".equals(action)) {
            // Lưu lịch sử xuất kho trước (Giữ nguyên của bạn)
            dao.insertExportHistory(h);
            
            // SAU ĐÓ TỰ ĐỘNG TRỪ SỐ LƯỢNG TRONG KHO (Lô nhập và Nguyên liệu gốc)
            invDao.processExportDeduction(h.getBatchId(), h.getExportQuantity());
        }
        else if ("edit".equals(action)) {
            dao.updateExportHistory(h);
        }
        
        response.sendRedirect("export-history-manager");
    }
}