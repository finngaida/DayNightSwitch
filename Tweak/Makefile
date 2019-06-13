ARCHS ?= arm64 arm64e
target ?= iphone:latest:11.2
SDKVERSION = 11.2
CFLAGS = -Iinclude
GO_EASY_ON_ME=1
DEBUG=0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DayNightSwitch
DayNightSwitch_FILES = Tweak.xm DayNightSwitch.m

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += daynightswitch
include $(THEOS_MAKE_PATH)/aggregate.mk
