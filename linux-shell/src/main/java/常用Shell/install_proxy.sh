#!/bin/bash
tee /usr/local/bin/proxy <<EOF
#!/bin/bash
http_proxy=http://192.168.1.21:8123 https_proxy=http://192.168.1.21:8123 \$*
EOF

chmod +x /usr/local/bin/proxy
