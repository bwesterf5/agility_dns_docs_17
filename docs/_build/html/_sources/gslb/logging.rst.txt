############################################
Logging
############################################

  Students will configure an F5 DNS server to support GSLB services on a single device in site1, and subsequently join an additional F5 DNS server in site2 to the GSLB cluster. A Windows AD DNS server is authoritative for the zone example.com and contains a static A record for "www.example.com", which resolves to 203.0.113.9. Students will add glue records and delegate gslb.example.com to the F5 GSLB DNS servers, and convert the A record "www.example.com" to be a CNAME record pointing
  to "www.gslb.example.com". At the end of the lab students will observe that the F5 GSLB DNS servers will alternately resolve www.example.com to 203.0.113.9 and 198.51.100.41. 
  
-  You are going to configure DNS query and response logging. To do
       this, you must tell GTM where to send logs to (a log publisher)
       and what specifically to log (DNS logging profile).

-  For lab purposes, we are going to use local-syslog as our logging
       destination. *Note that remote high speed logging is the
       recommendation for production environments.*

#. Open Internet Explorer and login to https://gtm1.site1.example.com https://10.1.10.13

#. In the GUI, navigate to: **DNS > Delivery > Profiles > Other > DNS Logging: Create**

#. Create a new DNS logging profile as shown in the table below. Keep
       the defaults if not noted in the table.

+------------------------+----------------------------------+
| **Name**               | example\_dns\_logging\_profile   |
+========================+==================================+
| **Log Publisher**      | Select sys-db-access-publisher   |
+------------------------+----------------------------------+
| **Log Responses**      | Enabled                          |
+------------------------+----------------------------------+
| **Include Query ID**   | Enabled                          |
+------------------------+----------------------------------+
|                        | Click Finished                   |
+------------------------+----------------------------------+

-  Your new dns-logging profile should now have all options enabled.

