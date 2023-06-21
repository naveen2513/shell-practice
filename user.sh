curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
useradd roboshop
rm -rf /app
mkdir /app
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/user.zip
cd /app
npm install
cp /home/centos/shell-practice/user.service /etc/systemd/system/user.service

cp /home/centos/shell-practice/mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org-shell -y
mongo --host mongo-dev.naveendevops2.online </app/schema/user.js
systemctl daemon-reload
systemctl enable user
systemctl restart user