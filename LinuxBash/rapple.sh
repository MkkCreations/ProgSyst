

grep "f" fonct.sh
#Pour chercher la lettre "f" dans un ficher
grep "^[f]" fonct.sh
#Pour chercher des mot qui commence avec la lettre "f"
grep -v "^f" fonct.sh
#Pour chercher des mot qui ne commence pas avec la lettre "f" (recherche inverse)

sed -e 's/hola/Salut/g' nomFicher
#Pour chancher tous les mot 'hola' pas 'Salut' dans le ficher nomFicher
sed -e '/^ *$/d' nomFicher
#Pour supprimer toutes les lignes vides

cd 
ls 
wc 
ping 
cut 
diff fic1 fic2 #comparer le contenu de deux fichers
cmp fic1 fic2 #comparer le contenu caractere par caracter et s'arrete dès la premiere diference