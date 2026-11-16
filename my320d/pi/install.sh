#!/bin/sh
# Install (or remove) the My 320d learning app as a small web service.
#   sudo sh install.sh          install or update, then start
#   sudo sh install.sh remove   stop and delete everything this script created
set -eu

DIR=/opt/my320d
UNIT=/etc/systemd/system/my320d.service
PORT=8320

[ "$(id -u)" = 0 ] || { echo "Run with sudo."; exit 1; }

if [ "${1:-}" = remove ]; then
  systemctl disable --now my320d 2>/dev/null || true
  rm -f "$UNIT"
  rm -rf "$DIR"
  systemctl daemon-reload
  echo "Removed."
  exit 0
fi

SRC=$(cd "$(dirname "$0")" && pwd)
install -d -m 755 "$DIR"
install -m 644 "$SRC/index.html" "$DIR/index.html"

cat > "$UNIT" <<EOF
[Unit]
Description=My 320d learning app (static page on port $PORT)
After=network.target

[Service]
ExecStart=/usr/bin/python3 -m http.server $PORT --directory $DIR
DynamicUser=yes
MemoryMax=64M
NoNewPrivileges=yes
ProtectSystem=strict
ProtectHome=yes
PrivateTmp=yes
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable my320d >/dev/null 2>&1
systemctl restart my320d
sleep 1

# Check: the page must answer locally.
if python3 -c "import urllib.request,sys; sys.exit(0 if b'My 320d' in urllib.request.urlopen('http://127.0.0.1:$PORT/').read() else 1)"; then
  echo "OK: http://$(hostname -I | awk '{print $1}'):$PORT"
else
  echo "The service did not answer. See: journalctl -u my320d -n 20"
  exit 1
fi
