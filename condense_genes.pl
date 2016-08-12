#!/usr/bin/perl -w
#Author: Verena Link
#Licence: GPL
#e-mail: vlink@ucsd.edu

#Script uses list of genes and condense it to one isoform per gene

use strict;
use Getopt::Long;

if(@ARGV < 1) {
	&printCMD();
}

sub printCMD{
	print STDERR "Usage\n";
	print STDERR "perl $0 <input file> [optinal parameters]\n";
	print STDERR "\t-output <output file> [default: STDOUT]\n";
	print STDERR "\t-condense <file with one isoform per gene> [default: ids_condense.txt in current working directory]\n";
	exit; 
}

my $input = $ARGV[0];
$_ = () for my (%ids, @split);
$_ = "" for my($output, $condense);
$_ = 0 for my($f);

GetOptions(     "output=s" => \$output,
                "condense=s" => \$condense)
        or die (&printCMD());

if($condense eq "") {
	open FH, "<ids_condense.txt" or die "Can't open file: ids_condense.txt\n";
} else {
	open FH, "<$condense" or die "Can't open file: $condense\n";
}

foreach my $line (<FH>) {
	if($f == 0) { $f++; next; }
	chomp $line;
	@split = split('\t', $line);
	$ids{$split[0]} = 1;
}
close FH;


open FH, "<$input";
if($output ne "") {
	open OUT, ">$output";
}

$f = 0;
foreach my $line (<FH>) {
	if($f == 0) {
		if($output ne "") {
			print OUT $line;
		} else {
			print $line;
		}
		$f++;
		next;
	}
	chomp $line;
	@split = split('\t', $line);
	if(exists $ids{$split[0]}) {
		if($output ne "" ) {
			print OUT $line . "\n";
		} else {
			print $line . "\n";
		}
	}
}
close FH;
if($output ne "") {
	close OUT;
}
