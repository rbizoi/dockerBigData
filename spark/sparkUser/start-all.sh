#!/bin/bash

$SPARK_HOME/sbin/start-master.sh
sleep 10
$SPARK_HOME/sbin/start-worker.sh  spark://`hostname -f`:7077
sleep 10

jps