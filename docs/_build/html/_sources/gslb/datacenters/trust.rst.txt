###############################################
Device Trust
###############################################

Prior to configuring the Server object, we need to establish trust
between the GTM and LTM. The bigip\_add script will exchange device
certificates to establish a trust relationship.

* Login via SSH using putty to your gtm1.site1 (10.1.10.13) using
   username: *root* password: *default*
* Issue the following commands
  ::
   bigip_add 203.0.113.5

* Enter ‘\ *yes*\ ’ to proceed and enter ‘\ *default*\ ' as the password.
* Now Enter
  ::
   big3d_install 203.0.113.5

.. note:: This script likely won’t need to install a new version of the big3d agent… this is just for you to be familiar with the script.

* Repeat the same operations (``bigip_add`` and ``big3d_install``) for the
  following LTM objects: 203.0.113.6, 198.51.100.37, 198.51.100.38

