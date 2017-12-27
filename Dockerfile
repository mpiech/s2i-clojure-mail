# s2i-clojure-mail
FROM openshift/base-centos7
MAINTAINER Mike Piech <mpiech@redhat.com>

ENV BUILDER_VERSION 1.0

LABEL io.k8s.description="Platform for building Clojure appsthat send mail" \
      io.k8s.display-name="Clojure s2i 1.0" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,clojure"

RUN yum -y install java-1.8.0-openjdk-devel && yum clean all

RUN yum -y install epel-release --enablerepo=extras && yum clean all

RUN yum -y install ssmtp && yum clean all

RUN yum -y install nss_wrapper gettext && yum clean all

RUN chmod a+rwx /etc/ssmtp
RUN chmod a+rw /etc/ssmtp/ssmtp.conf
RUN chmod g-s /usr/sbin/ssmtp

RUN curl https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -o ${HOME}/lein
RUN chmod 775 ${HOME}/lein
RUN ${HOME}/lein

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

COPY ./s2i/bin/ /usr/libexec/s2i

RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

CMD ["/usr/libexec/s2i/usage"]
