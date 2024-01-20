echo -e "\e[35mDisable default version of Nodejs\e[0m"
dnf module disable nodejs -y

echo -e "\e[35mEnable Nodejs 18 version\e[0m"
dnf module enable nodejs:18 -y

echo -e "\e[35mInstall Nodejs\e[0m"
dnf install nodejs -y

echo -e "\e[35mConfigure backend service\e[0m"
cp backend.service /etc/systemd/system/backend.service

echo -e "\e[35mAdding application user\e[0m"
useradd expense

echo -e "\e[35mRemove existing app folder\e[0m"
rm -rf /app

echo -e "\e[35mCreate application directory\e[0m"
mkdir /app

echo -e "\e[35mDownload application content\e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip
# shellcheck disable=SC2164
cd /app

echo -e "\e[35mExtracting application content\e[0m"
unzip /tmp/backend.zip

echo -e "\e[35mDownloading application dependencies\e[0m"
npm install

echo -e "\e[35mReloading SystemD and start backend service\e[0m"
systemctl daemon-reload
systemctl enable backend
systemctl start backend

echo -e "\e[35mInstalling mysql client\e[0m"
dnf install mysql -y

echo -e "\e[35mLoading mysql schema\e[0m"
mysql -h mysql-dev.satishreddy.org -uroot -pExpenseApp@1 < /app/schema/backend.sql
