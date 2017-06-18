##################
Topology
##################

  The lab environment consists of two datacenters and a branch office. Each datacenter has a standalone GTM, an HA pair of fully licensed BIG-IP's, and a LAMP container. The branch office has an AD server and a Windows-7 jumpbox. The lab environment is pre-configured with basic system and networking settings.


.. figure:: ./images/Agility_DNS.png


Use Internet Explorer Browser on the jumpbox to log in via the GUI, or use Putty for SSH to get a shell.

GUI username = **admin/admin**\s\s
CLI username = **root/default**

Management IP Addresses:

+---------------------------+---------------------------+
| **Site 1**                | **Site 2**                |
+===========================+===========================+
| bigip1.site1 = 10.1.10.11 | bigip1.site2 = 10.1.10.21 |
+---------------------------+---------------------------+
| bigip2.site1 = 10.1.10.12 | bigip2.site2 = 10.1.10.22 |
+---------------------------+---------------------------+
| gtm1.site1 = 10.1.10.13   | gtm1.site2 = 10.1.10.23   |
+---------------------------+---------------------------+

Service IP Addresses:

+--------------------------------+---------------------------------+
| **Site 1**                     | **Site 2**                      |
+================================+=================================+
| www.example.com = 203.0.113.9  | www.example.com = 198.51.100.41 |
+--------------------------------+---------------------------------+
| vpn.example.com = 203.0.113.10 | vpn.example.com = 198.51.100.42 |
+--------------------------------+---------------------------------+

