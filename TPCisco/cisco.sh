#! /bin/bash 


function config() { 
    echo -n "activer 'no ip domain-lookup' (O/n) " 
    read x 
    case $x in 
        o|O) 
            echo "no ip domain-lookup" >> $1.txt
        ;; 
        n) 
            echo "ip domain-lookup" >> $1.txt
        ;; 
        *) 
            echo "no ip domain-lookup" >> $1.txt 
        ;; 
    esac

    echo "réglage de la date et l'heure identiques à celles de votre système Linux"
    echo "clock timezone `date +%Z`" >> $1.txt
    echo "clock summer-time `date +%Z` recurring" >> $1.txt

    echo -e '!\n! \nconfigure terminal' >> $1.txt

    while true; do
        echo -n "Nom du switch: "
        read hote
        if [[ $hote =~ ^[0-9] ]]; then
            echo "Le nom ne peut pas commencer par un chiffre"
        elif [ -z $hote ]; then
            echo "hostname Switch" >> $1.txt
            break
        else
            echo "hostname $hote" >> $1.txt
            break
        fi
    done

    echo -e '!\n!' >> $1.txt

    echo -n "Bannière: "
    read banniere
    if [ -z $banniere ]; then
        echo "banner motd Acces Interdit" >> $1.txt
    else
        echo "banner motd $banniere" >> $1.txt
    fi

    echo -e '!\n!' >> $1.txt

    echo -n "Mot de passe pour Console (cisco): "
    read pwdConsole 
    if [ -z $pwdConsole ];  then
        echo "console secret cisco" >> $1.txt
    else
        echo "console secret $pwdConsole" >> $1.txt
    fi

    echo -e '!\n!' >> $1.txt

    echo -n "Mot de passe pour Enable (cisco): "
    read pwdPrivilege
    if [ -z $pwdPrivilege ];  then
        echo "enable secret cisco" >> $1.txt
    else
        echo "enable secret $pwdPrivilege" >> $1.txt
    fi

    echo -e '!\n!' >> $1.txt

    echo -n "VTY 0 4 (cisco) (O/n) "
    read vty
    case $vty in
        o|O)
            echo "line vty 0 4" >> $1.txt
            echo "password cisco" >> $1.txt
        ;;
        n|N)
            vty "$1"
            
            echo -n "Mot de passe pour VTY (cisco): "
            read pwdVty
            if [ -z $pwdVty ];  then
                echo "password cisco" >> $1.txt
            else
                echo "password $pwdVty" >> $1.txt
            fi
        ;;
    esac

    echo -e '!\n!' >> $1.txt

    echo -n "Chiffrement des mdp ? (o/N)"
    read crypt
    case $crypt in
        o|O)
            echo "service password-encryption" >> $1.txt
        ;;
        n|N)
            echo "no service password-encryption" >> $1.txt
        ;;
        *)
            echo "no service password-encryption" >> $1.txt
        ;;
    esac

    echo -e '!\n!' >> $1.txt

    while true; do
        echo -n "Adresse IP et masque (Vlan 1) (ip/mask) : "
        read vlan
        ip=$(echo -n $vlan | cut -d '/' -f 1)
        m=$(echo -n $vlan | cut -d '/' -f 2)
        if [[ $ip =~  ((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4} ]] && [[ $m =~ ([0-32]) ]]; then
            echo "interface Vlan 1" >> $1.txt
            echo "ip address $ip/$m" >> $1.txt
            break
        else
            echo "Nombre invalide"
        fi
    done

    echo -e '!\n!' >> $1.txt

    echo -n "Activer le SSH ? (o/N) "
    read ssh
    case $ssh in
        o|O)
            sshConfig "$1"
        ;;
        n|N|*)
            echo "no SSH config" >> $1.txt
        ;;
    esac

    echo -e '!\n!' >> $1.txt
    showInterface "$1"
}


function vty() {
   while true; do
    echo -n "VTY (0 4)[0-15]: "
    read vty
    if [[ $vty =~ ^[0-9]+\ [0-9]+$ ]]; then
        val1=$(echo $vty | cut -d' ' -f1)
        val2=$(echo $vty | cut -d' ' -f2)
        
        if (( $val1 >= 0 && $val1 <= 15 )) && (( $val2 >= 0 && $val2 <= 15 )); then
            if (( $val1 <= $val2 )); then
                echo "line vty $val1 $val2" >> $1.txt
                break
            else
                echo "Le premier valeur doit être inférieur au deuxième"
            fi
        else
            echo "Les valeurs doivent être comprises entre 0 et 15"
        fi
    else
        echo "Les valeurs doivent être comprises entre 0 et 15 avec un espace entre les deux valeurs"
    fi
done
}


function sshConfig() {
    while true; do
        echo -n "Nom de domaine de ssh (tp.local): "
        read domaine
        if [ -z $domaine ]; then
            echo "ip domain-name tp.local" >> $1.txt
            break
        else
            echo "ip domain-name $domaine" >> $1.txt
            break
        fi
    done

    echo -e '!\n!' >> $1.txt

    while true; do
        echo -n "Nom de modulus SSH [360-2048]: "
        read modulus
        if [[ $modulus -ge 360 && $modulus -le 2048 ]]; then
            echo "crypto key generate rsa general-keys modulus  $modulus" >> $1.txt
            break
        else
            echo "Le modulus doit être compris entre 360 et 2048"
        fi
    done

    echo -e '!\n!' >> $1.txt

    while true; do
        echo -n "Username: "
        read utilisateur
        if [ -z $utilisateur ]; then
            echo "Invalid username"
        else
            echo -n "Password: "
            read passw
            if [ -z $passw ]; then
                echo "Invalid password"
            else
                echo "username $utilisateur privilege 15 secret $passw" >> $1.txt
                break
            fi
        fi
    done

    echo -e '!\n!' >> $1.txt

    vty "$1"
    echo "transport input ssh" >> $1.txt
}


function showInterface() {
    interfaces="Interface IP-Address OK? Method Status Protocol
        FastEthernet0/0 unassigned YES manual down up 
        FastEthernet0/1 unassigned YES manual down down 
        Serial0/0 unassigned YES manual down up "

    echo "show ip interface brief" >> $1.txt
    echo "$interfaces" | column -t >> $1.txt
    echo -e '!\n!'
    echo "show ip interface brief"
    echo "$interfaces" | column -t
}


function main() {
    echo "Bienvenue dans le script de configuration de switch Cisco"
    echo "Veuillez choisir le type de Dispositif"
    echo "1 - Switch"
    echo "2 - Routeur"
    echo "4 - Quitter"
    echo -n "Votre choix: "
    read choix
    case $choix in
        1) 
            config "switch"
        ;;
        2) 
            config "routeur"
        ;;
        4) 
            exit
        ;;
        *) 
            echo "Choix invalide"
            main
        ;;
    esac
}
main