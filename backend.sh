MYSQL_PASSWORD=$1

source common.sh

Head "Disable default version of Nodejs"
dnf module disable nodejs -y &>> $log_file
echo $?

Head "Enable Nodejs 18 version"
dnf module enable nodejs:18 -y &>> $log_file
echo $?

Head "Install Nodejs"
dnf install nodejs -y &>> $log_file
echo $?

Head "Configure backend service"
cp backend.service /etc/systemd/system/backend.service &>> $log_file
echo $?

Head "Adding application user"
useradd expense &>> $log_file
echo $?

Head "Remove existing app folder"
rm -rf /app &>> $log_file
echo $?

Head "Create application directory"
mkdir /app &>> $log_file
echo $?

Head "Download application content"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>> $log_file
# shellcheck disable=SC2164
cd /app &>> $log_file
echo $?

Head "Extracting application content"
unzip /tmp/backend.zip &>> $log_file
echo $?

Head "Downloading application dependencies"
npm install &>> $log_file
echo $?

Head "Reloading SystemD and start backend service"
systemctl daemon-reload &>> $log_file
systemctl enable backend &>> $log_file
systemctl start backend &>> $log_file
echo $?

Head "Installing mysql client"
dnf install mysql -y &>> $log_file
echo $?

Head "Loading mysql schema"
mysql -h mysql-dev.satishreddy.org -uroot -p${MYSQL_PASSWORD} < /app/schema/backend.sql &>> $log_file
echo $?
