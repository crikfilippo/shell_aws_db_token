#!/bin/bash

PRNTOKN=1                               #MOSTRA TOKEN A CONSOLE
GENFILE=0                               #GENERA FILE
OPNFILE=0                               #APRI FILE CON GEDIT AL TERMINE DELLA GENERAZIONE
FILTOKN="last_token_db_aws.txt"         #NOME FILE GENERATO
PATTOKN=$HOME/script/$FILTOKN           #PATH FILE GENERATO
AWSPORT="5432"                          #PORTA DEL DB
#AWSDB="postgres"                       #NOME DB
FILCRDS="credentials"                   #NOME FILE CREDENZIALI (default AWS)
PATCRDS=$HOME/.aws/$FILCRDS             #PATH FILE CREDENZIALI (default AWS)



declare -A AWSHOSTS=( #ELENCO HOST
    ["DEVELOPMENT"]="onlinedb-development.cluster-crrubykox7bs.eu-central-1.rds.amazonaws.com"
    ["INTEGRATION"]="onlinedb-moved-bedbug-2.c0kkcwcgpb14.eu-central-1.rds.amazonaws.com"
)

declare -A AWSUSERS=( #ELENCO UTENTI
    ["etl_user_15"]="etl_user_15"
    ["etl_user"]="etl_user"
)

declare -A AWSCRDSS #ELENCO CREDENZIALI (estratte automaticamente)
#declare -A AWSCNFGS #ELENCO CONFIGURAZIONI (estratte automaticamente)

#SE "" ABILITA SELEZIONE HOST
AWSHOST=""   
#AWSHOST=${AWSHOSTS[DEVELOPMENT]}

#SE "" ABILITA SELEZIONE UTENTE 
AWSUSER="" 
#AWSUSER=${AWSUSERS[etl_user_15]}

#SE "" ABILITA SELEZIONE CREDENZIALI 
AWSCRDS="" 
#AWSCRDS="default"




#FUNZIONE PER CHIEDERE A UTENTE DI ESTRARRE 1 VALORE DA ARRAY ASSOCIATIVO 
function SEL_ARRVAL() {

    declare -n arr="$1"
    declare -n msg="$2"
    local index=1
    local nomi=()

    echo "" > `tty`
    echo "${msg}" > `tty`
    #echo "" > `tty`

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


#RICHIEDI VALORE HOST
if [[ -z "$AWSHOST" ]]; then
  #verifica presenza dati
  if [ ${#AWSHOSTS[@]} -eq 0 ]; then  
      echo "ERRORE: NESSUN HOST TROVATO."
      exit 1  
  fi
  #richiedi selelione
	MSG="SCEGLI HOST:"
	AWSHOST=$(SEL_ARRVAL AWSHOSTS MSG) # Passa l'array associativo come argomento
	if [[ -z "$AWSHOST" ]]; then
	    	echo "ERRORE: HOST SCELTO  NON VALIDO."
	    	exit 1
	fi
fi

#RICHIEDI VALORE USER
if [[ -z "$AWSUSER" ]]; then
  #verifica presenza dati
  if [ ${#AWSUSERS[@]} -eq 0 ]; then  
      echo "ERRORE: NESSUN UTENTE TROVATO."
      exit 1  
  fi
  #richiedi selelione
	MSG="SCEGLI UTENTE:"
	AWSUSER=$(SEL_ARRVAL AWSUSERS MSG) # Passa l'array associativo come argomento
	if [[ -z "$AWSUSER" ]]; then
	    	echo "ERRORE: USER SCELTO  NON VALIDO."
	    	exit 1
	fi
fi


#RICHIEDI PROFILO CREDENZIALI
if [[ -z "$AWSCRDS" ]]; then


  # Verifica che il file esista
  if [[ ! -f "$PATCRDS" ]]; then
      echo "ERRORE: FILE CREDENZIALI NON TROVATO."
      return 1
  fi
  
  # Leggi il file delle credenziali riga per riga
  while IFS= read -r line; do
      # Se la riga inizia con [ e termina con ], estrae il nome del profilo
    if [[ $line =~ ^\[(.*)\]$ ]]; then
        profile_name="${BASH_REMATCH[1]}"
        # Aggiunge il nome del profilo all'array associativo
        AWSCRDSS["$profile_name"]="$profile_name"
    fi
  done < "$PATCRDS"
    

  #verifica presenza dati
  if [ ${#AWSCRDSS[@]} -eq 0 ]; then
  
      echo "ERRORE: NESSUN PROFILO TROVATO."
      exit 1
  
   fi
 
  
  #richiedi scelta
 	MSG="SCEGLI PROF. CREDENZIALI:"
	AWSCRDS=$(SEL_ARRVAL AWSCRDSS MSG) # Passa l'array associativo come argomento
	if [[ -z "$AWSCRDS" ]]; then
	    	echo "ERRORE: PROFILO SCELTO NON VALIDO."
	    	exit 1
  fi
        
  	
fi


#predisposizione comando token
TKNSTR="aws rds generate-db-auth-token --hostname $AWSHOST --port $AWSPORT --region eu-central-1 --username $AWSUSER --profile $AWSCRDS"


#generazione token
echo "GENERAZIONE TOKEN IN CORSO..."
TOKEN=$($TKNSTR)


if [[ $? -ne 0 ]]; then
    echo "ERRORE GENERAZIONE TOKEN."
    exit 1
fi

echo "TOKEN GENERATO."
echo ""

#genera file token
if [ "$GENFILE" -eq "1" ]; then

  echo "GENERAZIONE FILE IN CORSO..."
	echo $TOKEN > $PATTOKN
	if [[ $? -ne 0 ]]; then
	    echo "ERRORE GENERAZIONE FILE."
	    exit 1
	fi
  echo "FILE GENERATO."
	echo ""
 
fi

#stampa token a console
if [ "$PRNTOKN" -eq "1" ]; then

  echo "TOKEN GENERATO:"
  echo ""
  echo $TOKEN
  echo ""

fi

#apri file generato
if [ "$OPNFILE" -eq "1" -a "$GENFILE" -eq "1" ]; then
	
  echo "APERTURA GEDIT IN CORSO..."
  gedit $PATTOKN
  
fi



#echo ${AWSHOST}:${AWSPORT}:${AWSDB}:${AWSUSER}:${TOKEN} > $HOME/script/$FILTOKN
#exit
#sleep infinity
