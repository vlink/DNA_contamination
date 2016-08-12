#!/usr/bin/perl -w
#Author: Verena Link
#Licence: GPL
#e-mail: vlink@ucsd.edu
use strict;
use Getopt::Long;

if(@ARGV < 2) {
	print STDERR "Usage:\n";
	print STDERR "perl $0 <file with introns> <file with exons> [optional parameters]\n";
	print STDERR "\t-output <output file> [default: STDOUT]\n";
	exit;
}
$_ = () for my(%intron, %exon, %intron_length, %exon_length, @split, @name);
$_ = "" for my($intron_input, $exon_input, $output);
$_ = 0 for my($f);

$intron_input = $ARGV[0];
$exon_input = $ARGV[1];

GetOptions(     "output=s" => \$output)
        or die (&printCMD());

open FH, "<$intron_input" or die "Can't open file: $intron_input\n";
foreach my $line (<FH>) {
	if($f == 0) {
		$f++;
		next;
	}
	chomp $line;
	@split = split('\t', $line);
	@name = split('--', $split[0]);
	$intron{$name[0]} += $split[-1];
	$intron_length{$name[0]} += abs($split[3] - $split[2]);
}
close FH;

open FH, "<$exon_input" or die "Can't open file: $exon_input\n";

$f = 0;
foreach my $line (<FH>) {
	if($f == 0) {
		$f++;
		next;
	}
	chomp $line;
	@split = split('\t', $line);
	@name = split('--', $split[0]);
	$exon{$name[0]} += $split[-1];
	$exon_length{$name[0]} += abs($split[3] - $split[2]);
}
close FH;

if($output ne "") {
	open OUT, ">$output" or die "Can't open file: $output\n";
	print OUT "ID\texons\tlength_exons\tnormalized_exons\tintrons\tlength_introns\tnormalized_introns\n";
} else {
	print "ID\texons\tlength_exons\tnormalized_exons\tintrons\tlength_introns\tnormalized_introns\n";
}

foreach my $gene (sort {$a cmp $b } keys %exon) {
	if($output ne "") {
		print OUT $gene . "\t" . $exon{$gene} . "\t" . $exon_length{$gene} . "\t" . ($exon{$gene}/$exon_length{$gene});
		if(exists $intron{$gene}) {
			print OUT "\t" . $intron{$gene} . "\t" . $intron_length{$gene} . "\t" . ($intron{$gene}/($intron_length{$gene}+1)) . "\n";
			delete $intron{$gene};
		} else {
			print OUT "\t0\t0\t0\n";
		}
	} else {
		print $gene . "\t" . $exon{$gene} . "\t" . $exon_length{$gene} . "\t" . ($exon{$gene}/$exon_length{$gene});
		if(exists $intron{$gene}) {
			print "\t" . $intron{$gene} . "\t" . $intron_length{$gene} . "\t" . ($intron{$gene}/($intron_length{$gene}+1)) . "\n";
			delete $intron{$gene};
		} else {
			print "\t0\t0\t0\n";
		}
	}
	delete $exon{$gene};
}

foreach my $gene (sort {$a cmp $b} keys %intron) {
	if($output ne "") {
		print OUT $gene . "\t0\t0\t" . $intron{$gene} . "\t" . $intron_length{$gene} . "\t" . ($intron{$gene}/($intron_length{$gene}+1)). "\n";
	} else {
		print $gene . "\t0\t0\t" . $intron{$gene} . "\t" . $intron_length{$gene} . "\t" . ($intron{$gene}/($intron_length{$gene}+1)). "\n";
	}
}
if($output ne "") {
	close OUT;
}
