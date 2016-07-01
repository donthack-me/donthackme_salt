nginx:
  pkg.installed

donthackme_vhost:
  file.managed:
    - name: /etc/nginx/sites-enabled/donthackme.conf
    - source: salt://web/files/bootstrap_nginx.conf
    - require:
      - pkg: nginx

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
      - cmd: nginx_dhparams
      - pkg: nginx
