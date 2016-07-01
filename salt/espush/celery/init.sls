celery_packages:
  pkg.installed:
    - pkgs:
      - python-pip
      - python-dev

root_pip_packages:
  pip.installed:
    - pkgs:
      - virtualenv
    - require:
      - pkg: celery_packages

git:
  pkg.installed

donthackme_elasticsearch:
  git.latest:
    - name: https://github.com/donthack-me/donthackme_elasticsearch.git
    - target: /opt/donthackme_elasticsearch
    - require:
      - pkg: git

/opt/donthackme_elasticsearch/venv:
  virtualenv.managed:
    - requirements: /opt/donthackme_elasticsearch/requirements.txt
    - require:
      - git: donthackme_elasticsearch

donthackme_es_config:
  file.managed:
    - name: /etc/donthackme_elasticsearch/config.yml
    - source: salt://espush/files/donthackme_elasticsearch.config
    - makedirs: True
    - template: jinja
