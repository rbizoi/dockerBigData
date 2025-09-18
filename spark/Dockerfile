# --------------------------------------------------------------------------------------------------------------
# Image de base
# --------------------------------------------------------------------------------------------------------------
FROM ubuntu:22.04

# Variables d'environnement
ENV DEBIAN_FRONTEND=noninteractive
ENV SPARK_VERSION=4.0.1
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

# --------------------------------------------------------------------------------------------------------------
# Installer dépendances
# --------------------------------------------------------------------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openjdk-17-jdk wget curl python3 python3-pip \
    rsync vim net-tools openssh-client iputils-ping unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# --------------------------------------------------------------------------------------------------------------
# Installer Miniconda
# --------------------------------------------------------------------------------------------------------------
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh
ENV PATH=/opt/conda/bin:$PATH

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
ENV PATH=$SPARK_HOME/bin:$SPARK_HOME/sbin:/opt/conda/envs/spark/bin:$PATH

# --------------------------------------------------------------------------------------------------------------
# Installer Spark avec Hadoop support
# --------------------------------------------------------------------------------------------------------------
RUN wget https://downloads.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop3.tgz \
    && tar -xvzf spark-$SPARK_VERSION-bin-hadoop3.tgz -C /opt \
    && mv /opt/spark-$SPARK_VERSION-bin-hadoop3 /opt/spark \
    && rm spark-$SPARK_VERSION-bin-hadoop3.tgz

COPY ./spark-conf/* /opt/spark/conf

RUN mkdir -p /spark_dir/server_eventlogs
RUN mkdir -p /spark_dir/server_logs
RUN mkdir -p /spark_dir/referentiel-metadonnees
RUN mkdir -p /var/log/spark
RUN mkdir -p /var/run/spark

RUN mkdir -p /app/donnees/ebrasil.zip 
RUN mkdir -p /app/donnees/ebrasil
RUN mkdir -p /app/donnees/meteoFranceSYNOP
RUN mkdir -p /app/donnees/meteo

RUN mkdir -p /app/sparkNotebooks

COPY ./app/initialise-jupyter-notebook.sh /app

RUN chmod 770 /app/initialise-jupyter-notebook.sh
#RUN /root/initialise-jupyter-notebook.sh

# --------------------------------------------------------------------------------------------------------------
# Ports exposés
# --------------------------------------------------------------------------------------------------------------
EXPOSE 22 7077 8888 8081 8082 18080 10000

# Définir le dossier de travail
WORKDIR /app

# Copier le code si besoin
COPY ./app/donnees/ebrasil.zip/* /app/donnees/ebrasil.zip 
COPY ./app/donnees/meteoFranceSYNOP/* /app/donnees/meteoFranceSYNOP
COPY ./app/sparkNotebooks/*  /app/sparkNotebooks
RUN chmod -R 770 /app

# Commande par défaut pour démarrer un shell PySpark
CMD ["bash"]

# docker build -t spark .
# docker run -it --name spark --hostname minerve.olimp.fr -p 22:22 -p 7077:7077 -p 8888:8888 -p 8081:8081 -p 8082:8082 -p 18080:18080 -p 10000:10000 spark
# docker start -ai spark
# docker exec -it spark bash
