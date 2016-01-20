
==================================
Home Assistant
==================================

Home Assistant is an open-source home automation platform running on Python 3. Track and control all devices at home and automate control.
	
Sample pillars
==============

Single homeassistant service

.. code-block:: yaml

    home_assistant:
      server:
        enabled: true
        bind:
          address: 0.0.0.0
          port: 8123

Read more
=========

* https://home-assistant.io/getting-started/
