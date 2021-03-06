Agility 2017 Hands-on Lab Guide

Written for: TMOS\ :sup:`®` v13.0.0

Presented by: DNS 2017 F5 Agility Team

DNS Services Beyond GSLB with BIG-IP DNS (201)
==============================================

AUTHORITATIVE NS: SLAVE FROM OFF-BOX BIND
--------------------------------------------

*  **Objective:** In this use-case, you will configure GTM as the
   authoritative slave using an off-box BIND server as the hidden
   master. This is a very common architecture to serve either external
   or internal zones with large scale RPS via DNS Express. You will
   configure the following common components:
* DNS Profile and Listeners
* DNS Express
* DNS Query Logging
* DNS Statistics
* DNSSEC signing
* Estimated completion time: 25 minutes

Configuring DNS Logging
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* You are going to configure DNS query and response logging. To do
  this, you must tell GTM where to send logs to (a log publisher) and
  what specifically to log (DNS logging profile).
* For lab purposes, we are going to use local-syslog as our logging
  destination.

.. note:: remote high-speed logging is highly recommended for production environments.

* Log in to https://gtm1.site1.example.com from the jumpbox
  desktop and using user: *admin* password: *admin*
* In the GUI, navigate to: **System > Logs > Configuration > Log Publishers: Create**
* Create a new DNS Log Publisher as shown in the table below.

*Keep the defaults if not noted in the table.*

+--------------------+----------------------------------------+
| **Name**           | dns-local-syslog                       |
+====================+========================================+
| **Destinations**   | Move local-syslog to Selected column   |
+--------------------+----------------------------------------+

* Click **Finished** to create.
* In the GUI, navigate to: **DNS > Delivery > Profiles > Other > DNS Logging: Create**
* Create a new DNS logging profile as shown in the table below.

*Keep the defaults if not noted in the table.*

+------------------------+---------------------------+
| **Name**               | dns-logging               |
+========================+===========================+
| **Log Publisher**      | Select dns-local-syslog   |
+------------------------+---------------------------+
| **Log Responses**      | Enabled                   |
+------------------------+---------------------------+
| **Include Query ID**   | Enabled                   |
+------------------------+---------------------------+

* Click **Finished** to create.
* Your new dns-logging profile should now have all options enabled.

Create a new DNS Profile
~~~~~~~~~~~~~~~~~~~~~~~~~

* A DNS profile tells the DNS Listener how to process DNS traffic.
  We’re going to make some tweaks for our use-case and lab environment.
* In the GUI, navigate to: **DNS > Delivery > Profiles > DNS: Create**
* Create a new DNS profile as shown in the table below.
*Keep the defaults if not noted in the table.*

+------------------------------------+--------------------------------+
| **Name**                           | AuthNS-offbox-BIND             |
+====================================+================================+
| **Unhandled Query Action**         | Drop                           |
+------------------------------------+--------------------------------+
| **Use BIND Server on Big-IP**      | Disabled                       |
+------------------------------------+--------------------------------+
| **Logging**                        | Enabled                        |
+------------------------------------+--------------------------------+
| **Logging Profile**                | dns-logging                    |
+------------------------------------+--------------------------------+
| **AVR Statistics Sampling Rate**   | Enabled; 1/1 queries sampled   |
+------------------------------------+--------------------------------+

* Click **Finished** to create.
* For lab purposes, we are going to use sample all DNS queries with AVR.

.. note:: production sampling rates would be a much lower rate
   as this would severely impact performance.

Create DNS Listeners
~~~~~~~~~~~~~~~~~~~~~

We are going to create both UDP and TCP external listeners. The
external Listener will be our target IP address when querying GTM.

* In the GUI, navigate to: **DNS > Delivery > Listeners > Listener List: Create**
* Create two **external** Listeners as shown in the tables below.
*Keep the defaults if not noted in the table.*

+-------------------------+-------------------------+
| **Name**                | external-listener-UDP   |
+=========================+=========================+
| **Destination**         | Host: 203.0.113.8       |
+-------------------------+-------------------------+
| **VLAN Traffic**        | Enabled on..            |
+-------------------------+-------------------------+
| **VLANs and Tunnels**   | External                |
+-------------------------+-------------------------+
| **DNS Profile**         | AuthNS-offbox-BIND      |
+-------------------------+-------------------------+

+-------------------------+-------------------------+
| **Name**                | external-listener-TCP   |
+=========================+=========================+
| **Destination**         | Host: 203.0.113.8       |
+-------------------------+-------------------------+
| **VLAN Traffic**        | Enabled on..            |
+-------------------------+-------------------------+
| **VLANs and Tunnels**   | External                |
+-------------------------+-------------------------+
| **Protocol**            | TCP                     |
+-------------------------+-------------------------+
| **DNS Profile**         | AuthNS-offbox-BIND      |
+-------------------------+-------------------------+

* For each Listener, click **Finished** to create.

* You should now have two UDP-based DNS Listeners and two TCP-based
  Listeners configured.

Create a Nameserver for Hidden Master
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We next need to tell GTM about our Hidden Master that DNS Express will
slave from.

* In the GUI, navigate to: **DNS > Delivery > Nameservers > Nameserver List: Create**
* Create offbox-BIND as a Nameserver as shown in the table below.
*Keep the defaults if not noted in the table.*

+---------------+-----------------+
| **Name**      | Offbox-BIND     |
+===============+=================+
| **Address**   | 203.0.113.15    |
+---------------+-----------------+

* Click **Finished** to create.

Create a zone to transfer from Hidden Master
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We will now configure the specific zone for GTM to obtain from the
Hidden Master. Note that the BIND server already has some key
configuration elements to consider:

* “Allow-transfer” (for lab purposes, any sourceIP is allowed)
* “Also-notify” for your internal Listener IP address.
* TSIG is disabled.
* Before we configure the zone, we are going to enable some debug
  logging so that you can see what happens underneath the covers. SSH
  to your F5 BIGIP1. You should have a BIGIP1 putty icon on your
  desktop. Use username: **root** password: **default** and issue the
  following TMSH command once logged in.

.. code-block:: cli

    tmsh modify sys db log.zxfrd.level value "debug"


* Now, view the log file real-time by issuing this command at the SSH prompt:

.. code-block:: cli

    tail –f /var/log/ltm

.. note:: You can make the putty window larger if needed

Keep your ssh session open while performing the rest of the steps.
You can break out of the tail process with *<Ctrl-C>*.

* In the GUI, navigate to: **DNS > Zones > Zones > Zone List: Create**
* Create the **“dnsx.com”** zone as shown in the figure below and then
  click **Finished.**

|image1|

* You should see log messages in your SSH console indicating a
  successful transfer from the hidden master. You can also view the
  state of the transfer by clicking back on the newly created zone and
  observing the “Availability” as shown in the figure below.

|image2|

* Issue the following command from SSH console to see specifics of the
  status and statistics related to the zone.
.. code-block:: cli

   tmsh show ltm dns zone dnsx.com | more

* The dnsx.com zone is configured with a 60 second refresh interval –
  meaning that DNS Express will proactively check the Master Nameserver
  every 60 seconds for zone updates. This very low interval is merely
  for lab purposes so you can view what happens in the logs. The log
  messages look like this:
.. code-block:: cli

  Jun 22 14:49:38 gtm1 debug zxfrd[4251]: 01531023:7: Scheduling zone transfer in 60s for dnsx.com from 203.0.113.15.
  Jun 22 14:49:38 gtm1 debug zxfrd[4251]: 01531106:7: Availability status of dnsx.com changed from YELLOW to GREEN.
  Jun 22 14:50:38 gtm1 debug zxfrd[4251]: 01531025:7: Serials equal (2017062201); transfer for zone dnsx.com complete.
  Jun 22 14:50:38 gtm1 debug zxfrd[4251]: 01531008:7: Resetting transfer state for zone dnsx.com.
  Jun 22 14:50:38 gtm1 debug zxfrd[4251]: 01531023:7: Scheduling zone transfer in 60s for dnsx.com from 203.0.113.15.

* Now, issue the following command in the SSH console to view what is
   in DNS Express.
.. code-block:: cli

   dnsxdump | more

* Open the command prompt from your windows desktop. Issue a DNS query
  against your external listener for a record in the dnsx.com zone and
  verify that it succeeds. For example:
.. code-block:: cli

   >dig @203.0.113.8 +short www1.dnsx.com


* Issue several more queries of different types to generate some
  interesting statistics. Here are some examples:
.. code-block:: cli

   dig @203.0.113.8 +short www1.dnsx.com

   dig @203.0.113.8 +short www2.dnsx.com

   dig @203.0.113.8 +short www3.dnsx.com

   dig @203.0.113.8 +short bigip1.dnsx.com

   dig @203.0.113.8 +short bigip2.dnsx.com

   dig @203.0.113.8 +short MX dnsx.com

   dig @203.0.113.8 +short NS dnsx.com

* Now is a good time to check query logging. Look at ``/var/log/ltm ``(i.e.
  tail /var/log/ltm ) to ensure that you’re properly logging queries
  and responses. It should look something like this:
.. code-block:: cli

   Jun 22 14:55:14 gtm1 info tmm[10506]: 2017-06-22 14:55:14 gtm1.site1.example.com qid 340 from 203.0.113.1#50316: view none: query: www3.dnsx.com IN A + (203.0.113.8%0)
   Jun 22 14:55:14 gtm1 info tmm[10506]: 2017-06-22 14:55:14 gtm1.site1.example.com qid 340 to 203.0.113.1#50316: [NOERROR qr,aa,rd] response: www3.dnsx.com. 100 IN A 203.0.113.103;


* In the GUI, navigate to **Statistics > Analytics > DNS**. Notice that
  you can view statics by different data points, over different periods of
  time, and drill down into different aspects. Spend a few moments looking
  at the various options.

.. note:: This may take up to 5 minutes to populate.

If no data exists, come back after the next task.

Enable DNSSEC for the zone
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We will now sign the dnsx.com zone. In this example, we are configuring
GTM to sign the zone on the fly rather than signing the actual static
zone information (which can be done starting in v11.5 but is outside the
scope of this lab).

* In the GUI, navigate to: **DNS > Delivery > Keys > DNSSEC Key List: Create**
* Create two keys as defined in the tables below.
*Keep the defaults if not noted in the table.*

+----------------------+--------------------+
| **Name**             | dnsx.com\_zsk      |
+======================+====================+
| **Type**             | Zone Signing Key   |
+----------------------+--------------------+
| **Key Management**   | Manual             |
+----------------------+--------------------+
| **Certificate**      | default.crt        |
+----------------------+--------------------+
| **Private Key**      | default.key        |
+----------------------+--------------------+

+----------------------+-------------------+
| **Name**             | dnsx.com\_ksk     |
+======================+===================+
| **Type**             | Key Signing Key   |
+----------------------+-------------------+
| **Key Management**   | Manual            |
+----------------------+-------------------+
| **Certificate**      | default.crt       |
+----------------------+-------------------+
| **Private Key**      | default.key       |
+----------------------+-------------------+

* Click **Finished** to create each key.
* In the GUI, navigate to: **DNS > Zones > DNSSEC Zones > DNSSEC Zone List: Create**
* Configure the dnsx.com zone for DNSSEC using the previously created
  keys as shown below.

|image3|

* Test that the zone is successfully signed by issuing a DNSSEC query
  to the external listener. For example:

.. code-block:: cli

   dig @203.0.113.8 +dnssec www1.dnsx.com

You should see RRSIG records indicating that the zone is signed. You
will also note signing in the query logs (``/var/log/ltm``)

* Finally, view some other DNS statistics related to queries, DNSSEC, zone transfers, notifies, etc.
* In the GUI, navigate to: **DNS > Zone > Zones > Zone List.**
* Click on the “dnsx.com” zone and then select “Statistics” from the top menu bar.
* Select the “View” Details as shown in the diagram below:

|image4|

* View the types of statistics available for the zone such as serial number, number of records, etc.
* In the GUI, navigate to: **Statistics > Module Statistics > DNS > Zones**.
* Set “Statistics Type” to **“DNSSEC Zones”.**
* View details as performed above. Note the various DNSSEC statistics available.
* If the graphs from task 5 weren’t available earlier, revisit
  **Statistics > Analytics > DNS** now and explore.

Authoritative Name Server: slave from ON-BOX BIND
-------------------------------------------------

In this use-case, you will configure GTM as an authoritative slave
using on-box BIND managed by ZoneRunner.

Estimated completion time: 15 minutes

Create a new DNS Profile
~~~~~~~~~~~~~~~~~~~~~~~~

* In the GUI, navigate to: **DNS > Delivery > Profiles > DNS: Create.**
  Create a new DNS profile as shown in the table below.
*Keep the defaults if not noted in the table.*

+------------------------------------+--------------------------------+
| **Name**                           | AuthNS-onbox-BIND              |
+====================================+================================+
| **Unhandled Query Action**         | Drop                           |
+------------------------------------+--------------------------------+
| **Use BIND Server on Big-IP**      | Disabled                       |
+------------------------------------+--------------------------------+
| **Logging**                        | Enabled                        |
+------------------------------------+--------------------------------+
| **Logging Profile**                | dns-logging                    |
+------------------------------------+--------------------------------+
| **AVR Statistics Sampling Rate**   | Enabled; 1/1 queries sampled   |
+------------------------------------+--------------------------------+

* Click **Finished** to create.
For lab purposes, we are going to sample all DNS queries with AVR.


.. note:: Production sampling rates would be a much lower rate.


Edit DNS Listeners
~~~~~~~~~~~~~~~~~~

We need to edit the external-listeners to use the new DNS profile
created above.

* In the GUI, navigate to: **DNS > Delivery > Listeners > Listener List**
* Edit the external-listener-UDP to use the AuthNS-onbox-BIND DNS
  profile.
* Edit the external-listener-TCP to use the AuthNS-onbox-BIND DNS
  profile.
* Click **Update** after change DNS profile to finish edition.

Create a Student1.com zone using ZoneRunner
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* In the GUI, navigate to: **DNS > Zones: ZoneRunner > Zone List: Create**
* Add a student1.com zone with the information as shown in the
  following screenshot. Note the “also-notify” message needs to be
  added to send a NOTIFY message to an internal GTM IP address for
  processing. Likewise BIND needs to allow the transfer from the
  loopback address. The diagram below shows the basic operation.

|image5|

|image6|

Create a Nameserver for on-box BIND
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Next, we need to tell DNS Express that on-box BIND is available to use
as a source for zone transfers.

* In the GUI, navigate to: **DNS > Delivery > Nameservers > Nameserver List: Create**
* Create a loopback as a Nameserver as shown in the table below.

*Keep the defaults if not noted in the table.*

+---------------+--------------+
| **Name**      | ZoneRunner   |
+===============+==============+
| **Address**   | 127.0.0.1    |
+---------------+--------------+

-  Click **Finished** to create.

Create a DNS Express zone to transfer from ZoneRunner
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We will now configure the specific zone for GTM to obtain from
ZoneRunner. Note that on-box BIND already has some key configuration
elements to consider:

    * “Allow-transfer” from the localhost.
    * “Also-notify” for DNS Express internal Listener IP address.
    * TSIG is disabled.

* In the GUI, navigate to: **DNS > Zones > Zones > Zone List: Create**
* Create the “student1.com” zone as shown in the figure below and then
  click **Finished.**

|image7|

* Perform the same validation steps as the previous lab for validating
  the successful transfer of student1.com to DNS Express
* View the details of the zone in the GUI
* Issue the following command from the ssh console:

.. code-block:: cli

   tmsh show ltm dns zone student1.com | more

* Dump the dns express output to see the records
.. code-block:: cli

    dnsxdump | more

* Verify logs in ``/var/log/ltm``
* From a command prompt on your jumpbox, issue a query to the external
  listener for a record in the zone
.. code-block:: cli

    dig @203.0.113.8 SOA student1.com

* Add a new record to the Student1.com zone in ZoneRunner
* In the GUI, navigate to: **DNS > Zones: ZoneRunner > Resource Record List.**
* Select View Name -> external
* Select Zone Name -> student1.com.
* Click **Create**
* Enter a new A record similar to the figure below for your zone and
  click **Finished**.

|image8|

* Validate the DNS Express was updated by performing a dnsxdump and/or
  query for your new record to the Listener.

* Add another record using the steps above for **www2.student1.com**
  with IP address of **203.0.113.102** but before doing this, make sure to
  have a putty session open to your BIG-IP1 and tail the logs using
  ``tail –f /var/log/ltm`` to view the changes. By making a change to the
  zone on the Hidden Master (in this case ZoneRunner), you will see a
  proactive update to DNS Express via a NOTIFY. Watch the ``/var/log/ltm``
  file to see the update occur. The logs should look something like
  this:
.. code-block:: cli

   Jun 5 08:21:26 bigip1 notice zxfrd[6429]: 0153101c:5: Handling NOTIFY for zone student1.com.
   Jun 5 08:21:26 bigip1 debug zxfrd[6429]: 01531008:7: Resetting transfer state for zone student1.com.
   Jun 5 08:21:26 bigip1 debug zxfrd[6429]: 01531023:7: Scheduling zone transfer in 5s for student1.com from 127.0.0.1.
   Jun 5 08:21:26 bigip1 debug zxfrd[6429]: 01531027:7: Notify response to ::1 succeeded (81:na).
   Jun 5 08:21:31 bigip1 notice zxfrd[6429]: 0153101f:5: IXFR Transfer of zone student1.com from 127.0.0.1 succeeded.

Issue a ``dnsxdump | more`` command for the SSH console or a query to the
listener to validate the zone file has updated.

Slaving off of DNS Express
--------------------------

In this use-case, we will obtain a zone transfer from another F5’s
DNS Express. This is a common deployment in a hybrid on-premise and
cloud-based DNS solution. Our purpose here is to focus on DNS Express
serving zone transfer clients. Note that zones can be signed during a
transfer – but this is outside the scope of this lab

* Estimated completion time: 10 minutes

Create a new DNS Profile
~~~~~~~~~~~~~~~~~~~~~~~~

* In the GUI, navigate to: **DNS > Delivery > Profiles > DNS: Create.**
  Create a new DNS profile as shown in the table below.
*Keep the defaults if not noted in the table.*

+------------------------------------+--------------------------------+
| **Name**                           | AuthNS-hybrid                  |
+====================================+================================+
| **Unhandled Query Action**         | Drop                           |
+------------------------------------+--------------------------------+
| **Use BIND Server on Big-IP**      | Disabled                       |
+------------------------------------+--------------------------------+
| **Zone Transfer**                  | Enabled                        |
+------------------------------------+--------------------------------+
| **Logging**                        | Enabled                        |
+------------------------------------+--------------------------------+
| **Logging Profile**                | dns-logging                    |
+------------------------------------+--------------------------------+
| **AVR Statistics Sampling Rate**   | Enabled; 1/1 queries sampled   |
+------------------------------------+--------------------------------+

* For lab purposes, we are going to use sample all DNS queries with
  AVR.
.. note:: that production sampling rates would be a much lower rate.

Edit DNS Listeners
~~~~~~~~~~~~~~~~~~

* In the GUI, navigate to: **DNS > Delivery > Listeners > Listener List**
* Edit the external-listener-TCP to use the AuthNS-hybrid DNS profile.
* Click **Update** to finish.

Create Nameservers for Zone Transfer Clients
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* Your lab environment has a second pre-configured BIG-IP (BIGIP2) that
  we will use as the on-prem DNS Express Master.
* In the GUI, navigate to: **DNS > Delivery > Nameservers > Nameserver List: Create**
* Create BIGIP2’s F5 as a Nameserver as shown in the table below. You
  will use the External SelfIP/Listener.

*Keep the defaults if not noted in the table.*

+---------------+------------------+
| **Name**      | site2_gtm1_master|
+===============+==================+
| **Address**   | 198.51.100.39    |
+---------------+------------------+

Edit Student2 Zones on BIGIP2 to allow Zone transfers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* Log in to gtm1.site2 (shortcut located on desktop) using a new browser
  window with the following credentials:
* https://10.1.10.23
* User: *admin* Pass: *admin*
* In the GUI, navigate to: **DNS > Zones > Zones > Zone List**
* Edit the existing student2.com zone.
* Under Zone Transfer Clients, move **gtm1.site1** (pre-defined to save
  time) to Active and click **Update**.

.. note:: The internal TCP listener on BIGIP2 is using the
   AuthNS-hybrid profile which is setup exactly like the profile with
   the same name on BIGIP1. ‘Zone Transfer = Enabled’ must be set in the
   profile on the source for this to work correctly.

* Return to your BIGIP1 browser session

Add Student2.com zone to DNS Express on BIGIP1
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* In the GUI on BIGIP1, navigate to: **DNS > Zones > Zones > Zone List: Create**
* Create the “student2.com” zone as shown in the figure below and then
  click Finished. Your GTM is acting as a zone transfer client in this
  case (looking to receive a transfer of the on-prem student2.com local
  zone). This example shows BIGIP1 adding the student2.com zone to pull
  from DNS Express on BIGIP2.

|image9|

* Perform the same validation steps as the previous lab for validating
  the successful transfer of student2.com zone
* View the details of the zone in the GUI
* Issue a ``dnsxdump | more`` command from SSH console
* Verify logs in ``/var/log/ltm``
* Issue a query to the external listener for a record in the zone
.. code-block:: cli

   dig @203.0.113.8 SOA student2.com

* Open putty sessions to both BIGIP1 and BIGIP2 and tail the logs using
  ``tail –f /var/log/ltm``. This will allow us to see the process of
  adding a new record on the Master on-prem server (BIGIP2) and then it
  being replicated first to DNS Express on its own box, followed by an
  update to the cloud GTM (BIGIP1) in this scenario.

* Add a new record to the student2.com zone in ZoneRunner on **gtm1.site2**
* In the GUI, navigate to: **DNS > Zones: ZoneRunner > Resource Record List**
* Select View Name -> external
* Select Zone Name -> student2.com.
* Click **Create**
* Enter a new A record based on the picture below and click
  **Finished**.

|image10|

* Notice the logs in each F5. You will see BIGIP2 perform a zone transfer
  from ZR after receiving a NOTIFY. You will then see BIGIP1
  receive a NOTIFY and obtain a zone transfer.
* Notice that we didn’t have to tell GTM where to send a NOTIFY. Those
  messages are automatically sent to the Zone Transfer Clients
  configured for the zone.
* Issue the following command from SSH console on BIGIP1 to see the
  status and statistics related to the zone.
  *Take note of the “Notifies Received” counter.*
.. code-block:: cli

   tmsh show ltm dns zone student2.com | more

* Issue the following command from SSH console on BIGIP2 to see the
  status and statistics related to the zone.
  *Take note of the “Notifies To Client” counter.*
.. code-block:: cli

   tmsh show ltm dns zone student2.com | more

* Validate DNS Express was updated by performing a ``dnsxdump | more``
  and/or query for your new record to the Listener.

**Close out your browser session to gtm1.site2, we will no longer be using it.**

Transparent Caching
-------------------

In this use-case, you will configure GTM as a transparent cache to a pool of BIND servers.

* Estimated completion time: 10 minutes

|image11|

Create a DNS Cache
~~~~~~~~~~~~~~~~~~

* In the GUI, navigate to: **DNS > Caches > Cache List: Create**
* Create a new DNS profile as shown in the table below.
*Keep the defaults if not noted in the table.*

+---------------------+----------------------+
| **Name**            | transparent-cache    |
+=====================+======================+
| **Resolver Type**   | Transparent (none)   |
+---------------------+----------------------+

* Click **Finished** to create.

Create a new DNS Profile
~~~~~~~~~~~~~~~~~~~~~~~~

* In the GUI, navigate to: **DNS > Delivery > Profiles > DNS: Create**.
  Create a new DNS profile as shown in the table below.

*Keep the defaults if not noted in the table.*

+------------------------------------+-----------------------------------+
| **Name**                           | Transparent                       |
+====================================+===================================+
| **DNSSEC**                         | Disabled                          |
+------------------------------------+-----------------------------------+
| **GSLB**                           | Disabled                          |
+------------------------------------+-----------------------------------+
| **DNS Express**                    | Disabled                          |
+------------------------------------+-----------------------------------+
| **DNS Cache**                      | Enabled                           |
+------------------------------------+-----------------------------------+
| **DNS Cache Name**                 | transparent-cache                 |
+------------------------------------+-----------------------------------+
| **Use BIND Server on Big-IP**      | Disabled                          |
+------------------------------------+-----------------------------------+
| **Logging**                        | Enabled                           |
+------------------------------------+-----------------------------------+
| **Logging Profile**                | dns-logging                       |
+------------------------------------+-----------------------------------+
| **AVR Statistics Sampling Rate**   | Enabled; 1/1 queries sampled      |
+------------------------------------+-----------------------------------+

Click **Finished** when complete.

Create a DNS Monitor
~~~~~~~~~~~~~~~~~~~~

* In the GUI, navigate to: **DNS > Delivery > Load Balancing > Monitors: Create**.
  Create a new DNS monitor as shown in the table below.

*Keep the defaults if not noted in the table.*

+------------------+--------------------------------------+
| **Name**         | mon\_resolver                        |
+==================+======================================+
| **Type**         | DNS                                  |
+------------------+--------------------------------------+
| **Query Name**   | www.f5.com                           |
+------------------+--------------------------------------+

* Click **Finished** to create.

Create a Resolver Pool
~~~~~~~~~~~~~~~~~~~~~~

* In the GUI, navigate to: **DNS > Delivery > Load Balancing > Pools > Pools List: Create**.
  Create a new pool of DNS resolvers as shown in the figure below.

* Add pool called **pool\_resolvers** with health monitor
  (**mon\_resolver**) and members as shown in table and diagram below:

+--------------------+
| **Pool Members**   |
+====================+
| 198.51.100.39:53   |
+--------------------+
| 203.0.113.15:53    |
+--------------------+
| 198.51.100.47:53   |
+--------------------+

|image12|

Create a new External DNS Listener
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We are going to create a new external-facing DNS Listener to cache DNS
requests and load-balance non-cached requests to pool\_resolvers.

* In the GUI, navigate to: **DNS > Delivery > Listeners > Listener List: Create**
* Create a Listener named ‘\ **resolver-listener**\ ’ as shown in the
  figure below. Use the Listener IP of **203.0.113.9**

.. note:: you need to be in the “Advanced” Menu to set some of the options.

|image13|

* From your workstation at a command prompt, perform several recursive
  queries to your new listener to test. You will want to repeat some of the same queries multiple times
  We are attempting to see cache hits. Below are some examples:

.. code-block:: cli

  dig @10.128.10.54 www.f5.com
  dig @10.128.10.54 www.wikipedia.org
  dig @10.128.10.54 www.ncsu.edu

* You should have successful resolution. Now it’s time to see statistics and cache entries.

**Viewing Cache Entries**

* In the SSH shell, type the following command:
.. code-block:: cli

  tmsh show ltm dns cache records rrset cache transparent-cache

* Your output should look similar to below with several entries

|image14|

* If you go to the TMSH console, you can see several other ways to
  query the cache database. Below show some examples.

* View cache entries for a particular domain / owner:

|image15|

* View cache entries of a particular RR type:

|image16|

* There are other options… feel free to play around and familiarize
  yourself with the options.

**Viewing Cache Statistics**

* In the SSH shell, type:
.. code-block:: cli

   tmsh show ltm dns cache transparent transparent-cache

* Your output should look similar to below with statistics showing Hits
  and Misses in particular.

|image17|

* In the GUI, you can find similar data as above by navigating
  **Statistics > Module Statistics > DNS > Caches**.
* Select “Statistics Type” of Caches.
* Select “View” under the Details column for transparent-cache
* Note that stats can also be reset from this view (Reset).

|image18|

* Spend some time looking in the DNS Analytics to verify that AVR is
  graphing query stats as expected.

**Deleting Cache Entries**

* Specific cache entries can be deleted via the TMSH console. Entries
  to be deleted can be filtered by several aspects.
* In the TMSH shell, go to the DNS prompt and type
.. code-block:: cli

   delete cache records rrset cache transparent-cache ?

* Now delete individual records by type and owner. Below show some
  examples.

|image19|

**Clearing Entire Cache**

* Via the GUI, navigate to **Statistics > Module Statistics > DNS > Caches**
* Set “Statistics Type” to “Caches”.
* You can select the cache and click “Clear Cache” to empty the cache.

Resolver Cache
---------------

In this use case, you will configure GTM as a resolver cache which
eliminates the need for the pool of resolvers.
* Estimated completion time: 10 minutes

|image20|

Create a new DNS Cache
~~~~~~~~~~~~~~~~~~~~~~

* In the GUI, navigate to: **DNS > Caches > Cache List: Create**

* Create a new DNS Cache as shown in the table below.
*Keep the defaults if not noted in the table.*

+---------------------+------------------+
| **Name**            | resolver-cache   |
+=====================+==================+
| **Resolver Type**   | Resolver         |
+---------------------+------------------+

Create a new DNS Profile
~~~~~~~~~~~~~~~~~~~~~~~~

* In the GUI, navigate to: **DNS > Delivery > Profiles > DNS: Create**.
  Create a new DNS profile as shown in the table below.
*Keep the defaults if not noted in the table.*

+------------------------------------+-----------------------------------+
| **Name**                           | Resolver                          |
+====================================+===================================+
| **DNSSEC**                         | Disabled                          |
+------------------------------------+-----------------------------------+
| **GSLB**                           | Disabled                          |
+------------------------------------+-----------------------------------+
| **DNS Express**                    | Disabled                          |
+------------------------------------+-----------------------------------+
| **DNS Cache**                      | Enabled                           |
+------------------------------------+-----------------------------------+
| **DNS Cache Name**                 | resolver-cache                    |
+------------------------------------+-----------------------------------+
| **Unhandled Query Action**         | Drop                              |
+------------------------------------+-----------------------------------+
| **Use BIND Server on Big-IP**      | Disabled                          |
+------------------------------------+-----------------------------------+
| **Logging**                        | Enabled                           |
+------------------------------------+-----------------------------------+
| **Logging Profile**                | dns-logging //from previous lab   |
+------------------------------------+-----------------------------------+
| **AVR Statistics Sampling Rate**   | Enabled; 1/1 queries sampled      |
+------------------------------------+-----------------------------------+

Edit DNS Listener
~~~~~~~~~~~~~~~~~

We will now apply the new profile to the existing DNS Listener.

* In the GUI, navigate to: **DNS > Delivery > Listeners > Listener List**
* Select ‘resolver-listener’ and modify the following settings.
* Change the DNS profile to ‘resolver’ and uncheck “Address
  Translation” (under Listener Advanced options). Click **Update**.
* Select “Load Balancing” from the middle menu above, and Select the
  Default Pool as “None” and click **Update**.
* Your Listener should now be setup as a caching resolver.
* From your workstation command prompt, perform several recursive
  queries to your external Listener to test. You will want to repeat
  some of the same queries multiple times. We are attempting to see
  cache hits and perform recursive queries. Below are some examples:
.. code-block:: cli

 dig @10.128.10.54 www.cnn.com

 dig @10.128.10.54 www.google.com

 dig @10.128.10.54 www.umich.edu

**Viewing Cache Statistics**

* In the SSH shell, type the following command:
.. code-block:: cli

   tmsh show ltm dns cache resolver resolver-cache | more


Your output should look similar to below with statistics. Bits
In/Out, Packets In/Out and Connections are of particular interest.

|image21|

DNSSEC Validating Resolver
---------------------------

In this use case, you will configure GTM as a DNSSEC validating
resolver which offloads heavy CPU computation to traditional
resolvers. This simply adds DNSSEC validation to the resolver-cache
use-case previously configured.
* Estimated completion time: 10 minutes

Create a new DNS Cache
~~~~~~~~~~~~~~~~~~~~~~

* In the GUI, navigate to: **DNS > Caches > Cache List: Create**
* Create a new DNS cache as shown in the table below.
*Keep the defaults if not noted in the table.*

+---------------------+-----------------------+
| **Name**            | validating-resolver   |
+=====================+=======================+
| **Resolver Type**   | Validating Resolver   |
+---------------------+-----------------------+

* A Trust Anchor must be configured so that the validating resolver has
  a starting point for validation. This can be done manually via the SSH console.
  You can obtain the root server DS keys by using dig and its related
  utilities as follows:

.. note:: In the interest of time, the trust anchors are located on your
   desktop as a text file named TrustAnchors.txt. You can simply cut
   and paste the values into the GUI. If you want to run the
   utilities to obtain the anchors, the commands are below for your
   reference.

* Get the root name servers in DNSKEY format and output to the file "root-dnskey"
.. code-block:: cli

   >dig +multi +noall +answer DNSKEY . >root-dnskey

* Convert the root trust anchors from DNSKEY format to DS
.. code-block:: cli

   >dnssec-dsfromkey -f root-dnskey . >root-ds

* Output of the root DS keys
.. code-block:: cli

   >cat ./root-ds

   IN DS 19036 8 1 B256BD09DC8DD59F0E0F0D8541B8328DD986DF6E

   IN DS 19036 8 2
   49AAC11D7B6F6446702E54A1607371607A1A41855200FD2CE1CDDE32 F24E8FB5

* Each of the 2 lines in the TrustAnchor.txt file should be entered as
  a new trust anchor (2 total).
* In the GUI, navigate to: **DNS > Caches > Cache List**. Select
  “validating-resolver” and click on **Trust Anchors** on the top
  menu. Click **Add**. Copy each line from the TrustAnchor.txt file
  as a Trust Anchor entry. You should end with a total of two
  entries.
* The figure below shows what your configuration should look like.

|image22|

Create a new DNS Profile
~~~~~~~~~~~~~~~~~~~~~~~~

In this task we will create a dns profile to be used by a listener for DNSSEC validation.
* In the GUI, navigate to: **DNS > Delivery > Profiles > DNS: Create**.
* Create a new DNS profile as shown in the table below.

*Keep the defaults if not noted in the table.*

+------------------------------------+-----------------------------------+
| **Name**                           | Validating                        |
+====================================+===================================+
| **DNSSEC**                         | Disabled                          |
+------------------------------------+-----------------------------------+
| **GSLB**                           | Disabled                          |
+------------------------------------+-----------------------------------+
| **DNS Express**                    | Disabled                          |
+------------------------------------+-----------------------------------+
| **DNS Cache**                      | Enabled                           |
+------------------------------------+-----------------------------------+
| **DNS Cache Name**                 | validating-resolver               |
+------------------------------------+-----------------------------------+
| **Unhandled Query Action**         | Drop                              |
+------------------------------------+-----------------------------------+
| **Use BIND Server on Big-IP**      | Disabled                          |
+------------------------------------+-----------------------------------+
| **Logging**                        | Enabled                           |
+------------------------------------+-----------------------------------+
| **Logging Profile**                | dns-logging //from previous lab   |
+------------------------------------+-----------------------------------+
| **AVR Statistics Sampling Rate**   | Enabled; 1/1 queries sampled      |
+------------------------------------+-----------------------------------+

Edit DNS Listener
~~~~~~~~~~~~~~~~~

We will now apply the new profile to the existing DNS Listener.

* In the GUI, navigate to: **DNS > Delivery > Listeners > Listener List**
* Select ‘\ **resolver-listener**\ ’ and modify the DNS Profile to use “\ **validating**\ ”.
* Your Listener should now be setup as a validating resolver.
* **Use-Case: Valid Signed Zone.** From your workstation, perform
  several recursive queries to your external Listener to test. Perform the following command
  2 or 3 times:

.. code-block:: cli

 dig @10.128.10.54 internetsociety.org

* In the SSH shell, type the following:
.. code-block:: cli

   tmsh show ltm dns cache validating-resolver | more

Your output should look similar to below with statistics. Response
Validation and DNSSEC Key stats are of particular interest in this use-case.

|image23|

* In the GUI, you can find similar data as above by navigating
  **Statistics > Module Statistics > DNS > Caches**.
* Select “Statistics Type” of Caches.
* Select “View” under the Details column for validating-resolver
* Note the size of the cache for just this single RR query. You can
  view what’s in the cache from the CLI with:
.. code-block:: cli

    tmsh show ltm dns cache records rrset cache validating-resolver | more

* **Use-Case: Invalid Signed Zone:** From your workstation, perform
  several recursive queries to your external Listener to test. Perform the
  following command 2 or 3 times:
.. code-block:: cli

  dig @10.128.10.54 dnssec-failed.org

* Run the same steps above to view statistics and see the difference
* What happens when trust is broken.
* What statistic incremented?
* What was the query response to the client?

Forwarders
----------

In this use-case, we will configure conditional forwarders with local
zone information.

* Estimated completion time: 5 minutes

Add Forwarder to Existing Cache
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* In the GUI, navigate to: **DNS > Caches > Cache List**. Click on
  **validating-resolver** from the previous exercise. Click **Forward Zones**
  from the top menu.
* Click **Add** and configure as shown in the figure below and then
  click **Finished**:

|image24|

* From your workstation, perform the following recursive queries to your
  external Listener to test.
.. code-block:: cli

  dig @10.128.10.54 www.forward.com

  dig @10.128.10.54 mail.forward.com

* In the SSH shell, type the following tmsh command:
.. code-block:: cli

   tmsh show ltm dns cache validating-resolver | more

Your output should look similar to below with statistics. Forwarder
Activity stats are of particular interest in this use-case.

|image25|

* In the GUI, you can find similar data as above by navigating
  **Statistics > Module Statistics > DNS > Caches**.
* Select “Statistics Type” of Caches.
* Select “View” under the Details column for validating-resolver

DNS 201 class is complete !  Thanks for attending!
--------------------------------------------------

.. |image0| image:: 201/media/image2.png
   :width: 5.30972in
   :height: 2.02776in
.. |image1| image:: 201/media/image4.png
   :width: 3.93000in
   :height: 3.05000in
.. |image2| image:: 201/media/image5.png
   :width: 2.66667in
   :height: 1.41319in
.. |image3| image:: 201/media/image6.png
   :width: 3.23729in
   :height: 2.35556in
.. |image4| image:: 201/media/image7.png
   :width: 3.96000in
   :height: 1.71000in
.. |image5| image:: 201/media/image8.png
   :width: 3.13333in
   :height: 1.40000in
.. |image6| image:: 201/media/image9.png
   :width: 5.31042in
   :height: 6.32847in
.. |image7| image:: 201/media/image10.png
   :width: 4.03000in
   :height: 3.21000in
.. |image8| image:: 201/media/image11.png
   :width: 3.95000in
   :height: 2.51000in
.. |image9| image:: 201/media/image12.png
   :width: 3.95000in
   :height: 2.97000in
.. |image10| image:: 201/media/image13.png
   :width: 3.64000in
   :height: 2.46000in
.. |image11| image:: 201/media/image14.png
   :width: 4.25347in
   :height: 3.55347in
.. |image12| image:: 201/media/image15.png
   :width: 4.24000in
   :height: 4.25000in
.. |image13| image:: 201/media/image16.png
   :width: 4.71000in
   :height: 6.97000in
.. |image14| image:: 201/media/image17.png
   :width: 5.46000in
   :height: 2.55000in
.. |image15| image:: 201/media/image18.png
   :width: 5.46000in
   :height: 1.54000in
.. |image16| image:: 201/media/image19.png
   :width: 5.46000in
   :height: 1.95000in
.. |image17| image:: 201/media/image20.png
   :width: 5.45000in
   :height: 3.26000in
.. |image18| image:: 201/media/image21.png
   :width: 3.86667in
   :height: 2.92014in
.. |image19| image:: 201/media/image22.png
   :width: 5.87000in
   :height: 3.78000in
.. |image20| image:: 201/media/image23.png
   :width: 4.58264in
   :height: 2.95764in
.. |image21| image:: 201/media/image24.png
   :width: 5.76000in
   :height: 3.47000in
.. |image22| image:: 201/media/image25.png
   :width: 4.00694in
   :height: 1.06042in
.. |image23| image:: 201/media/image26.png
   :width: 5.76000in
   :height: 3.47000in
.. |image24| image:: 201/media/image27.png
   :width: 4.31000in
   :height: 2.82000in
.. |image25| image:: 201/media/image28.png
   :width: 5.76000in
   :height: 3.47000in
