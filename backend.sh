dnf module disable nodejs -y
dnf module enable nodejs:18 -y

dnf install nodejs -y

useradd expense

mkdir /app

curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip
# shellcheck disable=SC2164
cd /app
unzip /tmp/backend.zip

npm install

cp backend.service /etc/systemd/system/backend.service

systemctl daemon-reload

systemctl enable backend
systemctl start backend

dnf install mysql -y

mysql -h 172.31.36.226 -uroot -pExpenseApp@1 < /app/schema/backend.sql
