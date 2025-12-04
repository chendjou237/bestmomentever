---
trigger: always_on
---

API STRUCTURE & ENDPOINTS (Continued)

Accounting:
- GET|POST|PUT|DELETE /api/accounts - Account CRUD
- GET|POST|PUT|DELETE /api/expenses - Expense CRUD
- GET|POST|PUT|DELETE /api/deposits - Deposit CRUD
- GET|POST|PUT|DELETE /api/transfer_money - Money transfer CRUD

Projects & Tasks:
- GET|POST|PUT|DELETE /api/projects - Project CRUD
- POST /api/project_discussions - Project discussions
- POST /api/project_issues - Project issues
- POST /api/project_documents - Project documents
- GET|POST|PUT|DELETE /api/tasks - Task CRUD
- GET /api/tasks_kanban - Kanban view
- POST /api/task_change_status - Update task status

Settings:
- GET|PUT /api/settings - System settings
- GET|PUT /api/pos_settings/{id} - POS settings
- GET|PUT /api/update_config_mail/{id} - Email settings
- GET|POST /api/get_sms_config - SMS settings
- GET|POST /api/get_payment_gateway - Payment gateway settings
- GET /api/get_modules_info - Module management
- POST /api/upload_module - Upload new module

Utilities:
- GET /api/clear_cache - Clear application cache
- GET /api/get_backup - List backups
- GET /api/generate_new_backup - Create backup
- DELETE /api/delete_backup/{name} - Delete backup

PDF Generation Endpoints (No Auth Required):
- GET /api/sale_pdf/{id}
- GET /api/purchase_pdf/{id}
- GET /api/quote_pdf/{id}
- GET /api/return_sale_pdf/{id}
- GET /api/return_purchase_pdf/{id}
- GET /api/payment_*_pdf/{id} - Various payment PDFs
- GET /api/sales_print_invoice/{id} - POS receipt
