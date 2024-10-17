#!/bin/bash

# Fix 2 fixing and updating `szmelc-update`

cd $HOME/szmelc/bin
rm szmelc-update

curl https://raw.githubusercontent.com/Szmelc-INC/Entropy-Package-Manager/refs/heads/main/szmelc-update > szmelc-update

chmod +x szmelc-update
sudo mv szmelc-update /bin/
echo "Complete"
