#!/bin/bash

MYSQL=$(which mysql)

while true; do
    echo
    echo "== Création d'un utilisateur MySQL =="
    echo

    read -r -p "Entrez un nom de base de données [default: database_db] : " responseDBName

    case "$responseDBName" in
    *)
        if [ ! $responseDBName = 0 ]; then
            sqlDB=$responseDBName
        else
            sqlDB=database_db
        fi
        ;;
    esac

    echo

    read -r -p "${1} un nom d'utilisateur [default: database_user] : " responseDBUser

    case "$responseDBUser" in
    *)
        if [ ! $responseDBUser = 0 ]; then
            sqlUser=$responseDBUser
        else
            sqlUser=database_user
        fi
        ;;
    esac

    echo

    read -r -p "${1} un mot de passe [default: database_password] : " responseDBPass

    case "$responseDBPass" in
    *)
        if [ ! $responseDBPass = 0 ]; then
            sqlPass=$responseDBPass
        else
            sqlPass=database_password
        fi
        ;;
    esac

    read -r -p "Voulez vous que votre utilisateur ai un accès passe partout [root] ? [y/N] : " responseIsRoot

    case "$responseIsRoot" in
    [yY][eE][sS] | [yY] | [oO] | [oO][uU][iI])
	sqlUserRoot=true
	;;
    *)
	sqlUserRoot=false
	;;

    esac

    echo
    read -r -p "êtes vous sûr ? [y/N] : " responseDBConfirm

    case "$responseDBConfirm" in
    [yY][eE][sS] | [yY] | [oO][uU][iI] | [oO])
            
	if [[ $sqlUserRoot == true ]]; then
		Q2="GRANT ALL PRIVILEGES ON *.* TO '$sqlUser'@'localhost' IDENTIFIED BY '$sqlPass' WITH GRANT OPTION;"
	else
		Q2="GRANT ALL ON $sqlDB.* TO '$sqlUser'@'localhost' IDENTIFIED BY '$sqlPass';"
	fi

	    Q1="CREATE DATABASE IF NOT EXISTS $sqlDB;"
	    # Q2 IS ALREADY DEFINED UPSIDE
            Q3="FLUSH PRIVILEGES;"
            SQL="${Q1}${Q2}${Q3}"
            sudo $MYSQL -u root -e "$SQL"

	if [[ $sqlUserRoot == true ]]; then
		userIsRoot="Oui"
	else
		userIsRoot="Non"
	fi
	    # Debug mode
	    # echo -e "${SQL}"
	    ############

            echo
            echo "Nom de la base de données : $sqlDB"
            echo "Nom d'utilisateur : $sqlUser"
            echo "Mot de passe : $sqlPass"
	    echo "Compte admin : $userIsRoot"

            sleep 3
            echo
            echo "L'utilisateur ${sqlUser} qui a pour mot de passe ${sqlPass} a bien été créé avec la base de donnée ${sqlDB}.."
            echo
        break
        ;;
    *)
        false
        clear
        ;;
    esac
done
