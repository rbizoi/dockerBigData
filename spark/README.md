# Effacement du docker si il à été crée 

>> `docker container rm spark`

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
