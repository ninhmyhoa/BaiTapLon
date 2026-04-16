<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khu Vực Bếp</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;600;700&display=swap" rel="stylesheet">
    
    <style>
        body {
            font-family: 'Quicksand', sans-serif;
            background-color: #0f172a; /* Slate 900 */
            color: #f8fafc;
            height: 100vh;
            overflow: hidden;
        }

        /* Navbar */
        .navbar {
            background-color: rgba(30, 41, 59, 0.7) !important;
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        .navbar-brand { font-weight: 700; letter-spacing: 1px; color: #fbbf24 !important; }

        /* Dashboard Container */
        .chef-container {
            height: calc(100vh - 100px);
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        /* Action Card */
        .chef-card {
            background: rgba(30, 41, 59, 0.5);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 24px;
            padding: 2rem;
            text-decoration: none;
            color: white;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex;
            flex-direction: column;
            align-items: center;
            height: 100%;
        }

        .chef-card:hover {
            transform: translateY(-10px);
            background: rgba(51, 65, 85, 0.8);
            border-color: #fbbf24;
            color: white;
        }

        /* Icon Styling */
        .icon-circle {
            width: 80px;
            height: 80px;
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            margin-bottom: 1.5rem;
            transition: all 0.3s;
        }

        /* Colors per action */
        .kds-card { border: 2px solid #fbbf24; background: rgba(251, 191, 36, 0.05); }
        .kds-card .icon-circle { background: #fbbf24; color: #0f172a; box-shadow: 0 0 20px rgba(251, 191, 36, 0.3); }
        
        .history-card .icon-circle { background: #64748b; color: white; }
        .shift-card .icon-circle { background: #38bdf8; color: white; }

        .card-title { font-weight: 700; font-size: 1.25rem; margin-bottom: 0.5rem; }
        .card-desc { font-size: 0.9rem; color: #94a3b8; text-align: center; }

        .btn-logout {
            border-radius: 12px;
            font-weight: 600;
            padding: 0.5rem 1.5rem;
        }

        /* Animation cho icon Bếp */
        @keyframes fire {
            0% { transform: scale(1); opacity: 0.8; }
            50% { transform: scale(1.1); opacity: 1; }
            100% { transform: scale(1); opacity: 0.8; }
        }
        .fa-fire-burner { animation: fire 2s infinite; }
    </style>
</head>
<body>

    <nav class="navbar navbar-dark py-3">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center" href="#">
                <i class="fas fa-fire-burner me-3 text-warning"></i>
                <span>BẾP</span>
            </a>
            <a href="login.jsp" class="btn btn-outline-danger btn-logout btn-sm">
                    <i class="fas fa-power-off me-2"></i> ĐĂNG XUẤT
                </a>
        </div>
    </nav>

    <div class="container chef-container">
        <div class="text-center mb-5">
            <h1 class="fw-bold mb-2">Xin chào Chef!</h1>
            <p class="text-warning opacity-75">Hôm nay bếp của chúng ta đang hoạt động rất tốt.</p>
        </div>

        <div class="row g-4 justify-content-center">
            
            <div class="col-md-4">
                <a href="chef-kds" class="chef-card kds-card">
                    <div class="icon-circle">
                        <i class="fas fa-utensils"></i>
                    </div>
                    <div class="card-title">NHẬN MÓN</div>
                    <p class="card-desc">Theo dõi order, chế biến và báo hoàn thành món ăn.</p>
                </a>
            </div>

            <div class="col-md-3">
                <a href="export-history-manager" class="chef-card history-card">
                    <div class="icon-circle">
                        <i class="fas fa-boxes-stacked"></i>
                    </div>
                    <div class="card-title">XUẤT KHO</div>
                    <p class="card-desc">Xem lịch sử sử dụng nguyên liệu trong ngày.</p>
                </a>
            </div>

            <div class="col-md-3">
                <a href="workshift-manager" class="chef-card shift-card">
                    <div class="icon-circle">
                        <i class="fas fa-clock-rotate-left"></i>
                    </div>
                    <div class="card-title">CA LÀM VIỆC</div>
                    <p class="card-desc">Kiểm tra lịch trực và chấm công ra/vào ca.</p>
                </a>
            </div>

        </div>

        <div class="mt-5 text-center">
            <div class="badge bg-success px-3 py-2 rounded-pill">
                <span class="spinner-grow spinner-grow-sm me-2"></span>
                Hệ thống đang kết nối trực tiếp với Phục vụ
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>