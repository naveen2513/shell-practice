script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

if [ -z "${rabbitmq_password}" ]; then
  input rabbitmq password
  exit 1

fi

component=payment
fun_python

