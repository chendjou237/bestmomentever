---
trigger: always_on
---

Stocky Inventory Management System - Agent Rules

PROJECT OVERVIEW
Stocky is a comprehensive inventory management system with POS (Point of Sale) capabilities, built as a commercial CodeCanyon product. Current version: 4.0.8

CORE FEATURES
- Inventory & Product Management (with variants, barcodes, combo products)
- Point of Sale (POS) with draft sales
- Sales, Purchases, Quotations
- Returns Management (Sales & Purchase)
- Warehouse & Transfer Management
- Stock Adjustments & Count Stock
- Client & Supplier Management
- HRM (Human Resource Management) Module
- Accounting Module (Accounts, Deposits, Expenses, Transfer Money)
- Payroll Management
- Project & Task Management
- Shipment/Delivery Management
- Reporting & Analytics
- Multi-warehouse support with user assignments
- Multi-language support (19+ languages)
- Payment Gateway Integration (Stripe)
- SMS Notifications (Twilio, Nexmo/Vonage, InfoBip)
- WhatsApp Notifications
- Email Notifications with custom templates
- Barcode scanning & printing
- Import/Export functionality (CSV, Excel, PDF)

TECHNOLOGY STACK

Backend:
- Framework: Laravel 10.x
- PHP Version: 8.1+ (minimum requirement)
- Database: MySQL/MariaDB
- Authentication: Laravel Passport (OAuth2)
- Architecture: MVC with Repository pattern
- Module System: nwidart/laravel-modules for modular architecture

Frontend:
- Framework: Vue.js 2.6.12
- Router: Vue Router 3.x
- State Management: Vuex 3.x
- UI Framework: Bootstrap 4.5.3 + Bootstrap Vue 2.21.2
- Build Tool: Laravel Mix 6.x (Webpack wrapper)
- Internationalization: vue-i18n 8.x

KEY DEPENDENCIES

Backend:
- barryvdh/laravel-dompdf - PDF generation
- maatwebsite/excel - Excel import/export
- intervention/image - Image processing
- stripe/stripe-php - Payment processing
- twilio/sdk, infobip/infobip-api-php-client - SMS services
- yajra/laravel-datatables-oracle - DataTables server-side processing
- nwidart/laravel-modules - Modular architecture support

Frontend:
- vue-good-table - Data tables
- vue-select - Enhanced select components
- vue-sweetalert2 - Alert dialogs
- vue-barcode - Barcode generation
- echarts + vue-echarts - Charts and analytics
- jspdf + jspdf-autotable - Client-side PDF generation
- vee-validate - Form validation
- moment - Date/time manipulation
- axios - HTTP client
