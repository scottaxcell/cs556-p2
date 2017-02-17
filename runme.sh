#!/bin/bash
#

NUM_NODES=500
NUM_EDGES=1000
ERDOS_CSV=erdos.csv
PATIENT_ZERO=100
PROB=0.5

#
# ERDOS
#
#./createGraph.py --graph erdos --nodes ${NUM_NODES} --edges ${NUM_EDGES} --file ${ERDOS_CSV}
#
#./simulateWorm.py --csv ${ERDOS_CSV} --zero ${PATIENT_ZERO} --prob ${PROB}


#NUM_NODES=5000
#NUM_EDGES=5
#BARABASI_CSV=barabasi.csv
#
##
## BARABASI
##
#./createGraph.py --graph barabasi --nodes ${NUM_NODES} --edges ${NUM_EDGES} --file ${BARABASI_CSV}
#
#./simulateWorm.py --csv ${BARABASI_CSV} --zero ${PATIENT_ZERO} --prob ${PROB}


#NUM_NODES=500
#NUM_EDGES=3
#WATTS_CSV=watts.csv
#
##
## WATTS
##
#./createGraph.py --graph watts --nodes ${NUM_NODES} --edges ${NUM_EDGES} --file ${WATTS_CSV}
#
#./simulateWorm.py --csv ${WATTS_CSV} --zero ${PATIENT_ZERO} --prob ${PROB}


NUM_NODES = ( 500 1000 5000 10000 25000 50000 )


exit 0
