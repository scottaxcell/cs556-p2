#!/usr/bin/perl
#
# WORM CURE SIMULATION
#
use strict;

my $numArgs = $#ARGV + 1;
if ($numArgs != 2) {
  print "\nUsage: genCureData.pl erdosFiles.txt erdosCureRuns.log\n";
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
  my $cureProb = 0.5;
  my $cureZero = 1;
  my $totalRounds = 0;
  my @output = ();
  my $graphLine = "";

  push @output, "Graph file: $csvFile\n";
  push @output, "Infection probability: $infectProb\n";
  push @output, "Infection Patient zero: $infectZero\n";
  push @output, "Cure probability: $cureProb\n";
  push @output, "Cure Patient zero: $cureZero\n";
  for (1..$numRuns) { # Run the experiment 10 times
    my $cmd = "python ./simulateWormCure.py --infect_prob $infectProb --infect_zero $infectZero --csv $csvFile --cure_prob $cureProb --cure_zero $cureZero";
    my $stdout = `$cmd`;
    
    my $roundInfo = ""; # store number of infected nodes per round for the simulation
    my $numRounds = 0; # store last round for the simulation
    my @lines = split /\n/, $stdout;
    foreach my $line (@lines) {
      if ($line =~ m/Round (\d+): infected = (\d+), inoculated = (\d+)/) {
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

