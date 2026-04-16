package controller;

import dal.BookingDAO; 
import dal.FacilityDAO; 
import dal.BillingDAO;
import java.io.IOException; 
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet; 
import javax.servlet.http.*; 
import model.Reservation;
import model.Occupies;

@WebServlet(name = "ReservationServlet", urlPatterns = {"/reservation-manager"})
public class ReservationServlet extends HttpServlet {

    @Override 
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        BookingDAO dao = new BookingDAO(); 
        FacilityDAO facDao = new FacilityDAO();
        BillingDAO billDao = new BillingDAO(); 

        String action = request.getParameter("action");
        String resId = request.getParameter("id"); 

        // =========================================================================
        // YÊU CẦU 2: KHI BẤM "KHÁCH ĐẾN" -> ĐỔI TRẠNG THÁI "CO KHACH" & CHUYỂN SANG TAB HÓA ĐƠN
        // =========================================================================
        if ("checkin".equals(action) && resId != null) {
            try {
                class LocalDAO extends dal.DBContext { public java.sql.Connection getC() { return this.connection; } }
                java.sql.Connection conn = new LocalDAO().getC();
                String cleanId = resId.trim();

                // 1. Lấy thông tin khách hàng, nhân viên và tiền cọc
                double deposit = 0; String custId = null; String empId = null;
                java.sql.ResultSet rs = conn.prepareStatement("SELECT Customer_ID, Employee_ID FROM RESERVATION WHERE Reservation_ID='"+cleanId+"'").executeQuery();
                if(rs.next()){ custId = rs.getString(1); empId = rs.getString(2); }

                java.sql.ResultSet rsDep = conn.prepareStatement("SELECT SUM(Amount) FROM DEPOSIT WHERE Reservation_ID='"+cleanId+"'").executeQuery();
                if(rsDep.next()){ deposit = rsDep.getDouble(1); }

                // 2. Tạo hóa đơn mới (Invoice)
                int newInvId = -1;
                java.sql.PreparedStatement psInv = conn.prepareStatement(
                    "INSERT INTO INVOICE (Customer_ID, Employee_ID, Created_time) VALUES (?, ?, ?)", 
                    java.sql.Statement.RETURN_GENERATED_KEYS);
                psInv.setString(1, custId);
                psInv.setString(2, empId);
                psInv.setDate(3, new java.sql.Date(System.currentTimeMillis()));
                psInv.executeUpdate();

                java.sql.ResultSet rsK = psInv.getGeneratedKeys();
                if(rsK.next()) newInvId = rsK.getInt(1);

                if (newInvId != -1) {
                    // Lưu cọc vào Session để tính tiền sau này
                    request.getSession().setAttribute("DEP_INV_" + newInvId, deposit);

                    // 3. Tìm các bàn mà đơn này đã đặt
                    java.sql.PreparedStatement psTables = conn.prepareStatement("SELECT Room_ID, Table_number FROM TABLE_RESERVATION WHERE Reservation_ID=?");
                    psTables.setString(1, cleanId);
                    java.sql.ResultSet rsP = psTables.executeQuery();

                    String firstRoomId = ""; 
                    int firstTableNum = 0;
                    boolean isFirst = true;

                    while (rsP.next()) { 
                        String rId = rsP.getString(1); 
                        int tNum = rsP.getInt(2); 

                        if (isFirst) {
                            firstRoomId = rId;
                            firstTableNum = tNum;
                            isFirst = false;
                        }

                        // 4. Chuyển món ăn từ món đặt trước (PRE_ORDER) sang chi tiết hóa đơn (INVOICE_DETAIL)
                        String sqlCopy = "INSERT INTO INVOICE_DETAIL (Invoice_ID, Employee_ID, Dish_ID, Room_ID, Table_number, Quantity, Kitchen_Status) " +
                                         "SELECT ?, ?, Dish_ID, ?, ?, Quantity, 'CHO_NAU' FROM PRE_ORDER WHERE Reservation_ID = ?";
                        java.sql.PreparedStatement psC = conn.prepareStatement(sqlCopy);
                        psC.setInt(1, newInvId); 
                        psC.setString(2, empId); 
                        psC.setString(3, rId); 
                        psC.setInt(4, tNum); 
                        psC.setString(5, cleanId);
                        psC.executeUpdate();

                        // 5. Cập nhật trạng thái bàn ăn thành "Co Khach"
billDao.updateTableStatus(Integer.parseInt(rId), tNum, "Co Khach");                    }

                    // =========================================================================
                    // PHẦN QUAN TRỌNG NHẤT: CHỈ XÓA LIÊN KẾT GIỮ BÀN (TẮT CHUÔNG VÀNG)
                    // TUYỆT ĐỐI KHÔNG GỌI dao.deleteReservation(cleanId) ĐỂ GIỮ LẠI LỊCH SỬ
                    // =========================================================================
                    java.sql.PreparedStatement psDelLink = conn.prepareStatement("DELETE FROM TABLE_RESERVATION WHERE Reservation_ID=?");
                    psDelLink.setString(1, cleanId);
                    psDelLink.executeUpdate();

                    // Chuyển hướng thẳng sang trang gọi món của hóa đơn vừa tạo
                    response.sendRedirect("invoice-detail-manager?invoiceId=" + newInvId + "&roomId=" + firstRoomId + "&tableNumber=" + firstTableNum);
                    return;
                }
            } catch (Exception e) { 
                e.printStackTrace(); 
            }
        }

        if ("delete".equals(action)) { 
            dao.deleteReservation(resId); 
            response.sendRedirect("reservation-manager"); 
            return; 
        }
        request.setAttribute("depList", dao.getAllDeposits());
        request.setAttribute("resList", dao.getAllReservations()); 
        request.setAttribute("tableList", facDao.getAllTables()); 
        request.setAttribute("custList", facDao.getAllCustomers());
        request.getRequestDispatcher("reservation_manager.jsp").forward(request, response);
    }

    @Override 
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        BookingDAO dao = new BookingDAO();
        
        try {
            String action = request.getParameter("action");
            String resId = request.getParameter("reservationId");
            String createdTime = request.getParameter("createdTime").replace("T", " ");
            String arrivalTime = request.getParameter("arrivalTime").replace("T", " ");
            int guestCount = Integer.parseInt(request.getParameter("guestCount"));
            
            String customerId = request.getParameter("customerId");
            if (customerId != null && customerId.trim().isEmpty()) {
                customerId = null; 
            }

            Reservation r = new Reservation(
                resId, request.getParameter("employeeId"), customerId, createdTime, arrivalTime, guestCount
            );

            // =========================================================================
            // YÊU CẦU 1: KHI TẠO ĐƠN CHỈ LƯU VÀO DB, BÀN VẪN "RANH", CHỈ HIỆN THÔNG BÁO CHUÔNG
            // =========================================================================
            if ("add".equals(action)) {
                int generatedId = dao.insertReservation(r); 
                
                if (generatedId != -1) {
                    String[] selectedTables = request.getParameterValues("selectedTables");
                    if (selectedTables != null) {
                        for (String tableInfo : selectedTables) {
                            String[] parts = tableInfo.split("\\|");
                            if(parts.length == 2) {
                                Occupies occ = new Occupies(String.valueOf(generatedId), parts[0], Integer.parseInt(parts[1]));
                                dao.insertOccupies(occ);
                                
                                // HOÀN TOÀN KHÔNG GỌI LỆNH ĐỔI TRẠNG THÁI BÀN Ở ĐÂY. BÀN VẪN NGUYÊN TRẠNG THÁI CŨ!
                            }
                        }
                    }
                }
                response.setStatus(HttpServletResponse.SC_OK);
                
            } else if ("edit".equals(action)) {
                dao.updateReservation(r);
                response.sendRedirect("reservation-manager");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
}