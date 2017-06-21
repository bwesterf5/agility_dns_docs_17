###############################################
site2_ha_pair
###############################################

* Navigate to: **DNS > GSLB > Servers > Server List: Create**

* Create a Server Object as defined in the table and diagram below.

.. csv-table::
   :header: "Setting", "Value"
   :widths: 15, 15

   "Name", "site2_ha_pair"
   "Data Center", "site2_datacenter"
   "Devices", "bigip1.site2: 198.51.100.37"
   "Devices", "bigip2.site2: 198.51.100.38"
   "Health Monitors", "bigip"
   "Virtual Server Discovery", "Enabled"

