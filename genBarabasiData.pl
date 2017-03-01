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
# BARABASI WORM SIMULATION
#
my @barabasiFiles = ( 
                     "barabasi_500_1.csv",
                     "barabasi_500_2.csv",
                     "barabasi_500_3.csv",
                     "barabasi_500_4.csv",
                     "barabasi_500_5.csv",
                     "barabasi_1000_1.csv",
                     "barabasi_1000_2.csv",
                     "barabasi_1000_3.csv",
                     "barabasi_1000_4.csv",
                     "barabasi_1000_5.csv",
                     "barabasi_5000_1.csv",
                     "barabasi_5000_2.csv",
                     "barabasi_5000_3.csv",
                     "barabasi_5000_4.csv",
                     "barabasi_5000_5.csv",
                     "barabasi_10000_1.csv",
                     "barabasi_10000_2.csv",
                     "barabasi_10000_3.csv",
                     "barabasi_10000_4.csv",
                     "barabasi_10000_5.csv",
                     "barabasi_25000_1.csv",
                     "barabasi_25000_2.csv",
                     "barabasi_25000_3.csv",
                     "barabasi_25000_4.csv",
                     "barabasi_25000_5.csv",
                     "barabasi_50000_1.csv",
                     "barabasi_50000_2.csv",
                     "barabasi_50000_3.csv",
                     "barabasi_50000_4.csv",
                     "barabasi_50000_5.csv"
                    );

my $barabasiLog = "barabasiRuns.log";
open(my $fh, '>', $barabasiLog);

foreach my $barabasiFile (@barabasiFiles) {
  # TODO multiple probabilities
  my $infectProb = 0.5;
  # TODO randomize infected zero patient
  my $infectZero = 1;

  my $edgesLine = "";

  if ($barabasiFile =~ m/barabasi_(\d+)_(\d+).+/) {
    print $fh "\n\nNumber of nodes: $1\n";
    print $fh "Number of edge multiples: $2\n";
    print $fh "Infection probability: $infectProb\n";
    print $fh "Patient zero: $infectZero\n";
  }
  for (1..10) { # Run the experiment 10 times
    my $cmd = "python ./simulateWorm.py --infect_prob $infectProb --infect_zero $infectZero --csv $barabasiFile --csvFormat";
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

