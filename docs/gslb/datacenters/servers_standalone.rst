############################################
Servers - Add your GTM as a Standalone server
############################################

By default, GTM is not self-aware. You will need to configure your BigIP
as a server object.

-  In the GUI, navigate to: **DNS > GSLB > Servers > Server List: Create**

-  Create a Server Object as defined in the table and diagram below.
       Leave default values unless otherwise noted:

+--------------------------------+-------------------------------------------------------+
| **Name**                       | site1-gtm                                             |
+================================+=======================================================+
| **Data Center**                | site1\_datacenter                                     |
+--------------------------------+-------------------------------------------------------+
| **Devices**                    | Click add and specify 203.0.113.7; click add and OK   |
+--------------------------------+-------------------------------------------------------+
| **Health Monitors**            | BIGIP                                                 |
+--------------------------------+-------------------------------------------------------+
| **Virtual Server Discovery**   | Disabled                                              |
+--------------------------------+-------------------------------------------------------+
|                                | Click Finished                                        |
+--------------------------------+-------------------------------------------------------+

|image4|

-  Click on the “Server List” tab at the top menu bar to refresh the
   page. You should see the Server object as green.

   | |image5|
   | What is the status of the site1\_datacenter object now?

Students will be using an LTM objects to on both site1 and site2
datacenters. You will need to create another BigIP objects to do this.
Prior to configuring the Server object, we need to establish trust
between the GTM and LTM. The bigip\_add script will exchange device
certificates to establish a trust relationship.

* Login via SSH using putty to your gtm1.site1 (10.1.10.13) using
   username: **root** password: **default**
* Issue the following commands
  ::
    bigip\_add 203.0.113.5
* Enter ‘\ **yes**\ ’ to proceed and enter ‘\ **default** as the
   password.
* Now Enter::
   big3d\_install 203.0.113.5


.. admonition:: Note that this script likely won’t need to install a new version of the big3d agent… this is just for you to be familiar with the script.

* Repeat same operations (bigip\_add and big3d\_install) for the
following LTM objects: 203.0.113.6, 198.51.100.37, 198.51.100.38

* From the gtm1.site1 GUI, navigate to: **DNS > GSLB > Servers> Server List: Create**

* Create a Server Object as defined in the tables and diagram below.
       Leave default values unless otherwise noted:

+--------------------------------+-----------------------------------------------+
| **Name**                       | site1\_ha\_pair                               |
+================================+===============================================+
| **Product**                    | BIG-IP System                                 |
+--------------------------------+-----------------------------------------------+
| **Data Center**                | site1.datacenter                              |
+--------------------------------+-----------------------------------------------+
| **Devices**                    | Click add and specify                         |
|                                |                                               |
|                                | Name: bigip1.site1                            |
|                                |                                               |
|                                | Address: 203.0.113.5; click add and then OK   |
|                                |                                               |
|                                | Click add and specify                         |
|                                |                                               |
|                                | Name: bigip2.site1                            |
|                                |                                               |
|                                | Address: 203.0.113.6; click add and then OK   |
+--------------------------------+-----------------------------------------------+
| **Health Monitors**            | bigip                                         |
+--------------------------------+-----------------------------------------------+
| **Virtual Server Discovery**   | Enabled                                       |
+--------------------------------+-----------------------------------------------+
|                                | Click Finished                                |
+--------------------------------+-----------------------------------------------+

|image6|

* After a few moments, click on the “Server List” tab at the top menu
       bar to refresh the page. You should see the Server object as
       green and number of discovered virtual servers. Below is a sample
       of what your screen should look like:

   |image7|

* Create server objects for site2.datacenters based on the tabled below

+--------------------------------+-------------------------------------------------+
| **Name**                       | site2\_ha\_pair                                 |
+================================+=================================================+
| **Product**                    | BIG-IP System                                   |
+--------------------------------+-------------------------------------------------+
| **Data Center**                | site2.datacenter                                |
+--------------------------------+-------------------------------------------------+
| **Devices**                    | Click add and specify                           |
|                                |                                                 |
|                                | Name: bigip1.site2                              |
|                                |                                                 |
|                                | Address: 198.51.100.37; click add and then OK   |
|                                |                                                 |
|                                | Click add and specify                           |
|                                |                                                 |
|                                | Name: bigip2.site2                              |
|                                |                                                 |
|                                | Address: 198.51.100.38; click add and then OK   |
+--------------------------------+-------------------------------------------------+
| **Health Monitors**            | bigip                                           |
+--------------------------------+-------------------------------------------------+
| **Virtual Server Discovery**   | Enabled                                         |
+--------------------------------+-------------------------------------------------+
|                                | Click Finished                                  |
+--------------------------------+-------------------------------------------------+

* Go to your SSH session on GTM1 and take a look at the /var/log/gtm
   file to see what kinds of logs are generated after a server is
   created.::

     tail -100 /var/log/gtm
