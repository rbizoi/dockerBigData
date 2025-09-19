jupyter lab --generate-config

sed -i -e "s/# c.ServerApp.ip = 'localhost'/c.ServerApp.ip = '`hostname -f`'/g" /root/.jupyter/jupyter_lab_config.py
sed -i -e "s/# c.ServerApp.port = 0/c.ServerApp.port = 8888/g" /root/.jupyter/jupyter_lab_config.py
sed -i -e "s/# c.ServerApp.allow_root = False/c.ServerApp.allow_root = True/g" /root/.jupyter/jupyter_lab_config.py

cat /root/.jupyter/jupyter_lab_config.py|grep c.ServerApp.ip
cat /root/.jupyter/jupyter_lab_config.py|grep c.ServerApp.port
cat /root/.jupyter/jupyter_lab_config.py|grep c.ServerApp.allow_root

cp donnees/meteoFranceSYNOP/postesSynop.csv donnees

cd /app/donnees/ebrasil
unzip /app/donnees/ebrasil.zip/olist_customers_dataset.zip      
unzip /app/donnees/ebrasil.zip/olist_geolocation_dataset.zip    
unzip /app/donnees/ebrasil.zip/olist_orders_dataset.zip         
unzip /app/donnees/ebrasil.zip/olist_order_items_dataset.zip    
unzip /app/donnees/ebrasil.zip/olist_order_payments_dataset.zip 
unzip /app/donnees/ebrasil.zip/olist_order_reviews_dataset.zip  
unzip /app/donnees/ebrasil.zip/olist_products_dataset.zip       
unzip /app/donnees/ebrasil.zip/olist_sellers_dataset.zip        
cp /app/donnees/ebrasil.zip/product_category_name_translation.csv .

chmod -R 770 /app/donnees/ebrasil
rm -Rf /app/donnees/ebrasil.zip

. /app/donnees/meteoFranceSYNOP/wget_meteo.sh

