#!/bin/bash
DNS=8.8.8.8

cat /etc/hosts | while read ip name rest
do
    if [ -z "$ip" ] || [[ "$ip" == \#* ]]; then
        continue
    fi
    if [[ "$ip" == *:* ]] || [[ "$ip" == 127.* ]]; then
        continue
    fi

    adrese=$(nslookup "$name" "$DNS" | awk '/^Name:/ {gasit=1} gasit && /^Address:/ {print $2}')

    if ! echo "$adrese" | grep -qx "$ip"; then
        echo "Bogus IP for $name in /etc/hosts!"
    fi
done
