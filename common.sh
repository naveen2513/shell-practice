add_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/roboshop.log


print_head() {
    echo -e "\e[32m>>>>>>>>> $1 <<<<<<<\e[0m"
    echo -e "\e[32m>>>>>>>>> $1 <<<<<<<\e[0m" &>>$log_file


}
fun_status_check() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[34msuccess\e[0m"
  else
    echo -e "\e[34mfailure\e[0m"
    echo "Refer the log file /tmp/roboshop.log for more information"
    exit 1
 fi
}

fun_app_prereq() {
  print_head "add user"
  id ${add_user} &>>$log_file
  if [ $? -eq 1 ]; then
      useradd ${add_user} &>>$log_file
  fi
  fun_status_check $?
  print_head "create directory"
  rm -rf /app &>>$log_file
  mkdir /app &>>$log_file
    fun_status_check $?

  print_head "download app content"

  curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
    fun_status_check $?

  print_head "extract content"

  cd /app
  unzip /tmp/${component}.zip &>>$log_file
    fun_status_check $?

}

fun_nodejs(){

print_head "download node source"

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
  fun_status_check $?

print_head "install nodejs"

yum install nodejs -y &>>$log_file
  fun_status_check $?


fun_app_prereq
print_head "download dependencies"

cd /app &>>$log_file
npm install &>>$log_file
  fun_status_check $?


fun_schema
fun_systemd_setup
}

fun_schema(){
  if [ "${schema}" == "mongo"  ]; then
    print_head "copy mongo repo file"
  
    cp /home/centos/shell-practice/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
        fun_status_check $?

     print_head "install mongo"
    yum install mongodb-org -y

    fun_status_check $?
        print_head" load schema"
  
      mongo --host mongo-dev.naveendevops2.online </app/schema/catalogue.js &>>$log_file
          fun_status_check $?



  
  fi
  if [ "${schema}" == "mysql" ]; then

     print_head "install mysql"

     yum install mysql -y &>>$log_file
         fun_status_check $?

     print_head "load schema"

     mysql -h mysql-dev.naveendevops2.online -uroot -p${my_root_password} < /app/schema/shipping.sql &>>$log_file
         fun_status_check $?


      
  fi
}
fun_systemd_setup() {
  print_head "systemd setup"

  cp /home/centos/shell-practice/${component}.service /etc/systemd/system/${component}.service &>>$log_file
      fun_status_check $?

  print_head "restart mongodb"

  systemctl daemon-reload &>>$log_file
  systemctl enable ${component} &>>$log_file
  systemctl restart ${component} &>>$log_file
      fun_status_check $?

}
fun_java() {
  print_head "install maven"

  yum install maven -y &>>$log_file
      fun_status_check $?

  fun_app_prereq
  print_head "download dependencies"

  cd /app &>>$log_file
  mvn clean package &>>$log_file
  mv target/shipping-1.0.jar ${component}.jar &>>$log_file
      fun_status_check $?

  fun_schema
  fun_systemd_setup
}
fun_python() {

print_head "install python"

yum install python36 gcc python3-devel -y &>>$log_file
    fun_status_check $?

print_head "add user"

fun_app_prereq
print_head "download dependencies"

cd /app
pip3.6 install -r requirements.txt &>>$log_file
    fun_status_check $?

sed -i -e "s|rabbit_pass|rabbitmq_password|g" /home/centos/shell-practice/payment.service &>>$log_file
    fun_status_check $?

fun_systemd_setup
}
