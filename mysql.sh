script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

if [ -z "${mysql_root_password}" ]; then
  input mysql root password missing
  exit 1

fi


print_head "disable mysql "

yum module disable mysql -y &>>$log_file
    fun_status_check $?

print_head "copy mysql repo file "

cp /home/centos/shell-practice/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
    fun_status_check $?

print_head "install mysql"

yum install mysql-community-server -y &>>$log_file
    fun_status_check $?

print_head "set up password"


mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$log_file
    fun_status_check $?

print_head "start mysql"

systemctl enable mysqld &>>$log_file
systemctl restart mysqld &>>$log_file
    fun_status_check $?
