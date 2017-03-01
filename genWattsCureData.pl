#!/usr/bin/perl
#
use strict;
use warnings;
use Data::Dumper;

# foreach graph type
#  foreach node/edge combo
#   foreach infect probability
#    simulate worm and capture round/infected node data

#
# WATTS WORM SIMULATION
#
my @wattsFiles = ( 
                  "watts_500_5.csv",
                  "watts_500_6.csv",
                  "watts_500_7.csv",
                  "watts_500_8.csv",
                  "watts_500_9.csv",
                  "watts_500_10.csv",
                  "watts_1000_5.csv",
                  "watts_1000_6.csv",
                  "watts_1000_7.csv",
                  "watts_1000_8.csv",
                  "watts_1000_9.csv",
                  "watts_1000_10.csv",
                  "watts_5000_5.csv",
                  "watts_5000_6.csv",
                  "watts_5000_7.csv",
                  "watts_5000_8.csv",
                  "watts_5000_9.csv",
                  "watts_5000_10.csv",
                  "watts_10000_5.csv",
                  "watts_10000_6.csv",
                  "watts_10000_7.csv",
                  "watts_10000_8.csv",
                  "watts_10000_9.csv",
                  "watts_10000_10.csv",
                  "watts_25000_5.csv",
                  "watts_25000_6.csv",
                  "watts_25000_7.csv",
                  "watts_25000_8.csv",
                  "watts_25000_9.csv",
                  "watts_25000_10.csv",
                  "watts_50000_5.csv",
                  "watts_50000_6.csv",
                  "watts_50000_7.csv",
                  "watts_50000_8.csv",
                  "watts_50000_9.csv",
                  "watts_50000_10.csv"
                 );

my $wattsLog = "wattsCureRuns.log";
open(my $fh, '>', $wattsLog);

foreach my $wattsFile (@wattsFiles) {
  # TODO multiple probabilities
  my $infectProb = 0.5;
  my $cureProb = 0.5;
  # TODO randomize infected zero patient
  my $infectZero = 1;
  my $cureZero = 10;

  my $edgesLine = "";

  if ($wattsFile =~ m/watts_(\d+)_(\d+).+/) {
    print $fh "\n\nNumber of nodes: $1\n";
    print $fh "Number of edge multiples: $2\n";
    print $fh "Infection probability: $infectProb\n";
    print $fh "Patient zero: $infectZero\n";
  }
  for (1..10) { # Run the experiment 10 times
    my $cmd = "python ./simulateWormCure.py --infect_prob $infectProb --infect_zero $infectZero --cure_prob $cureProb --cure_zero $cureZero --csv $wattsFile";
    my $output = `$cmd`;
 
    my @infectedNodesPerRound = (); 
    my @lines = split /\n/, $output;
    foreach my $line (@lines) {
      if ($line =~ m/Round \d+: infected = (\d+), inoculated = (\d+)/) {
        push @infectedNodesPerRound, $1;
      }
      if ($line =~ m/Generated graph.+/) {# with (\d+) nodes and (\d+) edges/) {
        $edgesLine = $line;
      }
    }
    foreach my $numNodes (@infectedNodesPerRound) {
      print $fh "$numNodes,";
    }
    print $fh "\n";
  }
  print $fh "$edgesLine\n";
}

close($fh);

