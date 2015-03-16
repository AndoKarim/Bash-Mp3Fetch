
#!/bin/bash
typeset -i verbose=0 help=0 dryrun=0 recursive=0 move=0 nbrKey=0 j=0

#FONCTIONS
die() {
    echo "$@" >&1
    exit 1
}

help() {
	cat << FIN 
		 NOM
			 mp3album
		 SYNOPSIS
			 organise des fichiers mp3 en fonction de certains tags
<<<<<<< HEAD
			 mp3album.sh [OPTION...] [chemin...]
=======
			 mp3album.sh [OPTION...] [CHEMIN...]
>>>>>>> origin/master
		 OPTIONS
			 -h, --help affiche l'aide et termine
			 -v, --verbose affiche les opérations effectuées \(sinon mode silencieux\)
			 -n, --dry-run essai pour voir sans modifier les fichiers 
			 -k, --key organisation : clé1, clé2, clé3 || clé : album|genre|interprete
			 -d, --dir chemin racine destination des morceaux triés
			 -m, --move déplace les fichiers
			 -r, --recursive explore les sous répertoires des chemins sources
FIN
}

tagID3V2 ()
{
    case $1 in
		"interprete")
	    	echo "^TPE";;
		"album")
	    	echo "^TAL";;
		"genre")
	   		echo "^TCO";;
		*)
	   		die;;
    esac
}

#GESTION DES ARGUMENTS-----------------------------------------------------------------
while (( $# )); do
    case $1 in
	-d|--dir)
	    [[ -n $dir ]] && die "Argument --dir en double"
	    dir=$2
	    shift;;
	-k|--key)
	    if [[ -z $key ]]; then key=$2; else key="$key,$2"; fi
	    shift;;
	-r|--recursive)
	    recursive=1;;
	-v|--verbose)
	    verbose=1;;
	-m|--move)
	    move=1;;
	-n|--dry-run)
	    dryrun=1;;
	-h|--help)
	    help
	    exit 852
	    ;;
	-*)
		die "Option $1 invalide";;
	*) 
		break;;
    esac
    shift
done

#EXCEPTIONS/AGRGUMENTS-----------------------------------------------------------------
[[ -z $dir ]] && die "Pas de direction (--dir) indique"
[[ -z $key  ]] && die "Pas de cle de triage (--key) indique"
[[ $# -eq 0 ]] && die "Pas de dossier source indique"
chemin_musique=$1

#TEST TEMPORAIRE PERSO SUPPRIMANT RANGEMENT POUR EVITER L'EXCEPTION
cd $dir
if [ -d RANGEMENT ]; then	rm -r ./RANGEMENT; fi

#TRAITEMENT DES CLEFS DE TRIAGE
while [[ -n $key ]]; do
	case $key in
	*,*)
		nbrKey=2
		if [[ -z $cle1 ]]; then cle1=${key%%,*}; key=${key#*,}
	    elif [[ -z $cle2 ]]; then cle2=${key%%,*}; key=${key#*,}
	    else die "Trop de cle de triage (3 maximums)"
	    fi;;
	*)
		((nbrKey++))
		if [[ -z $cle1 ]]; then cle1=$key
	    elif [[ -z $cle2 ]]; then cle2=$key
	    elif [[ -z $cle3 ]]; then cle3=$key
	    else die "Trop de cle de triage (3 maximums)"
	    fi
	    key=;;
    esac

    if ! [[ $cle1 =~ ^interprete$|^genre$|^album$ ]]; then die "cle de triage incorrecte, $cle1"; fi
    if ! [[ $cle2 =~ ^interprete$|^genre$|^album$|^$ ]]; then die "cle de triage incorrecte, $cle2"; fi
    if ! [[ $cle3 =~ ^interprete$|^genre$|^album$|^$ ]]; then die "cle de triage incorrecte, $cle3"; fi
done

#TRAITEMENT DES ARGUMENTS
if (($verbose)); then options="--verbose"; fi
if (($move)); then action="mv"; else action="cp"; fi
if (($verbose)); then
echo "Rangement des mp3 de $chemin_musique classes par $cle1 $cle2 $cle3 dans le repertoire $dir"; fi

#TEST SI RANGEMENT EXISTE SINON LE CREER
cd $dir
if [ -d RANGEMENT ]; then echo "Erreur, Un dossier RANGEMENT existe deja a la destination" && exit 798 
else mkdir RANGEMENT; fi

#TRAITEMENT-----------------------------------------------------------------
cd $chemin_musique

#BOUCLE PASSANT POUR TOUS LES FICHIERS
IFS=$'\n'
for i in $(if (($recursive)); then find -name \*.mp3; else ls *.mp3; fi)
do
	if (($verbose)); then echo "Traitement de la musique $i"; fi
	
	#Récupere les clefs nécessaires au triage
	if [[ -n $cle1 ]]; then
		tmp=$(id3v2 -l "$i" | grep $(tagID3V2 $cle1))
		tagA=${tmp##*: }
		if [[ -z $tagA ]]; then tagA=INCONNU; fi
		destination=${dir}/RANGEMENT/${tagA}
	fi
	if [[ -n $cle2 ]]; then
	    tmp=$(id3v2 -l "$i" | grep $(tagID3V2 $cle2))
	    tagB=${tmp##*: }
	    if [[ -z $tagB ]]; then tagB=INCONNU; fi
		destination=${dir}/RANGEMENT/${tagA}/${tagB}
	fi
	if [[ -n $cle3 ]]; then
		tmp=$(id3v2 -l "$i" | grep $(tagID3V2 $cle3))
		tagC=${tmp##*: }
		if [[ -z $tagC ]]; then tagC=INCONNU; fi
		destination=${dir}/RANGEMENT/${tagA}/${tagB}/${tagC}
	fi

	if [[ ! -d $destination ]]; then
			if ! (($dryrun)); then mkdir -p "$destination"; fi
			if (($verbose)); then echo "creation du dossier: $destination"; fi
			if (($dryrun)) || (($verbose));	then echo mkdir -p "$destination"; fi
	fi

	if (($dryrun)) || (($verbose)); then echo $action "$fichier" "$destination" from "$i"; fi
	if ! (($dryrun)); then $action "$i" "$destination"; fi
	done
