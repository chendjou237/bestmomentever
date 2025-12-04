---
trigger: always_on
---

TROUBLESHOOTING & COMMON ISSUES

Known Issues & Fixes (from version history):
- Backup Issues: Fixed in v1.1, v3.3.0
- Dark Mode: Fixed in v1.2
- Import Products: Fixed in v1.4, v3.0.0, v3.2.0
- POS Receipt Printer: Fixed in v2.5.0, v3.3.2
- Barcode Printing: Fixed in v3.3.0
- Variants Editing: Fixed in v2.3.0, v3.3.0
- Profit Calculation: Fixed in v3.4.0, v3.5.0
- Stripe Integration: Fixed in v4.0.6
- Exclusive Tax Calculations: Fixed in v4.0.8

Debug Mode:
- Set APP_DEBUG=true in .env for development
- Check storage/logs/laravel.log for errors
- Use browser console for frontend errors

VERSION-SPECIFIC NOTES

Current Version: 4.0.8
- Laravel 10 upgrade
- PHP 8.1+ required
- Camera scanner for all transactions
- Multiple barcode printing
- Combo products feature
- Project & task management
- WhatsApp notifications
- Import purchases via Excel
- Today's sales in POS

Upgrade Path:
- Refer to README.md for version history
- Documentation includes upgrade video guide
- Always backup before upgrading
- Test in staging environment first

DOCUMENTATION & RESOURCES

Available Documentation:
- Main documentation in documentation/ folder
- Duplicate in documentation 2/ folder
- Compressed version: documentation.zip
- Installation guide included
- Upgrade guide with video

Support & Updates:
- Version info: version.txt (currently "4.0.8")
- Update check: GET /api/get_version_info
- Commercial product from CodeCanyon
- Regular updates and bug fixes

CRITICAL RULES FOR AGENT

DO:
✅ Follow Laravel and Vue.js best practices
✅ Use existing patterns found in the codebase
✅ Maintain consistency with naming conventions
✅ Test changes in multiple warehouses if applicable
✅ Update all language files when adding new text
✅ Check permissions before implementing features
✅ Use Eloquent ORM for database operations
✅ Follow RESTful API conventions
✅ Validate all user inputs
✅ Handle errors gracefully with proper messages
✅ Update documentation when adding features
✅ Consider multi-warehouse implications
✅ Test with different user roles

DON'T:
❌ Modify core Laravel files
❌ Break existing API contracts
❌ Ignore warehouse-based filtering
❌ Hardcode values that should be configurable
❌ Skip input validation
❌ Expose sensitive data in API responses
❌ Use raw SQL queries (use Eloquent)
❌ Ignore existing middleware
❌ Create duplicate functionality
❌ Forget to update permissions
❌ Skip translation for new features
❌ Ignore mobile responsiveness
❌ Break PDF generation functionality

When in Doubt:
- Check existing similar features for patterns
- Review the extensive API routes file
- Look at existing controllers for examples
- Follow the established directory structure
- Consult the version history for context
- Test thoroughly before deploying

QUICK REFERENCE

Key Files:
- Main API Routes: routes/api.php
- Vue Router: resources/src/router.js
- Main Entry: resources/src/main.js
- Environment: .env
- Webpack Config: webpack.mix.js
- Composer: composer.json
- NPM: package.json

Key Directories:
- Controllers: app/Http/Controllers/
- Models: app/Models/
- Views: resources/src/views/
- Migrations: database/migrations/
- Public Assets: public/
- Storage: storage/

Common Commands:
# Development
php artisan serve
npm run watch

# Database
php artisan migrate
php artisan db:seed

# Cache
php artisan cache:clear
php artisan config:cache

# Build
npm run prod

STATISTICS:
Total Models: 77
Total Migrations: 175+
Total Controllers: 50+
Total Routes: 200+ API endpoints
Total Views: 145+
Supported Languages: 19+

Last Updated: Based on Stocky v4.0.8 analysis
