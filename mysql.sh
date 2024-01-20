source common.sh
MYSQL_PASSWORD=$1

if [ -z "$MYSQL_PASSWORD" ]; then
  echo -e "\e[31mInput MYSQL_PASSWORD is missing \e[0m"
  exit 1
fi

Head "Disable default version of MySql"
dnf module disable mysql -y &>> $log_file
Status $?

Head "Copying mysql Repo file into yum repos"
cp mysql.repo /etc/yum.repos.d/mysql.repo &>> $log_file
Status $?

Head "Install mysql community server"
dnf install mysql-community-server -y &>> $log_file
Status $?

Head "Enabling mysqlD and start mysql"
systemctl enable mysqld &>> $log_file
systemctl start mysqld &>> $log_file
Status $?

Head "Setting password to mysql"
mysql_secure_installation --set-root-pass "$MYSQL_PASSWORD" &>> $log_file
Status $?