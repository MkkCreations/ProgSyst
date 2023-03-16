#! /bin/bash 


function config() { 
    echo -n "$(tput setaf 2) activer 'no ip domain-lookup' (O/n) $(tput setaf 4) " 
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

    echo "$(tput setaf 2)réglage de la date et l'heure identiques à celles de votre système Linux"
    echo "clock timezone `date +%Z`" >> $1.txt
    echo "clock summer-time `date +%Z` recurring" >> $1.txt

    echo -e '!\n! \nconfigure terminal' >> $1.txt

    while true; do
        echo -n "Nom du Hôte: $(tput setaf 4)"
        read hote
        if [[ $hote =~ ^[0-9] ]]; then
            echo "$(tput setaf 1)Le nom ne peut pas commencer par un chiffre"
        elif (( ${#hote} > 64 )); then
            echo "$(tput setaf 1)Le nom ne peut pas dépasser 64 caractères"
        elif [[ -z $hote ]]; then
            echo "hostname $1" >> $1.txt
            break
        else
            echo "hostname $hote" >> $1.txt
            break
        fi
    done

    echo -e '!\n!' >> $1.txt

    echo -n "$(tput setaf 2)Bannière: $(tput setaf 4) "
    read banniere
    if [[ -z $banniere ]]; then
        echo "$(tput setaf 1)banner motd Acces Interdit" >> $1.txt
    else
        echo "banner motd $banniere" >> $1.txt
    fi

    echo -e '!\n!' >> $1.txt

    echo -n "$(tput setaf 2)Mot de passe pour Console (cisco): $(tput setaf 4) "
    read pwdConsole 
    if [ -z $pwdConsole ];  then
        echo "console secret cisco" >> $1.txt
    else
        echo "console secret $pwdConsole" >> $1.txt
    fi

    echo -e '!\n!' >> $1.txt

    echo -n "$(tput setaf 2)Mot de passe pour Enable (cisco): $(tput setaf 4) "
    read pwdPrivilege
    if [ -z $pwdPrivilege ];  then
        echo "enable secret cisco" >> $1.txt
    else
        echo "enable secret $pwdPrivilege" >> $1.txt
    fi

    echo -e '!\n!' >> $1.txt

    echo -n "$(tput setaf 2) VTY 0 4 (cisco) (O/n) $(tput setaf 4) "
    read vty
    case $vty in
        o|O)
            echo "line vty 0 4" >> $1.txt
            echo "password cisco" >> $1.txt
        ;;
        n|N)
            vty "$1"
            
            echo -n $(tput setaf 2) "Mot de passe pour VTY (cisco): $(tput setaf 4) "
            read pwdVty
            if [ -z $pwdVty ];  then
                echo "password cisco" >> $1.txt
            else
                echo "password $pwdVty" >> $1.txt
            fi
        ;;
    esac

    echo -e '!\n!' >> $1.txt

    echo -n "$(tput setaf 2) Chiffrement des mdp ? (o/N) $(tput setaf 4) "
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
        echo -n "$(tput setaf 2) Adresse IP et masque (Vlan 1) (ip/mask) : $(tput setaf 4) "
        read vlan
        ip=$(echo -n $vlan | cut -d '/' -f 1)
        m=$(echo -n $vlan | cut -d '/' -f 2)
        if [[ $ip =~  ((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4} ]] && [[ $m =~ ([0-32]) ]]; then
            echo "interface Vlan 1" >> $1.txt
            echo "ip address $ip/$m" >> $1.txt
            break
        else
            echo "$(tput setaf 1) Nombre invalide"
        fi
    done

    echo -e '!\n!' >> $1.txt

    echo -n "$(tput setaf 2) Activer le SSH ? (o/N) $(tput setaf 4) "
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
    echo -n "$(tput setaf 2) VTY (0 4)[0-15]: $(tput setaf 4) "
    read vty
    if [[ $vty =~ ^[0-9]+\ [0-9]+$ ]]; then
        val1=$(echo $vty | cut -d' ' -f1)
        val2=$(echo $vty | cut -d' ' -f2)
        
        if (( $val1 >= 0 && $val1 <= 15 )) && (( $val2 >= 0 && $val2 <= 15 )); then
            if (( $val1 <= $val2 )); then
                echo "line vty $val1 $val2" >> $1.txt
                break
            else
                echo "$(tput setaf 1) Le premier valeur doit être inférieur au deuxième"
            fi
        else
            echo "$(tput setaf 1) Les valeurs doivent être comprises entre 0 et 15"
        fi
    else
        echo "$(tput setaf 1) Les valeurs doivent être comprises entre 0 et 15 avec un espace entre les deux valeurs"
    fi
done
}


function sshConfig() {
    while true; do
        echo -n "$(tput setaf 2) Nom de domaine de ssh (tp.local): $(tput setaf 4) "
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
        echo -n "$(tput setaf 2) Nom de modulus SSH [360-2048]: $(tput setaf 4) "
        read modulus
        if [[ $modulus -ge 360 && $modulus -le 2048 ]]; then
            echo "crypto key generate rsa general-keys modulus  $modulus" >> $1.txt
            break
        else
            echo "$(tput setaf 1) Le modulus doit être compris entre 360 et 2048"
        fi
    done

    echo -e '!\n!' >> $1.txt

    while true; do
        echo -n "$(tput setaf 2) Username: $(tput setaf 4) "
        read utilisateur
        if [ -z $utilisateur ]; then
            echo "$(tput setaf 1) Invalid username"
        else
            echo -n "$(tput setaf 2) Password: $(tput setaf 4) "
            read passw
            if [ -z $passw ]; then
                echo "$(tput setaf 1) Invalid password"
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
    echo "$(tput setaf 3) Bienvenue dans le script de configuration de switch Cisco"
    echo "Veuillez choisir le type de Dispositif"
    echo "$(tput setaf 5) 1 - Switch"
    echo "$(tput setaf 6) 2 - Routeur"
    echo "$(tput setaf 1) 4 - Quitter"
    echo -n "$(tput setaf 3) Votre choix: "
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