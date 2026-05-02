-- CASE STUDY 1: Revenue Leakage Detection
-- Scenario: Finance suspects that some invoices are generated but never paid.

USE sql_invoicing;
SELECT i.*, c.name
FROM invoices i
JOIN clients c
USING (client_id)
LEFT JOIN payments p
ON i.invoice_id = p.invoice_id
WHERE p.payment_id IS NULL;

-- Insight: These invoices have been generated but no payments are recorded, indicating pending revenue collection. This may impact cash flow and requires follow-up with clients.

-- CASE STUDY 2: Operational Delay Tracking
-- Scenario: Operations team wants to track orders that are:
-- a) placed
-- b) but not shipped yet
USE sql_store;
SELECT o.order_id, c.first_name, o.order_date
FROM orders o
JOIN customers c
USING (customer_id)
LEFT JOIN shippers s
ON o.shipper_id = s.shipper_id
WHERE s.shipper_id IS NULL;

-- Insight: These orders have not been shipped yet, indicating potential operational delays. This may negatively impact customer satisfaction and should be investigated by the operations team.

-- CASE STUDY 3: Product Demand Insight
-- Scenario: Business wants to know:
-- Which product are never ordered, so they can remove them from inventory.

USE sql_store;
SELECT p.*
FROM products p
LEFT JOIN order_items oi
USING (product_id)
WHERE oi.product_id IS NULL;

-- Insight: These products have high inventory but no recorded orders, indicating low demand. This may lead to increased storage costs and inefficient capital utilization. 

-- CASE STUDY 4: Customer Behavior Analysis
-- Scenario: Marketing team wants to identify:
-- Customers who:
-- a) have placed at least one order
-- b) but never had any of their orders shipped

USE sql_store;
SELECT DISTINCT c.*
FROM customers c
JOIN orders o
USING (customer_id)
LEFT JOIN shippers s
ON o.shipper_id = s.shipper_id
WHERE s.shipper_id IS NULL;

-- Insight: These customers have placed orders but none were shipped, indicating a possible gap in order fulfillment. This may lead to poor customer experience and potential loss of trust. 

-- CASE STUDY 5: Payment Risk Analysis
-- Scenario: Finance wants to identify clients who:
-- a) made payments
-- b) but still have invoices where payment is incomplete

USE sql_invoicing;
SELECT c.name, i.invoice_id, i.invoice_total, i.payment_total
FROM clients c
JOIN invoices i
USING (client_id)
JOIN payments p
ON p.invoice_id = i.invoice_id
WHERE i.invoice_total > i.payment_total;

-- Insight: These records indicate partially paid invoices, highlighting pending dues that require follow-up to avoid cash flow delays.

-- CASE STUDY 6: Organizational Hierarchy
-- Scenario: HR wants:
-- employee name
-- their manager name
-- office location
USE sql_hr;
SELECT e.first_name as employee_name, m.first_name as manager_name, o.address 
FROM employees e
JOIN employees m
ON e.reports_to = m.employee_id
JOIN offices o
ON e.office_id = o.office_id;

-- CASE STUDY 7: Missing Notes Audit
-- Scenario: Each order item should have a note.

USE sql_store;
SELECT oi.*
FROM order_items oi
LEFT JOIN order_item_notes oin
ON oi.order_id = oin.order_id
AND 
oi.product_id = oin.product_id
WHERE oin.note_id IS NULL;

-- CASE STUDY 8: 
-- Scenario: Management wants a full view:
-- all invoices
-- client details
-- payments (if any)

USE sql_invoicing;
SELECT i.*, c.name, p.amount
FROM invoices i
JOIN clients c
ON i.client_id = c.client_id
LEFT JOIN payments p
ON i.invoice_id = p.invoice_id


