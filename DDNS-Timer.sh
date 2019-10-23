Update(){
	Current_IP=`curl -s http://ipv4bot.whatismyipaddress.com/`
	curl -s -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" -d "{\"data\":\"$Current_IP\"}" "https://api.digitalocean.com/v2/domains/$DOMAIN/records/$ID" | jq
 
}


make_dns_record(){
	IP=`curl -s http://ipv4bot.whatismyipaddress.com/`
	curl -s -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" -d "{\"type\":\"A\",\"name\":\"$DATA\",\"data\":\"$IP\",\"priority\":null,\"port\":null,\"ttl\":1800,\"weight\":null,\"flags\":null,\"tag\":null}" "https://api.digitalocean.com/v2/domains/$DOMAIN/records" | jq '.domain_record.id' > /tmp/id
	export ID=`cat /tmp/id`
	rm -f /tmp/id
}


get_dnsObjects(){
	curl -s -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" "https://api.digitalocean.com/v2/domains/$DOMAIN/records" > /tmp/objects.json 

}

enumurateObjects(){
	cat /tmp/objects.json | jq '.domain_records | length'
}

get_name(){
	return cat /tmp/objects.json | jq '.domain_records['$1'].name'
}	
get_type(){
	return cat /tmp/objects.json | jq '.domain_records['$1'].type'
}
match_name(){
	for i in enumurateObjects ;
	do 
		if [ $DATA  = ( get_name $i) && "\"A\"" = (get_type $i)  ];then
			return $i
		fi

	done
	return -1

}

get_dnsObjects

if [ match_name = -1 ]; then
	make_dns_record
else
	export ID=`cat /tmp/objects.json | jq '.domain_records['match_name'].id'`

fi


while true; do
	Update
	sleep 6h
	done
