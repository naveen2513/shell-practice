script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[32m>>>>>>>>> copy mongo repo file<<<<<<<\e[0m"

cp /home/centos/shell-practice/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
    fun_status_check $?

echo -e "\e[32m>>>>>>>>> install mongo<<<<<<<\e[0m"

yum install mongodb-org -y &>>$log_file
    fun_status_check $?

echo -e "\e[32m>>>>>>>>> update listen address<<<<<<<\e[0m"

sed -i -e "s|127.0.0.1|0.0.0.0|g" /etc/mongod.conf &>>$log_file
    fun_status_check $?

echo -e "\e[32m>>>>>>>>> restart mongodb<<<<<<<\e[0m"

systemctl enable mongod &>>$log_file

systemctl restart mongod &>>$log_file
    fun_status_check $?
