import QtQuick 6
import QtQuick.Window 2.5
import QtQuick.Controls 2.5
import QtQuick.Layouts 2.5
import QtQuick.Controls.Material 2.5

ApplicationWindow {
    id: main
    title: qsTr("磁力链接搜索")
    width: 1280
    height: 720
    minimumWidth: 960
    minimumHeight: 540
    visible: true
    visibility: Window.Windowed

    Material.theme: Material.Dark

    Connections {
        target : backend
        function onLoadStateChanged(state) {
            if (state === "error") {
                search.text = "搜索"
                search.enabled = true
                message_info.text = "加载错误，请稍后重试"
                message_timer.start()
            } else if (state === "loading") {
                search.text = "正在加载数据"
                search.enabled = false
            } else if (state === "loaded") {
                search.text = "搜索"
                search.enabled = true
            }
        }
    }

    property variant list_pro: true

    ListModel {
        id: website_list_pro
        ListElement {
            key: "btsow"
            value: "BTSOW(优)"
        }
        ListElement {
            key: "btsow_proxy"
            value: "BTSOW(优)(代理)"
        }
    }

    ListModel {
        id: website_list
        ListElement {
            key: "bt113"
            value: "磁力多"
        }
        ListElement {
            key: "btgg"
            value: "BTGG"
        }
        ListElement {
            key: "btsow"
            value: "BTSOW(优)"
        }
        ListElement {
            key: "btsow_proxy"
            value: "BTSOW(优)(代理)"
        }
        ListElement {
            key: "cili"
            value: "无极磁链"
        }
        ListElement {
            key: "cursor"
            value: "吃力网"
        }
        ListElement {
            key: "sofan"
            value: "搜番"
        }
    }

    Popup {
        id: qr_code_popup
        anchors.centerIn: parent
        width: 360
        height: 360
        Image {
            id: qr_code
            anchors.fill: parent
            cache: false
        }
    }

    property int message_show: 3

    Popup {
        id: message_popup
        x: (main.width-width)/2
        y: 0
        width: 200
        height: 36
        enter: Transition {
            PropertyAnimation {
                property: "y"
                to: 36
                duration: 200
            }
        }
        exit: Transition {
            PropertyAnimation {
                property: "y"
                to: 0
                duration: 200
            }
        }
        Label {
            id: message_info
            anchors.centerIn: parent
            font.pointSize: 10
            text: qsTr("消息提示")
        }
    }

    Timer {
        id: message_timer
        interval: 1000
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (message_show == 3) {
                message_popup.open()
            }
            message_show -= 1
            if (message_show == 0) {
                message_show = 3
                message_timer.stop()
                message_popup.close()
            }
        }
    }

    ApplicationWindow {
        id: proxy_window
        title: qsTr("代理设置")
        width: 400
        height: 200
        minimumWidth: 400
        minimumHeight: 200
        flags: Qt.Dialog
        modality: Qt.WindowModal

        Material.theme: Material.Dark
        visible: false

        Component.onCompleted: {
            console.log("请求后台数据")
        }

        GridLayout {
            columns: 2
            anchors.fill: parent
            anchors.margins: 20
            rowSpacing: 10
            columnSpacing: 20
            Label {
                text: qsTr("代理服务地址")
            }
            TextField {
                id: proxy_server
                Layout.fillWidth: true
                hoverEnabled: false
                selectByMouse: true
            }

            Label {
                text: qsTr("代理服务端口号")
            }
            TextField {
                id: proxy_port
                Layout.fillWidth: true
                hoverEnabled: false
                selectByMouse: true
                validator: IntValidator {
                    bottom: 0
                    top: 65535
                }
            }
            Item {
                Layout.columnSpan: 2
                Layout.fillWidth: true
                implicitHeight: 10
                Label {
                    id: test_result
                    text: ""
                    anchors.centerIn: parent
                }
            }
            Item {
                Layout.columnSpan: 2
                Layout.fillWidth: true
                implicitHeight: 40
                Row {
                    anchors.centerIn: parent
                    spacing: 20
                    Button {
                        id: test_proxy
                        width: 120
                        height: 40
                        text: qsTr("测试代理")
                        onClicked: {
                            let state = backend.test_proxy(proxy_server.text, proxy_port.text)
                            if (state === "success") {
                                test_result.text = "测试成功, 代理设置正确"
                                test_result.color = "#4CAF50"
                            } else if (state === "failed") {
                                test_result.text = "测试失败, 代理设置不正确"
                                test_result.color = "#F44336"
                            }
                        }
                    }
                    Button {
                        id: save_proxy
                        width: 60
                        height: 40
                        text: qsTr("保存")
                        onClicked: {
                            proxy_window.close()
                        }
                    }
                    Button {
                        id: save_proxy1
                        width: 60
                        height: 40
                        text: qsTr("取消")
                        onClicked: {
                            proxy_window.close()
                        }
                    }
                }
            }
        }
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("磁力链接搜索")
            MenuItem {
                text: qsTr("加载规则文件")
                onTriggered: console.log("加载规则文件")
            }
            MenuItem {
                id: list_pro_ctrl
                text: qsTr("只加载优质代理")
                onTriggered: {
                    if (list_pro) {
                        website.model = website_list_pro
                        list_pro_ctrl.text = "加载全部代理"
                    } else {
                        website.model = website_list
                        list_pro_ctrl.text = "只加载优质代理"
                    }
                    list_pro = !list_pro
                }
            }
            MenuItem {
                text: "退出"
                onTriggered: Qt.quit()
            }
        }
        Menu {
            title: qsTr("设置")
            MenuItem {
                text: qsTr("代理服务设置")
                onTriggered: {
                    proxy_window.visible = true
                }
            }
            MenuItem {
                text: qsTr("编辑搜索规则")
                onTriggered: {

                }
            }
            MenuItem {
                text: qsTr("搜索设置")
                onTriggered: {

                }
            }
        }
        Menu {
            title: qsTr("帮助")
            MenuItem {
                text: qsTr("使用手册")
                onTriggered: console.log("打开网页")
            }
            MenuItem {
                text: qsTr("关于")
                onTriggered: console.log("检查更新等")
            }
        }
    }

    Item {
        id: search_info
        height: 80
        ComboBox {
            id: website
            x: 40
            y: 20
            width: 200
            model: website_list
            textRole: "value"
            valueRole: "key"
        }
        TextField {
            id: search_terms
            text: qsTr("龙珠")
            width: 520
            anchors {
                top: website.top
                left: website.right
                leftMargin: 20
            }
            hoverEnabled: false
            selectByMouse: true
            placeholderText: qsTr("搜索词")
            font.pointSize: 12
        }
        Button {
            id: search
            width: 120
            anchors {
                top: search_terms.top
                left: search_terms.right
                leftMargin: 20
            }
            text: qsTr("搜索")
            onClicked: {
                backend.search(website.currentValue, search_terms.text)
            }
        }
    }

    ListView {
        id: search_result
        anchors {
            top: search_info.bottom
            right: parent.right
            bottom: parent.bottom
            left: parent.left
            topMargin: 20
            rightMargin: 40
            bottomMargin: 20
            leftMargin: 40
        }
        spacing: 20
        clip: true
        ScrollBar.vertical: ScrollBar {}
        boundsBehavior: Flickable.StopAtBounds

        model: backend.search_result_list

        delegate: Item {
            width: main.width - 80
            height: 80
            Column {
                id: info
                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
                Label {
                    text: model.name
                    font.pixelSize: 16
                    bottomPadding: 20
                }
                Row {
                    spacing: 20
                    Label {
                        text: qsTr("热度: ") + model.hot
                        color: "gray"
                        font.pixelSize: 12
                    }
                    Label {
                        text: qsTr("文件大小: ") + model.size
                        color: "gray"
                        font.pixelSize: 12
                    }
                    Label {
                        text: qsTr("创建时间: ") + model.time
                        color: "gray"
                        font.pixelSize: 12
                    }
                }
            }

            Row {
                anchors {
                    right: parent.right
                    rightMargin: 40
                    verticalCenter: parent.verticalCenter
                }
                spacing: 20
                Button {
                    id: qrcode
                    height: 40
                    text: qsTr("二维码")
                    onClicked: {
                        qr_code.source = backend.magnet_qr_code(model.magnet)
                        qr_code_popup.open()
                    }
                }
                Button {
                    id: download
                    height: 40
                    text: qsTr("迅雷下载")
                    onClicked: {
                        backend.download(model.magnet)
                    }
                }
                Button {
                    id: copy_url
                    height: 40
                    text: qsTr("复制链接")
                    onClicked: {
                        backend.copy_to_clipboard(model.magnet)
                        message_info.text = "复制成功"
                        message_timer.start()
                    }
                }
            }
        }
    }
}