#!/usr/bin/perl -w
#Author: Verena Link
#Licences: GPL
#e-mail vlink@ucsd.edu

#This script adds gene coordinates from the file all_genes.txt to the input file
use strict;
use Getopt::Long;

if(@ARGV < 1) {
	&printCMD();
}

sub printCMD{
	print STDERR "Usage:\n";
	print STDERR "perl $0 <input file> [optional parameters]\n";
	print STDERR "\t-output <output filename> (default: STDOUT)\n";
	print STDERR "\t-gene-file <path to all_genes.txt> (default: the current working directory)\n";
	print STDERR "\n\n";
	exit;
}

my $input_file = $ARGV[0];
$_ = "" for my($output, $gene, $h);
$_ = () for my(%genes, @split, @name);
$_ = 0 for my ($f);

GetOptions(     "output=s" => \$output,
                "gene-file=s" => \$gene)
        or die (&printCMD());

if($gene eq "") {
	$gene = "all_genes.txt";
}

open FH, "<$gene" or die "Can't open file $gene\n";

foreach my $line (<FH>) {
	chomp $line;
	if($f ==0 ) { $f++; next; }
	@split = split('\t', $line);
	@name = split('\|', $split[7]);
	$genes{$split[0]} = $split[0] . "\t" . $split[1] . "\t" . $split[2] . "\t" . $split[3] . "\t" . $split[4] . "\t" . $split[5] . "\t" . $split[6] . "\t" . $name[0];
}
close FH;

open FH, "<$input_file" or die "Can't open file $input_file\n";
if($output ne "") {
	open OUT, ">$output" or die "Can't open file $output\n";
}
$f = 0;

foreach my $line (<FH>) {
	chomp $line;
	@split = split('\t', $line);
	if($f == 0) { 
		$f++; 
		if($output ne "") {
			print OUT "ID\tchr\tstart\tend\tstrand\tlength\tCopies\tannotation";
			for(my $i = 1; $i < @split; $i++) {
				print OUT "\t" . $split[$i];
			}
			print OUT "\n";	
		} else {
			print "ID\tchr\tstart\tend\tstrand\tlength\tCopies\tannotation";
			for(my $i = 1; $i < @split; $i++) {
				print "\t" . $split[$i];
			}
			print "\n";	

		}
		next; 
	}

	if(!exists $genes{$split[0]}) {
		next;
	}
	if($output ne "") {
		print OUT $genes{$split[0]};
		for(my $i = 1; $i < @split; $i++) {
			print OUT "\t" . $split[$i];
		}
		print OUT "\n";
	} else {
		print $genes{$split[0]};
		for(my $i = 1; $i < @split; $i++) {
			print "\t" . $split[$i];
		}
		print "\n";
	}
}
close FH;
if($output ne "") {
	close OUT;
}
