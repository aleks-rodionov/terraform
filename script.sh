curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo yum -y install python3
sudo yum -y install zip
unzip awscliv2.zip
sudo $HOME/aws/install
curl -O https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py --user
pip install boto3