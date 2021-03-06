#
# Makefile for Atrix2
#

# The original zip file, MUST be specified by each product
local-zip-file     := stockrom.zip

# The output zip file of MIUI rom, the default is update.zip if not specified
local-out-zip-file := MIUI_Atrix2.zip

local-previous-target-dir := ~/workspace/ota_base/me865

# All apps from original ZIP, but has smali files chanded
local-modified-apps := Gallery2


local-modified-jars :=


# All apks from MIUI
local-miui-removed-apps := MediaProvider Stk
local-miui-modified-apps := MiuiHome Settings Phone ThemeManager Music Mms MiuiCompass PackageInstaller


# Config density for co-developers to use the aaps with HDPI or XHDPI resource,
# Default configrations are HDPI for ics branch and XHDPI for jellybean branch
local-density := HDPI


include phoneapps.mk

# To include the local targets before and after zip the final ZIP file, 
# and the local-targets should:
# (1) be defined after including porting.mk if using any global variable(see porting.mk)
# (2) the name should be leaded with local- to prevent any conflict with global targets
local-pre-zip := local-pre-zip-misc
local-after-zip:= local-put-to-phone

local-rewrite-skia-lib:= false

# The local targets after the zip file is generated, could include 'zip2sd' to 
# deliver the zip file to phone, or to customize other actions

include $(PORT_BUILD)/porting.mk

# To define any local-target
updater := $(ZIP_DIR)/META-INF/com/google/android/updater-script

local-pre-zip-misc:
	@echo Update build.prop
	cp stockrom/system/bin/installd $(ZIP_DIR)/system/bin/installd
	cp other/platform.xml $(ZIP_DIR)/system/etc/permissions/platform.xml
	cp other/javax.btobex.jar $(ZIP_DIR)/system/framework/javax.btobex.jar
	cp other/atmxt-i2c.kl $(ZIP_DIR)/system/usr/keylayout/
	cp other/spn-conf.xml $(ZIP_DIR)/system/etc/spn-conf.xml
	cp other/build.prop $(ZIP_DIR)/system/build.prop
	cp other/init.rc $(ZIP_DIR)/system/bootmenu/2nd-init/
#
#	@echo update bootanimation
#	rm $(ZIP_DIR)/system/bin/bootanimation
#	cp other/bootanimation $(ZIP_DIR)/system/bin/bootanimation
#
#	@echo add system config
#	#cp -fR other/system_app/* $(ZIP_DIR)/system/app/
#	cp -fR other/system_etc/* $(ZIP_DIR)/system/etc/
#	cp -fR other/system_xbin/* $(ZIP_DIR)/system/xbin/
	#cp other/system_lib/* $(ZIP_DIR)/system/lib/

#	@echo add system app
	#cp other/system_app/* $(ZIP_DIR)/system/app/

	@echo delete redundance files
	rm -rf $(ZIP_DIR)/system/media/MotoDemo
	rm -rf $(ZIP_DIR)/system/multiconfig
	rm -rf $(ZIP_DIR)/system/tts
	rm -rf $(ZIP_DIR)/system/vendor/app
	rm -rf $(ZIP_DIR)/system/bin/su
	cp ../miui/XHDPI/system/app/DeskClock.apk $(ZIP_DIR)/system/app/
	cp other/baiduinput.apk $(ZIP_DIR)/data/media/preinstall_apps/
	cp other/gps.conf $(ZIP_DIR)/system/etc/
	rm  -rf $(ZIP_DIR)/data/media/preinstall_apps/MiuiVideo.apk
	#cp other/Gallery2.apk $(ZIP_DIR)/system/app/

local-put-to-phone:
#	rm -f $(local-out-zip-file)
#	cp .build/$(local-out-zip-file) 
#	@echo push $(OUT_ZIP) to phone sdcard
#	adb shell mount sdcard
#	adb shell rm -f /sdcard/update.zip
#	adb push out/update.zip /sdcard/update.zip

#enter recovery
#echo 1 > /data/.recovery_mode ; sync ; reboot ;

%.phone : out/%.jar
	@echo push -- to --- phone
	adb remount
	adb push $< /system/framework
	adb shell chmod 644 /system/framework/$*.jar
	#adb shell stop
	#adb shell start
	#adb reboot

%.test : out/%.apk
	@echo push -- to --- phone
	adb remount
	java -jar $(TOOL_DIR)/signapk.jar $(PORT_ROOT)/build/security/platform.x509.pem $(PORT_ROOT)/build/security/platform.pk8  $< $<.signed
	adb push $<.signed /system/framework/$*.apk
	adb shell chmod 644 /system/framework/$*.apk
%.sign-plat : out/%
	java -jar $(TOOL_DIR)/signapk.jar $(PORT_ROOT)/build/security/platform.x509.pem $(PORT_ROOT)/build/security/platform.pk8  $< $<.signed
	@echo push -- to --- phone
	adb remount
	adb push $<.signed /system/app/$*
	adb shell chmod 644 /system/app/$*
