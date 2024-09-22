# Two shell scripts ( .sh ) for any Unix-like environment.

## Table of Contents
1. [Русская версия](#русская-версия)
2. [English version](#english-version)

---

# Русская версия

## 1. Первый скрипт делает
- Для переданного пути в виде аргумента проверить заполнение папки (далее условно /log), в процентах.
- Если папка занята более чем на X% (параметр X может варьироваться в качестве передаваемого параметра, можно взять за значение 70%), то нужно заархивировать файлы в /backup и удалить их из /log. Для архивирования можно использовать tar + gz.
- Перед архивацией произвести фильтрацию списка файлов. Архивируем N самых старых файлов (в зависимости от даты модификации).

## 2. Второй скрипт делает
- Генерирует тест-кейсы и проверяет корректность базового скрипта (фактически написать тесты), как минимум 4 теста. Во всех тест-кейсах папка /log должна весить минимум 0,5 GB.

---

# English version

## 1. The first script does
- For the passed path as an argument, check the occupancy of the folder (hereafter conventionally /log), as a percentage.
- If the folder is more than X% full (the parameter X can vary as a passed parameter, you can take 70% as a value), then you need to archive the files in /backup and remove them from /log. Tar + gz can be used for archiving.
- Before archiving, filter the list of files. Archive N oldest files (depending on the modification date).

## 2. The second script does
- Generates test cases and checks the correctness of the base script (actually write tests), at least 4 tests. In all test cases the /log folder must weigh at least 0.5 GB.
