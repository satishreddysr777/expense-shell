echo Disable default version of Nodejs
dnf module disable nodejs -y

echo Enable Nodejs 18 version
dnf module enable nodejs:18 -y

echo Install Nodejs
dnf install nodejs -y

echo Configure backend service
cp backend.service /etc/systemd/system/backend.service

echo Adding application user
useradd expense

echo Remove existing app folder
rm -rf /app

echo Create application directory
mkdir /app

echo Download application content
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip
# shellcheck disable=SC2164
cd /app

echo Extracting application content
unzip /tmp/backend.zip

echo Downloading application dependencies
npm install

echo Reloading SystemD and start backend service
systemctl daemon-reload
systemctl enable backend
systemctl start backend

echo Installing mysql client
dnf install mysql -y

echo Laoding mysql schema
mysql -h mysql-dev.satishreddy.org -uroot -pExpenseApp@1 < /app/schema/backend.sql
