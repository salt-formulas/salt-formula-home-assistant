{%- if pillar.home_assistant is defined %}
include:
{%- if pillar.home_assistant.server is defined %}
- home_assistant.server
{%- endif %}
{%- endif %}
