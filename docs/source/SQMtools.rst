**********************
The SQMtools R package
**********************

This package provides an easy way to expose the different results of SqueezeMeta (orfs, contigs, bins, taxonomy, functions…) into R, as well as a set of utility functions to filter and display SqueezeMeta results.

.. note::
  The documentation below aims to describe the philosophy, usage, and internals of the SQMtools package. For detailed (albeit maybe a bit outdated) usage examples see also the `wiki entry <https://github.com/jtamames/SqueezeMeta/wiki/Using-R-to-analyze-your-SQM-results>`_.

Design philosophy
=================

**SQMtools aims to simplify the analysis of complex metagenomic datasets** by representing them as a single object inside the R environment for statistical analysis. Once a project has been loaded into R with SQMtools the user can:

- Make basic plots representing its taxonomical and functional composition
- Subset it to select only certain taxa, functions or bins/MAGs
- Access the individual components of the object (e.g. taxonomy tables, contig sequences, bin qualities, etc) in order to perform custom analyses or feed the data to other R packages

**The main idea behind SQMtools is to speed up the exploration of metagenomic results by facilitating data inspection and filtering.** A standard workflow in *SQMtools* usually involves:

1) :ref:`Loading your project <SQMtools load>`
2) :ref:`Inpecting taxonomic/functional patterns <SQMtools plots>` in the whole project (e.g. plotting taxonomic distribution across samples)
3) Locating certain taxa/functions of interest (based on the results of the preliminary inspection, or on prior knowledge about the study system) and :ref:`generating a subset <SQMtools subset>` containing only those taxa/functions
4) Inspecting taxonomic/functional patterns in the subset. For example, making a subset containing some functions of interest and then making a taxonomic plot of that subset will inform us of the relative abundance and taxonomic distribution of those functions of interest in our samples


.. figure:: ../resources/Figure_1_SQMtools.svg
  :alt: Basic workflow of the SQMtools package.

  Basic workflow of the SQMtools package. The basic unit used in the package is the SQM object. This object can contain a full SqueezeMeta project or a subset of genes, contigs or bins. The data in the SQM object can be accessed directly (e.g. for using it with other R packages such as vegan for ordination analyses or DESeq2 for differential abundance analysis) but we also provide some utility functions for exploring the most abundant functions or taxa in a SQM object. Alternatively, aggregate tables can be loaded into a SQMlite objects, which supports plot and export functionality. SQMlite objects can not be subsetted, but can be combined.

.. _SQMtools load:
Loading data into SQMtools
==========================

The :doc:`SQMtools/loadSQM` function can be used the output of one or more :doc:`SqueezeMeta.pl <execution>` runs into a single object. It also works directly with compressed zip projects generated with :ref:`sqm2zip.py <sqm2zip>`. 

.. code-block:: r

  library(SQMtools)
  project = loadSQM("/path/to/project/")

The code above will generate a single :ref:`SQM object <SQM object>` containing all the information relative to the project. More than one project can be loaded at the same time (e.g. ``loadSQM( c("/path/to/project1", "/path/to/project2") )``. In this case, the call to *loadSQM* would return a single :ref:`SQMbunch object <SQMbunch object>` with the combined information from all the input projects, which would otherwise behave similarly.

Alternatively, the :doc:`SQMtools/loadSQMlite` function can be used to load aggregated taxonomic and functional tables generated with :ref:`sqm2tables.py <sqm2tables>` or :ref:`sqmreads2tables.py`. The resulting :ref:`SQMlite object <SQMlite object>` is much more lightweight, but carries not information on individual ORFs, contigs or bins and does not support subsetting.

.. _SQM object:
The SQM object structure
------------------------

A *SQM object* contains all the relevant information from a SqueezeMeta project, organized in nested an R lists (figure below). For example, a matrix with the taxonomic composition of the different samples at the phylum level in percentages can be obtained with ``project$taxa$phylum$percent`` while a matrix with the average copy number per genome of the different PFAMs across samples can be obtained with ``project$functions$PFAM$copy_number``.

.. figure:: ../resources/Figure_2_SQMtools.svg
  :alt: Structure of the SQM R object

  Structure of the SQM R object. If external databases for functional classification were provided to SqueezeMeta via the *-extdb* argument, the corresponding abundance (reads and bases), tpm and copy number profiles will be present in *SQM$functions* (e.g. results for the CAZy database would be present in *SQM$functions$CAZy*. Additionally, the extended names of the features present in the external database will be present in *SQM$misc* (e.g. *SQM$misc$CAZy_names*). The SQMlite object will have a similar structure, but will lack the *SQM$orfs*, *SQM$contigs* and *SQM$bins* section. Additionally, if the results come from a *sqm_reads.pl* or *sqm_longreads.pl* run, the SQMlite object will also be missing TPM, bases and copy numbers for the different functional classification methods.

.. _SQMbunch object:
The SQMbunch object structure
-----------------------------
A *SQMbunch* object contains all the relevant information for several SqueezeMeta projects. It has a similar structure to a :ref:`SQM object <SQM object>`, but it lacks the ``orfs``, ``contigs`` and ``bins`` sections. Instead, it has a separate list named ``projects``, which contains individual *SQM* objects for each of the projects that were loaded.

.. _SQMlite object:
The SQMlite object structure
----------------------------
A *SQMlite* object contains aggregated taxonomic and functional tables. It has a similar structure to a :ref:`SQM object <SQM object>`, but it lacks the ``orfs``, ``contigs`` and ``bins`` sections.

.. _SQMtools subset:
Creating subsets of your data
=============================
:ref:`SQM <SQM object>` and :ref:`SQMbunch <SQMbunch object>` objects can be subsetted to select only certain features of interest. This can be achieved with the following functions:

- :doc:`SQMtools/subsetSamples`: select the requested samples
- :doc:`SQMtools/subsetTax`: select data from the requested taxon
- :doc:`SQMtools/subsetFun`: select data from the requested function/s
- :doc:`SQMtools/subsetBins`: select data from the requested bins
- :doc:`SQMtools/subsetContigs`: select arbitrary contigs
- :doc:`SQMtools/subsetORFs`: select arbitrary ORFs

For example, the code

.. code-block:: r

  project.poly = subsetTax(project, "genus", "Polynucleobacter")

would return a new *SQM* or *SQMbunch* object containing only the information from contigs that belonged to the *Polynucleobacter* genus, the ORFs contained in them, and the bins/MAGs that contain those contigs.

Subsetting involves the following steps:

- Determining which ORFs, contigs and bins are to be included in the subsetted object
- Recalculating aggregated taxonomic and functional tables based on the selected ORFs/contigs
- If requested, renormalize certain functional abundance metrics to make them relative to the data included in the subset (see below)
- Recalculate bin abundance metrics based on the selected contigs. If requested, also recalculate bin completeness/contamination

.. note::
  *SQMlite* objects can not be subsetted. This means that results coming from :ref:`sqm_reads.pl <sqm_reads>` and :ref:`sqm_longreads.pl <sqm_longreads>` can also not be subsetted within SQMtools. However, a similar effect can by first filtering the results with the the ``--query`` parameter of the :ref:`sqmreads2tables.py <sqmreads2tables>` script, and then loading the resulting tables into SQMtools with :doc:`SQMtools/loadSQMlite`.

Data renormalization on subsetting
----------------------------------

When generating a subset, the TPM and copy number of functions can be rescaled so it becomes relative to the reads included in the subset, instead of to the reads included in the original object.

For example, upon loading a project into *SQMtools*, the copy number of each function represents the average number of copies of that function per genome in the whole community. If we then run `subsetTax` to select the contigs belonging to a taxa of interest, the copy numbers in the subsetted object will have a different interpretation depending on whether we rescale or not.

- **If no rescaling is performed**, the copy numbers in the subset will represent the average number of copies of each function in the full metagenome **that were coming from the taxa of interest**

- **If rescaling is performed**, the copy numbers in the subset will represent the average number of copies of each function **in the taxa of interest**

For further clarification, compare the following two assertions:

- *"For each genome in my samples (regardless of its taxonomy) cyanobacteria contributed on average 0.2 toxin production genes"*

- *"In my samples, each cyanobacterial genome had on average 2 toxin production genes"*

In addition to this, when generating a subset the completeness and contamination of bins can be recalculated according to only the contigs present in the subset.

The different subset functions have different default behaviour. As a rule of thumb, functions that expect to retrieve whole genomes after subsetting (`subsetTax`, `subsetBins`) will perform renormalization, while functions that retreive arbitrary parts of a genome (`subsetTax`, `subsetContigs`, `subsetORFs`) will recalculate bin statistics.

The default behaviour of each subset function is listed in the table below, but it can be controlled manually through the `rescale_tpm`, `rescale_copy_number` and `recalculate_bin_stats` arguments. 

=============    ===========    ===================    =====================
Method           rescale_tpm    rescale_copy_number    recalculate_bin_stats
=============    ===========    ===================    =====================
subsetSamples    N/A            N/A                    N/A
subsetTax        TRUE           TRUE                   TRUE
subsetFun        FALSE          FALSE                  FALSE
subsetBins       TRUE           TRUE                   N/A
subsetContigs    FALSE          FALSE                  TRUE
subsetORFs       FALSE          FALSE                  TRUE
=============    ===========    ===================    =====================

.. note::
   Completeness and contamination statistics are initially calculated using CheckM2, but upon subsetting they are recalculated using a re-implementation of the CheckM1 algorithm over root marker genes. This can give an idea on how adding/removing certain contigs affects the completeness of a bin, but should be considered as less reliable than manually running CheckM2 again.

Combining SQM and SQMlite objects
=================================
*SQMtools* also offers ways to combine several :ref:`SQM <SQM object>` and :ref:`SQMlite <SQMlite object>` objects into a single object: 

- :doc:`SQMtools/combineSQM`: this function combines several *SQM* objects into a single object containing all their information

  - If all the input objects come from the same projects (e.g. because they are different subsets of the same original dataset) this function will also return a *SQM* object
  - If the input objects come from different projects (i.e. they were generated from different *SqueezeMeta.pl* runs on different samples) then this function will return a *SQMbunch* object

- :doc:`SQMtools/combineSQMlite`: this functions combines several *SQM* and/or *SQMlite* objects into a single :ref:`SQMlite object <SQMlite object>`

.. _SQMtools plots:
Creating plots and exporting data
=================================
*SQMtools* offers the utility functions for creating plots and exporting data. The following work with *SQM*, *SQMbunch* and *SQMlite* objects:

- :doc:`SQMtools/plotTaxonomy`
- :doc:`SQMtools/plotFunctions`
- :doc:`SQMtools/plotBins`
- :doc:`SQMtools/exportKrona`
- :doc:`SQMtools/exportPathway`

The following functions work for *SQM* and *SQMbunch* objects only:

- :doc:`SQMtools/exportORFs`
- :doc:`SQMtools/exportContigs`
- :doc:`SQMtools/exportBins`

THe following functions work with arbitrary tables/matrices:

- doc:`SQMtools/plotBars`
- doc:`SQMtools/plotHeatmap`
- doc:`SQMtools/exportTable`

Working with bins
=================

Data normalization strategies
=============================

List of functions and detailed documentation
============================================

.. toctree::
   :glob:

   SQMtools/*
