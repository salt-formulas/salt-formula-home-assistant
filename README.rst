
======================
Home Assistant formula
======================

Home Assistant is an open-source home automation platform running on Python 3.
Track and control all devices at home and automate control.
	
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

home-assistant service wit git based configuration

.. code-block:: yaml

    home_assistant:
      server:
        enabled: true
        bind:
          address: 0.0.0.0
          port: 8123
        config:
          engine: git
          address: '${_param:home_assistant_config_repository}'
          branch: ${_param:home_assistant_config_revision}


More information
================

* https://home-assistant.io/getting-started/


Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use Github issue tracker for specific salt
formula:

    https://github.com/salt-formulas/salt-formula-home-assistant/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

You can also join salt-formulas-users team and subscribe to mailing list:

    https://launchpad.net/~salt-formulas-users

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

    https://github.com/salt-formulas/salt-formula-home-assistant

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net
