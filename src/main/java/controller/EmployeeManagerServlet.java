package controller;

import dal.EmployeeDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Employee;

@WebServlet(name = "EmployeeManagerServlet", urlPatterns = {"/employee-manager"})
public class EmployeeManagerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        EmployeeDAO dao = new EmployeeDAO();
        String action = request.getParameter("action");

        if (action != null && action.equals("delete")) {
            String id = request.getParameter("id");
            dao.deleteEmployee(id);
            response.sendRedirect("employee-manager"); 
            return;
        }

        List<Employee> list = dao.getAllEmployees();
        request.setAttribute("empList", list);
        request.getRequestDispatcher("employee_manager.jsp").forward(request, response);
    }

    @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
            request.setCharacterEncoding("UTF-8");
            EmployeeDAO dao = new EmployeeDAO();
            String action = request.getParameter("action");

            // Lấy dữ liệu từ form (Lưu ý: Bà nhớ dặn bạn sửa lại name trong file JSP cho khớp mấy tên này nha)
            String id = request.getParameter("employeeId");
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String street = request.getParameter("street");
            String district = request.getParameter("district");
            String city = request.getParameter("city");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String position = request.getParameter("position");
            String password = request.getParameter("password");

            // Khởi tạo Employee với đầy đủ 10 tham số theo Model mới
            Employee emp = new Employee(id, firstName, lastName, street, district, city, phone, email, position, password);

            if ("add".equals(action)) {
                dao.addEmployee(emp); // Sửa từ insertEmployee thành addEmployee cho khớp DAO mới
            } else if ("edit".equals(action)) {
                dao.updateEmployee(emp);
            }

            response.sendRedirect("employee-manager");
        }
}