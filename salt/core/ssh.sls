sshd_config:
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://core/files/sshd_config.j2
    - template: jinja

sshd_running:
  service.running:
    - name: sshd
    - enable: True
    - watch:
      - file: sshd_config
