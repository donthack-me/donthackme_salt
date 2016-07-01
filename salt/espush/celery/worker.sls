include:
  - espush.celery

celery_user_present:
  user.present:
    - name: celery
    - fullname: Celery Exec User
    - shell: /bin/bash
    - system: True

donthackme ensure log location:
  file.directory:
    - name: /var/log/celery/
    - user: celery
    - group: celery
    - mode: 755
    - makedirs: True
    - require:
      - user: celery_user_present

donthackme ensure pid location:
  file.directory:
    - name: /var/run/celery/
    - user: celery
    - group: celery
    - mode: 755
    - makedirs: True
    - require:
      - user: celery_user_present

donthackme_celery_config:
  file.managed:
    - name: /etc/conf.d/celery
    - source: salt://espush/files/celery.conf
    - makedirs: True
    - template: jinja

donthackme_celery_dropin:
  file.managed:
    - name: /etc/systemd/system/celery.service
    - source: salt://espush/files/celery.service
    - makedirs: True
    - require:
      - sls: espush.celery

reload-systemd:
  module.wait:
    - name: service.systemctl_reload
    - watch:
      - file: donthackme_celery_dropin
    - require:
      - sls: espush.celery

espush_celery_service:
  service.running:
    - name: celery
    - enable: True
    - require:
      - user: celery_user_present
      - file: donthackme ensure log location
      - file: donthackme ensure pid location
    - watch:
      - sls: espush.celery
      - file: donthackme_celery_dropin
      - file: donthackme_celery_config
      - git: donthackme_elasticsearch
