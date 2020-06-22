import QtQuick 2.0

Item {
    id: reel1Rect
    property int borderWidth: 1
    property string color

    Rectangle {
        width: parent.width
        height: borderWidth
        anchors.top: parent.top
        visible: parent.visible
        color: parent.color
    }

    Rectangle {
        width: borderWidth
        height: parent.height
        anchors.right: parent.right
        visible: parent.visible
        color: parent.color
    }

    Rectangle {
        width: borderWidth
        height: parent.height
        anchors.left: parent.left
        visible: parent.visible
        color: parent.color
    }

    Rectangle {
        width: parent.width
        height: borderWidth
        anchors.bottom: parent.bottom
        visible: parent.visible
        color: parent.color
    }
}
