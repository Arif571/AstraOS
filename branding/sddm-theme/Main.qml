import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    width: 1920
    height: 1080
    color: "#000814"

    // Background gradient
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#000814" }
            GradientStop { position: 1.0; color: "#0a0a2e" }
        }
    }

    // Logo text
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height * 0.25
        text: "⭐ AstraOS"
        color: "#00d4ff"
        font.pixelSize: 64
        font.bold: true
        font.family: "monospace"
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height * 0.35
        text: "As high as stars, illuminating all users"
        color: "#ffffff"
        font.pixelSize: 20
        opacity: 0.6
    }

    // Login form
    Column {
        anchors.centerIn: parent
        spacing: 16

        TextField {
            id: userField
            width: 320
            height: 48
            placeholderText: "Username"
            color: "#ffffff"
            background: Rectangle {
                color: "#ffffff20"
                radius: 8
                border.color: "#00d4ff"
                border.width: 1
            }
        }

        TextField {
            id: passField
            width: 320
            height: 48
            placeholderText: "Password"
            echoMode: TextInput.Password
            color: "#ffffff"
            background: Rectangle {
                color: "#ffffff20"
                radius: 8
                border.color: "#00d4ff"
                border.width: 1
            }
        }

        Rectangle {
            width: 320
            height: 48
            color: "#00d4ff"
            radius: 8

            Text {
                anchors.centerIn: parent
                text: "Login to AstraOS"
                color: "#000814"
                font.bold: true
                font.pixelSize: 16
            }

            MouseArea {
                anchors.fill: parent
                onClicked: sddm.login(userField.text, passField.text, sessionIndex)
            }
        }
    }

    // Version text
    Text {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 20
        text: "AstraOS v1.1.0 Nova"
        color: "#ffffff"
        opacity: 0.3
        font.pixelSize: 14
    }
}
