#consul:
#  dockerng.running:
#    - image: gliderlabs/consul:latest
#    - hostname: "{{ grains["fqdn"] }}"
#    - port_bindings:
#      - "8400:8400"
#      - "8500:8500"
#      - "8600:53/udp"
#    - entrypoint: "-server -bootstrap"

consul:
  cmd.run:
    - name: /usr/bin/docker run -d --name consul -p 8400:8400 -p 8500:8500 -p 8600:53/udp -h node1 progrium/consul -server -bootstrap
    - stateful:
      - test_name: /usr/bin/docker ls | grep consul
vault:
  cmd.run:
    - name : docker run -d -p 8200:8200 --hostname vault --name vault --link consul:consul --volume /etc/vault/config:/config sjourdan/vault server -config=/config/consul.hcl
    - stateful:
      - test_name: /usr/bin/docker ls | grep vault
