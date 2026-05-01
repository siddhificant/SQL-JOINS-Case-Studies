USE sql_store;

-- 1. List all orders with customer names
SELECT o.order_id, c.first_name, c.last_name
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id;

-- 2. Show all products with their order quantities
SELECT p.product_id, p.name as products, oi.quantity
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id;

-- 3. Show orders with shipper name
SELECT o.order_id, s.name as shipper_name
FROM orders o
JOIN shippers s
USING (shipper_id)
ORDER BY order_id;

-- 4. Show order details with customer + shipper
SELECT o.order_id, c.first_name, s.name as shipper_name
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
LEFT JOIN shippers s
USING (shipper_id);

-- 5. Show each order item with product name + customer name
SELECT o.order_id, c.first_name, p.name as product, oi.quantity
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id;

-- 6. Show payments with client name and payment method
USE sql_invoicing;
SELECT p.date, p.invoice_id, p.date, p.amount, c.name as client_name, pm.name as payment_method
FROM payments p
JOIN clients c
ON p.client_id = c.client_id
JOIN payment_methods pm
ON p.payment_method = pm.payment_method_id
ORDER BY client_name;

-- 7. Find customers who have never placed an order
USE sql_store;
SELECT c.*
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 8. Find products that were never ordered
SELECT p.*
FROM products p
LEFT JOIN order_items oi
ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;

-- 9. Find orders that are not shipped yet
SELECT o.*
FROM orders o
LEFT JOIN shippers s
USING (shipper_id)
WHERE s.shipper_id IS NULL;

-- 10. Show employees with their manager names (SELF JOIN)
USE sql_hr;
SELECT e.employee_id, e.first_name as employee, m.first_name as manager
FROM employees e
JOIN employees m
ON e.reports_to = m.employee_id;

-- 11. Show invoices with client details + payments (if any)
USE sql_invoicing;
SELECT i.invoice_id, c.name, p.amount
FROM invoices i
LEFT JOIN clients c
USING (client_id)
LEFT JOIN payments p
USING (invoice_id)
ORDER BY i.invoice_id;

-- 12. Show order items with product + customer + order status
USE sql_store;
SELECT oi.order_id, c.first_name, p.name, os.name as status
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
JOIN orders o
ON oi.order_id = o.order_id
JOIN customers c
ON o.customer_id = c.customer_id
JOIN order_statuses os
ON o.status = os.order_status_id
ORDER BY c.first_name;

-- 13. Find customers who ordered a specific product (e.g., product_id = 3)
SELECT DISTINCT c.*
FROM customers c
JOIN orders o
USING (customer_id)
JOIN order_items oi
ON o.order_id = oi.order_id
WHERE oi.product_id =3;

DELIMITER $$
CREATE PROCEDURE self_joins_pairs()
BEGIN
-- 14. Find pairs of products that appear in the same order (SELF JOIN)
SELECT oi1.product_id, oi2.product_id, oi1.order_id
FROM order_items oi1
JOIN order_items oi2
ON oi1.order_id = oi2.order_id
AND oi1.product_id < oi2.product_id;
END$$
DELIMITER ;

CALL self_joins_pairs();

DELIMITER $$
CREATE PROCEDURE self_joins_same_company()
BEGIN
-- 15. Find employees working in the same office
SELECT e.first_name, o.first_name, o.office_id
FROM employees e
JOIN employees o
ON e.office_id = o.office_id
AND e.employee_id < o.employee_id;
END$$
DELIMITER ;

CALL self_joins_same_company();

-- 16. Find orders where customer city = shipper not assigned yet
USE sql_store;
SELECT o.order_id, c.city
FROM orders o
JOIN customers c
USING (customer_id)
LEFT JOIN shippers s
ON o.shipper_id = s.shipper_id
WHERE s.shipper_id IS NULL;

DELIMITER $$
CREATE PROCEDURE invoices_not_fully_paid()
BEGIN
-- 17. Find clients who made payments for invoices not fully paid
SELECT c.name, i.invoice_total, i.payment_total
FROM clients c
JOIN invoices i ON c.client_id = i.client_id
WHERE i.invoice_total > i.payment_total;
END$$
DELIMITER ;

CALL invoices_not_fully_paid();

DELIMITER $$
CREATE PROCEDURE orders_that_contain_more_than_one_product()
BEGIN
-- 18. Find orders that contain more than one product
SELECT DISTINCT oi1.order_id
FROM order_items oi1
JOIN order_items oi2
ON oi1.order_id = oi2.order_id
AND oi1.product_id <> oi2.product_id;
END$$
DELIMITER ;

CALL orders_that_contain_more_than_one_product();




