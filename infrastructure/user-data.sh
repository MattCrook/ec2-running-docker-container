#!/bin/bash

cat > index.html <<EOF
<h1>Fairwinds SRE Technical Challenge</h1>
<p>AMI address: ${public_ip}</p>
<p>Server port: ${server_port}</p>
EOF

nohup busybox httpd -f -p ${server_port} &
