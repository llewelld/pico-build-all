# pico-build-all

## About Pico

The Pico project is liberating humanity from passwords. See https://www.mypico.org.

Pico is an alternative to passwords developed at the University of Cambridge that enables a smooth and password-free login to computers, and consists of a smartphone app and associated software on your computer.

## Install Pico on Ubuntu

The scripts in this repository allow you to build all of the Pico packages in one easy script. However, if you just want the binaries on Ubuntu 16.04, you can install directly from the Pico repository instead.

### Install the binary

If you're using Ubunutu 16.04, you can install directly from the Pico repository. Just add the repository:
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

### Install from source

If you want to build from source, the scripts in this repository will help you.

Pico is made up from several components:

- [android-pico](https://github.com/mypico/android-pico)
- [jpico](https://github.com/mypico/jpico)
- [libpicobt](https://github.com/mypico/libpicobt)
- [libpico](https://github.com/mypico/libpico)
- [pam_pico](https://github.com/mypico/pam_pico)

You can build them individually by following the instructions in each of the repositories, or check the [developer documentation](https://docs.mypico.org/developer/) for more complete instructions.

But you probably don't really want to go through all of that, do you? Suppose you just want to build the lot? If you're using Ubuntu 16.04, you can just clone this repository:
```
git clone git@github.com:mypico/pico-build-all.git
cd pico-build-all
```
Then run the following shell script. Note that this will install all of the dependencies, accept the Android Developer licence agreement and install the packages it builds without your intervention. If you're concerned about seeing what it's doing and making these decisions yourself, use the makefile detailed below instead.

```
./build-all.sh
```

If you're a more advanced user, you can use the makefile instead. This assumes you have `make` installed and provides a bit more visibilty. It's configurd to stop at various points to ask your consent (e.g. to install packages). You can run it by typing the following.

```
make
```

The benefit of the makefile is that it'll only perform the steps to update anything that's changed, and will skip steps that don't need to be performed.

On successful completion, both will create a folder called `built`, inside which you'll find an Android apk and five deb packages. The deb packages will already have been installed, but if you want to install them manually from inside the `built` folder, you can use the following.
```
sudo dpkg -i libpicobt_0.0.2_amd64-run.deb
sudo dpkg -i libpicobt_0.0.2_amd64-dev.deb
sudo dpkg -i libpico1_0.0.3-1_amd64.deb
sudo dpkg -i libpico1-dev_0.0.3-1_amd64.deb
sudo dpkg -i libpam-pico_0.0.3-1_amd64.deb
```

## Install Pico on Android phone

The easiest way to install the app is to deploy it to your phone via USB. Ensure your phone has [developer debugging](https://www.kingoapp.com/root-tutorials/how-to-enable-usb-debugging-mode-on-android.htm) enabled and connect it via USB to your computer. To check whether your phone is developer-enabled and correctly connected, enter the following on the computer it's connected to. 

```
adb devices -l
```

If you don't see your device showing correctly in this list, you'll need to fix this first. In this case check out the details on the [Android developer site](https://developer.android.com/studio/command-line/adb.html).

Once your developer-enabled Android phone is correctly connected to your computer via USB, you can install the app with the following.
```
adb -d install built/android-pico-debug.apk
```

In case this fails, it could be because you've got an old version of Pico already installed. Uninstall it from your phone first, then try again.

## Pairing your Pico

You're now in a position to pair the Pico app with your computer. Enter the following on your computer.

```
gksu -k "pico-pair --gui --user $USER"
```

You'll need to enter your password a couple of times and scan the QR code with your Pico. A wizard will take you through the process. At the end of the process, make sure you Bluetooth pair your phone with your computer.

## Configuring pam_pico

Finally you need to configure pam_pico for use with the application you want to authenticate to. Configuring PAMs is complex and not for the faint-hearted. Too complex for this README file in fact. If you want to know the full gory details, please refer to the [developer documentation](https://docs.mypico.org/developer/pam_pico/#configure).

However, let's suppose you're running a default Ubuntu 16.04 installation with no changes to the existing PAM configuration files. We'll go through adding Pico to the Unity lock screen as an example.

For this, open the `/etc/pam.d/unity` file in a text editor as root.

```
sudo nano /etc/pam.d/unity
```

You should see this:

```
@include common-auth
auth optional pam_gnome_keyring.so
```

That's a fairly basic PAM config file (the actual hard work is going on inside the `common-auth` file that's included in this one).

To add Pico functionality, you'd need to add a new line to the top of the file, as well as commenting out the `@include` line, like this.

```
auth    required /usr/lib/x86_64-linux-gnu/security/pam_pico.so channeltype=btc continuous=1 beacons=1 anyuser=1 qrtype=none input=0 timeout=0
#@include common-auth
auth optional pam_gnome_keyring.so
```

Now save the file. If you lock your machine now, you'll need your Pico to log in, so make sure you've correctly paired your Pico with your phone as explained above before doing anything else.

## Authenticating with Pico

If you're satisfied everything is set up correctly, lock your Unity session and you'll notice the password box has gone. Instead, a button will appear on the Pico scanner screen of your Pico prompting you to 'Touch to log in'.

Touch the button and Pico will log you in to your computer. Check out the [end user instructions](https://get.mypico.org/linux/#use-pico) for more info about how to use Pico.

## Uninstall the packages

Independent of how they were installed, the easiest way to uninstall the packages is as follows
```
sudo apt remove libpicobt-run
```
Since all of the packages depend on this package, it will cause any of the others you also have installed to be removed as well.

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
