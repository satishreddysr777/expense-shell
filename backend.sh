source common.sh

component=backend
MYSQL_PASSWORD=$1

Head "Disable default version of Nodejs"
dnf module disable nodejs -y &>> $log_file
Status $?

Head "Enable Nodejs 18 version"
dnf module enable nodejs:18 -y &>> $log_file
Status $?

Head "Install Nodejs"
dnf install nodejs -y &>> $log_file
Status $?

Head "Configure backend service"
cp backend.service /etc/systemd/system/backend.service &>> $log_file
Status $?

Head "Adding application user"
id expense &>> $log_file
if [ $? -ne 0 ]; then
  useradd expense &>> $log_file
fi
Status $?

InitPreScript "/app"

Head "Downloading application dependencies"
npm install &>> $log_file
Status $?

Head "Reloading SystemD and start backend service"
systemctl daemon-reload &>> $log_file
systemctl enable backend &>> $log_file
systemctl start backend &>> $log_file
Status $?

Head "Installing mysql client"
dnf install mysql -y &>> $log_file
Status $?

Head "Loading mysql schema"
mysql -h mysql-dev.satishreddy.org -uroot -p${MYSQL_PASSWORD} < /app/schema/backend.sql &>> $log_file
Status $?
