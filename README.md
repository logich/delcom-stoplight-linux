delcom-stoplight-linux
====================

C++ USB HID code to drive a Delcom Gen2 three color indicator light on linux.

Basic code currrently sets the light based on commandline arguments. 

Simple data structures are present to set yellow or green with each led in an on or off state.

Makes use of Alan Ott's HIDAPI - Multi-Platform library for communication with HID devices.

HIDAPI's public source code repository  is located at: http://github.com/signal11/hidapi 

Makefile uses the HIDAPI code and libusb.

You will need g++, libpthread-stub0-dev, libusb-1.0-dev, and libudev-dev packages.

A udev rule file can be copied into /etc/udev/rules.d to allow users to run the program instead of root.

There is also a perl pidgin plugin to change color based on availability
