---
trigger: always_on
---

ARCHITECTURE & PATTERNS

BACKEND ARCHITECTURE

Directory Structure:
app/
├── Console/          # Artisan commands
├── Exceptions/       # Exception handlers
├── Exports/          # Excel export classes
├── Http/
│   ├── Controllers/  # Main controllers (50+ files)
│   │   ├── hrm/     # HRM module controllers
│   │   └── Auth/    # Authentication controllers
│   ├── Middleware/   # Custom middleware (12 files)
│   └── Kernel.php   # HTTP kernel
├── Mail/            # Mail classes
├── Models/          # Eloquent models (77+ models)
├── Policies/        # Authorization policies (41 files)
├── Providers/       # Service providers
└── utils/           # Utility classes

database/
├── migrations/      # 175+ migration files
├── seeds/          # Database seeders
└── factories/      # Model factories

routes/
├── api.php         # API routes (554 lines, extensive REST API)
├── web.php         # Web routes
├── channels.php    # Broadcast channels
└── console.php     # Console routes

config/             # 18 configuration files

FRONTEND STRUCTURE

resources/src/
├── App.vue          # Root component
├── main.js          # Main entry point
├── login.js         # Login entry point
├── router.js        # Vue Router configuration (1427 lines)
├── auth/            # Authentication logic
├── components/      # Reusable components
├── containers/      # Layout containers
├── plugins/         # Vue plugins (i18n, etc.)
├── store/           # Vuex store modules
├── translations/    # 19 language files
├── utils/           # Utility functions
├── views/           # 145+ view components
│   └── app/
│       ├── dashboard/
│       └── pages/
│           ├── products/
│           ├── sales/
│           ├── purchases/
│           ├── quotations/
│           ├── hrm/
│           ├── accounts/
│           ├── projects/
│           ├── tasks/
│           └── ... (many more modules)
└── assets/          # Static assets (380+ files)

KEY ARCHITECTURAL PATTERNS
- RESTful API Design: All business logic exposed via REST API endpoints in routes/api.php
- SPA (Single Page Application): Vue.js frontend consumes Laravel API
- Middleware-based Authentication:
  - auth:api - Laravel Passport authentication
  - Is_Active - Check if user account is active
  - IsActiveToken - Token validation
- Policy-based Authorization: 41 policy files for fine-grained permissions
- Modular Design: Support for add-on modules via nwidart/laravel-modules
- Multi-tenancy Ready: Warehouse-based data segregation with user assignments
