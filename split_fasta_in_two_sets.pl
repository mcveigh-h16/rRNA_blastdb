#!/usr/bin/perl -w
# the first line of perl code has to be above
#
# Author: Alejandro Schaffer
# Code to split a fasta file into two files such that one file has all sequences with ids in a 
# specified list and the other file has the remaining sequences
# Usage: split_fasta_in_two_sets.pl <input fasta file>  <file of ids to select> <output file of selected> <output file of not selected> 

use strict;
use warnings;

my $input_file; #input fasta file 
my $id_file; #ids to select
my $output_file_selected; #output file of selected queries 
my $exclusion_file; #output file of queries not selected 
my $nextline; #one line of the file
my %selected_queries;
my @query_ids;
my @is_sequence_selected;
my $sequence_index = 1;
my $in_range; #is this sequence selected
my @fields; #for one line of exclusion file;
my $query_id; #id of one query
my $selection_count; #ids of selected sequences
my @sequences_found; #indicates whether the ith selected sequence was found
my $one_index; #index of one selected sequence among all selected sequences
my $s; #loop index

my $usage = "split_fasta_in_two_sets.pl <input fasta file>  <file of ids to select> <output file of selected> <output file of not selected> \n";

$input_file = $ARGV[0];
$id_file = $ARGV[1];
$output_file_selected = $ARGV[2];
$exclusion_file = $ARGV[3];


if (@ARGV != 4) {
    print "The correct number of arguments is 4\n";
    die $usage;
}

open(INPUT, "<$input_file") or die "Cannot open 1 $input_file\n"; 
open(IDS, "<$id_file") or die "Cannot open 2 $id_file\n"; 
open(OUTPUT, ">$output_file_selected") or die "Cannot open 3 $output_file_selected\n"; 
open(EXCLUSIONS, ">$exclusion_file") or die "Cannot open 4 $exclusion_file\n"; 

$selection_count = 1;
while(defined($nextline = <IDS>)) {
    chomp($nextline);
    @fields = split /\t/, $nextline;
    $selected_queries{$fields[0]} = $selection_count;
    $query_ids[$selection_count] = $fields[0];
    $selection_count++;
}
close(IDS);
$selection_count--;

for ($s= 1; $s <= $selection_count; $s++) {
    $sequences_found[$s] = 0;
}

while(defined($nextline = <INPUT>)) {
    chomp($nextline);
    if (($nextline =~m/^>/)) {
        ($query_id) = ($nextline =~m/^>(\S+)/);
	# print "Testing $query_id\n";
	if ($one_index = $selected_queries{$query_id}) {
	    print "Selected $query_id\n";
	    $is_sequence_selected[$sequence_index] = $one_index;
	}
	else {
	    $is_sequence_selected[$sequence_index] = 0;
	}
	$sequence_index++;
    }
}
close(INPUT);

$sequence_index  = 1;
$in_range = 1;
open(INPUT, "<$input_file") or die "Cannot open 5 $input_file\n"; 
while(defined($nextline = <INPUT>)) {
    chomp($nextline);
    if (($nextline =~m/^>/)) {
	if ($one_index = $is_sequence_selected[$sequence_index]) {
	    $in_range = 1;
	    $sequences_found[$one_index] = 1;
	}
	else {
	    $in_range = 0;
	}
	$sequence_index++;
    }
    if ($in_range) {
	print OUTPUT $nextline;
	print OUTPUT "\n";
    }
    else {
	print EXCLUSIONS $nextline;
	print EXCLUSIONS "\n";
    }
}
close (OUTPUT);
close(INPUT);

for ($s = 1; $s <= $selection_count; $s++) {
    if (!($sequences_found[$s])) {
	print STDERR "Could not find sequence with identifier $query_ids[$s]\n";
    }
}
