import os
import shutil


def build_dev():
    # 执行打包
    os.system('pyinstaller --upx-dir build/ -y --specpath build --distpath build/debug/ --workpath build/cache/ main.py')

    # 拷贝规则文件
    shutil.copytree('rule/', 'build/debug/main/rule', dirs_exist_ok = True)

    # 拷贝配置文件
    shutil.copytree('config/', 'build/debug/main/config', dirs_exist_ok = True)


def build_prod():
    # 使用resource.qrc方式加载
    os.system('pyside6-rcc resource.qrc -o resource.py')
    # 替换main.py的内容
    main_info = open('main.py', 'r+', encoding = 'utf-8')
    infos = main_info.readlines()
    main_info.seek(0, 0)
    for line in infos:
        line_new = line.replace("engine.load('main.qml')", "engine.load('qrc:/main.qml')")
        main_info.write(line_new)
    main_info.close()

    # 执行打包
    os.system('pyinstaller --noconsole --upx-dir build/ -y --specpath build --distpath build/release/ --workpath build/cache/ main.py')

    # 拷贝规则文件
    shutil.copytree('rule/', 'build/release/main/rule', dirs_exist_ok = True)

    # 拷贝配置文件
    shutil.copy2('config.json', 'build/release/main/')


if __name__ == '__main__':
    # pip install nuitka
    # nuitka --mingw64 --standalone  --follow-imports --enable-plugin=pyside6 --include-qt-plugins=all --output-dir=build main.py
    # pip install pyinstaller
    build_prod()
