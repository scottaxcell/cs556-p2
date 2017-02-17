#!/usr/bin/perl
#
use strict;
use warnings;

#
# ERDOS
#
#{
#  # nodes => [ edges, edges, ... ]
#  my $graphNodes = [ 500, 600, 700, 800, 900, 1000, 1500, 2000, 5000, 10000 ];
#  my $graphType = "erdos";
#  
#  foreach my $numNodes (@$graphNodes) {
#    my $fileName = "$graphType\E_$numNodes.csv";
#    my $cmd = "./createGraph.py --graph $graphType --nodes $numNodes --edges 10 --file $fileName";
#    system($cmd);
#    print "$cmd\n";
#    $cmd = "./simulateWorm.py --csv $fileName --zero 10 --prob 1";
#    print "$cmd\n";
#    system($cmd);
#  }
#}

#
# BARABASI
#
#{
#  # nodes => [ edges, edges, ... ]
#  my $graphNodes = [ 500, 1000, 5000, 10000, 25000, 50000 ];
#  my $graphEdges = [ 1, 2, 3, 4, 5 ];
#  my $graphType = "barabasi";
#  
#  foreach my $numNodes (@$graphNodes) {
#    foreach my $edgeMultiple (@$graphEdges) {
#      my $numEdges = $edgeMultiple; # barabasi
#      my $fileName = "$graphType\E_$numNodes\E_$numEdges.csv";
#      my $cmd = "./createGraph.py --graph $graphType --nodes $numNodes --edges $numEdges --file $fileName";
#      system($cmd);
#      print "$cmd\n";
#      $cmd = "./simulateWorm.py --csv $fileName --zero 10 --prob 1";
#      print "$cmd\n";
#      system($cmd);
#    }
#  }
#}

#
# WATTS
#
{
  # nodes => [ edges, edges, ... ]
  my $graphNodes = [ 500, 1000, 5000, 10000, 25000, 50000 ];
  my $graphEdges = [ 5, 6, 7, 8, 9, 10 ];
  my $graphType = "watts";
  
  foreach my $numNodes (@$graphNodes) {
    foreach my $edgeMultiple (@$graphEdges) {
      my $numEdges = $edgeMultiple; # barabasi
      my $fileName = "$graphType\E_$numNodes\E_$numEdges.csv";
      my $cmd = "./createGraph.py --graph $graphType --nodes $numNodes --edges $numEdges --file $fileName";
      system($cmd);
      print "$cmd\n";
      $cmd = "./simulateWorm.py --csv $fileName --zero 10 --prob 1";
      print "$cmd\n";
      system($cmd);
    }
  }
}

exit 0;
