# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
# Note: perform a FULL CLEAN before switching between i486 and armv architectures

TEMPLATE=subdirs
SUBDIRS = sailfishslots
OTHER_FILES += rpm/* README_template.md README.md

DISTFILES += \
    sailfishslots/harbour/sailfishslots/SailfishSlots/Rules.js \
    sailfishslots/harbour/sailfishslots/SailfishWidgets/JS/JsTimer.js
