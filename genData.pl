#!/usr/bin/perl
#
# WORM SIMULATION
#
use strict;

my $numArgs = $#ARGV + 1;
if ($numArgs != 2) {
  print "\nUsage: genData.pl erdosFiles.txt erdosRuns.log\n";
  exit;
}

my $fileListFile = $ARGV[0];
my $logFile = $ARGV[1];
my @csvFiles = ();
open(my $fh, '<', $fileListFile) || die "Cannot open $fileListFile for read\n";
while (my $line = <$fh>) {
  chomp $line;
  push @csvFiles, $line;
}
close($fh);


open(my $fh, '>', $logFile) || die "Cannot open $logFile for write\n";

foreach my $csvFile (@csvFiles) {
  my $numRuns = 10;
  my $infectProb = 0.5;
  my $infectZero = 1;
  my $totalRounds = 0;
  my @output = ();
  my $graphLine = "";

  push @output, "Graph file: $csvFile\n";
  push @output, "Infection probability: $infectProb\n";
  push @output, "Patient zero: $infectZero\n";
  for (1..$numRuns) { # Run the experiment 10 times
    my $cmd = "python ./simulateWorm.py --infect_prob $infectProb --infect_zero $infectZero --csv $csvFile --csvFormat";
    my $stdout = `$cmd`;
    
    my $roundInfo = ""; # store number of infected nodes per round for the simulation
    my $numRounds = 0; # store last round for the simulation
    my @lines = split /\n/, $stdout;
    foreach my $line (@lines) {
      if ($line =~ m/(\d+),(\d+)/) {
        $numRounds = $1;
        $roundInfo .= $2 . ",";
      }
      if ($line =~ m/Generated graph.+/) {
        $graphLine = "\n\n$line"; # store the node and edges information of the graph
      }
    }
    $roundInfo .= "\n";
    push @output, $roundInfo;
    $totalRounds += $numRounds;
  }
  unshift @output, "Average number of rounds: " . ($totalRounds / $numRuns) . "\n";
  unshift @output, $graphLine;
  foreach my $line (@output) {
    print $fh $line;
  }
}

close($fh);
close(0);
