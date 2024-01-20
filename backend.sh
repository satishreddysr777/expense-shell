echo -e "\e[35m Disable default version of Nodejs\e[0m"
dnf module disable nodejs -y

echo -e "\e[35m Enable Nodejs 18 version\e[0m"
dnf module enable nodejs:18 -y

echo -e "\e[35m Install Nodejs\e[0m"
dnf install nodejs -y

echo -e "\e[35m Configure backend service\e[0m"
cp backend.service /etc/systemd/system/backend.service

echo -e "\e[35m Adding application user\e[0m"
useradd expense

echo -e "\e[35m Remove existing app folder\e[0m"
rm -rf /app

echo -e "\e[35m Create application directory\e[0m"
mkdir /app

echo -e "\e[35m Download application content\e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip
# shellcheck disable=SC2164
cd /app

echo -e "\e[35m Extracting application content\e[0m"
unzip /tmp/backend.zip

echo -e "\e[35m Downloading application dependencies\e[0m"
npm install

echo -e "\e[35m Reloading SystemD and start backend service\e[0m"
systemctl daemon-reload
systemctl enable backend
systemctl start backend

echo -e "\e[35m Installing mysql client\e[0m"
dnf install mysql -y

echo -e "\e[35m Laoding mysql schema\e[0m"
mysql -h mysql-dev.satishreddy.org -uroot -pExpenseApp@1 < /app/schema/backend.sql
