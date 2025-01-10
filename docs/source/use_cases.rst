*********
Use cases
*********

Choosing an assembly strategy
=============================

SqueezeMeta can be run in four different modes, depending of the type of
multi-metagenome support. These modes are:

-  *Sequential mode:* All samples are treated individually and analysed
   sequentially.

-  *Coassembly mode:* Reads from all samples are pooled and a single
   assembly is performed. Then reads from individual samples are mapped
   to the coassembly to obtain gene abundances in each sample. Binning
   methods allow to obtain genome bins.

-  *Merged mode:* if many big samples are available, co-assembly could
   crash because of memory requirements. This mode achieves a comparable
   resul with a procedure inspired by the one used by Benjamin Tully for
   analysing TARA Oceans data (https://dx.doi.org/10.17504/protocols.io.hfqb3mw).
   Briefly, samples are assembled individually and the resulting contigs are
   merged in a single co-assembly. Then the analysis proceeds as in the
   co-assembly mode. This is not the recommended procedure (use
   co-assembly if possible) since the possibility of creating chimeric
   contigs is higher. But it is a viable alternative in smaller computers in
   which standard co-assembly is not feasible.

-  *Seqmerge mode:* This is intended to work with more samples than the
   merged mode. Instead of merging all individual assemblies in a single
   step, which can be very computationally demanding, seqmerge works
   sequentially. First, it assembles individually all samples, as in
   merged mode. But then it will merge the two most similar assemblies.
   Similarity is measured as Amino Acid Identity values using the
   wonderful CompareM software by Donovan Parks. After this first
   merging, it again evaluates similarity and merge, and proceeds this
   way until all metagenomes have been merged in one. Therefore, for n
   metagenomes, it will need n-1 merging steps.

Note that the *merged* and *seqmerge* modes work well as a substitute of
coassembly for running small datasets in computers with low memory
(e.g. 16 Gb) but are very slow for analising large datasets (>10
samples) even in workstations with plenty of resources. Still, setting
``-contiglen`` to 1000 or higher can make *seqmerge* a viable strategy
even in those cases. Otherwise, we recommend to use either the
sequential or the co-assembly modes.

Regarding the choice of assembler, MEGAHIT and SPAdes work better with
short Illumina reads, while Canu and Flye support long reads from PacBio
or ONT-Minion. MEGAHIT (the default in SqueezeMeta) is more
resource-efficient than SPAdes, consuming less memory, but SPAdes
supports more analysis modes and produces slightly better assembly
statistics. SqueezeMeta can call SPAdes in three different ways. The
option ``-a spades`` is meant for metagenomic datasets, and will
automatically add the flags ``–meta -k 21,33,55,77,99,127`` to the
*spades.py* call. Conversely, ``-a rnaspades`` will add the flags
``–rna -k 21,33,55,77,99,127``. Finally, the option ``-a spades_base``
will add no additional flags to the *spades.py* call. This can be used in
conjunction with ``–assembly options`` when one wants to fully customize
the call to SPAdes, e.g. for assembling single cell genomes.

Analyzing user-supplied assemblies or bins
==========================================

An user-supplied assembly can be passed to SqueezeMeta with the flag
``-extassembly <your_assembly.fasta>``. The contigs in that fasta file
will be analyzed by the SqueezeMeta pipeline starting from step 2.
With this, you will be able to annotate your assembly, estimate its
abundance in your metagenomes/metatranscriptomes, and perform binning on it.

Additionally, a set of pre-existing genomes and bins can be passed to
SqueezeMeta with the flag ``-extbins <path_to_dir_with_bins>``. This will
work similarly to ``-extassembly``, but SqueezeMeta will treat each fasta
file in the input directory as an individual bin.
