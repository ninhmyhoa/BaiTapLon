<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Đặt Bàn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; color: #1e293b; }
        .main-content { margin-left: 260px; padding: 20px 30px; }
        .top-navbar { display: flex; justify-content: flex-end; padding: 10px 0 20px; border-bottom: 1px solid #e5e7eb; margin-bottom: 25px; }
        .navbar { background: #ffffff; border-bottom: 1px solid #e2e8f0; padding: 1rem 0; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .navbar-brand { font-weight: 800; color: #4338ca !important; }
        .main-card { border: none; border-radius: 20px; box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.05); background: white; overflow: hidden; }
        .table thead { background-color: #f8fafc; }
        .table thead th { border: none; color: #64748b; font-weight: 600; text-transform: uppercase; font-size: 0.75rem; padding: 1.25rem 1.5rem; letter-spacing: 0.5px; }
        .table tbody td { vertical-align: middle; padding: 1.25rem 1.5rem; border-bottom: 1px solid #f1f5f9; }
        .res-id-badge { background-color: #eef2ff; color: #4338ca; padding: 6px 12px; border-radius: 10px; font-weight: 800; font-size: 0.85rem; }
        .booking-tag { background-color: #fef3c7; color: #d97706; padding: 4px 10px; border-radius: 8px; font-weight: 700; font-size: 0.75rem; border: 1px solid #fde68a; }
        .guest-count { background-color: #f1f5f9; color: #4338ca; padding: 4px 12px; border-radius: 8px; font-weight: 800; }
        
        .btn-action { width: 36px; height: 36px; display: inline-flex; align-items: center; justify-content: center; border-radius: 10px; transition: 0.2s; border: none; text-decoration: none; }
        
        .btn-check-in { background: #10b981; color: white; width: auto; padding: 0 15px; font-weight: 800; font-size: 0.7rem; letter-spacing: 0.5px; }
        .btn-check-in:hover { background: #059669; color: white; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2); }

        .btn-delete-custom { background: #fee2e2; color: #dc2626; }
        .btn-delete-custom:hover { background: #dc2626; color: white; }
        
        .btn-add { background: #4338ca; border: none; border-radius: 14px; font-weight: 700; padding: 12px 28px; box-shadow: 0 10px 15px -3px rgba(67, 56, 202, 0.3); transition: 0.3s; color: white;}
        .btn-add:hover { background: #3730a3; transform: translateY(-2px); color: white; }
        
        .modal-content { border: none; border-radius: 28px; }
        .form-label { font-weight: 700; font-size: 0.8rem; color: #64748b; text-transform: uppercase; margin-bottom: 0.5rem; }
        .form-control, .form-select { border-radius: 12px; padding: 12px 15px; border: 1px solid #e2e8f0; background-color: #f8fafc; }
    </style>
</head>
<body>

<jsp:include page="sidebar.jsp">
        <jsp:param name="menu" value="menu2" /> <jsp:param name="active" value="reservation" /> </jsp:include>

    <div class="main-content">
        
        <div class="top-navbar">
            <span class="me-3 mt-1 fw-bold">Xin chào</span>
            <a href="login.jsp" class="btn btn-outline-danger btn-sm px-3 rounded-pill"><i class="fas fa-sign-out-alt me-1"></i>Đăng xuất</a>
        </div>


    <div class="container pb-5">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div><h3 class="fw-bold mb-1 text-dark">Danh sách đặt chỗ</h3></div>
            <button class="btn btn-add" data-bs-toggle="modal" data-bs-target="#addModal">
                <i class="fas fa-plus-circle me-2"></i> Tạo Đơn Mới
            </button>
        </div>
        <div class="row mb-3">
            <div class="col-md-5 col-sm-12">
                <div class="input-group shadow-sm">
                    <span class="input-group-text bg-white border-end-0">
                        <i class="fas fa-search text-muted"></i>
                    </span>
                    <input type="text" id="searchInput" class="form-control border-start-0 ps-0" 
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
                            <th>Mã Đặt</th>
                            <th>Trạng Thái</th>
                            <th>Khách Hàng</th>
                            <th>Giờ Khách Đến</th>
                            <th class="text-center">Số Khách</th>
                            <th>Người Lập</th>
                            <th class="text-end">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${resList}" var="r">
                            <c:if test="${not r.createdTime.equals(r.arrivalTime)}">
                                <tr>
                                    <td><span class="res-id-badge">#${r.reservationId}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${r.status eq 'Da Phuc Vu'}">
                                                <span class="badge bg-success px-3 py-2"><i class="fas fa-check-circle me-1"></i> ĐÃ PHỤC VỤ</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="booking-tag"><i class="fas fa-clock me-1"></i> ĐANG CHỜ</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="fw-bold text-dark">
                                            <i class="fas fa-user text-muted me-2 small"></i>
                                            <c:out value="${empty r.customerId ? 'Khách vãng lai' : r.customerId}" />
                                        </div>
                                    </td>
                                    <td>
                                        <div class="fw-bold text-primary">
                                            <i class="far fa-calendar-check me-2"></i>${r.arrivalTime.replace('T', ' ')}
                                        </div>
                                    </td>
                                    <td class="text-center"><span class="guest-count">${r.guestCount}</span></td>
                                    <td><small class="fw-bold text-muted">${r.employeeId}</small></td>
                                    <td class="text-end text-nowrap">
                                        <c:if test="${r.status ne 'Da Phuc Vu'}">
                                            <a href="reservation-manager?action=checkin&id=${r.reservationId}" 
                                                class="btn btn-sm btn-success fw-bold">
                                                <i class="fas fa-check me-1"></i> Khách đến
                                             </a>
<button type="button" class="btn btn-sm btn-outline-primary fw-bold ms-1" data-bs-toggle="modal" data-bs-target="#depositModal" onclick="openDepositModal('${r.reservationId}')">Thu Cọc</button>                                        </c:if>

                                        <a href="reservation-manager?action=delete&id=${r.reservationId}" class="btn-action btn-delete-custom ms-2" onclick="return confirm('Xóa đơn?');">
                                            <i class="fas fa-trash-can"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="addModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg">
                <form id="addForm"> 
                    <div class="modal-header border-0 p-4 pb-0">
                        <h5 class="fw-bold text-primary">Tiếp Nhận Khách</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="alert alert-info border-0 rounded-4 py-2 small mb-3" style="background-color: #e0e7ff; color: #4338ca;">
                            <i class="fas fa-magic me-2"></i> Mã đơn đặt bàn sẽ được hệ thống cấp tự động.
                        </div>

                        <div class="row g-3">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Nhân viên trực</label>
                                <select name="employeeId" class="form-select bg-light" style="pointer-events: none;" readonly>
                                    <option value="${sessionScope.user.employeeId}">${sessionScope.user.fullName}</option>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Khách hàng</label>
                                <select name="customerId" class="form-select">
                                    <option value="">-- Khách vãng lai --</option>
                                    <c:forEach items="${custList}" var="c"><option value="${c.customerId}">${c.fullName}</option></c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="row g-3">
                            <div class="col-md-6 mb-3"><label class="form-label">Giờ tạo đơn</label><input type="datetime-local" id="add_createdTime" name="createdTime" class="form-control" required></div>
                            <div class="col-md-6 mb-3"><label class="form-label">Giờ khách đến</label><input type="datetime-local" id="add_arrivalTime" name="arrivalTime" class="form-control" required></div>
                        </div>
                        <div class="mb-3"><label class="form-label">Số lượng khách</label><input type="number" name="guestCount" class="form-control" required min="1"></div>
                        
                        <div class="border-top pt-3">
                            <label class="form-label text-primary">Chọn Bàn Trống</label>
                            <div class="row g-2" style="max-height: 150px; overflow-y: auto;">
                                <c:forEach items="${tableList}" var="t">
                                    <div class="col-6">
                                        <div class="form-check border rounded p-2 small shadow-sm">
                                            <input class="form-check-input ms-0" type="checkbox" name="selectedTables" value="${t.roomId}|${t.tableNumber}" id="t${t.roomId}${t.tableNumber}">
                                            <label class="form-check-label fw-bold ms-2" for="t${t.roomId}${t.tableNumber}">
                                                ${t.roomId} - Bàn ${t.tableNumber}
                                            </label>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" id="btnSubmitAdd" onclick="handleLogic()" class="btn btn-primary w-100 py-3 fw-bold rounded-pill" style="background: #4338ca; border: none;">XÁC NHẬN</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
<div class="modal fade" id="depositModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg">
                <div class="modal-header border-0 p-4 pb-0">
                    <h5 class="fw-bold mb-0 text-success"><i class="fas fa-hand-holding-dollar me-2"></i>Quản Lý Thu Cọc</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <h6 class="fw-bold text-primary">Mã Đặt Bàn: <span id="modal_res_id_display" class="fs-5"></span></h6>
                    </div>

                    <div class="mb-4">
                        <label class="form-label text-muted small">Lịch Sử Giao Dịch</label>
                        <div class="table-responsive border rounded-3 overflow-hidden">
                            <table class="table table-sm table-hover mb-0 text-center">
                                <thead class="table-light">
                                    <tr>
                                        <th>Lần</th>
                                        <th>Số tiền (VNĐ)</th>
                                        <th>Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody id="deposit_history_table">
                                    </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="border-top pt-3">
                        <label class="form-label text-success"><i class="fas fa-plus-circle me-1"></i> Ghi Nhận Cọc Mới</label>
                        <form id="addDepositAjaxForm">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="reservationId" id="dep_res_id_input">
                            
                            <div class="row g-2 mb-2">
                                <div class="col-4">
                                    <input type="number" name="depositTurn" id="dep_turn_input" class="form-control bg-light text-center fw-bold" readonly title="Lần cọc tiếp theo">
                                </div>
                                <div class="col-8">
                                    <input type="text" name="status" class="form-control bg-light" value="Paid" readonly title="Trạng thái mặc định">
                                </div>
                            </div>
                            <div class="mb-3">
                                <input type="number" step="0.01" name="amount" class="form-control shadow-sm" placeholder="Nhập số tiền..." required>
                            </div>
                            <button type="button" id="btnSubmitDepositAjax" onclick="submitDepositAjax()" class="btn btn-success w-100 py-3 fw-bold rounded-pill shadow">XÁC NHẬN THU</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Lấy toàn bộ dữ liệu cọc từ Servlet truyền qua và biến thành mảng JS
        const allDeposits = [
            <c:forEach items="${depList}" var="d">
                { resId: '${d.reservationId}', turn: ${d.depositTurn}, amount: ${d.amount}, status: '${d.status}' },
            </c:forEach>
        ];

        // Hàm mở Pop-up và lọc lịch sử
        function openDepositModal(resId) {
            document.getElementById('modal_res_id_display').innerText = '#' + resId;
            document.getElementById('dep_res_id_input').value = resId;

            // Tìm các lần cọc của đúng cái mã bàn này
            const history = allDeposits.filter(d => d.resId === resId);
            
            // Đổ dữ liệu vào bảng
            const tbody = document.getElementById('deposit_history_table');
            tbody.innerHTML = '';
            
            if (history.length === 0) {
                tbody.innerHTML = '<tr><td colspan="3" class="text-muted small py-3">Chưa có giao dịch cọc nào.</td></tr>';
            } else {
                history.forEach(d => {
                    tbody.innerHTML += `
                        <tr>
                            <td class="fw-bold">Lần ${d.turn}</td>
                            <td class="text-success fw-bold">` + d.amount.toLocaleString() + `</td>
                            <td><span class="badge bg-success">${d.status}</span></td>
                        </tr>
                    `;
                });
            }

            // Tự động tính số lần cọc tiếp theo (vd đã cọc 2 lần thì ô tiếp theo hiện số 3)
            const nextTurn = history.length > 0 ? Math.max(...history.map(d => d.turn)) + 1 : 1;
            document.getElementById('dep_turn_input').value = nextTurn;
        }

        // Hàm gửi dữ liệu đi mà không bị chuyển trang
        function submitDepositAjax() {
            const form = document.getElementById('addDepositAjaxForm');
            if(!form.checkValidity()) { form.reportValidity(); return; }

            const btn = document.getElementById('btnSubmitDepositAjax');
            const originalText = btn.innerHTML;
            btn.innerHTML = "<i class='fas fa-spinner fa-spin'></i> Đang xử lý...";
            btn.disabled = true;

            const params = new URLSearchParams(new FormData(form));

            // Bắn dữ liệu sang DepositServlet
            fetch("deposit-manager", {
                method: "POST",
                body: params,
                headers: { "Content-Type": "application/x-www-form-urlencoded" }
            })
            .then(res => {
                if(res.ok) {
                    // Thành công thì chỉ load lại trang hiện tại (reservation-manager)
                    window.location.reload(); 
                } else {
                    alert("Có lỗi xảy ra khi lưu!");
                    btn.innerHTML = originalText; btn.disabled = false;
                }
            })
            .catch(err => {
                alert("Lỗi kết nối mạng!");
                btn.innerHTML = originalText; btn.disabled = false;
            });
        }
    </script>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function handleLogic() {
            const form = document.getElementById('addForm');
            const createTime = document.getElementById('add_createdTime').value;
            const arriveTime = document.getElementById('add_arrivalTime').value;
            const btnSubmit = document.getElementById('btnSubmitAdd');

            if(!form.checkValidity()) { form.reportValidity(); return; }

            btnSubmit.innerHTML = "Đang lưu...";
            btnSubmit.disabled = true;

            const params = new URLSearchParams(new FormData(form));

            fetch("reservation-manager", {
                method: "POST",
                body: params,
                headers: { "Content-Type": "application/x-www-form-urlencoded" }
            })
            .then(res => {
                if (res.ok) {
                    if (createTime === arriveTime) {
                        window.location.href = "table-manager";
                    } else {
                        window.location.reload();
                    }
                } else {
                    alert("Lỗi lưu đơn! Vui lòng thử lại.");
                    btnSubmit.innerHTML = "XÁC NHẬN";
                    btnSubmit.disabled = false;
                }
            })
            .catch(err => { alert("Lỗi kết nối!"); btnSubmit.disabled = false; });
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