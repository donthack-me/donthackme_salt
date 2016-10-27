base:
  "*":
    - core.packages
    - core.users
  "roles:saltmaster":
    - match: grain
    - letsencrypt.nfs-server
    - letsencrypt.config
#    - openstack
  "roles:redis":
    - match: grain
    - redis.config
  "roles:celeryworker":
    - match: grain
    - elasticsearch_creds
    - mongo_creds
    - celery
  "roles:celerymaster":
    - match: grain
    - elasticsearch_creds
    - mongo_creds
    - celery
  "roles:webhead":
    - match: grain
    - letsencrypt.nfs-client
    - mongo_creds
  'roles:cowrie':
    - match: grain
    - cowrie
