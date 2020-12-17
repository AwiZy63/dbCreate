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

    echo
    read -r -p "êtes vous sûr ? [y/N] : " responseDBConfirm

    case "$responseDBConfirm" in
    [yY][eE][sS] | [yY] | [oO][uU][iI] | [oO])
            Q1="CREATE DATABASE IF NOT EXISTS $sqlDB;"
            Q2="GRANT ALL ON $sqlDB.* TO '$sqlUser'@'localhost' IDENTIFIED BY '$sqlPass';"
            Q3="FLUSH PRIVILEGES;"
            SQL="${Q1}${Q2}${Q3}"
            sudo $MYSQL -u root -e "$SQL"
            
            echo
            echo "Nom de la base de données : $sqlDB"
            echo "Nom d'utilisateur : $sqlUser"
            echo "Mot de passe : $sqlPass"

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
