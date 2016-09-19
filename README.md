Deploy OpenStack via Kolla containerized services
=================================================

This repo is intended to accelerate the installation of a basic
All-In-One Kolla driven environment.  It has been tested on a
VirtualBox based environment.

Install Centos 7.2 on a machine, with as much resource as your
virtualization host has to spare (4 cores, 8GB memory, 40GB disk minimum)
and ensure you can ssh to the host as the root user without
passwords (ssh configured).

then update the inventory file in this repo changing, if necessary:

```
ansible_host={address of the ssh reachable interface}
domain={either a dns registerd domain name for the instance, or your own}
nat_int
pub_int
ext_int
```

Then launch ansible against it:

```ansible-playbook kolla.yml```

This should launch a centos-binary-3.0.0 based kolla environment.  There are two bugs that are being addressed as I write this, one that affects nova's ability to boot instances, as there is some interaction in the NUMA code that breaks the scheduler after filtering. Run the following additinoal ansible on the build host (the host from which you ran the ansible provided in this repository):

```ansible-playbook fix_nova_compute_vb.yml```

This will add 'virt_type: qemu' to the nova-compute nova.conf and restart the nova-compute container.

In addition, for complete Horizon use, the ```_member_``` role doesn't get created. This can be fixed either in Horizon or via the CLI:

Log into the target kolla node, become root, and then run:

```
source ~/admin.rc
openstack role create _member_
```

Now you have a baseline functional Kolla system.  A default public/private+router network can be created with the:

    create_networks.sh

script which should be on the kolla node.
