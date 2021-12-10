#!/bin/bash
# new-dbs-from-rich.sh: What this script does
#
# Author: Christiam Camacho (camacho@ncbi.nlm.nih.gov)
# Created: Mon 28 Oct 2019 04:38:21 PM EDT

sqsh-ms -m bcp -S MSSQL33 -D Blastdb2Entrez <<EOF
select created_at,UID,last_updated,file_path from BlastDBStage
where submitter_email like '%mcveigh%' and last_updated >= '2019-10-28'
order by last_updated;
go
EOF
exit

sqsh-ms -m pretty -S MSSQL33 -D Blastdb2Entrez <<EOF
select * from AliasUID where blastdb_UID = '108435734';
go
EOF
sqsh-ms -m pretty -S MSSQL33 -D Blastdb2Entrez <<EOF
select file_path from BlastDBStage where UID in (select id from AliasUID where blastdb_UID = '108435734');
go
EOF
