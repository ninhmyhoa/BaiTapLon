package controller;

import dal.BillingDAO;
import dal.FacilityDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.DiningTable;

@WebServlet(name = "PrintBillServlet", urlPatterns = {"/print-bill"})
public class PrintBillServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String invoiceIdStr = request.getParameter("invoiceId");

        if (invoiceIdStr != null && !invoiceIdStr.isEmpty()) {
            try {
                int invoiceId = Integer.parseInt(invoiceIdStr);
                BillingDAO dao = new BillingDAO();
                HttpSession session = request.getSession();

                // =========================================================
                // 1. LOGIC GIẢI PHÓNG BÀN (Cập nhật Status thành 'Ranh')
                // =========================================================
                // Lấy danh sách các bàn thuộc hóa đơn để giải phóng trạng thái
List<DiningTable> mergedTables = dao.getTablesByInvoiceList(invoiceId);
if (mergedTables != null && !mergedTables.isEmpty()) {
    for (DiningTable t : mergedTables) {
        // Ép kiểu String từ model sang int trước khi truyền vào DAO
        dao.updateTableStatus(Integer.parseInt(t.getRoomId()), t.getTableNumber(), "Ranh");
    }
}
                // =========================================================
                // 2. LOGIC TÍNH TIỀN TRỪ CỌC (Lấy từ Session)
                // =========================================================
                double totalItems = dao.getTotalBill(invoiceId); 
                
                // Lấy tiền cọc đã cất ở Session lúc Check-in
                Double depositObj = (Double) session.getAttribute("DEP_INV_" + invoiceId);
                double deposit = (depositObj != null) ? depositObj : 0;
                
                double finalAmount = totalItems - deposit; 
                if (finalAmount < 0) finalAmount = 0;

                // =========================================================
                // 3. ĐẨY DỮ LIỆU SANG JSP (Giữ nguyên toàn bộ Attributes của bạn)
                // =========================================================
                request.setAttribute("invoiceId", invoiceId);
                request.setAttribute("billList", dao.getBillDetails(invoiceId));
                request.setAttribute("totalItems", totalItems);   
                request.setAttribute("deposit", deposit);         
                request.setAttribute("finalAmount", finalAmount); 
                request.setAttribute("totalAmount", finalAmount); 

                request.getRequestDispatcher("print_bill.jsp").forward(request, response);
                
            } catch (Exception e) {
                System.out.println("Lỗi PrintBill: " + e.getMessage());
                response.sendRedirect("print_bill_search.jsp");
            }
        } else {
            response.sendRedirect("print_bill_search.jsp");
        }
    }
}