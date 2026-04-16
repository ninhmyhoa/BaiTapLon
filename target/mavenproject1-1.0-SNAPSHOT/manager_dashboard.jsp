<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%
    // KẾT NỐI DATABASE TRỰC TIẾP ĐỂ LẤY SỐ LIỆU REAL-TIME
    String dbUrl = "jdbc:mysql://localhost:3306/QuanLyNhaHang"; // Nhớ đổi đúng tên DB của bà nha
    String dbUser = "root";
    String dbPass = "241006"; // Pass của bà
    
    double doanhThuNgay = 0, doanhThuThang = 0;
    NumberFormat currencyVN = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    
    Connection conn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
        
        // 1. LẤY DOANH THU TRONG NGÀY
        String sqlNgay = "SELECT SUM(d.price * id.quantity) as Total FROM INVOICE_DETAIL id JOIN DISH d ON id.dish_id = d.dish_id JOIN INVOICE i ON i.invoice_id = id.invoice_id WHERE DATE(i.created_time) = CURDATE()";
        ResultSet rsNgay = conn.createStatement().executeQuery(sqlNgay);
        if(rsNgay.next()) doanhThuNgay = rsNgay.getDouble("Total");

        // 2. LẤY DOANH THU TRONG THÁNG
        String sqlThang = "SELECT SUM(d.price * id.quantity) as Total FROM INVOICE_DETAIL id JOIN DISH d ON id.dish_id = d.dish_id JOIN INVOICE i ON i.invoice_id = id.invoice_id WHERE MONTH(i.created_time) = MONTH(CURDATE()) AND YEAR(i.created_time) = YEAR(CURDATE())";
        ResultSet rsThang = conn.createStatement().executeQuery(sqlThang);
        if(rsThang.next()) doanhThuThang = rsThang.getDouble("Total");

%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Quản Lý</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body { background-color: #f4f6f9; overflow-x: hidden; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        
        /* SIDEBAR STYLES */
        .sidebar { height: 100vh; width: 260px; background-color: #fff; box-shadow: 2px 0 5px rgba(0,0,0,0.05); position: fixed; top: 0; left: 0; overflow-y: auto; }
        .sidebar-brand { padding: 20px; font-size: 22px; font-weight: bold; color: #4338ca; text-align: center; border-bottom: 1px solid #eee; margin-bottom: 10px; }
        .sidebar-nav .nav-item { margin: 2px 10px; }
        .sidebar-nav .nav-link { color: #4b5563; border-radius: 8px; padding: 12px 15px; font-weight: 500; display: flex; justify-content: space-between; align-items: center; transition: 0.2s;}
        .sidebar-nav .nav-link:hover { background-color: #f3f4f6; color: #4338ca; }
        .sidebar-nav .nav-link.active { background-color: #e0e7ff; color: #4338ca; font-weight: bold; }
        .sidebar-nav .nav-link i.icon-left { width: 25px; }
        
        /* MENU CON (Dropdown/Accordion) */
        .sub-menu { padding-left: 30px; font-size: 0.9em; border-left: 2px solid #e0e7ff; margin-left: 20px;}
        .sub-menu .nav-link { padding: 8px 10px; color: #6b7280; }
        .sub-menu .nav-link:hover { background: transparent; color: #4338ca; font-weight: 600; }

        /* MAIN CONTENT */
        .main-content { margin-left: 260px; padding: 20px 30px; }
        .top-navbar { display: flex; justify-content: flex-end; padding: 10px 0 20px; border-bottom: 1px solid #e5e7eb; margin-bottom: 25px; }
        
        /* CARD DASHBOARD */
        .dash-card { background: #fff; border-radius: 12px; padding: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.03); height: 100%; border: 1px solid #f3f4f6;}
        .dash-title { color: #6b7280; font-size: 14px; text-transform: uppercase; font-weight: bold; margin-bottom: 15px; }
        
        .alert-item { border-left: 4px solid; padding: 15px; background: #fff; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); margin-bottom: 15px; display: flex; justify-content: space-between; align-items: center;}
        .alert-warning-custom { border-left-color: #f59e0b; }
        .alert-danger-custom { border-left-color: #ef4444; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-brand"><i class="fas fa-utensils me-2"></i>NHÀ HÀNG X</div>
        
        <ul class="nav flex-column sidebar-nav" id="menuAccordion">
            <li class="nav-item">
                <a href="manager_dashboard.jsp" class="nav-link active">
                    <span><i class="fas fa-chart-pie icon-left"></i>Dashboard</span>
                </a>
            </li>

            <li class="nav-item">
                <a class="nav-link collapsed" href="#menu1" data-bs-toggle="collapse">
                    <span><i class="fas fa-book-open icon-left"></i>Thực Đơn & Phòng</span>
                    <i class="fas fa-chevron-down ms-auto" style="font-size: 12px;"></i>
                </a>
                <div class="collapse sub-menu" id="menu1" data-bs-parent="#menuAccordion">
                    <a href="category-manager" class="nav-link">Loại Món Ăn</a>
                    <a href="dish-manager" class="nav-link">Quản Lý Món Ăn</a>
                    <a href="room-manager" class="nav-link">Khu Vực / Phòng</a>
                    <a href="table-manager" class="nav-link">Sơ Đồ Bàn</a>
                </div>
            </li>

            <li class="nav-item">
                <a class="nav-link collapsed" href="#menu2" data-bs-toggle="collapse">
                    <span><i class="fas fa-shopping-cart icon-left"></i>Giao Dịch Bán Hàng</span>
                    <i class="fas fa-chevron-down ms-auto" style="font-size: 12px;"></i>
                </a>
                <div class="collapse sub-menu" id="menu2" data-bs-parent="#menuAccordion">
                    <a href="reservation-manager" class="nav-link">Đặt Bàn</a>
                    <a href="invoice-detail-manager" class="nav-link">POS Gọi Món</a>
                    <a href="invoice-manager" class="nav-link">Hóa Đơn</a>
                </div>
            </li>

            <li class="nav-item">
                <a class="nav-link collapsed" href="#menu3" data-bs-toggle="collapse">
                    <span><i class="fas fa-users icon-left"></i>Nhân Sự & Khách</span>
                    <i class="fas fa-chevron-down ms-auto" style="font-size: 12px;"></i>
                </a>
                <div class="collapse sub-menu" id="menu3" data-bs-parent="#menuAccordion">
                    <a href="employee-manager" class="nav-link">Quản Lý Nhân Viên</a>
                    <a href="workshift-manager" class="nav-link">Ca Làm Việc</a>
                    <a href="customer-manager" class="nav-link">Khách Hàng</a>
                </div>
            </li>

            <li class="nav-item">
                <a class="nav-link collapsed" href="#menu4" data-bs-toggle="collapse">
                    <span><i class="fas fa-boxes icon-left"></i>Quản Lý Kho</span>
                    <i class="fas fa-chevron-down ms-auto" style="font-size: 12px;"></i>
                </a>
                <div class="collapse sub-menu" id="menu4" data-bs-parent="#menuAccordion">
                    <a href="ingredient-manager" class="nav-link">Nguyên Liệu</a>
                    <a href="recipe-manager" class="nav-link">Công Thức</a>
                    <a href="batch-manager" class="nav-link">Lô Nhập Kho</a>
                </div>
            </li>
            
            <li class="nav-item">
                <a class="nav-link collapsed" href="#menu5" data-bs-toggle="collapse">
                    <span><i class="fas fa-history icon-left"></i>Lịch Sử & Báo Cáo</span>
                    <i class="fas fa-chevron-down ms-auto" style="font-size: 12px;"></i>
                </a>
                <div class="collapse sub-menu" id="menu5" data-bs-parent="#menuAccordion">
                    <a href="price-history-manager" class="nav-link">Lịch Sử Giá</a>
                    <a href="export-history-manager" class="nav-link">Lịch Sử Xuất Kho</a>
                </div>
            </li>
        </ul>
    </div>

    <div class="main-content">
        <div class="top-navbar">
            <span class="me-3 mt-1 fw-bold">Xin chào</span>
            <a href="login.jsp" class="btn btn-outline-danger btn-sm px-3 rounded-pill"><i class="fas fa-sign-out-alt me-1"></i>Đăng xuất</a>
        </div>

        <div class="row mb-4 g-4">
            <div class="col-md-6">
                <div class="dash-card text-center">
                    <div class="dash-title">Doanh thu trong ngày</div>
                    <h2 class="text-success mb-3 fw-bold"><%= currencyVN.format(doanhThuNgay) %></h2>
                    <div class="d-flex justify-content-center align-items-center gap-2">
                        <input type="date" class="form-control form-control-sm w-auto text-muted">
                        <span class="text-muted">-</span>
                        <input type="date" class="form-control form-control-sm w-auto text-muted">
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="dash-card text-center">
                    <div class="dash-title">Doanh thu trong tháng</div>
                    <h2 class="text-primary mb-3 fw-bold"><%= currencyVN.format(doanhThuThang) %></h2>
                    <div class="d-flex justify-content-center align-items-center gap-2">
                        <input type="month" class="form-control form-control-sm w-auto text-muted">
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-lg-6">
                <div class="dash-card">
                    <div class="dash-title text-center"><i class="fas fa-fire text-danger me-2"></i>5 MÓN BÁN CHẠY NHẤT</div>
                    <div class="table-responsive mt-3">
                        <table class="table table-borderless table-hover align-middle">
                            <thead class="border-bottom">
                                <tr class="text-muted small">
                                    <th>Top</th>
                                    <th>Tên Món Ăn</th>
                                    <th class="text-center">Số Lượng Bán</th>
                                </tr>
                            </thead>
                            <tbody>
                            <%
                                // 3. LẤY TOP 5 MÓN BÁN CHẠY
                                String sqlTop = "SELECT d.dish_name, SUM(id.quantity) as TongSoLuong FROM INVOICE_DETAIL id JOIN DISH d ON id.dish_id = d.dish_id GROUP BY d.dish_id ORDER BY TongSoLuong DESC LIMIT 5";
                                ResultSet rsTop = conn.createStatement().executeQuery(sqlTop);
                                int rank = 1;
                                while(rsTop.next()) {
                            %>
                                <tr>
                                    <td><span class="badge bg-dark rounded-circle"><%= rank++ %></span></td>
                                    <td class="fw-bold text-dark"><%= rsTop.getString("dish_name") %></td>
                                    <td class="text-center fw-bold text-primary"><%= rsTop.getInt("TongSoLuong") %></td>
                                </tr>
                            <%  } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="col-lg-6">
                <div class="dash-card">
                    <div class="dash-title"><i class="fas fa-bell text-warning me-2"></i>THÔNG BÁO HỆ THỐNG</div>
                    
                    <div class="mt-3">
                        <%
                            // 4. QUÉT CẢNH BÁO: TỒN KHO THẤP
                            String sqlLowStock = "SELECT i.ingredient_name, SUM(ib.stock_quantity) as TonKho, i.min_stock FROM INGREDIENT i LEFT JOIN IMPORT_BATCH ib ON i.ingredient_id = ib.ingredient_id GROUP BY i.ingredient_id HAVING TonKho < i.min_stock";
                            ResultSet rsLow = conn.createStatement().executeQuery(sqlLowStock);
                            while(rsLow.next()) {
                        %>
                        <div class="alert-item alert-warning-custom">
                            <div>
                                <strong class="text-dark"><%= rsLow.getString("ingredient_name") %></strong>
                                <span class="text-danger ms-2 fw-bold"><%= rsLow.getDouble("TonKho") %> kg/lít</span>
                                <div class="badge bg-warning text-dark mt-1 d-block w-50">Tồn kho thấp (Dưới <%= rsLow.getDouble("min_stock") %>)</div>
                            </div>
                            <div><a href="batch-manager" class="btn btn-sm btn-outline-primary">Nhập thêm</a></div>
                        </div>
                        <% } %>

                        <%
                            // 5. QUÉT CẢNH BÁO: SẮP HẾT HẠN (Còn < 3 ngày)
                            String sqlExpire = "SELECT ib.batch_id, i.ingredient_name, ib.stock_quantity, DATEDIFF(ib.expiration_date, CURDATE()) as DaysLeft FROM IMPORT_BATCH ib JOIN INGREDIENT i ON ib.ingredient_id = i.ingredient_id WHERE ib.stock_quantity > 0 AND DATEDIFF(ib.expiration_date, CURDATE()) BETWEEN 0 AND 3";
                            ResultSet rsExpire = conn.createStatement().executeQuery(sqlExpire);
                            while(rsExpire.next()) {
                                int days = rsExpire.getInt("DaysLeft");
                        %>
                        <div class="alert-item alert-danger-custom">
                            <div>
                                <strong class="text-dark"><%= rsExpire.getString("ingredient_name") %> (Lô #<%= rsExpire.getString("batch_id") %>)</strong>
                                <span class="text-muted ms-2">Tồn: <%= rsExpire.getDouble("stock_quantity") %></span>
                                <div class="text-danger mt-1 fw-bold">
                                    <i class="fas fa-clock me-1"></i><%= days == 0 ? "Hết hạn HÔM NAY!" : "Còn " + days + " ngày" %>
                                </div>
                            </div>
                            <div><a href="export-history-manager" class="btn btn-sm btn-outline-danger">Xuất hủy</a></div>
                        </div>
                        <% } 
                        
                        // Đóng kết nối
                        if(conn != null) conn.close();
                        } catch(Exception e) {
                            out.println("<p class='text-danger'>Lỗi lấy dữ liệu DB: " + e.getMessage() + "</p>");
                        }
                        %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>