<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Tiền Cọc</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        body { 
            font-family: 'Inter', sans-serif; 
            background-color: #f8fafc; 
            color: #1e293b;
        }
        
        .navbar { 
            background: #ffffff; 
            border-bottom: 1px solid #e2e8f0; 
            padding: 1rem 0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        .navbar-brand { font-weight: 800; color: #4338ca !important; }

        /* Main Card & Table Styling */
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

        /* Badge & Amount Styling */
        .res-id-badge {
            background-color: #f1f5f9;
            color: #475569;
            padding: 6px 12px;
            border-radius: 10px;
            font-weight: 700;
            font-size: 0.85rem;
        }
        .amount-text { 
            font-weight: 800; 
            color: #059669; 
            font-size: 1.1rem;
        }
        .status-badge {
            background-color: #dcfce7;
            color: #15803d;
            padding: 5px 12px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.75rem;
            text-transform: uppercase;
        }

        /* Action Buttons */
        .btn-action { 
            width: 36px; height: 36px; 
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

    <nav class="navbar navbar-expand-lg mb-4 sticky-top shadow-sm">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center" href="#">
                <i class="fas fa-clock-rotate-left me-2"></i> QUẢN LÝ ĐẶT CỌC
            </a>
            <c:choose>
                <c:when test="${sessionScope.user.position.toUpperCase() eq 'WAITER'}">
                    <c:set var="dashLink" value="waiter_dashboard.jsp" />
                </c:when>
                <c:otherwise>
                    <c:set var="dashLink" value="manager_dashboard.jsp" />
                </c:otherwise>
            </c:choose>
            <a href="${dashLink}" class="btn btn-outline-secondary btn-sm px-4 rounded-pill fw-bold">
                <i class="fas fa-arrow-left me-2"></i> Dashboard
            </a>
        </div>
    </nav>
                
    <div class="container pb-5">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <h3 class="fw-bold mb-1">Giao dịch đặt cọc</h3>
                <p class="text-muted mb-0 small text-uppercase fw-600" style="letter-spacing: 1px;">Theo dõi các khoản tạm ứng tài chính của khách hàng</p>
            </div>
            <button class="btn btn-primary btn-add" data-bs-toggle="modal" data-bs-target="#addModal">
                <i class="fas fa-plus-circle me-2"></i> Thêm Lần Cọc
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
                            <th>Mã Đặt Bàn</th>
                            <th class="text-center">Lần Cọc</th>
                            <th class="text-end">Số Tiền</th>
                            <th class="text-center">Trạng Thái</th>
                            <th class="text-end">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${depList}" var="d">
                            <tr>
                                <td><span class="res-id-badge"><i class="fas fa-hashtag me-1 small opacity-50"></i>${d.reservationId}</span></td>
                                <td class="text-center">
                                    <span class="badge rounded-pill bg-light text-dark border px-3">Lần thứ ${d.depositTurn}</span>
                                </td>
                                <td class="text-end">
                                    <span class="amount-text">
                                        <fmt:formatNumber value="${d.amount}" type="number"/>
                                    </span>
                                </td>
                                <td class="text-center">
                                    <span class="status-badge">
                                        <i class="fas fa-check-circle me-1"></i>${d.status}
                                    </span>
                                </td>
                                <td class="text-end text-nowrap">
                                    <button class="btn-action btn-edit-custom me-1" 
                                            data-bs-toggle="modal" 
                                            data-bs-target="#editModal" 
                                            onclick="fillEdit('${d.reservationId}','${d.depositTurn}','${d.amount}','${d.status}')">
                                        <i class="fas fa-pen-to-square"></i>
                                    </button>
                                    <a href="deposit-manager?action=delete&resId=${d.reservationId}&turn=${d.depositTurn}" 
                                       class="btn-action btn-delete-custom me-2" 
                                       onclick="return confirm('Xác nhận xóa lịch sử tiền cọc này?');">
                                        <i class="fas fa-trash-can"></i>
                                    </a>
                                    
                                    <a href="preorder-manager?reservationId=${d.reservationId}" class="btn btn-sm btn-outline-success fw-bold ms-1" title="Khách chọn món trước">
                                        Đặt Món <i class="fas fa-arrow-right ms-1"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
        
        <p class="text-center mt-5 text-muted small">Mọi giao dịch tiền cọc được lưu vết bảo mật</p>
    </div>

    <div class="modal fade" id="addModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg">
                <form id="addForm" action="deposit-manager" method="POST">
                    <div class="modal-header border-0 p-4 pb-0">
                        <h5 class="fw-bold mb-0 text-indigo-600"><i class="fas fa-plus-circle me-2"></i>Ghi Nhận Tiền Cọc</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="add">
                        
                        <div class="mb-3">
                            <label class="form-label">Chọn Đơn Đặt Bàn</label>
                            <select name="reservationId" class="form-select shadow-sm">
                                <c:forEach items="${resList}" var="r">
                                    <option value="${r.reservationId}">${r.reservationId} - Khách: ${r.customerId}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="row g-3">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Lần cọc thứ</label>
                                <input type="number" name="depositTurn" class="form-control" value="1" required min="1">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Số tiền</label>
                                <input type="number" step="0.01" name="amount" class="form-control" placeholder="0.00" required>
                            </div>
                        </div>

                        <div class="mb-1">
                            <label class="form-label">Trạng thái hạch toán</label>
                            <input type="text" name="status" class="form-control" value="Da Thu">
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="button" id="btnSubmitAdd" onclick="handleLogic()" class="btn btn-primary w-100 py-3 fw-bold rounded-pill shadow" style="background: #4338ca; border: none;">XÁC NHẬN THU TIỀN</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow-lg">
                <form action="deposit-manager" method="POST">
                    <div class="modal-header border-0 p-4 pb-0">
                        <h5 class="fw-bold mb-0 text-primary"><i class="fas fa-edit me-2"></i>Cập Nhật Giao Dịch</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="action" value="edit">
                        
                        <div class="row g-3 mb-3">
                            <div class="col-6">
                                <label class="form-label text-muted small">Mã đặt bàn</label>
                                <input type="text" name="reservationId" id="e_res" class="form-control bg-light border-0 fw-bold" readonly>
                            </div>
                            <div class="col-6">
                                <label class="form-label text-muted small">Lần cọc</label>
                                <input type="number" name="depositTurn" id="e_turn" class="form-control bg-light border-0 fw-bold" readonly>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Số tiền điều chỉnh</label>
                            <input type="number" step="0.01" name="amount" id="e_amount" class="form-control shadow-sm" required>
                        </div>

                        <div class="mb-1">
                            <label class="form-label">Cập nhật trạng thái</label>
                            <input type="text" name="status" id="e_status" class="form-control shadow-sm" required>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-0">
                        <button type="submit" class="btn btn-primary w-100 py-3 fw-bold rounded-pill shadow">LƯU THAY ĐỔI</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function fillEdit(res, turn, amount, status) { 
            document.getElementById('e_res').value = res; 
            document.getElementById('e_turn').value = turn; 
            document.getElementById('e_amount').value = amount; 
            document.getElementById('e_status').value = status; 
        }

        // HÀM XỬ LÝ LƯU NGẦM VÀ TẢI LẠI TRANG
        function handleLogic() {
            const form = document.getElementById('addForm');
            const btnSubmit = document.getElementById('btnSubmitAdd');

            // 1. Kiểm tra Validation của Form HTML
            if(!form.checkValidity()) {
                form.reportValidity();
                return;
            }

            // Đổi trạng thái nút để tránh click nhiều lần
            btnSubmit.innerHTML = "<i class='fas fa-spinner fa-spin'></i> Đang lưu...";
            btnSubmit.disabled = true;

            // 2. Ép dữ liệu thành dạng chuẩn
            const formData = new FormData(form);
            const params = new URLSearchParams();
            for (const [key, value] of formData.entries()) {
                params.append(key, value);
            }

            // 3. Gửi ngầm về Servlet
            fetch("deposit-manager", {
                method: "POST",
                body: params.toString(), 
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
                }
            })
            .then(response => {
                if(response.ok) {
                    // Tải lại trang để bảng hiển thị dữ liệu mới kèm nút "Đặt món"
                    window.location.reload(); 
                } else {
                    alert("Lỗi Server khi lưu! Vui lòng kiểm tra lại.");
                    btnSubmit.innerHTML = "XÁC NHẬN THU TIỀN";
                    btnSubmit.disabled = false;
                }
            })
            .catch(error => {
                alert("Lỗi kết nối mạng, không thể lưu!");
                console.error(error);
                btnSubmit.innerHTML = "XÁC NHẬN THU TIỀN";
                btnSubmit.disabled = false;
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