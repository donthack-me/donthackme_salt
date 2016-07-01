git:
  pkg.installed

donthackme_scripts:
  git.latest:
    - name: https://github.com/donthack-me/donthackme_scripts.git
    - target: /opt/donthackme_scripts
    - require:
      - pkg: git

/opt/donthackme_scripts/venv:
  virtualenv.managed:
    - requirements: /opt/donthackme_scripts/requirements.txt
    - require:
      - git: donthackme_scripts

add to load balancer:
  cmd.run:
    - name: ./venv/bin/python ./lb_add_remove.py -u {{ pillar["openstack"]["username"] }} -k {{ pillar["openstack"]["api_key"] }} -l {{ pillar["loadbalancer_id"] }} -r {{ pillar["new_region"] }} -i {{ pillar["new_servicenet_ip"] }}
    - cwd: /opt/donthackme_scripts/
    - require:
      - virtualenv: /opt/donthackme_scripts/venv
