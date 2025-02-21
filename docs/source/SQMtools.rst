**********************
The SQMtools R package
**********************

This package provides an easy way to expose the different results of SqueezeMeta (orfs, contigs, bins, taxonomy, functions…) into R, as well as a set of utility functions to filter and display SqueezeMeta results.

Design philosophy
=================

SQMtools aims to simplify the analysis of complex metagenomic 
One or more SqueezeMeta projects can be r
Once SqueezeMeta has finished running, just go into R and load the project.
library(SQMtools)
project = loadSQM(“<project_directory>”)

This will also work with a zip file produced by sqm2zip.py.
project = loadSQM(“<project.zip>”)

.. figure:: ../resources/Figure_1_SQMtools.svg
  :alt: Structure of the SQM R object

  Structure of the SQM R object. If external databases for functional classification were provided to SqueezeMeta via the *-extdb* argument, the corresponding abundance (reads and bases), tpm and copy number profiles will be present in *SQM$functions* (e.g. results for the CAZy database would be present in *SQM$functions$CAZy*. Additionally, the extended names of the features present in the external database will be present in *SQM$misc* (e.g. *SQM$misc$CAZy_names*). The SQMlite object will have a similar structure, but will lack the *SQM$orfs*, *SQM$contigs* and *SQM$bins* section. Additionally, if the results come from a *sqm_reads.pl* or *sqm_longreads.pl* run, the SQMlite object will also be missing TPM, bases and copy numbers for the different functional classification methods.

The SQM object structure
========================

The resulting SQM object contains all the relevant information, organized in nested an R lists (see next figure). For example, a matrix with the taxonomic composition of the different samples at the phylum level in percentages can be obtained with ``project$taxa$phylum$percent`` while a matrix with the average copy number per genome of the different PFAMs across samples can be obtained with ``project$functions$PFAM$copy_number``.

.. figure:: ../resources/Figure_2_SQMtools.svg
  :alt: Structure of the SQM R object

  Structure of the SQM R object. If external databases for functional classification were provided to SqueezeMeta via the *-extdb* argument, the corresponding abundance (reads and bases), tpm and copy number profiles will be present in *SQM$functions* (e.g. results for the CAZy database would be present in *SQM$functions$CAZy*. Additionally, the extended names of the features present in the external database will be present in *SQM$misc* (e.g. *SQM$misc$CAZy_names*). The SQMlite object will have a similar structure, but will lack the *SQM$orfs*, *SQM$contigs* and *SQM$bins* section. Additionally, if the results come from a *sqm_reads.pl* or *sqm_longreads.pl* run, the SQMlite object will also be missing TPM, bases and copy numbers for the different functional classification methods.

The SQMtools package also provides functions for selecting subsets of your data and plotting/exporting results. The basic workflow is illustrated in Figure 6. For example, we can make a plot with the taxonomic distribution of all the genes related to vitamin metabolism.
vit = subsetFun(project, “Metabolism of cofactors and vitamins”)
plotTaxonomy(vit)
As an alternative to running a full SqueezeMeta project, you can just load the taxonomic and functional aggregate tables. This will work with the output of sqm2tables.py, sqmreads2tables.py and combine-sqm-tables.py, so you can analyze the ouput of sqm_reads.pl, or the combined results of several SqueezeMeta or sqm_reads projects. To do so, you can use the loadSQMlite function from SQMtools.
project = loadSQMlite(“<tables_directory>”)

XXXXX NORMALIZATION / COPY NUMBERS1i

SQM_READS

.. toctree::
   :glob:

   SQMtools/*
