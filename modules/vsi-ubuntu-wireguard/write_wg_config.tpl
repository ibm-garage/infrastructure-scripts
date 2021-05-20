#cloud-config
write_files:
  - path: /etc/ssh/sshd_config
    content: |
      PasswordAuthentication no
      ChallengeResponseAuthentication no
      UsePAM yes
      X11Forwarding no
      PrintMotd no
      AcceptEnv LANG LC_*
      Subsystem	sftp	/usr/lib/openssh/sftp-server
  - path: /etc/sysctl.d/98-wireguard.conf
    content: |
      net.ipv4.ip_forward = 1
  - path: /etc/wireguard/wg0.conf
    content: |
      [Interface]
      Address = ${wg_server_ip}/32
      PrivateKey = ${wg_server_privateKey}

      PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE
      PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o ens3 -j MASQUERADE

      ListenPort = 65000

      %{ for client in wg_clients ~}
      
      [Peer]
      PublicKey = ${client.publicKey}
      AllowedIPs = ${client.ip}/32
      
      %{ endfor ~}
