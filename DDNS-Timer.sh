Update(){
lexicon digitalocean --name="$DOMAIN" update $DOMAIN A --content=$(curl -s http://ipv4bot.whatismyipaddress.com/)
}


while true; do
	Update
	sleep 6h
	done
