FROM centos:7
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN rm -rf /etc/localtime
RUN ln -s /usr/share/zoneinfo/Asia/Bangkok /etc/localtime

RUN yum install -y openssh openssh-server openssh-clients
RUN yum install -y gnupg2
RUN yum install -y cronie

RUN mkdir -p /tmp/infile
RUN mkdir -p /tmp/outfile
RUN mkdir -p /tmp/backup
RUN mkdir -p /tmp/log
RUN mkdir -p /tmp/script
RUN mkdir -p /tmp/key
COPY decrypt.sh /tmp/script/decrypt.sh
RUN chmod +x /tmp/script/decrypt.sh
COPY key.secret /tmp/key
COPY public.key /tmp/key
COPY private.key /tmp/key
RUN gpg --import /tmp/key/public.key; 
RUN gpg --allow-secret-key-import --import /tmp/key/private.key

#***** Set Crontab *****
RUN echo '* * * * * /tmp/script/decrypt.sh' >> /var/spool/cron/root
#***** Set Crontab *****

#CMD ["crond", "-n"]
