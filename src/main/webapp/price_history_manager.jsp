<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Sử Giá Món</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        body { 
            font-family: 'Inter', sans-serif; 
            background-color: #f8fafc; 
            color: #1e293b;
        }
        .main-content { margin-left: 260px; padding: 20px 30px; }
        .top-navbar { display: flex; justify-content: flex-end; padding: 10px 0 20px; border-bottom: 1px solid #e5e7eb; margin-bottom: 25px; }
        .navbar { 
            background: #ffffff; 
            border-bottom: 1px solid #e2e8f0; 
            padding: 1rem 0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        .navbar-brand { font-weight: 800; color: #4338ca !important; }

        /* Card & Table Styling */
        .main-card { 
            border: none; 
            border-radius: 20px; 
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.05);
            background: white;
            overflow: hidden;
        }
        
        .table thead { background-color: #f8fafc; }
        .table thead th { 
            border: none; 
            color: #64748b; 
            font-weight: 600; 
            text-transform: uppercase; 
            font-size: 0.75rem; 
            padding: 1.25rem 1.5rem;
            letter-spacing: 0.5px;
        }
        .table tbody td { 
            vertical-align: middle; 
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid #f1f5f9;
        }
        
        /* Badges & Text Styling */
        .id-badge {
            background-color: #f1f5f9;
            color: #475569;
            padding: 6px 12px;
            border-radius: 10px;
            font-weight: 700;
            font-size: 0.85rem;
        }
        .price-text { font-weight: 800; color: #059669; font-size: 1.1rem; }
        .time-text { color: #64748b; font-size: 0.9rem; }

        /* Action Buttons */
        .btn-action { 
            width: 36px; height: 36px; 
            display: inline-flex; align-items: center; justify-content: center; 
            border-radius: 10px; transition: all 0.2s; border: none;
        }
        .btn-edit-custom { background: #e0e7ff; color: #4338ca; }
        .btn-edit-custom:hover { background: #4338ca; color: white; }
        
        .btn-delete-custom { background: #fee2e2; color: #dc2626; }
        .btn-delete-custom:hover { background: #dc2626; color: white; }

        .btn-add { 
            background: #4338ca;
            border: none;
            border-radius: 14px; 
            font-weight: 700; 
            padding: 12px 28px;
            box-shadow: 0 10px 15px -3px rgba(67, 56, 202, 0.3);
            transition: 0.3s;
        }
        .btn-add:hover { background: #3730a3; transform: translateY(-2px); color: white; }

        /* Modal Customization */
        .modal-content { border: none; border-radius: 28px; }
        .form-label { font-weight: 700; font-size: 0.8rem; color: #64748b; text-transform: uppercase; margin-bottom: 0.5rem; }
        .form-control, .form-select { 
            border-radius: 12px; 
            padding: 12px 15px; 
            border: 1px solid #e2e8f0; 
            background-color: #f8fafc;
        }
        .form-control:focus { background-color: white; border-color: #4338ca; box-shadow: 0 0 0 4px rgba(67, 56, 202, 0.1); }
    </style>
</head>
<body>

    <jsp:include page="sidebar.jsp">
        <jsp:param name="menu" value="menu5" /> <jsp:param name="active" value="price-history" /> </jsp:include>

    <div class="main-content">
        
        <div class="top-navbar">
            <span class="me-3 mt-1 fw-bold">Xin chào</span>
            <a href="login.jsp" class="btn btn-outline-danger btn-sm px-3 rounded-pill"><i class="fas fa-sign-out-alt me-1"></i>Đăng xuất</a>
        </div>
    <div class="container pb-5">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <h3 class="fw-bold mb-1">Nhật ký thay đổi giá bán</h3>
                <p class="text-muted mb-0 small text-uppercase fw-600" style="letter-spacing: 1px;">Theo dõi lịch sử điều chỉnh thực đơn theo thời gian</p>
            </div>
            <button class="btn btn-primary btn-add" data-bs-toggle="modal" data-bs-target="#addModal">
                <i class="fas fa-plus-circle me-2"></i> Thêm Mốc Giá Mới
            </button>
        </div>
        <div class="row mb-3">
    <div class="col-md-5 col-sm-12">
        <div class="input-group shadow-sm">
            <span class="input-group-text bg-white border-end-0">
                <i class="fas fa-search text-muted"></i>
            </span>
            <input type="text" id="searchInput" class="form-control border-start-0 ps-0" 
                   placeholder="Nhập thông tin cần tìm (Tên, SĐT, ID...)" 
                   onkeyup="filterTable()">
        </div>
    </div>
</div>
        <div class="card main-card">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>Mã Món</th>
                            <th>Tên Món Ăn</th> <th class="text-end">Giá Cập Nhật</th>
                            <th>Thời Gian</th>
                            <th>Người Cập Nhật</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${priceList}" var="p"> <tr>
                                <td><span class="badge bg-light text-dark border">#${p.dishId}</span></td>
                                
                                <td class="fw-bold text-primary">${p.dishName}</td>
                                
                                <td class="text-end fw-bold text-danger">
                                    <fmt:formatNumber value="${p.price}" type="number"/> đ
                                </td>
                                <td>
                                    <div class="small"><i class="fas fa-clock text-muted me-1"></i>${p.appliedTime.replace('T', ' ')}</div>
                                </td>
                                <td>
                                    <div class="small"><i class="fas fa-user-tie text-muted me-1"></i>${p.employeeName}</div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
        
        <p class="text-center mt-5 text-muted small"></p>
    </div>

    <div class="modal fade" id="addModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg">
                <form action="price-history-manager" method="POST">
                    <div class="modal-header border-0 p-4 pb-0">
                        <h5 class="fw-bold mb-0 text-indigo-600"><i class="fas fa-plus-circle me-2"></i>Thiết Lập Mốc Giá</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="mb-3">
                            <label class="form-label">Chọn Món Ăn</label>
                            <select name="dishId" class="form-select shadow-sm">
                                <c:forEach items="${dishList}" var="d">
                                    <option value="${d.dishId}">${d.dishName} (${d.dishId})</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Thời gian bắt đầu áp dụng</label>
                            <input type="datetime-local" name="appliedTime" class="form-control shadow-sm" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Giá niêm yết mới</label>
                            <input type="number" step="0.01" name="price" class="form-control shadow-sm" placeholder="0.00" required>
                        </div>

                        <div class="col-12">
                            <label class="form-label">Người phê duyệt thay đổi</label>
                            <select name="employeeId" id="e_emp" class="form-select">
                                <c:forEach items="${empList}" var="e">
                                    <%-- THÊM DÒNG NÀY ĐỂ LỌC CHỈ LẤY MANAGER --%>
                                    <c:if test="${e.position.toUpperCase() eq 'MANAGER'}">
                                        <option value="${e.employeeId}">${e.fullName}</option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="submit" class="btn btn-primary w-100 py-3 fw-bold rounded-pill shadow" style="background: #4338ca; border: none;">LƯU MỐC GIÁ</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg">
                <form action="price-history-manager" method="POST">
                    <div class="modal-header border-0 p-4 pb-0">
                        <h5 class="fw-bold mb-0 text-primary"><i class="fas fa-edit me-2"></i>Chỉnh Sửa Mốc Giá</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="edit">
                        
                        <div class="row g-3">
                            <div class="col-6">
                                <label class="form-label text-muted small">Món Ăn</label>
                                <input type="text" name="dishId" id="e_dish" class="form-control bg-light border-0" readonly>
                            </div>
                            <div class="col-6">
                                <label class="form-label text-muted small">Thời Gian</label>
                                <input type="datetime-local" name="appliedTime" id="e_time" class="form-control bg-light border-0" readonly>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Giá điều chỉnh</label>
                                <input type="number" step="0.01" name="price" id="e_price" class="form-control" required>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Người phê duyệt thay đổi</label>
                                <select name="employeeId" id="e_emp" class="form-select">
                                    <c:forEach items="${empList}" var="e">
                                        <%-- THÊM DÒNG NÀY ĐỂ LỌC CHỈ LẤY MANAGER --%>
                                        <c:if test="${e.position.toUpperCase() eq 'MANAGER'}">
                                            <option value="${e.employeeId}">${e.fullName}</option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="submit" class="btn btn-primary w-100 py-3 fw-bold rounded-pill shadow">CẬP NHẬT LỊCH SỬ</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function fillEdit(dish, time, price, emp) { 
            document.getElementById('e_dish').value = dish; 
            document.getElementById('e_time').value = time; 
            document.getElementById('e_price').value = price; 
            document.getElementById('e_emp').value = emp; 
        }
    </script>
    <script>
    function filterTable() {
        // 1. Lấy từ khóa người dùng nhập và chuyển thành chữ thường
        var input = document.getElementById("searchInput");
        var filter = input.value.toLowerCase();
        
        // 2. Tìm cái bảng trên trang (Giả định bảng của bạn có class="table")
        var table = document.querySelector(".table");
        
        // Kiểm tra xem trang có bảng không để tránh lỗi
        if (!table) return; 
        
        // 3. Lấy tất cả các hàng (tr) nằm trong phần thân bảng (tbody)
        var tr = table.getElementsByTagName("tbody")[0].getElementsByTagName("tr");

        // 4. Lặp qua từng hàng để kiểm tra
        for (var i = 0; i < tr.length; i++) {
            // Lấy toàn bộ chữ (text) có trong hàng đó
            var rowText = tr[i].textContent || tr[i].innerText;
            
            // Nếu chữ trong hàng chứa từ khóa tìm kiếm -> Giữ lại (hiện)
            if (rowText.toLowerCase().indexOf(filter) > -1) {
                tr[i].style.display = "";
            } else {
                // Nếu không chứa -> Ẩn hàng đó đi
                tr[i].style.display = "none";
            }
        }
    }
</script>
</body>
</html>