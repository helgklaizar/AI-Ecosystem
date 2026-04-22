---
title: Ai News Feed
description: Сбор и кластеризация AI новостей из Telegram (с UI радаром)
---

# AI News Feed (Telegram Radar)

Этот воркфлоу автоматически собирает новости из ваших Telegram-каналов (папка ИИ), фильтрует спам, дедуплицирует похожие посты с помощью LLM, извлекает ссылки на GitHub и открывает локальный интерфейс в стиле радар-ленты.

## Step 1: Запуск парсера и анализатора
Парсер выполнит сбор постов, а модель сгенерирует JSON-сводку.
// turbo
```bash
cd ~/AI/mvp/github-scout && source venv/bin/activate && python generate_news_feed.py
```

## Step 2: Запуск интерфейса
Запуск легковесного локального веб-сервера для UI и открытие вкладки браузера.
// turbo
```bash
cd ~/AI/mvp/github-scout/frontend && (python -m http.server 5174 &) && sleep 1 && open http://localhost:5174
```

> [!NOTE] 
> Чтобы обновить базу, вы можете воспользоваться кнопкой "Refresh Data" в UI. Она перезапросит JSON файл, но для генерации свежего датасета необходимо перезапустить этот воркфлоу, либо настроить `generate_news_feed.py` на запуск по cron.
