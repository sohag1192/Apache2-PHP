
---
![Badge](https://hitscounter.dev/api/hit?url=https%3A%2F%2Fgithub.com%2Fsohag1192%2FApache2-PHP&label=Vistors&icon=suit-heart-fill&color=%23f316c3&message=&style=flat&tz=UTC)

# Apache2-PHP Installer & IP Viewer

A lightweight shell script to install **Apache2 + PHP** on Ubuntu/Debian systems and deploy a PHP file (`ip.php`) that displays client IP, remote IP, and server IP information.  
Perfect for quick testing, reverse proxy debugging, and infrastructure demos.

---

## ✨ Features
- 🚀 One‑command installation of Apache2 and PHP
- 📄 Auto‑deployment of `ip.php` to `/var/www/html/`
- 🌐 Displays:
  - Client IP (best guess, using headers if present)
  - Remote IP (as seen by Apache)
  - Server IP
  - Forwarded headers (`X-Forwarded-For`, `X-Real-IP`)
- 🔒 MIT Licensed — free to use and adapt

---

## 📦 Installation (Ubuntu/Debian)

Clone the repository and run the installer:

```bash
git clone https://github.com/sohag1192/Apache2-PHP.git
cd Apache2-PHP
chmod +x Apache2&Php.sh
./Apache2&Php.sh
```

---

## 🖥️ Usage

After installation, test with:

```bash
curl http://localhost/ip.php
```

Example output:

```
Client IP (best guess): 127.0.0.1
Remote addr (Apache sees): 127.0.0.1
Server IP: 192.168.1.100
Forwarded for: n/a
Real IP header: n/a
```

---

## ⚙️ Reverse Proxy Support

If you’re behind a proxy (Nginx, HAProxy, Cloudflare), enable Apache’s `mod_remoteip`:

```bash
sudo a2enmod remoteip
sudo tee /etc/apache2/conf-available/remoteip.conf > /dev/null <<'CONF'
RemoteIPHeader X-Forwarded-For
RemoteIPTrustedProxy 127.0.0.1
RemoteIPTrustedProxy 10.0.0.0/8
RemoteIPTrustedProxy 172.16.0.0/12
RemoteIPTrustedProxy 192.168.0.0/16
CONF

sudo a2enconf remoteip
sudo systemctl reload apache2
```

This ensures Apache logs and PHP’s `$_SERVER['REMOTE_ADDR']` reflect the **real client IP** instead of the proxy.

---

## 🧹 Uninstallation

To remove Apache2, PHP, and the deployed file, run:

```bash
chmod +x uninstall.sh
./uninstall.sh
```

This will stop Apache2, remove packages, and clean up `/var/www/html/ip.php`.

---

## 📜 License
Distributed under the **MIT License**. See `LICENSE` for details.

---

## 👤 Maintainer
**Md. Sohag Rana**  
Network & IT Infrastructure Manager, Sarker Net  
📧 Email: sohag1192@gmail.com  
📱 Telegram: [@sohag1192](https://t.me/sohag1192)

---

## 🇧🇩 বাংলা নির্দেশনা

এই স্ক্রিপ্টটি Ubuntu/Debian সার্ভারে Apache2 এবং PHP ইন্সটল করবে এবং `/var/www/html/ip.php` ফাইল তৈরি করবে।  
এই ফাইলটি আপনার **Client IP, Remote IP, Server IP** এবং Proxy Header দেখাবে।  

ইন্সটল করতে:

```bash
git clone https://github.com/sohag1192/Apache2-PHP.git
cd Apache2-PHP
chmod +x Apache2&Php.sh
./Apache2&Php.sh
```

পরীক্ষা করতে:

```bash
curl http://localhost/ip.php
```

আনইন্সটল করতে:

```bash
chmod +x uninstall.sh
./uninstall.sh
```

