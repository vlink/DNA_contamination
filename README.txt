This set of scripts was written in order to normalize for genomic DNA contamination, which occurred in some low-input RNA-Seq samples due to incomplete DNA removal during RNA isolation (method first published in TBA). Therefore, the average intronic noise per base pair in all intronic regions per gene was calculated. The exonic reads were then normalized by subtracting the background noise per base pair for the complete length of the exonic regions. Genes without introns were not normalized, as these genes are the minority of genes and are typically short.

1. Installation
The only requirement for these scripts are:
	1. Perl
	2. Perl modules: Getopt::Long

2. Usage
For the usage in this readme, HOMER (http://homer.salk.edu/homer/) was used. However, any other program can be used. 
	1. annotate the files all_introns.txt and all_exons.txt with the read density of every experiment independently. Do NOT adjust for sequencing density.
	For HOMER use annotatePeaks <file> -noann -nogene -noadj 
	The output format has to be following:
	ID\tchromosome (chrX)\tstart position\tend position\tstrand\t0\tNA\tread density

	2. Run merge_intron_and_exon.pl <intron file> <exon file>
	This script will merge the read density counted for introns and exons in one file. It then will calculate the coverage of reads per basepair over the length of all introns and all exons per gene

	3. Run remove_contamination.pl <output file from merge_intron_and_exon.pl>
	This scripts calculates the number of reads in exons that are due to cDNA contamination (coverage of read per bp in introns * length of exons)
	If there is no intron, there is no normalization.
	If there are more reads in introns thane xons, the value for this gene is set to 0.

At this point the contamination is removed. There are some other useful little scripts that make it easier to deal with the data

	4. calc_rpkm.pl <output file from remove_contamination.pl>
	This script calculates RPKM per gene, only considering reads in exons. The contamination should have been removed in the previous step.

	5. add_gene_names.pl <input file>
	This script adds gene coordinates and trivial names from the file all_genes.txt to the input file based on the RefSeq ID of the gene.

	6. condense_genes.pl <input file>
	This script condenses all isoforms into one single entry. In cases of genes differently expressed between conditions that have many isoforms, the number of differently expressed genes between the two condiitions can be overestimated by not condensing the data into only one isoform.

	7. merge_norm_files.pl
	This script merges previously normalized experiemnts into one file to do follow up analysis (for example different gene expression analysis)
	The output file can directly be used in HOMER.

Please report bugs or any other comments to vlink@ucsd.edu
