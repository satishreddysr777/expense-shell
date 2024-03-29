source common.sh

component=frontend

Head "Installing Nginx"
dnf install nginx -y &>> $log_file
Status $?

Head "Copying expense config file"
cp expense.conf /etc/nginx/default.d/expense.conf &>> $log_file
Status $?

InitPreScript "/usr/share/nginx/html"

Head "Start Nginx service"
systemctl enable nginx &>> $log_file
systemctl restart nginx &>> $log_file
Status $?