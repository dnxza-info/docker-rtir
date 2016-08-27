FROM dnxza/rt:latest

MAINTAINER DNX DragoN "ratthee.jar@hotmail.com"

ENV RTIR_VERSION 4.0.0
ENV RTIR_SHA1 b660855cd7467cad1fec60b4050437dacb77cb91

RUN rm /opt/rt4/etc/RT_SiteConfig.pm
COPY RT_SiteConfig.pm /opt/rt4/etc/RT_SiteConfig.pm

WORKDIR /usr/local/src

RUN cd /usr/local/src \
  && /usr/bin/mysqld_safe & sleep 10s \
  && curl -sSL "https://download.bestpractical.com/pub/rt/release/RT-IR-${RTIR_VERSION}.tar.gz" -o RT-IR.tar.gz \
  && echo "${RTIR_SHA1}  RT-IR.tar.gz" | shasum -c \
  && tar -xvzf RT-IR.tar.gz \
  && rm RT-IR.tar.gz 
  
WORKDIR /usr/local/src/RT-IR-${RTIR_VERSION}

RUN perl Makefile.PL \
  && make install \
  && /usr/bin/perl -Ilib -I/opt/rt4/local/lib -I/opt/rt4/lib /opt/rt4/sbin/rt-setup-database --action insert --datadir etc --datafile etc/initialdata --dba root --dba-password=$MYSQLPASS --package RT::IR --ext-version ${RTIR_VERSION}

WORKDIR /opt/rt4
  
CMD [ "/bin/bash", "/start.sh", "start" ]