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

my $erdosLog = "erdosCureRuns.log";
open(my $fh, '>', $erdosLog);

foreach my $erdosFile (@erdosFiles) {
  # TODO multiple probabilities
  my $infectProb = 0.5;
  my $cureProb = 0.5;
  # TODO randomize infected zero patient
  my $infectZero = 1;
  my $cureZero = 10;

  my $edgesLine = "";

  if ($erdosFile =~ m/erdos_(\d+).+/) {
    print $fh "\n\nInfection probability: $infectProb\n";
    print $fh "Patient zero: $infectZero\n";
  }
  for (1..10) { # Run the experiment 10 times
    my $cmd = "python ./simulateWormCure.py --infect_prob $infectProb --infect_zero $infectZero --cure_prob $cureProb --cure_zero $cureZero --csv $erdosFile";
    my $output = `$cmd`;
    #print $output . "\n";
 
    my @infectedNodesPerRound = (); 
    my @lines = split /\n/, $output;
    foreach my $line (@lines) {
       #Round 1: infected = 1, inoculated = 1
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

