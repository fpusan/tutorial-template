Welcome to SqueezeMeta's documentation!
===================================

**SqueezeMeta** is a full automatic pipeline for
metagenomics/metatranscriptomics, covering all steps of the analysis.
SqueezeMeta includes multi-metagenome support allowing the co-assembly
of related metagenomes and the retrieval of individual genomes via
binning procedures. Thus, SqueezeMeta features several unique
characteristics:

1) Co-assembly procedure with read mapping for estimation of the
   abundances of genes in each metagenome
2) Co-assembly of a large number of metagenomes via merging of
   individual metagenomes
3) Includes binning and bin checking, for retrieving individual genomes
4) The results are stored in a database, where they can be easily
   exported and shared, and can be inspected anywhere using a web
   interface.
5) Internal checks for the assembly and binning steps inform about the
   consistency of contigs and bins, allowing to spot potential chimeras.
6) Metatranscriptomic support via mapping of cDNA reads against
   reference metagenomes

SqueezeMeta supports different assembly strategies (co-assembly,
sequential, assembly merging, and sequential-merging) and different
assemblers (see below for details), as well as the analysis of pre-existing
contigs or bins. Check out the doc:`use_cases` section for more information.

SqueezeMeta uses a combination of custom scripts and external
software packages for the different steps of the analysis:

1)  Assembly
2)  RNA prediction and classification
3)  ORF (CDS) prediction
4)  Homology searching against taxonomic and functional databases
5)  Hmmer searching against Pfam database
6)  Taxonomic assignment of genes
7)  Functional assignment of genes (OPTIONAL)
8)  Blastx on parts of the contigs with no gene prediction or no hits
9)  Taxonomic assignment of contigs, and check for taxonomic disparities
10) Coverage and abundance estimation for genes and contigs
11) Estimation of taxa abundances
12) Estimation of function abundances
13) Merging of previous results to obtain the ORF table
14) Binning with different methods
15) Binning integration with DAS tool
16) Taxonomic assignment of bins, and check for taxonomic disparities
17) Checking of bins with CheckM2 (and optionally classify them with
    GTDB-Tk)
18) Merging of previous results to obtain the bin table
19) Merging of previous results to obtain the contig table
20) Prediction of kegg and metacyc patwhays for each bin
21) Final statistics for the run
22) Generation of tables with aggregated taxonomic and functional
    profiles

Detailed information about the different steps of the pipeline can be
found in the doc:`scripts` section.


.. note::

   This project is under active development.

Contents
--------

.. toctree::

   use_cases
   installation
   scripts
