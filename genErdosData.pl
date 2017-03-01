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
# ERDOS WORM SIMULATION
#
my @erdosFiles = (
                  "erdos_500.csv",
                  "erdos_600.csv",
                  "erdos_800.csv",
                  "erdos_700.csv",
                  "erdos_900.csv",
                  "erdos_1000.csv",
                  "erdos_1500.csv",
                  "erdos_2000.csv",
                  "erdos_5000.csv",
                  "erdos_10000.csv",
                  "erdos_20000.csv"
                 );

my $erdosLog = "erdosRuns.log";
open(my $fh, '>', $erdosLog);

foreach my $erdosFile (@erdosFiles) {
  # TODO multiple probabilities
  my $infectProb = 0.5;
  # TODO randomize infected zero patient
  my $infectZero = 1;

  my $edgesLine = "";

  if ($erdosFile =~ m/erdos_(\d+).+/) {
    print $fh "\n\nInfection probability: $infectProb\n";
    print $fh "Patient zero: $infectZero\n";
  }
  for (1..10) { # Run the experiment 10 times
    my $cmd = "python ./simulateWorm.py --infect_prob $infectProb --infect_zero $infectZero --csv $erdosFile --csvFormat";
    my $output = `$cmd`;
 
    my @infectedNodesPerRound = (); 
    my @lines = split /\n/, $output;
    foreach my $line (@lines) {
      if ($line =~ m/\d+,(\d+)/) {
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

