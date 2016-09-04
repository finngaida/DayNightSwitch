TARGET = iphone:latest

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DayNightSwitch
DayNightSwitch_FILES = Tweak.xm DayNightSwitch.m

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += daynightswitch
include $(THEOS_MAKE_PATH)/aggregate.mk
