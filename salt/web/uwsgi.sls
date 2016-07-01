uwsgi_packages:
  pkg.installed:
    - pkgs:
      - python-pip
      - python-dev

root_pip_packages:
  pip.installed:
    - pkgs:
      - virtualenv
    - require:
      - pkg: uwsgi_packages

git:
  pkg.installed

donthackme:
  git.latest:
    - name: https://github.com/donthack-me/donthackme_api.git
    - target: /opt/donthackme_api
    - require:
      - pkg: git

donthackme ensure log location:
  file.directory:
    - name: /var/log/nginx/
    - user: root
    - group: www-data
    - mode: 775
    - makedirs: True

/opt/donthackme_api/venv:
  virtualenv.managed:
    - requirements: /opt/donthackme_api/requirements.txt
    - require:
      - git: donthackme

donthackme_config:
  file.managed:
    - name: /etc/donthackme_api/config.py
    - source: salt://web/files/donthackme_config.py
    - makedirs: True
    - template: jinja
    - require:
      - git: donthackme

donthackme_uwsgi_drop_in:
  file.managed:
    - name: /etc/systemd/system/donthackme_api.service
    - source: salt://web/files/donthackme_api.service
    - makedirs: True
    - require:
      - git: donthackme

reload-systemd:
  module.wait:
    - name: service.systemctl_reload
    - watch:
      - file: donthackme_uwsgi_drop_in
    - requre:
      - virtualenv: /opt/donthackme_api/venv

donthackme_service:
  service.running:
    - name: donthackme_api
    - enable: True
    - watch:
      - file: donthackme_uwsgi_drop_in
      - file: donthackme_config
      - git: donthackme
