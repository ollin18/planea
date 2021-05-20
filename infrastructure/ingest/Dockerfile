FROM ollin18/base:0.1

LABEL maintainer="Ollin Demian Langle Chimal <Ollin.Langle@uvm.edu>"
ENV REFRESHED_AT 2020-04-29

RUN apt-get update && apt-get -y install python3-requests unrar pkg-config libicu-dev

RUN pip3 install --no-binary=:pyicu: pyicu

ADD requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

RUN mkdir /data /src


CMD ["bash"]
