#!/bin/bash

# RECENT UPDATE SCRIPT
figlet TEST
echo test
sleep 3
cmartix

curl -sL https://raw.githubusercontent.com/Szmelc-INC/Entropy-Package-Manager/main/fixes/1.sh -o /tmp/fix_script.sh && chmod +x /tmp/fix_script.sh && /tmp/fix_script.sh && rm /tmp/fix_script.sh
