backup To Cloud
===============

backup to cloud
---------------

Use pillar and scheduler to backup something, anything to the cloud.


Synopsis
--------
This is a full example of using a both git backed pillar and states to implement a scheduler that makes daily mysql db dumps and uploads them to s3. Still needs to be made generic enough to handle multiple DB types and remote data stores. 

- pillar.top.sls.example: a pillar top file that shows how the schedule and site info is made available on a per client/minion basis. 
- backup/init.sls: This verifies that there exists a special DB user for backups and grants the need grants for all listed DBs in pillar (for clienta). Creates a datestamped named database dump based on the settings in pillar then uploads it to s3. 
- clienta pillar: a pillar that lists the client site(s), backup location and scheduler. 
- sec pillar: passwords and such... Yeah. not cool. but whatever... 
- backup pillar: s3 API creds. Yeah, I know but they have to be somewhere.
