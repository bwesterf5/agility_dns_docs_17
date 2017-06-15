DNS LAB – GETTING STARTED
=========================

We will be utilizing Ravello Systems for our virtualized lab in this
class. Each student will be working in a self-contained virtual lab
containing:

-  2 F5 BIG-IP VEs running 13.0 and provisioned with LTM and GTM

-  LAMP Server that will act as a back-end BIND sever

-  Windows7 RDP server which will be used as a jumpbox in to your
   environment

To access your Ravello Lab Environment, from either Chrome or Mozilla
Browser connect to the Ravello Training Portal **(Ask an instructor for the IP address)**

Type in your username such as **dns201\_student1, dns201\_student2**,
etc. with a shared password of **"DnS201"**

Select ‘View’ Under the Actions Column associated with the DNS201 lab.

Once you are logged in, you will see the URL for your specific windows
jump box needed to proceed with the lab. A student view:

|image0|

NOTE: All the VMs should be in a STARTED state, if a VM is in any other
state please let the Lab Instructors know or you can attempt to RESTART
the VM yourself.

Select and Highlight then COPY the URL Link located under the DNS
section

Open a Remote Desktop Client on your Laptop and Paste the DNS URL Link
from the Ravello Login screen.

Username: **Student**

Password: **F5@GilitY!** //This is the same password for all Student Logins

Once connected to the Windows7 jumpbox, you will be able to access all
other machines needed for this lab from this system. From the jumpbox,
your F5 device is accessible via HTTPS at: **10.128.1.245** (username:
**admin** password: **admin**)

And available via SSH at the same address with username: **root**
password: **default**

Shortcuts to your devices have been provided on your Windows Desktop.

**\*\*Please use the ‘Command Prompt’ shortcut for ALL ‘dig’ related commands.**

Your F5 has already been configured with the following:

- Networking: VLANs, SelfIPs, Routing
- DNS, NTP
