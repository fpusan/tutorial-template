*************************************
Scripts, output files and file format
*************************************

.. note::
    YOU SHOULD BE USING SQM2TABLES OR SQMTOOLS


Step 1: Assembly
================

**Script:** *01.run_assembly.pl*

Files produced
--------------
- ``<project>/results/01.<project>.fasta``: FASTA file containing the contigs resulting from the assembly 
- ``<project>/intermediate/01.<project>.lon``: Length of the contigs
- ``<project>/intermediate/01.<project>.stats``: Some statistics on the assembly (N50, N90, number of reads)

.. note::
  
  The merged/seqmerge modes will also produce a .fasta and a .lon file for each sample)


Step 2: RNA finding
===================

**Script:** *02.run_barrnap.pl*

Files produced
--------------
- ``<project>/results/02.<project>.rnas``: FASTA file containing all rRNAs and tRNAs found in the assembly
- ``<project>/results/02.<project>.16S``: Assignment (RDP classifier) for the 16S rRNAs sequences
- ``<project>/intermediate/02.<project>.maskedrna.fasta``: Fasta file containing the contigs resulting from the assembly, masking the positions where a rRNA/tRNA was found.

Step 3: Gene prediction
=======================

**Script:** *03.run_prodigal.pl*

Files produced
--------------
- ``<project>/results/03.<project>.fna``: Nucleotide sequences for predicted ORF
- ``<project>/results/03.<project>.faa``: Aminoacid sequences for predicted ORF
- ``<project>/results/03.<project>.gff``: Features and position in contigs for each of the predicted genes (this file will be moved to the ``intermediate`` directory if the ``-D`` option is selected)


Step 4: Homology searching against taxonomic (nr) and functional (COG, KEGG) databases
======================================================================================

**Script:** *04.rundiamond.pl*

Files produced
--------------
- ``<project>/intermediate/04.<project>.nr.diamond``: result of the homology search against the nr database
- ``<project>/intermediate/04.<project>.kegg.diamond``: result of the homology search against the KEGG database
- ``<project>/intermediate/04.<project>.eggnog.diamond``: result of the homology search against the eggNOG database
- ``<project>/intermediate/DB_BUILD_DATE``: date at which the SqueezeMeta database was originally created

.. note::

  If additional databases were provided using the ``-optdb`` option, this script will create additional diamond result files for each database

Step 5: HMM search for Pfam database
====================================

**Script:** *05.run_hmmer.pl*

Files produced
--------------
- ``<project>/intermediate/05.<project>.pfam.hmm``: results of the HMM search against the Pfam database


.. _lca script:
Step 6: Taxonomic assignment
============================

**Script:** *06.lca.pl*

Files produced
--------------
- ``<project>/results/06.<project>.fun3.tax.wranks``: taxonomic assignments for each ORF, including taxonomic ranks
- ``<project>/results/06.<project>.fun3.tax.noidfilter.wranks``: same as above, but the assignment is done without considering identity filters (see :ref:`lca`)

.. note::
  These files will be moved to the ``intermediate`` directory if the ``-D`` option is selected

.. _fun3 script:
Step 7: Functional assignment
=============================

**Script:** *07.fun3assign.pl*

Files produced
--------------
- ``<project>/results/07.<project>.fun3.cog``: PFAM functional assignment for each ORF
- ``<project>/results/07.<project>.fun3.kegg``: PFAM functional assignment for each ORF

Format of these files:

- Column 1: Name of the ORF
- Column 2: Best hit assignment
- Column 3: Best average assignment (see :ref:`fun3`)

.. note::
  - These files will be moved to the ``intermediate`` directory if the ``-D`` option is selected
  - If additional databases were provided using the ``-optdb`` option, this script will create additional result files for each database

- ``<project>/results/07.<project>.pfam``: PFAM functional assignment for each ORF

Step 8: Blastx on parts of the contigs without gene prediction or without hits
==============================================================================

**Script:** *08.blastx.pl*

This script will only be executed if the ``-D`` option was selected.

Files produced
--------------

- ``<project>/results/08.<project>.gff``: features and position in contigs for each of the Prodigal and BlastX ORFs
Blastx 
- ``<project>/results/08.<project>.fun3.tax.wranks``: taxonomic assignment for the mix of Prodigal and BlastX ORFs, including taxonomic ranks
- ``<project>/results/08.<project>.fun3.tax.noidfilter.wranks``: same as above, but the assignment is done without considering identity filters (see :ref:`lca`)
- ``<project>/results/08.<project>.fun3.cog``: COG functional assignment for the mix of Prodigal and BlastX ORFs
- ``<project>/results/08.<project>.fun3.kegg``: KEGG functional assignment for the mix of Prodigal and BlastX ORFs 
- ``<project>/intermediate/blastx.fna``: nucleotide sequences for BlastX ORFs 

.. note::
  If additional databases were provided using the ``-optdb`` option, this script will create additional result files for each database

Step 9: Taxonomic assignment of contigs
=======================================

**Script:** *09.summarycontigs3.pl*

Files produced
--------------
-  

.. _mappingstat:
Step 10: Mapping of reads to contigs and calculation of abundance measures
==========================================================================

**Script:** *10.mapsamples.pl*

Files produced
--------------
-


Step 11: Calculation of the abundance of all taxa
=================================================

**Script:** *11.mcount.pl*

Files produced
--------------
-

.. _funcover:
Step 12: Calculation of the abundance of all functions
======================================================

**Script:** *12.funcover.pl*

Files produced
--------------


.. _ORF table:
Step 13: Creation of the ORF table
==================================

**Script:** *13.mergeannot2.pl*

Files produced
--------------
-


Step 14: Binning
================

**Script:** *14.runbinning.pl*

Files produced
--------------
-


Step 15: Merging bins with DAS Tool
===================================

**Script:** *15.dastool.pl*

Files produced
--------------
-


Step 16: Taxonomic assignment of bins
=====================================

**Script:** *16.addtax2.pl*

Files produced
--------------
-


Step 17: Running CheckM2 and optionally GTDB-Tk on bins
=======================================================

**Script:** *17.checkbins.pl*

Files produced
--------------
-


Step 18: Creation of the bin table
==================================

**Script:** *17.getbins.pl*

Files produced
--------------
-


Step 19: Creation of the contig table
=====================================

**Script:** *19.getcontigs.pl*

Files produced
--------------
-


Step 20: Prediction of pathway presence in bins using MinPath
=============================================================

**Script:** *20. minpath.pl*

Files produced
--------------
-

.. _stats:
Step 21: Final statistics for the run
=====================================

**Script:** *21.stats.pl*

Files produced
--------------
-

.. _sqm2tables in pipeline:
Step 22: Calculation of summary tables for the project
======================================================

**Script:** *sqm2tables.py*

Files produced
--------------
-
