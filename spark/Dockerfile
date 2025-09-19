# --------------------------------------------------------------------------------------------------------------
# Image de base
# --------------------------------------------------------------------------------------------------------------
FROM ubuntu:22.04

# Variables d'environnement
ENV DEBIAN_FRONTEND=noninteractive
ENV SPARK_VERSION=4.0.1
ENV SPARK_HOME=/opt/spark
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

RUN echo "root:coursBigData" | chpasswd

# --------------------------------------------------------------------------------------------------------------
# Installer dépendances
# --------------------------------------------------------------------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openjdk-17-jdk wget curl python3 python3-pip \
    rsync vim net-tools ca-certificates bzip2 ssh openssh-client openssh-server iputils-ping unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
RUN echo "UserKnownHostsFile=/dev/null" >> /etc/ssh/ssh_config
RUN echo "LogLevel=quiet" >> /etc/ssh/ssh_config

# --------------------------------------------------------------------------------------------------------------
# Installer Spark avec Hadoop support
# --------------------------------------------------------------------------------------------------------------
RUN wget https://downloads.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop3.tgz \
    && tar -xvzf spark-$SPARK_VERSION-bin-hadoop3.tgz -C /opt \
    && mv /opt/spark-$SPARK_VERSION-bin-hadoop3 $SPARK_HOME \
    && rm spark-$SPARK_VERSION-bin-hadoop3.tgz

COPY ./spark-conf/* /opt/spark/conf

#RUN echo "spark.master	spark://`hostname -f`:7077" >> $SPARK_HOME/conf/spark-defaults.conf
#RUN echo "`hostname -f`" > $SPARK_HOME/conf/slaves

# --------------------------------------------------------------------------------------------------------------
# Créer un utilisateur non-root pour Spark
# --------------------------------------------------------------------------------------------------------------
RUN useradd -ms /bin/bash spark \
    && chown -R spark:spark $SPARK_HOME

RUN echo "spark:coursBigData" | chpasswd

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

RUN chmod -R 777 /app
RUN chown -R spark:spark /app
RUN chown -R spark:spark /var/log/spark
RUN chown -R spark:spark /var/run/spark

# --------------------------------------------------------------------------------------------------------------
# Passer à l’utilisateur sparkuser
# --------------------------------------------------------------------------------------------------------------
USER spark
WORKDIR /home/spark

RUN mkdir -p /home/spark/spark_dir/server_eventlogs
RUN mkdir -p /home/spark/spark_dir/server_logs
RUN mkdir -p /home/spark/spark_dir/referentiel-metadonnees

ENV CONDA_DIR=/home/spark/miniconda
# --------------------------------------------------------------------------------------------------------------
# Installer Miniconda
# --------------------------------------------------------------------------------------------------------------
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p $CONDA_DIR && \
    rm /tmp/miniconda.sh \
    && $CONDA_DIR/bin/conda clean -afy
	
ENV PATH=$CONDA_DIR/bin:$PATH

# --------------------------------------------------------------------------------------------------------------
# Créer un environnement conda pour Python
# --------------------------------------------------------------------------------------------------------------
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

RUN conda create -y -n spark -c conda-forge python=3.13 ipython ipython-sql jupyter notebook \
               numpy pandas  matplotlib seaborn plotly portpicker flatbuffers colour \
			   pydot pyyaml folium imgaug imagecodecs pyarrow pyspark==4.0.1 && \
    conda clean -afy
	
ENV CONDA_DEFAULT_ENV=spark
ENV SPARK_HOME=/opt/spark
ENV PYSPARK_PYTHON=/opt/conda/bin/python
ENV PYSPARK_DRIVER_PYTHON=jupyter
ENV PYSPARK_DRIVER_PYTHON_OPTS='lab'
ENV PATH=$SPARK_HOME/bin:$SPARK_HOME/sbin:$CONDA_DIR/envs/spark/bin:$PATH

# --------------------------------------------------------------------------------------------------------------
# Ports exposés
# --------------------------------------------------------------------------------------------------------------
EXPOSE 22 7077 8888 8081 8082 18080 10000

# Définir le dossier de travail
WORKDIR /app


# Commande par défaut pour démarrer un shell PySpark
CMD ["bash"]

# docker container rm spark
# docker build -t spark .
# docker run -it --name spark --hostname minerve.olimp.fr -p 2222:22 -p 4040:4040 -p 7077:7077 -p 8888:8888 -p 8081:8081 -p 8082:8082 -p 18080:18080 -p 10000:10000 spark
# docker start -ai spark
# docker exec -it spark bash

# $SPARK_HOME/sbin/start-all.sh
# $SPARK_HOME/sbin/stop-all.sh
# cat $SPARK_HOME/conf/spark-env.sh
# cat $SPARK_HOME/conf/spark-defaults.conf
# cat $SPARK_HOME/conf/slaves





