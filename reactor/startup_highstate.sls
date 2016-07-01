reactor_highstate:
  cmd.state.apply:
    - tgt: {{ data['name'] }}
