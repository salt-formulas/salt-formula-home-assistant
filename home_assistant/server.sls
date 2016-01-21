{%- from "home_assistant/map.jinja" import server with context %}
{%- if server.enabled %}

home_assistant_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

{{ server.dir.base }}:
  virtualenv.manage:
  - requirements: salt://home_assistant/files/requirements.txt
  - require:
    - pkg: home_assistant_packages

home_assistant_user:
  user.present:
  - name: home_assistant
  - system: true
  - home: {{ server.dir.base }}
  - require:
    - virtualenv: {{ server.dir.base }}

home_assistant_dir:
  file.directory:
  - names:
    - /etc/home_assistant
    - /var/log/home_assistant
  - mode: 700
  - makedirs: true
  - user: home_assistant
  - require:
    - virtualenv: {{ server.dir.base }}

home_assistant_config:
  file.managed:
  - name: /etc/home_assistant/configuration.yaml
  - source: salt://home_assistant/files/configuration.yaml
  - template: jinja
  - user: home_assistant
  - mode: 600
  - require:
    - file: home_assistant_dir

{%- if server.known_device is defined %}

home_assistant_know_devices:
  file.managed:
  - name: /etc/home_assistant/known_devices.yaml
  - source: salt://home_assistant/files/known_devices.yaml
  - template: jinja
  - user: home_assistant
  - mode: 600
  - require:
    - file: home_assistant_dir

{%- endif %}

{%- endif %}