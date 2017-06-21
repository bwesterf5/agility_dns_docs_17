###############################################
gtm1.site2
###############################################

Navigate to: **DNS  ››  GSLB : Servers : Server List**  
https://gtm1.site2.example.com/tmui/Control/jspmap/tmui/globallb/server/list.jsp

Create a Server Object as defined in the table below:

.. csv-table::
   :header: "Setting", "Value"
   :widths: 15, 15

   "Name", "gtm1.site2_server"
   "Data Center", "site2_datacenter"
   "Devices", "198.51.100.40"
   "Health Monitors", "bigip"
   "Virtual Server Discovery", "Enabled"

.. figure:: ./images/gtm1.site2_create.png
