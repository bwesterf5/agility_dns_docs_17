############################################
Listeners
############################################

A listener object is an spcialized virtual server that is configured to respond to DNS queries.

In the GUI, navigate to: **DNS > Delivery > Listeners > Listener List:
Create**

Create a listeners with the values from the table below. Use defaults if not noted in the table.

.. csv-table::
   :header: "Setting", "Value"
   :widths: 15, 15

   "Name", "isp1_site1_ns1.example.com_udp_53_virtual"
   "Destination", "203.0.113.8"
   "Protocol Profile (Client)", "example.com_udp-dns_profile"
   "DNS Profile", "example.com_dns_profile"

.. figure:: ./images/udp-dns_profile.png


.. rubric:: References
.. [#f1] Find a cool link to share
