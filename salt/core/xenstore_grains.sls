nova_uuid:
  grains.present:
    - value:  {{ salt["cmd.run"]("xenstore-read name | sed 's/instance-//'") }}

region:
  grains.present:
    - value: {{ salt["cmd.run"]("xenstore-read vm-data/provider_data/region") }} 


