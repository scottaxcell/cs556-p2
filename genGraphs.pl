#!/usr/bin/perl
#
use strict;
use warnings;

# nodes => [ edges, edges, ... ]
#my $graphNodes = [ 500, 1000, 5000, 10000, 25000, 50000 ];
my $graphNodes = [ 500, 600, 700, 800, 900, 1000, 1500, 2000, 5000, 10000 ];
my $graphEdges = [ 2, 3, 4 ];

foreach my $numNodes (@$graphNodes) {
  #print "$numNodes: ";
  #foreach my $edgeMultiple (@$graphEdges) {
    #print "$edgeMultiple ";
    #my $numEdges = $numNodes * $edgeMultiple;
    #my $fileName = "erdos_$numNodes\E_$numEdges.csv";
    my $fileName = "erdos_$numNodes.csv";
    my $cmd = "./createGraph.py --graph erdos --nodes $numNodes --edges 1000 --file $fileName";
    system($cmd);
    print "$cmd\n";
    $cmd = "./simulateWorm.py --csv $fileName --zero 10 --prob 1";
    print "$cmd\n";
    system($cmd);
  #}
  #print "\n";
}

exit 0;
