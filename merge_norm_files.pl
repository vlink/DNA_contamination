#!/usr/bin/perl -w
#Author: Verena Link
#Licence: GPL
#e-mail: vlink@ucsd.edu
#Script to merge the previously normalized experiments into one file to do follow up analysis

use strict;
use Getopt::Long;

sub printCMD {
	print STDERR "This script merges files that are already normalized by DNA contamination\n";
	print STDERR "If the input files are normalized files without RPKM the script will merge the normalized values, otherwise it will merge the RPKM values\n";
	print STDERR "Usage:\n";
	print STDERR "perl $0 -files <list of files> -names <names> [optional parameters]\n";
	print STDERR "\t-files <list of files>: comma or space separated list of files\n";
	print STDERR "\t-names <names>: comma or space separated list to name the files in output file - list has to be the same length as file\n";
	print STDERR "\nOptional paramters:\n";
	print STDERR "\t-output <output file>\n";
	exit;
}

if(@ARGV < 1) {
	&printCMD();
}

$_ = () for my(@files, @names, @split, %save);
$_ = "" for my($output);
$_ = 0 for my($f);

my %convert = map { $_ => 1 } @ARGV;
if(!exists $convert{'-files'} || !exists $convert{'-names'}) {
	&printCMD();
}

GetOptions(	"names=s{,}" => \@names,
		"files=s{,}" => \@files)
	or die(&printCMD());

@names = split(/[\s,]+/,join(',', @names));
@files = split(/[\s,]+/, join(',', @files));

if(@names < @files) {
	print STDERR "Name and file list have different length!\n";
	exit;
}

for(my $i = 0; $i < @files; $i++) {
	chomp $files[$i];
	open FH, "<$files[$i]" or die "Can't open $files[$i]\n";
	$f = 0;
	foreach my $line (<FH>) {
		chomp $line;
		if($f == 0) { $f++; next; }
		@split = split('\t', $line);
		$save{$split[0]}{$names[$i]} = $split[-1];
	}
	close FH;
}

if($output ne "") {
	open OUT, ">$output" or die "Can't open file: $output\n";
	print OUT "ID";
	for(my $i = 0; $i < @names; $i++) {
		print OUT "\t" . $names[$i];
	}
	print OUT "\n";
	foreach my $gene (keys %save) {
		print OUT $gene;
		for(my $i = 0; $i < @names; $i++) {
			print OUT "\t" . $save{$gene}{$names[$i]};
		}
		print OUT "\n";
	}
	close OUT;
} else {
	print "ID";
	for(my $i = 0; $i < @names; $i++) {
		print "\t" . $names[$i];
	}
	print "\n";
	foreach my $gene (keys %save) {
		print $gene;
		for(my $i = 0; $i < @names; $i++) {
			print "\t" . $save{$gene}{$names[$i]};
		}
		print "\n";
	}
}
