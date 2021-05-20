
%{ for client in client_configs ~}
################################################
[Interface]
Address = ${client.ip}/32
PrivateKey = ${client.privateKey != "" ? client.privateKey : "<enter client private key here>"}


[Peer]
PublicKey = ${server_config.publicKey != "" ? server_config.publicKey : "<enter server public key here>"}
Endpoint = ${floating_ip}:65000

# Allow only the following networks to tunnel through VPN:
# - VSI subnet
# - Cluster subnets - You need this to get to the openshift console
# - IBM Cloud Service Endpoint (CSE): 166.8.0.0/14, 166.9.0.0/14
# - Anything else you need to tunnel to
AllowedIPs = 166.8.0.0/14, 166.9.0.0/14, ${wg_cidr}%{ for cidr in cidrs ~}, ${cidr}%{ endfor ~}

################################################

%{ endfor ~}
