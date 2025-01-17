# Changelog
## [Unreleased]
### Added
* Добавлен fallback на WebView с поддержкой SSL-пиннинга в случае неудачной попытки запуска партнерской авторизации через приложение Тинькофф
* Добавлен дополнительный домен для запуска партнерской авторизации через приложения Тинькофф
### Changed
* Изменена схема диплинков
* Изменено название кнопки авторизации по-умолчанию
* Изменена икнока TID в компактной кнопке
* Обновлен экран UI приложения Example для возможности гибкого предпросмотра дизайна

## [1.2.1] - 2022-05-18
### Changed
* Обновлены версии зависимостей окружения
### Fixed
* Фикс сборки при подключении через SPM

## [1.2.0] - 2022-07-26
### Added
* Добавлены альтернативные цветовые схемы
* Добавлена иконка в кнопку без возможности конфигурации
* Добавлено отображение дополнительной информации на кнопке (н-р, информации о cashback)
* Добавлена круглая кнопка с логотипом с 3 цветовыми стилями
### Changed
* Расширены возможности кастомизации кнопки по размеру, форме и типографии
* Обновлен Example для демонстрации возможных конфигураций
* Сделан переход на V1 версию workflows

## [1.1.0] - 2021-07-29
### Added
* Добавлена абстрактная фабрика `ITinkoffIDFactory`
* Добавлен класс `DebugTinkoffIDFactory`, реализующий `ITinkoffIDFactory`
* Добавлен класс `DebugTinkoffID`, реализующий `ITinkoffID`
* Добавлено приложение для отладки интеграции

## [1.0.0] - 2021-02-18
### Added
* Реализована первая версия SDK
* Добавлены модульные тесты
* Добавлена поддержка `Cocoapods` и `SPM`
