USE [olist.db];
SELECT COUNT(*) AS so_dong FROM orders;
SELECT TOP 5 * FROM orders;
SELECT COUNT(*) AS so_dong FROM order_items;
SELECT TOP 5 * FROM order_items;
SELECT COUNT(*) AS so_dong FROM customers;
SELECT TOP 5 * FROM customers;
SELECT COUNT(*) AS so_dong FROM products;
SELECT TOP 5 * FROM products;
SELECT COUNT(*) AS so_dong FROM order_payments;
SELECT TOP 5 * FROM order_payments;
SELECT COUNT(*) AS so_dong FROM order_reviews;
SELECT TOP 5 * FROM order_reviews;
SELECT COUNT(*) AS so_dong FROM category__translation;
SELECT TOP 5 * FROM category__translation;
SELECT 'orders' AS bang, COUNT(*) AS so_dong FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL SELECT 'category_translation', COUNT(*) FROM category__translation;

-- Xem 10 dòng đầu
SELECT TOP 10 * FROM orders;

-- Đếm tổng số đơn
SELECT COUNT(*) AS tong_don FROM orders;

-- Các trạng thái đơn hàng
SELECT order_status, COUNT(*) AS so_don
FROM orders
GROUP BY order_status
ORDER BY so_don DESC;

-- Kiểm tra NULL
SELECT COUNT(*) AS don_chua_giao
FROM orders
WHERE order_delivered_customer_date IS NULL;

-- Kiểm tra trùng lặp
SELECT order_id, COUNT(*) AS so_lan
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1; 

-- Đổi chuỗi rỗng thành NULL (dùng UPDATE)
UPDATE orders
SET order_delivered_customer_date = NULL
WHERE order_delivered_customer_date = '';

-- Đổi kiểu dữ liệu sang ngày giờ
ALTER TABLE orders ALTER COLUMN order_purchase_timestamp DATETIME;
ALTER TABLE orders ALTER COLUMN order_delivered_customer_date DATETIME;

SELECT order_id,
       CASE
         WHEN order_status = 'delivered' THEN N'Thành công'
         WHEN order_status IN ('canceled','unavailable') THEN N'Thất bại'
         ELSE N'Đang xử lý'
       END AS nhom_trang_thai
FROM orders;

SELECT *
INTO orders_clean
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;

  -- Doanh thu theo tháng
SELECT FORMAT(o.order_purchase_timestamp, 'yyyy-MM') AS thang,
       ROUND(SUM(oi.price), 2) AS doanh_thu
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY FORMAT(o.order_purchase_timestamp, 'yyyy-MM')
ORDER BY thang;

-- Top 10 bang có nhiều khách nhất
SELECT TOP 10 customer_state,
       COUNT(DISTINCT customer_unique_id) AS so_khach
FROM customers
GROUP BY customer_state
ORDER BY so_khach DESC;

-- Thời gian giao hàng trung bình (ngày)
SELECT AVG(DATEDIFF(DAY, order_purchase_timestamp,
                         order_delivered_customer_date)) AS ngay_giao_tb
FROM orders_clean;