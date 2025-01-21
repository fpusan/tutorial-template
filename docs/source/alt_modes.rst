**************************
Alternative analysis modes
**************************

Taxonomic and functional annotation of unassembled reads
========================================================

.. _sqm_reads:
sqm_reads.pl
------------
This procedure performs taxonomic and functional assignments directly on the reads. This is useful when the assembly is not good, usually because of low sequencing depth, high diversity of the microbiome, or both. One indication that this is happening can be found in the :ref:`mappingstat <mappingstat>` file. Should you find there low mapping percentages (below 50%), it means that most of your reads are not represented in the assembly and can we can try to classify the reads instead of the genes/contigs.

This script will do a DIAMOND Blastx alignment of reads agains the nr, COG and KEGG databases, and will assign taxa as functions using the :ref:`lca <lca>` and :ref:`fun3 <fun3>` methods, as SqueezeMeta does. It will probably provide an increment in the number of annotations. But on the other hand, the annotations could be less precise (we are working with a smaller sequence) and you lose the capacity to map reads onto an assembly and thus comparing metagenomes using a common reference. Use this for Illumina reads. This method is less suited to analyze long MinION reads where more than one gene can be represented (see :ref:`sqm_longreads.pl <sqm_longreads>` in that case).

This script can be found in the ``/path/to/SqueezeMeta/utils/`` directory, but if using conda it will be present in your PATH.

Usage
^^^^^
The usage of ``sqm_reads.pl`` is very similar to that of SqueezeMeta:

``sqm_reads.pl -p <project name> -s <equiv file> -f <raw fastq dir> [options]```

Arguments
^^^^^^^^^

Mandatory parameters
""""""""""""""""""""
[-p <string>]
    Project name (REQUIRED)

[-s|-samples]
    Samples file, see :ref:`Samples file` (REQUIRED)

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
    (see the documentation for :ref:`sqmreads2tables.py <sqmreads2tables>` and also for the ``loadSQMlite`` function in the
    *SQMtools* R package), so this is only relevant if you are planning to use the intermediate files directly.

[-extdb <path>]
    File with a list of additional user-provided databases for functional annotations. See :ref:`Using external function databases`

[-t <integer>]
    Number of threads (default: ``12``)                                                                                                                                                                                                                                   [-b|-block-size <integer>]
    Block size for DIAMOND against the nr database (default: *calculate automatically*)

[-e|-evalue <float]
    Max e-value for discarding hits in the DIAMOND run  (default: *1e-03*)

[-miniden <float>]
    Identity percentage for discarding hits in DIAMOND run (default: *50*)

.. _sqm_reads_output:
Output
^^^^^^

.. note::
    The most straightforward way to analyze the results from this script is not to use its output files directly, but rather to produce summary tables for taxonomy and function with :ref:`sqmreads2tables.py <sqmreads2tables>` and optionally load them into R using the ``loadSQMlite`` function from the SQMtools package for further exploration. However, we list the output files here for completeness.

The script produces the following files.

- ``<project>.out.allreads``: taxonomic and functional assignments for each read. Format of the file:
    - Column 1: sample name
    - Column 2: read name
    - Column 3: corresponding taxon
    - Column 4 and beyond Functional assignments (COG, KEGG)


- ``<project>.out.mcount``: abundance of all taxa. Format of the file:
samples_file    - Column 1: taxonomic rank for the taxon
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


.. _sqm_longreads:
sqm_longreads.pl
----------------

This script works in the same way as SQM_reads.pl, that is, it attempts to produce taxonomic and functional assignments directly on the raw reads, not using an assembly. The difference is that this script assumes that more than one ORF can be found in the read. It performs Diamond Blastx searches against taxonomic and functional databases, and then identifies ORFs by collapsing the hits in the same region of the read. The ``--range-culling`` option of Diamond makes this possible, since it limits the number of hits to the same region of the sequence, making it possible to recover hits for all parts of the read.

The script assigns taxa and functions to each ORF using the :ref:`lca <lca>` and :ref:`fun3 <fun3>` methods, as done by SqueezeMeta. In addition, it calculates a consensus taxonomic assignment for each read (see :ref:`consensus tax`). The taxon provided for the read is that consensus annotation.

This script can be found in the ``/path/to/SqueezeMeta/utils/`` directory, but if using conda it will be present in your PATH.

Usage
^^^^^
The usage of ``sqm_longreads.pl`` is the same than that of :ref:`sqm_reads.pl <sqm_reads>`:

``sqm_longreads.pl -p <project name> -s <equiv file> -f <raw fastq dir> [options]``

Arguments
^^^^^^^^^

Mandatory parameters
""""""""""""""""""""
[-p <string>]
    Project name (REQUIRED)

[-s|-samples]
    Samples file, see :ref:`Samples file` (REQUIRED)

[-f|-seq]
    Fastq read files directory (REQUIRED)

Options
"""""""
[–-nocog]                                                                                                                                Skip COG assignment

[-–nokegg]                                                                                                                               Skip KEGG assignment

[–-nodiamond]                                                                                                                            Assumes that Diamond output files are already in place (for instance, if you are redoing the analysis) and skips all Diamond run

[-–euk]
    Drop identity filters for eukaryotic annotation (Default: no). This is recommended for analyses in which the eukaryotic
    population is relevant, as it will yield more annotations.
    Note that, regardless of whether this option is selected or not, that result will be available as part of the aggregated
    taxonomy tables generated at the last step of the pipeline and also when loading the project into *SQMtools*
    (see the documentation for :ref:`sqmreads2tables.py <sqmreads2tables>` and also for the ``loadSQMlite`` function in the
    *SQMtools* R package), so this is only relevant if you are planning to use the intermediate files directly.

[-extdb <path>]
    File with a list of additional user-provided databases for functional annotations. See :ref:`Using external function databases`

[-t <integer>]
    Number of threads (default: ``12``)

[-b|-block-size <integer>]
    Block size for DIAMOND against the nr database (default: *calculate automatically*)

[-e|-evalue <float]
    Max e-value for discarding hits in the DIAMOND run  (default: ``1e-03``)

[-miniden <float>]
    Identity percentage for discarding hits in DIAMOND run (default: ``50``)

[-n|-nopartialhits]
    Ignore partial hits if they occur at the middle of a long read

[--force_overwrite]
    Overwrite previous results

Output
^^^^^^
The output is similar to that of :ref:`sqm_reads.pl <sqm_reads_output>`. In addition, ``sqm_longreads.pl`` provides information about the consensus in the ``readconsensus.txt`` files placed in the output directories for each sample.

Ignoring or not partial hits
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
A truncated hit (one missing to find one, or both, extremes) often happens in the extremes of the long read (because the read is ending and so is the hit), but it is unexpected to find it in the middle of a long read. There you would expect to see a complete hit. Whatever the reasons for this, the hit is suspicious and can be excluded using the ``-n`` option. But beware, this probably will decrease significantly the number of detected ORFs.


.. _sqm_hmm_reads:
Fast screening of unassembled short reads for a particular function
===================================================================

sqm_hmm_reads.pl
----------------
This script does functional assignment of the raw reads, using an ultra-sensitive Hidden Markov Model (HMM) search implemented in the third-party software Short-Pair (https://sourceforge.net/projects/short-pair). By using an approximate Bayesian approach employing distribution of fragment lengths and alignment scores, Short-Pair can retrieve the missing end and determine true domains for short paired-end reads (Techa-Angkoon *et al.*, BMC Bioinformatics 18, 414, 2017). This is intended to give an answer to the question "Is my function of interest present in the metagenome?", avoiding assembly biases where low-abundance genes may be not assembled and therefore will not be represented in the metagenome. This is also expected to be more sensitive than DIAMOND assignment of reads done by :ref:`sqm_reads.pl <sqm_reads>` and :ref:`sqm_longreads.pl <sqm_longreads>`.

As HMM searches are slower than short-read alignment, it is not practical to do this for all functions. Instead, the user must specify one or several PFAM IDs and the search will be done just for these. The script will connect to the Pfam database (https://pfam.xfam.org) to download the corresponding hmm and seed files.  This script can be found in the ``/path/to/SqueezeMeta/utils/`` directory.

This script can be found in the ``/path/to/SqueezeMeta/utils/`` directory, but if using conda it will be present in your PATH.

Usage
^^^^^
``sqm_hmm_reads.pl -pfam <PFAM list> -pair1 <pair1 fasta file>  -pair2 <pair2 fasta file> [options]``

Arguments
^^^^^^^^^

Mandatory parameters
""""""""""""""""""""
[-pfam <string>]
    List of Pfam IDs to retrieve, comma-separated (eg: ``-pfam PF00069,PF00070``) (REQUIRED)

[-pair1 <path>]
    Fasta file for pair 1 (REQUIRED)

[-pair2 <path>]
    Fasta file for pair 2 (REQUIRED)

.. note::
    Note that ``-pair1`` and ``-pair2`` must be uncompressed fasta files

Options
"""""""
[-t <int>]
    Number of threads (default: ``12``)

[-output <string>]
    Name of the output file (default: ``SQM_pfam.out``)

Output
""""""
The output file follows the Short-Pair output format:
- First column: read name (.1 for first pair, .2 for second pair) 
- Second column: Pfam domain family
- Third column: alignment score
- Fourth column: e-value
- Fifth column: start position of alignment on the pfam domain model
- Sixth column: end position of alignment on the pfam domain model
- Seventh column: start position of alignment on the read
- Eighth column: end position of alignment on the read
- Ninth column: strand (+ for forward, - for reverse)


.. _sqm_mapper:
Mapping reads to a reference
============================

sqm_mapper.pl
-------------

.. _sqm_annot:
Functional and taxonomic annotation of genes and genomes
========================================================

sqm_annot.pl
------------
