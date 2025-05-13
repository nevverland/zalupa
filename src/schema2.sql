BEGIN TRANSACTION;
CREATE TABLE product_type (
    product_type_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    coefficient NUMERIC(10,2) NOT NULL
);
INSERT INTO product_type VALUES(1,'Тип продукции',0.0);
INSERT INTO product_type VALUES(2,'Декоративные обои',5.5);
INSERT INTO product_type VALUES(3,'Фотообои',7.540000000000000035);
INSERT INTO product_type VALUES(4,'Обои под покраску',3.25);
INSERT INTO product_type VALUES(5,'Стеклообои',2.5);
CREATE TABLE material_type (
    material_type_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    defect_rate NUMERIC(10,2) NOT NULL
);
INSERT INTO material_type VALUES(1,'Тип материала',0.0);
INSERT INTO material_type VALUES(2,'Бумага',0.006999999999999999278);
INSERT INTO material_type VALUES(3,'Краска',0.005000000000000000104);
INSERT INTO material_type VALUES(4,'Клей',0.001500000000000000031);
INSERT INTO material_type VALUES(5,'Дисперсия',0.002000000000000000041);
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
INSERT INTO material VALUES(1,'Наименование материала',1,0.0,0.0,0.0,0.0,'Единица измерения');
INSERT INTO material VALUES(2,'Бумага-основа с покрытием для флизелиновых обоев',2,1700.0,2500.0,1000.0,100.0,'рул');
INSERT INTO material VALUES(3,'Бумага-основа для флизелиновых обоев',2,1500.0,3000.0,1000.0,100.0,'рул');
INSERT INTO material VALUES(4,'Бумага обойная для вспененных виниловых обоев',2,1200.0,1500.0,1000.0,100.0,'рул');
INSERT INTO material VALUES(5,'Концентрат водоразбавляемой печатной краски',3,1500.0,550.0,500.0,200.0,'кг');
INSERT INTO material VALUES(6,'Перламутровый пигмент',3,3100.0,200.0,100.0,10.0,'кг');
INSERT INTO material VALUES(7,'Сухой клей на основе ПВС',4,360.0,700.0,500.0,50.0,'кг');
INSERT INTO material VALUES(8,'Флизелин',2,1600.0,2000.0,1000.0,140.0,'рул');
INSERT INTO material VALUES(9,'Стирол-акриловая дисперсия для производства обоев',5,14.0,2000.0,880.0,220.0,'л');
INSERT INTO material VALUES(10,'Стирол-акриловая дисперсия для гидрофобных покрытий',5,14.0,1200.0,880.0,220.0,'л');
INSERT INTO material VALUES(11,'Акрилат-винилацетатная дисперсия для производства бумаги',5,15.0,1000.0,660.0,220.0,'л');
INSERT INTO material VALUES(12,'Цветная пластизоль',3,650.0,200.0,100.0,5.0,'кг');
INSERT INTO material VALUES(13,'Дисперсия анионно-стабилизированного стирол-акрилового сополимера',4,170.0,800.0,660.0,220.0,'л');
INSERT INTO material VALUES(14,'Водорастворимая краска водная',3,500.0,400.0,300.0,25.0,'кг');
INSERT INTO material VALUES(15,'Диспергатор минеральных пигментов и наполнителей',5,16.0,400.0,360.0,120.0,'л');
INSERT INTO material VALUES(16,'Ассоциативный акриловый загуститель',5,16.0,400.0,360.0,120.0,'л');
INSERT INTO material VALUES(17,'Водорастворимая краска спецводная ',3,700.0,350.0,300.0,25.0,'кг');
INSERT INTO material VALUES(18,'Металлический пигмент',3,4100.0,250.0,100.0,15.0,'кг');
INSERT INTO material VALUES(19,'Акриловая дисперсия',5,14.0,1000.0,880.0,220.0,'л');
INSERT INTO material VALUES(20,'Бумага-основа для обоев марки АФ',2,1200.0,2000.0,1000.0,100.0,'рул');
INSERT INTO material VALUES(21,'Бумага с подложкой устойчивая к атмосферным воздействиям',2,3500.0,2000.0,800.0,50.0,'рул');
CREATE TABLE product (
    product_id SERIAL PRIMARY KEY,
    article VARCHAR(255) NOT NULL UNIQUE,
    product_type_id INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    min_partner_price NUMERIC(10,2) NOT NULL CHECK (min_partner_price >= 0),
    roll_width NUMERIC(10,2) NOT NULL CHECK (roll_width >= 0),
    FOREIGN KEY (product_type_id) REFERENCES product_type (product_type_id) ON DELETE RESTRICT
);
INSERT INTO product VALUES(1,'Артикул',1,'Наименование продукции',0.0,0.0);
INSERT INTO product VALUES(2,'1549922',2,'Обои из природного материала Традиционный принт светло-коричневые',16950.0,0.0);
INSERT INTO product VALUES(3,'2018556',3,'Фотообои флизелиновые Горы 500x270 см',15880.0,0.0);
INSERT INTO product VALUES(4,'3028272',4,'Обои под покраску флизелиновые Рельеф',11080.0,0.0);
INSERT INTO product VALUES(5,'4029272',5,'Стеклообои Рогожка белые',5898.0,1.0);
INSERT INTO product VALUES(6,'1028248',2,'Обои флизелиновые Эвелин светло-серые',15200.0,1.0);
INSERT INTO product VALUES(7,'2118827',3,'Фотообои флизелиновые 3D Лес и горы 300x280 см',12500.0,0.0);
INSERT INTO product VALUES(8,'3130981',4,'Обои под покраску флизелиновые цвет белый',4320.0,1.0);
INSERT INTO product VALUES(9,'4029784',5,'Стеклохолст',2998.0,1.0);
INSERT INTO product VALUES(10,'1658953',2,'Флизелиновые обои Принт Вензель серые',16200.0,0.0);
INSERT INTO product VALUES(11,'2026662',3,'Фотообои флизелиновые Узор 300x270 см',8780.0,0.0);
INSERT INTO product VALUES(12,'3159043',4,'Обои под покраску флизелиновые Кирпичная стена',15750.0,1.0);
INSERT INTO product VALUES(13,'4588376',5,'Стеклообои Средняя елка белые',5500.0,1.0);
INSERT INTO product VALUES(14,'1758375',2,'Обои бумажные Полосы цвет бежевый',13500.0,0.0);
INSERT INTO product VALUES(15,'2759324',3,'Фотообои Тропики 290x260 см',6980.0,0.0);
INSERT INTO product VALUES(16,'3118827',4,'Обои под покраску Рисунок Штукатурка белые',5890.0,1.0);
INSERT INTO product VALUES(17,'4559898',5,'Стеклообои Геометрические фигуры белые ',5369.0,1.0);
INSERT INTO product VALUES(18,'1259474',2,'Обои флизелиновые Лилия бежевые',9750.0,1.0);
INSERT INTO product VALUES(19,'2115947',3,'Фотообои флизелиновые 3D Пейзаж 300x280 см',16850.0,0.0);
INSERT INTO product VALUES(20,'3033136',4,'Обои под покраску флизелиновые однотонные цвет белый ',3390.0,1.0);
INSERT INTO product VALUES(21,'4028048',5,'Стеклохолст малярный Паутинка',1750.0,1.0);
CREATE TABLE product_material (
    product_id INTEGER NOT NULL,
    material_id INTEGER NOT NULL,
    required_quantity NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (product_id, material_id),
    FOREIGN KEY (product_id) REFERENCES product (product_id) ON DELETE RESTRICT,
    FOREIGN KEY (material_id) REFERENCES material (material_id) ON DELETE RESTRICT
);
INSERT INTO product_material VALUES(6,11,1.0);
INSERT INTO product_material VALUES(13,11,0.0);
INSERT INTO product_material VALUES(15,19,1.0);
INSERT INTO product_material VALUES(19,19,1.0);
INSERT INTO product_material VALUES(11,19,1.0);
INSERT INTO product_material VALUES(2,16,0.0);
INSERT INTO product_material VALUES(17,16,0.0);
INSERT INTO product_material VALUES(12,4,2.0);
INSERT INTO product_material VALUES(17,4,3.0);
INSERT INTO product_material VALUES(13,4,2.0);
INSERT INTO product_material VALUES(2,21,2.0);
INSERT INTO product_material VALUES(12,21,2.0);
INSERT INTO product_material VALUES(7,21,1.0);
INSERT INTO product_material VALUES(19,21,2.0);
INSERT INTO product_material VALUES(3,21,3.0);
INSERT INTO product_material VALUES(14,20,3.0);
INSERT INTO product_material VALUES(16,20,3.0);
INSERT INTO product_material VALUES(15,20,1.0);
INSERT INTO product_material VALUES(11,20,3.0);
INSERT INTO product_material VALUES(6,3,4.0);
INSERT INTO product_material VALUES(4,2,2.0);
INSERT INTO product_material VALUES(10,2,3.0);
INSERT INTO product_material VALUES(6,17,3.0);
INSERT INTO product_material VALUES(10,17,5.0);
INSERT INTO product_material VALUES(19,17,5.0);
INSERT INTO product_material VALUES(11,17,3.0);
INSERT INTO product_material VALUES(14,14,4.0);
INSERT INTO product_material VALUES(2,14,3.0);
INSERT INTO product_material VALUES(16,15,1.0);
INSERT INTO product_material VALUES(20,15,1.0);
INSERT INTO product_material VALUES(8,15,1.0);
INSERT INTO product_material VALUES(5,15,0.0);
INSERT INTO product_material VALUES(9,15,0.0);
INSERT INTO product_material VALUES(10,15,0.0);
INSERT INTO product_material VALUES(2,13,0.0);
INSERT INTO product_material VALUES(20,13,0.0);
INSERT INTO product_material VALUES(6,13,0.0);
INSERT INTO product_material VALUES(17,13,0.0);
INSERT INTO product_material VALUES(21,13,0.0);
INSERT INTO product_material VALUES(15,13,0.0);
INSERT INTO product_material VALUES(7,13,0.0);
INSERT INTO product_material VALUES(19,13,0.0);
INSERT INTO product_material VALUES(3,13,1.0);
INSERT INTO product_material VALUES(11,13,0.0);
INSERT INTO product_material VALUES(18,5,2.0);
INSERT INTO product_material VALUES(15,5,2.0);
INSERT INTO product_material VALUES(7,5,2.0);
INSERT INTO product_material VALUES(3,5,1.0);
INSERT INTO product_material VALUES(6,18,0.0);
INSERT INTO product_material VALUES(5,18,0.0);
INSERT INTO product_material VALUES(10,18,1.0);
INSERT INTO product_material VALUES(14,6,1.0);
INSERT INTO product_material VALUES(2,6,0.0);
INSERT INTO product_material VALUES(13,6,0.0);
INSERT INTO product_material VALUES(19,6,1.0);
INSERT INTO product_material VALUES(16,10,1.0);
INSERT INTO product_material VALUES(12,10,1.0);
INSERT INTO product_material VALUES(14,9,0.0);
INSERT INTO product_material VALUES(20,9,1.0);
INSERT INTO product_material VALUES(4,9,1.0);
INSERT INTO product_material VALUES(8,9,1.0);
INSERT INTO product_material VALUES(18,9,1.0);
INSERT INTO product_material VALUES(7,9,1.0);
INSERT INTO product_material VALUES(3,9,0.0);
INSERT INTO product_material VALUES(14,7,0.0);
INSERT INTO product_material VALUES(12,7,2.0);
INSERT INTO product_material VALUES(8,7,1.0);
INSERT INTO product_material VALUES(18,7,1.0);
INSERT INTO product_material VALUES(9,7,0.0);
INSERT INTO product_material VALUES(10,7,1.0);
INSERT INTO product_material VALUES(20,8,1.0);
INSERT INTO product_material VALUES(4,8,2.0);
INSERT INTO product_material VALUES(8,8,1.0);
INSERT INTO product_material VALUES(18,8,1.0);
INSERT INTO product_material VALUES(5,8,2.0);
INSERT INTO product_material VALUES(9,8,1.0);
INSERT INTO product_material VALUES(21,8,0.0);
INSERT INTO product_material VALUES(4,12,1.0);
INSERT INTO product_material VALUES(15,12,1.0);
INSERT INTO product_material VALUES(7,12,1.0);
INSERT INTO sqlite_sequence VALUES('product_type',5);
INSERT INTO sqlite_sequence VALUES('material_type',5);
INSERT INTO sqlite_sequence VALUES('material',21);
INSERT INTO sqlite_sequence VALUES('product',21);
COMMIT;