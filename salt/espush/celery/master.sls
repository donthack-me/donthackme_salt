include:
  - espush.celery

master_celery_user_present:
  user.present:
    - name: celery
    - fullname: Celery Exec User
    - shell: /bin/false
    - system: True

master_donthackme ensure log location:
  file.directory:
    - name: /var/log/celery/
    - user: celery
    - group: celery
    - mode: 755
    - makedirs: True
    - require:
      - user: master_celery_user_present

donthackme_espush_dropin:
  file.managed:
    - name: /etc/systemd/system/espush.service
    - source: salt://espush/files/espush.service
    - makedirs: True
    - require:
      - sls: espush.celery

master-reload-systemd:
  module.wait:
    - name: service.systemctl_reload
    - watch:
      - file: donthackme_espush_dropin
    - require:
      - sls: espush.celery

espush_service:
  service.running:
    - name: espush
    - enable: True
    - require:
      - user: master_celery_user_present
    - watch:
      - sls: espush.celery
      - file: donthackme_espush_dropin
      - git: donthackme_elasticsearch
