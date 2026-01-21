# 🚀 Uptime Controller (Non-Docker Uptime Kuma Installer)

**Uptime Controller**, Ubuntu sunucularda **Docker kullanmadan** Uptime Kuma kurmak için hazırlanmış otomatik bir kurulum scriptidir.  
Script; **Node.js, Uptime Kuma, systemd servisi ve NGINX reverse-proxy** yapılandırmasını tek seferde kurar.


---
![Uptime Kuma](https://raw.githubusercontent.com/g0khanbey/uptimecontroller/main/uptimekoma.PNG)

## ✨ Özellikler

- ✅ Docker gerektirmez  
- ✅ Uptime Kuma otomatik kurulur  
- ✅ systemd servisi olarak çalışır  
- ✅ NGINX reverse-proxy hazır gelir  
- ✅ Sunucu reboot olsa bile otomatik başlar  
- ✅ Hafif ve VDS dostu

---

## 📦 Gereksinimler

- Ubuntu 20.04 / 22.04 / 24.04
- Root erişimi
- Açık portlar:
  - **80** (NGINX)
  - **3001** (Uptime Kuma)

---

## 🛠️ Kurulum

Sunucuda aşağıdaki komutları sırayla çalıştır:

```bash
cd /root
git clone https://github.com/g0khanbey/uptimecontroller.git
cd uptimecontroller
chmod +x uptimecontrollersetup.sh
./uptimecontrollersetup.sh
