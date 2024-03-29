
# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application

# The name of your application
TARGET = harbour-sailfishslots

CONFIG += sailfishapp
CONFIG(release, debug|release) {
 DEFINES += QT_NO_DEBUG_OUTPUT
}

SSH_TARGET_NAME = $(MER_SSH_TARGET_NAME)
message ( "mer target is " $$SSH_TARGET_NAME )

QMAKE_LFLAGS += -Wl,-rpath,\\$${LITERAL_DOLLAR}$${LITERAL_DOLLAR}ORIGIN/../share/$${TARGET}/lib

LIBS += -L$$_PRO_FILE_PWD_/lib

INCLUDEPATH += ../thirdparty/SailfishWidgets/include

SOURCES += src/$${TARGET}.cpp

OTHER_FILES += rpm/* \
    qml/* \
    qml/pages/* \
    qml/cover/* \
    translations/*.ts \
    harbour/sailfishslots/* \
    harbour/sailfishslots/SailfishSlots/* \
    sounds/* \
    $${TARGET}.desktop \
    lib/libapplicationsettings.so \
    lib/libcore.so.1 \
    lib/liblanguage.so \
    images.qrc

QT += qml multimedia

QML_IMPORT_PATH = .
QML2_IMPORT_PATH += $$_PRO_FILE_PWD_/harbour/sailfishslots/SailfishWidgets/Settings

target.path = /usr/bin
INSTALLS += target

#install lib
ss.files = harbour lib sounds
ss.path = /usr/share/$${TARGET}
INSTALLS += ss

png1.files = icons/hicolor/*
png1.path = /usr/share/icons/hicolor
INSTALLS += png1

#png2.files = harbour-sailfishslots_128x128.png
#png2.path = /usr/share/icons/hicolor/128x128/apps/$${TARGET}.png
#INSTALLS += png2

#png3.files = harbour-sailfishslots_172x172.png
#png3.path = /usr/share/icons/hicolor/172x172/apps/$${TARGET}.png
#INSTALLS += png3

### Rename QML modules for Harbour store
swlc.path = /usr/share/$${TARGET}/harbour/sailfishslots
swlc.commands = find /home/deploy/installroot$$swl.path -name 'qmldir' -exec sed -i \"s/module SailfishWidgets/module harbour.sailfishslots.SailfishWidgets/\" \\{} \;;
swlc.commands += find /home/deploy/installroot$$swl.path -name '*.qmltypes' -exec sed -i \"s/SailfishWidgets/harbour\/sailfishslots\/SailfishWidgets/\" \\{} \;;
INSTALLS += swlc

# Linker instructions--The order of -L and -l is important
LIBS += -lsailfishapp \
        -lapplicationsettings \
        -lcore \
        -llanguage


# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/$${TARGET}.ts \
                translations/$${TARGET}-ja.ts

RESOURCES += \
    images.qrc
