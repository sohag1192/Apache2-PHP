
---
![Badge](https://hitscounter.dev/api/hit?url=https%3A%2F%2Fgithub.com%2Fsohag1192%2FApache2-PHP&label=Vistors&icon=suit-heart-fill&color=%23f316c3&message=&style=flat&tz=UTC)

# Apache2-PHP Installer

![Shell Script](https://img.shields.io/badge/language-shell-blue.svg)
![Ubuntu](https://img.shields.io/badge/platform-ubuntu%20%7C%20debian-green.svg)
![License: MIT](https://img.shields.io/badge/license-MIT-yellow.svg)
![Status](https://img.shields.io/badge/status-stable-brightgreen.svg)

A simple shell script set for Ubuntu/Debian to install and uninstall **Apache2 + PHP** with common modules. Includes configuration tweaks to allow serving all file types and a test PHP file for verification.

---

## 🚀 Features
- One‑command installation of Apache2 + PHP  
- Auto‑configuration of Apache to allow all files  
- Deployment of a PHP test page (`info.php`)  
- Easy uninstallation script to clean up packages and configs  

---

## 📦 Installation
Clone the repository and run the installer:

```bash
git clone https://github.com/sohag1192/Apache2-PHP.git
cd Apache2-PHP
chmod +x install.sh uninstall.sh
./install.sh
```

---

## 🖥️ Verification
After installation, open in your browser:

```
http://your_server_ip/info.php
```

You should see the PHP info page confirming Apache + PHP integration.

---

## 🔄 Uninstallation
To remove Apache2 and PHP completely:

```bash
./uninstall.sh
```

This stops services, purges packages, and deletes configuration files.

---

## 📜 Usage
1. Save each script as `install.sh` and `uninstall.sh`.  
2. Make them executable:
   ```bash
   chmod +x install.sh uninstall.sh
   ```
3. Run with:
   ```bash
   ./install.sh
   ./uninstall.sh
   ```

---

## 👤 Author
**Md. Sohag Rana**  
GitHub: [Sohag1192](https://github.com/sohag1192)  
📱 Telegram: @sohag1192  
🌍 Location: Bangladesh  


---
