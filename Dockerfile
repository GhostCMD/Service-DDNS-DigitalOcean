FROM alpine:3.10

RUN adduser  --system Account-DDNS
RUN apk add --no-cache bash curl jq
USER Account-DDNS 
#RUN mkdir /home/Account-DDNS
WORKDIR /home/Account-DDNS

COPY DDNS-Timer.sh  DDNS-Timer.sh
ENV LEXICON_DIGITALOCEAN_TOKEN=Override
ENV DOMAIN=Override
ENV DATA=Override 
ENV Type=A
ENV ID=Collect
CMD [ "bash", "/home/Account-DDNS/DDNS-Timer.sh"]
