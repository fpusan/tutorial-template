**********************
The SQMtools R package
**********************

This package provides an easy way to expose the different results of SqueezeMeta (orfs, contigs, bins, taxonomy, functions…) into R, as well as a set of utility functions to filter and display SqueezeMeta results.

.. note::
  The documentation below aims to describe the philosophy, usage, and internals of the SQMtools package. For detailed (albeit maybe a bit outdated) usage examples see also the `wiki entry <https://github.com/jtamames/SqueezeMeta/wiki/Using-R-to-analyze-your-SQM-results>`_.

Design philosophy
=================

SQMtools aims to simplify the analysis of complex metagenomic 

see :doc:`SQMtools/loadSQM`

One or more SqueezeMeta projects can be r
Once SqueezeMeta has finished running, just go into R and load the project.
library(SQMtools)
project = loadSQM(“<project_directory>”)

This will also work with a zip file produced by sqm2zip.py.
project = loadSQM(“<project.zip>”)

.. figure:: ../resources/Figure_1_SQMtools.svg
  :alt: Structure of the SQM R object

  Structure of the SQM R object. If external databases for functional classification were provided to SqueezeMeta via the *-extdb* argument, the corresponding abundance (reads and bases), tpm and copy number profiles will be present in *SQM$functions* (e.g. results for the CAZy database would be present in *SQM$functions$CAZy*. Additionally, the extended names of the features present in the external database will be present in *SQM$misc* (e.g. *SQM$misc$CAZy_names*). The SQMlite object will have a similar structure, but will lack the *SQM$orfs*, *SQM$contigs* and *SQM$bins* section. Additionally, if the results come from a *sqm_reads.pl* or *sqm_longreads.pl* run, the SQMlite object will also be missing TPM, bases and copy numbers for the different functional classification methods.

Loading data into SQMtools
==========================

The SQM object structure
------------------------

The resulting SQM object contains all the relevant information, organized in nested an R lists (see next figure). For example, a matrix with the taxonomic composition of the different samples at the phylum level in percentages can be obtained with ``project$taxa$phylum$percent`` while a matrix with the average copy number per genome of the different PFAMs across samples can be obtained with ``project$functions$PFAM$copy_number``.

.. figure:: ../resources/Figure_2_SQMtools.svg
  :alt: Structure of the SQM R object

  Structure of the SQM R object. If external databases for functional classification were provided to SqueezeMeta via the *-extdb* argument, the corresponding abundance (reads and bases), tpm and copy number profiles will be present in *SQM$functions* (e.g. results for the CAZy database would be present in *SQM$functions$CAZy*. Additionally, the extended names of the features present in the external database will be present in *SQM$misc* (e.g. *SQM$misc$CAZy_names*). The SQMlite object will have a similar structure, but will lack the *SQM$orfs*, *SQM$contigs* and *SQM$bins* section. Additionally, if the results come from a *sqm_reads.pl* or *sqm_longreads.pl* run, the SQMlite object will also be missing TPM, bases and copy numbers for the different functional classification methods.

Creating subsets of your data
=============================

Data renormalization on subsetting
----------------------------------

TABLE WITH THE RECALCULATE STUFF
Creating plots and exporting data
=================================

Working with bins
=================

Data normalization strategies
=============================

List of functions and detailed documentation
============================================

.. toctree::
   :glob:

   SQMtools/*
