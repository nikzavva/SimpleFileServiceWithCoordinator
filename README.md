# SimpleFileServiceWithCoordinator

## Описание
iOS-приложение с Coordinator-паттерном и файловым хранилищем.

## Особенности
- **Архитектура**: 
  - Чистый Coordinator-паттерн с поддержкой дочерних координаторов
  - Разделение на модули: Coordinators, Services, Protocols
- **Навигация**:
  - Иерархические переходы между контроллерами
  - Передача данных между координаторами
- **Технологии**:
  - SnapKit для верстки UI
  - FileManager для работы с файлами
  - UserDefaults для временного хранения данных

## Установка
1. Клонируйте репозиторий
2. Откройте `SimpleFileServiceWithCoordinator.xcodeproj` в Xcode
3. Запустите проект (Cmd+R)