*******************
Advanced annotation
*******************

.. _Using external taxonomy database:
Using a user-supplied database for taxonomic annotation
=======================================================
LINK HERE FROM THE PARAMETERS SECTION

.. _Using external function database:
Using external databases for functional annotation
==================================================
Version 1.0 of SqueezeMeta implements the possibility of using one or several external databases (user-provided) for functional annotation. This is invoked using the ``--extdb`` option. The argument must be a file (external database file) with the following format (tab-separated fields):

::
 <Database Name>    <Path to database>    <Functional annotation file>

For example, we can create the file mydb.list containing information of two databases:

::
 
 DB1    /path/to/my/database1    /path/to/annotations/database1
 DB2    /path/to/my/database2    /path/to/annotations/database2

and give it to SqueezeMeta using ``--extdb mydb.list``.

Each database must be a fasta file of amino acid sequences, in which the sequences must have a header in the format:

::

 >ID|...|Function

Where ID can be any identifier for the entry, and Function is the associated function that will be used for annotation. For example, a KEGG entry could be something like:

::

 >WP_002852319.1|K02835
 MKEFILAKNEIKTMLQIMPKEGVVLQGDLASKTSLVQAWVKFLVLGLDRVDSTPTFSTQKYE...

You can put anything you want between the first and last pipe, because these are the only fields that matter. For instance, the previous entry could also be:

::
 >WP_002852319.1|KEGGDB|27/02/2019|K02835
 MKEFILAKNEIKTMLQIMPKEGVVLQGDLASKTSLVQAWVKFLVLGLDRVDSTPTFSTQKYE...

Just remember not to put blank spaces, because they act as field separators in the fasta format.
This database must be formatted for DIAMOND usage. For avoiding compatibility issues between different versions of DIAMOND, it is advisable that you use the DIAMOND that is shipped with SqueezeMeta, and is placed in the bin directory of SqueezeMeta distribution. You can do the formatting with the command:

``/path/to/SqueezeMeta/bin/diamond makedb -d /path/to/ext/db/dbname.dmnd --in /path/to/my/ext/dbname.fasta``

For each database, you can OPTIONALLY provide a file with functional annotations, such as the name of the enzyme or whatever you want. Its location must be specified in the last field of the external database file. It must have only two columns separated by tabulators, the first with the function, the second with the additional information. For instance:

``K02835    peptide chain release factor 1``

The ORF table (ADD LINK HERE!!) will show both the database ID and the associated annotation for each external database you provided.

.. _Extra sensitive ORFs:
Extra-sensitive detection of ORFs
=================================
LINK HERE FROM THE PARAMETERS SECTION
