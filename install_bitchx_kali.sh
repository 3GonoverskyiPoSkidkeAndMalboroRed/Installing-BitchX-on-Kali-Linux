#!/bin/bash

# Скрипт установки BitchX на Kali Linux
# Основан на официальных инструкциях: https://github.com/lgblgblgb/BitchX/blob/master/INSTALL

set -e  # Остановка при ошибке

echo "=========================================="
echo "Установка BitchX на Kali Linux"
echo "=========================================="

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Проверка прав root
if [ "$EUID" -eq 0 ]; then 
    INSTALL_PREFIX="/usr/local"
    echo -e "${GREEN}Установка будет выполнена в системную директорию: $INSTALL_PREFIX${NC}"
else
    INSTALL_PREFIX="$HOME"
    echo -e "${YELLOW}Установка будет выполнена в домашнюю директорию: $INSTALL_PREFIX${NC}"
fi

# Шаг 1: Обновление списка пакетов
echo -e "\n${GREEN}[1/6] Обновление списка пакетов...${NC}"
sudo apt update

# Шаг 2: Установка зависимостей
echo -e "\n${GREEN}[2/6] Установка зависимостей...${NC}"
sudo apt install -y \
    build-essential \
    libncurses5-dev \
    ncurses-dev \
    git \
    autoconf \
    automake \
    libtool \
    pkg-config

# Шаг 3: Клонирование репозитория
echo -e "\n${GREEN}[3/6] Клонирование репозитория BitchX...${NC}"
BUILD_DIR="$HOME/bitchx-build"
if [ -d "$BUILD_DIR" ]; then
    echo -e "${YELLOW}Директория $BUILD_DIR уже существует. Удаление...${NC}"
    rm -rf "$BUILD_DIR"
fi

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

if [ -d "BitchX" ]; then
    echo -e "${YELLOW}Репозиторий уже клонирован. Обновление...${NC}"
    cd BitchX
    git pull
else
    git clone https://github.com/lgblgblgb/BitchX.git
    cd BitchX
fi

# Шаг 4: Настройка конфигурации
echo -e "\n${GREEN}[4/6] Настройка конфигурации...${NC}"
./configure --prefix="$INSTALL_PREFIX" --with-plugins

# Шаг 5: Компиляция
echo -e "\n${GREEN}[5/6] Компиляция BitchX (это может занять некоторое время)...${NC}"
make

# Шаг 6: Установка
echo -e "\n${GREEN}[6/6] Установка BitchX...${NC}"
if [ "$EUID" -eq 0 ]; then
    make install
else
    sudo make install
fi

# Проверка установки
echo -e "\n${GREEN}Проверка установки...${NC}"
if command -v BitchX &> /dev/null || [ -f "$INSTALL_PREFIX/bin/BitchX" ]; then
    echo -e "${GREEN}✅ BitchX успешно установлен!${NC}"
    echo -e "\n${GREEN}Запуск:${NC}"
    if [ "$EUID" -eq 0 ]; then
        echo "  BitchX"
    else
        echo "  $INSTALL_PREFIX/bin/BitchX"
        echo -e "\n${YELLOW}Или добавьте в PATH:${NC}"
        echo "  export PATH=\"$INSTALL_PREFIX/bin:\$PATH\""
        echo -e "\n${YELLOW}Для постоянного добавления в PATH добавьте в ~/.bashrc:${NC}"
        echo "  echo 'export PATH=\"$INSTALL_PREFIX/bin:\$PATH\"' >> ~/.bashrc"
    fi
else
    echo -e "${RED}❌ Ошибка: BitchX не найден после установки${NC}"
    exit 1
fi

echo -e "\n${GREEN}=========================================="
echo "Установка завершена!"
echo "==========================================${NC}"

