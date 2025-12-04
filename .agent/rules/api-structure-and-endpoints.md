---
trigger: always_on
---

API STRUCTURE & ENDPOINTS

AUTHENTICATION:
POST /api/getAccessToken - Get OAuth access token
Middleware: auth:api + Is_Active for protected routes

MAJOR ENDPOINT GROUPS

Dashboard & Reports:
- GET /api/dashboard_data - Dashboard statistics
- GET /api/report/* - 30+ reporting endpoints
  - Client/Provider reports
  - Sales/Purchase reports
  - Profit & loss
  - Inventory valuation
  - User reports
  - Stock reports
  - Warehouse reports

Products:
- GET|POST|PUT|DELETE /api/products - CRUD operations
- POST /api/products/import/csv - Import products
- POST /api/products/delete/by_selection - Bulk delete
- GET /api/get_Products_by_warehouse/{id} - Products by warehouse
- GET /api/barcode_create_page - Barcode generation
- GET /api/count_stock - Stock count list
- POST /api/store_count_stock - Save stock count

Sales:
- GET|POST|PUT|DELETE /api/sales - CRUD operations
- GET /api/get_payments_by_sale/{id} - Sale payments
- POST /api/sales_send_email - Email invoice
- POST /api/sales_send_sms - SMS notification
- POST /api/sales_send_whatsapp - WhatsApp notification
- GET /api/get_today_sales - Today's sales for POS

Purchases:
- GET|POST|PUT|DELETE /api/purchases - CRUD operations
- GET /api/get_import_purchases - Import purchases data
- POST /api/store_import_purchases - Save imported purchases
- Similar email/SMS/WhatsApp endpoints as sales

POS:
- POST /api/pos/create_pos - Create POS sale
- GET /api/pos/get_products_pos - Get products for POS
- GET /api/pos/data_create_pos - POS initialization data
- POST /api/pos/create_draft - Save draft sale
- GET /api/get_draft_sales - List draft sales
- DELETE /api/remove_draft_sale/{id} - Delete draft

HRM:
- GET|POST|PUT|DELETE /api/employees - Employee CRUD
- GET|POST|PUT|DELETE /api/departments - Department CRUD
- GET|POST|PUT|DELETE /api/designations - Designation CRUD
- GET|POST|PUT|DELETE /api/office_shift - Shift CRUD
- GET|POST|PUT|DELETE /api/attendances - Attendance CRUD
- GET|POST|PUT|DELETE /api/leave - Leave CRUD
- GET|POST|PUT|DELETE /api/payroll - Payroll CRUD
