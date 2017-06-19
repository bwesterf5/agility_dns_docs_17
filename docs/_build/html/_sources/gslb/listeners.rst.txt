############################################
Listeners
############################################

A listener object is an spcialized virtual server that is configured to respond to DNS queries.

In the GUI, navigate to: **DNS > Delivery > Listeners > Listener List: Create**

https://gtm1.site1.example.com/tmui/Control/jspmap/tmui/dns/listener/list.jsp

Create a listener with the values from the table below. Use defaults if not noted in the table.

.. csv-table::
   :header: "Setting", "Value"
   :widths: 15, 15

   "Name", "isp1_site1_ns1.example.com_udp_53_virtual"
   "Destination", "203.0.113.8"
   "Protocol Profile (Client)", "example.com_udp-dns_profile"
   "DNS Profile", "example.com_dns_profile"

.. figure:: images/listener_flyout.png

.. figure:: images/listener_settings.png


.. rubric:: References
.. [#f1] Find a cool link to share
