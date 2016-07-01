docker package dependencies:
  pkg.installed:
    - pkgs:
      - apt-transport-https
      - iptables
      - ca-certificates
      - python-apt

docker package repository:
  pkgrepo.managed:
    - name: deb https://apt.dockerproject.org/repo debian-jessie main
    - humanname:  Docker Package Repository
    - keyid: 58118E89F3A912897C070ADBF76221572C52609D
    - keyserver: hkp://p80.pool.sks-keyservers.net:80
    - file: /etc/apt/sources.list.d/docker.list
    - refresh_db: True
    - require_in:
      - pkg: docker package
    - require:
      - pkg: docker package dependencies

docker package:
  pkg.installed:
    - name: docker-engine 
    - require:
      - pkg: docker package dependencies
      - pkgrepo: docker package repository
      - file: docker-config

docker-config:
  file.managed:
    - name: /etc/default/docker
    - source: salt://vault/files/docker-config
    - template: jinja
    - mode: 644
    - user: root

docker-unit-drop-in:
  file.managed:
    - name: /etc/systemd/system/docker.service.d/docker-defaults.conf
    - source: salt://vault/files/docker-systemd.drop-in
    - makedirs: True
    - require:
      - file: docker-config

reload-systemd:
  module.wait:
    - name: service.systemctl_reload
    - watch:
      - file: docker-unit-drop-in

docker-service:
  service.running:
    - name: docker
    - enable: True
    - watch:
      - file: /etc/default/docker
      - pkg: docker package
