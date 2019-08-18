#!/bin/bash

wan='enp0s8'
lan='enp0s9'

case $1 in
        --stop)

                echo "Desativando firewall.."

                # Habilita o roteamento entre as interfaces
                echo 0 > /proc/sys/net/ipv4/ip_forward

                unset wan lan

                echo "Firewall desativado..."

                ;;

        *)

                echo "Ativando firewall..."

                # Carrega o modulos Iptables
                modprobe iptable_filter
                modprobe iptable_nat

                # Regra para compartilhar a Internet (NAT)
                iptables -t nat -A POSTROUTING -o $wan -j MASQUERADE
                iptables -A FORWARD   -m state --state RELATED,ESTABLISHED -j ACCEPT

                iptables -A FORWARD -i $lan -o $wan -j ACCEPT


                # Habilita o roteamento entre as interfaces
                echo 1 > /proc/sys/net/ipv4/ip_forward

                echo "Firewall Ativado..."

                ;;


esac
