script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

if [ -z "${mysql_root_password}" ]; then
  input mysql root password missing
  exit 1

fi


echo -e "\e[32m>>>>>>>>> disable mysql<<<<<<<\e[0m"

yum module disable mysql -y &>>$log_file
    fun_status_check $?

echo -e "\e[32m>>>>>>>>> copy mysql repo file<<<<<<<\e[0m"

cp /home/centos/shell-practice/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
    fun_status_check $?

echo -e "\e[32m>>>>>>>>> install mysql<<<<<<<\e[0m"

yum install mysql-community-server -y &>>$log_file
    fun_status_check $?

echo -e "\e[32m>>>>>>>>> set up password<<<<<<<\e[0m"


mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$log_file
    fun_status_check $?

echo -e "\e[32m>>>>>>>>> start mysql<<<<<<<\e[0m"

systemctl enable mysqld &>>$log_file
systemctl restart mysqld &>>$log_file
    fun_status_check $?
