Deploy OpenStack via Kolla containerized services
=================================================

This repo is intended to accelerate the installation of a basic
All-In-One Kolla driven environment.  It has been tested on a
VirtualBox based environment.

Install Ubuntu Xenial on a machine, with as much resource as your
virtualization host has to spare (4 cores, 8GB memory, 40GB disk minimum)
and ensure you can ssh to the host as the root or ubuntu user without
passwords (ssh configured).

then update the local inventory file with the IP Address of the 
target machine and launch ansible:

ansible-playbook kolla.yml

Once the containers are built, you can launch the actual OpenStack
deployment:

ansible-playbook launch.yml

