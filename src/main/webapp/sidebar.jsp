<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:choose>
    <%-- ======================================================= --%>
    <%-- TRƯỜNG HỢP 1: LÀ QUẢN LÝ -> HIỂN THỊ SIDEBAR BÌNH THƯỜNG  --%>
    <%-- ======================================================= --%>
    <c:when test="${sessionScope.user.position.toUpperCase() eq 'MANAGER'}">
        <style>
            .sidebar { height: 100vh; width: 260px; background-color: #fff; box-shadow: 2px 0 5px rgba(0,0,0,0.05); position: fixed; top: 0; left: 0; overflow-y: auto; z-index: 1000; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
            .sidebar-brand { padding: 20px; font-size: 22px; font-weight: bold; color: #4338ca; text-align: center; border-bottom: 1px solid #eee; margin-bottom: 10px; }
            .sidebar-nav .nav-item { margin: 2px 10px; }
            .sidebar-nav .nav-link { color: #4b5563; border-radius: 8px; padding: 12px 15px; font-weight: 500; display: flex; justify-content: space-between; align-items: center; transition: 0.2s; text-decoration: none;}
            .sidebar-nav .nav-link:hover { background-color: #f3f4f6; color: #4338ca; }
            .sidebar-nav .nav-link.active-main { background-color: #e0e7ff; color: #4338ca; font-weight: bold; }
            .sidebar-nav .nav-link i.icon-left { width: 25px; }
            .sub-menu { padding-left: 30px; font-size: 0.9em; border-left: 2px solid #e0e7ff; margin-left: 20px;}
            .sub-menu .nav-link { padding: 8px 10px; color: #6b7280; text-decoration: none; display: block;}
            .sub-menu .nav-link:hover, .sub-menu .nav-link.active-sub { background: transparent; color: #4338ca; font-weight: 600; }
        </style>

        <div class="sidebar">
            <div class="sidebar-brand"><i class="fas fa-utensils me-2"></i>NHÀ HÀNG X</div>
            
            <ul class="nav flex-column sidebar-nav" id="menuAccordion">
                <li class="nav-item">
                    <a href="manager_dashboard.jsp" class="nav-link ${param.active == 'dashboard' ? 'active-main' : ''}">
                        <span><i class="fas fa-chart-pie icon-left"></i>Dashboard</span>
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link ${param.menu == 'menu1' ? '' : 'collapsed'}" href="#menu1" data-bs-toggle="collapse" aria-expanded="${param.menu == 'menu1'}">
                        <span><i class="fas fa-book-open icon-left"></i>Thực Đơn & Phòng</span>
                        <i class="fas fa-chevron-down ms-auto" style="font-size: 12px;"></i>
                    </a>
                    <div class="collapse ${param.menu == 'menu1' ? 'show' : ''} sub-menu" id="menu1" data-bs-parent="#menuAccordion">
                        <a href="category-manager" class="nav-link ${param.active == 'category' ? 'active-sub' : ''}">Loại Món Ăn</a>
                        <a href="dish-manager" class="nav-link ${param.active == 'dish' ? 'active-sub' : ''}">Quản Lý Món Ăn</a>
                        <a href="room-manager" class="nav-link ${param.active == 'room' ? 'active-sub' : ''}">Khu Vực / Phòng</a>
                        <a href="table-manager" class="nav-link ${param.active == 'table' ? 'active-sub' : ''}">Sơ Đồ Bàn</a>
                    </div>
                </li>

                <li class="nav-item">
                    <a class="nav-link ${param.menu == 'menu2' ? '' : 'collapsed'}" href="#menu2" data-bs-toggle="collapse" aria-expanded="${param.menu == 'menu2'}">
                        <span><i class="fas fa-shopping-cart icon-left"></i>Giao Dịch Bán Hàng</span>
                        <i class="fas fa-chevron-down ms-auto" style="font-size: 12px;"></i>
                    </a>
                    <div class="collapse ${param.menu == 'menu2' ? 'show' : ''} sub-menu" id="menu2" data-bs-parent="#menuAccordion">
                        <a href="reservation-manager" class="nav-link ${param.active == 'reservation' ? 'active-sub' : ''}">Đặt Bàn</a>
                        <a href="invoice-detail-manager" class="nav-link ${param.active == 'pos' ? 'active-sub' : ''}">POS Gọi Món</a>
                        <a href="invoice-manager" class="nav-link ${param.active == 'invoice' ? 'active-sub' : ''}">Hóa Đơn</a>
                    </div>
                </li>

                <li class="nav-item">
                    <a class="nav-link ${param.menu == 'menu3' ? '' : 'collapsed'}" href="#menu3" data-bs-toggle="collapse" aria-expanded="${param.menu == 'menu3'}">
                        <span><i class="fas fa-users icon-left"></i>Nhân Sự & Khách</span>
                        <i class="fas fa-chevron-down ms-auto" style="font-size: 12px;"></i>
                    </a>
                    <div class="collapse ${param.menu == 'menu3' ? 'show' : ''} sub-menu" id="menu3" data-bs-parent="#menuAccordion">
                        <a href="employee-manager" class="nav-link ${param.active == 'employee' ? 'active-sub' : ''}">Quản Lý Nhân Viên</a>
                        <a href="workshift-manager" class="nav-link ${param.active == 'workshift' ? 'active-sub' : ''}">Ca Làm Việc</a>
                        <a href="customer-manager" class="nav-link ${param.active == 'customer' ? 'active-sub' : ''}">Khách Hàng</a>
                    </div>
                </li>

                <li class="nav-item">
                    <a class="nav-link ${param.menu == 'menu4' ? '' : 'collapsed'}" href="#menu4" data-bs-toggle="collapse" aria-expanded="${param.menu == 'menu4'}">
                        <span><i class="fas fa-boxes icon-left"></i>Quản Lý Kho</span>
                        <i class="fas fa-chevron-down ms-auto" style="font-size: 12px;"></i>
                    </a>
                    <div class="collapse ${param.menu == 'menu4' ? 'show' : ''} sub-menu" id="menu4" data-bs-parent="#menuAccordion">
                        <a href="ingredient-manager" class="nav-link ${param.active == 'ingredient' ? 'active-sub' : ''}">Nguyên Liệu</a>
                        <a href="recipe-manager" class="nav-link ${param.active == 'recipe' ? 'active-sub' : ''}">Công Thức</a>
                        <a href="batch-manager" class="nav-link ${param.active == 'batch' ? 'active-sub' : ''}">Lô Nhập Kho</a>
                    </div>
                </li>

                <li class="nav-item">
                    <a class="nav-link ${param.menu == 'menu5' ? '' : 'collapsed'}" href="#menu5" data-bs-toggle="collapse" aria-expanded="${param.menu == 'menu5'}">
                        <span><i class="fas fa-history icon-left"></i>Lịch Sử & Báo Cáo</span>
                        <i class="fas fa-chevron-down ms-auto" style="font-size: 12px;"></i>
                    </a>
                    <div class="collapse ${param.menu == 'menu5' ? 'show' : ''} sub-menu" id="menu5" data-bs-parent="#menuAccordion">
                        <a href="price-history-manager" class="nav-link ${param.active == 'price-history' ? 'active-sub' : ''}">Lịch Sử Giá</a>
                        <a href="export-history-manager" class="nav-link ${param.active == 'export-history' ? 'active-sub' : ''}">Lịch Sử Xuất Kho</a>
                    </div>
                </li>
            </ul>
        </div>
    </c:when>

    <%-- ======================================================= --%>
    <%-- TRƯỜNG HỢP 2: LÀ BẾP/PHỤC VỤ -> ẨN SIDEBAR VÀ ÉP TRÀN VIỀN --%>
    <%-- ======================================================= --%>
    <c:otherwise>
        <style>
            /* Ép thẻ main-content mất cái lề trái 260px đi để nó tràn ra full màn hình */
            .main-content {
                margin-left: 0 !important;
                padding: 20px 50px !important;
            }
        </style>
    </c:otherwise>
</c:choose>