FROM ubuntu:18.04

RUN apt-get -q update && \
    apt-get -qy dist-upgrade && \
    apt-get -qy install libterm-readline-perl-perl dialog && \
    apt-get -qy install sudo apt-utils software-properties-common xauth dialog curl

RUN apt-add-repository -y ppa:jonathonf/firefox-esr-52 && \
    apt-get -q update && \
    apt-get -qy install firefox-esr

RUN useradd -m -s /bin/bash -c "Firefox user" ffuser && \
    mkdir -p /etc/sudoers.d && \
    echo "ffuser ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ffuser && \
    chmod 0440 /etc/sudoers.d/ffuser

RUN echo "deb http://archive.canonical.com/ubuntu bionic partner" | tee -a /etc/apt/sources.list && \
    apt-get -q update && \
    apt-get -qy install adobe-flashplugin

RUN curl -O --header "Cookie: oraclelicense=accept-securebackup-cookie;" -L https://download.oracle.com/otn-pub/java/jdk/8u202-b08/1961070e4c9b4e26a04e7f5a083f551e/jre-8u202-linux-x64.tar.gz

RUN mkdir -p /opt/java
RUN tar --strip 1 -C /opt/java -zxvf jre-8u202-linux-x64.tar.gz

RUN cp -a /opt/java/lib/desktop/applications/*.desktop /usr/share/applications
RUN ln -sf /opt/java/bin/java /usr/bin
RUN ln -sf /opt/java/bin/javaws /usr/bin

#RUN mkdir -p /usr/lib/firefox-esr/browser/plugins
#RUN ln -sf /opt/java/lib/amd64/libnpjp2.so /usr/lib/firefox-esr/browser/plugins
#RUN ln -sf /opt/java/lib/amd64/libnpjp2.so /usr/lib/firefox/plugins
RUN ln -sf /opt/java/lib/amd64/libnpjp2.so /usr/lib/mozilla/plugins

COPY default.profile /tmp/default.profile

USER ffuser
RUN mkdir -p /home/ffuser/.java/deployment/security && \
    touch /home/ffuser/.java/deployment/security/exception.sites

COPY entrypoint.sh /home/ffuser

ENTRYPOINT [ "/home/ffuser/entrypoint.sh" ]

