# Description

Bash script to obtain AWS Postgres DB tokens from preset profiles with quick selection.
The script also allows saving the last generated token to a file and manually selecting connection parameters from those registered.

# Configuration Variables

<b>GENFILE</b>  -  IF 1, GENERATES FILE AND OPENS WITH GEDIT; IF 0, DISPLAYS TOKEN IN SHELL
</br><b>OPNFILE</b>  -  IF 1, OPENS FILE WITH GEDIT AFTER GENERATION
</br><b>FILTOKN</b>  -  NAME AND EXTENSION OF THE GENERATED FILE
</br><b>PATTOKN</b>  -  PATH AND NAME OF THE GENERATED FILE (PREDEFINED)
</br><b>AWSPORT</b>  -  DB PORT
</br><b>FILCRDS</b>  -  NAME OF THE CREDENTIALS FILE (default AWS)
</br><b>PATCRDS</b>  -  PATH TO CREDENTIALS FILE (default AWS)
</br>
</br><b>AWSHOSTS</b> -  ARRAY OF AVAILABLE HOSTS 
</br><b>AWSUSERS</b> -  ARRAY OF AVAILABLE USERS 
</br><b>AWSCRDSS</b> -  ARRAY OF CREDENTIALS EXTRACTED FROM THE CREDENTIALS FILE
</br>
</br><b>MAINPRR</b>  -  PRESELECTED PROFILE,
</br>                  IF "PROFILE_NAME" USES DIRECTLY THE PRESET PROFILE
</br>                  IF "" ENABLES CHOICE (see profile management for details),
</br>                  IF "MANUAL", DIRECTLY REQUESTS SELECTION OF INDIVIDUAL ELEMENTS FROM VARIOUS ARRAYS
                  
# Profile Management

You can add a profile to the MAINPRFS array following the convention ["PROFILE_NAME","PARAMETER_NAME"]
and set the parameters with data from the previous arrays (AWSHOSTS, AWSUSERS, AWSCRDSS)
example of a profile:

MAINPRFS["DEVELOPMENT","AWSHOST"]=${AWSHOSTS[DEVELOPMENT]}
MAINPRFS["DEVELOPMENT","AWSUSER"]=${AWSUSERS[etl_user_15]}
MAINPRFS["DEVELOPMENT","AWSCRDS"]="default"

# Script Usage

Navigate to the path where the script is located and execute with ./gen_token_db_aws.sh
