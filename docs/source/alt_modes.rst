**************************
Alternative analysis modes
**************************

Taxonomic and functional annotation of unassembled reads
========================================================

sqm_reads.pl
------------

This procedure performs taxonomic and functional assignments directly on the reads. This is useful when the assembly is not good, usually because of low sequencing depth, high diversity of the microbiome, or both. One indication that this is happening can be found in the :ref:`Step 10: Mapping of reads to contigs and calculation of abundance measures <mappingstat>`_ file. Should you find there low mapping percentages (below 50%), it means that most of your reads are not represented in the assembly and can we can try to classify the reads instead of the genes/contigs.

This script will do a DIAMOND Blastx alignment of reads agains the nr, COG and KEGG databases, and will assign taxa as functions using the :ref:`The LCA algorithm <lca>`_ and :ref:`The fun3 algorithm <fun3>`_ methods, as SqueezeMeta does. It will probably provide an increment in the number of annotations. But on the other hand, the annotations could be less precise (we are working with a smaller sequence) and you lose the capacity to map reads onto an assembly and thus comparing metagenomes using a common reference. Use this for Illumina reads. This method is less suited to analyze long MinION reads where more than one gene can be represented (see `sqm_longreads.pl`_ in that case).  This script can be found in the ``/path/to/SqueezeMeta/utils/`` directory, but if using conda it will be present in your PATH.

The usage of SQM_reads is very similar to that of SqueezeMeta:

``sqm_reads.pl -p <project name> -s <equiv file> -f <raw fastq dir> [options]```

Arguments
^^^^^^^^^

Mandatory parameters
""""""""""""""""""""
[-p <string>]
    Project name (REQUIRED)

[-s|-samples]
    Samples file, see :ref:`samples file` (REQUIRED)

[-f|-seq]
    Fastq read files directory (REQUIRED)

Options
"""""""
[–-nocog]
    Skip COG assignment

[-–nokegg]
    Skip KEGG assignment

[–-nodiamond]
    Assumes that Diamond output files are already in place (for instance, if you are redoing the analysis) and skips all Diamond run

[-–euk]
    Drop identity filters for eukaryotic annotation (Default: no). This is recommended for analyses in which the eukaryotic
    population is relevant, as it will yield more annotations.
    Note that, regardless of whether this option is selected or not, that result will be available as part of the aggregated
    taxonomy tables generated at the last step of the pipeline and also when loading the project into *SQMtools*
    (see the documentation for `sqmreads2tables.py`_ and also for the ``loadSQMlite`` function in the *SQMtools* R package),
    so this is only relevant if you are planning to use the intermediate files directly.

[-extdb <path>]
    File with a list of additional user-provided databases for functional annotations. See :ref:`Using external function databases`

[-t <integer>]
    Number of threads (default: ``12``)                                                                                                                                                                                                                                   [-b|-block-size <integer>]
    Block size for DIAMOND against the nr database (default: *calculate automatically*)

[-e|-evalue <float]
    Max e-value for discarding hits in the DIAMOND run  (default: *1e-03*)

[-miniden <float>]
    Identity percentage for discarding hits in DIAMOND run (default: *50*)

Output
^^^^^^

.. note::
    The most straightforward way to analyze the results from this script is not to use its output files directly, but rather to produce summary tables for taxonomy and function with `sqmreads2tables.py`_ and optionally load them into R using the ``loadSQMlite`` function from the SQMtools package for further exploration. However, we list the output files here for completeness.

The script produces the following files.

- ``<project>.out.allreads``: taxonomic and functional assignments for each read. Format of the file:
    - Column 1: sample name
    - Column 2: read name
    - Column 3: corresponding taxon
    - Column 4 and beyond Functional assignments (COG, KEGG)


- ``<project>.out.mcount``: abundance of all taxa. Format of the file:
    - Column 1: taxonomic rank for the taxon
    - Column 2: taxon
    - Column 3: accumulated read number (number of reads for that taxon in all samples)
    - Column 4 and beyond: number of reads for the taxon in the corresponding sample


- ``<project>.out.funcog``: abundance of all COG functions. Format of the file:
    - Column 1: COG ID
    - Column 2: accumulated read number: Number of reads for that COG in all samples
    - Column 3 and beyond: number of reads for the COG in the corresponding sample
    - Next to last column: COG function
    - Last column: COG functional class

- ``<project>.out.funkegg``: abundance of all KEGG functions. Format of the file:
    - Column 1: KEGG ID
    - Column 2: accumulated read number (number of reads for that KEGG in all samples)
    - Column 3 and beyond (number of reads for the KEGG in the corresponding sample)
    - Next to last column: KEGG function
    - Last column: KEGG functional class

sqm_longreads.pl
----------------


Fast screening unassembled short reads for a particular function
================================================================

sqm_hmm_reads.pl
----------------


Mapping reads to a reference
============================

sqm_mapper.pl
-------------

Functional and taxonomic annotation of genes and genomes
========================================================

sqm_annot.pl
------------
