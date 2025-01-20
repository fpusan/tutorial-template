**************************************
Execution, restart and running scripts
**************************************

Scripts location
================

The scripts composing the SqueezeMeta pipeline can be found in the
``/path/to/SqueezeMeta/scripts`` directory. Other utility scripts can be
found in the ``/path/to/SqueezeMeta/utils`` directory. See the documentation
for more information on utility scripts.

Execution
=========

The command for running SqueezeMeta has the following syntax:

``SqueezeMeta.pl -m <mode> -p <projectname> -s <equivfile> -f <raw fastq dir> <options>``

Arguments
=========

Mandatory parameters
--------------------

[-m <sequential|coassembly|merged|seqmerge>]
    Mode: See :ref:`Assembly strategy` (REQUIRED)

[-p <string>]
    Project name (REQUIRED in coassembly and merged modes)

[-s|samples <path>]
    Samples file (REQUIRED)

[-f|-seq <path>]
Version 1.0 of SqueezeMeta implements the possibility of using one or several external databases (user-provided) for functional annotation. This is invoked using the --extdb option. The argument must be a file (external database file) with the following format (tab-separated fields):
<Database Name>	<Path to database>	<Functional annotation file>
For example, we can create the file mydb.list containing information of two databases:
DB1	/path/to/my/database1	/path/to/annotations/database1
DB2	/path/to/my/database2	/path/to/annotations/database2	 
and give it to SqueezeMeta using --extdb mydb.list.
Each database must be a fasta file of amino acid sequences, in which the sequences must have a header in the format:
>ID|...|Function
Where ID can be any identifier for the entry, and Function is the associated function that will be used for annotation. For example, a KEGG entry could be something like:
>WP_002852319.1|K02835
MKEFILAKNEIKTMLQIMPKEGVVLQGDLASKTSLVQAWVKFLVLGLDRVDSTPTFSTQKYE...
You can put anything you want between the first and last pipe, because these are the only fields that matter. For instance, the previous entry could also be:
>WP_002852319.1|KEGGDB|27/02/2019|K02835
MKEFILAKNEIKTMLQIMPKEGVVLQGDLASKTSLVQAWVKFLVLGLDRVDSTPTFSTQKYE...
Just remember not to put blank spaces, because they act as field separators in the fasta format.
This database must be formatted for DIAMOND usage. For avoiding compatibility issues between different versions of DIAMOND, it is advisable that you use the DIAMOND that is shipped with SqueezeMeta, and is placed in the bin directory of SqueezeMeta distribution. You can do the formatting with the command:
/path/to/SqueezeMeta/bin/diamond makedb -d /path/to/ext/db/dbname.dmnd --in /path/to/my/ext/dbname.fasta
For each database, you can OPTIONALLY provide a file with functional annotations, such as the name of the enzyme or whatever you want. Its location must be specified in the last field of the external database file. It must have only two columns separated by tabulators, the first with the function, the second with the additional information. For instance:
K02835	peptide chain release factor 1
The ORF table will show both the database ID and the associated annotation for each external database you provided.    Fastq read files’ directory (REQUIRED)

Restarting
----------

[-–restart]
    Restarts the given project where it stopped (project must be speciefied with the ``-p`` option) (will NOT overwite previous results, unless ``-–force_overwrite`` is also provided)

[-step <int>]
    In combination with ``–-restart``, restarts the project starting in the given step number (combine with ``force_overwrite`` to regenerate results)

[-–force_overwrite]:
    Do not check for previous results, and overwrite existing ones

Filtering
---------

[-–cleaning]
    Filters the input reads with Trimmomatic

[-cleaning_options <string>]
    Options for Trimmomatic (default: ``"LEADING:8 TRAILING:8 SLIDINGWINDOW:10:15 MINLEN:30"``).
    Please provide all options as a single quoted string

Assembly
--------

[-a <megahit|spades|rnaspades|spades-base|canu|flye>]
    assembler (default: ``megahit``)

[-assembly_options <string>]
    Extra options for the assembler (refer to the manual of the specific assembler).
    Please provide all the extra options as a single quoted string
    (e.g. ``-assembly_options "–opt1 foo –opt2 bar"``)

[-c|-contiglen <int>]
    Minimum length of contigs (default: ``200``)

[-extassembly <path>]
    Path to a file containing an external assembly provided by the user. The file must contain contigs
    in the fasta format. This overrides the assembly step of SqueezeMeta

[-extbins <path>]
    Path to a directory containing external genomes/bins provided by the user.
    There must be one file per genome/bin, each containing contigs in the fasta format.
    This overrides the assembly and binning steps

[-–sq|-–singletons]
    Unassembled reads will be treated as contigs and
    included in the contig fasta file resulting from the assembly. This
    will produce 100% mapping percentages, and will increase BY A LOT the
    number of contigs to process. Use with caution

[-contigid <string>]
    Prefix id for contigs (default: *assembler name*)

[–-norename]
    Don't rename contigs (Use at your own risk, characters like ``-`` in contig names may make the pipeline crash)

Annotation
----------

[-g <int>]
    Number of targets for DIAMOND global ranking during taxonomic assignment (default: ``100``)

[-db <path>]
    Specifies the location of a new taxonomy database (in DIAMOND format, .dmnd). See :ref:`Using external taxonomy database`

[–-nocog]
    Skip COG assignment

[-–nokegg]
    Skip KEGG assignment

[-–nopfam]
    Skip Pfam assignment

[-–fastnr]
    Run DIAMOND in ``-–fast`` mode for taxonomic assignment

[-–euk]
    Drop identity filters for eukaryotic annotation (Default: no). This is recommended for analyses in which the eukaryotic
    population is relevant, as it will yield more annotations (see the documentation for details).
    Note that, regardless of whether this option is selected or not, that result will be available as part of the aggregated
    taxonomy tables generated at the last step of the pipeline and also when loading the project into *SQMtools*
    (see the documentation for ``sqm2tables.py`` and also for the ``loadSQM`` function in the *SQMtools* R package),
    so this is only relevant if you are planning to use the intermediate files directly.

[-consensus <float>]
    Minimum percentage of genes assigned to a taxon in order to assign it as the consensus taxonomy
    for that contig (default: ``50``)

[-extdb <path>]
    File with a list of additional user-provided databases for functional annotations. See :ref:`Using external function databases`

[–D|–-doublepas]
    Run BlastX ORF prediction in addition to Prodigal. See :ref:`Extra sensitive ORFs`

Mapping
-------

[-map <bowtie|bwa|minimap2-ont|minimap2-pb|minimap2-sr>]
    Read mapper (default: ``bowtie``)

[-mapping_options <string>]
    Extra options for the mapper (refer to the manual of the specific mapper).
    Please provide all the extra options as a single quoted string
    (e.g. ``-mapping_options "–opt1 foo –opt2 bar"``)

Binning
-------

[-binners <string>]
    Comma-separated list with the binning programs to be used (available:
    maxbin, metabat2, concoct) (default: ``concoct,metabat2``)

[–-nobins]
    Skip all binning (Default: no). Overrides ``-binners``

[-–onlybins]
    Run only assembly, binning and bin statistics
    (including GTDB-Tk if requested)

[-extbins <path>]
    Path to a directory containing external genomes/bins provided by the user.
    There must be one file per genome/bin, each containing contigs in the fasta format.
    This overrides the assembly and binning steps

[-–nomarkers]
    Skip retrieval of universal marker genes from bins.
    Note that, while this precludes recalculation of bin
    completeness/contamination in SQMtools for bin refining, you will still
    get completeness/contamination estimates of the original bins obtained
    in SqueezeMeta

[-–gtdbtk]
    Run GTDB-Tk to classify the bins. Requires
    a working GTDB-Tk installation available in your environment

[-gtdbtk_data_path <path>]
    Path to the GTDB database, by default it is assumed to be present in
    ``/path/to/SqueezeMeta/db/gtdb``. Note that the GTDB database is NOT
    included in the SqueezeMeta databases, and must be obtained separately

Performance
-----------

[-t <integer>]
    Number of threads (default: ``12``)

[-b|-block-size <integer>]
    Block size for DIAMOND against the nr database (default: *calculate automatically*)

[-canumem <float>]
    Memory for Canu in Gb (default: ``32``)

[-–lowmem]
    Attempt to run on less than 16 Gb of RAM memory.
    Equivalent to: ``-b 3 -canumem 15``. Note that assembly may still fail due to lack of memory

Other
-----

[-–minion]
    Run on MinION reads. Equivalent to
    ``-a canu -map minimap2-ont``. If canu is not working for you consider using
    ``-a flye -map minimap2-ont`` instead

[-test <integer>]
    For testing purposes, stops AFTER the given step number

[-–empty]
    Create an empty directory structure and configuration files WITHOUT
    actually running the pipeline

Information
-----------

[-v]
    Display version number

[-h]
    Display help

Example SqueezeMeta call
========================

``SqueezeMeta.pl -m coassembly -p test -s test.samples -f mydir --nopfam -miniden 50``

This will create a project “test” for co-assembling the samples
specified in the file “test.samples”, using a minimum identity of 50%
for taxonomic and functional assignment, and skipping Pfam annotation.
The ``-p`` parameter indicates the name under which all results and data
files will be saved. This is not required for sequential mode, where the
name will be taken from the samples file instead. The ``-f`` parameter
indicates the directory where the read files specified in the sample
file are stored.

The samples file
================

The samples file specifies the samples, the names of their corresponding
raw read files and the sequencing pair represented in those files,
separated by tabulators.

It has the format: ``<Sample>   <filename>  <pair1|pair2>``

An example would be

::

   Sample1 readfileA_1.fastq   pair1
   Sample1 readfileA_2.fastq   pair2
   Sample1 readfileB_1.fastq   pair1
   Sample1 readfileB_2.fastq   pair2
   Sample2 readfileC_1.fastq.gz    pair1
   Sample2 readfileC_2.fastq.gz    pair2
   Sample3 readfileD_1.fastq   pair1   noassembly
   Sample3 readfileD_2.fastq   pair2   noassembly

The first column indicates the sample id (this will be the project name
in sequential mode), the second contains the file names of the
sequences, and the third specifies the pair number of the reads. A
fourth optional column can take the ``noassembly`` value, indicating
that these sample must not be assembled with the rest (but will be
mapped against the assembly to get abundances). This is the case for
RNAseq reads that can hamper the assembly but we want them mapped to get
transcript abundance of the genes in the assembly. Similarly, an extra
column with the ``nobinning`` value can be included in order to avoid
using those samples for binning. Notice that a sample can have more than
one set of paired reads. The sequence files can be in fastq or fasta
format, and can be gzipped. If a sample contains paired libraries, it is
the user’s responsability to make sure that the forward and reverse
files are truly paired (i.e. they contain the same number of reads in
the same order). Some quality filtering / trimming tools may produce
unpaired filtered fastq files from paired input files (particularly if
run without the right parameters). This may result in SqueezeMeta
failing or producing incorrect results.

Restart
=======

Any interrupted SqueezeMeta run can be restarted using the program the
flag ``--restart``. It has the syntax:

``SqueezeMeta.pl -p <projectname> --restart``

This command will restart the run of that project by reading the
progress.txt file to find out the point where the run stopped.

Alternatively, the run can be restarted from a specific step by issuing
the command:

``SqueezeMeta.pl -p <projectname> --restart -step <step_to_restart_from>``

By default, already completed steps will not be repeated when
restarting, even if requested with ``-step``. In order to repeat already
completed steps you must also provide the flag ``--force_overwrite``.

e.g. ``SqueezeMeta.pl --restart -p <projectname> -step 6 --force_overwrite``
would restart the pipeline from the taxonomic assignment of genes. The
different steps of the pipeline are listed in :doc:`scripts`.

Running scripts
===============

Also, any individual script of the pipeline can be run using the same
syntax:

``script <projectname>`` (for instance,
``04.rundiamond.pl <projectname>`` to repeat the DIAMOND run for the
project).
