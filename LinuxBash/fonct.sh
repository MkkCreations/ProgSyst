#! /bin/bash 
# compatibilité du script : bash 
# Faire une pause écran 
function pause { 
  echo "Appuyez sur une touche pour continuer" 
  read x 
}  
# Savoir si un utilisateur est défini sur le système 
function exist_user { 
 echo -n "Saisir le nom d'un utilisateur : "  # bash 
 read user 
 if grep -q "^$user" /Users  ; then 
   return 0 
 fi 
 return 1  
} 
# Programme principal  
while true  
do 
 clear 
 echo "- 1 - Savoir si un utilisateur est défini" 
 echo "- 2 - Fin" 
 echo -n "Votre choix : " 
 read choix 
 case $choix in 
   1)   # Appel de la fonction  
        # Test du statut de retour de la fonction ($?) 
       if exist_user    
       then 
         echo "L'utilisateur $user est défini" 
       else 
         echo "L'utilisateur $user n'est pas défini" 
       fi 
       pause           # Appel de la fonction pause 
       ;; 
   2) 
    echo "Bye" 
    exit 0 ;; 
esac 
done 
