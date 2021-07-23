import sys
from concurrent.futures import ThreadPoolExecutor

from PySide6.QtCore import QAbstractListModel, Qt, QModelIndex, QObject, Slot, Property, Signal, QCoreApplication
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from crawler import run_crawler


class QDataListModel(QAbstractListModel):
    NAME = Qt.UserRole + 1000
    TIME = Qt.UserRole + 1001
    SIZE = Qt.UserRole + 1002
    HOT = Qt.UserRole + 1003
    MAGNET = Qt.UserRole + 1004

    def __init__(self, model):
        QAbstractListModel.__init__(self)
        self.model = model

    def rowCount(self, parent=None) -> int:
        return len(self.model)

    def roleNames(self):
        return {
            self.NAME:   b"name",
            self.TIME:   b"time",
            self.SIZE:   b"size",
            self.HOT:    b"hot",
            self.MAGNET: b"magnet",
        }

    def data(self, index: QModelIndex, role: int = None):
        index = index.row()
        row = self.model[index]

        return row[str(self.roleNames()[role], "utf-8")]


class MainWindow(QObject):
    def __init__(self):
        QObject.__init__(self)
        self._pool = ThreadPoolExecutor()
        self._search_result_list = QDataListModel([])

    def search_done(self, future):
        if future.result() is None:
            # 通知页面数据加载失败（忽视编辑器莫名其妙的警告）
            # noinspection PyUnresolvedReferences
            self.loadStateChanged.emit("loaded")
        else:
            self._search_result_list = QDataListModel(future.result())

            # 通知页面数据加载完成（忽视编辑器莫名其妙的警告）
            # noinspection PyUnresolvedReferences
            self.loadStateChanged.emit("loaded")

    @Slot(str, str)
    def search(self, key, search_terms):
        # 提交任务
        self._pool.submit(run_crawler, key, search_terms, "1", "").add_done_callback(self.search_done)
        # 通知页面处于加载状态（忽视编辑器莫名其妙的警告）
        # noinspection PyUnresolvedReferences
        self.loadStateChanged.emit("loading")

    loadStateChanged = Signal(str)

    # 绑定QML数据
    @Property(QObject, constant=False, notify=loadStateChanged)
    def search_result_list(self):
        return self._search_result_list

    @Slot(str)
    def download(self, magnet):
        print("调用迅雷下载")
        print(magnet)


def main():
    QCoreApplication.setAttribute(Qt.AA_UseSoftwareOpenGL)
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # 绑定视图
    backend = MainWindow()
    engine.rootContext().setContextProperty("backend", backend)
    engine.load("main.qml")

    if not engine.rootObjects():
        return -1

    return app.exec()


if __name__ == '__main__':
    sys.exit(main())
