log_file=/tmp/expense.log

Head() {
  echo -e "\e[35m$1\e[0m"
}


Head "Installing Nginx"
dnf install nginx -y &>> $log_file
echo $?

Head "Copying expense config file"
cp expense.conf /etc/nginx/default.d/expense.conf &>> $log_file
echo $?

Head "Removing Old/Default content"
rm -rf /usr/share/nginx/html/* &>> $log_file
echo $?

Head "Download frontend application content"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip &>> $log_file
echo $?

Head "Extracting application content"
# shellcheck disable=SC2164
cd /usr/share/nginx/html &>> $log_file
unzip /tmp/frontend.zip &>> $log_file
echo $?

Head "Start Nginx service"
systemctl enable nginx &>> $log_file
systemctl restart nginx &>> $log_file
echo $?