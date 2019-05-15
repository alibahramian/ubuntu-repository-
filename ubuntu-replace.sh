#!/bin/bash
# replacing  reposirory 

sudo cp /etc/apt/sources.list /etc/apt/sources.list.old

sudo sed -i 's+http://.*/ubuntu+http://YOURDOMAIN/ubuntu+gI' /etc/apt/sources.list

sudo apt update
