# --------------------------------------------------------------------------------------------------------------
# Image de base
# --------------------------------------------------------------------------------------------------------------
FROM ubuntu:22.04

# --------------------------------------------------------------------------------------------------------------
# Variables d'environnement
# --------------------------------------------------------------------------------------------------------------
ENV NOM_MACHINE=jupiter.olimp.fr
ENV DEBIAN_FRONTEND=noninteractive
ENV ROOT_PASSWORD=coursBigData
ENV SPARK_PASSWORD=coursBigData
ENV SPARK_VERSION=4.0.1
ENV HADOOP_VERSION=3
ENV PYTHON_VERSION=3.13
ENV SPARK_HOME=/opt/spark
ENV SPARK_USER=spark
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV M3_HOME=/usr/share/maven
ENV MAVEN_HOME=/usr/share/maven
ENV MAVEN_OPTS="-Xmx4g -XX:ReservedCodeCacheSize=2g"
ENV PATH=$M3_HOME/bin:$JAVA_HOME/bin:$PATH

RUN echo "root:$ROOT_PASSWORD" | chpasswd

# --------------------------------------------------------------------------------------------------------------
# Installer dépendances
# --------------------------------------------------------------------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openjdk-17-jdk maven wget curl python3 python3-pip supervisor tree \
    rsync vim net-tools ca-certificates bzip2 ssh openssh-client openssh-server iputils-ping unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
RUN echo "UserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config
RUN echo "LogLevel=quiet" >> /etc/ssh/ssh_config

# --------------------------------------------------------------------------------------------------------------
# Installer Spark avec Hadoop support
# --------------------------------------------------------------------------------------------------------------
RUN wget https://downloads.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz \
    && tar -xvzf spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz -C /opt \
    && mv /opt/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION $SPARK_HOME \
    && rm spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz

COPY ./spark-conf/* /opt/spark/conf

RUN echo "spark.master                    spark://$NOM_MACHINE:7077"                                  >> $SPARK_HOME/conf/spark-defaults.conf
RUN echo "spark.eventLog.dir              file:///home/$SPARK_USER/spark_dir/server_eventlogs"        >> $SPARK_HOME/conf/spark-defaults.conf
RUN echo "spark.history.fs.logDirectory   file:///home/$SPARK_USER/spark_dir/server_logs"             >> $SPARK_HOME/conf/spark-defaults.conf
RUN echo "spark.sql.warehouse.dir         file:///home/$SPARK_USER/spark_dir/referentiel-metadonnees" >> $SPARK_HOME/conf/spark-defaults.conf

RUN echo "$NOM_MACHINE"                   > $SPARK_HOME/conf/slaves

# --------------------------------------------------------------------------------------------------------------
# Créer un utilisateur non-root pour Spark
# --------------------------------------------------------------------------------------------------------------
RUN useradd -ms /bin/bash $SPARK_USER \
    && chown -R $SPARK_USER:$SPARK_USER $SPARK_HOME

RUN echo "$SPARK_USER:$SPARK_PASSWORD" | chpasswd

# --------------------------------------------------------------------------------------------------------------
# Copier les donnees 
# --------------------------------------------------------------------------------------------------------------
RUN mkdir -p /var/log/spark
RUN mkdir -p /var/run/spark

RUN mkdir -p /app/donnees/ebrasil.zip 
RUN mkdir -p /app/donnees/ebrasil
RUN mkdir -p /app/donnees/meteoFranceSYNOP
RUN mkdir -p /app/donnees/meteo

RUN mkdir -p /app/sparkNotebooks

COPY ./app/donnees/ebrasil.zip/*.zip /app/donnees/ebrasil.zip 

RUN unzip /app/donnees/ebrasil.zip/olist_customers_dataset.zip      -d  /app/donnees/ebrasil 
RUN unzip /app/donnees/ebrasil.zip/olist_geolocation_dataset.zip    -d  /app/donnees/ebrasil 
RUN unzip /app/donnees/ebrasil.zip/olist_orders_dataset.zip         -d  /app/donnees/ebrasil 
RUN unzip /app/donnees/ebrasil.zip/olist_order_items_dataset.zip    -d  /app/donnees/ebrasil 
RUN unzip /app/donnees/ebrasil.zip/olist_order_payments_dataset.zip -d  /app/donnees/ebrasil 
RUN unzip /app/donnees/ebrasil.zip/olist_order_reviews_dataset.zip  -d  /app/donnees/ebrasil 
RUN unzip /app/donnees/ebrasil.zip/olist_products_dataset.zip       -d  /app/donnees/ebrasil 
RUN unzip /app/donnees/ebrasil.zip/olist_sellers_dataset.zip        -d  /app/donnees/ebrasil 
COPY ./app/donnees/ebrasil.zip/*.csv /app/donnees/ebrasil

RUN chmod -R 770 /app/donnees/ebrasil
RUN rm -Rf /app/donnees/ebrasil.zip

COPY ./app/donnees/meteoFranceSYNOP/* /app/donnees/meteoFranceSYNOP
COPY ./app/donnees/meteoFranceSYNOP/postesSynop.csv /app/donnees
COPY ./app/sparkNotebooks/*  /app/sparkNotebooks

COPY ./app/* /app
COPY ./jupyter/* /app

COPY ./sparkUser/start-all.sh         /home/$SPARK_USER
COPY ./sparkUser/stop-all.sh          /home/$SPARK_USER
									  
RUN chmod 777 /home/$SPARK_USER/*-all.sh
RUN chown $SPARK_USER:$SPARK_USER /home/$SPARK_USER/*-all.sh

RUN chmod -R 777 /app
RUN chown -R $SPARK_USER:$SPARK_USER /app
RUN chown -R $SPARK_USER:$SPARK_USER /var/log/spark
RUN chown -R $SPARK_USER:$SPARK_USER /var/run/spark

# --------------------------------------------------------------------------------------------------------------
# Passer à l’utilisateur sparkuser
# --------------------------------------------------------------------------------------------------------------
USER $SPARK_USER
WORKDIR /home/$SPARK_USER

RUN mkdir -p /home/$SPARK_USER/spark_dir/server_eventlogs
RUN mkdir -p /home/$SPARK_USER/spark_dir/server_logs
RUN mkdir -p /home/$SPARK_USER/spark_dir/referentiel-metadonnees

ENV CONDA_HOME=/home/spark/miniconda
# --------------------------------------------------------------------------------------------------------------
# Installer Miniconda
# --------------------------------------------------------------------------------------------------------------
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p $CONDA_HOME && \
    rm /tmp/miniconda.sh \
    && $CONDA_HOME/bin/conda clean -afy
	
ENV PATH=$CONDA_HOME/bin:$PATH

# --------------------------------------------------------------------------------------------------------------
# Créer un environnement conda pour Python
# --------------------------------------------------------------------------------------------------------------
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

ENV CONDA_DEFAULT_ENV=spark

RUN conda create -y -n $CONDA_DEFAULT_ENV -c conda-forge python=$PYTHON_VERSION ipython ipython-sql jupyter notebook \
               numpy pandas  matplotlib seaborn plotly portpicker flatbuffers colour \
			   pydot pyyaml folium imgaug imagecodecs pyarrow pyspark==$SPARK_VERSION && \
    conda clean -afy
	
ENV SPARK_HOME=$SPARK_HOME
ENV PYSPARK_PYTHON=$CONDA_HOME/envs/$CONDA_DEFAULT_ENV/bin/python
ENV PYSPARK_DRIVER_PYTHON=jupyter
ENV PYSPARK_DRIVER_PYTHON_OPTS='lab'
ENV PATH=$SPARK_HOME/bin:$SPARK_HOME/sbin:$CONDA_HOME/envs/$CONDA_DEFAULT_ENV/bin:$PATH

RUN jupyter lab --generate-config
RUN jupyter server --generate-config
RUN python /app/init_serveur.py
RUN rm /app/init_serveur.py

RUN echo "ROOT_PASSWORD=$ROOT_PASSWORD" >> /app/mot.de.passe.txt
RUN echo "SPARK_PASSWORD=$SPARK_PASSWORD" >> /app/mot.de.passe.txt

RUN echo "$SPARK_HOME/sbin/start-master.sh"                            >> /home/$SPARK_USER/.bashrc
RUN echo "sleep 5"                                                     >> /home/$SPARK_USER/.bashrc
RUN echo "$SPARK_HOME/sbin/start-worker.sh  spark://$NOM_MACHINE:7077" >> /home/$SPARK_USER/.bashrc
RUN echo "jps"                                                         >> /home/$SPARK_USER/.bashrc

# --------------------------------------------------------------------------------------------------------------
# Ports exposés
# --------------------------------------------------------------------------------------------------------------
EXPOSE 22 7077 8888 8081 8082 18080 10000

# Définir le dossier de travail
WORKDIR /app

# Commande par défaut pour démarrer un shell PySpark
CMD ["bash"]