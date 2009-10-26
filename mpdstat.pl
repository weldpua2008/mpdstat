#!/usr/bin/perl

use strict;
use warnings;
use Time::Local;

my %links = ();
my %users = ();

print "Session Report\n";
while(<>) {
  if ($_ =~ /Name:/) {
    my @ret = split(/\s+/, $_, 7);
    my $link = $ret[5];
    $links{$link} = $_;
  }
  if ($_ =~ /Link: Shutdown/) {
    # out
    my @ret = split(/\s+/, $_, 7);
    my ($from, $to, $link, $message, $duration);
    ($to, $link, $message) = strftime($_);
    # in
    if (defined $links{$link}) {
      my @ret2 = split(/\s+/, $links{$link}, 7);
      ($from, $link, $message) = strftime($links{$link});
      $duration = $to - $from;
      $message =~ /"(.*)"/;
      $users{$1}[0] += $duration;
      $users{$1}[1]++;
      print "$1\n";
      print "\tduration:", sprint_duration($duration), "\tlink: ", $link, "\n";
      print "\tfrom: $ret2[0] $ret2[1] $ret2[2]\tto: $ret[0] $ret[1] $ret[2]\n";
      delete $links{$link};
    }
  }
}

print "\nActive Session Report\n";
foreach my $key (keys(%links)) {
  my @ret2 = split(/\s+/, $links{$key}, 7);
  my ($from, $link, $message, $duration);
  ($from, $link, $message) = strftime($links{$key});
  $duration = time - $from;
  $message =~ /"(.*)"/;
  print "$1\n";
  print "\tduration:", sprint_duration($duration), "\tlink: ", $link, "\n";
  print "\tfrom: $ret2[0] $ret2[1] $ret2[2]\n";
  $users{$1}[0] += $duration;
  $users{$1}[1]++;
}

print "\nUser Report\n";
foreach my $key (keys(%users)) {
  my $duration = $users{$key}[0];
  printf "%12s: total:%s\t%4dtimes\n", $key, sprint_duration($duration), $users{$key}[1];
}

sub strftime {
  my %month_hash = ("Jan" => 1, "Feb" => 2, "May" => 3, "Apr" => 4, "May" => 5, "Jun" => 6,
	"Jul" => 7, "Aug" => 8, "Sep" => 9, "Oct" => 10, "Nov" => 11, "Dec" => 12);
  my @ret = split(/\s+/, $_[0], 7);
  my $month = $month_hash{$ret[0]};
  my $day = $ret[1];
  my ($hour, $min, $sec) = split(/:/, $ret[2]);
  return (timelocal($sec, $min, $hour, $day, $month - 1, 2009), $ret[5], $ret[6]);
}

sub sprint_duration {
  my $duration = $_[0];
  return sprintf "%2dd %02d:%02d:%02d", $duration / 86400 % 30, $duration / 3600 % 24, $duration / 60 % 60, $duration % 60;
}
