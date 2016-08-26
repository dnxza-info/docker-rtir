FROM dnxza/rt:latest

MAINTAINER DNX DragoN "ratthee.jar@hotmail.com"

ENV RTIR_VERSION 4.0.0
ENV RTIR_SHA1 b660855cd7467cad1fec60b4050437dacb77cb91

RUN cd /usr/local/src \
  && curl -sSL "https://download.bestpractical.com/pub/rt/release/RT-IR-${RTIR_VERSION}.tar.gz" -o RT-IR.tar.gz \
  && echo "${RTIR_SHA1}  RT-IR.tar.gz" | shasum -c \
  && tar -xvzf RT-IR.tar.gz \
  && rm RT-IR.tar.gz \
  && cd "RT-IR-${RTIR_VERSION}" \
  && perl Makefile.PL \
  && make install

CMD [ "/bin/bash", "/start.sh", "start" ]