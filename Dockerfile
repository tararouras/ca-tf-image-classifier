FROM python:2.7.13

ADD ./requirements.txt ./

RUN wget https://iperf.fr/download/ubuntu/libiperf0_3.1.3-1_amd64.deb \
 && wget https://iperf.fr/download/ubuntu/iperf3_3.1.3-1_amd64.deb \
 && dpkg -i libiperf0_3.1.3-1_amd64.deb iperf3_3.1.3-1_amd64.deb \
 && rm -f libiperf0_3.1.3-1_amd64.deb iperf3_3.1.3-1_amd64.deb

RUN apt-get update \
 && pip install --upgrade pip \
 && apt-get install -y openssl \
 && apt-get install -y swig \
 && pip install -r ./requirements.txt \
 && rm -rf /var/lib/apt/lists/*

ADD . ./artifacts/

COPY entrypoint.sh ./artifacts/entrypoint.sh
RUN chmod +x /artifacts/entrypoint.sh

VOLUME /tmp/workdir

WORKDIR /tmp/workdir

ENV PYTHONPATH /artifacts/

ENTRYPOINT /artifacts/entrypoint.sh
