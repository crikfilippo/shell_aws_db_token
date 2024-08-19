# Variabili di configurazione.

GENFILE  - 	SE 1 GENERA FILE ED APRE CON GEDIT, SE 0  MOSTRA TOKEN IN SHELL
OPNFILE  - 	SE 1 APRE FILE CON GEDIT AL TERMINE DELLA GENERAZIONE
FILTOKN  - 	NOME ED ESTENSIONE FILE GENERATO
PATTOKN  - 	PATH E NOME FILE GENERATO (PREIMPOSTATO)
AWSPORT  - 	PORTA DEL DB
FILCRDS  -	NOME FILE CREDENZIALI (default AWS)
PATCRDS  -	PATH FILE CREDENZIALI (default AWS)

AWSHOSTS - 	ARRAY DEGLI HOST DISPONIBILI 
AWSUSERS - 	ARRAY DEGLI USER DISPONIBILI 
AWSCRDSS - 	ARRAY DELLE CREDENZIALI ESTRATTE DA FILE credentials

MAINPRR  -	PROFILO PRESELEZIONATO, SE "" ABILITA SCELTA (vedi gestione profili per dettagli)

# Gestione profili

Si può aggiungere un profilo all'array MAINPRFS rispettando la nomenclatura ["NOME_PROFILO","NOME_PARAMETRO"]
e valorizzare i parametri con i dati provenienti dagli array precedenti (AWSHOSTS,AWSUSERS,AWSCRDSS)
esempio di profilo:

MAINPRFS["DEVELOPMENT","AWSHOST"]=${AWSHOSTS[DEVELOPMENT]}
MAINPRFS["DEVELOPMENT","AWSUSER"]=${AWSUSERS[etl_user_15]}
MAINPRFS["DEVELOPMENT","AWSCRDS"]="default"

# Impiego script

Raggiungere la path dove è presente lo script ed eseguire con ./gen_token_db_aws.sh

