<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Danh Mục</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: #10b981;
            --primary-hover: #059669;
            --bg-light: #f9fafb;
        }

        body { font-family: 'Inter', sans-serif; background-color: var(--bg-light); color: #1f2937; }

        /* BỔ SUNG 2 DÒNG CSS NÀY CHO KHU VỰC BÊN PHẢI */
        .main-content { margin-left: 260px; padding: 20px 30px; }
        .top-navbar { display: flex; justify-content: flex-end; padding: 10px 0 20px; border-bottom: 1px solid #e5e7eb; margin-bottom: 25px; }

        /* Các CSS cũ của bà giữ nguyên hoàn toàn */
        .content-card { border: none; border-radius: 16px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06); overflow: hidden; background: white; }
        .table { margin-bottom: 0; }
        .table thead th { background-color: #f8fafc; color: #64748b; font-weight: 600; text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; padding: 1rem 1.5rem; border-bottom: 1px solid #e5e7eb; }
        .table tbody td { padding: 1rem 1.5rem; vertical-align: middle; border-bottom: 1px solid #f3f4f6; }
        .cat-id-badge { background-color: #ecfdf5; color: #065f46; padding: 0.25rem 0.75rem; border-radius: 9999px; font-weight: 600; font-size: 0.875rem; }
        .btn-add { background-color: var(--primary-color); border: none; border-radius: 10px; padding: 0.6rem 1.25rem; font-weight: 600; transition: all 0.2s; box-shadow: 0 4px 10px rgba(16, 185, 129, 0.2); color: white; }
        .btn-add:hover { background-color: var(--primary-hover); transform: translateY(-2px); box-shadow: 0 6px 15px rgba(16, 185, 129, 0.3); color: white; }
        .action-btn { width: 35px; height: 35px; display: inline-flex; align-items: center; justify-content: center; border-radius: 8px; transition: all 0.2s; margin-right: 5px; }
        .btn-edit-custom { background-color: #eff6ff; color: #2563eb; border: none; }
        .btn-edit-custom:hover { background-color: #2563eb; color: white; }
        .btn-delete-custom { background-color: #fef2f2; color: #dc2626; border: none; }
        .btn-delete-custom:hover { background-color: #dc2626; color: white; }
        .modal-content { border: none; border-radius: 20px; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25); }
        .modal-header { border-bottom: 1px solid #f3f4f6; padding: 1.5rem; }
        .form-control { border-radius: 10px; padding: 0.75rem 1rem; border: 1px solid #d1d5db; }
        .form-control:focus { border-color: var(--primary-color); box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1); }
    </style>
</head>
<body>

    <jsp:include page="sidebar.jsp">
        <jsp:param name="menu" value="menu1" /> <jsp:param name="active" value="category" /> </jsp:include>

    <div class="main-content">
        
        <div class="top-navbar">
            <span class="me-3 mt-1 fw-bold">Xin chào</span>
            <a href="login.jsp" class="btn btn-outline-danger btn-sm px-3 rounded-pill"><i class="fas fa-sign-out-alt me-1"></i>Đăng xuất</a>
        </div>

        <div class="container-fluid px-0">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1">Quản lý Thực Đơn</h2>
                    <p class="text-muted small mb-0">Phân loại món ăn để khách hàng dễ dàng lựa chọn</p>
                </div>
                <button class="btn btn-add" data-bs-toggle="modal" data-bs-target="#addModal">
                    <i class="fas fa-plus me-2"></i> Thêm Danh Mục
                </button>
            </div>
            
            <div class="row mb-3">
                <div class="col-md-5 col-sm-12">
                    <div class="input-group shadow-sm">
                        <span class="input-group-text bg-white border-end-0">
                            <i class="fas fa-search text-muted"></i>
                        </span>
                        <input type="text" id="searchInput" class="form-control border-start-0 ps-0" 
                               placeholder="Nhập thông tin cần tìm..." onkeyup="filterTable()">
                    </div>
                </div>
            </div>
            
            <div class="card content-card">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Mã Định Danh</th>
                                <th>Tên Danh Mục</th>
                                <th class="text-end">Tùy Chọn</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${catList}" var="c">
                                <tr>
                                    <td><span class="cat-id-badge">#${c.categoryId}</span></td>
                                    <td class="fw-bold text-dark">${c.categoryName}</td>
                                    <td class="text-end">
                                        <button class="action-btn btn-edit-custom" title="Chỉnh sửa" data-bs-toggle="modal" data-bs-target="#editModal" onclick="fillEdit('${c.categoryId}', '${c.categoryName}')">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <a href="category-manager?action=delete&id=${c.categoryId}" class="action-btn btn-delete-custom" title="Xóa" onclick="return confirm('Bạn có chắc muốn xóa danh mục này? Món ăn thuộc danh mục này cũng sẽ bị ảnh hưởng.');">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <div class="text-center mt-4">
                <p class="text-muted small">Dữ liệu được cập nhật thời gian thực vào hệ thống</p>
            </div>
        </div>

        <div class="modal fade" id="addModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <form action="category-manager" method="POST">
                        <div class="modal-header">
                            <h5 class="modal-title fw-bold text-success"><i class="fas fa-plus-circle me-2"></i>Thêm Danh Mục</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body p-4">
                            <input type="hidden" name="action" value="add">
                            <div class="alert alert-info border-0 rounded-4 py-2 small mb-4" style="background-color: #ecfdf5; color: #065f46;">
                                <i class="fas fa-magic me-2"></i> Mã danh mục sẽ được hệ thống cấp tự động.
                            </div>
                            <div class="mb-2">
                                <label class="form-label fw-600 small">TÊN DANH MỤC</label>
                                <input type="text" name="categoryName" class="form-control" placeholder="Nhập tên hiển thị..." required>
                            </div>
                        </div>
                        <div class="modal-footer border-0 p-4 pt-0">
                            <button type="button" class="btn btn-light rounded-pill" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-success px-4 rounded-pill fw-bold">Lưu Danh Mục</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="modal fade" id="editModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <form action="category-manager" method="POST">
                        <div class="modal-header border-bottom">
                            <h5 class="modal-title fw-bold text-primary"><i class="fas fa-edit me-2"></i>Cập Nhật Thông Tin</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body p-4">
                            <input type="hidden" name="action" value="edit">
                            <div class="mb-3">
                                <label class="form-label fw-600 small text-muted">MÃ DANH MỤC</label>
                                <input type="text" name="categoryId" id="e_id" class="form-control bg-light" readonly>
                            </div>
                            <div class="mb-2">
                                <label class="form-label fw-600 small">TÊN DANH MỤC MỚI</label>
                                <input type="text" name="categoryName" id="e_name" class="form-control" required>
                            </div>
                        </div>
                        <div class="modal-footer border-0 p-4 pt-0">
                            <button type="button" class="btn btn-light rounded-pill" data-bs-dismiss="modal">Bỏ qua</button>
                            <button type="submit" class="btn btn-primary px-4 rounded-pill fw-bold">Cập Nhật Ngay</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

    </div> <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function fillEdit(id, name) {
            document.getElementById('e_id').value = id;
            document.getElementById('e_name').value = name;
        }

        function filterTable() {
            var input = document.getElementById("searchInput").value.toLowerCase();
            var tr = document.querySelectorAll("tbody tr");
            tr.forEach(row => {
                row.style.display = row.innerText.toLowerCase().includes(input) ? "" : "none";
            });
        }
    </script>
</body>
</html>