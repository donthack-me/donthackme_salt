include:
  - .uwsgi
  - .nginx

{% set ips = salt["grains.get"]("ip4_interfaces") %}
web_inform_master:
  event.send:
    - name: donthackme/loadbalancer/pool/update
    - data:
        nova_uuid: {{ salt["grains.get"]("nova_uuid") }}
        region: {{ salt["grains.get"]("region") }}
        servicenet_ip: {{ ips["eth1"][0] }}
