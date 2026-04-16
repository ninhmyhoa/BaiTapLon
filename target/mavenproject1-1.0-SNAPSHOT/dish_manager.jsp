<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Thực Đơn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; color: #1e293b; }
        .main-content { margin-left: 260px; padding: 20px 30px; }
        .top-navbar { display: flex; justify-content: flex-end; padding: 10px 0 20px; border-bottom: 1px solid #e5e7eb; margin-bottom: 25px; }
        .navbar { background: #ffffff; border-bottom: 1px solid #e2e8f0; padding: 1rem 0; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .navbar-brand { font-weight: 800; color: #4338ca !important; letter-spacing: -0.5px; }

        /* Card & Table Styling */
        .main-card { border: none; border-radius: 20px; box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.05); background: white; overflow: hidden; }
        .table thead { background-color: #f8fafc; }
        .table thead th { border: none; color: #64748b; font-weight: 600; text-transform: uppercase; font-size: 0.75rem; padding: 1.25rem 1.5rem; letter-spacing: 0.5px; }
        .table tbody td { vertical-align: middle; padding: 1.25rem 1.5rem; border-bottom: 1px solid #f1f5f9; }
        
        /* Badges Styling */
        .dish-id-badge { background-color: #f1f5f9; color: #475569; padding: 4px 10px; border-radius: 8px; font-weight: 700; font-size: 0.8rem; }
        .cat-badge { background-color: #e0e7ff; color: #4338ca; padding: 4px 10px; border-radius: 8px; font-weight: 600; font-size: 0.8rem; }

        /* Price styling */
        .price-text { font-weight: 800; color: #059669; font-size: 1.1rem; }

        /* Action Buttons */
        .btn-action { width: 36px; height: 36px; display: inline-flex; align-items: center; justify-content: center; border-radius: 10px; transition: all 0.2s; border: none; }
        .btn-delete-custom { background: #fee2e2; color: #dc2626; }
        .btn-delete-custom:hover { background: #dc2626; color: white; }

        .btn-add { background: #4338ca; border: none; border-radius: 14px; font-weight: 700; padding: 12px 28px; box-shadow: 0 10px 15px -3px rgba(67, 56, 202, 0.3); transition: 0.3s; color: white;}
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
        <jsp:param name="menu" value="menu1" /> <jsp:param name="active" value="dish" /> </jsp:include>

    <div class="main-content">
        <div class="top-navbar">
            <span class="me-3 mt-1 fw-bold">Xin chào</span>
            <a href="login.jsp" class="btn btn-outline-danger btn-sm px-3 rounded-pill"><i class="fas fa-sign-out-alt me-1"></i>Đăng xuất</a>
        </div>

    <div class="container pb-5">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <h3 class="fw-bold mb-1">Danh sách món ăn</h3>
                <p class="text-muted mb-0 small text-uppercase fw-600" style="letter-spacing: 1px;">Quy định: Món ăn nhập sai giá bắt buộc phải xóa và tạo lại</p>
            </div>
            <button class="btn btn-add" data-bs-toggle="modal" data-bs-target="#addModal">
                <i class="fas fa-plus-circle me-2"></i> Thêm Món Mới
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
                            <th>Phân Loại</th>
                            <th>Tên Món Ăn</th>
                            <th class="text-end">Đơn Giá</th>
                            <th class="text-end">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${dishList}" var="d">
                            <tr>
                                <td><span class="dish-id-badge">#${d.dishId}</span></td>
                                <td><span class="cat-badge"><i class="fas fa-tag me-1 small opacity-50"></i>${d.categoryName}</span></td>
                                <td class="fw-bold text-dark">${d.dishName}</td>
                                <td class="text-end">
                                    <span class="price-text">
                                        <fmt:formatNumber value="${d.price}" type="number"/>
                                    </span> 
                                    <small class="text-muted fw-bold">VNĐ</small>
                                </td>
                                <td class="text-end text-nowrap">
                                    <a href="dish-manager?action=delete&id=${d.dishId}" 
                                       class="btn-action btn-delete-custom" 
                                       onclick="return confirm('Bạn có chắc chắn muốn xóa món ăn này khỏi thực đơn không?');">
                                        <i class="fas fa-trash-can"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
       
        <p class="text-center mt-5 text-muted small">Thông tin thực đơn được đồng bộ thời gian thực</p>
    </div>

    <div class="modal fade" id="addModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg">
                <form action="dish-manager" method="POST">
                    <div class="modal-header border-0 p-4 pb-0">
                        <h5 class="fw-bold mb-0 text-indigo-600"><i class="fas fa-plus-circle me-2"></i>Thêm Món Ăn Mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="alert border-0 rounded-4 py-2 small mb-3" style="background-color: #e0e7ff; color: #4338ca;">
                            <i class="fas fa-magic me-2"></i> Mã món ăn sẽ được hệ thống cấp tự động.
                        </div>

                        <div class="row g-3">
                            <div class="col-12">
                                <label class="form-label">Danh Mục</label>
                                <select name="categoryId" class="form-select">
                                    <c:forEach items="${catList}" var="c">
                                        <option value="${c.categoryId}">${c.categoryName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        
                        <div class="mt-3">
                            <label class="form-label">Tên Món Ăn</label>
                            <input type="text" name="dishName" class="form-control" placeholder="Nhập tên món..." required>
                        </div>
                        
                        <div class="mt-3">
                            <label class="form-label">Giá Bán Niêm Yết</label>
                            <div class="input-group">
                                <input type="number" step="0.01" name="price" class="form-control" placeholder="0.00" required>
                                <span class="input-group-text bg-white fw-bold">VNĐ</span>
                            </div>
                            <small class="text-danger mt-1 d-block fw-bold"><i class="fas fa-circle-exclamation me-1"></i>Lưu ý: Giá món không thể sửa sau khi thêm!</small>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="submit" class="btn btn-primary w-100 py-3 fw-bold rounded-pill shadow">LƯU VÀO THỰC ĐƠN</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

</div> <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>    <script>
        function fillEdit(id, catId, name, price) {
            document.getElementById('e_id').value = id;
            document.getElementById('e_cat').value = catId;
            document.getElementById('e_name').value = name;
            document.getElementById('e_price').value = price;
        }
    </script>
    <script>
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