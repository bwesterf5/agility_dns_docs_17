###############################################
site1_ha_pair
###############################################

* Navigate to: **DNS > GSLB > Servers > Server List: Create**

* Create a Server Object as defined in the table and diagram below.

.. csv-table::
   :header: "Setting", "Value"
   :widths: 15, 15

   "Name", "site1_ha_pair"
   "Data Center", "site1_datacenter"
   "Devices", "bigip1.site1: 203.0.113.5"
   "Devices", "bigip2.site1: 203.0.113.6"
   "Health Monitors", "bigip"
   "Virtual Server Discovery", "Enabled"

