# Chargement du docker 

>> `git config --global core.autocrlf false`<br>
>> `git clone https://github.com/rbizoi/dockerBigData`<br>
>> `cd dockerBigData\spark`

# Effacement du docker si il à été crée 

>> `docker container rm spark`

# Configuration du fichier Dockerfile

Les variables que vous pouvez modifier dans le fichier **Dockerfile** (seulement si necessaire):
>> `NOM_MACHINE=jupiter.olimp.fr`<br>
>> `ROOT_PASSWORD=coursBigData`<br>
>> `SPARK_PASSWORD=coursBigData`<br>
>> `SPARK_HOME=/opt/spark`<br>
>> `SPARK_USER=spark`<br>
>> `CONDA_HOME=/home/spark/miniconda`<br>
>> `CONDA_DEFAULT_ENV=spark`<br>

# Création de l’image

>> `docker build -t spark .`

# Création du docker  

## *Attention* 

Le nom du **hostname** doit être identique avec la variable **NOM_MACHINE** du **Dockerfile**.<br>
La même remarque pour le ports : 
            **Dockerfile**  `EXPOSE 22 7077 8888 8081 8082 18080 10000`

>> `docker run -it --name spark --hostname jupiter.olimp.fr -p 2222:22 -p 4040:4040 -p 7077:7077 -p 9999:8888 -p 8081:8081 -p 8082:8082 -p 18080:18080 -p 10000:10000 spark`

# Lancement de docker sur votre machine 

>> `docker start -ai spark`

# Dans le docker 

## Lancez jupyter avec un serveur SPARK avec la commande 
>> `pyspark`

## Lancez jupyter sans spark  
>> `jupyter lab`


# Vous avez l’accès à partir de la machine principale avec les URLs suivants
>> Jupyter : http://127.0.0.1:9999/lab<br>
>> Spark Master : http://127.0.0.1:8081<br>
>> Spark Worker : http://127.0.0.1:8081<br>
>> Spark Jobs : http://127.0.0.1:4040/jobs<br>