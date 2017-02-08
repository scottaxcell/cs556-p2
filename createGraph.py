#!/usr/bin/python
import sys
import argparse
import networkx as nx

def createWattsStrogatzGraph(numNodes, numEdges):
    #TODO
    #http://networkx.readthedocs.io/en/stable/reference/generated/networkx.generators.random_graphs.watts_strogatz_graph.html?highlight=watts
    return None

def createBarabasiAlbertGraph(numNodes, numEdges):
    #TODO
    #http://networkx.readthedocs.io/en/stable/reference/generated/networkx.generators.random_graphs.barabasi_albert_graph.html?highlight=barabasi
    #barabasi_albert_graph(n, m, seed=None)
    #n = nodes, m = edges
    return None

def createErdosRenyiGraph(numNodes, numEdges):
    #TODO
    #erdos_renyi_graph(n, p, seed=None, directed=False)
    return None


def printGraph(graph):
    #TODO
    return None


def main(args):
    graphType = None
    numNodes = 0
    numEdges = 0
    output = None

    parser = argparse.ArgumentParser(description='Generates and writes a graph to a CSV.')
    parser.add_argument('--graph', dest='graphType', required=True,
                        help='Graph types available: [erdos, barabasi, watts].')
    parser.add_argument('--nodes', dest='numNodes', required=True,
                        help='Number of nodes in graph.')
    parser.add_argument('--edges', dest='numEdges', required=True,
                        help='Nmber of edges in graph.')
    parser.add_argument('--file', dest='output', required=True,
                        help='CSV output file.')
    args = parser.parse_args()

    if graphType == "erdos":
        pass
    elif graphType == "barabasi":
        pass
    elif graphType == "watts":
        pass
    else:
        print "ERROR: cannot create a graph of type '" + str(graphType) + "'"
        exit(1)

        
    return None


if __name__ == "__main__":
    main(sys.argv)
