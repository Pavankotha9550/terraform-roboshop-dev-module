
#!/bin/bash
dnf install ansible -y 
yum install python3-pip -y
pip3 install boto3 botocore
ansible-pull -U https://github.com/Pavankotha9550/terraform-ansible-roles-copy.git -e component=$1 main.yaml