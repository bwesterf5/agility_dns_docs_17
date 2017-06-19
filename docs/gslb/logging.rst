############################################
Logging
############################################

Configure DNS query and response logging.

-  For lab purposes, we are going to use local-syslog as our logging
       destination. *Note that remote high speed logging is the
       recommendation for production environments.*

#. Using Internet Explorer, login to https://gtm1.site1.example.com

#. Navigate to **DNS > Delivery > Profiles > Other > DNS Logging: Create**

#. Create a new DNS logging profile as shown in the table below. Retain the defaults if not noted in the table.

.. csv-table::
   :header: "Setting", "Value"
   :widths: 15, 15

   "Name", "example_dns_logging_profile"
   "Log Publisher", "sys-db-access-publisher"
   "Log Responses", "enabled"
   "Include Query ID", "enabled"

.. figure:: ./images/dns_logging_profile_flyout.png

.. figure:: ./images/dns_logging_profile_create.png
