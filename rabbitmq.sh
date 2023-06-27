script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

rabbitmq_password=$1


if [ -z "${rabbitmq_password}" ]; then
  input rabbitmq password
  exit 1

fi
print_head "yum repo script"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$log_file
    fun_status_check $?

print_head "download app content"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$log_file
    fun_status_check $?

print_head "install mysql"

yum install rabbitmq-server -y &>>$log_file
    fun_status_check $?

print_head "add user"

rabbitmqctl add_user roboshop ${rabbitmq_password} &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
    fun_status_check $?

print_head "start rabbitmq"

systemctl enable rabbitmq-server &>>$log_file
systemctl restart rabbitmq-server &>>$log_file
    fun_status_check $?
