iptables_input_policy:
  iptables.set_policy:
    - table: filter
    - chain: INPUT
    - policy: ACCEPT

iptables_forward_policy:
  iptables.set_policy:
    - table: filter
    - chain: FORWARD
    - policy: ACCEPT

iptables_tcp_chain:
  iptables.chain_present:
    - table: filter
    - name: TCP

iptables_udp_chain:
  iptables.chain_present:
    - table: filter
    - name: UDP

related_established_iptables_rule:
  iptables.insert:
    - position: 1
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: conntrack
    - ctstate: RELATED,ESTABLISHED
    - save: True
    - require_in:
      - iptables: INPUT - TCP Reject

tcp_chain_jump:
  iptables.insert:
    - table: filter
    - chain: INPUT
    - jump: TCP
    - proto: tcp
    - match: conntrack
    - ctstate: NEW
    - tcp-flags: FIN,SYN,RST,ACK SYN
    - position: 2
    - save: True
    - require_in:
      - iptables: INPUT - TCP Reject
    - require:
      - iptables: iptables_tcp_chain

udp_chain_jump:
  iptables.insert:
    - table: filter
    - chain: INPUT
    - jump: UDP
    - proto: udp
    - match: conntrack
    - ctstate: NEW
    - position: 3
    - save: True
    - require_in:
      - iptables: INPUT - TCP Reject
    - require:
      - iptables: iptables_udp_chain

{% if "webhead" in salt["grains.get"]("roles", []) %}
salt_http_iptables_rule:
  iptables.append:
    - table: filter 
    - chain: TCP
    - jump: ACCEPT
    - dport: 80
    - proto: tcp
    - save: True
    - require_in:
      - iptables: INPUT - TCP Reject
    - require:
      - iptables: iptables_tcp_chain

salt_https_iptables_rule:
  iptables.append:
    - table: filter
    - chain: TCP
    - jump: ACCEPT
    - dport: 443
    - proto: tcp
    - save: True
    - require_in:
      - iptables: INPUT - TCP Reject
    - require:
      - iptables: iptables_tcp_chain
{% endif %}

{% if "saltmaster" in salt["grains.get"]("roles", []) %}
salt_pub_iptables_rule:
  iptables.append:
    - table: filter 
    - chain: TCP 
    - jump: ACCEPT
    - dport: 4505
    - proto: tcp
    - save: True
    - require_in:
      - iptables: INPUT - TCP Reject
    - require:
      - iptables: iptables_tcp_chain

salt_sub_iptables_rule:
   iptables.append:
     - table: filter 
     - chain: TCP
     - jump: ACCEPT
     - dport: 4506
     - proto: tcp
     - save: True
     - require_in:
       - iptables: INPUT - TCP Reject
     - require:
       - iptables: iptables_tcp_chain

salt_nfs_iptables_rule_1:
   iptables.append:
     - table: filter
     - chain: TCP
     - jump: ACCEPT
     - dport: 111
     - proto: tcp
     - save: True
     - require_in:
       - iptables: INPUT - TCP Reject
     - require:
       - iptables: iptables_tcp_chain

salt_nfs_iptables_rule_2:
   iptables.append:
     - table: filter
     - chain: TCP
     - jump: ACCEPT
     - dport: 2049
     - proto: tcp
     - save: True
     - require_in:
       - iptables: INPUT - TCP Reject
     - require:
       - iptables: iptables_tcp_chain

salt_nfs_iptables_rule_3:
   iptables.append:
     - table: filter
     - chain: UDP
     - jump: ACCEPT
     - dport: 111
     - proto: udp
     - save: True
     - require_in:
       - iptables: INPUT - TCP Reject
     - require:
       - iptables: iptables_udp_chain

salt_nfs_iptables_rule_4:
   iptables.append:
     - table: filter
     - chain: UDP
     - jump: ACCEPT
     - dport: 2049
     - proto: udp
     - save: True
     - require_in:
       - iptables: INPUT - TCP Reject
     - require:
       - iptables: iptables_udp_chain
{% endif %}

sshd_iptables_rule:
  iptables.append:
    - table: filter 
    - chain: TCP
    - jump: ACCEPT
    - dport: 7322
    - proto: tcp
    - save: True
    - require_in:
      - iptables: INPUT - TCP Reject
    - require:
      - iptables: iptables_tcp_chain

loopback_rule:
  iptables.insert:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - in-interface: lo
    - position: 4
    - save: True
    - require_in:
      - iptables: INPUT - TCP Reject

INPUT - TCP Reject:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: REJECT
    - proto: tcp
    - reject-with: tcp-reset
    - save: True

INPUT - UDP Reject:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: REJECT
    - proto: tcp
    - reject-with: icmp-port-unreachable
    - save: True
    - require:
      - iptables: INPUT - TCP Reject

INPUT - Reject All:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: REJECT
    - reject-with: icmp-proto-unreachable
    - save: True
    - require:
      - iptables: INPUT - TCP Reject
