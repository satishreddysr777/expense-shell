log_file=/tmp/expense.log

Head() {
  echo -e "\e[35m$1\e[0m"
}

InitPreScript() {
  DIR=$1

  Head "Remove existing app folder"
  rm -rf $1 &>> $log_file
  Status $?

  Head "Create application directory"
  mkdir $1 &>> $log_file
  Status $?

  Head "Download application content"
  curl -o /tmp/${component}.zip https://expense-artifacts.s3.amazonaws.com/${component}.zip &>> $log_file
  # shellcheck disable=SC2164
  Status $?

  # shellcheck disable=SC2164
  cd $1

  Head "Extracting application content"
  unzip /tmp/${component}.zip &>> $log_file
  Status $?
}

Status() {
  if [ "$1" -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
    echo ""
  else
    echo -e "\e[31mFAILURE\e[0m"
    exit 1
  fi
}