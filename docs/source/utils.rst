***************
Utility scripts
***************

Compressing a SqueezeMeta project into a zip file
=================================================

.. _sqm2zip:
sqm2zip.py
----------
This script generates a compressed zip file with all the essential information needed to load a project into SQMtools. If the directory ``/path/to/project/results/tables`` is not present, it will also run :ref:`sqm2tables.py <sqm2tables>` to generate the required tables (see below).

This script can be found in the ``/path/to/SqueezeMeta/utils/`` directory, but if using conda it will be present in your PATH.

Usage
^^^^^
``sqm2zip.py <project_path> <output_dir> [options]``

Arguments
^^^^^^^^^

Mandatory parameters (positional)
"""""""""""""""""""""""""""""""""
[project_path <path>]
    Path to the SqueezeMeta run

[output_dir] <path>
    Output directory

Options
"""""""
[--trusted-functions]
    Include only ORFs with highly trusted KEGG and COG assignments in aggregated functional tables. This will be ignored if the ``/path/to/project/results/tables`` directory already exists

[--ignore-unclassified]
    Ignore reads without assigned functions for TPM calculation (KO, COG, PFAM). This will be ignored if the ``/path/to/project/results/tables`` directory already exists

[--force-overwrite]
    Write results even if the output file already exists

[--doc]
    Print the documentation

Output
^^^^^^
A zip file named ``<project_name>.zip`` in the directory specified by ``output_dir``. This file can be loaded directly into :doc:`SQMtools` using the ``loadSQM`` function.

Generating summary tables
=========================

.. _sqm2tables:
sqm2tables.py
-------------

This script generates tabular outputs from a SqueezeMeta run. It will aggregate the abundances of the ORFs assigned to the same feature (be it a given taxon or a given function) and produce tables with features in rows and samples in columns. Note that if you want to create tables coming from a :ref:`sqm_reads.pl <sqm_reads>` or :ref:`sqm_longreads.pl <sqm_longreads>` run you will need to use the :ref:`sqmreads2tables.py <sqmreads2tables>` script instead.

This script can be found in the ``/path/to/SqueezeMeta/utils/`` directory, but if using conda it will be present in your PATH.

.. note::
  This script is now run automatically with default parameters at the end of a SqueezeMeta run, placing the results in the ``/path/to/project/results/tables`` directory. You may still want to run it on your own if you want to use non-default parameters.

Usage
^^^^^
``sqm2tables.py <project_path> <output_dir> [options]``

Arguments
^^^^^^^^^

Mandatory parameters (positional)
"""""""""""""""""""""""""""""""""
[project_path <path>]
    Path to the SqueezeMeta run

[output_dir <path>]
    Output directory

Options
"""""""
[--trusted-functions]
    Include only ORFs with highly trusted KEGG and COG assignments in aggregated functional tables

[--ignore-unclassified]
    Ignore reads without assigned functions for TPM calculation

[--force-overwrite]
    Write results even if the output file already exists

[--doc]
    Print the documentation

Output
^^^^^^
- ``<project_name>.orfs.sequences.tsv``: ORF sequences

- ``<project_name>.orfs.sequences.tsv``: contig sequences

- ``<project_name>.orf.tax.allfilter.tsv``: taxonomy of each ORF at the different taxonomic levels. Minimum identity cutoffs for taxonomic assignment are applied to all taxa

- ``<project_name>.orf.tax.prokfilter.tsv``: taxonomy of each ORF at the different taxonomic levels. Minimum identity cutoffs for taxonomic assignment are applied to bacteria and archaea, but not to eukaryotes

- ``<project_name>.orf.tax.nofilter.tsv``: taxonomy of each ORF at the different taxonomic levels. No identity cutoffs for taxonomic assignment are applied

- ``<project_name>.contig.tax.allfilter.tsv``: consensus taxonomy of each contig at the different taxonomic levels, based on the taxonomy of their constituent ORFs (applying minimum identity cutoffs to all taxa)

- ``<project_name>.contig.tax.prokfilter.tsv``: consensus taxonomy of each contig at the different taxonomic levels, based on the taxonomy of their constituent ORFs. Minimum identity cutoffs for taxonomic assignment are applied to bacteria and archaea, but not to eukaryotes)

- ``<project_name>.contig.tax.nofilter.tsv``: consensus taxonomy of each contig at the different taxonomic levels, based on the taxonomy of their constituent ORFs. No identity cutoffs for taxonomic assignment are applied

- ``<project_name>.bin.tax.tsv``: consensus taxonomy of each bin at the different taxonomic levels, based on the taxonomy of their constituent contigs

.. note::
   See a deeper discussion on the use of identity cutoffs in taxonomic annotation :ref:`here <euk annot>`.

- ``<project_name>.RecA.tsv``: coverage of RecA (COG0468) in the different samples.

- For each taxonomic rank (superkingdom, phylum, class, order, family, genus, species) the script will produce the following files:
    - ``<project_name>.<rank>.allfilter.abund.tsv``: raw abundances of each taxon for that taxonomic rank in the different samples, applying the identity cutoffs for taxonomic assignment
    - ``<project_name>.<rank>.prokfilter.abund.tsv``: raw abundances of each taxon for that taxonomic rank in the different samples. Identity cutoffs for taxonomic assignment are applied to prokaryotic (bacteria + archaea) ORFs but not to Eukaryotes
    - ``<project_name>.<rank>.nofilter.abund.tsv``: raw abundances of each taxon for that taxonomic rank in the different samples. Identity cutoffs for taxonomic assignment are applied to prokaryotic (bacteria + archaea) ORFs but not to Eukaryotes

- For each functional classification system (KO, COG, PFAM, and any external database provided by the user) the script will produce the following files:
    - ``<project_name>.<classification>.names.tsv``: extended description of the functional categories in that classification system. For KO and COG the file will contain three fields: ID, Name and Path within the functional hierarchy. For external databases, it will contain only ID and Name.
    - ``<project_name>.<classification>.abunds.tsv``: raw read counts of each functional category in the different samples
    - ``<project_name>.<classification>.bases.tsv``: raw base counts of each functional category in the different samples
    - ``<project_name>.<classification>.copyNumber.tsv``: average copy numbers per genome of each functional category in the different samples. Copy numbers are obtained by dividing the aggregate coverage of each function in each sample by the coverage of RecA (COG0468) in each sample.
    - ``<project_name>.<classification>.tpm.tsv``: normalized (TPM) abundances of each functional category in the different samples. This normalization takes into account both sequencing depth and gene length
.. note::
  The --ignore_unclassified flag can be used to control whether unclassified ORFs are counted towards the total for TPM normalization

.. _sqmreads2tables:
sqmreads2tables.py
------------------
This script generates tabular outputs from a sqm_reads.pl or sqm_longreads.pl run. It will aggregate the abundances of the ORFs assigned to the same feature (be it a given taxon or a given function) and produce tables with features in rows and samples in columns.  It can optionally accept a query argument to generate tables containing only certain taxa and functions.

This script can be found in the ``/path/to/SqueezeMeta/utils/`` directory, but if using conda it will be present in your PATH.

Usage
^^^^^
``sqmreads2tables.py <project_path> <output_dir> [options]``

Arguments
^^^^^^^^^

Mandatory parameters (positional)
"""""""""""""""""""""""""""""""""
[project_path <path>]
    Path to the SqueezeMeta run

[output_dir <path>]
    Output directory

Options
"""""""

[-q/—query <string>]
    Filter the results based on the provided query in order to create tables containing only certain taxa or functions. See :ref:`query syntax`

[--trusted-functions]
    Include only ORFs with highly trusted KEGG and COG assignments in aggregated functional tables

[--force-overwrite]
    Write results even if the output file already exists

[--doc]
    Print the documentation

Output
^^^^^^
- For each taxonomic rank (superkingdom, phylum, class, order, family, genus, species) the script will produce the following files:
    - ``<project_name>.<rank>.allfilter.abund.tsv``: raw abundances of each taxon for that taxonomic rank in the different samples, applying the identity cutoffs for taxonomic assignment
    - ``<project_name>.<rank>.prokfilter.abund.tsv``: raw abundances of each taxon for that taxonomic rank in the different samples. Identity cutoffs for taxonomic assignment are applied to prokaryotic (bacteria + archaea) ORFs but not to Eukaryotes. See :ref:`euk annot`
    - ``<project_name>.<rank>.nofilter.abund.tsv``: raw abundances of each taxon for that taxonomic rank in the different samples. Identity cutoffs for taxonomic assignment are applied to prokaryotic (bacteria + archaea) ORFs but not to Eukaryotes

- For each functional classification system (KO, COG, PFAM, and any external database provided by the user) the script will produce the following files:
    - ``<project_name>.<classification>.abunds.tsv``: raw abundances of each functional category in the different samples
    - ``<project_name>.<classification>.names.tsv``: extended description of the functions in that classification system. For KO and COG the file will contain three fields: ID, Name and Path within the functional hierarchy. For external databases, it will contain only ID and Name

.. _query syntax:
Query syntax
^^^^^^^^^^^^

.. note::                                                                                                                              This syntax is used by two different scripts:
  - :ref:`sqmreads2tables.py <sqmreads2tables>` script, in order to filter reads annotated with :ref:`sqm_reads_pl <sqm_reads>` or :ref:`sqm_longreads.pl <sqm_longreads>`
  - :ref:`anvi-filter-sqm.py <anvi-filter-sqm>` script, in order to filter an anvi'o database obtained after running :ref:`anvi-load-sqm.py <anvi-load-sqm>` on a SqueezeMeta project

- Please enclose query strings within double brackets.

- Queries are combinations of relational operations in the form of ``<SUBJECT> <OPERATOR> <VALUE>`` (e.g. ``"PHYLUM == Bacteroidota"``) joined by logical operators (``AND``, ``OR``).

- Parentheses can be used to group operations together.

- The ``AND`` and ``OR`` logical operators can't appear together in the same expression. Parentheses must be used to separate them into different  expressions. e.g:
    - ``"GENUS == Escherichia OR GENUS == Prevotella AND FUN CONTAINS iron"`` would not be valid. Parentheses must be used to write either of the following expressions:
        - ``"(GENUS == Escherichia OR GENUS == Prevotella)" AND FUN CONTAINS iron"`` to select features from either *Escherichia* or *Prevotella* which contain ORFs related to iron
        - ``"GENUS == Escherichia OR (GENUS == Prevotella AND FUN CONTAINS iron)"`` to select all features from *Escherichia* and any feature from *Prevotella* which contains ORFs related to iron

- Another example query would be: ``"(PHYLUM == Bacteroidota OR CLASS IN [Alphaproteobacteria, Gammaproteobacteria]) AND FUN CONTAINS iron AND Sample1 > 1"``
    - This would select all the features assigned to either the *Bacteroidota* phylum or the *Alphaproteobacteria* or *Gammaproteobacteria* classes, that also contain the substring ``"iron"`` in the functional annotations of any of their ORFs, and whose abundance in Sample1 is higher than 1

- Possible subjects are:
    - ``FUN``: search within all the combined databases used for functional annotation
    - ``FUNH``: search within the KEGG BRITE and COG functional hierarchies (e.g. ``"FUNH CONTAINS Carbohydrate metabolism"`` will select all the feature containing a gene associated with the broad ``"Carbohydrate metabolism"`` category)
    - ``SUPERKINGDOM``, ``PHYLUM``, ``CLASS``, ``ORDER``, ``FAMILY``, ``GENUS``,  ``SPECIES``: search within the taxonomic annotation at the requested taxonomic rank
    - *<SAMPLE_NAME>* (for :ref:`anvi-filter-sqm.py <anvi-filter-sqm>` only): search within the anvi'o abundances (mean coverage of a split divided by the overall sample mean coverage) in the sample named *<SAMPLE_NAME>* (e.g. if you have two samples named ``Sample1`` and ``Sample2``, the query string ``Sample1 > 0.5 AND Sample2 > 0.5`` would return the splits with an anvi'o abundance higher than 0.5 in both samples)

- Posible relational operators are ``==``,, ``!=``, ``>=``, ``<=``, ``>``, ``<``, ``IN``, ``NOT IN``, ``CONTAINS``, ``DOES NOT CONTAIN``


combine-sqm-tables.py
---------------------
Combine tabular outputs from different projects generated either with SqueezeMeta or *sqm_(long)reads* (but not both at the same time). If the directory ``/path/to/project/results/tables`` is not present, it will also run :ref:`sqm2tables.py <sqm2tables>` or :ref:`sqmreads2tables.py <sqmreads2tables>` to generate the required tables.

This script can be found in the ``/path/to/SqueezeMeta/utils/`` directory, but if using conda it will be present in your PATH.

.. note::
  The recommended way of doing is is now using :doc:`SQMtools`
  - The ``loadSQM`` function accepts an arbitrary number of SqueezeMeta projects, loading them into a single SQM object
  - The ``combineSQMlite`` fucntion can be used to combine previously loaded SqueezeMeta and *sqm_(long)reads* projects into a single object. An advantage of this over ``combine-sqm-tables.py`` is that it can be used to combine projects coming from **both** SqueezeMeta and *sqm_(long)reads* at the same time. 

Usage
^^^^^
``combine-sqm-tables.py <project_paths> [options]``

Arguments
^^^^^^^^^

Mandatory parameters (positional)
"""""""""""""""""""""""""""""""""
[project_paths <paths>]
    A space-separated list of paths

Options
"""""""
[-f|--paths-file <path>]
   File containing the paths of the SqueezeMeta projects to combine, one path per line

[-o|--output-dir <path>]
    Output directory (default: ``"combined"``)

[-p|--output-prefix]
    Prefix for the output files (default: ``"combined"``)

[--trusted-functions]
   Include only ORFs with highly trusted KEGG and COG assignments in aggregated functional tables. This will be ignored if the ``/path/to/project/results/tables`` directory already exists

[--ignore-unclassified]
    Ignore reads without assigned functions for TPM calculation. This will be ignored if the ``/path/to/project/results/tables`` directory already exists or if ``--sqm-reads`` is passed

[--sqm-reads]
    Projects were generated using :ref:`sqm_reads.pl <sqm_reads>` or :ref:`sqm_longreads.pl <sqm_longreads>`

[--force-overwrite]
    Write results even if the output directory already exists

[--doc]
    Print the documentation

Example calls
"""""""""""""
- Combine projects  ``/path/to/proj1`` and ``/path/to/proj2`` and store output in a directory named ``"outputDir"``
    - ``combine-sqm-tables.py /path/to/proj1 /path/to/proj2 -o output_dir``
- Combine a list of projects contained in a file, use default output dir
    - ``combine-sqm-tables.py -f project_list.txt``

Output
^^^^^^
Tables containing aggregated counts and feature names for the different functional hierarchies and taxonomic levels for each sample contained in the different projects that were combined. Tables with the TPM and copy number of functions will also be generated for SqueezeMeta runs, but not for *sqm_(long)reads* runs.

Estimation of the sequencing depth needed for a project
=====================================================

cover.pl
--------

COVER intends to help in the experimental design of metagenomics by addressing the unavoidable question: How much should I sequence to get good results? Or the other way around: I can spend this much money, would it be worth to use it in sequencing the metagenome?

To answer these questions, COVER allows the estimation of the amount of sequencing needed to achieve a particular objective, being this the coverage attained for the most abundant N members of the microbiome. For instance, how much sequence is needed to reach 5x coverage for the four most abundant members (from now on, OTUs). COVER was first published in 2012 (Tamames *et al.*, 2012, Environ Microbiol Rep. 4:335-41), but we are using a different version of the algorithm described there. Details on this implementation can be found in :ref:`COVER`.

COVER needs information on the composition of the microbiome, and that must be provided as a file containing 16S rRNA sequences obtained by amplicon sequencing of the target microbiome. If you don't have that, you can look for a similar sample already sequenced (for instance, in NCBI's SRA).

This script can be found in the ``/path/to/SqueezeMeta/utils/`` directory, but if using conda it will be present in your PATH.

Usage
^^^^^
``cover.pl -i <input_file> [options]``

Arguments
^^^^^^^^^

Mandatory parameters
""""""""""""""""""""
[-i <path>]
    FASTA file containing 16S rRNA amplicons

Options
"""""""
[-idcluster <float>]
    Identity threshold for collapsing OTUs (default: ``0.98``)

[-c|-coverage <float>]
    Target coverage (default: ``5``)

[-r|-rank <integer>]
    Rank of target OTU (default: ``4``)

.. note::
   Default values imply looking for 5x coverage for the 4th most abundant 98% OTU

[-cl|-classifier <mothur|rdp>]
    Classifier to use (RDP or Mothur) (default: ``mothur``)

[-d|-dir]
    Output directory (default: ``cover``)

[-t]
    Number of threads (default: ``4``)

  (Default values imply looking for 5 x coverage for the 4 th most abundant OTU)

Output
""""""
The output is a table that first lists the amount of sequencing needed, both uncorrected and corrected by the Good’s estimator:

::
  
  Needed 4775627706 bases, uncorrected
  Correcting by unobserved: 6693800053 bases

And then lists the information and coverages for each OTU, with the following columns:

- OTU: Name of the OTU
- Size: Inferred genomic size of the OTU
- Raw abundance: Number of sequences in the OTU
- Copy number: Inferred 16S rRNA copy number
- Corrected abundance: Abundance n / Σn Abundance
- Pi : Probability of sequencing a base of this OTU
- %Genome sequenced: Percentage of the genome that will be sequenced for that OTU
- Coverage: Coverage that will be obtained for that OTU
- Taxon: Deepest taxonomic annotation for the OTU

Adding new databases to an existing project
===========================================

add_database.pl
---------------
This script adds one or several new databases to the results of an existing project. The list of databases must be provided in an external database file as specified in :ref:`Using external function database`. It must be a tab-delimited file with the following format:

::

   <Database Name>	<Path to database>	<Functional annotation file>

The databases to add must also be formatted in DIAMOND format. See :ref:`Using external function database` for details. If the external database file already exists (because you already used some external databases when running SqueezeMeta), DO NOT create a new one. Instead add the new entries to the existing database file.

The script will run Diamond searches for the new databases, and then will re-run several SqueezeMeta scripts to include the new database(s) to the existing results. The following scripts will be invoked:

- :ref:`fun3 script`
- :ref:`funcover`
- :ref:`ORF table`
- :ref:`stats`
- :ref:`_sqm2tables in pipeline`

The outputs of these programs will be regenerated (but all files corresponding to other databases will remain untouched).

This script can be found in the ``/path/to/SqueezeMeta/utils/`` directory, but if using conda it will be present in your PATH.

Usage
^^^^^

``add_database.pl <project_path> <database_file>``

Integration with external tools
===============================

Integration with itol
---------------------

sqm2itol.pl
^^^^^^^^^^^

This script generates the files for creating a radial plot of abundances using iTOL (https://itol.embl.de/). It can be found in the ``/path/to/SqueezeMeta/utils/`` directory, but if using conda it will be present in your PATH.

Usage
"""""

``sqm2itol.pl <project_path> [options]``

Arguments
"""""""""

Mandatory parameters (positional)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

[project_path <path>]
    Path to the SqueezeMeta run

Options
~~~~~~~
[-completion <float>]
    Select only bins with percent completion above that threshold (default: ``30``)

[-contamination <float>]
    Select only bins with percent contamination below that threshold (default: ``100``)

[-classification <metacyc|kegg>]
    Functional classification to use (default: ``metacyc``)

[-functions <path>]
    File containing the name of the functions to be considered (for functional plots). For example:
    ::

     arabinose degradation
     galactose degradation
     glucose degradation

Output
""""""
The script will generate several datafiles that you must upload to https://itol.embl.de/ to produce the figure.

Integration with ipath
----------------------

sqm2ipath.pl
^^^^^^^^^^^^
This script creates data on  the existence of enzymatic reactions that can be plotted in the interactive pathway mapper iPath (http://pathways.embl.de). It can be found in the ``/path/to/SqueezeMeta/utils/`` directory, but if using conda it will be present in your PATH.

Usage
"""""
``sqm2ipath.pl <project_path> [options]``

Mandatory parameters (positional)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
[project_path <path>]
    Path to the SqueezeMeta run

Options
~~~~~~~
[-taxon <string>]
    Taxon to be plotted  (default: *plot all taxa*)

[-color <string>]
    RGB color to be used in the plot (default: ``red``)

[-c|classification <cog|kegg>]
    Functional classification to use (default: ``kegg``)

[-functions <file>]
    File containing the COG/KEGG identifiers of the functions to be considered. For example:
    ::

     K00036
     K00038
     K00040
     K00052  #ff0000
     K00053

    A second argument following the identifier selects the RGB color to be associated to that ID in the plot

    .. note::
    The plotting colors can be specified by the -color option, or by associating values to each of the IDs in the functions file. In that case, several colors can be used in the same plot. If no color is specified, the default is red.

[-o|out <path>]
    Name of the output file (default: ``ipath.out``)

Output
""""""
A file suitable to be uploaded to http://pathways.embl.de. Several output files can be combined, for instance using different colors for different taxa.

Integration with pavian
-----------------------

sqm2pavian.pl
^^^^^^^^^^^^^

Integration with anvi`o
-----------------------

sqm2anvio.pl
^^^^^^^^^^^^

.. _anvi-load-sqm:
anvi-load-sqm.py
^^^^^^^^^^^^^^^^

.. _anvi-filter-sqm:
anvi-filter-sqm.py
^^^^^^^^^^^^^^^^^^

Binning refinement
------------------

.. note::
    THIS CAN NOW BE DONE WITH SQMTOOLS

remove_duplicate_markers.pl
^^^^^^^^^^^^^^^^^^^^^^^^^^^

find_missing_markers.pl
^^^^^^^^^^^^^^^^^^^^^^^

