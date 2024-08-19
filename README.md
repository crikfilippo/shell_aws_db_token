# Variabili di configurazione.

<b>GENFILE</b>  - 	SE 1 GENERA FILE ED APRE CON GEDIT, SE 0  MOSTRA TOKEN IN SHELL
</br><b>OPNFILE</b>  -  SE 1 APRE FILE CON GEDIT AL TERMINE DELLA GENERAZIONE
</br><b>FILTOKN</b>  -  NOME ED ESTENSIONE FILE GENERATO
</br><b>PATTOKN</b>  -  PATH E NOME FILE GENERATO (PREIMPOSTATO)
</br><b>AWSPORT</b>  -  PORTA DEL DB
</br><b>FILCRDS</b>  -  NOME FILE CREDENZIALI (default AWS)
</br><b>PATCRDS</b>  -  PATH FILE CREDENZIALI (default AWS)
</br>
</br><b>AWSHOSTS</b> -  ARRAY DEGLI HOST DISPONIBILI 
</br><b>AWSUSERS</b> -  ARRAY DEGLI USER DISPONIBILI 
</br><b>AWSCRDSS</b> -  ARRAY DELLE CREDENZIALI ESTRATTE DA FILE credentials
</br>
</br><b>MAINPRR</b>  -  PROFILO PRESELEZIONATO,
</br>                  SE "NOME_PROFILO" IMPIEGA DIRETTAMENTE PROFILO PREIMPOSTATO
</br>                  SE "" ABILITA SCELTA (vedi gestione profili per dettagli),
</br>                  SE "MANUAL", RICHIEDE DIRETTAMENTE SELEZIONE SINGOLI ELEMENTI DA VARI ARRAY
                  

# Gestione profili

Si può aggiungere un profilo all'array MAINPRFS rispettando la nomenclatura ["NOME_PROFILO","NOME_PARAMETRO"]
e valorizzare i parametri con i dati provenienti dagli array precedenti (AWSHOSTS,AWSUSERS,AWSCRDSS)
esempio di profilo:

MAINPRFS["DEVELOPMENT","AWSHOST"]=${AWSHOSTS[DEVELOPMENT]}
MAINPRFS["DEVELOPMENT","AWSUSER"]=${AWSUSERS[etl_user_15]}
MAINPRFS["DEVELOPMENT","AWSCRDS"]="default"

# Impiego script

Raggiungere la path dove è presente lo script ed eseguire con ./gen_token_db_aws.sh

