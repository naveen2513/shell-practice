script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

print_head "redis repo file"

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$log_file
    fun_status_check $?

print_head "enable 6.2 redis "

yum module enable redis:remi-6.2 -y &>>$log_file
    fun_status_check $?

print_head "download redis "

yum install redis -y &>>$log_file
    fun_status_check $?

print_head "update listen address"

sed -i -e "s|127.0.0.1|0.0.0.0|g" /etc/redis.conf /etc/redis/redis.conf &>>$log_file
    fun_status_check $?

print_head "restart redis"

systemctl enable redis &>>$log_file
systemctl restart redis &>>$log_file
    fun_status_check $?

