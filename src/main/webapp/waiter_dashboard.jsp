<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Phục Vụ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        body { 
            font-family: 'Inter', sans-serif; 
            background-color: #f8fafc; 
            color: #1e293b;
        }
        
        /* Navbar */
        .navbar { 
            background: #ffffff; 
            padding: 1rem 0;
            box-shadow: 0 4px 20px rgba(0,0,0,0.03);
        }
        .navbar-brand { font-weight: 800; color: #3730a3 !important; font-size: 1.4rem; }
        .btn-logout { border-radius: 12px; font-weight: 700; padding: 0.5rem 1.25rem; transition: 0.2s; }
        
        /* Typography */
        .section-title {
            font-weight: 800;
            font-size: 1.1rem;
            color: #475569;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
        }
        .section-title::after {
            content: "";
            flex: 1;
            height: 2px;
            background: #e2e8f0;
            margin-left: 1rem;
            border-radius: 2px;
        }

        /* Flow Cards (Thẻ quy trình) */
        .flow-card {
            background: #ffffff;
            border: 2px solid transparent;
            border-radius: 24px;
            padding: 2rem 1rem;
            text-align: center;
            text-decoration: none;
            color: #1e293b;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.02);
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
            height: 100%;
        }
        
        .flow-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 25px -5px rgba(67, 56, 202, 0.1);
            border-color: #e0e7ff;
        }
        
        /* Badge thứ tự bước */
        .step-badge {
            position: absolute;
            top: -15px;
            left: 50%;
            transform: translateX(-50%);
            background: #4338ca;
            color: white;
            width: 34px;
            height: 34px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-size: 1rem;
            border: 4px solid #f8fafc;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: 0.3s;
        }
        .flow-card:hover .step-badge { background: #312e81; transform: translateX(-50%) scale(1.1); }

        /* Icon Box Pastel */
        .icon-box {
            width: 75px;
            height: 75px;
            border-radius: 22px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.2rem;
            margin-bottom: 1.25rem;
            transition: 0.3s;
        }
        
        /* Các tone màu cho từng loại Card */
        /* 1. Tone Xanh Dương (Quy trình chuẩn) */
        .flow-card.card-primary .icon-box { background: #e0e7ff; color: #4338ca; }
        .flow-card.card-primary:hover .icon-box { background: #4338ca; color: #ffffff; }

        /* 2. Tone Xanh Lá (Thanh toán / Hoàn thành) */
        .flow-card.card-success .step-badge { background: #10b981; }
        .flow-card.card-success:hover { border-color: #d1fae5; box-shadow: 0 20px 25px -5px rgba(16, 185, 129, 0.15); }
        .flow-card.card-success .icon-box { background: #d1fae5; color: #059669; }
        .flow-card.card-success:hover .icon-box { background: #059669; color: #ffffff; }

        /* 3. Tone Vàng Cam (Đặt trước) */
        .flow-card.card-warning .step-badge { background: #f59e0b; color: white; }
        .flow-card.card-warning:hover { border-color: #fef3c7; box-shadow: 0 20px 25px -5px rgba(245, 158, 11, 0.1); }
        .flow-card.card-warning .icon-box { background: #fef3c7; color: #d97706; }
        .flow-card.card-warning:hover .icon-box { background: #d97706; color: #ffffff; }

        /* Utility Buttons */
        .util-btn {
            background: white;
            border: 1px solid #f1f5f9;
            border-radius: 20px;
            padding: 1.2rem;
            text-decoration: none;
            color: #475569;
            font-weight: 700;
            display: flex;
            align-items: center;
            transition: 0.2s;
            box-shadow: 0 4px 6px rgba(0,0,0,0.02);
        }
        .util-btn i {
            width: 45px;
            height: 45px;
            background: #f8fafc;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
            font-size: 1.2rem;
            color: #64748b;
            transition: 0.2s;
        }
        .util-btn:hover {
            border-color: #cbd5e1;
            transform: translateY(-3px);
            color: #1e293b;
        }
        .util-btn:hover i { background: #e2e8f0; color: #0f172a; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg mb-5 sticky-top">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center" href="#">
                <div class="bg-indigo-600 text-white p-2 rounded-3 me-2 shadow-sm" style="background-color: #4338ca;">
                    <i class="fas fa-concierge-bell px-1"></i>
                </div>
                <span>WAITER</span>
            </a>
            <div class="ms-auto d-flex align-items-center">
                <span class="fw-bold text-secondary me-4 d-none d-md-block">
                    <i class="far fa-user-circle me-1"></i> Phục vụ: ${sessionScope.user.fullName}
                </span>
                <a href="login.jsp" class="btn btn-outline-danger btn-logout btn-sm">
                    <i class="fas fa-power-off me-2"></i> ĐĂNG XUẤT
                </a>
            </div>
        </div>
    </nav>

    <div class="container pb-5">
        <div class="text-center mb-5">
            <h1 class="fw-extrabold mb-2" style="letter-spacing: -0.5px;">Ca làm việc mới đã sẵn sàng!</h1>
            <p class="text-muted fs-6">Chọn luồng thao tác tương ứng với yêu cầu của khách hàng.</p>
        </div>

        <div class="section-title">
            <i class="fas fa-street-view me-2 text-primary"></i>KHÁCH VÀO QUÁN TRỰC TIẾP
        </div>
        <div class="row g-4 mb-5">
            <div class="col-6 col-md-3">
                <a href="table-manager" class="flow-card card-primary">
                    <div class="step-badge">1</div>
                    <div class="icon-box"><i class="fas fa-chair"></i></div>
                    <h5 class="fw-bold mb-1">Sơ Đồ Bàn</h5>
                    <p class="small text-muted mb-0">Mở bàn đón khách</p>
                </a>
            </div>
            <div class="col-6 col-md-3">
                <a href="invoice-manager" class="flow-card card-primary">
                    <div class="step-badge">2</div>
                    <div class="icon-box"><i class="fas fa-file-invoice"></i></div>
                    <h5 class="fw-bold mb-1">Hóa Đơn</h5>
                    <p class="small text-muted mb-0">Tạo mã đơn hàng</p>
                </a>
            </div>
            <div class="col-6 col-md-3">
                <a href="invoice-detail-manager" class="flow-card card-primary">
                    <div class="step-badge">3</div>
                    <div class="icon-box"><i class="fas fa-utensils"></i></div>
                    <h5 class="fw-bold mb-1">Gọi Món</h5>
                    <p class="small text-muted mb-0">Order xuống bếp</p>
                </a>
            </div>
            <div class="col-6 col-md-3">
                <a href="print_bill_search.jsp" class="flow-card card-success">
                    <div class="step-badge">4</div>
                    <div class="icon-box"><i class="fas fa-cash-register"></i></div>
                    <h5 class="fw-bold mb-1 text-success">Thanh Toán</h5>
                    <p class="small text-muted mb-0">In Bill và Nhận tiền</p>
                </a>
            </div>
        </div>

        <div class="section-title mt-5">
            <i class="fas fa-calendar-alt me-2 text-warning"></i>KHÁCH ĐẶT BÀN TRƯỚC
        </div>
        <div class="row g-4 mb-5 justify-content-center">
            <div class="col-6 col-md-4">
                <a href="reservation-manager" class="flow-card card-warning">
                    <div class="step-badge">1</div>
                    <div class="icon-box"><i class="fas fa-book-open"></i></div>
                    <h5 class="fw-bold mb-1">Đặt Bàn</h5>
                    <p class="small text-muted mb-0">Ghi nhận lịch hẹn</p>
                </a>
            </div>
            <div class="col-6 col-md-4">
                <a href="deposit-manager" class="flow-card card-warning">
                    <div class="step-badge">2</div>
                    <div class="icon-box"><i class="fas fa-hand-holding-dollar"></i></div>
                    <h5 class="fw-bold mb-1">Nhận Cọc</h5>
                    <p class="small text-muted mb-0">Ghi nhận tiền cọc</p>
                </a>
            </div>
            <div class="col-6 col-md-4">
                <a href="preorder-manager" class="flow-card card-warning">
                    <div class="step-badge">3</div>
                    <div class="icon-box"><i class="fas fa-clipboard-list"></i></div>
                    <h5 class="fw-bold mb-1">Đặt Món Trước</h5>
                    <p class="small text-muted mb-0">Order trước thực đơn</p>
                </a>
            </div>
        </div>

        <div class="section-title mt-5">
            <i class="fas fa-toolbox me-2 text-secondary"></i> CÔNG CỤ HỖ TRỢ
        </div>
        <div class="row g-4 mb-3">
            <div class="col-md-6">
                <a href="workshift-manager" class="util-btn">
                    <i class="fas fa-user-clock"></i>
                    <div>
                        <div class="fs-5">Quản lý Ca Làm</div>
                        <div class="small fw-normal text-muted"></div>
                    </div>
                </a>
            </div>
            <div class="col-md-6">
                <a href="customer-manager" class="util-btn">
                    <i class="fas fa-users"></i>
                    <div>
                        <div class="fs-5">Khách Hàng</div>
                        <div class="small fw-normal text-muted"></div>
                    </div>
                </a>
            </div>
        </div>

        <footer class="text-center mt-5 pt-4 text-muted small fw-bold" style="border-top: 1px dashed #cbd5e1;">
            <p>&copy;NHÀ HÀNG</p>
        </footer>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>