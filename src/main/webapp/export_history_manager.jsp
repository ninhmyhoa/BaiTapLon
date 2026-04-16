<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Sử Xuất Kho</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        body { 
            font-family: 'Inter', sans-serif; 
            background-color: #f1f5f9; 
            color: #334155;
        }
        .main-content { margin-left: 260px; padding: 20px 30px; }
        .top-navbar { display: flex; justify-content: flex-end; padding: 10px 0 20px; border-bottom: 1px solid #e5e7eb; margin-bottom: 25px; }
        .navbar { 
            background: #ffffff; 
            border-bottom: 2px solid #e2e8f0; 
            padding: 1rem 0;
        }
        .navbar-brand { font-weight: 700; color: #2563eb !important; }

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
        }
        .table tbody td { 
            vertical-align: middle; 
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid #f1f5f9;
        }
        
        /* Badges */
        .batch-badge {
            background-color: #fef3c7;
            color: #92400e;
            padding: 4px 10px;
            border-radius: 8px;
            font-weight: 700;
            font-size: 0.8rem;
        }
        .emp-tag {
            background-color: #f0fdf4;
            color: #166534;
            padding: 4px 10px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.8rem;
        }

        .qty-text { font-weight: 700; color: #ef4444; }
        .date-text { color: #64748b; font-size: 0.9rem; }

        /* Buttons */
        .btn-add { 
            background: #2563eb;
            border: none;
            border-radius: 12px; 
            font-weight: 600; 
            padding: 10px 24px;
            box-shadow: 0 10px 15px -3px rgba(37, 99, 235, 0.3);
            transition: 0.3s;
        }
        .btn-add:hover { background: #1d4ed8; transform: translateY(-2px); color: white; }

        .btn-action { 
            width: 34px; height: 34px; 
            display: inline-flex; align-items: center; justify-content: center; 
            border-radius: 10px; transition: 0.2s; border: none;
        }
        .btn-edit-custom { background: #eff6ff; color: #2563eb; }
        .btn-edit-custom:hover { background: #2563eb; color: white; }
        
        .btn-delete-custom { background: #fef2f2; color: #dc2626; }
        .btn-delete-custom:hover { background: #dc2626; color: white; }

        /* Modal Custom */
        .modal-content { border: none; border-radius: 24px; }
        .form-label { font-weight: 600; font-size: 0.85rem; color: #475569; }
        .form-control, .form-select { border-radius: 12px; padding: 12px; border: 1px solid #e2e8f0; background-color: #f8fafc; }
    </style>
</head>
<body>

<jsp:include page="sidebar.jsp">
        <jsp:param name="menu" value="menu5" /> <jsp:param name="active" value="export-history" /> </jsp:include>

    <div class="main-content">
        
        <div class="top-navbar">
            <span class="me-3 mt-1 fw-bold">Xin chào</span>
            <a href="login.jsp" class="btn btn-outline-danger btn-sm px-3 rounded-pill"><i class="fas fa-sign-out-alt me-1"></i>Đăng xuất</a>
        </div>

    <div class="container pb-5">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <h3 class="fw-bold mb-1">Nhật ký xuất nguyên liệu</h3>
                <p class="text-muted mb-0 small text-uppercase fw-600" style="letter-spacing: 1px;">Theo dõi biến động tồn kho thực tế</p>
            </div>
            <button class="btn btn-success btn-add" data-bs-toggle="modal" data-bs-target="#addModal">
                <i class="fas fa-plus me-2"></i> Ghi Nhận Xuất Kho
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
                            <th>Ngày Xuất / Người Lập</th>
                            <th>Mã Lô Hàng</th>
                            <th>Tên Nguyên Liệu</th>
                            <th class="text-center">Số Lượng</th>
                            <th class="text-center">Đơn Vị</th>
                            <th>Mục Đích Sử Dụng</th>
                            <th class="text-end">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${exportList}" var="x">
                            <tr>
                                <td class="date-text fw-medium">
                                    <div><i class="far fa-clock me-2"></i>${x.exportDate.replace('T', ' ')}</div>
                                    <div class="small text-primary mt-1 fw-bold">
                                        <i class="fas fa-user-tag me-1"></i>${x.employeeName}
                                    </div>
                                </td>
                                
                                <td><span class="batch-badge">#${x.batchId}</span></td>
                                
                                <td class="fw-bold text-dark">${x.ingredientName}</td>
                                
                                <td class="text-center qty-text fs-5">${x.exportQuantity}</td>
                                
                                <td class="text-center">
                                    <span class="badge bg-secondary rounded-pill px-3">${x.unit}</span>
                                </td>
                                
                                <td class="text-muted italic small">${x.exportPurpose}</td>
                                
                                <td class="text-end">
                                    <button class="btn-action btn-edit-custom me-1" 
                                            data-bs-toggle="modal" 
                                            data-bs-target="#editModal" 
                                            onclick="fillEdit('${x.exportDate}','${x.batchId}','${x.employeeId}','${x.exportQuantity}','${x.exportPurpose}')">
                                        <i class="fas fa-pen"></i>
                                    </button>
                                    <a href="export-history-manager?action=delete&time=${x.exportDate}&batchId=${x.batchId}" 
                                       class="btn-action btn-delete-custom" 
                                       onclick="return confirm('Xác nhận xóa bản ghi xuất kho này?');">
                                        <i class="fas fa-trash-can"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
        
        <c:if test="${empty exportList}">
            <div class="text-center py-5">
                <i class="fas fa-box-open fa-3x text-muted mb-3 opacity-25"></i>
                <p class="text-muted">Chưa có dữ liệu xuất kho nào được ghi lại.</p>
            </div>
        </c:if>
    </div>

    <div class="modal fade" id="addModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg">
                <form action="export-history-manager" method="POST">
                    <div class="modal-header border-0 p-4 pb-0">
                        <h5 class="fw-bold"><i class="fas fa-file-export text-success me-2"></i>Ghi Nhận Xuất Kho</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="mb-3">
                            <label class="form-label">THỜI GIAN XUẤT</label>
                            <input type="datetime-local" name="exportDate" class="form-control shadow-sm" required>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">CHỌN LÔ HÀNG</label>
                                <select name="batchId" class="form-select shadow-sm">
                                    <c:forEach items="${batchList}" var="b">
                                        <option value="${b.batchId}">Lô #${b.batchId} (Tồn: ${b.stockQuantity})</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">NGƯỜI THỰC HIỆN</label>
                                <select name="employeeId" class="form-select bg-light" style="pointer-events: none;" readonly>             
                                    <option value="${sessionScope.user.employeeId}" selected>
                                        ${sessionScope.user.fullName}
                                    </option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">SỐ LƯỢNG XUẤT</label>
                            <input type="number" step="0.01" name="exportQuantity" class="form-control shadow-sm" placeholder="VD: 5.5" required>
                        </div>

                        <div class="mb-2">
                            <label class="form-label">MỤC ĐÍCH SỬ DỤNG</label>
                            <input type="text" name="exportPurpose" class="form-control shadow-sm" placeholder="VD: Chế biến món bò bít tết" required>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="submit" class="btn btn-success w-100 py-3 fw-bold shadow">XÁC NHẬN XUẤT KHO</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg">
                <form action="export-history-manager" method="POST">
                    <div class="modal-header border-0 p-4 pb-0">
                        <h5 class="fw-bold"><i class="fas fa-edit text-primary me-2"></i>Điều Chỉnh Lịch Sử</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="edit">
                        
                        <div class="row">
                            <div class="col-md-6 mb-3 text-muted">
                                <label class="form-label">THỜI GIAN (CỐ ĐỊNH)</label>
                                <input type="text" id="e_date_display" class="form-control bg-light border-0" disabled>
                                <input type="hidden" name="exportDate" id="e_date">
                            </div>
                            <div class="col-md-6 mb-3 text-muted">
                                <label class="form-label">MÃ LÔ (CỐ ĐỊNH)</label>
                                <input type="text" name="batchId" id="e_batch" class="form-control bg-light border-0" readonly>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">NGƯỜI XUẤT THAY THẾ</label>
                            <select name="employeeId" class="form-select bg-light" style="pointer-events: none;" readonly>             
                                <option value="${sessionScope.user.employeeId}" selected>
                                    ${sessionScope.user.fullName}
                                </option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">CẬP NHẬT SỐ LƯỢNG</label>
                            <input type="number" step="0.01" name="exportQuantity" id="e_qty" class="form-control" required>
                        </div>

                        <div class="mb-2">
                            <label class="form-label">CẬP NHẬT MỤC ĐÍCH</label>
                            <input type="text" name="exportPurpose" id="e_purp" class="form-control" required>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="submit" class="btn btn-primary w-100 py-3 fw-bold shadow">CẬP NHẬT THÔNG TIN</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function fillEdit(date, batch, emp, qty, purp) { 
            document.getElementById('e_date').value = date;
            document.getElementById('e_date_display').value = date.replace('T', ' ');
            document.getElementById('e_batch').value = batch; 
            document.getElementById('e_emp').value = emp; 
            document.getElementById('e_qty').value = qty; 
            document.getElementById('e_purp').value = purp; 
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