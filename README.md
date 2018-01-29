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

Note that, because some of the components depend on others that are built, this will install various packages as it goes along, both in the repositories and the packages it builds.

The script will create a folder called `built`. If it completes successfully you'll find an Android apk and five deb packages inside there.
