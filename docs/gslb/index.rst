############################################
GSLB
############################################

* Students will configure F5 DNS servers to support GSLB services on a single device in site1.
* Join an additional F5 DNS server in site2 to the GSLB cluster.
* A Windows AD DNS server is authoritative for the zone example.com and contains a static A record for "www.example.com", which resolves to 203.0.113.9.
* Students will add glue records and delegate gslb.example.com to the F5 GSLB DNS servers.
* Convert the A record "www.example.com" to be a CNAME record pointing to *www.gslb.example.com*.

At the end of the lab students will have configured F5 GSLB DNS servers to alternately resolve www.example.com to 203.0.113.9 and 198.51.100.41.

* Where were you when v9 was released ?

.. image:: ./images/v9.png
   :width: 500

.. toctree::
   :maxdepth: 2
   :hidden:

   global-settings.rst
   profiles/index
   listeners/index
   datacenters/index
   pools.rst
   wip.rst
   delegation.rst
   l4_acl.rst
   usecases/index.rst
