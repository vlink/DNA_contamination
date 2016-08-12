#!/usr/bin/perl -w
#Author: Verena Link
#Licence: GPL
#e-mail: vlink@ucsd.edu
#Script that removes DNA contamination from the gene counts

use strict;
use Getopt::Long;

if(@ARGV < 1) {
	&printCMD();
}

sub printCMD{
	print STDERR "Usage:\n";
	print STDERR "perl $0 <merge file> [optional parameters]\n";
	print STDERR "\tmerge file: output from merge_intron_and_exon.pl\n";
	print STDERR "\t-output <output file> [default: STDOUT]\n";
	exit;
}

$_ = "" for my($output, $merge_file);
$_ = () for my(@split);
$_ = 0 for my($f, $tag_count, $norm);
$merge_file = $ARGV[0];

GetOptions(     "output=s" => \$output)
        or die (&printCMD());

open FH, "<$merge_file" or die "Can't open file: " . $merge_file . "\n";
if($output ne "") {
	open OUT, ">$output" or die "Can't open file: $output\n";
}

foreach my $line (<FH>) {
	chomp $line;
	if($f == 0) { 
		$f++;
		if($output ne "") { 
			print OUT $line . "\tnormalized_reads\n"; 
		} else { 
			print $line . "\tnormalized_reads\n"; 
		}
		next;
	}
	@split = split("\t", $line);
	if($output ne "") {
		print OUT $line;
		if($split[6] == 0) {
			print OUT "\t" . $split[1] . "\n";
		} else {
			$tag_count = $split[2] * $split[6];
			if($tag_count > $split[1]) {
				print OUT "\t0\n";
			} else {
				$norm = $split[1] - $tag_count;
				print OUT"\t" . $norm . "\n";
			}
		}
	} else {
		print $line;
		if($split[6] == 0) {
			print "\t" . $split[1] . "\n";
		} else {
			$tag_count = $split[2] * $split[6];
			if($tag_count > $split[1]) {
				print "\t0\n";
			} else {
				$norm = $split[1] - $tag_count;
				print "\t" . $norm . "\n";
			}
		}
	}
}
close FH;
if($output ne "") {
	close OUT;
}
