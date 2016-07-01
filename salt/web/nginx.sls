nginx:
  pkg.installed

donthackme_vhost:
  file.managed:
    - name: /etc/nginx/sites-enabled/donthackme.conf
    - source: salt://web/files/nginx.conf
    - require:
      - pkg: nginx

donthackme_cert:
  file.managed:
    - name: /etc/nginx/certs/donthack.me/fullchain.pem
    - source: salt://api.donthack.me/fullchain.pem
    - makedirs: True
    - mode: 755
    - owner: root
    - group: root

donthackme_key:
  file.managed:
    - name: /etc/nginx/certs/private/donthack.me/privkey.pem
    - source: salt://api.donthack.me/privkey.pem
    - mode: 700
    - makedirs: True
    - group: root
    - owner: root

nginx_dhparams:
  cmd.run:
    - name: sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
    - creates: /etc/ssl/certs/dhparam.pem

donthackme_nginx_restarted:
  service.running:
    - name: nginx
    - enable: True
    - watch:
      - file: donthackme_vhost
      - file: donthackme_cert
      - file: donthackme_key
      - cmd: nginx_dhparams
      - pkg: nginx
