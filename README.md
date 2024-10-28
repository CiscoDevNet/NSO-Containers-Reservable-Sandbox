# NSO-Containers-Reservable-Sandbox

NSO is a top-notch tool for automating and orchestrating network services across both physical and virtual elements. NSO supports hundreds of devices from various network and infrastructure vendors.

The [NSO Reservable Sandbox](https://devnetsandbox.cisco.com/DevNet/catalog/nso-sandbox_nso) provides a hands-on experience with NSO APIs and network automation package development.

On this repository, you can find **the files and configuration that are used to build the NSO containers for the Sandbox**.

> [!IMPORTANT]
> This repository **does not contain any NSO containers or NED artifacts**. You can get a _free trial_ of the NSO container on [Download Your NSO Free Trial Installer and Cisco NEDs](https://developer.cisco.com/docs/nso/getting-and-installing-nso/#download-your-nso-free-trial-installer-and-cisco-neds), click on the link and look for files with `container-image-prod`, then pick your architecture.

You can find the [NSO Reservable Sandbox here.](https://devnetsandbox.cisco.com/DevNet/catalog/nso-sandbox_nso)

## Building and Running

This repository contains all the files that are needed to build the image. To build and run a container, follow these steps:

- Set the NSO version by updating the `NSO_VERSION` environment variable in the [sandbox_env_vars](./sandbox_env_vars.sh#L1) file.
- Change `nso-devnet/reservable-sandbox` to the desired tag name for the built image.
- Replace `cisco-nso/cisco-nso-prod` with the base image name of the NSO container that you downloaded.

> [!TIP]
> Use your IDE search capabilities to find all the occurrence of the names across the repo.

## Development

### Build

The [Makefile](Makefile) on the root of the project handles the necessary Docker commands.

To build the initial container, run:

```bash
make build
```

### Working using Make

Start and watch the NSO logs using `run` and `follow`. This is useful when working with the NSO startup.

```bash
make run follow
```

Press `Ctrl + C` To stop the Docker log command (used by the `follow` make entry).

To enter the container, run:

```bash
make cli
```

### Working using Dev Containers

You can use [dev containers](https://containers.dev/) to interact directly with NSO through your IDE. VS Code opens your environment inside the NSO container along with the terminal.

On macOS, follow these steps:

1. Press `Cmd + p`
2. Type `> rebuild and reopen in container`

VS Code opens a new window, install extensions, and configure itself to work with NSO. See the configuration used in [the devcontainer.json file.](.devcontainer/devcontainer.json)

## Credentials

The credentials used `developer/C1sco12345` on the containers [are hardcoded.](Dockerfile#L18) This ensures that the containers always have the same credentials, which in the Sandbox environment _is desired for educational purposes._

> [!CAUTION]
> For production, never hard code credentials.

The container runs as the `developer` user without any root privileges. Note that `sudo` is not installed.

## Adding NEDs

Copy your NEDs' `signed.bin` file (for example, `ncs-6.2.3-cisco-ios-6.106.5.signed.bin`) to the [NEDs' directory.](/neds/)

The script [setup_add_neds](scripts/setup_add_neds.sh) unpacks and adds the NEDs to the Docker image at build time. It runs automatically.

For more information, see the [NEDs Readme.](neds/README.md)

## Packages

A [router package](packages/router) example is included as a starting point.

We added a third-party package [rest-api-explorer](https://gitlab.com/nso-developer/rest-api-explorer/-/tree/master) to the NSO containers. You can add it as well if desired. This package helps with REST APIs by providing a Swagger GUI (only works with Chrome).

For more information, see the [Package Readme.](packages/README.md)

## SSH

On the containers, to enable `ssh` work as non-root, [PAM Auth is enabled.](config/ssh/sshd_config#L96)

## Learn More

To learn more about the official NSO container, see the [Containerized NSO](https://developer.cisco.com/docs/nso/guides/containerized-nso) documentation.

Explore additional content for working with the NSO container.

- [Best Practices in Migrating from NID to Official Containerized NSO.](https://community.cisco.com/t5/crosswork-automation-hub-blogs/best-practices-in-migrating-from-nid-to-official-containerized/ba-p/5206419)
- [Deploy LSA with Containerized NSO.](https://community.cisco.com/t5/crosswork-automation-hub-blogs/deploy-lsa-with-containerized-nso/ba-p/5163795)

Start experimenting with the [NSO reservable Sandbox.](https://devnetsandbox.cisco.com/DevNet/catalog/nso-sandbox_nso)

## Need Help?

If you have questions, feel free to ask on the [NSO Developer Hub.](https://community.cisco.com/t5/nso-developer-hub/ct-p/5672j-dev-nso)

## Appendix

### Memory changes

We tweaked the VM used by the Sandbox to prevent the _Linux Out Of Memory Killer_ terminating NSO unexpectedly. This is documented on the [Containerized NSO](https://developer.cisco.com/docs/nso/guides/containerized-nso/#administrative-information) documentation, under _NSO System Dump and Disable Memory Overcommit_.

We Added the following lines to `/etc/sysctl.conf`.

```bash
vm.overcommit_memory = 2
vm.overcommit_ratio = 100
```

Resulting in:

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
