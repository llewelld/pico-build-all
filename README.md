# pico-build-all

## About Pico

The Pico project is liberating humanity from passwords. See https://www.mypico.org.

Pico is an alternative to passwords developed at the University of Cambridge that enables a smooth and password-free login to computers, and consists of a smartphone app and associated software on your computer.

The scripts in this repository allow you to build all of the Pico packages in one easy script. However, if you just want the binaries on Ubuntu 16.04, you can install directly from the Pico repository instead.

## Install the binary

If you're using Ubunutu 16.04 you can install directly from the Pico repository. Just add the repository:
```
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 22991E96
sudo add-apt-repository "deb https://get.mypico.org/apt/ xenial main"
sudo apt update
```

then install libpam-pico:
```
sudo apt install libpam-pico
```

If you also want the developer files, you can also install these.
```
sudo apt install libpicobt-dev
sudo apt install libpico1-dev
```

## Install from source

If you want to build from source, the scripts in this repository will help you.

Pico is made up from several components:

- [android-pico](https://github.com/mypico/android-pico)
- [jpico](https://github.com/mypico/jpico)
- [libpicobt](https://github.com/mypico/libpicobt)
- [libpico](https://github.com/mypico/libpico)
- [pam_pico](https://github.com/mypico/pam_pico)

You can build them individually by following the instructions in each of the repositories, or check the [developer documentation](https://docs.mypico.org/developer/) for more complete instructions.

But you probably don't really want to go through all of that do you? Suppose you just want to build the lot? If you're using Ubuntu 16.04 you can just clone this repository:
```
git clone git@github.com:mypico/pico-build-all.git
cd pico-build-all
```
Then either run the following shell script.

```
./build-all.sh
```

Or, if you have `make` installed, you can do the same thing more efficiently with the following.
```
make
```

The benefit of the makefile is that it'll only perform the steps to update anything that's changed, and will skip steps that don't need to be performed.

Note that, because some of the components depend on others that are built, both the shell script and the makefile will install various packages as they go along, both from the repositories and from the packages it builds. It may ask you to agree for them to be installed, ask you to enter a `sudo` password, or ask you to agree to the ADK licensing agreement as it goes along.

On successful completion, both will create a folder called `built`, inside which you'll find an Android apk and five deb packages.

## License

These scripts are released under the AGPL licence. Read COPYING for information.

## Contributing

We welcome comments and contributions to the project. If you're interested in contributing please see here: https://get.mypico.org/cla/

## Contact and Links

More information can be found at: http://mypico.org

The Pico project team:
 * Frank Stajano (PI), Frank.Stajano@cl.cam.ac.uk
 * David Llewellyn-Jones, David.Llewellyn-Jones@cl.cam.ac.uk
 * Claudio Dettoni, cd611@cam.ac.uk
 * Seb Aebischer, seb.aebischer@cl.cam.ac.uk
 * Kat Krol, kat.krol@cl.cam.ac.uk
