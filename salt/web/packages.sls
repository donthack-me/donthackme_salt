web_packages:
  pkg.installed:
    - pkgs: {{ pillar["web_packages"] }}

{% for package in pillar["web_pip_packages"] %}
{{ package }}:
  pip.installed:
    - require:
      - pkg: web_packages 
{% endfor %}
