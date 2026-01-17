# SQL_Logistics_Task
Решение ДЗ 2 курса Индустриальная разработка ПО  

"Представьте что вы создаете базу данных для одной из предметных областей (Мессенджер, MMORPG, Компания, занимающаяся грузоперевозками).  
Попробуйте спроектировать базу данных под выбранную предметную область соблюдая принципы нормальных форм включая  НФБК."  

**В качестве предметной области выбрана Компания, занимающаяся грузоперевозками**

Чтобы вывести все внешние ключи (посмотреть зависимости таблиц) можно ввести команду:  

```sql
SELECT
    tc.table_schema,
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM
    information_schema.table_constraints AS tc
    JOIN information_schema.key_column_usage AS kcu
        ON tc.constraint_name = kcu.constraint_name
    JOIN information_schema.constraint_column_usage AS ccu
        ON ccu.constraint_name = tc.constraint_name
WHERE
    tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_schema = 'public'
ORDER BY
    tc.table_name;
```
