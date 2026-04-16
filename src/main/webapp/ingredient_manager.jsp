<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Nguyên Liệu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-mint: #10b981; /* Emerald 500 */
            --primary-hover: #059669;
            --bg-light: #f8fafc;
        }

        body { 
            font-family: 'Inter', sans-serif; 
            background-color: var(--bg-light); 
            margin: 0; 
            color: #1e293b; 
        }
        .main-content { margin-left: 260px; padding: 20px 30px; }
        .top-navbar { display: flex; justify-content: flex-end; padding: 10px 0 20px; border-bottom: 1px solid #e5e7eb; margin-bottom: 25px; }
        
        /* --- NAVBAR --- */
        .navbar { 
            background: #ffffff; 
            border-bottom: 1px solid #e2e8f0; 
            padding: 1rem 0; 
            box-shadow: 0 1px 3px rgba(0,0,0,0.05); 
        }
        .navbar-brand { font-weight: 800; color: var(--primary-mint) !important; }

        /* --- MAIN CARD & TABLE --- */
        .main-card { 
            background-color: #ffffff; 
            border: none; 
            border-radius: 20px; 
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.05); 
            overflow: hidden; 
        }
        
        .table thead { background-color: #f8fafc; }
        .table thead th { 
            border: none; color: #64748b; 
            font-weight: 600; text-transform: uppercase; 
            font-size: 0.75rem; padding: 1.25rem 1.5rem; 
            letter-spacing: 0.5px; 
        }
        .table tbody td { 
            vertical-align: middle; 
            padding: 1rem 1.5rem; 
            border-bottom: 1px solid #f1f5f9; 
            font-size: 0.9rem; 
        }

        /* Badges */
        .ing-id { font-weight: 700; color: #059669; }
        .unit-badge { 
            background-color: #f0fdf4; 
            color: #166534; padding: 4px 12px; 
            border-radius: 20px; font-weight: 600; 
            font-size: 0.8rem; border: 1px solid #dcfce7; 
        }
        .min-stock-text { color: #dc2626; font-weight: 700; }

        /* Buttons */
        .btn-add { 
            background: var(--primary-mint); 
            border: none; border-radius: 12px; 
            font-weight: 700; padding: 12px 28px; 
            box-shadow: 0 10px 15px -3px rgba(16, 185, 129, 0.2); 
            transition: 0.3s; color: white; 
        }
        .btn-add:hover { background: var(--primary-hover); transform: translateY(-2px); color: white; }

        .btn-action { 
            width: 34px; height: 34px; 
            display: inline-flex; align-items: center; justify-content: center; 
            border-radius: 10px; transition: 0.2s; border: none; margin-right: 5px; 
        }
        .btn-edit-custom { background: #ecfdf5; color: #059669; }
        .btn-edit-custom:hover { background: #059669; color: white; }
        .btn-delete-custom { background: #fef2f2; color: #dc2626; }
        .btn-delete-custom:hover { background: #dc2626; color: white; }

        /* Modal Custom */
        .modal-content { border: none; border-radius: 24px; }
        .form-label { font-weight: 700; font-size: 0.8rem; color: #64748b; text-transform: uppercase; margin-bottom: 0.5rem; }
        .form-control { border-radius: 12px; padding: 12px 15px; border: 1px solid #e5e7eb; background-color: #f8fafc; transition: 0.2s;}
        .form-control:focus { background-color: white; border-color: var(--primary-mint); box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1); }
    </style>
</head>
<body>

<jsp:include page="sidebar.jsp">
        <jsp:param name="menu" value="menu4" /> <jsp:param name="active" value="ingredient" /> </jsp:include>

    <div class="main-content">
        
        <div class="top-navbar">
            <span class="me-3 mt-1 fw-bold">Xin chào</span>
            <a href="login.jsp" class="btn btn-outline-danger btn-sm px-3 rounded-pill"><i class="fas fa-sign-out-alt me-1"></i>Đăng xuất</a>
        </div>

    <div class="container pb-5">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <h3 class="fw-bold mb-1">Danh mục vật tư</h3>
                <p class="text-muted mb-0 small text-uppercase fw-600" style="letter-spacing: 1px;">Quản lý định mức tồn kho an toàn</p>
            </div>
            <button class="btn btn-add" data-bs-toggle="modal" data-bs-target="#addModal">
                <i class="fas fa-plus-circle me-2"></i> Thêm Nguyên Liệu
            </button>
        </div>

        <div class="row mb-3">
            <div class="col-md-5 col-sm-12">
                <div class="input-group shadow-sm border rounded-3 overflow-hidden">
                    <span class="input-group-text bg-white border-0">
                        <i class="fas fa-search text-muted"></i>
                    </span>
                    <input type="text" id="searchInput" class="form-control border-0 ps-0" 
                           placeholder="Nhập thông tin cần tìm..." 
                           onkeyup="filterTable()">
                </div>
            </div>
        </div>

        <div class="card main-card">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>Mã Định Danh</th>
                            <th>Tên Nguyên Liệu</th>
                            <th class="text-center">Tổng Hàng Thực Tế</th>
                            <th class="text-center">Tồn Kho Tối Thiểu</th>
                            <th class="text-center">Đơn Vị Tính</th>
                            <th class="text-end">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${ingList}" var="i">
                            <tr>
                                <td><span class="ing-id">${i.ingredientId}</span></td>
                                <td class="fw-bold text-dark">${i.ingredientName}</td>
                                
                                <td class="text-center">
                                    <span class="fw-bold fs-5 text-primary">${i.totalStock}</span>
                                    
                                    <c:if test="${i.totalStock <= i.minStock}">
                                        <div class="badge bg-danger mt-1" style="font-size: 0.65rem;">CẦN NHẬP THÊM</div>
                                    </c:if>
                                </td>

                                <td class="text-center min-stock-text">
                                    <i class="fas fa-triangle-exclamation me-1 small opacity-50"></i> ${i.minStock}
                                </td>
                                <td class="text-center">
                                    <span class="unit-badge">${i.unit}</span>
                                </td>
                                <td class="text-end text-nowrap">
                                    <button class="btn-action btn-edit-custom" 
                                            data-bs-toggle="modal" 
                                            data-bs-target="#editModal" 
                                            onclick="fillEdit('${i.ingredientId}','${i.ingredientName}','${i.minStock}','${i.unit}')">
                                        <i class="fas fa-pen-to-square"></i>
                                    </button>
                                    <a href="ingredient-manager?action=delete&id=${i.ingredientId}" 
                                       class="btn-action btn-delete-custom" 
                                       onclick="return confirm('Xóa nguyên liệu này sẽ ảnh hưởng đến các công thức liên quan. Tiếp tục?');">
                                        <i class="fas fa-trash-can"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="addModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg">
                <form action="ingredient-manager" method="POST">
                    <div class="modal-header border-0 p-4 pb-0">
                        <h5 class="fw-bold text-success"><i class="fas fa-plus-circle me-2"></i>Thêm Nguyên Liệu</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="alert alert-success border-0 rounded-4 py-2 small mb-4" style="background-color: #ecfdf5; color: #065f46;">
                            <i class="fas fa-magic me-2"></i> Mã nguyên liệu sẽ được hệ thống cấp tự động.
                        </div>

                        <div class="mb-3">
                            <label class="form-label">TÊN NGUYÊN LIỆU</label>
                            <input type="text" name="ingredientName" class="form-control" placeholder="Ví dụ: Thịt bò Úc" required>
                        </div>
                        <div class="row">
                            <div class="col-6 mb-3">
                                <label class="form-label">TỒN TỐI THIỂU</label>
                                <input type="number" step="0.01" name="minStock" class="form-control" placeholder="VD: 5.0" required>
                            </div>
                            <div class="col-6 mb-3">
                                <label class="form-label">ĐƠN VỊ TÍNH</label>
                                <input type="text" name="unit" class="form-control" placeholder="kg, túi, lít..." required>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="submit" class="btn w-100 py-3 fw-bold rounded-pill shadow text-white" style="background: #10b981; border: none;">LƯU THÔNG TIN</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg">
                <form action="ingredient-manager" method="POST">
                    <div class="modal-header border-0 p-4 pb-0">
                        <h5 class="fw-bold text-primary"><i class="fas fa-edit me-2"></i>Cập Nhật Nguyên Liệu</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="edit">
                        <div class="mb-3">
                            <label class="form-label text-muted small">MÃ NGUYÊN LIỆU</label>
                            <input type="text" name="ingredientId" id="e_id" class="form-control bg-light border-0 fw-bold" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">TÊN NGUYÊN LIỆU MỚI</label>
                            <input type="text" name="ingredientName" id="e_name" class="form-control" required>
                        </div>
                        <div class="row">
                            <div class="col-6 mb-3">
                                <label class="form-label">TỒN TỐI THIỂU MỚI</label>
                                <input type="number" step="0.01" name="minStock" id="e_min" class="form-control" required>
                            </div>
                            <div class="col-6 mb-3">
                                <label class="form-label">ĐƠN VỊ TÍNH</label>
                                <input type="text" name="unit" id="e_unit" class="form-control" required>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="submit" class="btn btn-primary w-100 py-3 fw-bold rounded-pill shadow" style="background: #2563eb; border:none;">CẬP NHẬT NGAY</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function fillEdit(id, name, min, unit) { 
            document.getElementById('e_id').value = id; 
            document.getElementById('e_name').value = name; 
            document.getElementById('e_min').value = min; 
            document.getElementById('e_unit').value = unit; 
        }

        function filterTable() {
            var input = document.getElementById("searchInput");
            var filter = input.value.toLowerCase();
            var table = document.querySelector(".table");
            if (!table) return; 
            
            var tr = table.getElementsByTagName("tbody")[0].getElementsByTagName("tr");
            for (var i = 0; i < tr.length; i++) {
                var rowText = tr[i].textContent || tr[i].innerText;
                if (rowText.toLowerCase().indexOf(filter) > -1) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                }
            }
        }
    </script>
</body>
</html>