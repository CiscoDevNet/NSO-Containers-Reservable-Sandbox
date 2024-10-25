# NSO-Containers-Reservable-Sandbox

Definiton of the NSO containers used for the Reservable Sandbox

## Development

To **upgrade the NSO version**, update the [NSO_VERSION variable on the sandbox_env_vars.sh file,](sandbox_env_vars.sh#L1) the `Makefile` file will take care of the rest.

For local development _Build and Run_ a container.

```bash
make all
```

Enter the container.

```bash
make cli
```

The NSO configuration file is named `ncs.conf.xml` to allow the editor highlight it and treat it as `xml`. Then on the dockerfile is copied as `ncs.conf`.

## Credentials

The credentials provided are `developer/C1sco12345`

> **NOTE:** The container runs as `developer` user without any root priviledges.

## Adding NEDs

Add the `signed.bin` file, for example `ncs-6.2.3-cisco-ios-6.106.5.signed.bin` to the `neds` directory.

The [setup_add_neds.sh script](scripts/setup_add_neds.sh) will automatically unpack and add the NEDs to the docker image.

## Packages

One [example package router](packages/router) is included, for users to use as a starting point.

A third party package [rest-api-explorer.tar.gz](https://gitlab.com/nso-developer/rest-api-explorer/-/tree/master) is used for the sandbox, you can add it as well if desired. This package is for helping users with REST APIs.

## SSH

For `ssh` to work as non-root, [PAM auth is enabled.](config/ssh/sshd_config#L96)

## Memory changes

Changes done on the VM. Under `/etc/sysctl.conf` add these lines

```bash
vm.overcommit_memory = 2
vm.overcommit_ratio = 100
```

```bash
developer@ubuntu:~$ sudo vim /etc/sysctl.conf
[sudo] password for developer:
developer@ubuntu:~$ tail -4 /etc/sysctl.conf
#kernel.sysrq=438

vm.overcommit_memory = 2
vm.overcommit_ratio = 100
developer@ubuntu:~$ sudo sysctl -p
vm.overcommit_memory = 2
vm.overcommit_ratio = 100
developer@ubuntu:~$ cat /proc/sys/vm/overcommit_memory
2
developer@ubuntu:~$ cat /proc/sys/vm/overcommit_ratio
100
developer@ubuntu:~$
```
