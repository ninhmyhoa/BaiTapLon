<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Khách Hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        body { 
            font-family: 'Inter', sans-serif; 
            background-color: #f8fafc; 
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
        .navbar-brand { font-weight: 800; color: #4338ca !important; }

        /* --- MAIN CARD & TABLE --- */
        .main-card { 
            background-color: #ffffff; 
            border-radius: 20px; 
            border: none;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.05); 
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
        
        /* Badges Styling */
        .id-badge { 
            background-color: #eef2ff; 
            color: #4338ca; 
            padding: 6px 12px; 
            border-radius: 10px; 
            font-weight: 700; 
            font-size: 0.85rem; 
        }

        /* Action Buttons */
        .btn-action { 
            width: 36px; height: 36px; 
            display: inline-flex; align-items: center; justify-content: center; 
            border-radius: 10px; transition: all 0.2s; border: none; margin-right: 5px; 
        }
        .btn-edit-custom { background: #e0e7ff; color: #4338ca; }
        .btn-edit-custom:hover { background: #4338ca; color: white; }
        .btn-delete-custom { background: #fee2e2; color: #dc2626; }
        .btn-delete-custom:hover { background: #dc2626; color: white; }

        .btn-add { 
            background: #4338ca; 
            border: none; border-radius: 14px; 
            font-weight: 700; padding: 12px 28px; 
            box-shadow: 0 10px 15px -3px rgba(67, 56, 202, 0.3); 
            transition: 0.3s; color: white;
        }
        .btn-add:hover { background: #3730a3; transform: translateY(-2px); color: white; }

        /* Modal Customization */
        .modal-content { border: none; border-radius: 28px; }
        .form-label { font-weight: 700; font-size: 0.8rem; color: #64748b; text-transform: uppercase; margin-bottom: 0.5rem; }
        .form-control { 
            border-radius: 12px; padding: 12px 15px; 
            border: 1px solid #e2e8f0; background-color: #f8fafc; transition: 0.2s; 
        }
        .form-control:focus { background-color: white; border-color: #4338ca; box-shadow: 0 0 0 4px rgba(67, 56, 202, 0.1); }
    </style>
</head>
<body>

   <jsp:include page="sidebar.jsp">
        <jsp:param name="menu" value="menu3" /> <jsp:param name="active" value="customer" /> </jsp:include>

    <div class="main-content">
        
        <div class="top-navbar">
            <span class="me-3 mt-1 fw-bold">Xin chào</span>
            <a href="login.jsp" class="btn btn-outline-danger btn-sm px-3 rounded-pill"><i class="fas fa-sign-out-alt me-1"></i>Đăng xuất</a>
        </div>

    <div class="container pb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold mb-1">Cơ sở dữ liệu hội viên</h3>
                <p class="text-muted mb-0 small text-uppercase fw-600" style="letter-spacing: 1px;">Quản lý thông tin liên hệ và lịch sử khách hàng</p>
            </div>
            <button class="btn btn-add" data-bs-toggle="modal" data-bs-target="#addModal">
                <i class="fas fa-plus me-2"></i> Thêm Khách Hàng
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
                            <th>Mã KH</th>
                            <th>Họ và Tên</th>
                            <th>Số Điện Thoại</th>
                            <th>Email Liên Hệ</th>
                            <th class="text-end">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${custList}" var="c">
                            <tr>
                                <td><span class="id-badge">#${c.customerId}</span></td>
                                <td class="fw-bold text-dark">${c.fullName}</td>
                                <td><i class="fas fa-phone text-muted me-2 small"></i>${c.phone}</td>
                                <td><i class="fas fa-envelope text-muted me-2 small"></i>${c.email}</td>
                                <td class="text-end text-nowrap">
                                    <button class="btn-action btn-edit-custom" 
                                            data-bs-toggle="modal" 
                                            data-bs-target="#editModal" 
                                            onclick="fillEdit('${c.customerId}','${c.fullName}','${c.phone}','${c.email}')">
                                        <i class="fas fa-pen-to-square"></i>
                                    </button>
                                    <a href="customer-manager?action=delete&id=${c.customerId}" 
                                       class="btn-action btn-delete-custom" 
                                       onclick="return confirm('Bạn có chắc muốn xóa khách hàng này? Mọi lịch sử đặt bàn liên quan sẽ mất thông tin định danh.');">
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
                <form action="customer-manager" method="POST">
                    <div class="modal-header border-0 p-4 pb-0">
                        <h5 class="fw-bold mb-0 text-primary"><i class="fas fa-user-plus me-2"></i>Đăng Ký Thành Viên</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="alert alert-info border-0 rounded-4 py-2 small mb-4" style="background-color: #e0e7ff; color: #4338ca;">
                            <i class="fas fa-magic me-2"></i> Mã khách hàng sẽ được hệ thống cấp tự động.
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Họ và Tên khách hàng</label>
                            <input type="text" name="fullName" class="form-control shadow-sm" placeholder="Nhập tên đầy đủ..." required>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Số điện thoại</label>
                                <input type="text" name="phone" class="form-control shadow-sm" placeholder="09xx...">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Email</label>
                                <input type="email" name="email" class="form-control shadow-sm" placeholder="example@mail.com">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="submit" class="btn w-100 py-3 fw-bold rounded-pill shadow text-white" style="background: #4338ca; border: none;">LƯU THÔNG TIN</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg">
                <form action="customer-manager" method="POST">
                    <div class="modal-header border-0 p-4 pb-0">
                        <h5 class="fw-bold mb-0 text-indigo-600"><i class="fas fa-user-pen me-2"></i>Cập Nhật Hồ Sơ</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="edit">
                        <div class="mb-3">
                            <label class="form-label text-muted small">Mã khách hàng</label>
                            <input type="text" name="customerId" id="e_id" class="form-control bg-light border-0 fw-bold" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Họ và Tên</label>
                            <input type="text" name="fullName" id="e_name" class="form-control" required>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Số điện thoại mới</label>
                                <input type="text" name="phone" id="e_phone" class="form-control">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Email mới</label>
                                <input type="email" name="email" id="e_email" class="form-control">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="submit" class="btn btn-primary w-100 py-3 fw-bold rounded-pill shadow" style="background: #4338ca; border: none;">CẬP NHẬT NGAY</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function fillEdit(id, name, phone, email) { 
            document.getElementById('e_id').value = id; 
            document.getElementById('e_name').value = name; 
            document.getElementById('e_phone').value = phone; 
            document.getElementById('e_email').value = email; 
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