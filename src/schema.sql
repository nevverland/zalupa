CREATE TABLE product_type (
    product_type_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    coefficient NUMERIC(10,2) NOT NULL
);

CREATE TABLE material_type (
    material_type_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    defect_rate NUMERIC(10,2) NOT NULL
);
CREATE TABLE material (
    material_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    material_type_id INTEGER NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    stock_quantity NUMERIC(10,2) NOT NULL,
    min_quantity NUMERIC(10,2) NOT NULL,
    pack_quantity NUMERIC(10,2) NOT NULL,
    unit VARCHAR(255) NOT NULL,
    FOREIGN KEY (material_type_id) REFERENCES material_type (material_type_id) ON DELETE RESTRICT
);
CREATE TABLE product (
    product_id SERIAL PRIMARY KEY,
    article VARCHAR(255) NOT NULL UNIQUE,
    product_type_id INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    min_partner_price NUMERIC(10,2) NOT NULL CHECK (min_partner_price >= 0),
    roll_width NUMERIC(10,2) NOT NULL CHECK (roll_width >= 0),
    FOREIGN KEY (product_type_id) REFERENCES product_type (product_type_id) ON DELETE RESTRICT
);
CREATE TABLE product_material (
    product_id INTEGER NOT NULL,
    material_id INTEGER NOT NULL,
    required_quantity NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (product_id, material_id),
    FOREIGN KEY (product_id) REFERENCES product (product_id) ON DELETE RESTRICT,
    FOREIGN KEY (material_id) REFERENCES material (material_id) ON DELETE RESTRICT
);