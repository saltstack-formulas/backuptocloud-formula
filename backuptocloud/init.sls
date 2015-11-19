#!pydsl

import datetime
 
bkdeps = state('bkdeps')
bkdeps.pkg.installed(name='python-mysqldb')
  
prep = state('prep')
prep.mysql_user.present(host='localhost',allow_passwordless=True,connection_pass=__pillar__['gogo']).require(pkg='python-mysqldb')
   
for name,data in __pillar__['sites'].items(): # iterates of a client's list of sites in pillar
    dbname = data['db_name']
    remote_folder = data['backup_folder']
        
prep.mysql_grants.present(user='backupuser',grant='select,lock tables',database=dbname+'.*',connection_pass=__pillar__['gogo'])
         
tod = datetime.datetime.today().strftime('%m%d%Y_%H%M')
backup = state('backup')
 
for name,data in __pillar__['sites'].items(): # iterates of a client's list of sites in pillar
    dbname = data['db_name']
    file = "%(db)s_%(tod)s.sql" % {'db': dbname, 'tod':tod}
    command = "mysqldump -usophic %(db)s > /tmp/%(file)s" % {'db': dbname, 'file':file} # this should be relative to the used Db backend. The command assumes only mysql dbs.
      
backup.mysql_database.present(name=dbname,connection_pass=__pillar__['gogo'])
backup.cmd.run(name=command, shell='/bin/bash').require(mysql_database=dbname).require_in(module='backup')
backup.module.run(name=__pillar__['backup']['location']+'.put', bucket=__pillar__['backup']['bucket_name'], path="clienta/"+file,local_file="/tmp/"+file)
