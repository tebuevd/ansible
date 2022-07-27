FROM ubuntu:jammy

RUN apt update \
  && apt install -y software-properties-common \
  && add-apt-repository --yes --update ppa:ansible/ansible \
  && apt install -y ansible 

WORKDIR /ansible

COPY ./tasks/system.yml .
RUN ansible-playbook system.yml

COPY ./tasks/zsh.yml .
RUN ansible-playbook zsh.yml

COPY ./tasks/rust.yml .
RUN ansible-playbook rust.yml

COPY ./setup.yml .
RUN ansible-playbook setup.yml

CMD ["zsh"]
