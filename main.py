import sys

from PySide6.QtCore import QObject, Slot
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine


# Main Window Class
class MainWindow(QObject):
    def __init__(self):
        QObject.__init__(self)

    @Slot(str, str)
    def search(self, url, keyword):
        print(url)
        print(keyword)
        print("执行搜索")


if __name__ == '__main__':
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # 主窗口
    main = MainWindow()
    engine.rootContext().setContextProperty("backend", main)

    engine.load("main.qml")
    app.exec()
