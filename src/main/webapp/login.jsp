<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - Hệ Thống</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #e0e7ff 0%, #f8fafc 100%);
            height: 100vh;
            display: flex;
            align-items: center;
        }

        .login-card {
            border: none;
            border-radius: 24px;
            background: #ffffff;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.05), 0 10px 10px -5px rgba(0, 0, 0, 0.02);
            padding: 40px;
        }

        .brand-logo {
            width: 70px;
            height: 70px;
            background: #4f46e5;
            color: white;
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            margin: 0 auto 20px;
            box-shadow: 0 10px 15px -3px rgba(79, 70, 229, 0.3);
        }

        .form-label {
            font-weight: 700;
            color: #64748b;
            font-size: 0.75rem;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .input-group-text {
            background-color: #f1f5f9;
            border: 1px solid #e2e8f0;
            border-right: none;
            color: #94a3b8;
            border-radius: 12px 0 0 12px;
        }

        .form-control {
            background-color: #f1f5f9;
            border: 1px solid #e2e8f0;
            border-left: none;
            border-radius: 0 12px 12px 0;
            padding: 12px;
            font-size: 0.95rem;
        }

        .form-control:focus {
            background-color: #ffffff;
            border-color: #4f46e5;
            box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
        }

        .btn-login {
            background: #4f46e5;
            border: none;
            border-radius: 12px;
            padding: 14px;
            font-weight: 700;
            transition: all 0.3s;
            margin-top: 10px;
            color: white;
        }

        .btn-login:hover {
            background: #4338ca;
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(79, 70, 229, 0.3);
            color: white;
        }

        .alert-custom {
            border-radius: 12px;
            font-size: 0.85rem;
            border: none;
            background-color: #fee2e2;
            color: #b91c1c;
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-11 col-sm-8 col-md-6 col-lg-4">
                
                <div class="card login-card text-center">
                    <div class="card-body p-0">
                        <div class="brand-logo">
                            <i class="fas fa-utensils"></i>
                        </div>
                        
                        <h3 class="fw-bold mb-1" style="color: #1e293b;">Đăng nhập</h3>
                        <p class="text-muted small mb-4">Sử dụng tài khoản Google để truy cập</p>
                        
                        <% if(request.getAttribute("error") != null) { %>
                            <div class="alert alert-custom d-flex align-items-center mb-4 text-start" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>
                                <div><%= request.getAttribute("error") %></div>
                            </div>
                        <% } %>

                        <form action="login" method="POST" class="text-start">
                            <div class="mb-3">
                                <label class="form-label">ĐỊA CHỈ GMAIL</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                    <input type="email" class="form-control" name="email" placeholder="example@gmail.com" required>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label">MẬT KHẨU</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                    <input type="password" class="form-control" name="password" placeholder="••••••••" required>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-login w-100 shadow-sm">
                                VÀO HỆ THỐNG <i class="fas fa-arrow-right ms-2"></i>
                            </button>
                        </form>
                    </div>
                </div>

                <div class="text-center mt-4">
                    <p class="text-secondary small">Bạn gặp sự cố? <a href="#" class="text-decoration-none fw-bold" style="color: #4f46e5;">Hỗ trợ kỹ thuật</a></p>
                </div>

            </div>
        </div>
    </div>

</body>
</html>