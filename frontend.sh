script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

print_head "install nginx "
yum install nginx -y
    fun_status_check $?

print_head "remove lod app content"

rm -rf /usr/share/nginx/html/*
    fun_status_check $?

print_head "download app cotnent"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
    fun_status_check $?


cd /usr/share/nginx/html  &>>$log_file
print_head "extract app content"

unzip /tmp/frontend.zip &>>$log_file
    fun_status_check $?

print_head "copy roboshop conf file"

cp /home/centos/shell-practice/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
    fun_status_check $?

print_head "restart nginx"


systemctl enable nginx &>>$log_file

systemctl restart nginx &>>$log_file
    fun_status_check $?
