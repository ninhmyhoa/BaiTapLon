<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Bàn Ăn</title>
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
        
        .status-badge { padding: 5px 12px; border-radius: 20px; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; }
        .status-ranh { background-color: #dcfce7; color: #16a34a; } 
        .status-co-khach { background-color: #e0e7ff; color: #4338ca; } 
        .status-da-dat { background-color: #fef3c7; color: #d97706; } 

        .room-badge { background-color: #f1f5f9; color: #475569; padding: 4px 10px; border-radius: 8px; font-weight: 700; font-size: 0.8rem; }

        .btn-action { width: 36px; height: 36px; display: inline-flex; align-items: center; justify-content: center; border-radius: 10px; transition: all 0.2s; border: none; }
        .btn-edit-custom { background: #e0e7ff; color: #4338ca; }
        .btn-edit-custom:hover { background: #4338ca; color: white; }
        .btn-delete-custom { background: #fee2e2; color: #dc2626; }
        .btn-delete-custom:hover { background: #dc2626; color: white; }

        .btn-add { background: #4338ca; border: none; border-radius: 14px; font-weight: 700; padding: 12px 24px; box-shadow: 0 10px 15px -3px rgba(67, 56, 202, 0.3); transition: 0.3s; }
        .btn-add:hover { background: #3730a3; transform: translateY(-2px); color: white; }
        
        .btn-merge { background: #0ea5e9; color: white; border: none; border-radius: 14px; font-weight: 700; padding: 12px 24px; box-shadow: 0 10px 15px -3px rgba(14, 165, 233, 0.3); transition: 0.3s; margin-right: 10px; }
        .btn-merge:hover { background: #0284c7; transform: translateY(-2px); color: white; }

        .modal-content { border: none; border-radius: 28px; }
        .form-label { font-weight: 700; font-size: 0.8rem; color: #64748b; text-transform: uppercase; margin-bottom: 0.5rem; }
        .form-control, .form-select { border-radius: 12px; padding: 12px 15px; border: 1px solid #e2e8f0; background-color: #f8fafc; }
        .form-control:focus { background-color: white; border-color: #4338ca; box-shadow: 0 0 0 4px rgba(67, 56, 202, 0.1); }
        
        .checkbox-card { border: 2px solid #e2e8f0; transition: 0.2s; cursor: pointer; }
        .checkbox-card:hover { border-color: #0ea5e9; background-color: #f0f9ff; }
        .form-check-input:checked + label { color: #0284c7; }
    </style>
</head>
<body>

    <jsp:include page="sidebar.jsp">
        <jsp:param name="menu" value="menu1" /> <jsp:param name="active" value="table" /> </jsp:include>

    <div class="main-content">
        
        <div class="top-navbar">
            <span class="me-3 mt-1 fw-bold">Xin chào</span>
            <a href="login.jsp" class="btn btn-outline-danger btn-sm px-3 rounded-pill"><i class="fas fa-sign-out-alt me-1"></i>Đăng xuất</a>
        </div>

    <div class="container pb-5">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <h3 class="fw-bold mb-1">Quản lý trạng thái bàn</h3>
                <p class="text-muted mb-0 small text-uppercase fw-600" style="letter-spacing: 1px;">Theo dõi tình trạng sử dụng bàn theo khu vực</p>
            </div>
            <div>
                <button class="btn btn-merge" data-bs-toggle="modal" data-bs-target="#mergeModal">
                    <i class="fas fa-layer-group me-2"></i> Mở HĐ Nhóm
                </button>
                <button class="btn btn-primary btn-add" data-bs-toggle="modal" data-bs-target="#addModal">
                    <i class="fas fa-plus-circle me-2"></i> Thêm Bàn
                </button>
            </div>
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
                            <th>Khu Vực / Phòng</th>
                            <th class="text-center">Số Thứ Tự Bàn</th>
                            <th class="text-center">Trạng Thái</th>
                            <th class="text-end">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${tableList}" var="t">
                            <tr>
                                <td><span class="room-badge"><i class="fas fa-door-open me-2 small opacity-50"></i>${t.roomId}</span></td>
                                
                                <td class="text-center">
                                    <div class="fw-bold fs-5 text-dark">Bàn ${t.tableNumber}</div>
                                    
                                    <c:set var="tableKey" value="${t.roomId.trim()}-${t.tableNumber}" />
                                    
                                    <c:if test="${not empty resMap[tableKey]}">
                                        <div class="mt-2">
                                            <span class="badge bg-warning text-dark border border-warning shadow-sm" 
                                                  style="font-size: 0.65rem; padding: 6px 8px; white-space: normal; line-height: 1.4;">
                                                <i class="fas fa-bell text-danger me-1"></i> Khách đến:<br>
                                                <span class="fw-bold">${resMap[tableKey]}</span>
                                            </span>
                                        </div>
                                    </c:if>
                                </td>

                                <td class="text-center">
                                    <span class="status-badge 
                                        ${t.status == 'Trống' ? 'status-ranh' : 
                                          (t.status == 'Đang phục vụ' ? 'status-co-khach' : 'status-da-dat')}">
                                        <i class="fas 
                                              ${t.status == 'Trống' ? 'fa-check-circle' : 
                                              (t.status == 'Đang phục vụ' ? 'fa-user-group' : 'fa-clock')} me-1"></i>
                                        ${t.status}
                                    </span>
                                </td>
                                <td class="text-end text-nowrap">
                                    <button class="btn-action btn-edit-custom me-1" data-bs-toggle="modal" data-bs-target="#editModal" 
                                            onclick="fillEdit('${t.roomId}','${t.tableNumber}','${t.status}')">
                                        <i class="fas fa-pen-to-square"></i>
                                    </button>
                                    <a href="table-manager?action=delete&roomId=${t.roomId}&tableNum=${t.tableNumber}" 
                                       class="btn-action btn-delete-custom me-2" onclick="return confirm('Bạn có chắc muốn xóa bàn này?');">
                                        <i class="fas fa-trash-can"></i>
                                    </a>

                                    <c:choose>
                                        <c:when test="${t.status == 'Trống'}">
                                            <a href="table-manager?action=checkin&roomId=${t.roomId}&tableNum=${t.tableNumber}" 
                                               class="btn btn-sm btn-primary fw-bold shadow-sm">
                                                Mở Bàn & HĐ <i class="fas fa-sign-in-alt ms-1"></i>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="invoice-manager" class="btn btn-sm btn-outline-indigo fw-bold">
                                                Vào HĐ <i class="fas fa-file-invoice ms-1"></i>
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal fade" id="mergeModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content shadow-lg">
                <form id="mergeForm" action="table-manager" method="POST">
                    <div class="modal-header border-0 p-4 pb-0">
                        <h5 class="fw-bold mb-0 text-info" style="color: #0ea5e9 !important;">
                            <i class="fas fa-layer-group me-2"></i>Mở Hóa Đơn Cho Nhiều Bàn
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="merge">
                        
                        <div class="alert alert-info border-0 rounded-4 py-2 small mb-4">
                            <i class="fas fa-info-circle me-2"></i> Chọn các bàn trống bên dưới. Hệ thống sẽ tự động tạo chung 1 Hóa đơn cho các bàn này.
                        </div>

                        <label class="form-label text-primary">Danh Sách Bàn Đang Trống</label>
                        <div class="row g-3" style="max-height: 250px; overflow-y: auto; overflow-x: hidden; padding: 5px;">
                            <c:forEach items="${tableList}" var="t">
                                <c:if test="${t.status == 'Trống'}">
                                    <div class="col-md-4 col-6">
                                        <div class="form-check checkbox-card rounded-3 p-3 shadow-sm d-flex align-items-center h-100">
                                            <input class="form-check-input ms-0 me-2 mt-0" style="transform: scale(1.2);" type="checkbox" name="selectedTables" value="${t.roomId}|${t.tableNumber}" id="m${t.roomId}${t.tableNumber}">
                                            <label class="form-check-label fw-bold m-0 w-100 cursor-pointer" for="m${t.roomId}${t.tableNumber}">
                                                ${t.roomId} - Bàn ${t.tableNumber}
                                            </label>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="submit" class="btn btn-info text-white w-100 py-3 fw-bold rounded-pill shadow" style="background: #0ea5e9;">
                            TẠO HÓA ĐƠN CHUNG <i class="fas fa-arrow-right ms-2"></i>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="addModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg">
                <form id="addForm" action="table-manager" method="POST">
                    <div class="modal-header border-0 p-4 pb-0">
                        <h5 class="fw-bold mb-0"><i class="fas fa-plus-circle text-primary me-2"></i>Thiết Lập Bàn Mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="mb-3">
                            <label class="form-label">Chọn Khu Vực / Phòng</label>
                            <select name="roomId" class="form-select shadow-sm">
                                <c:forEach items="${roomList}" var="r">
                                    <option value="${r.roomId}">${r.roomId}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Số thứ tự bàn</label>
                            <input type="number" name="tableNumber" class="form-control shadow-sm" placeholder="VD: 01, 02..." required min="1">
                        </div>

                            <div class="mb-1">
                                <label class="form-label">Trạng thái ban đầu</label>
                                <select name="status" class="form-select shadow-sm">
                                    <option value="Trống">Trống (Sẵn sàng)</option>
                                    <option value="Đang phục vụ">Đang phục vụ (Có khách)</option>
                                    <option value="Đã đặt">Đã đặt trước</option>
                                </select>
                            </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" onclick="handleTableSubmit('addForm')" class="btn btn-primary w-100 py-3 fw-bold rounded-pill shadow">XÁC NHẬN THÊM BÀN</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg">
                <form id="editForm" action="table-manager" method="POST">
                    <div class="modal-header border-0 p-4 pb-0">
                        <h5 class="fw-bold mb-0 text-indigo-600"><i class="fas fa-edit me-2"></i>Cập Nhật Trạng Thái Bàn</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="edit">
                        
                        <div class="row g-3 mb-3">
                            <div class="col-6">
                                <label class="form-label text-muted small">Phòng</label>
                                <input type="text" name="roomId" id="e_room" class="form-control bg-light border-0 fw-bold" readonly>
                            </div>
                            <div class="col-6">
                                <label class="form-label text-muted small">Số Bàn</label>
                                <input type="number" name="tableNumber" id="e_num" class="form-control bg-light border-0 fw-bold" readonly>
                            </div>
                        </div>

                                <div class="mb-1">
                                    <label class="form-label">Cập nhật trạng thái</label>
                                    <select name="status" id="e_status" class="form-select shadow-sm">
                                        <option value="Trống">Trống (Sẵn sàng)</option>
                                        <option value="Đang phục vụ">Đang phục vụ (Có khách)</option>
                                        <option value="Đã đặt">Đã đặt trước</option>
                                    </select>
                                </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" onclick="handleTableSubmit('editForm')" class="btn btn-primary w-100 py-3 fw-bold rounded-pill shadow">LƯU THAY ĐỔI</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function fillEdit(room, num, stat) { 
            document.getElementById('e_room').value = room; 
            document.getElementById('e_num').value = num; 
            document.getElementById('e_status').value = stat; 
        }

        function handleTableSubmit(formId) {
            const form = document.getElementById(formId);

            if(!form.checkValidity()) {
                form.reportValidity();
                return;
            }

            const formData = new FormData(form);
            const searchParams = new URLSearchParams(formData);

            fetch("table-manager", {
                method: "POST",
                body: searchParams,
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                }
            })
            .then(function(response) {
                if(response.ok) {
                    window.location.reload();
                } else {
                    alert("Lỗi khi xử lý trên máy chủ!");
                }
            })
            .catch(function(error) {
                alert("Lỗi khi kết nối đến máy chủ. Vui lòng thử lại!");
                console.error(error);
            });
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
</body>
</html>