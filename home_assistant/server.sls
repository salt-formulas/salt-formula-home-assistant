{%- from "home_assistant/map.jinja" import server with context %}
{%- if server.enabled %}

home_assistant_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

home_assistant_user:
  user.present:
  - name: home_assistant
  - system: true
  - home: {{ server.dir.base }}

{{ server.dir.base }}:
  virtualenv.manage:
  - user: home_assistant
  - system_site_packages: True
  - requirements: salt://home_assistant/files/requirements.txt
  - python: /usr/bin/python3
  - require:
    - pkg: home_assistant_packages
    - user: home_assistant_user

home_assistant_install:
  pip.installed:
  {%- if server.source is defined and server.source.get("engine", "git") %}
  - editable: git+{{ server.source.address }}@{{ server.source.version }}#egg=homeassistant
  {%- else %}
  - name: homeassistant{%- if server.get('source', {}).version is defined %}=={{ server.source.version }}{%- endif %}
  {%- endif %}
  - user: home_assistant
  - pre_releases: True
  - bin_env: {{ server.dir.base }}
  - exists_action: w
  - require:
    - virtualenv: {{ server.dir.base }}
    - pkg: home_assistant_packages

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

{%- if server.config.engine == 'git' %}

home_assistant_config:
  git.latest:
  - name: {{ server.config.address }}
  - user: home_assistant
  - target: /etc/home_assistant
  - rev: {{ server.config.revision|default(server.config.branch) }}
  {%- if grains.saltversion >= "2015.8.0" %}
  - branch: {{ server.config.branch|default(server.config.revision) }}
  {%- endif %}
  {%- if server.config.identity is defined %}
  - identity: {{ server.config.identity }}
  {%- endif %}
  - force_reset: {{ server.config.force_reset|default(False) }}

{%- else %}

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

home_assistant_service_script:
  file.managed:
  - name: /etc/systemd/system/home-assistant.service
  - source: salt://home_assistant/files/home-assistant.service
  - template: jinja
  - user: root
  - mode: 644
  - watch_in:
    - module: home_assistant_restart_systemd

home_assistant_service:
  service.running:
  - name: home-assistant
  - enable: true
  - watch:
    - module: home_assistant_restart_systemd
    - file: home_assistant_service_script

home_assistant_restart_systemd:
  module.wait:
  - name: service.systemctl_reload

{%- endif %}
