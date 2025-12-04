---
trigger: always_on
---

TESTING GUIDELINES

Backend Testing:
- Test files in tests/ directory
- PHPUnit configuration in phpunit.xml
- Run tests: php artisan test or vendor/bin/phpunit

Frontend Testing:
- No explicit test framework configured
- Manual testing recommended for UI changes
- Test in multiple browsers (IE support added in v1.1)

Testing Checklist for New Features:
✓ API Endpoints: Test with Postman/Insomnia
✓ Permissions: Verify role-based access
✓ Warehouse Filtering: Test with different warehouse assignments
✓ Multi-language: Check all language files updated
✓ Responsive Design: Test on mobile devices
✓ PDF Generation: Verify PDF output
✓ Email/SMS: Test notification delivery
✓ Import/Export: Test CSV/Excel functionality

DEPLOYMENT & PRODUCTION

Environment Configuration:
- Copy .env.example to .env
- Configure database credentials
- Set APP_ENV=production
- Set APP_DEBUG=false
- Configure mail settings
- Configure SMS gateway credentials
- Set up Stripe keys if using payments

Build for Production:
npm run prod
php artisan config:cache
php artisan route:cache
php artisan view:cache

Server Requirements:
- PHP 8.1+
- MySQL 5.7+ or MariaDB
- Composer
- Node.js & NPM
- Apache/Nginx with mod_rewrite
- PHP extensions: BCMath, Ctype, Fileinfo, JSON, Mbstring, OpenSSL, PDO, Tokenizer, XML, GD

File Permissions:
chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache

SECURITY CONSIDERATIONS

Best Practices Implemented:
- CSRF Protection: Laravel's CSRF middleware enabled
- SQL Injection: Eloquent ORM prevents SQL injection
- XSS Protection: Laravel escapes output by default
- Mass Assignment: Models use $fillable or $guarded
- Authentication: OAuth2 via Passport
- Authorization: Policy-based access control
- Password Hashing: Bcrypt hashing
- HTTPS: Recommended for production

Security Improvements Over Versions:
v1.3, v2.0, v2.1.0, v3.3.0, v3.4.0: Improved security

When Making Changes:
✓ Always validate user input
✓ Use Laravel's validation rules
✓ Check user permissions before operations
✓ Sanitize data before database operations
✓ Use parameterized queries (Eloquent handles this)
✓ Never expose sensitive data in API responses
✓ Log security-relevant events
