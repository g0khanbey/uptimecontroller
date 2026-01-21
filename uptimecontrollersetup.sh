#!/bin/bash
set -e

echo "=== UPTIME KUMA INSTALLER (NON-DOCKER) ==="

if [ "$EUID" -ne 0 ]; then
  echo "Root olarak çalıştır."
  exit 1
fi

echo "[1/7] Sistem güncelleniyor..."
apt update -y
apt upgrade -y

echo "[2/7] Gerekli paketler kuruluyor..."
apt install -y curl git sudo build-essential nginx

echo "[3/7] Node.js 18 kuruluyor..."
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs

echo "[4/7] Uptime Kuma indiriliyor..."
cd /opt
if [ -d "uptime-kuma" ]; then
  echo "Önceden kurulmuş, klasör siliniyor..."
  rm -rf uptime-kuma
fi
git clone https://github.com/louislam/uptime-kuma.git
cd uptime-kuma

echo "[5/7] Uptime Kuma build ediliyor..."
npm run setup

echo "[6/7] systemd servisi oluşturuluyor..."
cat > /etc/systemd/system/uptime-kuma.service <<EOF
[Unit]
Description=Uptime Kuma
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/uptime-kuma
ExecStart=/usr/bin/node server/server.js
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable uptime-kuma
systemctl start uptime-kuma

echo "[7/7] NGINX reverse proxy ayarlanıyor..."

cat > /etc/nginx/sites-available/kuma <<EOF
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:3001;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

ln -sf /etc/nginx/sites-available/kuma /etc/nginx/sites-enabled/kuma
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl reload nginx

IP=$(curl -s ifconfig.me)

echo ""
echo "====================================="
echo " UPTIME KUMA KURULDU "
echo " Panel: http://$IP"
echo " Port: 3001 (NGINX üzerinden 80)"
echo "====================================="
