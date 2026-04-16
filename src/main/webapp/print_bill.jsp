<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <title>In Hóa Đơn - #${invoiceId}</title>
    <style>
        body { font-family: 'Courier New', Courier, monospace; width: 300px; margin: 0 auto; padding: 20px; color: #000; }
        .header { text-align: center; border-bottom: 1px dashed #000; padding-bottom: 10px; margin-bottom: 10px; }
        .header h2 { margin: 0; text-transform: uppercase; }
        .info { font-size: 12px; margin-bottom: 10px; }
        .table { width: 100%; border-collapse: collapse; font-size: 12px; }
        .table th { text-align: left; border-bottom: 1px solid #000; padding: 5px 0; }
        .table td { padding: 5px 0; }
        .footer { border-top: 1px dashed #000; margin-top: 10px; padding-top: 10px; }
        .total-row { display: flex; justify-content: space-between; font-weight: bold; margin-bottom: 5px; }
        .thank-you { text-align: center; margin-top: 20px; font-style: italic; font-size: 11px; }
        @media print { .no-print { display: none; } } /* Ẩn nút in khi in thực tế */
    </style>
</head>
<body>
    <div class="header">
        <h2>NHÀ HÀNG X</h2>
        <p style="font-size: 10px;">Địa chỉ: 123 Đường ABC, Hà Nội<br>SĐT: 0123 456 789</p>
    </div>

    <div class="info">
        <div>HÓA ĐƠN: #${invoiceId}</div>
        <div>Ngày: <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy HH:mm"/></div>
    </div>

    <table class="table">
        <thead>
            <tr>
                <th width="50%">Món</th>
                <th width="15%">SL</th>
                <th width="35%" style="text-align: right;">Tiền</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${billList}" var="item">
                <tr>
                    <td>${item.dishName}</td>
                    <td>${item.quantity}</td>
                    <td style="text-align: right;"><fmt:formatNumber value="${item.subTotal}" type="number"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <div class="footer">
        <div class="total-row">
            <span>TỔNG CỘNG:</span>
            <span><fmt:formatNumber value="${totalItems}" type="number"/> đ</span>
        </div>
        <div class="total-row" style="font-weight: normal; font-size: 12px;">
            <span>Tiền đặt cọc:</span>
            <span>- <fmt:formatNumber value="${deposit}" type="number"/> đ</span>
        </div>
        <div class="total-row" style="font-size: 16px; border-top: 1px double #000; padding-top: 5px;">
            <span>THANH TOÁN:</span>
            <span><fmt:formatNumber value="${finalAmount}" type="number"/> đ</span>
        </div>
    </div>

    <div class="thank-you">Cảm ơn Quý khách - Hẹn gặp lại!</div>

    <div class="no-print" style="margin-top: 30px; text-align: center;">
        <button onclick="window.print()" style="padding: 10px 20px; cursor: pointer;">BẮT ĐẦU IN</button>
        <button onclick="window.history.back()" style="padding: 10px 20px;">QUAY LẠI</button>
    </div>
</body>
</html>