ip6tables_input_policy:
  iptables.set_policy:
    - table: filter
    - chain: INPUT
    - family: ipv6
    - policy: ACCEPT

ip6tables_forward_policy:
  iptables.set_policy:
    - table: filter
    - chain: FORWARD
    - family: ipv6
    - policy: ACCEPT

ip6tables_tcp_chain:
  iptables.chain_present:
    - table: filter
    - family: ipv6
    - name: TCP

ip6tables_udp_chain:
  iptables.chain_present:
    - table: filter
    - family: ipv6
    - name: UDP

related_established_ip6tables_rule:
  iptables.insert:
    - position: 1
    - table: filter
    - family: ipv6
    - chain: INPUT
    - jump: ACCEPT
    - match: conntrack
    - ctstate: RELATED,ESTABLISHED
    - save: True
    - require_in:
      - iptables: 6INPUT - TCP Reject

tcp6_chain_jump:
  iptables.insert:
    - table: filter
    - chain: INPUT
    - family: ipv6
    - jump: TCP
    - proto: tcp
    - match: conntrack
    - ctstate: NEW
    - tcp-flags: FIN,SYN,RST,ACK SYN
    - position: 2
    - save: True
    - require_in:
      - iptables: 6INPUT - TCP Reject
    - require:
      - iptables: ip6tables_tcp_chain

udp6_chain_jump:
  iptables.insert:
    - table: filter
    - chain: INPUT
    - family: ipv6
    - jump: UDP
    - proto: udp
    - match: conntrack
    - ctstate: NEW
    - position: 3
    - save: True
    - require_in:
      - iptables: 6INPUT - UDP Reject
    - require:
      - iptables: ip6tables_udp_chain

6loopback_rule:
  iptables.insert:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - family: ipv6
    - in-interface: lo
    - position: 4
    - save: True
    - require_in:
      - iptables: 6INPUT - TCP Reject

6INPUT - TCP Reject:
  iptables.append:
    - table: filter
    - family: ipv6
    - chain: INPUT
    - jump: REJECT
    - proto: tcp
    - reject-with: icmp6-adm-prohibited
    - save: True

6INPUT - UDP Reject:
  iptables.append:
    - table: filter
    - chain: INPUT
    - family: ipv6
    - jump: REJECT
    - proto: udp
    - reject-with: icmp6-adm-prohibited
    - save: True
    - require:
      - iptables: 6INPUT - TCP Reject

6INPUT - Reject All:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: REJECT
    - family: ipv6
    - reject-with: icmp6-adm-prohibited
    - save: True
    - require:
      - iptables: 6INPUT - TCP Reject

