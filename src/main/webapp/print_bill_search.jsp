<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>In Hóa Đơn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { font-family: 'Quicksand', sans-serif; background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); height: 100vh; }
        .search-card { border: none; border-radius: 20px; overflow: hidden; }
        .card-header-custom { background: #198754; color: white; padding: 30px; text-align: center; }
        .btn-print { background: #198754; border: none; padding: 12px; font-weight: 600; border-radius: 10px; }
    </style>
</head>
<body class="d-flex align-items-center">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5 col-lg-4">
                <div class="mb-3">
                    <a href="invoice-manager" class="text-decoration-none text-secondary">
                        <i class="fas fa-arrow-left me-2"></i> Quay lại quản lý
                    </a>
                </div>

                <div class="card search-card shadow-lg">
                    <div class="card-header-custom">
                        <div class="fs-1 mb-2"><i class="fas fa-file-invoice-dollar"></i></div>
                        <h4 class="fw-bold mb-0">TÌM HÓA ĐƠN</h4>
                        <small class="opacity-75">Nhập mã hóa đơn để in lại</small>
                    </div>
                    
                    <div class="card-body p-4 p-lg-5">
                        <form action="print-bill" method="GET">
                            <label class="form-label fw-bold text-secondary small">MÃ HÓA ĐƠN</label>
                            <div class="input-group mb-4">
                                <span class="input-group-text bg-white border-end-0 text-success"><i class="fas fa-hashtag"></i></span>
                                <input type="number" name="invoiceId" class="form-control border-start-0" placeholder="Ví dụ: 101" required autofocus>
                            </div>
                            
                            <div class="d-grid gap-3">
                                <button type="submit" class="btn btn-success btn-print text-white">
                                    <i class="fas fa-print me-2"></i> XUẤT HÓA ĐƠN
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>