#!/usr/bin/python
#
# Generates a graph and writes the edges to a CSV file
#
import sys
import argparse
import networkx as nx
import random


def createGraph(csv, nodes):
    graph = nx.Graph()
    with open(csv, 'r') as f:
        count = 0
        for l in f:
            count += 1
            edges = l.strip().split(',')
            graph.add_edge(int(edges[0]), int(edges[1]))
            nodes[int(edges[0])] = False
            nodes[int(edges[1])] = False
    numNodes = nx.number_of_nodes(graph)
    numEdges = nx.number_of_edges(graph)
    print "Generated graph with " + str(numNodes) + " nodes and " + str(numEdges) + " edges"
    #print "Read " + str(count) + " lines"
    #print "len(nodes) = " + str(len(nodes))
    return graph


def infectNode(nodes, node):
    if nodes[node] == True:
        print "ERROR: infecting an infected node, node: " + str(node)
    nodes[node] = True
    return None 


def printGraph(graph):
    for edge in graph.edges_iter():
        print edge
    return None


def printNodes(nodes):
    for node, infected in nodes.iteritems():
        print str(node) + " : " + str(infected)
    return None


def getInfectedNodes(nodes):
    infectedNodes = []
    for node, infected in nodes.iteritems():
        if infected == True:
            infectedNodes.append(node)
    return infectedNodes


def getNeighborNodes(graph, node):
    neighbors = []
    for neighbor in nx.all_neighbors(graph, node):
        neighbors.append(neighbor)
    return neighbors


def isNodeInfected(nodes, node):
    return nodes[node]


def canInfectNode(prob):
    return random.random() <= prob


def simulateWorm(graph, nodes, prob):
    round = 0
    while False in nodes.values():
        round += 1
        # Get list of infected nodes
        infectedNodes = getInfectedNodes(nodes)
        print "Round " + str(round) + ": " + str(len(infectedNodes)) + " infected nodes"

        # Get list of adjacent nodes to infected node
        for node in infectedNodes:
            neighborNodes = getNeighborNodes(graph, node)
            #print "Node " + str(node) + " has " + str(len(neighborNodes)) + " neighbors"
            for neighbor in neighborNodes:
                #print "  " + str(neighbor)
                if isNodeInfected(nodes, neighbor) == False:
                    if canInfectNode(prob) == True:
                        infectNode(nodes, neighbor)

    infectedNodes = getInfectedNodes(nodes)
    print "Simulation complete after " + str(round) + " rounds, all " + str(len(infectedNodes)) + " nodes infected"

    return None


def main(args):
    #
    # Parse arguments
    #
    parser = argparse.ArgumentParser(description='Reads a graph from a CSV and runs a worm simulation.')
    parser.add_argument('--csv', dest='csv', required=True,
                        help='CSV input file.')
    parser.add_argument('--prob', dest='prob', required=True, type=float,
                        help='Probability of worm infecting an un-infected node.')
    parser.add_argument('--zero', dest='zeroNode', required=True, type=int,
                        help='Patient zero node with initial infection.')
    args = parser.parse_args()

    #
    # Generate from CSV input
    #
    nodes = {} # { node ID, infected }
    graph = createGraph(args.csv, nodes)
    #printGraph(graph)
    #printNodes(nodes)

    #
    # Infect patient zero node
    #
    print "Infecting patient zero node " + str(args.zeroNode)
    infectNode(nodes, args.zeroNode)
    #printNodes(nodes)

    #
    # Run worm simulation
    #
    simulateWorm(graph, nodes, args.prob)
    #printNodes(nodes)

    return None


if __name__ == "__main__":
    main(sys.argv)
