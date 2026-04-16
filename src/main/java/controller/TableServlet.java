package controller;

import dal.FacilityDAO; 
import java.io.IOException; 
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet; 
import javax.servlet.http.*; 
import model.DiningTable;

@WebServlet(name = "TableServlet", urlPatterns = {"/table-manager"})
public class TableServlet extends HttpServlet {
    
    @Override 
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        FacilityDAO dao = new FacilityDAO();
        
        String action = request.getParameter("action");

        // --- LOGIC: TỰ ĐỘNG ĐỔI TRẠNG THÁI KHI MỞ HĐ CHO 1 BÀN ---
        if ("checkin".equals(action)) {
            String rId = request.getParameter("roomId");
            String tNumStr = request.getParameter("tableNum");
            
            if (rId != null && tNumStr != null) {
                int tNum = Integer.parseInt(tNumStr);
                // Cập nhật trạng thái bàn thành "Co Khach"
                DiningTable tempTable = new DiningTable(rId, tNum, "Đang phục vụ");
                dao.updateTable(tempTable); 
                
                // Chuyển hướng sang trang Hóa đơn
                response.sendRedirect("invoice-manager?roomId=" + rId + "&tableNumber=" + tNum);
                return; 
            }
        }

        if ("delete".equals(action)) { 
            dao.deleteTable(request.getParameter("roomId"), Integer.parseInt(request.getParameter("tableNum"))); 
            response.sendRedirect("table-manager"); 
            return; 
        }

        request.setAttribute("resMap", dao.getUpcomingReservations()); 
        request.setAttribute("tableList", dao.getAllTables());
        request.setAttribute("roomList", dao.getAllRooms());
        request.getRequestDispatcher("table_manager.jsp").forward(request, response);
    }
    
    @Override 
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        FacilityDAO dao = new FacilityDAO();
        String action = request.getParameter("action");

        // =========================================================
        // LOGIC GỘP BÀN: Đổi trạng thái rồi nhảy sang trang Invoice
        // =========================================================
        if ("merge".equals(action)) {
            String[] selectedTables = request.getParameterValues("selectedTables");
            
            if (selectedTables != null && selectedTables.length > 0) {
                try {
                    // 1. Cập nhật tất cả các bàn được tick chọn thành "Co Khach"
                    for (String tInfo : selectedTables) {
                        String[] parts = tInfo.split("\\|");
                        if (parts.length == 2) {
                            DiningTable tempTable = new DiningTable(parts[0], Integer.parseInt(parts[1]), "Co Khach");
                            dao.updateTable(tempTable);
                        }
                    }

                    // 2. Ký gửi danh sách bàn đã gộp vào Session để trang Invoice biết đường xử lý
                    request.getSession().setAttribute("MERGED_TABLES", selectedTables);

                    // 3. Lấy bàn đầu tiên làm "đại diện" để nhét lên URL (giúp trang Invoice không bị lỗi)
                    String[] firstTable = selectedTables[0].split("\\|");
                    String firstRoom = firstTable[0];
                    String firstTableNum = firstTable[1];

                    // 4. Nhảy thẳng sang trang invoice-manager để tạo hóa đơn
                    response.sendRedirect("invoice-manager?action=merge&roomId=" + firstRoom + "&tableNumber=" + firstTableNum);
                    return;
                    
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect("table-manager");
            return;
        }

        // =========================================================
        // LOGIC THÊM HOẶC SỬA BÀN (Đã bọc chống lỗi Null)
        // =========================================================
        if ("add".equals(action) || "edit".equals(action)) {
            String roomId = request.getParameter("roomId");
            String tableNumStr = request.getParameter("tableNumber");
            String status = request.getParameter("status");

            // Chỉ thực hiện khi lấy được số bàn, tránh lỗi Cannot parse null string
            if (roomId != null && tableNumStr != null && !tableNumStr.trim().isEmpty()) {
                try {
                    int tableNum = Integer.parseInt(tableNumStr.trim());
                    DiningTable t = new DiningTable(roomId, tableNum, "Trống");
                    
                    if ("add".equals(action)) dao.insertTable(t);
                    else if ("edit".equals(action)) dao.updateTable(t);
                } catch (Exception e) {
                    System.out.println("Lỗi khi lưu bàn: " + e.getMessage());
                    e.printStackTrace();
                }
            } else {
                System.out.println("Cảnh báo: Dữ liệu gửi lên bị thiếu Số Bàn!");
            }
            
            response.sendRedirect("table-manager");
            return;
        }
    }
}