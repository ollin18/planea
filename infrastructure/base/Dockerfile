FROM ubuntu:18.04
LABEL maintainer="Ollin Demian Langle Chimal <Ollin.Langle@uvm.edu>"

ENV refreshed_at 2020-04-29
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install build-essential tzdata locales
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata
RUN apt-get update -qq
RUN apt-get -y install software-properties-common dirmngr
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran40/'
RUN apt-get update
# RUN apt-get -y install --no-install-recommends r-base
# RUN apt-get -y install wget gdal-bin curl sed gawk unzip tar default-jdk grep r-base-core python3 python3-pip r-base libiconv-hook-dev
RUN apt-get -y install wget gdal-bin curl sed gawk unzip tar default-jdk grep python3 python3-pip libiconv-hook-dev
RUN apt-get -y install python-pip && pip install awscli
RUN wget https://julialang-s3.julialang.org/bin/linux/x64/1.2/julia-1.2.0-linux-x86_64.tar.gz -P /tmp
RUN tar -xvf /tmp/julia-1.2.0-linux-x86_64.tar.gz
RUN mv julia-1.2.0 /usr/local/bin/julia

# We need spanish for compatibility with our data
# Still don't know
# RUN echo "es_MX.UTF-8 UTF-8" >> /etc/locale.gen \
#     && locale-gen es_MX.UTF-8 es_MX\
#     && /usr/sbin/update-locale LANG=es_MX.UTF-8 \
#     && dpkg-reconfigure locales

# ENV LANG es_MX.UTF-8
# ENV LANGUAGE es_MX.UTF-8
# ENV LC_ALL es_MX.UTF-8

CMD ["true"]
