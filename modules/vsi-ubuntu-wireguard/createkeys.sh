#!/bin/bash

# Default number of client keys is 1
numClients=1


while [ "$1" != "" ]; do
    case $1 in
        -n | --number )        shift
                               numClients=$1
                               ;;
       * )                     exit
    esac
    shift
done


# Create keys for server
privateKey=$(wg genkey)
publicKey=$(echo "$privateKey" | wg pubkey)

# Output the server variable for terraform
echo 'wg_server_config={"publicKey" : "'$publicKey'", "privateKey" : "'$privateKey'"}'

# Create keys for specified number of clients
privateKey=$(wg genkey)
publicKey=$(echo "$privateKey" | wg pubkey)

echo -n 'wg_clients=[{"publicKey" : "'$publicKey'", "privateKey" : "'$privateKey'"}'


if [ $numClients -gt 1 ]
then
  for i in $(seq 2 1 $numClients)
  do
    privateKey=$(wg genkey)
    publicKey=$(echo "$privateKey" | wg pubkey)
    echo -n ', {"publicKey" : "'$publicKey'", "privateKey" : "'$privateKey'"}' 
  done
fi


echo ']'
