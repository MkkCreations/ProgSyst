#Ex 1
    wc -l logsNasa.log
    #1891714 lignes

#Ex 2
    ls -sh logsNasa.log
    #196M

#Ex 3
    grep "/shuttle/countdown/" logsNasa.txt >> rebours.log

#Ex 4 
    time grep "/shuttle/countdown/" logsNasa.txt >> rebours2.log
    #real    0m0,024s
