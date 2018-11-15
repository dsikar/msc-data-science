# -*- coding: utf-8 -*-
"""
Created on Mon Nov 17 12:43:08 2014

@author: sbbk529
"""

#import os
#import urllib
#import xml.etree.ElementTree as ET
#feed = urllib.request.urlopen("http://feeds.bbci.co.uk/news/world/rss.xml?edition=uk")

import networkx as nx
import numpy as np
import matplotlib.pyplot as plt

############## Solution for first part ################
#
G=nx.Graph()

G.add_nodes_from(["A", "B", "C", "D", "E", "F", "G", "H"])
G.add_edges_from([('A','B'),('A','C'),('B','C'),('C','E'),('C','D'),('D','F'),('F','G'),('F','H')])

betweenValues = nx.betweenness_centrality(G)
print("Without weights: ", betweenValues)

G1=nx.Graph()

G1.add_nodes_from(["A", "B", "C", "D", "E", "F", "G", "H"])

G1.add_weighted_edges_from([('A','B',3.0),('A','C', 2.0),('B','C', 1.0),('C','E', 10.0),('C','D', 10.0),('D','F', 100.0),('F','G', 20.0),('F','H', 7.0)])

betweenValues = nx.betweenness_centrality(G1, weight = 'weight')
print("With weights: ", betweenValues)

# Due to the drawing routines of networkX, we need to draw the labels and the nodes separately.
# first, layout the graph and save the positions.
position = nx.spring_layout(G)
# now we will use these positions to draw the graph and then the labels
nx.draw(G,pos=position)
nx.draw_networkx_labels(G,pos=position)
plt.draw() 

############## Solution for second part ################
G2=nx.read_graphml("netScience.graphml")

plt.figure(2)
position = nx.spring_layout(G2)
nx.draw(G2,pos=position)
nx.draw_networkx_labels(G2,pos=position)
plt.draw() 
# But maybe rendering the labels wasn't a very good idea ?? See how cluttered it became.

connectedComp = nx.connected_components(G2)
connectedComp = list(connectedComp)
countComp = len(connectedComp)
print ("This graph has ", countComp, " many connected components")

# It is already sorted but just to make sure, we get the largest component
compLengths = []
for i in range(0, countComp):
    compLengths.append(len(connectedComp[i]))

highestIndex = np.argmax(compLengths)
componentGraphs = list(nx.connected_component_subgraphs(G2))
largestComponent = componentGraphs[highestIndex]
# This is a subgraph with 379 nodes and 914 edges

#nx.draw(largestComponent)
#plt.draw() 

betweenValues = nx.betweenness_centrality(largestComponent)

# betweenValues is a dictionary, let's get the values and keys in separate lists
values = list(betweenValues.values())
keys = list(betweenValues.keys())

# find the index of the node with highest betweeness centrality
highestIndex = np.argmax(values)
print("The node id ", keys[highestIndex], " has the centrality degree of ", values[highestIndex])

# and let's print this central node's label (we need to look at the graphml for the names of the attribute fields)
print (largestComponent.node[str(keys[highestIndex])]['label'])

overallAverage = []
# now on to looking at clustering coefficients
for i in range(0, countComp):
    clustCoeff = nx.clustering( componentGraphs[i])
    coeffVals = list(clustCoeff.values())
    overallAverage.append(np.average(coeffVals))
    print ("Component: ", i, " Size of the component: ", len(componentGraphs[i].nodes()),  " coefficient: ", np.average(coeffVals))

print ("Average clustering coefficent is: ", np.average(overallAverage))

# Component 4 with a coefficient of 0.9872 and a size of 21 draws our attention
plt.figure(3)
position = nx.spring_layout(componentGraphs[4])
nx.draw(componentGraphs[4],pos=position)
nx.draw_networkx_labels(componentGraphs[4],pos=position)
plt.draw() 

