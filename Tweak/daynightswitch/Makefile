include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = DayNightSwitch
DayNightSwitch_FILES = FGARootListController.m
DayNightSwitch_INSTALL_PATH = /Library/PreferenceBundles
DayNightSwitch_FRAMEWORKS = UIKit
DayNightSwitch_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/DayNightSwitch.plist$(ECHO_END)
