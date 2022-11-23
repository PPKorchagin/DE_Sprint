hdfs dfs -copyFromLocal vim1.txt /user/cloudera/

hdfs dfs -copyFromLocal vim2.txt /user/cloudera/

hdfs dfs -copyFromLocal vim3.txt /user/cloudera/

hdfs dfs -copyFromLocal vim4.txt /user/cloudera/

****
-rw-r--r--   3 root cloudera    1275160 2022-11-23 08:55 /user/cloudera/vim1.txt                                        
-rw-r--r--   3 root cloudera    1366235 2022-11-23 08:55 /user/cloudera/vim2.txt                                        
-rw-r--r--   3 root cloudera    1476330 2022-11-23 08:55 /user/cloudera/vim3.txt                                        
-rw-r--r--   3 root cloudera    1246282 2022-11-23 08:56 /user/cloudera/vim4.txt
****

hdfs dfs -cat /user/cloudera/* | hdfs dfs -appendToFile - /user/cloudera/voyna-i-mir.txt

hdfs dfs -chmod 755 "/user/cloudera/vim*.txt" 

hdfs dfs -ls /user/cloudera/
****
-rwxr-xr-x   3 root cloudera    1275160 2022-11-23 08:55 /user/cloudera/vim1.txt                                        
-rwxr-xr-x   3 root cloudera    1366235 2022-11-23 08:55 /user/cloudera/vim2.txt                                        
-rwxr-xr-x   3 root cloudera    1476330 2022-11-23 08:55 /user/cloudera/vim3.txt                                        
-rwxr-xr-x   3 root cloudera    1246282 2022-11-23 08:56 /user/cloudera/vim4.txt                                        
-rw-r--r--   3 root cloudera    5364007 2022-11-23 09:10 /user/cloudera/voyna-i-mir.txt          
***

hdfs dfs -du -h /user/cloudera/
***
719.3 K  719.3 K  /user/cloudera/vim1.txt

752.3 K  752.3 K  /user/cloudera/vim2.txt

823.4 K  823.4 K  /user/cloudera/vim3.txt

681.6 K  681.6 K  /user/cloudera/vim4.txt

2.9 M    2.9 M    /user/cloudera/voyna-i-mir.txt
***
hdfs dfs -setrep 2 /user/cloudera/*

hdfs dfs -du -h /user/cloudera/

***
719.3 K  1.4 M  /vim1.txt

752.3 K  1.5 M  /vim2.txt

823.4 K  1.6 M  /vim3.txt

681.6 K  1.3 M  /vim4.txt

2.9 M    5.8 M  /voyna-i-mir.txt

***
hdfs dfs -cat /voyna-i-mir.txt | wc -l
***
10272
***