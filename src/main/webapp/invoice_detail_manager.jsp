<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Gọi Món</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f1f5f9; color: #1e293b; }
         .main-content { margin-left: 260px; padding: 20px 30px; }
        .top-navbar { display: flex; justify-content: flex-end; padding: 10px 0 20px; border-bottom: 1px solid #e5e7eb; margin-bottom: 25px; }
        .navbar { background: #ffffff; border-bottom: 2px solid #e2e8f0; padding: 1rem 0; }
        .navbar-brand { font-weight: 800; color: #4f46e5 !important; }
        .main-card { border: none; border-radius: 20px; box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.05); background: white; overflow: hidden; }
        .table thead { background-color: #f8fafc; }
        .table thead th { border: none; color: #64748b; font-weight: 600; text-transform: uppercase; font-size: 0.7rem; padding: 1.25rem 1rem; letter-spacing: 0.5px; }
        .table tbody td { vertical-align: middle; padding: 1rem; border-bottom: 1px solid #f1f5f9; font-size: 0.9rem; }
        
        .status-badge { padding: 5px 12px; border-radius: 20px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; }
        .status-cho-nau { background-color: #fef3c7; color: #d97706; }
        .status-dang-nau { background-color: #e0f2fe; color: #0284c7; }
        .status-da-xong { background-color: #dcfce7; color: #16a34a; }
        .status-huy { background-color: #fee2e2; color: #dc2626; }

        .inv-tag { font-weight: 700; color: #4f46e5; }
        .table-tag { background: #f1f5f9; padding: 4px 8px; border-radius: 6px; font-weight: 600; font-size: 0.8rem; }
        .dish-name { font-weight: 700; color: #1e293b; }

        .btn-add { background: #4f46e5; border: none; border-radius: 12px; font-weight: 600; padding: 10px 24px; box-shadow: 0 10px 15px -3px rgba(79, 70, 229, 0.3); transition: 0.3s; }
        .btn-add:hover { background: #4338ca; transform: translateY(-2px); color: white; }

        .btn-action { width: 32px; height: 32px; display: inline-flex; align-items: center; justify-content: center; border-radius: 8px; transition: 0.2s; border: none; }
        .btn-edit-custom { background: #eef2ff; color: #4f46e5; }
        .btn-edit-custom:hover { background: #4f46e5; color: white; }
        .btn-delete-custom { background: #fef2f2; color: #dc2626; }
        .btn-delete-custom:hover { background: #dc2626; color: white; }
        
        .modal-content { border: none; border-radius: 24px; }
        .alert-mini { font-size: 0.75rem; border-radius: 10px; padding: 10px; }
        .form-label { font-weight: 700; font-size: 0.75rem; color: #64748b; text-transform: uppercase; }
        .form-control, .form-select { border-radius: 12px; padding: 10px 15px; border: 1px solid #e2e8f0; background-color: #f8fafc; transition: 0.3s; }
        .form-control:focus, .form-select:focus { background-color: white; border-color: #4f46e5; box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1); }
        
        .locked-select { background-color: #e2e8f0; pointer-events: none; opacity: 0.8; }
        .highlight-select { background-color: #fef08a !important; border-color: #eab308 !important; color: #854d0e !important; }
    </style>
</head>
<body>

    <jsp:include page="sidebar.jsp">
        <jsp:param name="menu" value="menu2" /> <jsp:param name="active" value="pos" /> </jsp:include>

    <div class="main-content">
        
        <div class="top-navbar">
            <span class="me-3 mt-1 fw-bold">Xin chào</span>
            <a href="login.jsp" class="btn btn-outline-danger btn-sm px-3 rounded-pill"><i class="fas fa-sign-out-alt me-1"></i>Đăng xuất</a>
        </div>

    <div class="container-fluid px-4 pb-5">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <h3 class="fw-bold mb-1">Lệnh xuống bếp và Phục vụ</h3>
                <p class="text-muted mb-0 small">Theo dõi trạng thái chế biến từng món ăn theo bàn</p>
            </div>
            
            <c:if test="${sessionScope.user.position.toUpperCase() ne 'CHEF'}">
                <button class="btn btn-success btn-add" data-bs-toggle="modal" data-bs-target="#addModal">
                    <i class="fas fa-plus me-2"></i> Gọi Món Mới
                </button>
            </c:if>
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
                            <th>Hóa Đơn</th>
                            <th>Món Ăn</th> <th>Vị Trí</th>
                            <th class="text-center">SL</th>
                            <th>Ghi Chú</th>
                            <th>Người Gọi</th> <th class="text-center">Trạng Thái Bếp</th>
                            <th class="text-end">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${detailList}" var="d">
                            <tr>
                                <td><span class="inv-tag">#${d.invoiceId}</span></td>
                                
                                <td><span class="dish-name fw-bold text-primary"><i class="fas fa-utensils me-2 opacity-50"></i>${d.dishName}</span></td>
                                
                                <td>
                                    <span class="table-tag">
                                        <i class="fas fa-chair me-1 small opacity-50"></i> ${d.roomId} - Bàn ${d.tableNumber}
                                    </span>
                                </td>
                                <td class="text-center fw-bold fs-5 text-primary">${d.quantity}</td>
                                <td class="text-muted small italic">${d.note == null || d.note == '' ? '---' : d.note}</td>
                                
                                <td><small class="fw-bold"><i class="far fa-user me-1 text-muted"></i> ${d.employeeName}</small></td>
                                
                                <td class="text-center">
                                    <span class="status-badge 
                                        ${d.kitchenStatus == 'CHO_NAU' ? 'status-cho-nau' : 
                                          (d.kitchenStatus == 'DANG_NAU' ? 'status-dang-nau' : 
                                          (d.kitchenStatus == 'DA_XONG' ? 'status-da-xong' : 'status-huy'))}">
                                        <i class="fas 
                                            ${d.kitchenStatus == 'CHO_NAU' ? 'fa-clock' : 
                                              (d.kitchenStatus == 'DANG_NAU' ? 'fa-fire-burner' : 
                                              (d.kitchenStatus == 'DA_XONG' ? 'fa-check-circle' : 'fa-ban'))} me-1"></i>
                                        ${d.kitchenStatus}
                                    </span>
                                </td>
                                <td class="text-end text-nowrap">
                                    <button class="btn-action btn-edit-custom me-1" 
                                            data-bs-toggle="modal" 
                                            data-bs-target="#editModal" 
                                            onclick="fillEdit('${d.invoiceId}','${d.employeeId}','${d.dishId}','${d.roomId}','${d.tableNumber}','${d.quantity}','${d.note}','${d.kitchenStatus}')">
                                        <i class="fas fa-pen"></i>
                                    </button>
                                    
                                    <c:if test="${sessionScope.user.position.toUpperCase() eq 'MANAGER' || sessionScope.user.employeeId eq d.employeeId}">
                                        <a href="invoice-detail-manager?action=delete&invId=${d.invoiceId}&dishId=${d.dishId}&roomId=${d.roomId}&tableNum=${d.tableNumber}" 
                                           class="btn-action btn-delete-custom me-2" 
                                           onclick="return confirm('Xác nhận xóa món này khỏi hóa đơn?');">
                                            <i class="fas fa-trash-can"></i>
                                        </a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    <div class="modal fade" id="addModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg">
                <form id="addForm" action="invoice-detail-manager" method="POST">
                    <div class="modal-header border-0 p-4 pb-0">
                        <h5 class="fw-bold"><i class="fas fa-cart-plus text-success me-2"></i>Ghi Nhận Gọi Món</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Chọn Hóa Đơn</label>
                                <select name="invoiceId" id="add_inv_select" class="form-select shadow-sm" onchange="updateLocationByInvoice()">
                                    <c:forEach items="${invList}" var="i">
                                        <option value="${i.invoiceId}">HĐ #${i.invoiceId}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Nhân viên Order</label>
                                <select name="employeeId" class="form-select bg-light" style="pointer-events: none;" readonly>             
                                    <option value="${sessionScope.user.employeeId}" selected>
                                        ${sessionScope.user.fullName}
                                    </option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label class="form-label">Chọn Món Ăn</label>
                                        <select name="dishId" id="dish_select" class="form-select shadow-sm" onchange="updateMaxQuantity()">
                                            <c:forEach items="${dishList}" var="di">
                                                <c:set var="maxP" value="${maxPortionsMap[di.dishId]}" />

                                                <c:choose>
                                                    <c:when test="${maxP > 0}">
                                                        <option value="${di.dishId}" data-max="${maxP}">
                                                            ${di.dishName} (Còn tối đa: ${maxP} phần)
                                                        </option>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <option value="${di.dishId}" disabled class="text-danger fw-bold bg-light">
                                                            ${di.dishName} - HẾT NGUYÊN LIỆU
                                                        </option>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </select>
                            </div>
                            
                            <div class="col-12">
                                <p class="mb-2 fw-bold small text-secondary text-uppercase">Vị Trí Phục Vụ</p>
                                <div class="row g-2">
                                    <div class="col-6">
                                        <select name="roomId" id="add_room_select" class="form-select shadow-sm" onchange="loadTablesForAdd()">
                                        </select>
                                    </div>
                                    <div class="col-6">
                                        <select name="tableNumber" id="add_table_select" class="form-select shadow-sm">
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label">Số lượng</label>
                                <input type="number" name="quantity" class="form-control" value="1" min="1" required>
                            </div>
                            
                            <div class="col-md-8">
                                <label class="form-label">Trạng thái Bếp</label>
                                <select name="kitchenStatus" class="form-select ${sessionScope.user.position.toUpperCase() eq 'WAITER' ? 'locked-select' : ''}">
                                    <option value="CHO_NAU" selected>Chờ nấu</option>
                                    <c:if test="${sessionScope.user.position.toUpperCase() ne 'WAITER'}">
                                        <option value="DANG_NAU">Đang nấu</option>
                                        <option value="DA_XONG">Đã xong</option>
                                        <option value="HUY">Hủy</option>
                                    </c:if>
                                </select>
                                <c:if test="${sessionScope.user.position.toUpperCase() eq 'WAITER'}">
                                    <small class="text-danger" style="font-size: 0.65rem;">*Bạn chỉ có quyền Order món.</small>
                                </c:if>
                            </div>
                            
                            <div class="col-12">
                                <label class="form-label">Ghi chú</label>
                                <input type="text" name="note" class="form-control" placeholder="Ví dụ: Ít cay, Không hành...">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" onclick="handleAjaxSubmit('addForm', 'add')" class="btn btn-success w-100 py-3 fw-bold shadow">XÁC NHẬN GỌI MÓN</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg">
                <form id="editForm" action="invoice-detail-manager" method="POST">
                    <div class="modal-header border-0 p-4 pb-0">
                        <h5 class="fw-bold"><i class="fas fa-edit text-primary me-2"></i>Cập Nhật Order</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="edit">
                        
                        <div class="alert alert-warning alert-mini mb-3 border-0 shadow-sm">
                            <i class="fas fa-info-circle me-1"></i> Thông tin HĐ, Món và Vị trí là cố định.
                        </div>

                        <div class="row g-3">
                            <div class="col-6">
                                <label class="form-label text-muted small">Hóa Đơn</label>
                                <input type="number" name="invoiceId" id="e_inv" class="form-control bg-light" readonly>
                            </div>
                            <div class="col-6">
                                <label class="form-label text-muted small">Món Ăn</label>
                                <input type="text" name="dishId" id="e_dish" class="form-control bg-light" readonly>
                            </div>
                            <div class="col-6">
                                <label class="form-label text-muted small">Phòng</label>
                                <input type="text" name="roomId" id="e_room" class="form-control bg-light" readonly>
                            </div>
                            <div class="col-6">
                                <label class="form-label text-muted small">Số Bàn</label>
                                <input type="number" name="tableNumber" id="e_table" class="form-control bg-light" readonly>
                            </div>
                            
                            <div class="col-12">
                                <label class="form-label">Nhân viên phục vụ</label>
                                <select name="employeeId" class="form-select bg-light" style="pointer-events: none;" readonly>             
                                    <option value="${sessionScope.user.employeeId}" selected>
                                        ${sessionScope.user.fullName}
                                    </option>
                                </select>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label">Số lượng</label>
                                <input type="number" name="quantity" id="order_qty" class="form-control" value="1" min="1" required>
                            </div>
                            
                            <div class="col-md-8">
                                <label class="form-label">Trạng thái Bếp</label>
                                <select name="kitchenStatus" id="e_status" class="form-select ${sessionScope.user.position.toUpperCase() eq 'WAITER' ? 'locked-select' : ''}">
                                    <option value="CHO_NAU">Chờ nấu</option>
                                    <c:if test="${sessionScope.user.position.toUpperCase() ne 'WAITER'}">
                                        <option value="DANG_NAU">Đang nấu</option>
                                        <option value="DA_XONG">Đã xong</option>
                                        <option value="HUY">Hủy</option>
                                    </c:if>
                                </select>
                                <c:if test="${sessionScope.user.position.toUpperCase() eq 'WAITER'}">
                                    <small class="text-danger" style="font-size: 0.65rem;">*Bạn không thể thay đổi trạng thái bếp.</small>
                                </c:if>
                            </div>
                            
                            <div class="col-12">
                                <label class="form-label">Cập nhật ghi chú</label>
                                <input type="text" name="note" id="e_note" class="form-control">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" onclick="handleAjaxSubmit('editForm', 'edit')" class="btn btn-primary w-100 py-3 fw-bold shadow">CẬP NHẬT THAY ĐỔI</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        const roomTableData = {};
        let firstRoom = null;
        const invoiceLocationMap = {};
    </script>

    <c:forEach items="${tableList}" var="t">
        <script>
            (function() {
                var rId = "${t.roomId}".trim();
                var tNum = "${t.tableNumber}".trim();
                if (!roomTableData[rId]) {
                    roomTableData[rId] = [];
                    if (!firstRoom) firstRoom = rId;
                }
                roomTableData[rId].push(tNum);
            })();
        </script>
    </c:forEach>

    <c:forEach items="${detailList}" var="d">
        <script>
            (function() {
                var dInv = "${d.invoiceId}".trim();
                var dRoom = "${d.roomId}".trim();
                var dTable = "${d.tableNumber}".trim();
                if (!invoiceLocationMap[dInv]) {
                    invoiceLocationMap[dInv] = { room: dRoom, table: dTable };
                }
            })();
        </script>
    </c:forEach>

    <script>
        function initRoomDropdown() {
            const roomSelect = document.getElementById('add_room_select');
            if (!roomSelect) return;
            let roomOptions = '';
            for (const room in roomTableData) {
                roomOptions += '<option value="' + room + '">' + room + '</option>';
            }
            roomSelect.innerHTML = roomOptions;
        }

        function loadTablesForAdd() {
            const roomSelect = document.getElementById('add_room_select');
            const tableSelect = document.getElementById('add_table_select');
            if (!roomSelect || !tableSelect) return;

            let selectedRoom = roomSelect.value;
            // Nếu bị rỗng, ép về phòng mặc định đầu tiên
            if (!selectedRoom && firstRoom) {
                selectedRoom = firstRoom;
                roomSelect.value = firstRoom;
            }

            const tables = roomTableData[selectedRoom] || [];
            let tableOptions = '';
            for(let i = 0; i < tables.length; i++) {
                tableOptions += '<option value="' + tables[i] + '">Bàn ' + tables[i] + '</option>';
            }
            tableSelect.innerHTML = tableOptions;
        }

        function updateLocationByInvoice() {
            const invSelectElement = document.getElementById('add_inv_select');
            const roomSelect = document.getElementById('add_room_select');
            const tableSelect = document.getElementById('add_table_select');

            if (!invSelectElement || !roomSelect || !tableSelect) return;
            const selectedInv = invSelectElement.value.trim();

            // Trường hợp A: Hóa đơn cũ đã có món -> Lấy chính xác vị trí từ Map
            if (invoiceLocationMap[selectedInv]) {
                roomSelect.value = invoiceLocationMap[selectedInv].room;
                loadTablesForAdd();
                tableSelect.value = invoiceLocationMap[selectedInv].table;
                triggerHighlight(roomSelect, tableSelect);
                return;
            }

            // Trường hợp B: Hóa đơn mới tinh -> Ưu tiên lấy vị trí từ URL truyền sang
            const urlParams = new URLSearchParams(window.location.search);
            const urlRoom = urlParams.get('roomId');
            const urlTable = urlParams.get('tableNumber');

            if (urlRoom && urlTable) {
                if (roomTableData[urlRoom]) {
                    roomSelect.value = urlRoom;
                    loadTablesForAdd();
                    tableSelect.value = urlTable;
                    triggerHighlight(roomSelect, tableSelect);
                    return;
                }
            }

            // Trường hợp C: Mở chay không có dữ liệu -> Hiện phòng đầu tiên
            if (firstRoom) {
                roomSelect.value = firstRoom;
                loadTablesForAdd();
            }
        }

        function triggerHighlight(rSelect, tSelect) {
            rSelect.classList.add('highlight-select');
            tSelect.classList.add('highlight-select');
            setTimeout(() => {
                rSelect.classList.remove('highlight-select');
                tSelect.classList.remove('highlight-select');
            }, 800);
        }

        document.addEventListener("DOMContentLoaded", function() {
            initRoomDropdown();
            
            const urlParams = new URLSearchParams(window.location.search);
            const urlInvId = urlParams.get('invoiceId');
            const invSelect = document.getElementById('add_inv_select');

            if (urlInvId && invSelect) {
                invSelect.value = urlInvId.trim();
            }
            // Khởi chạy ngay lần đầu
            updateLocationByInvoice();
        });

        function fillEdit(inv, emp, dish, room, table, qty, note, status) { 
            document.getElementById('e_inv').value = inv.trim(); 
            document.getElementById('e_dish').value = dish.trim(); 
            document.getElementById('e_room').value = room.trim(); 
            document.getElementById('e_table').value = table.trim(); 
            document.getElementById('e_qty').value = qty; 
            document.getElementById('e_note').value = note; 
            
            let statusSelect = document.getElementById('e_status');
            let hasOption = false;
            for (let i = 0; i < statusSelect.options.length; i++) {
                if (statusSelect.options[i].value === status.trim()) {
                    hasOption = true;
                    break;
                }
            }
            if (!hasOption) {
                let opt = document.createElement('option');
                opt.value = status.trim();
                opt.innerHTML = status.trim(); 
                statusSelect.appendChild(opt);
            }
            statusSelect.value = status.trim(); 
        }

        function handleAjaxSubmit(formId, type) {
            const form = document.getElementById(formId);
            if(!form.checkValidity()) { form.reportValidity(); return; }

            const searchParams = new URLSearchParams(new FormData(form));
            let btn = event.target;
            let originalText = btn.innerHTML;
            btn.innerHTML = "<i class='fas fa-spinner fa-spin'></i> Đang xử lý...";
            btn.disabled = true;

            fetch("invoice-detail-manager", {
                method: "POST", body: searchParams,
                headers: { "Content-Type": "application/x-www-form-urlencoded" }
            })
            .then(res => {
                if(res.ok) window.location.reload();
                else { alert("Lỗi khi xử lý dữ liệu."); btn.innerHTML = originalText; btn.disabled = false; }
            })
            .catch(err => { alert("Lỗi mạng."); btn.innerHTML = originalText; btn.disabled = false; });
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
<script>
    // Hàm tự động giới hạn số lượng nhập dựa trên tồn kho
    function updateMaxQuantity() {
        var select = document.getElementById("dish_select");
        if (!select) return;
        
        var selectedOption = select.options[select.selectedIndex];
        var maxQty = selectedOption.getAttribute("data-max");
        var qtyInput = document.getElementById("order_qty");
        
        if (maxQty && qtyInput) {
            qtyInput.setAttribute("max", maxQty);
            // Nếu số lượng đang nhập lớn hơn max, tự động ép về max
            if(parseInt(qtyInput.value) > parseInt(maxQty)) {
                qtyInput.value = maxQty;
            }
        }
    }

    // Chạy ngay khi vừa mở thẻ chọn món
    document.addEventListener("DOMContentLoaded", function() {
        // Lắng nghe sự kiện mở Modal Thêm Mới để update lại Max Qty
        var addModal = document.getElementById('addModal');
        if(addModal) {
            addModal.addEventListener('shown.bs.modal', function () {
                updateMaxQuantity();
            });
        }
    });
</script>
</body>
</html>