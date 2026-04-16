<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Nhân Sự</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; color: #1e293b; }
        .main-content { margin-left: 260px; padding: 20px 30px; }
        .top-navbar { display: flex; justify-content: flex-end; padding: 10px 0 20px; border-bottom: 1px solid #e5e7eb; margin-bottom: 25px; }
        .navbar { background: #ffffff; border-bottom: 1px solid #e2e8f0; padding: 1rem 0; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .navbar-brand { font-weight: 700; color: #4f46e5 !important; }
        .main-card { border: none; border-radius: 16px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); background: white; overflow: hidden; }
        .table thead { background-color: #f8fafc; }
        .table thead th { border: none; color: #64748b; font-weight: 600; text-transform: uppercase; font-size: 0.75rem; padding: 1.25rem 1rem; }
        .table tbody td { vertical-align: middle; padding: 1rem; border-bottom: 1px solid #f1f5f9; font-size: 0.9rem; }
        .badge-manager { background-color: #fee2e2; color: #dc2626; border-radius: 20px; padding: 5px 12px; }
        .badge-chef { background-color: #fef3c7; color: #d97706; border-radius: 20px; padding: 5px 12px; }
        .badge-waiter { background-color: #e0e7ff; color: #4338ca; border-radius: 20px; padding: 5px 12px; }
        .btn-action { width: 32px; height: 32px; display: inline-flex; align-items: center; justify-content: center; border-radius: 8px; transition: 0.2s; border: none; margin-right: 5px;}
        .btn-edit-custom { background: #eff6ff; color: #2563eb; }
        .btn-edit-custom:hover { background: #2563eb; color: white; }
        .btn-delete-custom { background: #fef2f2; color: #dc2626; }
        .btn-delete-custom:hover { background: #dc2626; color: white; }
        .btn-add { border-radius: 12px; font-weight: 600; padding: 10px 24px; box-shadow: 0 4px 12px rgba(79, 70, 229, 0.2); }
        .modal-content { border: none; border-radius: 20px; }
        .form-label { font-weight: 600; font-size: 0.85rem; color: #475569; }
        .form-control, .form-select { border-radius: 10px; padding: 10px 15px; border: 1px solid #e2e8f0; background-color: #f8fafc; }
        .form-control:focus { background-color: #fff; border-color: #4f46e5; box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1); }
    </style>
</head>
<body>

    <jsp:include page="sidebar.jsp">
        <jsp:param name="menu" value="menu3" /> <jsp:param name="active" value="employee" /> </jsp:include>

    <div class="main-content">
        
        <div class="top-navbar">
            <span class="me-3 mt-1 fw-bold">Xin chào</span>
            <a href="login.jsp" class="btn btn-outline-danger btn-sm px-3 rounded-pill"><i class="fas fa-sign-out-alt me-1"></i>Đăng xuất</a>
        </div>

    <div class="container pb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1 text-dark">Danh sách nhân viên</h3>
                <p class="text-muted mb-0 small">Quản lý tài khoản và phân quyền nhân sự</p>
            </div>
            <button class="btn btn-primary btn-add" data-bs-toggle="modal" data-bs-target="#addModal">
                <i class="fas fa-plus me-2"></i> Thêm Nhân Viên
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
                            <th>ID</th>
                            <th>Họ và Tên</th>
                            <th>Liên hệ</th>
                            <th>Địa chỉ</th>
                            <th class="text-center">Chức vụ</th>
                            <th>Mật khẩu</th>
                            <th class="text-end">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${empList}" var="e">
                            <tr>
                                <td class="fw-bold text-primary">${e.employeeId}</td>
                                <td class="fw-bold text-dark">${e.fullName}</td>
                                <td>
                                    <div class="small"><i class="fas fa-phone me-2 text-muted"></i>${e.phone}</div>
                                    <div class="small text-muted"><i class="fas fa-envelope me-2 text-muted"></i>${e.email}</div>
                                </td>
                                <td class="text-muted small">${e.street}, ${e.district}, ${e.city}</td>
                                <td class="text-center">
                                    <span class="badge ${e.position == 'Manager' ? 'badge-manager' : (e.position == 'Chef' ? 'badge-chef' : 'badge-waiter')}">
                                        ${e.position}
                                    </span>
                                </td>
                                <td><code class="text-muted">****</code></td>
                                <td class="text-end text-nowrap">
                                    <button class="btn-action btn-edit-custom me-1" 
                                            data-bs-toggle="modal" 
                                            data-bs-target="#editModal"
                                            onclick="fillEditModal('${e.employeeId}', '${e.firstName}', '${e.lastName}', '${e.phone}', '${e.street}', '${e.district}', '${e.city}', '${e.position}', '${e.email}', '${e.password}')">
                                        <i class="fas fa-pen"></i>
                                    </button>
                                    <a href="employee-manager?action=delete&id=${e.employeeId}" 
                                       class="btn-action btn-delete-custom" 
                                       onclick="return confirm('Bạn có chắc muốn xóa nhân viên này khỏi hệ thống?');">
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
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content shadow-lg">
                <form action="employee-manager" method="POST">
                    <div class="modal-header border-0 p-4 pb-0">
                        <h5 class="fw-bold mb-0">Thêm Nhân Viên Mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label text-uppercase small">Chức vụ</label>
                                <select name="position" class="form-select">
                                    <option value="Manager">Manager</option>
                                    <option value="Waiter" selected>Waiter</option>
                                    <option value="Chef">Chef</option>
                                </select>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label text-uppercase small">Họ đệm</label>
                                <input type="text" name="lastName" class="form-control" placeholder="Nguyễn Văn" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label text-uppercase small">Tên</label>
                                <input type="text" name="firstName" class="form-control" placeholder="A" required>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-uppercase small">Số điện thoại</label>
                                <input type="text" name="phone" class="form-control">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label text-uppercase small">Email</label>
                                <input type="email" name="email" class="form-control">
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label text-uppercase small">Số nhà, Đường</label>
                                <input type="text" name="street" class="form-control">
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label text-uppercase small">Quận/Huyện</label>
                                <input type="text" name="district" class="form-control">
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label text-uppercase small">Thành phố</label>
                                <input type="text" name="city" class="form-control">
                            </div>
                        </div>

                        <div class="mb-1">
                            <label class="form-label text-uppercase small">Mật khẩu truy cập</label>
                            <input type="password" name="password" class="form-control" required>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="submit" class="btn btn-primary w-100 py-3 fw-bold rounded-pill">LƯU NHÂN VIÊN</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content shadow-lg">
                <form action="employee-manager" method="POST">
                    <div class="modal-header border-0 p-4 pb-0">
                        <h5 class="fw-bold mb-0">Cập Nhật Nhân Sự</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="edit">
                        
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label text-uppercase small text-muted">Mã NV</label>
                                <input type="text" name="employeeId" id="edit_id" class="form-control bg-light" readonly>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label text-uppercase small">Họ đệm</label>
                                <input type="text" name="lastName" id="edit_lastName" class="form-control" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label text-uppercase small">Tên</label>
                                <input type="text" name="firstName" id="edit_firstName" class="form-control" required>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label text-uppercase small">Chức vụ</label>
                                <select name="position" id="edit_pos" class="form-select">
                                    <option value="Manager">Manager</option>
                                    <option value="Waiter">Waiter</option>
                                    <option value="Chef">Chef</option>
                                </select>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label text-uppercase small">Số điện thoại</label>
                                <input type="text" name="phone" id="edit_phone" class="form-control">
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label text-uppercase small">Email</label>
                                <input type="email" name="email" id="edit_email" class="form-control">
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label text-uppercase small">Số nhà, Đường</label>
                                <input type="text" name="street" id="edit_street" class="form-control">
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label text-uppercase small">Quận/Huyện</label>
                                <input type="text" name="district" id="edit_district" class="form-control">
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label text-uppercase small">Thành phố</label>
                                <input type="text" name="city" id="edit_city" class="form-control">
                            </div>
                        </div>

                        <div class="mb-1">
                            <label class="form-label text-uppercase small">Đổi mật khẩu</label>
                            <input type="text" name="password" id="edit_pass" class="form-control" required>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="submit" class="btn btn-primary w-100 py-3 fw-bold rounded-pill">CẬP NHẬT NGAY</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Cập nhật lại hàm map dữ liệu cho khớp với các ô input mới
        function fillEditModal(id, firstName, lastName, phone, street, district, city, pos, email, pass) {
            document.getElementById('edit_id').value = id;
            document.getElementById('edit_firstName').value = firstName;
            document.getElementById('edit_lastName').value = lastName;
            document.getElementById('edit_phone').value = phone;
            document.getElementById('edit_street').value = street;
            document.getElementById('edit_district').value = district;
            document.getElementById('edit_city').value = city;
            document.getElementById('edit_pos').value = pos;
            document.getElementById('edit_email').value = email;
            document.getElementById('edit_pass').value = pass;
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