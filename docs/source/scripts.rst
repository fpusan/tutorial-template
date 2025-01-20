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
- 


Step 2: RNA finding
===================

**Script:** *02.run_barrnap.pl*

Files produced
--------------
- 


Step 3: Gene prediction
=======================

**Script:** *03.run_prodigal.pl*

Files produced
--------------
-


Step 4: Homology searching against taxonomic (nr) and functional (COG, KEGG) databases
======================================================================================

**Script:** *04.rundiamond.pl*

Files produced
--------------
-


Step 5: HMM search for Pfam database
====================================

**Script:** *05.run_hmmer.pl*

Files produced
--------------
-


Step 6: Taxonomic assignment
============================

**Script:** *06.lca.pl*

Files produced
--------------
-


Step 7: Functional assignment
=============================

**Script:** *07.fun3assign.pl*

Files produced
--------------
-


Step 8: Blastx on parts of the contigs without gene prediction or without hits
==============================================================================

**Script:** *08.blastx.pl*

Files produced
--------------
-


Step 9: Taxonomic assignment of contigs
=======================================

**Script:** *09.summarycontigs3.pl*

Files produced
--------------
-


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


Step 12: Calculation of the abundance of all functions
======================================================

**Script:** *12.funcover.pl*

Files produced
--------------
-


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


Step 21: Final statistics for the run
=====================================

**Script:** *21.stats.pl*

Files produced
--------------
-


Step 22: Calculation of summary tables for the project
======================================================

**Script:** *sqm2tables.py*

Files produced
--------------
-
