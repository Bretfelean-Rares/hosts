#!/bin/bash
DNS=8.8.8.8
echo "Modificat de studentul A"
verifica_ip()
{
    local name=$1
    local ip=$2
    local dns=$3
    local adrese

    adrese=$(nslookup "$name" "$dns" | awk '/^Name:/ {gasit=1} gasit && /^Address:/ {print $2}')
    echo "$adrese" | grep -qx "$ip"
}

cat /etc/hosts | while read ip name rest
do
    if [ -z "$ip" ] || [[ "$ip" == \#* ]]; then
        continue
    fi
    if [[ "$ip" == *:* ]] || [[ "$ip" == 127.* ]]; then
        continue
    fi

    adrese=$(nslookup "$name" "$DNS" | awk '/^Name:/ {gasit=1} gasit && /^Address:/ {print $2}')

    if ! verifica_ip "$name" "$ip" "$DNS"; then
        echo "Bogus IP for $name in /etc/hosts!"
    fi
done
