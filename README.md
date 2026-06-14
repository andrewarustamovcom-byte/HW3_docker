# ДЗ №3 — Docker & Bash
## Тема: Статистика матчей Dota 2

Проект состоит из двух Docker-контейнеров. Первый генерирует CSV-файл с данными о матчах Dota 2, второй читает этот файл и строит HTML-отчёт со статистикой. Оба контейнера работают с файлами через общую папку `data/` на хосте.

***

## Как запустить

### Шаг 1 — Дать права на запуск скрипта

```bash
chmod +x run.sh
```

### Шаг 2 — Собрать образы

```bash
./run.sh build_generator
./run.sh build_reporter
```

### Шаг 3 — Сгенерировать данные

```bash
./run.sh run_generator
```

После этого в папке `data/` появится файл `data.csv` — 100 строк с данными о матчах Dota 2 (герои, роли, kills, deaths, assists, gpm, xpm, hero_damage, win).

### Шаг 4 — Построить HTML-отчёт

```bash
./run.sh run_reporter
```

После этого в папке `data/` появится файл `report.html` — таблицы со статистикой по каждой колонке.

***

## Все команды run.sh

| Команда | Что делает |
|---|---|
| `./run.sh build_generator` | Собирает Docker-образ генератора |
| `./run.sh run_generator` | Запускает генератор → создаёт `data/data.csv` |
| `./run.sh create_local_data` | Создаёт `local_data/data.csv` локально без Docker |
| `./run.sh build_reporter` | Собирает Docker-образ аналитика |
| `./run.sh run_reporter` | Запускает аналитик → создаёт `data/report.html` |
| `./run.sh structure` | Показывает дерево файлов проекта |
| `./run.sh clear_data` | Удаляет все `.csv` и `.html` из `data/` |
| `./run.sh inside_generator` | Запускает генератор и показывает содержимое `/data` изнутри контейнера |
| `./run.sh inside_reporter` | Показывает содержимое `/data` изнутри контейнера аналитика |
| `./run.sh report_server` | Запускает nginx-сервер для просмотра отчёта в браузере |

***

## Данные в CSV

Генератор создаёт 100 строк со следующими колонками:

| Колонка | Тип | Описание |
|---|---|---|
| `hero` | текст | Название героя (Pudge, Invoker, ...) |
| `role` | текст | Роль (Carry, Mid, Offlane, Soft Support, Hard Support) |
| `kills` | число | Количество убийств (0–25) |
| `deaths` | число | Количество смертей (0–15) |
| `assists` | число | Количество ассистов (0–30) |
| `gpm` | число | Gold per minute (250–850) |
| `xpm` | число | Experience per minute (200–900) |
| `hero_damage` | число | Урон по героям (3000–60000) |
| `win` | текст | Победа (True / False) |