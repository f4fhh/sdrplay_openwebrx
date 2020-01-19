FROM debian:stretch-slim AS base

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
        dumb-init \
        python3 \
        python3-setuptools \
        netcat \
        sox \
        librtlsdr0 \
        libfftw3-3 \
        libitpp8v5 \
        libsndfile1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

FROM base as builder

ENV MAJVERS 2.13
ENV MINVERS .1
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	    wget \
        git \
        build-essential \
        cmake \
        librtlsdr-dev \
        libfftw3-dev \
        libitpp-dev \
        libsndfile-dev \
	    ca-certificates

WORKDIR /tmp/sdrlib
RUN wget https://www.sdrplay.com/software/SDRplay_RSP_API-Linux-${MAJVERS}${MINVERS}.run && \
        export ARCH=`arch` && \
        sh ./SDRplay_RSP_API-Linux-${MAJVERS}${MINVERS}.run --tar xvf && \
        cp ${ARCH}/libmirsdrapi-rsp.so.${MAJVERS} /usr/local/lib/. && \
        chmod 644 /usr/local/lib/libmirsdrapi-rsp.so.${MAJVERS} && \
        ln -s /usr/local/lib/libmirsdrapi-rsp.so.${MAJVERS} /usr/local/lib/libmirsdrapi-rsp.so.2 && \
        ln -s /usr/local/lib/libmirsdrapi-rsp.so.2 /usr/local/lib/libmirsdrapi-rsp.so && \
        cp mirsdrapi-rsp.h /usr/local/include/. && \
        chmod 644 /usr/local/include/mirsdrapi-rsp.h
WORKDIR /tmp
RUN git clone https://github.com/pothosware/SoapySDR.git ./SoapySDR
WORKDIR /tmp/SoapySDR/build
RUN cmake .. && make && make install
WORKDIR /tmp
RUN git clone https://github.com/pothosware/SoapySDRPlay.git ./SoapySDRPlay
WORKDIR /tmp/SoapySDRPlay/build
RUN cmake .. && make && make install
WORKDIR /tmp
RUN git clone https://github.com/pothosware/SoapyRTLSDR.git ./SoapyRTLSDR
WORKDIR /tmp/SoapyRTLSDR/build
RUN cmake .. && make && make install
WORKDIR /tmp
RUN git clone https://github.com/jketterl/owrx_connector.git ./owrx_connector
WORKDIR /tmp/owrx_connector/build
RUN cmake .. && make && make install
WORKDIR /tmp
RUN git clone https://github.com/jketterl/csdr.git ./csdr
WORKDIR /tmp/csdr
RUN make && make install PREFIX=/usr/local
WORKDIR /tmp
RUN git clone https://github.com/szechyjs/mbelib.git ./mbelib
WORKDIR /tmp/mbelib/build
RUN cmake .. && make && make install
WORKDIR /tmp
RUN git clone https://github.com/jketterl/digiham.git ./digiham
WORKDIR /tmp/digiham/build
RUN cmake .. && make && make install
WORKDIR /tmp
RUN git clone https://github.com/f4exb/dsd ./dsd
WORKDIR /tmp/dsd/build
RUN cmake .. && make && make install
WORKDIR /opt
RUN git clone https://github.com/jketterl/openwebrx.git ./openwebrx

FROM base

COPY --from=builder /usr/local/bin/ /usr/local/bin/
# Workaround a docker bug with 2 consecutive COPY
RUN true
COPY --from=builder /usr/local/lib/ /usr/local/lib/
RUN true
COPY --from=builder /opt/ /opt/
RUN ldconfig
WORKDIR /opt/openwebrx

VOLUME /etc/openwebrx

CMD [ "/opt/openwebrx/docker/scripts/run.sh" ]

EXPOSE 8073/tcp