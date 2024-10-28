# Packages

The [router package](packages/router) is included as example for users as a starting point. Is a simple package for managing `DNS`, `NTP`, `SYSLOG` configuration on the network devices used in the Sandbox.

The Sandbox adds a third-party package [rest-api-explorer](https://gitlab.com/nso-developer/rest-api-explorer/-/tree/master). This package helps getting `REST` APIs from NSO (only works on Chrome) using a swagger client.

If you want to use the `rest-api-explorer` package, place the the `tar.gz` file in this directory, at the **same level as this README file**. The [setup_add_packages script](../scripts/setup_add_packages.sh) picks it along the router package, compile them, and create a symbolic link for NSO to use.
