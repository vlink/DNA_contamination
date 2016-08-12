#!/usr/bin/perl -w
#Author: Verena Link
#Licences: GPL
#e-mail vlink@ucsd.edu

#Script calculates RPKM values for genes with removed DNA contamination fomr Low Input RNA-Seq

use strict;
use Getopt::Long;

if(@ARGV < 1) {
	&printCMD();
}

sub printCMD{
	print STDERR "Usage:\n";
	print STDERR "perl $0 <input file> [optional parameters]\n";
	print STDERR "\t-output <output filename> (default: STDOUT)\n";
	print STDERR "\n\n";
	exit;
}

$_ = () for my(%save, @split);
$_ = "" for my($input, $output);
$_ = 0 for my($f, $total_reads);
$input = $ARGV[0];

GetOptions(     "output=s" => \$output)
        or die (&printCMD());

if($output ne "") {
	open OUT, ">$output" or die "Can't open file: $output\n";
}	
open FH, "<$input" or die "Can't open file: $input\n";

foreach my $line (<FH>) {
	chomp $line;
	if($f == 0) { 
		$f++;
		if($output ne "") {
			print OUT $line . "\trpkm\n";
		} else { 
			print $line . "\trpkm\n"; 
		}
		next;
	}
	@split = split('\t', $line);
	$save{$split[0]}{'norm'} = $split[7];
	$save{$split[0]}{'length'} = $split[2];
	$save{$split[0]}{'line'} = $line;
	$total_reads += $split[7];  
}
close FH;

my $rpkm;
foreach my $gene (sort {$a cmp $b} keys %save) {
	$rpkm = ($save{$gene}{'norm'}/($save{$gene}{'length'}/1000)/($total_reads/1000000));
	if($output ne "") {
		print OUT $save{$gene}{'line'} . "\t" . $rpkm . "\n";		
	} else {
		print $save{$gene}{'line'} . "\t" . $rpkm . "\n";		
	}
}
close OUT;
