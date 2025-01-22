*************************************
Explanation of SqueezeMeta algorithms
*************************************

.. _lca:
The LCA algorithm
=================

.. _euk annot:
Taxonomic annotation of eukaryotic ORFs
---------------------------------------
By default, SqueezeMeta applies `Luo et al. (2014) <https://pmc.ncbi.nlm.nih.gov/articles/PMC4005636/>`_ identity cutoffs in order to assign an ORF to a given taxonomic rank (see :ref:`lca`). In our tests, these cutoffs resulted in a very low percentage of annotation for eukaryotic ORFs.

The treatment of these ORFs differs depending on how :doc:`SqueezeMeta.pl <execution>`, :ref:`sqm_reads.pl <sqm_reads>` or :ref:`sqm_longreads.pl <sqm_longreads>` are launched, and the result files that are used afterwards.

- The raw results produced by :doc:`SqueezeMeta.pl <execution>`,  :ref:`sqm_reads.pl <sqm_reads>` and `sqm_longreads.pl <sqm_longreads>` will apply identity cutoffs to all taxa by default unless the flag ``--euk`` is passed when running the script, in which case the identity cutoffs will only be applied to eukaryotic reads.

    - An exception to this is the final step of the *SqueezeMeta* pipeline, which runs :ref:`sqm2tables.py <sqm2tables>` with default parameters, see :ref:`_sqm2tables in pipeline`. In that step, both types of results will be produced regardless of whether the ``--euk`` flag is passed or not, see below.

- When creating taxonomic aggregate tables with :ref:`sqm2tables.py <sqm2tables>` (for projects created with *SqueezeMeta.pl*) and :ref:`sqmreads2tables.py <sqmreads2tables>` (for projects created with :ref:`sqm_reads.pl <sqm_reads>` and `sqm_longreads.pl <sqm_longreads>`) three sets of results will be generated **regardless of whether the ``--euk`` flag was passed when running the script**.
  
    - *allfilter* files, containing ORF, contig and aggregate taxonomies obtained after applying identity filters to ALL taxa.
    - *prokfilter* files, containing ORF, contig and aggregate taxonomies obtained after applying identity filters to prokaryotic taxa only. This would replicate the behaviour of ``--euk`` flag.
    - *nofilter* files, containing ORF, contig and aggregate taxonomies obtained after applying NO identity filters at all.
  
  The advantage of this method is that there is no need to repeat the whole run to change the behaviour of identity cutoffs.

- When using :doc:`SQMtools` to analyze your data, you get to choose the behaviour of identity cutoffs (*allfilter*, *prokfilter*, *nofilter*) through the ``tax_mode`` parameter in the ``loadSQM`` and ``loadSQMlite`` functions (with the default being ``prokfilter``, i.e. using identity cutoffs for prokaryotes but not eukaryotes).

.. _consensus tax:
Consensus taxonomic annotation for contigs and bins
===================================================

.. _fun3:
The fun3 algorithm
==================

.. _doublepass:
Doublepass: blastx on contig gaps
=================================

.. _disparity:
Disparity calculation
=====================
