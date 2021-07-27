import os
import shutil

if __name__ == '__main__':
    # pip install nuitka
    # nuitka --mingw64 --standalone  --follow-imports --enable-plugin=pyside6 --include-qt-plugins=all --output-dir=build main.py

    # pyside6-rcc resource.qrc -o resource.py
    # pip3 install pyinstaller
    # 执行打包
    os.system('pyinstaller --noconsole --upx-dir build/ -y --specpath build --distpath build/dist/ --workpath build/build/ main.py')

    # 拷贝规则文件
    shutil.copytree('rule/', 'build/dist/main/rule', dirs_exist_ok = True)

    # 拷贝配置文件
    shutil.copytree('config/', 'build/dist/main/config', dirs_exist_ok = True)
