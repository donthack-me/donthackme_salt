redis:
  root_dir: /var/lib/redis
  user: redis
  port: 6379
  bind: 0.0.0.0
  snapshots:
    - '900 1'
    - '300 10'
    - '60  10000'

  lookup:
    svc_state: running
    cfg_name: /etc/redis.conf
    pkg_name: redis-server
    svc_name: redis-server
