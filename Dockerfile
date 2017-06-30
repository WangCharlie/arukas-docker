FROM alpine:latest
MAINTAINER Charlie Wang <272876047@qq.com>

RUN apk add --update openssh util-linux dbus ttf-freefont xauth xf86-input-keyboard sudo \
    openssh-server python-pip libnet1 libnet1-dev libpcap0.8 libpcap0.8-dev git\
    && rm  -rf /tmp/* /var/cache/apk/*

RUN echo "root:password"|chpasswd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
	sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
    
RUN pip install shadowsocks
RUN git clone https://github.com/snooda/net-speeder.git net-speeder
WORKDIR net-speeder
RUN sh build.sh

RUN mv net_speeder /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/net_speeder

# Configure container to run as an executable
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
EXPOSE 22
