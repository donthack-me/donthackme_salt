test_new_node:
  local.http.query:
    - name: https://{{ data["data"]["servicenet_ip"] }}/admin/health
    - status: 200
    - match: All Good!
    - verify_ssl: False

add_to_loadbalancer:
  local.state.apply:
    - tgt: 'salt.donthack.me'
    - arg:
      - web.add_to_lb
    - kwarg:
        pillar:
          new_nova_uuid: {{ data["data"]["nova_uuid"] }}
          new_servicenet_ip: {{ data["data"]["servicenet_ip"] }}
          new_region: {{ data["data"]["region"] }}
    - require:
      - http: test_new_node
