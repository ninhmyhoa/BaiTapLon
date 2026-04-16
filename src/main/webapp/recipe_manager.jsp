<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%> <!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Định Lượng Món Ăn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; color: #1e293b; }
        .main-content { margin-left: 260px; padding: 20px 30px; }
        .top-navbar { display: flex; justify-content: flex-end; padding: 10px 0 20px; border-bottom: 1px solid #e5e7eb; margin-bottom: 25px; }
        .navbar { background: #ffffff; border-bottom: 1px solid #e2e8f0; padding: 1rem 0; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .navbar-brand { font-weight: 800; color: #4338ca !important; }

        /* Card & Table Styling */
        .main-card { border: none; border-radius: 20px; box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.05); background: white; overflow: hidden; }
        .table thead { background-color: #f8fafc; }
        .table thead th { border: none; color: #64748b; font-weight: 600; text-transform: uppercase; font-size: 0.75rem; padding: 1.25rem 1.5rem; letter-spacing: 0.5px; }
        .table tbody td { vertical-align: middle; padding: 1.25rem 1.5rem; border-bottom: 1px solid #f1f5f9; }
        
        /* Badges & Info Tags */
        .qty-badge { background-color: #eef2ff; color: #4338ca; padding: 6px 12px; border-radius: 10px; font-weight: 800; font-size: 1rem; }

        /* Action Buttons */
        .btn-action { width: 36px; height: 36px; display: inline-flex; align-items: center; justify-content: center; border-radius: 10px; transition: all 0.2s; border: none; }
        .btn-edit-custom { background: #e0e7ff; color: #4338ca; }
        .btn-edit-custom:hover { background: #4338ca; color: white; }
        .btn-delete-custom { background: #fee2e2; color: #dc2626; }
        .btn-delete-custom:hover { background: #dc2626; color: white; }

        .btn-add { background: #4338ca; border: none; border-radius: 14px; font-weight: 700; padding: 12px 28px; box-shadow: 0 10px 15px -3px rgba(67, 56, 202, 0.3); transition: 0.3s; color: white; }
        .btn-add:hover { background: #3730a3; transform: translateY(-2px); color: white; }

        /* Modal Customization */
        .modal-content { border: none; border-radius: 28px; }
        .form-label { font-weight: 700; font-size: 0.8rem; color: #64748b; text-transform: uppercase; margin-bottom: 0.5rem; }
        .form-control, .form-select { border-radius: 12px; padding: 12px 15px; border: 1px solid #e2e8f0; background-color: #f8fafc; }
        .form-control:focus { background-color: white; border-color: #4338ca; box-shadow: 0 0 0 4px rgba(67, 56, 202, 0.1); }
    </style>
</head>
<body>

    <jsp:include page="sidebar.jsp">
        <jsp:param name="menu" value="menu4" /> 
        <jsp:param name="active" value="recipe" /> 
    </jsp:include>

    <div class="main-content">
        <div class="top-navbar">
            <span class="me-3 mt-1 fw-bold">Xin chào</span>
            <a href="login.jsp" class="btn btn-outline-danger btn-sm px-3 rounded-pill"><i class="fas fa-sign-out-alt me-1"></i>Đăng xuất</a>
        </div>

        <div class="container pb-5">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <h3 class="fw-bold mb-1">Công thức và Thành phần</h3>
                    <p class="text-muted mb-0 small text-uppercase fw-600" style="letter-spacing: 1px;">Quản lý nguyên liệu tiêu thụ cho từng món ăn</p>
                </div>
                <button class="btn btn-add" data-bs-toggle="modal" data-bs-target="#addModal">
                    <i class="fas fa-plus-circle me-2"></i> Thêm Định Lượng
                </button>
            </div>
            
            <div class="row mb-3">
                <div class="col-md-5 col-sm-12">
                    <div class="input-group shadow-sm">
                        <span class="input-group-text bg-white border-end-0">
                            <i class="fas fa-search text-muted"></i>
                        </span>
                        <input type="text" id="searchInput" class="form-control border-start-0 ps-0" placeholder="Nhập thông tin cần tìm..." onkeyup="filterTable()">
                    </div>
                </div>
            </div>
            
            <div class="card main-card">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead>
                            <tr>
                                <th>Tên Món Ăn</th>
                                <th>Thành Phần Nguyên Liệu</th>
                                <th class="text-center">Định Lượng</th>
                                <th class="text-center">Đơn Vị Tính</th>
                                <th class="text-end">Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${recipeList}" var="r">
                                <tr>
                                    <td class="fw-bold text-dark"><i class="fas fa-utensils me-2 text-primary small"></i>${r.dishName}</td>
                                    <td><i class="fas fa-leaf text-success me-2 small"></i>${r.ingredientName}</td>
                                    
                                    <td class="text-center"><span class="qty-badge">${r.quantity}</span></td>
                                    
                                    <td class="text-center">
                                        <span class="badge bg-light text-dark border">${r.unit}</span>
                                        
                                        <c:if test="${r.unit.toLowerCase() == 'kg' && r.quantity < 1.0}">
                                            <br><small class="text-danger fw-bold">(<fmt:formatNumber value="${r.quantity * 1000}" maxFractionDigits="0"/> g)</small>
                                        </c:if>
                                        
                                        <c:if test="${(r.unit.toLowerCase() == 'l' || r.unit.toLowerCase() == 'lít' || r.unit.toLowerCase() == 'lit') && r.quantity < 1.0}">
                                            <br><small class="text-danger fw-bold">(<fmt:formatNumber value="${r.quantity * 1000}" maxFractionDigits="0"/> ml)</small>
                                        </c:if>
                                    </td>
                                    
                                    <td class="text-end text-nowrap">
                                        <button class="btn-action btn-edit-custom me-1" data-bs-toggle="modal" data-bs-target="#editModal" 
                                                onclick="fillEdit('${r.dishId}','${r.ingredientId}','${r.dishName}','${r.ingredientName}','${r.quantity}')">
                                            <i class="fas fa-pen-to-square"></i>
                                        </button>
                                        
                                        <a href="recipe-manager?action=delete&dishId=${r.dishId}&ingId=${r.ingredientId}" 
                                           class="btn-action btn-delete-custom" onclick="return confirm('Bạn có chắc muốn xóa thành phần định lượng này?');">
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
                    <form action="recipe-manager" method="POST">
                        <div class="modal-header border-0 p-4 pb-0">
                            <h5 class="fw-bold mb-0 text-indigo-600"><i class="fas fa-plus-circle me-2"></i>Tạo Định Lượng Mới</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body p-4">
                            <input type="hidden" name="action" value="add">
                            
                            <div class="mb-3">
                                <label class="form-label">Chọn Món Ăn</label>
                                <select name="dishId" class="form-select shadow-sm">
                                    <c:forEach items="${dishList}" var="d">
                                        <option value="${d.dishId}">${d.dishName}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Chọn Nguyên Liệu</label>
                                <select name="ingredientId" class="form-select shadow-sm">
                                    <c:forEach items="${ingList}" var="i">
                                        <option value="${i.ingredientId}">${i.ingredientName} (Trong kho: ${i.unit})</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="mb-2">
                                <label class="form-label">Số lượng tiêu thụ</label>
                                <div class="input-group shadow-sm">
                                    <input type="number" step="0.01" name="quantity" class="form-control" placeholder="VD: 50" required>
                                    <select name="recipeUnit" class="form-select border-start-0" style="max-width: 140px; background-color: #e0e7ff; font-weight: bold; cursor: pointer;">
                                        <option value="g">Gram (g)</option>
                                        <option value="kg">Kilogram (kg)</option>
                                        <option value="ml">Mililit (ml)</option>
                                        <option value="lít">Lít (l)</option>
                                        <option value="cái">Cái/Quả</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer border-0 p-4 pt-0">
                            <button type="submit" class="btn btn-primary w-100 py-3 fw-bold rounded-pill shadow" style="background: #4338ca; border: none;">XÁC NHẬN LƯU</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="modal fade" id="editModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content shadow-lg">
                    <form action="recipe-manager" method="POST">
                        <div class="modal-header border-0 p-4 pb-0">
                            <h5 class="fw-bold mb-0 text-primary"><i class="fas fa-edit me-2"></i>Cập Nhật Công Thức</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body p-4">
                            <input type="hidden" name="action" value="edit">
                            <input type="hidden" name="dishId" id="e_dish_id">
                            <input type="hidden" name="ingredientId" id="e_ing_id">
                            
                            <div class="row g-3">
                                <div class="col-6">
                                    <label class="form-label text-muted small">Món Ăn</label>
                                    <input type="text" id="e_dish_name" class="form-control bg-light" readonly>
                                </div>
                                <div class="col-6">
                                    <label class="form-label text-muted small">Nguyên Liệu</label>
                                    <input type="text" id="e_ing_name" class="form-control bg-light" readonly>
                                </div>
                                
                                <div class="col-12">
                                    <label class="form-label">Điều chỉnh số lượng tiêu thụ</label>
                                    <div class="input-group shadow-sm">
                                        <input type="number" step="0.01" name="quantity" id="e_qty" class="form-control" required>
                                        <select name="recipeUnit" class="form-select border-start-0" style="max-width: 140px; background-color: #e0e7ff; font-weight: bold; cursor: pointer;">
                                            <option value="g">Gram (g)</option>
                                            <option value="kg">Kilogram (kg)</option>
                                            <option value="ml">Mililit (ml)</option>
                                            <option value="lít">Lít (l)</option>
                                            <option value="cái">Cái/Quả</option>
                                        </select>
                                    </div>
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
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function fillEdit(dishId, ingId, dishName, ingName, qty) { 
            document.getElementById('e_dish_id').value = dishId;
            document.getElementById('e_ing_id').value = ingId; 
            document.getElementById('e_dish_name').value = dishName;
            document.getElementById('e_ing_name').value = ingName; 
            document.getElementById('e_qty').value = qty;
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