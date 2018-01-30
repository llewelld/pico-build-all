all: install-libpam androidpico

.NOTPARALLEL:

.PHONY: install clean

GIT = git
DEBUILD = debuild
DEBUILD_FLAGS = -us -uc -b --lintian-opts -X changes-file
CP = cp
CP_FLAGS = -u
RSYNC = rsync
RSYNC_FLAGS = -r -u --delete
DEBSUFFIX = ubuntu16.04
GITROOT = git@github.com:mypico
#GITROOT = git@gitlab.dtg.cl.cam.ac.uk:pico

LIBPICO_RUN = libpico1_*_amd64.deb
LIBPICO_DEV = libpico1-dev_*_amd64.deb

LIBPICOBT_RUN = libpicobt_*_amd64-run.deb
LIBPICOBT_DEV = libpicobt_*_amd64-dev.deb

LIBPAM_RUN = libpam-pico_*_amd64.deb

ANDROIDPICO_APK = android-pico-debug.apk

clean:
	rm -rf working built; \

############### install-libpicobt

.PHONY: install-libpicobt

install-libpicobt: /usr/include/picobt/bt.h update-libpicobt

/usr/include/picobt/bt.h: built/$(LIBPICOBT_RUN) built/$(LIBPICOBT_DEV)
	sudo dpkg -i built/$(LIBPICOBT_RUN); \
	sudo dpkg -i built/$(LIBPICOBT_DEV); \
	sudo touch /usr/include/picobt/bt.h

############### install-libpico

.PHONY: install-libpico

install-libpico: /usr/include/pico/pico.h update-libpico install-libpicobt

/usr/include/pico/pico.h: built/$(LIBPICO_RUN) built/$(LIBPICO_DEV)
	sudo dpkg -i built/$(LIBPICO_RUN); \
	sudo dpkg -i built/$(LIBPICO_DEV); \
	sudo touch /usr/include/pico/pico.h

############### install-libpam

.PHONY: install-libpam

install-libpam: /usr/bin/pico-continuous update-libpam install-libpico install-libpicobt

/usr/bin/pico-continuous: built/$(LIBPAM_RUN)
	sudo dpkg -i built/$(LIBPAM_RUN); \
	sudo touch /usr/bin/pico-continuous

############### libpicobt

.PHONY: libpicobt-deb update-libpicobt

libpicobt-deb: update-libpicobt built/$(LIBPICOBT_RUN) built/$(LIBPICOBT_DEV)

built/$(LIBPICOBT_RUN) built/$(LIBPICOBT_DEV): working/libpicobt/build/packages/$(LIBPICOBT_RUN) working/libpicobt/build/packages/$(LIBPICOBT_DEV)
	mkdir built; \
	$(CP) $(CP_FLAGS) working/libpicobt/build/packages/$(LIBPICOBT_RUN) built/; \
	$(CP) $(CP_FLAGS) working/libpicobt/build/packages/$(LIBPICOBT_DEV) built/

update-libpicobt: working/libpicobt
	cd working/libpicobt; \
	$(GIT) pull; \
	cd ../..

working/libpicobt/build/packages/$(LIBPICOBT_RUN) working/libpicobt/build/packages/$(LIBPICOBT_DEV): working/libpicobt
	cd working/libpicobt; \
	sudo apt install openssh-client git libbluetooth-dev cmake dh-exec gcovr check pkg-config doxygen graphviz; \
	mkdir build; \
	cd build; \
	cmake ..;\
	make package; \
	cd ../../..

working/libpicobt:
	$(GIT) clone $(GITROOT)/libpicobt.git working/libpicobt

############### libpico

.PHONY: libpico-deb update-libpico

libpico-deb: update-libpico built/$(LIBPICO_RUN) built/$(LIBPICO_DEV)

built/$(LIBPICO_RUN) built/$(LIBPICO_DEV): working/$(LIBPICO_RUN) working/$(LIBPICO_DEV)
	mkdir built; \
	$(CP) $(CP_FLAGS) working/$(LIBPICO_RUN) built/; \
	$(CP) $(CP_FLAGS) working/$(LIBPICO_DEV) built/

update-libpico: working/libpico
	cd working/libpico; \
	$(GIT) pull; \
	git checkout debian/changelog; \
	dch -l~`git rev-list master --count`~$(DEBSUFFIX). Auto build.; \
	dch -r .; \
	cd ../..

working/$(LIBPICO_RUN) working/$(LIBPICO_DEV): /usr/include/picobt/bt.h working/libpico
	cd working/libpico; \
	sudo apt install libssl-dev libcurl4-openssl-dev libqrencode-dev libbluetooth-dev liburl-dispatcher1-dev pkg-config autotools-dev devscripts debhelper dh-systemd dh-exec build-essential git gcc make check openssh-client doxygen graphviz; \
	./configure; \
	$(DEBUILD) $(DEBUILD_FLAGS); \
	cd ../..

working/libpico:
	$(GIT) clone $(GITROOT)/libpico.git working/libpico

############### libpam

.PHONY: libpam-deb update-libpam

libpam-deb: update-libpam built/$(LIBPAM_RUN)

built/$(LIBPAM_RUN): working/$(LIBPAM_RUN)
	mkdir built; \
	$(CP) $(CP_FLAGS) working/$(LIBPAM_RUN) built/

update-libpam: working/pam_pico
	cd working/pam_pico; \
	$(GIT) pull; \
	git checkout debian/changelog; \
	dch -l~`git rev-list master --count`~$(DEBSUFFIX). Auto build.; \
	dch -r .; \
	cd ../..

working/$(LIBPAM_RUN): /usr/include/pico/pico.h working/pam_pico
	cd working/pam_pico; \
	sudo apt install autoconf autotools-dev libcurl4-openssl-dev libqrencode-dev check cmake libpam0g-dev gcovr libbluetooth-dev libsoup2.4-dev devscripts build-essential openssh-client git debhelper libtool pkg-config libssl-dev libglib2.0-dev dh-systemd libdbus-glib-1-dev libgtk-3-dev liburl-dispatcher1-dev doxygen graphviz; \
	./configure; \
	$(DEBUILD) $(DEBUILD_FLAGS); \
	cd ../..

working/pam_pico:
	$(GIT) clone $(GITROOT)/pam_pico.git working/pam_pico

############### androidpico

.PHONY: androidpico update-androidpico

androidpico: update-androidpico built/$(ANDROIDPICO_APK)

built/$(ANDROIDPICO_APK): working/android-pico/android-pico/build/outputs/apk/$(ANDROIDPICO_APK)
	$(CP) $(CP_FLAGS) working/android-pico/android-pico/build/outputs/apk/$(ANDROIDPICO_APK) built/

update-androidpico: working/android-pico
	cd working/android-pico; \
	$(GIT) pull; \
	cd ../..

working/android-pico/android-pico/build/outputs/apk/$(ANDROIDPICO_APK): working/android-pico working/android-pico/android-sdk-linux
	cd working/android-pico; \
	sudo apt install openjdk-8-jdk git ant wget android-tools-adb lib32stdc++6 lib32z1; \
	git submodule init; \
	git submodule update; \
	export ANDROID_HOME=$(CURDIR)/working/android-pico/android-sdk-linux; \
	export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8; \
	./gradlew assembleDebug; \
	./gradlew javadoc; \
	cd ../..

working/android-pico/android-sdk.tgz:
	cd working/android-pico; \
	wget --output-document=android-sdk.tgz https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz; \
	cd ../..

working/android-pico/android-sdk-linux: working/android-pico/android-sdk.tgz
	cd working/android-pico; \
	tar --extract --gzip --file=android-sdk.tgz; \
	android-sdk-linux/tools/android update sdk --no-ui --all --filter platform-tools,tools,build-tools-25.0.2,android-23,extra-android-m2repository,extra-google-m2repository; \
	cd ../..

working/android-pico:
	mkdir built; \
	$(GIT) clone $(GITROOT)/android-pico.git working/android-pico


