############################################
Listeners
############################################

We are going to create UDP/TCP external Listeners. You will use this IP
as a target address when querying GTM.

In the GUI, navigate to: **DNS > Delivery > Listeners > Listener List:
Create**

-  Create two external Listeners as shown in the tables below. Keep the
       defaults if not noted in the table.

+---------------------------------+--------------------------------------------------+
| **Name**                        | isp2\_site1\_ns1.example.com\_udp\_53\_virtual   |
+=================================+==================================================+
| **Destination**                 | Host: 203.0.113.8                                |
+---------------------------------+--------------------------------------------------+
| **Protocol Profile (Client)**   | example.com\_dns\_profile                        |
+---------------------------------+--------------------------------------------------+
| **DNS Profile**                 | example.com\_dns\_profile                        |
+---------------------------------+--------------------------------------------------+
|                                 | Click Finished                                   |
+---------------------------------+--------------------------------------------------+
