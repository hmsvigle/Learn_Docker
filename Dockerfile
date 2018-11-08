FROM sequenceiq/pam:centos-6.5

USER root

WORKDIR /apps

COPY . /apps

RUN yum clean all; \
    rpm --rebuilddb; \
    yum install -y  curl tar openssh-server openssh-clients rsync unzip which httpd wget

#RUN yum update -y libselinux 

RUN ["chmod", "+x","/apps/setupenv-entrypoint.sh"]

ENTRYPOINT ["./setupenv-entrypoint.sh"]

EXPOSE 8080 22 8081 8070 
