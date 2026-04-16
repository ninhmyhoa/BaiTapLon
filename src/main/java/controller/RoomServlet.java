package controller;
import dal.FacilityDAO; import java.io.IOException; import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet; import javax.servlet.http.*; import model.Room;

@WebServlet(name = "RoomServlet", urlPatterns = {"/room-manager"})
public class RoomServlet extends HttpServlet {
    
    @Override 
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        FacilityDAO dao = new FacilityDAO();
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) { 
            dao.deleteRoom(request.getParameter("id")); 
            dao.closeConnection(); // Đóng kết nối
            response.sendRedirect("room-manager"); 
            return; 
        }
        
        request.setAttribute("roomList", dao.getAllRooms());
        
        // RÚT ỐNG HÚT RA TRƯỚC KHI TRẢ VỀ GIAO DIỆN
        dao.closeConnection(); 
        request.getRequestDispatcher("room_manager.jsp").forward(request, response);
    }
    
    @Override 
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); 
        FacilityDAO dao = new FacilityDAO();
        Room r = new Room(request.getParameter("roomId"), Integer.parseInt(request.getParameter("maxCapacity")));
        
        if ("add".equals(request.getParameter("action"))) dao.insertRoom(r);
        else if ("edit".equals(request.getParameter("action"))) dao.updateRoom(r);
        
        // RÚT ỐNG HÚT RA SAU KHI THÊM/SỬA XONG
        dao.closeConnection();
        response.sendRedirect("room-manager");
    }
}