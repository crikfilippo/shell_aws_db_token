#!/bin/bash

GENFILE=0 #GENERA FILE ED APRI CON GEDIT / MOSTRA TOKEN
OPNFILE=0 #APRI FILE CON GEDIT AL TERMINE DELLA GENERAZIONE
FILENAME="last_token_db_aws.txt" #NOME FILE GENERATO
FILEPATH=$HOME/script/$FILENAME #PATH FILE GENERATO
AWSUSER="etl_user_15" #NOME UTENTE
AWSPORT="5432" #PORTA DEL DB
#AWSDB="postgres" #NOME DB

declare -A AWSHOSTS=( #ELENCO HOST
    ["DEVELOPMENT"]="onlinedb-development.cluster-crrubykox7bs.eu-central-1.rds.amazonaws.com"
    ["INTEGRATION"]="integration-db-cloned-cluster.cluster-ro-c0kkcwcgpb14.eu-central-1.rds.amazonaws.com"
)

#VALORE HOST - SE "" ABILITA SELEZIONE UTENTE
AWSHOST="" 
#AWSHOST=${AWSHOSTS[DEVELOPMENT]}

function SEL_ARRVAL() {

    declare -n arr="$1"
    local index=1
    local nomi=()

    echo "" > `tty`	
    echo "SCEGLI HOST:" > `tty`

    for nome in "${!arr[@]}"; do
        echo "$index) $nome" > `tty`
        nomi+=("$nome")
        ((index++))
    done


    echo "" > `tty`
    read -r scelta
    echo "" > `tty`

    # Controlla se la scelta è un numero valido
    if [[ "$scelta" =~ ^[0-9]+$ && "$scelta" -ge 1 && "$scelta" -le "${#nomi[@]}" ]]; then
        # Recupera il nome selezionato
        nome_selezionato="${nomi[$((scelta-1))]}"
        valore="${arr[$nome_selezionato]}"
        echo "$valore" # Ritorna il nome selezionato
    else
        echo "" # Ritorna una stringa vuota
    fi
}


# Loop finché l'utente non inserisce una scelta valida
#while [[ -z "$AWSHOST" ]]; do
#    AWSHOST=$(SEL_ARRVAL AWSHOSTS) # Passa l'array associativo come argomento
#done

if [[ -z "$AWSHOST" ]]; then
	AWSHOST=$(SEL_ARRVAL AWSHOSTS) # Passa l'array associativo come argomento
	if [[ -z "$AWSHOST" ]]; then
	    	echo "ERRORE: HOST SCELTO  NON VALIDO."
	    	exit 1
	fi
fi

echo "GENERAZIONE TOKEN IN CORSO..."

TOKEN=$(aws rds generate-db-auth-token --hostname $AWSHOST --port $AWSPORT --region eu-central-1 --username $AWSUSER)


if [[ $? -ne 0 ]]; then
    echo "ERRORE GENERAZIONE TOKEN."
    exit 1
fi

echo "TOKEN GENERATO."
echo ""

if [ "$GENFILE" -eq "1" ]; then
    echo "GENERAZIONE FILE IN CORSO..."
	echo $TOKEN > $FILEPATH
	if [[ $? -ne 0 ]]; then
	    echo "ERRORE GENERAZIONE FILE."
	    exit 1
	fi
	echo "FILE GENERATO."
	echo ""
	if [ "$OPNFILE" -eq "1" ]; then
		echo "APERTURA GEDIT IN CORSO..."
		gedit $FILEPATH
	fi
else	
	echo $TOKEN
fi

echo ""

#echo ${AWSHOST}:${AWSPORT}:${AWSDB}:${AWSUSER}:${TOKEN} > $HOME/script/$FILENAME
#exit
#sleep infinity
