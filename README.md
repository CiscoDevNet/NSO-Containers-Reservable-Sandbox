# NSO-Containers-Reservable-Sandbox

NSO is a top-notch tool for automating and orchestrating network services across both physical and virtual elements. NSO supports hundreds of devices from various network and infrastructure vendors.

The [NSO Reservable Sandbox](https://devnetsandbox.cisco.com/DevNet/catalog/nso-sandbox_nso) provides a hands-on experience with NSO APIs and network automation package development.

On this repository, you can find **the files and configuration that are used to build the NSO containers for the Sandbox**.

> [!IMPORTANT]
> On this repository, **no NSO container nor NED artifacts are present**. You can find a _free trial_ of the NSO container on [Download Your NSO Free Trial Installer and Cisco NEDs](https://developer.cisco.com/docs/nso/getting-and-installing-nso/#download-your-nso-free-trial-installer-and-cisco-neds), click on the link and look for the files containing `container-image-prod`, then pick your architecture.

You can find the [NSO Reservable Sandbox here.](https://devnetsandbox.cisco.com/DevNet/catalog/nso-sandbox_nso)

## Building and Running

All files needed to build the image are present on this repository. If you want to build and run a container from this repository, you must do the following changes:

- Specify the NSO version using the `NSO_VERSION` env var on the [sandbox_env_vars](./sandbox_env_vars.sh#L1) file.
- Replace `nso-devnet/reservable-sandbox` to set the tag name you want to use for the image built.
- Replace `cisco-nso/cisco-nso-prod` with the image name of the NSO container that you want to use as a base image (the NSO container you downloaded).

> [!TIP]
> Use your IDE search capabilities to find all the occurrence of the names across the repo.

## Development

### Build

The [Makefile](Makefile) on the root of the project takes care of using the right Docker commands.

For building, the initial container you can do.

```bash
make build
```

### Working using Make

You can start and watch the logs of NSO with `run` and `follow`. Useful when you are working with the start of NSO.

```bash
make run follow
```

`Ctrl + c` To stop the Docker log command (used by the follow make entry).

Enter the container.

```bash
make cli
```

### Working using Dev Containers

Also, you can use [dev containers](https://containers.dev/) to interact directly with NSO through your IDE. VS Code opens your environment inside the NSO container along with the terminal.

On MacOS, you can do.

`cmd + p` And `> rebuild and reopen in container`

VS Code opens a new window, install extensions, and configure VS Code to work with NSO. See the configuration used on [the devcontainer.json file.](.devcontainer/devcontainer.json)

## Credentials

The credentials used `developer/C1sco12345` on the containers [are hardcoded.](Dockerfile#L18) This allow us to guarantee the containers will always have the same credentials, which in the Sandbox environment _is desired for educational purposes._

> [!CAUTION]
> For production, never hard code credentials.

The container runs as `developer` user without any root privileges. `sudo` is not installed.

## Adding NEDs

To add your NEDs, copy the `signed.bin` file, for example `ncs-6.2.3-cisco-ios-6.106.5.signed.bin` to the [NEDs' directory.](/neds/)

The script [setup_add_neds](scripts/setup_add_neds.sh) will automatically unpack and add the NEDs to the Docker image at build time.

For more information, see the [NEDs Readme.](neds/README.md)

## Packages

One [example router package](packages/router) is included as a starting point.

We added to the NSO containers the third-party package [rest-api-explorer](https://gitlab.com/nso-developer/rest-api-explorer/-/tree/master), you can add it as well if desired. This package is for helps with REST APIs providing a swagger GUI (only works with Chrome).

For more information, see the [Package Readme.](packages/README.md)

## SSH

For `ssh` to work as non-root, [PAM Auth is enabled.](config/ssh/sshd_config#L96)

## Learn More

To learn more about the official NSO container, see the [Containerized NSO](https://developer.cisco.com/docs/nso/guides/containerized-nso) documentation.

See more content for working with the NSO container.

- [Best Practices in Migrating from NID to Official Containerized NSO.](https://community.cisco.com/t5/crosswork-automation-hub-blogs/best-practices-in-migrating-from-nid-to-official-containerized/ba-p/5206419)
- [Deploy LSA with Containerized NSO.](https://community.cisco.com/t5/crosswork-automation-hub-blogs/deploy-lsa-with-containerized-nso/ba-p/5163795)

Start playing with the [NSO reservable Sandbox.](https://devnetsandbox.cisco.com/DevNet/catalog/nso-sandbox_nso)

## Need Help?

Feel free to ask your questions on the [NSO Developer Hub.](https://community.cisco.com/t5/nso-developer-hub/ct-p/5672j-dev-nso)

## Appendix

### Memory changes

The VM used by the Sandbox had to be tweaked to avoid the _Linux Out Of Memory Killer_ kill NSO without any clue. This is documented on the [Containerized NSO](https://developer.cisco.com/docs/nso/guides/containerized-nso/#administrative-information) documentation, under _NSO System Dump and Disable Memory Overcommit_.

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
