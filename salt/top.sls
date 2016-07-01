base:
  '*':
    - core.packages
    - core.ssh
    - core.iptables
    - core.xenstore_grains
    - users
  'roles:webhead':
    - match: grain
    - web.uwsgi
    - web.nginx
    - nfs.client
    - nfs.mount
    - web.complete_event
  'roles:redis':
    - match: grain
    - redis
  'roles:celeryworker':
    - match: grain
    - espush.celery.worker
  'roles:celerymaster':
    - match: grain
    - espush.celery.master
  'salt.*':
    - vault.docker
    - vault.containers
    - letsencrypt.directory
    - nfs.server
