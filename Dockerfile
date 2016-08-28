FROM dnxza/rt:latest

MAINTAINER DNX DragoN "ratthee.jar@hotmail.com"

ENV RTIR_VERSION 4.0.0
ENV RTIR_SHA1 b660855cd7467cad1fec60b4050437dacb77cb91

RUN rm /opt/rt4/etc/RT_SiteConfig.pm
COPY RT_SiteConfig.pm /opt/rt4/etc/RT_SiteConfig.pm
RUN chown root:www-data /opt/rt4/etc/RT_SiteConfig.pm \
  && chmod 0640 /opt/rt4/etc/RT_SiteConfig.pm

WORKDIR /usr/local/src

RUN cd /usr/local/src \
  && curl -sSL "https://download.bestpractical.com/pub/rt/release/RT-IR-${RTIR_VERSION}.tar.gz" -o RT-IR.tar.gz \
  && echo "${RTIR_SHA1}  RT-IR.tar.gz" | shasum -c \
  && tar -xvzf RT-IR.tar.gz \
  && rm RT-IR.tar.gz 

RUN PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install Parse::BooleanLogic'  

WORKDIR /usr/local/src/RT-IR-${RTIR_VERSION}

RUN perl Makefile.PL \
  && make install

RUN /usr/bin/mysqld_safe & sleep 10s \
  && echo $MYSQLPASS | make initdb

RUN chown -R www-data:www-data /opt/rt4/var/