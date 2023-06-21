script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[32m>>>>>>>>> install nginx<<<<<<<\e[0m"
yum install nginx -y
    fun_status_check $?

echo -e "\e[32m>>>>>>>>> remove lod app content<<<<<<<\e[0m"

rm -rf /usr/share/nginx/html/*
    fun_status_check $?

echo -e "\e[32m>>>>>>>>> download app cotnent<<<<<<<\e[0m"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
    fun_status_check $?


cd /usr/share/nginx/html  &>>$log_file
echo -e "\e[32m>>>>>>>>> extract app content<<<<<<<\e[0m"

unzip /tmp/frontend.zip &>>$log_file
    fun_status_check $?

echo -e "\e[32m>>>>>>>>> copy roboshop conf file<<<<<<<\e[0m"

cp /home/centos/shell-practice/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
    fun_status_check $?

echo -e "\e[32m>>>>>>>>> restart nginx<<<<<<<\e[0m"


systemctl enable nginx &>>$log_file

systemctl restart nginx &>>$log_file
    fun_status_check $?
