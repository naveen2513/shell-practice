script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

print_head "copy mongo repo file"

cp /home/centos/shell-practice/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
    fun_status_check $?

print_head "install mongo"

yum install mongodb-org -y &>>$log_file
    fun_status_check $?

print_head "update listen address"

sed -i -e "s|127.0.0.1|0.0.0.0|g" /etc/mongod.conf &>>$log_file
    fun_status_check $?

print_head "restart mongodb "

systemctl enable mongod &>>$log_file

systemctl restart mongod &>>$log_file
    fun_status_check $?
