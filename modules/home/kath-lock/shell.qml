import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pam
import Quickshell.Wayland

ShellRoot {
    id: shell

    property string assets: Quickshell.env("KATH_ASSETS")
    property int notificationCount: -1
    property bool authenticating: false

    function authenticate(password) {
        if (password.length > 0 && pam.responseRequired && !authenticating) {
            authenticating = true;
            pam.respond(password);
        }
    }

    KathConfig {
        id: kathConfig
    }

    FontLoader {
        id: kathFont
        source: `file://${shell.assets}/Fonts/pixelon.regular.ttf`
    }

    QtObject {
        id: sddmAdapter

        property bool canPowerOff: false
        property bool canReboot: false
        property bool canSuspend: false
        property bool canHibernate: false

        signal loginSucceeded
        signal loginFailed

        function login(username, password, session) {
            shell.authenticate(password);
        }
    }

    Process {
        id: notificationProcess
        property bool requestStarted: false

        running: true
        command: ["swaync-client", "-c"]
        stdout: SplitParser {
            onRead: function(data) {
                const count = parseInt(data.trim(), 10);
                shell.notificationCount = isNaN(count) ? -1 : count;
            }
        }
        onStarted: requestStarted = true
        onRunningChanged: {
            if (!running) {
                if (!requestStarted)
                    shell.notificationCount = -1;
                requestStarted = false;
            }
        }
        onExited: function(exitCode, exitStatus) {
            if (exitCode !== 0)
                shell.notificationCount = -1;
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            notificationProcess.requestStarted = false;
            notificationProcess.exec(["swaync-client", "-c"]);
        }
    }

    PamContext {
        id: pam
        config: "login"

        Component.onCompleted: {
            if (!start())
                sddmAdapter.loginFailed();
        }

        onCompleted: function(result) {
            shell.authenticating = false;
            if (result === PamResult.Success) {
                sddmAdapter.loginSucceeded();
                sessionLock.locked = false;
                Qt.quit();
                return;
            }

            sddmAdapter.loginFailed();
            if (result !== PamResult.MaxTries)
                start();
        }
    }

    WlSessionLock {
        id: sessionLock
        locked: Quickshell.env("KATH_LOCK_TEST") !== "1"

        WlSessionLockSurface {
            color: "#1e1e2e"

            Main {
                anchors.fill: parent
                config: kathConfig.config
                sddm: sddmAdapter
            }

            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 32
                visible: shell.notificationCount > 0
                width: notificationText.implicitWidth + 32
                height: 48
                radius: 20
                color: "#cc181825"
                border.color: "#313244"
                border.width: 1
                z: 20

                Text {
                    id: notificationText
                    anchors.centerIn: parent
                    text: `${shell.notificationCount} notifications`
                    color: "#cba6f7"
                    font.family: kathFont.name
                    font.pointSize: 12
                }
            }
        }
    }
}
