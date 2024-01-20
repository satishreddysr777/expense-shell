source common.sh

component=backend
MYSQL_PASSWORD=$1

Head "Disable default version of Nodejs"
dnf module disable nodejs -y &>> $log_file
Stat $?

Head "Enable Nodejs 18 version"
dnf module enable nodejs:18 -y &>> $log_file
Stat $?

Head "Install Nodejs"
dnf install nodejs -y &>> $log_file
Stat $?

Head "Configure backend service"
cp backend.service /etc/systemd/system/backend.service &>> $log_file
Stat $?

Head "Adding application user"
useradd expense &>> $log_file
Stat $?

InitPreScript "/app"

Head "Downloading application dependencies"
npm install &>> $log_file
Stat $?

Head "Reloading SystemD and start backend service"
systemctl daemon-reload &>> $log_file
systemctl enable backend &>> $log_file
systemctl start backend &>> $log_file
Stat $?

Head "Installing mysql client"
dnf install mysql -y &>> $log_file
Stat $?

Head "Loading mysql schema"
mysql -h mysql-dev.satishreddy.org -uroot -p${MYSQL_PASSWORD} < /app/schema/backend.sql &>> $log_file
Stat $?
