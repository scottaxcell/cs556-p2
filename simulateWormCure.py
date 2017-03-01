#!/usr/bin/python
#
# Generates a graph and writes the edges to a CSV file
#
import sys
import argparse
import networkx as nx
import random
from datetime import datetime


class Node:
    def __init__(self, id):
        self.id = id
        self.cured = False
        self.infected = False
    
    def infect(self):
        self.infected = True

    def isInfected(self):
        return self.infected

    def cure(self):
        self.cured = True
        self.infected = False

    def isCured(self):
        return self.cured


def createGraph(csv, nodes):
    graph = nx.Graph()
    with open(csv, 'r') as f:
        count = 0
        for l in f:
            count += 1
            edges = l.strip().split(',')
            graph.add_edge(int(edges[0]), int(edges[1]))
            nodes[int(edges[0])] = Node(int(edges[0]))
            nodes[int(edges[1])] = Node(int(edges[1]))
    numNodes = nx.number_of_nodes(graph)
    numEdges = nx.number_of_edges(graph)
    print "Generated graph with " + str(numNodes) + " nodes and " + str(numEdges) + " edges"
    #print "Read " + str(count) + " lines"
    #print "len(nodes) = " + str(len(nodes))
    return graph


def infectNode(nodes, nodeID):
    if nodes[nodeID].isInfected() == True:
        print "ERROR: infecting an infected node, node: " + str(nodeID)
    nodes[nodeID].infect()
    return None 

def cureNode(nodes, nodeID):
    if nodes[nodeID].isCured() == True:
        print "ERROR: inoculating an inoculated node, node: " + str(nodeID)
    nodes[nodeID].cure()
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
    for nodeID, node in nodes.iteritems():
        if node.isInfected() == True:
            infectedNodes.append(node)
    return infectedNodes


def getCuredNodes(nodes):
    curedNodes = []
    for nodeID, node in nodes.iteritems():
        if node.isCured() == True:
            curedNodes.append(node)
    return curedNodes


def getNeighborNodeIDs(graph, node):
    neighbors = []
    for neighbor in nx.all_neighbors(graph, node.id):
        neighbors.append(neighbor)
    return neighbors


def canInfectNode(node, prob):
    if node.isCured() == True:
        return False
    if node.isInfected() == True:
        return False
    return random.random() <= prob


def canCureNode(node, prob):
    if node.isCured() == True:
        return False
    if node.isInfected() == True:
        return random.random() <= prob
    return False



def simulateWorm(graph, nodes, infectProb, cureProb, csvFormat):
    round = 0
    numInfectedNodes = 1
    #while numInfectedNodes != len(nodes):
    while numInfectedNodes != 0:
        round += 1
        # Get list of infected nodes
        infectedNodes = getInfectedNodes(nodes)
        #if csvFormat == True:
        #    print str(round) + "," + str(len(infectedNodes))
        #else:
        #    print "Round " + str(round) + ": " + str(len(infectedNodes)) + " infected nodes"

        # Get list of cured nodes
        curedNodes = getCuredNodes(nodes)
        if csvFormat == True:
            print str(round) + "," + str(len(curedNodes))
        else:
            print "Round " + str(round) + ": infected = " + str(len(infectedNodes)) + ", inoculated = " + str(len((curedNodes)))

        # Get list of adjacent nodes to infected node
        for node in infectedNodes:
            neighborNodeIDs = getNeighborNodeIDs(graph, node)
            #print "Node " + str(node.id) + " has " + str(len(neighborNodeIDs)) + " neighbors"
            for neighborID in neighborNodeIDs:
                #print "  " + str(neighbor)
                if canInfectNode(nodes[neighborID], infectProb) == True:
                    infectNode(nodes, neighborID)

        # Get list of adjacent nodes to inoculated node
        for node in curedNodes:
            neighborNodeIDs = getNeighborNodeIDs(graph, node)
            #print "Node " + str(node.id) + " has " + str(len(neighborNodeIDs)) + " neighbors"
            for neighborID in neighborNodeIDs:
                #print "  " + str(neighbor)
                if canCureNode(nodes[neighborID], cureProb) == True:
                    cureNode(nodes, neighborID)

        numInfectedNodes = len(getInfectedNodes(nodes))


    infectedNodes = getInfectedNodes(nodes)
    curedNodes = getCuredNodes(nodes)
    if csvFormat == True:
        print str(round+1) + "," + str(len(infectedNodes))
    else:
        print "Round " + str(round+1) + ": infected = " + str(len(infectedNodes)) + ", inoculated = " + str(len((curedNodes)))
        #print "Simulation complete after " + str(round+1) + " rounds"
        #print "Infected nodes: " + str(len(infectedNodes))
        #print "Inoculated nodes: " + str(len(curedNodes))

    return None





def main(args):
    #
    # Seed randomizer
    #
    random.seed(datetime.now())
    #
    # Parse arguments
    #
    parser = argparse.ArgumentParser(description='Reads a graph from a CSV and runs a worm simulation.')
    parser.add_argument('--csv', dest='csv', required=True,
                        help='CSV input file.')

    parser.add_argument('--infect_prob', dest='infect_prob', required=True, type=float,
                        help='Probability of worm infecting an un-infected node.')

    parser.add_argument('--cure_prob', dest='cure_prob', type=float, default=0, required=True,
                        help='Probability of cure inoculating an infected node.')

    parser.add_argument('--infect_zero', dest='infectZero', required=True, type=int,
                        help='Patient zero node with initial infection.')

    parser.add_argument('--cure_zero', dest='cureZero', type=int, default=-1, required=True,
                        help='Patient zero node with initial cure.')

    parser.add_argument('--csvFormat', dest='csvFormat', action='store_true',
                        help='Write round information in a CSV format.')

    args = parser.parse_args()

    #
    # Generate from CSV input
    #
    nodes = {} # Hash of Node objects
    graph = createGraph(args.csv, nodes)
    #printGraph(graph)
    #printNodes(nodes)

    #
    # Infect patient zero node
    #
    print "Infecting patient zero node " + str(args.infectZero)
    infectNode(nodes, args.infectZero)
    if (args.cureZero != -1):
        print "Inoculating patient zero node " + str(args.cureZero)
        cureNode(nodes, args.cureZero)
    #printNodes(nodes)

    #
    # Run worm simulation
    #
    simulateWorm(graph, nodes, args.infect_prob, args.cure_prob, args.csvFormat)
    #printNodes(nodes)

    return None


if __name__ == "__main__":
    main(sys.argv)
