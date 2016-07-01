letsencrypt:
  config: |
    server = https://acme-v01.api.letsencrypt.org/directory
    email = russell.troxel@rackspace.com
    authenticator = webroot
    webroot-path = /var/www/letsencrypt
    agree-tos = True
    renew-by-default = True
    redirect: True
  domainsets:
    api:
      - api.donthack.me
