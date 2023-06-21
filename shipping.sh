script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
source ${script_path}/common.sh

mysql_root_password=$1

if [ -z "${mysql_root_password}" ]; then
  input mysql root password missing
  exit 1

fi


fun_java
schema=mysql