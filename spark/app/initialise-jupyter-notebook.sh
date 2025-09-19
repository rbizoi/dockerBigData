jupyter lab --generate-config

sed -i -e "s/# c.ServerApp.ip = 'localhost'/c.ServerApp.ip = '`hostname -f`'/g" /home/spark/.jupyter/jupyter_lab_config.py
sed -i -e "s/# c.ServerApp.port = 0/c.ServerApp.port = 8888/g" /home/spark/.jupyter/jupyter_lab_config.py

cat /home/spark/.jupyter/jupyter_lab_config.py|grep c.ServerApp.ip
cat /home/spark/.jupyter/jupyter_lab_config.py|grep c.ServerApp.port

jupyter server --generate-config
jupyter server password

. /app/donnees/meteoFranceSYNOP/wget_meteo.sh

