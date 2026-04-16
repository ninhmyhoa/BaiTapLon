<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Ca Làm</title>
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
        .emp-id-badge {
            background-color: #f1f5f9;
            color: #475569;
            padding: 6px 12px;
            border-radius: 10px;
            font-weight: 700;
            font-size: 0.85rem;
        }
        .time-box {
            display: flex;
            align-items: center;
            font-size: 0.9rem;
            font-weight: 500;
        }
        .status-active {
            background-color: #dcfce7;
            color: #166534;
            padding: 4px 10px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.75rem;
        }

        /* Action Buttons */
        .btn-action { 
            width: 36px;
            height: 36px; 
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
        <jsp:param name="menu" value="menu3" /> 
        <jsp:param name="active" value="workshift" /> 
    </jsp:include>

    <div class="main-content">
        
        <div class="top-navbar">
            <span class="me-3 mt-1 fw-bold">Xin chào</span>
            <a href="login.jsp" class="btn btn-outline-danger btn-sm px-3 rounded-pill"><i class="fas fa-sign-out-alt me-1"></i>Đăng xuất</a>
        </div>

        <div class="container pb-5">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <h3 class="fw-bold mb-1">Chấm công nhân viên</h3>
                    <p class="text-muted mb-0 small text-uppercase fw-600" style="letter-spacing: 1px;">Theo dõi thời gian vào/ra và hoạt động trong ca</p>
                </div>
                
                <c:choose>
                    <c:when test="${sessionScope.user.position == 'Manager' || sessionScope.user.position == 'Quản lý'}">
                        <button class="btn btn-primary btn-add" data-bs-toggle="modal" data-bs-target="#addModal">
                            <i class="fas fa-plus-circle me-2"></i> Thêm Ca Làm Mới
                        </button>
                    </c:when>
                    <c:otherwise>
                        <div>
                            <form action="workshift-manager" method="POST" class="d-inline">
                                <input type="hidden" name="action" value="clockIn">
                                <button type="submit" class="btn btn-success fw-bold rounded-pill px-4 shadow-sm me-2">
                                    <i class="fas fa-sign-in-alt me-2"></i>VÀO CA
                                </button>
                            </form>
                            <form action="workshift-manager" method="POST" class="d-inline">
                                <input type="hidden" name="action" value="clockOut">
                                <button type="submit" class="btn btn-warning fw-bold rounded-pill px-4 shadow-sm text-dark">
                                    <i class="fas fa-sign-out-alt me-2"></i>TAN CA
                                </button>
                            </form>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="row mb-3">
                <div class="col-md-5 col-sm-12">
                    <div class="input-group shadow-sm">
                        <span class="input-group-text bg-white border-end-0">
                            <i class="fas fa-search text-muted"></i>
                        </span>
                        <input type="text" id="searchInput" class="form-control border-start-0 ps-0" 
                               placeholder="Nhập mã nhân viên hoặc trạng thái..." 
                               onkeyup="filterTable()">
                    </div>
                </div>
            </div>

            <div class="card main-card">
                <div class="table-responsive">
                    <table class="table table-hover mb-0" id="shiftTable">
                        <thead>
                            <tr>
                                <th>Nhân Viên</th>
                                <th>Giờ Vào</th>
                                <th>Giờ Ra</th>
                                <th class="text-center">Trạng Thái</th>
                                <c:if test="${sessionScope.user.position == 'Manager' || sessionScope.user.position == 'Quản lý'}">
                                    <th class="text-end">Thao Tác</th>
                                </c:if>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${shiftList}" var="s">
                                <tr>
                                    <td><span class="emp-id-badge"><i class="fas fa-user-tie me-2 small opacity-50"></i>${s.employeeId}</span></td>
                                    <td>
                                        <div class="time-box text-success">
                                            <i class="fas fa-right-to-bracket me-2 opacity-50"></i>
                                            ${s.loginTime.replace('T', ' ')}
                                        </div>
                                    </td>
                                    <td>
                                        <div class="time-box ${empty s.logoutTime ? 'text-muted italic' : 'text-danger'}">
                                            <i class="fas fa-right-from-bracket me-2 opacity-50"></i>
                                            <c:choose>
                                                <c:when test="${empty s.logoutTime}">---</c:when>
                                                <c:otherwise>${s.logoutTime.replace('T', ' ')}</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${empty s.logoutTime}">
                                                <span class="status-active"><i class="fas fa-spinner fa-spin me-1"></i> ĐANG TRỰC</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-light text-muted border">Hoàn thành</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <c:if test="${sessionScope.user.position == 'Manager' || sessionScope.user.position == 'Quản lý'}">
                                        <td class="text-end text-nowrap">
                                            <button class="btn-action btn-edit-custom me-1" 
                                                    title="Sửa giờ ra" data-bs-toggle="modal" data-bs-target="#editModal" 
                                                    onclick="fillEdit('${s.employeeId}','${s.loginTime}','${s.logoutTime}')">
                                                <i class="fas fa-user-clock"></i>
                                            </button>
                                            <a href="workshift-manager?action=delete&empId=${s.employeeId}&time=${s.loginTime}" 
                                               class="btn-action btn-delete-custom" 
                                               onclick="return confirm('Xác nhận xóa bản ghi ca làm này?');">
                                                <i class="fas fa-trash-can"></i>
                                            </a>
                                        </td>
                                    </c:if>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            
        </div>
    </div>

    <div class="modal fade" id="addModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg">
                <form action="workshift-manager" method="POST">
                    <div class="modal-header border-0 p-4 pb-0">
                        <h5 class="fw-bold mb-0 text-primary"><i class="fas fa-plus-circle me-2"></i>Ghi Nhận Ca Làm Mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="mb-3">
                            <label class="form-label">Chọn nhân viên trực ca</label>
                            <select name="employeeId" class="form-select bg-light" required>             
                                <c:forEach items="${empList}" var="e">
                                    <option value="${e.employeeId}">ID: ${e.employeeId} - ${e.fullName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Thời gian bắt đầu</label>
                            <input type="datetime-local" name="loginTime" class="form-control shadow-sm" required>
                        </div>

                        <div class="mb-2">
                            <label class="form-label">Thời gian kết thúc</label>
                            <input type="datetime-local" name="logoutTime" class="form-control shadow-sm">
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="submit" class="btn btn-primary w-100 py-3 fw-bold rounded-pill shadow" style="background: #4338ca; border: none;">LƯU BẢN GHI</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg">
                <form action="workshift-manager" method="POST">
                    <div class="modal-header border-0 p-4 pb-0">
                        <h5 class="fw-bold mb-0 text-indigo-600"><i class="fas fa-sign-out-alt me-2"></i>Checkout Ca Làm</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="edit">
                        
                        <div class="row g-3 mb-3">
                            <div class="col-6">
                                <label class="form-label text-muted small">Mã Nhân Viên</label>
                                <input type="text" name="employeeId" id="e_emp" class="form-control bg-light border-0 fw-bold" readonly>
                            </div>
                            <div class="col-6">
                                <label class="form-label text-muted small">Giờ Vào</label>
                                <input type="text" id="e_in_display" class="form-control bg-light border-0 fw-bold" readonly>
                                <input type="hidden" name="loginTime" id="e_in">
                            </div>
                        </div>

                        <div class="mb-1">
                            <label class="form-label">Cập nhật giờ ra</label>
                            <input type="datetime-local" name="logoutTime" id="e_out" class="form-control shadow-sm" required>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="submit" class="btn btn-primary w-100 py-3 fw-bold rounded-pill shadow">XÁC NHẬN GIỜ RA</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
 
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function fillEdit(emp, inTime, outTime) { 
            document.getElementById('e_emp').value = emp;
            document.getElementById('e_in').value = inTime; 
            document.getElementById('e_in_display').value = inTime.replace('T', ' ');
            document.getElementById('e_out').value = outTime; 
        }

        // Bổ sung thêm hàm để thanh tìm kiếm hoạt động
        function filterTable() {
            var input = document.getElementById("searchInput");
            var filter = input.value.toLowerCase();
            var table = document.getElementById("shiftTable");
            var tr = table.getElementsByTagName("tr");

            for (var i = 1; i < tr.length; i++) {
                var rowText = tr[i].textContent.toLowerCase();
                if (rowText.indexOf(filter) > -1) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                }
            }
        }
    </script>
</body>
</html>