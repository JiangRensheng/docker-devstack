FROM debian:jessie

# policy-rc.d likes to block devstack 
RUN perl -pi -w -e 's/101/0/g;' /usr/sbin/policy-rc.d 

# install required files
RUN apt-get update && \
	apt-get -y install \
	python \
	net-tools \
	bsdmainutils \
	git \
	build-essential \
	libssl-dev \
	libffi-dev \
	python-dev \
	sudo \
	vim \
	apt-utils

RUN mkdir /github

WORKDIR /github

RUN git clone https://git.openstack.org/openstack-dev/devstack 

WORKDIR /github/devstack

RUN tools/create-stack-user.sh && \
	chown -R stack:stack /github

USER stack

COPY localrc /github/devstack/

#RUN sed -e '0,/n/{//i\nameserver 127.0.0.1' -e '}'

RUN /bin/bash -c ./stack.sh

EXPOSE 22, 80, 443

CMD ["/github/devstack/rejoin-stack.sh"]