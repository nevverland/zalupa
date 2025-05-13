PRAGMA foreign_keys = ON;

CREATE TABLE product_type (
    product_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    coefficient REAL NOT NULL
);

CREATE TABLE material_type (
    material_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    defect_rate REAL NOT NULL
);

CREATE TABLE material (
    material_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    material_type_id INTEGER NOT NULL,
    unit_price REAL NOT NULL,
    stock_quantity REAL NOT NULL,
    min_quantity REAL NOT NULL,
    pack_quantity REAL NOT NULL,
    unit TEXT NOT NULL,
    FOREIGN KEY (material_type_id) REFERENCES material_type (material_type_id) ON DELETE RESTRICT
);

CREATE TABLE product (
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
    article TEXT NOT NULL UNIQUE,
    product_type_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    min_partner_price REAL NOT NULL CHECK (min_partner_price >= 0),
    roll_width REAL NOT NULL CHECK (roll_width >= 0),
    FOREIGN KEY (product_type_id) REFERENCES product_type (product_type_id) ON DELETE RESTRICT
);

CREATE TABLE product_material (
    product_id INTEGER NOT NULL,
    material_id INTEGER NOT NULL,
    required_quantity REAL NOT NULL,
    PRIMARY KEY (product_id, material_id),
    FOREIGN KEY (product_id) REFERENCES product (product_id) ON DELETE RESTRICT,
    FOREIGN KEY (material_id) REFERENCES material (material_id) ON DELETE RESTRICT
);

CREATE TEMP TABLE temp_product_type (
    "Тип продукции" TEXT,
    "Коэффициент типа продукции" TEXT
);

CREATE TEMP TABLE temp_material_type (
    "Тип материала" TEXT,
    "Процент брака материала" TEXT
);

CREATE TEMP TABLE temp_materials (
    "Наименование материала" TEXT,
    "Тип материала" TEXT,
    "Цена единицы материала" TEXT,
    "Количество на складе" TEXT,
    "Минимальное количество" TEXT,
    "Количество в упаковке" TEXT,
    "Единица измерения" TEXT
);

CREATE TEMP TABLE temp_products (
    "Тип продукции" TEXT,
    "Наименование продукции" TEXT,
    "Артикул" TEXT,
    "Минимальная стоимость для партнера" TEXT,
    "Ширина рулона м" TEXT
);

CREATE TEMP TABLE temp_product_materials (
    "Продукция" TEXT,
    "Наименование материала" TEXT,
    "Необходимое количество материала" TEXT
);

