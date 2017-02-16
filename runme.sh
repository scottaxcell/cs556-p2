#!/bin/bash
#

NUM_NODES=5
NUM_EDGES=10
ERDOS_CSV=erdos.csv
PATIENT_ZERO=1
PROB=0.5

#
# ERDOS
#
./createGraph.py --graph erdos --nodes ${NUM_NODES} --edges ${NUM_EDGES} --file ${ERDOS_CSV}

./simulateWorm.py --csv ${ERDOS_CSV} --zero ${PATIENT_ZERO} --prob ${PROB}




exit 0
