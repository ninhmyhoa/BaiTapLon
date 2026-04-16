<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Gọi Món Trước</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        body { 
            font-family: 'Inter', sans-serif; 
            background-color: #f8fafc; 
            color: #1e293b;
        }
        
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
            background-color: #eef2ff;
            color: #4338ca;
            padding: 6px 12px;
            border-radius: 10px;
            font-weight: 800;
            font-size: 0.85rem;
        }
        .dish-name { font-weight: 700; color: #1e293b; }
        .qty-text { font-weight: 800; color: #4338ca; font-size: 1.1rem; }

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

    <nav class="navbar navbar-expand-lg mb-4 sticky-top shadow-sm">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center" href="#">
                <i class="fas fa-clock-rotate-left me-2"></i> GỌI MÓN TRƯỚC
            </a>
            
            <%-- KHỐI LOGIC: TỰ ĐỘNG DÒ TÌM ĐÚNG TRANG CHỦ CỦA NGƯỜI ĐĂNG NHẬP --%>
            <c:choose>
                <c:when test="${sessionScope.user.position.toUpperCase() eq 'WAITER'}">
                    <c:set var="dashLink" value="waiter_dashboard.jsp" />
                </c:when>
                
                <c:otherwise>
                    <c:set var="dashLink" value="manager_dashboard.jsp" />
                </c:otherwise>
            </c:choose>

            <%-- NÚT BẤM ĐÃ ĐƯỢC THAY THẾ LINK ĐỘNG --%>
            <a href="${dashLink}" class="btn btn-outline-secondary btn-sm px-4 rounded-pill fw-bold">
                <i class="fas fa-arrow-left me-2"></i> Dashboard
            </a>
        </div>
    </nav>

    <div class="container pb-5">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <h3 class="fw-bold mb-1">Món ăn chuẩn bị trước</h3>
                <p class="text-muted mb-0 small text-uppercase fw-600" style="letter-spacing: 1px;">Quản lý thực đơn đi kèm đơn đặt bàn</p>
            </div>
            <button class="btn btn-primary btn-add" data-bs-toggle="modal" data-bs-target="#addModal">
                <i class="fas fa-plus-circle me-2"></i> Gọi Thêm Món
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
                            <th>Mã Đặt Bàn</th>
                            <th>Tên Món Ăn</th>
                            <th class="text-center">Số Lượng</th>
                            <th>Ghi Chú Phục Vụ</th>
                            <th class="text-end">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${preList}" var="p">
                            <tr>
                                <td><span class="id-badge">#${p.reservationId}</span></td>
                                <td><span class="dish-name"><i class="fas fa-utensils me-2 text-muted small"></i>${p.dishId}</span></td>
                                <td class="text-center"><span class="qty-text">${p.quantity}</span></td>
                                <td class="text-muted small">
                                    <c:choose>
                                        <c:when test="${empty p.note}"><span class="opacity-50 italic">Không có ghi chú</span></c:when>
                                        <c:otherwise><i class="far fa-comment-dots me-1"></i> ${p.note}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end">
                                    <button class="btn-action btn-edit-custom me-1" 
                                            data-bs-toggle="modal" 
                                            data-bs-target="#editModal" 
                                            onclick="fillEdit('${p.reservationId}','${p.dishId}','${p.quantity}','${p.note}')">
                                        <i class="fas fa-pen-to-square"></i>
                                    </button>
                                    <a href="preorder-manager?action=delete&resId=${p.reservationId}&dishId=${p.dishId}" 
                                       class="btn-action btn-delete-custom" 
                                       onclick="return confirm('Bạn có chắc muốn xóa món này khỏi đơn đặt bàn?');">
                                        <i class="fas fa-trash-can"></i>
                                    </a>
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
                <form action="preorder-manager" method="POST">
                    <div class="modal-header border-0 p-4 pb-0">
                        <h5 class="fw-bold mb-0"><i class="fas fa-cart-plus text-primary me-2"></i>Đặt Thêm Món Ăn</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="mb-3">
                            <label class="form-label">Đơn đặt bàn liên quan</label>
                            <select name="reservationId" class="form-select">
                                <c:forEach items="${resList}" var="r">
                                    <option value="${r.reservationId}">Đơn #${r.reservationId}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Chọn món ăn</label>
                            <select name="dishId" class="form-select">
                                <c:forEach items="${dishList}" var="d">
                                    <option value="${d.dishId}">${d.dishName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Số lượng</label>
                                <input type="number" name="quantity" class="form-control" value="1" min="1" required>
                            </div>
                            <div class="col-md-8 mb-3">
                                <label class="form-label">Ghi chú bếp</label>
                                <input type="text" name="note" class="form-control" placeholder="Ít cay, bỏ hành...">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="submit" class="btn btn-primary w-100 py-3 fw-bold rounded-pill shadow">XÁC NHẬN GHI MÓN</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg">
                <form action="preorder-manager" method="POST">
                    <div class="modal-header border-0 p-4 pb-0">
                        <h5 class="fw-bold mb-0 text-primary"><i class="fas fa-edit me-2"></i>Điều Chỉnh Số Lượng</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="edit">
                        
                        <div class="row g-3">
                            <div class="col-6">
                                <label class="form-label text-muted small">Đơn đặt bàn</label>
                                <input type="text" name="reservationId" id="e_res" class="form-control bg-light" readonly>
                            </div>
                            <div class="col-6">
                                <label class="form-label text-muted small">Món ăn</label>
                                <input type="text" name="dishId" id="e_dish" class="form-control bg-light" readonly>
                            </div>
                            <div class="col-4">
                                <label class="form-label">Số lượng</label>
                                <input type="number" name="quantity" id="e_qty" class="form-control" required>
                            </div>
                            <div class="col-8">
                                <label class="form-label">Ghi chú mới</label>
                                <input type="text" name="note" id="e_note" class="form-control">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="submit" class="btn btn-primary w-100 py-3 fw-bold rounded-pill shadow">LƯU THAY ĐỔI</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function fillEdit(res, dish, qty, note) { 
            document.getElementById('e_res').value = res; 
            document.getElementById('e_dish').value = dish; 
            document.getElementById('e_qty').value = qty; 
            document.getElementById('e_note').value = note; 
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