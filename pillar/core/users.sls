users:
  russell:
    fullname: Russell Troxel
    createhome: True
    sudouser: True
    sudo_rules:
      - ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    groups:
      - users
    ssh_auth_sources:
      - salt://core/keys/russell.id_rsa.pub
    manage_vimrc: True
    maange_bashrc: True
    manage_profile: True
    uid: 1001
  reese:
    fullname: Reese McJunkface
    createhome: True
    sudouser: True
    sudo_rules:
      - ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    groups:
      - users
    ssh_auth_sources:
      - salt://core/keys/reese.id_rsa.pub
    manage_vimrc: True
    manage_bashrc: True
    manage_profile: True
    uid: 1002
  brandon:
    fullname: Brandon Carter
    createhome: True
    sudouser: True
    sudo_rules:
      - ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    groups:
      - users
    ssh_auth_sources:
      - salt://core/keys/brandon.id_rsa.pub
    manage_vimrc: True
    manage_bashrc: True
    manage_profile: True
    uid: 1003
      
