# pico-build-all

Build all of the Pico packages in one easy script.

Pico is made up from several components:

- [android-pico](https://github.com/mypico/android-pico)
- [jpico](https://github.com/mypico/jpico)
- [libpicobt](https://github.com/mypico/libpicobt)
- [libpico](https://github.com/mypico/libpico)
- [pam_pico](https://github.com/mypico/pam_pico)

You can build them individually by following the instructions in each of the repositories, or check the [developer documentation](https://docs.mypico.org/developer/) for more complete instructions.

But you probably don't really want to go through all of that do you? Suppose you just want to build the lot? If you're using Ubuntu 16.04 you can just clone this repository and run the following shell script.

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
