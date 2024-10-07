# Dockerfile
FROM ubuntu:24.04

# Устанавливаем необходимые пакеты
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    zsh \
    && apt-get clean

# Настраиваем SSH
RUN mkdir /var/run/sshd

# Создаём пользователя и даём ему права sudo
RUN useradd -m -s /bin/bash ansible \
    && echo "ansible:ansible" | chpasswd \
    && usermod -aG sudo ansible 

RUN mkdir -p /home/ansible/.ssh && \
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGk8enjOA7TNE+8oqBZjH0T0vHFM8tg/y7VY7k0aP6hd root@server" > /home/ansible/.ssh/authorized_keys \
    && chown -R ansible:ansible /home/ansible/.ssh \
    && chmod 700 /home/ansible/.ssh  \
    && chmod 600 /home/ansible/.ssh/authorized_keys

# Разрешаем sudo без пароля
RUN echo "ansible ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Отключаем возможность логина root и пустых паролей
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/' /etc/ssh/sshd_config

# Открываем порты
EXPOSE 22 80

# Стартуем SSH и Nginx
#CMD ["/bin/bash", "-c", "service ssh start && nginx -g 'daemon off;'"]
CMD ["/bin/bash", "-c", "service ssh start && tail -f /dev/null"]
