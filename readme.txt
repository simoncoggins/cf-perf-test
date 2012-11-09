Instructions to reproduce:

1. Installed moodle 2.4 master using postgres 9.1 database
2. Created 4 user profile custom fields ('check', 'text', 'area' and 'num')
3. Used a script to generate data for 10000 users:
    php bulk.php > bulk.txt
4. Ran bulk import on bulk.txt to import the users and their custom field data
5. Ran an SQL script (cf.sql) to create the ELIS and user_extend schema and populate the data
   from the existing custom field tables
6. Ran each case listed in perf-tests.sql one at a time and measured the timing of the overall queries
7. Ran the drop-cf.sql script before each run and recorded the first time, then an average of several subsequent times

