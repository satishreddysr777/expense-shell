source common.sh
MYSQL_PASSWORD=$1

Head "Disable default version of MySql"
dnf module disable mysql -y &>> $log_file
echo -e "\e[32m[Done!]\e[0m"
echo ""

Head "Copying mysql Repo file into yum repos"
cp mysql.repo /etc/yum.repos.d/mysql.repo &>> $log_file
echo -e "\e[32m[Done!]\e[0m"
echo ""

Head "Install mysql community server"
dnf install mysql-community-server -y &>> $log_file
echo -e "\e[32m[Done!]\e[0m"
echo ""

Head "Enabling mysqlD and start mysql"
systemctl enable mysqld &>> $log_file
systemctl start mysqld &>> $log_file
echo -e "\e[32m[Done!]\e[0m"
echo ""

Head "Setting password to mysql"
mysql_secure_installation --set-root-pass "$MYSQL_PASSWORD" &>> $log_file
echo -e "\e[32m[Done!]\e[0m"
echo ""