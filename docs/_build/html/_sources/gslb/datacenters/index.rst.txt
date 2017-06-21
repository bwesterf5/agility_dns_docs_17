############################################
Datacenters
############################################

Navigate to: **DNS > GSLB > Data Centers > Data Center List: Create**

https://gtm1.site1.example.com/tmui/Control/jspmap/xsl/gtm_dc/list

.. note::   The tasks in this section are to be only completed on gtm1.site1

Create two darta centers according to the table below:

.. csv-table::
   :header: "Setting", "Value"
   :widths: 15, 15

   "Name", "site1_datacenter"
   "Name", "site2_datacenter"

.. image:: images/create_datacenters.png

TMSH command to insert a data center..
::
  create gtm datacenter <dc_name>

.. toctree::
   :maxdepth: 1
   :hidden:

   servers/index
   trust.rst
   join-to_sync-group.rst
   virtuals.rst
   links.rst
   autodiscover.rst
