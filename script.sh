#!/bin/bash
mkdir $HOME/.aws
mv /tmp/credentials $HOME/.aws/.
export PATH="$HOME/.local/bin:$PATH"
sudo yum -y install python3
curl -O "https://bootstrap.pypa.io/get-pip.py"
python3 get-pip.py --user
sudo yum -y install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
pip install boto3
sudo cat /var/log/$1>/tmp/$1
python3 /tmp/upload_file.py "/tmp/$1" "$2"
