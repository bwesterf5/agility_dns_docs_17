############################################
Profiles
############################################

-  A DNS profile tells the DNS Listener how to process DNS traffic.
       We’re going to make some basic tweaks.

-  In the GUI, navigate to: **DNS > Delivery > Profiles > DNS: Create**

-  Create a new DNS profile as shown in the following table. Keep the
       defaults if not noted in the table.

+----------------------------------+----------------------------------+
| **Name**                         | example.com\_dns\_profile        |
+==================================+==================================+
| **Unhandled Query Action**       | Drop                             |
+----------------------------------+----------------------------------+
| **Use BIND Server on Big-IP**    | Disabled                         |
+----------------------------------+----------------------------------+
| **Logging**                      | Enabled                          |
+----------------------------------+----------------------------------+
| **Logging Profile**              | example\_dns\_logging\_profile   |
+----------------------------------+----------------------------------+
| **AVR statistics Sample Rate**   | Enabled, 1/1 queries sampled     |
+----------------------------------+----------------------------------+
|                                  | Click Finished                   |
+----------------------------------+----------------------------------+

