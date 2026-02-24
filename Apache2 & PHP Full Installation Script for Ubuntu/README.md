

### How it works
- Updates and upgrades your system.  
- Installs **Apache2** and enables it at boot.  
- Installs **PHP** with common modules (MySQL, XML, GD, etc.).  
- Rewrites the `<Directory /var/www/>` block in `apache2.conf` to allow all files.  
- Enables `mod_rewrite` for flexible file handling.  
- Creates a `phpinfo()` test page to confirm setup.  

