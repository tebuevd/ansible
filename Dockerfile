FROM --platform=arm64 ubuntu:jammy

RUN apt update \
  && apt install -y software-properties-common \
  && add-apt-repository --yes --update ppa:ansible/ansible \
  && apt install -y ansible 

WORKDIR /ansible
COPY ./setup.yml .

RUN ansible-playbook setup.yml
