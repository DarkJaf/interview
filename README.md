To run composer "docker-compose up --build -d"


Vault pass: 12345


Специально оставил ключ для ssh в проекте


Все ролы закоментены, можете проверить!


Если честно не понял задание номер 2. то ли нужно было добавить в кастомные пользователи, то ли надо было создать просто роль.
я не добавил его в роли, но думаю сделал бы так

---
- name: Install Zsh
  apt:
    name: zsh
    state: present
  become: true

- name: Install Oh My Zsh for users with Zsh as default shell
  become: true
  shell: |
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  when: ansible_env.SHELL == "/bin/zsh"
