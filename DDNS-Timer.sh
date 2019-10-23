#!/bin/sh

Update(){
        Current_IP=$(curl -s http://ipv4bot.whatismyipaddress.com/)
        curl -s -X PUT -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" -d "{\"data\":\"$Current_IP\"}" "https://api.digitalocean.com/v2/domains/$DOMAIN/records/$ID" | jq
}


make_dns_record(){
        IP=$(curl -s http://ipv4bot.whatismyipaddress.com/)
        curl -s -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" -d "{\"type\":\"A\",\"name\":\"$DATA\",\"data\":\"$IP\",\"priority\":null,\"port\":null,\"ttl\":1800,\"weight\":null,\"flags\":null,\"tag\":null}" "https://api.digitalocean.com/v2/domains/$DOMAIN/records" | jq '.domain_record.id' > /tmp/id
        ID=$(cat /tmp/id)
        export ID
        rm -f /tmp/id
}


get_dnsObjects(){
        curl -s -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $TOKEN" "https://api.digitalocean.com/v2/domains/$DOMAIN/records" > /tmp/objects.json 

}

enumurateObjects(){
        </tmp/objects.json  jq '.domain_records | length'
        return 0
}

get_name(){
        </tmp/objects.json  jq '.domain_records['"$1"'].name'
        return 0
}
get_type(){
        </tmp/objects.json  jq '.domain_records['"$1"'].type'
        return 0
}
match_name(){
        for i in $(enumurateObjects) ;
        do 
                Name=$(get_name "$i")
                Type=$(get_type "$i")
                AType="\"A\""
                if [ "$DATA"  =  "$Name"  ]; then
                        if [ "$Type" = "$AType" ];then
                                return "$i"
                                break
                        fi
                fi
        done
        return 255
}

get_dnsObjects

if [ "$(match_name)" = 255 ]; then
        make_dns_record
else
        ID=$( </tmp/objects.json  jq '.domain_records['"$(match_name)"'].id')
        export ID
fi


while true; do
        Update
        sleep 6h
        done
