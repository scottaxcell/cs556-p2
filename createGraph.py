#!/usr/bin/python
#
# Generates a graph and writes the edges to a CSV file
#
import sys
import argparse
import networkx as nx
import random


def createWattsStrogatzGraph(numNodes, numEdges):
    # TODO
    #http://networkx.readthedocs.io/en/stable/reference/generated/networkx.generators.random_graphs.watts_strogatz_graph.html?highlight=watts
    g = nx.watts_strogatz_graph(numNodes, numEdges, 0.5, seed=random.randint(1, 1000))
    return g


def createBarabasiAlbertGraph(numNodes, numEdges):
    #http://networkx.readthedocs.io/en/stable/reference/generated/networkx.generators.random_graphs.barabasi_albert_graph.html?highlight=barabasi
    #barabasi_albert_graph(n, m, seed=None)
    #n = nodes, m = edges
    #Will give you a scale free network(barabasi_albert_graph) with 50
    #nodes where each node is connected to three vertices(k=3) with
    #probability proportional to the degree of the vertex.
    g = nx.barabasi_albert_graph(numNodes, numEdges, seed=random.randint(1, 1000))
    return g


def createErdosRenyiGraph(numNodes, numEdges):
    #erdos_renyi_graph(n, p, seed=None, directed=False)
    return nx.erdos_renyi_graph(numNodes, 0.01, seed=random.randint(1, 1000))
    #return nx.gnm_random_graph(numNodes, numEdges, seed=random.randint(1, 1000), True)

    #createGraph = True
    #while createGraph == True:
    #    createGraph = False
    #    graph = nx.gnm_random_graph(numNodes, numEdges, seed=random.randint(1, 1000))
    #    for node in graph.nodes_iter():
    #        numNeighbors = 0
    #        for neighbor in nx.all_neighbors(graph, node):
    #            numNeighbors += 1
    #        if numNeighbors == 0:
    #            print "WARNING: " + str(node) + " in graph has no neighbors!"
    #            createGraph = True
    #return graph


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

    numNodes = nx.number_of_nodes(graph)
    numEdges = nx.number_of_edges(graph)
    print "Generated '" + str(args.graphType) + "' graph with " + str(numNodes) + " nodes and " + str(numEdges) + " edges"

    #for node in graph.nodes_iter():
    #    #neighbors = nx.all_neighbors(graph, node)
    #    numNeighbors = 0
    #    for neighbor in nx.all_neighbors(graph, node):
    #        numNeighbors += 1
    #    if numNeighbors == 0:
    #        print "WARNING: " + str(node) + " in graph has a no neighbors!"

    #
    # Write graph to CSV output file
    #
    f = open(args.output, 'w')
    for edge in graph.edges_iter():
        f.write(str(edge[0]) + "," + str(edge[1]) + "\n")
    f.close()
        
    print "Wrote graph to '" + str(args.output) + "'"

    return None


if __name__ == "__main__":
    main(sys.argv)
