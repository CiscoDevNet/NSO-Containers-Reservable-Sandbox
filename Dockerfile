ARG BASE_IMAGE
ARG NSO_VERSION
FROM --platform=linux/amd64 $BASE_IMAGE:$NSO_VERSION as base

RUN dnf --disableplugin subscription-manager install -y \
      net-tools \
      openssh-clients \
      openssh-server \
      procps \
      vim

FROM base as os_setup


RUN getent group ncsadmin || groupadd ncsadmin \
    && useradd --create-home --home-dir /home/developer --no-user-group \
        --no-log-init --groups ncsadmin  --shell /bin/bash developer \
    && echo "developer:C1sco12345" | chpasswd \
    && echo 'alias ll="ls -al"' >> /etc/profile.d/alias.sh \
    && echo 'export PS1="\u@\h:\W > "' >> /etc/bash.bashrc \
    && echo 'export PS1="\u@\h:\W > "' >> /home/developer/.bashrc \
    && echo 'export PATH="/opt/ncs/current/bin:$PATH"' >> /etc/profile.d/local.sh \
    && echo NCS_DIR=$NCS_DIR >> /etc/environment \
    && echo NCS_LOG_DIR=$NCS_LOG_DIR >> /etc/environment \
    && echo NCS_RUN_DIR=$NCS_RUN_DIR >> /etc/environment \
    && echo NCS_CONFIG_DIR=$NCS_CONFIG_DIR >> /etc/environment

FROM os_setup as sandbox_setup

ARG ADMIN_PASSWORD
ENV HOME=/home/developer \
    ADMIN_PASSWORD=$ADMIN_PASSWORD

EXPOSE 53 179 443 2024 4369 8080

COPY neds /tmp/neds
COPY config /tmp/config
COPY scripts /tmp/scripts
COPY packages /tmp/packages

RUN mkdir -p /home/developer/.ssh \
    && mv /tmp/config/limits.conf /etc/security/limits.conf \
    && mv /tmp/config/phase0/ncs.conf.xml $NCS_CONFIG_DIR/ncs.conf \
    && mv /tmp/config/phase1/authgroups.xml $NCS_RUN_DIR/cdb/ \
    && mv /tmp/config/devices/groups.xml $NCS_RUN_DIR/cdb/ \
    && mv /tmp/config/devices/devices.xml $NCS_RUN_DIR/cdb/ \
    && mv /tmp/scripts/display_directory_tree.sh /usr/bin/tree \
    && mv /tmp/scripts/10-cron-logrotate.sh $NCS_CONFIG_DIR/post-ncs-start.d/10-cron-logrotate.sh \
    && mv /tmp/scripts/post_start_processes.sh $NCS_CONFIG_DIR/post-ncs-start.d/post_start_processes.sh \
    && chmod a+x /usr/bin/tree \
    && chmod a+x $NCS_CONFIG_DIR/post-ncs-start.d/10-cron-logrotate.sh \
    && chmod a+x $NCS_CONFIG_DIR/post-ncs-start.d/post_start_processes.sh \
    && chmod a+x /tmp/scripts/setup_add_neds.sh \
    && chmod a+x /tmp/scripts/setup_add_packages.sh \
    && ./tmp/scripts/setup_add_neds.sh \
    && ./tmp/scripts/setup_add_packages.sh \
    && cp /tmp/config/ssh/sshd_config /home/developer/.ssh \
    && chown -R developer:ncsadmin \
        /nso/ \
        /tmp/ \
        /opt/ncs/ \
        /defaults/* \
        /home/developer \
        $NCS_LOG_DIR \
        $NCS_CONFIG_DIR \
    && rm -rf /tmp/*


WORKDIR $HOME

USER developer

RUN mkdir -p /nso/etc/ssh \
    && ssh-keygen -N '' -t ed25519 -f /nso/etc/ssh/ssh_host_ed25519_key
