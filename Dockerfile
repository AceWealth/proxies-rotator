FROM python:3.5
MAINTAINER Johannes Gontrum <https://github.com/jgontrum>

ENV CHECK_URL "https://www.immobilienscout24.de"
ENV CHECK_FOR "Immobilien"
ENV PROXY_TIMEOUT "15.0"
ENV PROXY_FILE "/app/data/proxies.txt"

RUN mkdir -p /app
RUN mkdir -p /app/logs
RUN mkdir -p /app/data

COPY gimmeproxy.py /app/gimmeproxy.py
COPY parse_proxy_list.py /app/parse_proxy_list.py
COPY haproxy.cfg /app/haproxy.cfg
COPY requirements.txt /app/requirements.txt
COPY run.sh /app/run.sh
COPY data/proxies.txt /app/data/proxies.txt

RUN echo deb http://httpredir.debian.org/debian jessie-backports main | sed 's/\(.*\)-sloppy \(.*\)/&@\1 \2/' | tr @ '\n' | tee /etc/apt/sources.list.d/backports.list

RUN apt-get update
RUN apt-get install -y --force-yes iptables zlib1g zlib1g-dev haproxy -t jessie-backports --fix-missing
RUN apt-get clean

RUN pip install -r /app/requirements.txt

RUN chmod -R 777 /app
RUN chmod -R 777 /etc/haproxy

EXPOSE 20020
CMD ["/app/run.sh"]
