script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[32m>>>>>>>>> redis repo file<<<<<<<\e[0m"

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$log_file
    fun_status_check $?

echo -e "\e[32m>>>>>>>>> enable 6.2 redis<<<<<<<\e[0m"

yum module enable redis:remi-6.2 -y &>>$log_file
    fun_status_check $?

echo -e "\e[32m>>>>>>>>> download redis<<<<<<<\e[0m"

yum install redis -y &>>$log_file
    fun_status_check $?

echo -e "\e[32m>>>>>>>>> update listen address<<<<<<<\e[0m"

sed -i -e "s|127.0.0.1|0.0.0.0|g" /etc/redis.conf /etc/redis/redis.conf &>>$log_file
    fun_status_check $?

echo -e "\e[32m>>>>>>>>> restart redis<<<<<<<\e[0m"

systemctl enable redis &>>$log_file
systemctl restart redis &>>$log_file
    fun_status_check $?

