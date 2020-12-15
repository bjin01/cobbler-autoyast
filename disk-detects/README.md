# Detect block devices and show disk list as ask dialog in autoyast

There is a pre-script that 
1. wget - download the bash script from a install server or SUSE Manager host to the yast installer system.
2. the bash script will be executed and it tries to parse /dev/disk/by-path/ directory. The example is trying to find pci devices
3. the bash script then tries to parse the block device shortname ../../vda or ../../sda etc.
4. then the bash script tries to use lsblk to detect the disks and get the size of each block device
5. then the bash script will write a temp.xml files with the xml syntax for a new ask section with a selection list of all found block devices.
6. The value of the device will be ../../by-path/... and the label will be the pci-path, shortname and size for the user to make decision 
7. The bash script will then add the temp.xml into the current autoinst.xml and write into a new file in /tmp/profile/modified.xml

This script has been tetsted on SLES15SP2 in conjunction with SUSE Manager 4.1.3

The original idea is to use a such script to detect SAN LUNs which should be used for root disks.

Feedbacks welcome.
