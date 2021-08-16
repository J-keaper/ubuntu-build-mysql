FROM ubuntu:16.04

COPY sources.list /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y build-essential cmake make gdb
RUN apt-get install -y openssh-server rsync
RUN apt-get install -y vim git wget
RUN apt-get install -y openssl libssl-dev libncurses5-dev bison pkg-config

# config sshd
RUN mkdir /var/run/sshd
RUN sed -ri 's/^#PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config &&  sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && sed -ri 's/RSYNC_ENABLE=false/RSYNC_ENABLE=true/g' /etc/default/rsync

# config rsync service
COPY rsync.conf /etc
RUN echo 'root:root' |chpasswd
RUN mkdir /root/sync


# download boost
WORKDIR /root/software/
RUN wget https://nchc.dl.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.gz
RUN tar -zxvf boost_1_59_0.tar.gz

WORKDIR /root/

COPY entrypoint.sh /sbin
RUN chmod +x /sbin/entrypoint.sh
ENTRYPOINT [ "/sbin/entrypoint.sh" ]
