script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

rabbitmq_password=$1


if [ -z "${rabbitmq_password}" ]; then
  input rabbitmq password
  exit 1

fi
echo -e "\e[32m>>>>>>>>> yum repo script<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$log_file
    fun_status_check $?

echo -e "\e[32m>>>>>>>>> download app content<<<<<<<\e[0m"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$log_file
    fun_status_check $?

echo -e "\e[32m>>>>>>>>> install mysql<<<<<<<\e[0m"

yum install rabbitmq-server -y &>>$log_file
    fun_status_check $?

echo -e "\e[32m>>>>>>>>> add user<<<<\e[0m"

rabbitmqctl add_user roboshop ${rabbitmq_password} &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
    fun_status_check $?

echo -e "\e[32m>>>>>>>>> start rabbitmq<<<<<<<\e[0m"

systemctl enable rabbitmq-server &>>$log_file
systemctl restart rabbitmq-server &>>$log_file
    fun_status_check $?
