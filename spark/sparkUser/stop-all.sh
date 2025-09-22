#!/bin/bash

$SPARK_HOME/sbin/stop-worker.sh
sleep 5
$SPARK_HOME/sbin/stop-master.sh
sleep 5

jps