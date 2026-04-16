<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Màn Hình Bếp</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f1f5f9;
            color: #1e293b;
            min-height: 100vh;
        }

        /* Navbar xịn xò */
        .navbar-kds {
            background-color: #ffffff;
            border-bottom: 2px solid #e2e8f0;
            padding: 1rem 0;
        }
        .navbar-brand-kds { font-weight: 800; color: #f59e0b !important; letter-spacing: -1px; }

        /* Style cho từng Order Card */
        .order-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            overflow: hidden;
            background: #fff;
        }
        
        /* Trạng thái CHỜ NẤU - Màu Cam Amber */
        .status-pending { border-top: 8px solid #f59e0b; }
        .status-pending .quantity-text { color: #f59e0b; }
        .status-pending .card-header-kds { background-color: #fffbeb; }

        /* Trạng thái ĐANG NẤU - Màu Xanh Indigo */
        .status-cooking { border-top: 8px solid #4f46e5; }
        .status-cooking .quantity-text { color: #4f46e5; }
        .status-cooking .card-header-kds { background-color: #eef2ff; }

        .card-header-kds {
            padding: 15px 20px;
            font-weight: 700;
            font-size: 0.9rem;
            color: #475569;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .dish-name {
            font-weight: 800;
            font-size: 1.4rem;
            color: #1e293b;
            margin-bottom: 10px;
        }

        .quantity-text {
            font-size: 4rem;
            font-weight: 900;
            line-height: 1;
            margin: 15px 0;
        }

        .note-box {
            background-color: #f8fafc;
            border-radius: 12px;
            padding: 10px 15px;
            border-left: 4px solid #cbd5e1;
            font-size: 0.95rem;
            min-height: 60px;
        }

        /* Button cực to cho đầu bếp */
        .btn-kds {
            border-radius: 15px;
            padding: 15px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: 0.2s;
            border: none;
        }
        .btn-start { background-color: #f59e0b; color: white; }
        .btn-start:hover { background-color: #d97706; transform: scale(1.02); }
        
        .btn-done { background-color: #10b981; color: white; }
        .btn-done:hover { background-color: #059669; transform: scale(1.02); }

        .empty-state {
            margin-top: 100px;
            opacity: 0.5;
        }
        .empty-state i { font-size: 5rem; margin-bottom: 20px; }
    </style>
</head>
<body>

    <nav class="navbar navbar-kds sticky-top mb-4 shadow-sm">
        <div class="container-fluid px-4">
            <span class="navbar-brand-kds fs-3 d-flex align-items-center">
                <i class="fas fa-fire-burner me-2"></i> KITCHEN DISPLAY SYSTEM
            </span>
            <div class="d-flex align-items-center">
                <div class="me-4 d-none d-md-block text-end">
                    <div class="fw-bold small text-muted text-uppercase">Tự động làm mới</div>
                    <div class="badge bg-success"></div>
                </div>
                <a href="chef-kds" class="btn btn-warning fw-bold rounded-pill me-2 px-4 shadow-sm">
                    <i class="fas fa-sync-alt me-2"></i> LÀM MỚI
                </a>
                <a href="chef_dashboard.jsp" class="btn btn-outline-secondary rounded-pill fw-bold px-4">
                    <i class="fas fa-home me-2"></i> THOÁT
                </a>
            </div>
        </div>
    </nav>

    <div class="container-fluid px-4">
        <div class="row g-4">
            <c:forEach items="${pendingList}" var="p">
                <div class="col-sm-6 col-md-4 col-xl-3 col-xxl-2">
                    <div class="card h-100 order-card ${p.kitchenStatus == 'CHO_NAU' ? 'status-pending' : 'status-cooking'}">
                        <div class="card-header-kds">
                            <span><i class="fas fa-chair me-1"></i> BÀN ${p.roomId}-${p.tableNumber}</span>
                            <span class="small">#INV-${p.invoiceId}</span>
                        </div>
                        
                        <div class="card-body text-center d-flex flex-column">
                            <div class="dish-name text-uppercase">${p.dishId}</div>
                            
                            <div class="quantity-text">${p.quantity}</div>
                            
                            <div class="note-box text-start mb-3">
                                <small class="text-muted d-block fw-bold text-uppercase" style="font-size: 0.7rem;">Ghi chú:</small>
                                <span>${p.note == null || p.note == '' ? '---' : p.note}</span>
                            </div>

                            <div class="mt-auto">
                                <span class="badge w-100 mb-3 py-2 ${p.kitchenStatus == 'CHO_NAU' ? 'bg-warning text-dark' : 'bg-primary'}">
                                    ${p.kitchenStatus == 'CHO_NAU' ? '⏳ ĐANG ĐỢI NẤU' : '🔥 ĐANG CHẾ BIẾN'}
                                </span>
                            </div>
                        </div>

                        <div class="p-3 pt-0">
                            <div class="d-grid">
                                <c:if test="${p.kitchenStatus == 'CHO_NAU'}">
                                    <a href="chef-kds?action=updateStatus&invId=${p.invoiceId}&dishId=${p.dishId}&roomId=${p.roomId}&tableNum=${p.tableNumber}&status=DANG_NAU" 
                                       class="btn btn-kds btn-start shadow-sm">
                                        BẮT ĐẦU NẤU
                                    </a>
                                </c:if>
                                <c:if test="${p.kitchenStatus == 'DANG_NAU'}">
                                    <a href="chef-kds?action=updateStatus&invId=${p.invoiceId}&dishId=${p.dishId}&roomId=${p.roomId}&tableNum=${p.tableNumber}&status=DA_XONG" 
                                       class="btn btn-kds btn-done shadow-sm">
                                        XONG - RA MÓN
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
            
            <c:if test="${empty pendingList}">
                <div class="col-12 text-center empty-state">
                    <i class="fas fa-check-circle text-success"></i>
                    <h1 class="fw-bold">BẾP ĐÃ SẠCH ĐƠN!</h1>
                    <p class="fs-4">Hiện không có món nào cần chế biến thêm.</p>
                </div>
            </c:if>
        </div>
    </div>

    <script>
        setTimeout(function(){
            window.location.reload(1);
        }, 30000);
    </script>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>