############################################
Orientation
############################################

#. Open the command prompt on the Windows jumpbox and execute the following command:

   **dig www.example.com**. Examine the output, and observe that an A record exists.

.. image:: ./images/dig_www.example.com_static.png
  :width: 800

#. Open Internet Explorer and access `www.example.com <https://www.example.com>`__. Note that you accessed a web server in site1.
   
   **TODO Create content server page and add screenshot**

#. RDP to the domain controller using: **EXAMPLE\\user**, password **Agility1**.
   
   **Start** –> **Remote Desktop Connection** –> **10.1.70.200**.

.. image:: ./images/start-rdp-dco1.png
  :width: 800

   .. image:: ./images/logon_screen.png
  :width: 800
   
#. Click on **Server Manager**, and in the top right corner choose **Tools** and then **DNS**.

.. image:: ./images/AD_tools.png
  :width: 800

#. Double click on **EXAMPLE.COM** and examine DNS records.

.. image:: ./images/DNS_Manager.png
  :width: 800

.. image:: ./images/www_properties.png
  :width: 800

#. Connect to https://bigip1.site1.example.com and list the virtual server (**203.0.113.9**).
   Use Internet Explorer Browser on the jumpbox to log in via the GUI, or use Putty for SSH to get a shell.

GUI username = **admin/admin**

CLI username = **root/default**

.. image:: ./images/bigip1.site1_virtuals.png
  :width: 800

#. Connect to https://bigip1.site2.example.com and list the virtual servers (**198.51.100.41**).
   Use Internet Explorer Browser on the jumpbox to log in via the GUI, or use Putty for SSH to get a shell.

GUI username = **admin/admin**

CLI username = **root/default**

.. image:: ./images/bigip1.site2_virtuals.png
  :width: 800
