<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Lô Nhập</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        body { 
            font-family: 'Inter', sans-serif; 
            background-color: #f1f5f9; 
            margin: 0; 
            color: #334155; 
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
        .navbar-brand { font-weight: 700; color: #0d9488 !important; } /* Teal 600 */

        /* --- MAIN CARD & TABLE --- */
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
            padding: 1.25rem 1rem;
            letter-spacing: 0.5px;
        }
        .table tbody td { 
            vertical-align: middle; 
            padding: 1.25rem 1rem;
            border-bottom: 1px solid #f1f5f9;
            font-size: 0.9rem;
        }

        /* Badges & Icons */
        .batch-id { font-weight: 700; color: #0d9488; background: #f0fdfa; padding: 6px 10px; border-radius: 8px; }
        .ing-name { font-weight: 700; color: #1e293b; }
        .qty-badge { background: #f1f5f9; color: #475569; font-weight: 800; padding: 6px 14px; border-radius: 10px; }
        
        .price-text { font-weight: 800; color: #059669; font-size: 1.05rem;}
        .date-info { font-size: 0.85rem; color: #64748b; font-weight: 500; }

        /* Buttons */
        .btn-add { 
            background: #0d9488;
            border: none;
            border-radius: 14px; 
            font-weight: 700; 
            padding: 12px 28px;
            box-shadow: 0 10px 15px -3px rgba(13, 148, 136, 0.3);
            transition: 0.3s;
            color: white;
        }
        .btn-add:hover { background: #0f766e; transform: translateY(-2px); color: white; }

        .btn-logout-soft { background-color: #fee2e2; color: #dc2626; font-weight: 600; font-size: 0.85rem; padding: 8px 16px; border-radius: 8px; border: none; text-decoration: none; transition: 0.2s; }
        .btn-logout-soft:hover { background-color: #fca5a5; color: #991b1b; }

        /* Modal styling */
        .modal-content { border: none; border-radius: 28px; }
        .form-label { font-weight: 700; font-size: 0.8rem; color: #64748b; text-transform: uppercase; margin-bottom: 0.5rem;}
        .form-control, .form-select { border-radius: 12px; padding: 12px 15px; border: 1px solid #e2e8f0; background-color: #f8fafc; transition: 0.2s;}
        .form-control:focus { background-color: white; border-color: #0d9488; box-shadow: 0 0 0 4px rgba(13, 148, 136, 0.1); }
    </style>
</head>
<body>

    <jsp:include page="sidebar.jsp">
        <jsp:param name="menu" value="menu4" /> <jsp:param name="active" value="batch" /> </jsp:include>

    <div class="main-content">
        
        <div class="top-navbar">
            <span class="me-3 mt-1 fw-bold">Xin chào</span>
            <a href="login.jsp" class="btn btn-outline-danger btn-sm px-3 rounded-pill"><i class="fas fa-sign-out-alt me-1"></i>Đăng xuất</a>
        </div>

    <div class="container pb-5">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <h3 class="fw-bold mb-1">Danh sách lô hàng nhập</h3>
                <p class="text-muted mb-0 small text-uppercase fw-600" style="letter-spacing: 0.5px;">Theo dõi chi phí nhập và hạn sử dụng nguyên liệu</p>
            </div>
            <button class="btn btn-add" data-bs-toggle="modal" data-bs-target="#addModal">
                <i class="fas fa-plus-circle me-2"></i> Tạo Lô Nhập Mới
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
                            <th>Mã Lô</th>
                            <th>Nguyên Liệu</th>
                            <th>Ngày Nhập</th>
                            <th>Hạn Sử Dụng</th>
                            <th class="text-end">Giá Nhập</th>
                            <th class="text-center">Số Lượng</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${batchList}" var="b">
                            <tr>
                                <td><span class="batch-id">#${b.batchId}</span></td>
                                <td>
                                    <div class="ing-name">${b.ingredientName}</div>
                                    <div class="small text-muted mt-1"><i class="fas fa-user-tie me-1"></i>Bởi: ${b.employeeName}</div>
                                </td>
                                <td>
                                    <div class="date-info"><i class="far fa-calendar-check me-1"></i> ${b.importDate.replace('T', ' ')}</div>
                                </td>
                                <td>
                                    <div class="date-info fw-bold text-danger">
                                        <i class="fas fa-hourglass-half me-1"></i> ${b.expirationDate.replace('T', ' ')}
                                    </div>
                                </td>
                                <td class="text-end price-text">
                                    <fmt:formatNumber value="${b.batchPrice}" type="number"/> <small>đ</small>
                                </td>
                                <td class="text-center">
                                    <span class="qty-badge">${b.stockQuantity}</span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="addModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content shadow-lg">
                <form action="batch-manager" method="POST">
                    <div class="modal-header border-0 p-4 pb-0">
                        <h5 class="fw-bold" style="color: #0d9488;"><i class="fas fa-cart-plus me-2"></i>Nhập Lô Hàng Mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="alert alert-info border-0 rounded-4 py-2 small mb-4 fw-bold" style="background-color: #f0fdfa; color: #0f766e;">
                            <i class="fas fa-magic me-2"></i> Mã lô hàng sẽ được hệ thống cấp tự động.
                        </div>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Nhân viên thực hiện</label>
                                <select name="employeeId" class="form-select bg-light" style="pointer-events: none;" readonly>
                                    <option value="${sessionScope.user.employeeId}">${sessionScope.user.fullName}</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Nguyên liệu nhập</label>
                                <select name="ingredientId" class="form-select">
                                    <c:forEach items="${ingList}" var="i">
                                        <option value="${i.ingredientId}">${i.ingredientName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Ngày giờ nhập</label>
                                <input type="datetime-local" name="importDate" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Hạn sử dụng</label>
                                <input type="datetime-local" name="expirationDate" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Tổng giá nhập</label>
                                <div class="input-group">
                                    <input type="number" step="0.01" name="batchPrice" class="form-control border-end-0" placeholder="0.00" required>
                                    <span class="input-group-text bg-white fw-bold border-start-0 text-muted">VNĐ</span>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Số lượng nhập kho</label>
                                <input type="number" step="0.01" name="stockQuantity" class="form-control" placeholder="VD: 100" required>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="submit" class="btn btn-add w-100 py-3 text-white shadow">XÁC NHẬN NHẬP KHO</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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