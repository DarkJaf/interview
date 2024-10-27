# Dockerfile
FROM ubuntu:24.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    zsh \
    && apt-get clean

# SSH config
RUN mkdir /var/run/sshd

# Create user for ansible
RUN useradd -m -s /bin/bash ansible \
    && echo "ansible:ansible" | chpasswd \
    && usermod -aG sudo ansible 
# Setting up ssh
RUN mkdir -p /home/ansible/.ssh && \
    echo "ENCREYPTED_KEY root@server" > /home/ansible/.ssh/authorized_keys \
    && chown -R ansible:ansible /home/ansible/.ssh \
    && chmod 700 /home/ansible/.ssh  \
    && chmod 600 /home/ansible/.ssh/authorized_keys

# Access sudo without pass
RUN echo "ansible ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Denied root login 
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/' /etc/ssh/sshd_config

# Compose ports
EXPOSE 22 80

# starting ssh
CMD ["/bin/bash", "-c", "service ssh start && tail -f /dev/null"]
