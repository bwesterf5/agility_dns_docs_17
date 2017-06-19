############################################
DNS
############################################

-  A DNS profile tells the DNS Listener how to process DNS traffic.
       We’re going to make some basic tweaks.

-  In the GUI, navigate to: **DNS > Delivery > Profiles > DNS: Create**

-  Create a new DNS profile as shown in the following table. Keep the
       defaults if not noted in the table.


.. csv-table::
   :header: "Setting", "Value"
   :widths: 15, 15

   "Name", "example.com_dns_profile"
   "Unhandled Query Action", "Drop"
   "Use BIND Server on Big-IP", "Disabled"
   "Logging", "Enabled"
   "Logging Profile", "example_dns_logging_profile"
   "AVR statistics Sample Rate", "Enabled, 1/1 queries sampled"

.. figure:: ./images/dns_profile_flyout.png

.. figure:: ./images/dns_profile_settings.png

.. rubric:: References
.. [#f1] https://support.f5.com/csp/article/K14510
