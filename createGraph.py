#!/usr/bin/python
import sys
import argparse
import networkx as nx
import random


def createWattsStrogatzGraph(numNodes, numEdges):
    # TODO
    #http://networkx.readthedocs.io/en/stable/reference/generated/networkx.generators.random_graphs.watts_strogatz_graph.html?highlight=watts
    g = nx.watts_strogatz_graph(numNodes, numNodes, 0.5, seed=random.randint(1, 1000))
    return g


def createBarabasiAlbertGraph(numNodes, numEdges):
    #http://networkx.readthedocs.io/en/stable/reference/generated/networkx.generators.random_graphs.barabasi_albert_graph.html?highlight=barabasi
    #barabasi_albert_graph(n, m, seed=None)
    #n = nodes, m = edges
    g = nx.barabasi_albert_graph(numNodes, numEdges, seed=random.randint(1, 1000))
    return g


def createErdosRenyiGraph(numNodes, numEdges):
    #erdos_renyi_graph(n, p, seed=None, directed=False)
    g = nx.gnm_random_graph(numNodes, numEdges, seed=random.randint(1, 1000))
    return g


def printGraph(graph):
    for edge in graph.edges_iter():
        print edge
    return None


def main(args):
    #
    # Parse arguments
    #
    parser = argparse.ArgumentParser(description='Generates and writes a graph to a CSV.')
    parser.add_argument('--graph', dest='graphType', required=True,
                        help='Graph types available: [erdos, barabasi, watts].')
    parser.add_argument('--nodes', dest='numNodes', required=True, type=int,
                        help='Number of nodes in graph.')
    parser.add_argument('--edges', dest='numEdges', required=True, type=int,
                        help='Nmber of edges in graph.')
    parser.add_argument('--file', dest='output', required=True,
                        help='CSV output file.')
    args = parser.parse_args()

    if args.numNodes < 1:
        print "ERROR: cannot create a graph with <1 node"
        exit(1)
    if args.numEdges < 0:
        print "ERROR: cannot create a graph with <0 edges"
        exit(1)

    #
    # Generate graph
    #
    if args.graphType == "erdos":
        graph = createErdosRenyiGraph(args.numNodes, args.numEdges)
    elif args.graphType == "barabasi":
        graph = createBarabasiAlbertGraph(args.numNodes, args.numEdges)
    elif args.graphType == "watts":
        graph = createWattsStrogatzGraph(args.numNodes, args.numEdges)
    else:
        print "ERROR: cannot create a graph of type '" + str(args.graphType) + "'"
        exit(1)

    print "Generated '" + str(args.graphType) + "' graph with " + str(args.numNodes) + " nodes and " + str(args.numEdges) + " edges"

    #
    # Write graph to CSV output file
    #
    f = open(args.output, 'w')
    for edge in graph.edges_iter():
        f.write(str(edge[0]) + ", " + str(edge[1]) + "\n")
    f.close()
        
    print "Wrote graph to '" + str(args.output) + "'"

    return None


if __name__ == "__main__":
    main(sys.argv)
