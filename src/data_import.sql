-- Команды для импорта данных (выполняются в командной строке SQLite):
-- .mode csv
-- .separator ";"
-- .import 'W:/ДЭ/de-6/Войтов НЕ/src/res/product_type_import.csv' temp_product_type
-- .import 'W:/ДЭ/de-6/Войтов НЕ/src/res/material_type_import.csv' temp_material_type
-- .import 'W:/ДЭ/de-6/Войтов НЕ/src/res/materials_import.csv' temp_materials
-- .import 'W:/ДЭ/de-6/Войтов НЕ/src/res/products_import.csv' temp_products
-- .import 'W:/ДЭ/de-6/Войтов НЕ/src/res/product_materials_import.csv' temp_product_materials


INSERT INTO product_type (name, coefficient)
SELECT
    "Тип продукции",
    REPLACE("Коэффициент типа продукции", ',', '.') * 1.0
FROM temp_product_type;

INSERT INTO material_type (name, defect_rate)
SELECT
    "Тип материала",
    REPLACE(REPLACE("Процент брака материала", '%', ''), ',', '.') * 0.01
FROM temp_material_type;

INSERT INTO material (name, material_type_id, unit_price, stock_quantity, min_quantity, pack_quantity, unit)
SELECT
    m."Наименование материала",
    mt.material_type_id,
    REPLACE(m."Цена единицы материала", ' ', '') * 1.0,
    REPLACE(m."Количество на складе", ' ', '') * 1.0,
    REPLACE(m."Минимальное количество", ' ', '') * 1.0,
    REPLACE(m."Количество в упаковке", ' ', '') * 1.0,
    m."Единица измерения"
FROM temp_materials m
JOIN material_type mt ON m."Тип материала" = mt.name;

INSERT INTO product (article, product_type_id, name, min_partner_price, roll_width)
SELECT
    p."Артикул",
    pt.product_type_id,
    p."Наименование продукции",
    REPLACE(p."Минимальная стоимость для партнера", ' ', '') * 1.0,
    REPLACE(p."Ширина рулона м", ' ', '') * 1.0
FROM temp_products p
JOIN product_type pt ON p."Тип продукции" = pt.name;

INSERT INTO product_material (product_id, material_id, required_quantity)
SELECT
    p.product_id,
    m.material_id,
    REPLACE(pm."Необходимое количество материала", ' ', '') * 1.0
FROM temp_product_materials pm
JOIN product p ON pm."Продукция" = p.name
JOIN material m ON pm."Наименование материала" = m.name;

DROP TABLE temp_product_type;
DROP TABLE temp_material_type;
DROP TABLE temp_materials;
DROP TABLE temp_products;
DROP TABLE temp_product_materials;