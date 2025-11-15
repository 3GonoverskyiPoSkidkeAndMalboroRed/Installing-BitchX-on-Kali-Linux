# Установка BitchX на Kali Linux

BitchX - это популярный IRC клиент для терминала. Данная инструкция описывает процесс установки BitchX на Kali Linux из исходных кодов.

## Быстрая установка (автоматическая)

Используйте готовый скрипт для автоматической установки:

```bash
./scripts/install_bitchx_kali.sh
```

## Ручная установка

### Шаг 1: Установка зависимостей

Kali Linux основан на Debian, поэтому используем пакет `libncurses5-dev`:

```bash
sudo apt update
sudo apt install -y build-essential libncurses5-dev ncurses-dev git autoconf automake libtool pkg-config
```

### Шаг 2: Клонирование репозитория

```bash
cd ~
git clone https://github.com/lgblgblgb/BitchX.git
cd BitchX
```

### Шаг 3: Настройка конфигурации

Для установки в системную директорию (требуются права root):
```bash
./configure --prefix=/usr/local --with-plugins
```

Для установки в домашнюю директорию (без прав root):
```bash
./configure --prefix=$HOME --with-plugins
```

**Опции configure:**
- `--prefix` - директория установки (по умолчанию `/usr/local`)
- `--with-plugins` - включить поддержку плагинов (рекомендуется)
- `--with-tcl` - включить поддержку Tcl скриптов (опционально, большинству пользователей не нужно)

### Шаг 4: Компиляция

```bash
make
```

### Шаг 5: Установка

Для системной установки:
```bash
sudo make install
```

Для установки в домашнюю директорию:
```bash
make install
```

### Шаг 6: Добавление в PATH (если установлено в домашнюю директорию)

Добавьте в `~/.bashrc`:
```bash
export PATH="$HOME/bin:$PATH"
```

Затем перезагрузите конфигурацию:
```bash
source ~/.bashrc
```

## Запуск BitchX

После установки запустите:
```bash
BitchX
```

Или, если установлено в домашнюю директорию:
```bash
~/bin/BitchX
```

## Решение проблем

### Ошибка: "Cannot find terminfo or termcap"

Установите пакет ncurses:
```bash
sudo apt install -y libncurses5-dev
```

### Ошибка прав доступа при установке

Если вы не root и пытаетесь установить в системную директорию, используйте:
```bash
./configure --prefix=$HOME --with-plugins
```

### Проблемы с компиляцией

1. Убедитесь, что установлены все зависимости:
```bash
sudo apt install -y build-essential libncurses5-dev git autoconf automake libtool pkg-config
```

2. Проверьте вывод `configure` на наличие ошибок

## Дополнительная информация

- Официальный репозиторий: https://github.com/lgblgblgb/BitchX
- Инструкции по установке: https://github.com/lgblgblgb/BitchX/blob/master/INSTALL
- Скрипты для BitchX: http://scripts.bitchx.org
- FAQ: http://wiki.bitchx.org/faq:start

## Примечания

- Некоторые функции работают только с определенными IRC серверами (например, IRCUMODE, /4OP)
- Серверы UnderNet, DalNet, NewNet могут не поддерживать некоторые режимы пользователя
- Плагины могут вызывать проблемы из-за ошибок в самих плагинах

