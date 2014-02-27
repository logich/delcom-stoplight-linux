###########################################
# Simple Makefile for delcom-stoplight program
#
# Logan Browne
# 7-Feb-2014
###########################################

all: delcom-stoplight

CC       ?= gcc
CFLAGS   ?= -Wall -g

CXX      ?= g++
CXXFLAGS ?= -Wall -g

COBJS     = hid-libusb.o
CPPOBJS   = main.o
OBJS      = $(COBJS) $(CPPOBJS)
LIBS      = `pkg-config libusb-1.0 libudev --libs` -pthread
INCLUDES ?= -I../hidapi `pkg-config libusb-1.0 pthread-stubs --cflags`


delcom-stoplight: $(OBJS)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $^ $(LIBS) -o delcom-stoplight

$(COBJS): %.o: %.c
	$(CC) $(CFLAGS) -c $(INCLUDES) $< -o $@

$(CPPOBJS): %.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $(INCLUDES) $< -o $@

clean:
	rm -f $(OBJS) delcom-stoplight

.PHONY: clean
