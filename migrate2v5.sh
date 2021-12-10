#!/bin/bash -xe
# check.sh: Check versions of current DBs
#
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Tue 17 Sep 2019 03:24:57 PM EDT

#rm -f *taxid-map
~camacho/work/internal/blast/DBUpdates/make-taxid-map-ncbi.sh -a -p F -d rRNA_blastdb/ITS-protist_final.fsa    > ITS-protist_final.taxid-map   2>ITS-protist_final.err
~camacho/work/internal/blast/DBUpdates/make-taxid-map-ncbi.sh -a -p F -d rRNA_blastdb/ITS-animal2.fsa          > ITS-animal2.taxid-map         2>ITS-animal.err
~camacho/work/internal/blast/DBUpdates/make-taxid-map-ncbi.sh -a -p F -d rRNA_blastdb/ITS-plant2.fsa           > ITS-plant2.taxid-map          2>ITS-plant.err
#~camacho/work/internal/blast/DBUpdates/make-taxid-map-ncbi.sh -p F -d rRNA_typestrains/ITS_RefSeq_Fungi     > ITS_RefSeq_Fungi.taxid-map    2>ITS_RefSeq_Fungi.err
#~camacho/work/internal/blast/DBUpdates/make-taxid-map-ncbi.sh -p F -d rRNA_typestrains/16S_ribosomal_RNA    > 16S_ribosomal_RNA.taxid-map   2>16S_ribosomal_RNA.err

makeblastdb -blastdb_version 5 -parse_seqids -in ~mcveigh/rRNA_blastdb/ITS-protist_final.fsa -input_type fasta -taxid_map ITS-protist_final.taxid-map -dbtype nucl -title 'ITS-protist' -out ITS-protist-final
makeblastdb -blastdb_version 5 -parse_seqids -in ~mcveigh/rRNA_blastdb/ITS-animal2.fsa -input_type fasta -taxid_map ITS-animal2.taxid-map -dbtype nucl -title 'ITS-animal' -out ITS-animal
makeblastdb -blastdb_version 5 -parse_seqids -in ~mcveigh/rRNA_blastdb/ITS-plant2.fsa -input_type fasta -taxid_map ITS-plant2.taxid-map -dbtype nucl -title 'plant_ITS_blast' -out ITS-plant
