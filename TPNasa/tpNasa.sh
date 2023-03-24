#Ex 1
#Combien de lignes contient ce fichier ?
    wc -l logsNasa.log
    #1891714 lignes

#Ex 2
#Quelle est la taille de ce fichier en Mo ?
    ls -sh logsNasa.log
    #196M

#Ex 3
#La page /shuttle/countdown/ annonce le temps restant avant le lancement de la prochaine fusée.
#Avec la commande grep, créez un fichier rebours.log qui contient uniquement ces lignes.
    grep "/shuttle/countdown/" logsNasa.log >> rebours.log
#Combien de lignes sont-elles concernées ?
    grep "/shuttle/countdown/" logsNasa.log | wc -l
    #175428

#Ex 4 
#Quelle a été la durée d'exécution de cette commande ?
    time grep "/shuttle/countdown/" logsNasa.log >> rebours.log
    #3,79s user 0,12s system 98% cpu 3,973 total

#Ex 5
#Au début de chaque ligne, on trouve l'IP ou le nom du site de provenance de l'utilisateur. On voudrait faire des statistiques à partir de ces informations.
#Gardez uniquement la première colonne du fichier rebours.log. Mettre le résultat dans rebours2.log
    awk '{print $1}' rebours.log >> rebours2.log

#Ex 6
#Triez dans l'ordre alphabétique et mettre le résultat dans rebours3.log
    sort rebours2.log >> rebours3.log

#Ex 7
#Supprimez les doublons et mettre le résultat dans rebours4.log
    uniq rebours3.log >> rebours4.log

#Ex 8
#En partant de rebours3.log, on veut avec la commande uniq, compter le nombre de ligne dupliquées. On met le résultat dans rebours5.log
    uniq -c rebours3.log >> rebours5.log

#Ex 9
#Trouver à partir de rebours5.log les 10 adresses IP ou domaines qui ont le plus accédé au site de la NASA ce mois-là.
    sort -r rebours5.log | head -10  >> rebours6.log
#Ex 10
#En repartant du fichier log d'origine pouvez-vous dire combien il y a eu de connexion pour chacune des journées du mois concerné ?
    awk '{print $4 $5}' logsNasa.log | sed 's/.*\[//; s/\:.*//' | uniq -c

    