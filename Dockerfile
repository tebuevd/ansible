FROM ubuntu:jammy as base

RUN apt update \
  && apt install -y software-properties-common sudo \
  && add-apt-repository --yes --update ppa:ansible/ansible \
  && apt install -y ansible

FROM base as prime

ARG USER
RUN echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN addgroup --gid 1000 ${USER}
RUN adduser --gecos ${USER} --uid 1000 --gid 1000 --disabled-password ${USER}
RUN usermod -aG sudo ${USER}
USER $USER
WORKDIR /home/${USER}

FROM prime

COPY ./tasks/system.yml .
RUN ansible-playbook system.yml

COPY ./tasks/rust.yml .
RUN ansible-playbook rust.yml

COPY ./tasks/dev.yml .
RUN ansible-playbook dev.yml

COPY ./tasks/zsh.yml .
RUN ansible-playbook zsh.yml

CMD ["zsh"]
