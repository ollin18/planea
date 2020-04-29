from ollin18/base:0.1

MAINTAINER Ollin Demian Langle Chimal <Ollin.Langle@uvm.edu>

RUN apt-get update && apt-get -y install python3-requests

ADD requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

ENV REFRESHED_AT 2019-04-03

CMD ["bash"]
