log_file=/tmp/mysql_log.log
MYSQL_PASSWORD=$1

echo -e "\e[35mDisable default version of MySql\e[0m"
dnf module disable mysql -y &>> $log_file
echo [Done!]
echo ""

echo -e "\e[35mCopying mysql Repo file into yum repos\e[0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo &>> $log_file
echo [Done!]
echo ""

echo -e "\e[35mInstall mysql community server\e[0m"
dnf install mysql-community-server -y &>> $log_file
echo [Done!]
echo ""

echo -e "\e[35mEnabling mysqlD and start mysql\e[0m"
systemctl enable mysqld &>> $log_file
systemctl start mysqld &>> $log_file
echo [Done!]
echo ""

echo -e "\e[35mSetting password to mysql\e[0m"
mysql_secure_installation --set-root-pass "$MYSQL_PASSWORD" &>> $log_file
echo [Done!]
echo ""