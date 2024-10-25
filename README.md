# NSO-Containers-Reservable-Sandbox

NSO is a top-notch tool for automating and orchestrating network services across both physical and virtual elements. NSO supports hundreds of devices from various network and infrastructure vendors.

The [NSO Reservable Sandbox](https://devnetsandbox.cisco.com/DevNet/catalog/nso-sandbox_nso) provides a hands-on experience with NSO APIs and network automation package development.

On this repository, you can find **the files and configuration used to built the NSO containers for the sandbox**.

> [!IMPORTANT]
> On this repository there are **no NSO container or NED artifacts are present**. You can find an trial container version on the documentation [Download Your NSO Free Trial Installer and Cisco NEDs](https://developer.cisco.com/docs/nso/getting-and-installing-nso/#download-your-nso-free-trial-installer-and-cisco-neds) click on the link and look for the files containing `container-image-prod`, then pick your architecture.

You can find the [NSO Reservable Sandbox here.](https://devnetsandbox.cisco.com/DevNet/catalog/nso-sandbox_nso)

## Building and Running

All files needed to build the image are present on this repository. If you want to build and run a container from this repository, you must do the following changes:

- Specify the NSO version using the `NSO_VERSION` env var.
- Replace `nso-devnet/reservable-sandbox` to set the tag name you want to use for the image built.
- Replace `cisco-nso/cisco-nso-prod` with the image name of the NSO container to be use as a base image (the NSO container you downloaded).

> [!TIP]
> Use your IDE search capabilities to find all the ocurrence of the names across the repo.

## Development

### Build

The [Makefile](Makefile) on the root of the project takes care of using the right docker commands.

For building the initial container you can do.

```bash
make build
```

### Working using Make

For working with the runtime environment there are two options.

```bash
make run follow
```

`Ctrl + c` to stop the docker log command (used by the follow make entry).

Enter the container.

```bash
make cli
```

### Working using Dev Containers

Additionally, you can use [dev container](https://containers.dev/) to interact directly with NSO through your IDE such as VS Code.

On MacOS you can do.

`cmd + p` and `> rebuild and reopen in container`

This will open a new window, install extensions and configure VS Code to work with NSO. See the configuration used on [the devcontainer.json file](.devcontainer/devcontainer.json)

## Credentials

The credentials used `developer/C1sco12345` on the contrainer [are hardcoded.](Dockerfile#L23) This allow us to garantee the containers will always have the same credentials, which in the sandbox environment _is desired for educational purposes._

> [!CAUTION]
> For production, never hard code credentials.

The container runs as `developer` user without any root priviledges. `sudo` is not installed.

## Adding NEDs

To add your NEDs, copy the `signed.bin` file, for example `ncs-6.2.3-cisco-ios-6.106.5.signed.bin` to the `neds` directory.

The [setup_add_neds.sh script](scripts/setup_add_neds.sh) will automatically unpack and add the NEDs to the docker image.

For more information see the [NEDs Readme.](neds/README.md)

## Packages

One [example package router](packages/router) is included, for users to use as a starting point.

A third party package [rest-api-explorer.tar.gz](https://gitlab.com/nso-developer/rest-api-explorer/-/tree/master) is used for the sandbox, you can add it as well if desired. This package is for helping users with REST APIs.

For more information see the [Package Readme.](packages/README.md)

## SSH

For `ssh` to work as non-root, [PAM auth is enabled.](config/ssh/sshd_config#L96)

## Learn More

To learn more about the official NSO container, see the [Containerized NSO](https://developer.cisco.com/docs/nso/guides/containerized-nso) documentation.

The [NSO reservable sandbox link(https://devnetsandbox.cisco.com/DevNet/catalog/nso-sandbox_nso)

## Need Help?

Feel free to ask your question on the [NSO Developer Hub](https://community.cisco.com/t5/nso-developer-hub/ct-p/5672j-dev-nso)

## Apendix

### Memory changes

The VM used by the sandbox had to be tweaked to avoid the _Linux Out Of Memory Killer_ kill NSO without any clue.

Under `/etc/sysctl.conf` we added these lines.

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
