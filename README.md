                                            ________________________
                                                mp3album.sh	
                                            ________________________

Tri de musique Version Béta 07/01/2013

Auteurs:	ANDOLERZAK Abdelkarim
		KEYNES 	   Timothy

--------------------------------
Utilisation générale du programe:
---------------------------------
Ce programme permet de trier des musiques rangées 'en vrac' selon des critères tels que l'auteur, le genre ou encore l'album. Si il y a multiclés, alors separer les clés par des virgules, exemple: album,interprete,genre


->Localisez premièrement le répertoire source avec les musiques ainsi que le répertoire de destination(Pas besoin de créer un dossier pour les recevoir, l'application s'occupera de créer un dossier 'RANGEMENT')

->Pour executer le programme, faites comme ceci:
.\mp3album.sh [ARGUMENTS][CHEMIN]
Avec comme ARGUMENTS:
.-d / --dir  suivi du répertoire de destination des musiques (OBLIGATOIRE)
.-k / --key suivi des critères de tri (interprete/album/genre) (au moins un OBLIGATOIRE)
.-v / --verbose pour afficher les opérations faites à l'écran (OPTIONNEL)
.-m / --move pour déplacer les fichiers triés et donc ne les garder qu'une seule fois(OPTIONNEL). Par défault, les musiques sont juste copiées.
.-n / --dry-run S'accompagnant d'un '-v' pour afficher les actions faites sans le faire réellement, peut servir pour tester le programme.(OPTIONNEL)
.-r /--recursive Pour explorer les sous dossiers du répertoire source indiqué. (OPTIONNEL)

Pour avoir l'aide dans l'invite de commande:
.\mp3album.sh -h ou 
.\mp3album.sh --help

Le CHEMIN désigne le chemin de destination des musiques qui seront triées (OBLIGATOIRE)
On suppose que l'on range les musiques dans le dossier courant, et que le repertoire source se nomme VRAC2 et est dans le repertoire courant

#test de l'argument multi clés avec les racourcis des arguments et avec leur nom complet
./mp3album.sh -d ./  -v -k interprete,genre,album ./VRAC2
./mp3album.sh --dir ./  --verbose --key interprete,album,genre ./VRAC2

#test de l'argument help
./mp3album.sh -h
./mp3album.sh --help

#tests non fonctionnels (pas de repertoire de destination)
./mp3album.sh 
./mp3album.sh -d
./mp3album.sh -dir

#Pas de clés de tri ou clé incorrecte
./mp3album.sh -d ~/M111/Projet ./VRAC2
./mp3album.sh -k interprete,genre,albumeee -d ./ ./VRAC2
./mp3album.sh -k interpreteee -d ./ ./VRAC2

#Repertoire source non existant
./mp3album.sh -dir ./ -verbose -key interprete ./VRAC2

