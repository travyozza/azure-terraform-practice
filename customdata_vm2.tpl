#!/bin/bash

# Update the package list and upgrade existing packages

sudo apt update && sudo apt upgrade -y

# Script itself can run in priviliged, or run sudo / so I don't have to do it for each line

# Install Apache2 web server

sudo apt install -y apache2
 
# Start the Apache service

sudo systemctl start apache2
 
# Enable Apache to start on boot

sudo systemctl enable apache2
 
# Adjust firewall settings to allow traffic on port 80 (HTTP)

sudo ufw allow 'Apache' # could require port destination and source parameters. Could allow all inbound access instead of just allowing Apache.
 
sudo bash -c 'cat > /var/www/html/index.html <<EOF
<html>
<head>
<title>Welcome to My Web Page</title>
</head>
<body>
<h1>Hello from VM2!</h1>
<p>This is a simple web page hosted on my Apache server.</p>
</body>
</html>

EOF'

 