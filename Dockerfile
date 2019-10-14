FROM fedora:latest

RUN useradd -m --system Account-DDNS

RUN dnf install python3-pip curl -y
RUN pip3 install dns-lexicon

USER Account-DDNS 
WORKDIR Account-DDNS

COPY DDNS-Timer.sh  DDNS-Timer.sh
ENV LEXICON_DIGITALOCEAN_TOKEN=Override
ENV DOMAIN=Override
CMD [ "bash", "/home/Account-DDNS/DDNS-Timer.sh"]
