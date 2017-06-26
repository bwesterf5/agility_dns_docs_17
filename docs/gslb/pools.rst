===========================
Pools
===========================

Navigate to: **DNS  ››  GSLB : Pools : Pool List**

https://gtm1.site1.example.com/tmui/Control/jspmap/tmui/globallb/pool/list.jsp?

Create a GTM pool of LTM Virtuals according to the following table:

.. csv-table::
   :header: "Setting", "Value"
   :widths: 15, 15

   "Name", "www.example.com_pool"
   "Type", "A"
   "member", "isp1_site1_www.example.com_tcp_https_virtual"
   "member", "isp2_site2_www.example.com_tcp_https_virtual"

.. image:: ./images/gtm_pool_list.png
   :width: 800

.. image:: ./images/create_gtm_pool.png
   :width: 800

TMSH command to run on only gtm1.site1:

.. code-block:: cli

   tmsh create gtm pool a www.example.com_pool { members add { site1_ha-pair:/Common/isp1_site1_www.example.com_tcp_https_virtual { member-order 0 } site2_ha-pair:/Common/isp2_site2_www.example.com_tcp_https_virtual { member-order 1 } } }
