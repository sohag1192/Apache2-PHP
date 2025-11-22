
Here’s a clean, ready‑to‑run version you can use directly on Ubuntu:

   ```bash

wget https://raw.githubusercontent.com/sohag1192/Apache2-PHP/refs/heads/main/install.sh
   ```  
---

### 🚀 Usage on Ubuntu
1. Save the script as `install.sh`.  
2. Run:  
   ```bash
   chmod +x install.sh
   ./install.sh
   ```  
3. After installation, test with:  
   ```bash
   curl http://localhost/ip.php
   ```  

You’ll see output like:
```
Client IP (best guess): 127.0.0.1
Remote addr (Apache sees): 127.0.0.1
Server IP: 192.168.1.100
Forwarded for: n/a
Real IP header: n/a
```

---

