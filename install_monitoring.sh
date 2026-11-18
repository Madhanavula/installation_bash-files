
#!/bin/bash

set -e

echo "=========================================="
echo " Installing Prometheus, Node Exporter & Grafana"
echo "=========================================="

# Update packages
sudo apt update
sudo apt install -y wget tar curl gnupg apt-transport-https

# ==========================================
# 1. INSTALL PROMETHEUS
# ==========================================

echo "Installing Prometheus..."

mkdir -p ~/prometheus
cd ~/prometheus

wget -q https://github.com/prometheus/prometheus/releases/download/v3.12.0/prometheus-3.12.0.linux-amd64.tar.gz

tar -xzf prometheus-3.12.0.linux-amd64.tar.gz

cd prometheus-3.12.0.linux-amd64

# Configure Prometheus
cat > prometheus.yml <<EOF
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node_exporter'
    static_configs:
      - targets: ['localhost:9100']
EOF

# Start Prometheus in background
nohup ./prometheus --config.file=prometheus.yml \
--web.listen-address=:9090 > prometheus.log 2>&1 &

echo "Prometheus installed and started."

# ==========================================
# 2. INSTALL NODE EXPORTER
# ==========================================

echo "Installing Node Exporter..."

mkdir -p ~/nodeexporter
cd ~/nodeexporter

wget -q https://github.com/prometheus/node_exporter/releases/download/v1.11.1/node_exporter-1.11.1.linux-amd64.tar.gz

tar -xzf node_exporter-1.11.1.linux-amd64.tar.gz

cd node_exporter-1.11.1.linux-amd64

# Start Node Exporter in background
nohup ./node_exporter \
--web.listen-address=:9100 > node_exporter.log 2>&1 &

echo "Node Exporter installed and started."

# ==========================================
# 3. INSTALL GRAFANA
# ==========================================

echo "Installing Grafana..."

sudo mkdir -p /etc/apt/keyrings

sudo wget -q -O /etc/apt/keyrings/grafana.asc \
https://apt.grafana.com/gpg-full.key

sudo chmod 644 /etc/apt/keyrings/grafana.asc

echo "deb [signed-by=/etc/apt/keyrings/grafana.asc] https://apt.grafana.com stable main" | \
sudo tee /etc/apt/sources.list.d/grafana.list

sudo apt update

sudo apt install -y grafana

# Start and enable Grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

echo "Grafana installed and started."

# ==========================================
# 4. FINAL VERIFICATION
# ==========================================

echo "=========================================="
echo " Installation Completed!"
echo "=========================================="

echo "Prometheus:    http://YOUR_EC2_PUBLIC_IP:9090"
echo "Node Exporter: http://YOUR_EC2_PUBLIC_IP:9100/metrics"
echo "Grafana:       http://YOUR_EC2_PUBLIC_IP:3000"

echo ""
echo "Checking services..."

sleep 5

curl -s http://localhost:9090/-/healthy
curl -s http://localhost:9100/metrics | head -5

sudo systemctl status grafana-server --no-pager

echo ""
echo "Default Grafana credentials:"
echo "Username: admin"
echo "Password: admin"
echo "=========================================="
