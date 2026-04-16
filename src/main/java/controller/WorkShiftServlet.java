package controller;

import dal.HistoryDAO; 
import dal.EmployeeDAO; 
import java.io.IOException; 
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet; 
import javax.servlet.http.*; 
import model.WorkShift;
import model.Employee; // Import model chứa thông tin nhân viên của bạn

@WebServlet(name = "WorkShiftServlet", urlPatterns = {"/workshift-manager"})
public class WorkShiftServlet extends HttpServlet {
    
    @Override 
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        HistoryDAO dao = new HistoryDAO(); 
        EmployeeDAO empDao = new EmployeeDAO();
        HttpSession session = request.getSession();
        
        // Lấy thông tin người đang đăng nhập
        Employee currentUser = (Employee) session.getAttribute("user");
        
        if ("delete".equals(request.getParameter("action"))) { 
            dao.deleteWorkShift(request.getParameter("empId"), request.getParameter("time")); 
            dao.closeConnection();
            empDao.closeConnection();
            response.sendRedirect("workshift-manager"); 
            return; 
        }
        
        // PHÂN QUYỀN HIỂN THỊ DỮ LIỆU
       // PHÂN QUYỀN HIỂN THỊ DỮ LIỆU
        boolean isManager = currentUser != null && (
            "Manager".equalsIgnoreCase(currentUser.getPosition()) || 
            "Quản lý".equalsIgnoreCase(currentUser.getPosition())
        );

        if (isManager) {
            // Quản lý: Thấy tất cả ca làm
            request.setAttribute("shiftList", dao.getAllWorkShifts()); 
        } else if (currentUser != null) {
            // Phục vụ / Bếp: Chỉ thấy lịch sử của chính mình
            request.setAttribute("shiftList", dao.getWorkShiftsByEmployeeId(String.valueOf(currentUser.getEmployeeId()))); 
        }
        
        request.setAttribute("empList", empDao.getAllEmployees());
        
        dao.closeConnection();
        empDao.closeConnection();
        
        request.getRequestDispatcher("workshift_manager.jsp").forward(request, response);
    }
    
    @Override 
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        HistoryDAO dao = new HistoryDAO();
        HttpSession session = request.getSession();
        Employee currentUser = (Employee) session.getAttribute("user");
        
        String action = request.getParameter("action");
        
        // Lấy thời gian hiện tại để tự động chấm công
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String currentTime = LocalDateTime.now().format(formatter);
        
        // XỬ LÝ NÚT VÀO CA CỦA NHÂN VIÊN
        if ("clockIn".equals(action)) {
            WorkShift w = new WorkShift(String.valueOf(currentUser.getEmployeeId()), currentTime, null);
            dao.insertWorkShift(w);
        } 
        // XỬ LÝ NÚT TAN CA CỦA NHÂN VIÊN
        else if ("clockOut".equals(action)) {
            dao.clockOutEmployee(String.valueOf(currentUser.getEmployeeId()), currentTime);
        } 
        // XỬ LÝ NÚT THÊM/SỬA CỦA QUẢN LÝ
        else {
            String login = request.getParameter("loginTime");
            String logout = request.getParameter("logoutTime");
            
            if (login != null) { login = login.replace("T", " "); }
            if (logout != null && !logout.isEmpty()) { logout = logout.replace("T", " "); } else { logout = null; }
            
            WorkShift w = new WorkShift(request.getParameter("employeeId"), login, logout);
            
            if ("add".equals(action)) {
                dao.insertWorkShift(w);
            } else if ("edit".equals(action)) {
                dao.updateWorkShift(w);
            }
        }
        
        dao.closeConnection();
        response.sendRedirect("workshift-manager");
    }
}