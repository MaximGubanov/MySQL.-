/*КУРСОВОЙ ПРОЕКТ: Основы реляционных баз данных. MySQL

Выполнил: Губанов М.В.

Требования к курсовому проекту:
1. Составить общее текстовое описание БД и решаемых ею задач;
2. Минимальное количество таблиц - 10;
3. Скрипты создания структуры БД (с первичными ключами, индексами, внешними ключами);
4. создать ERDiagram для БД;
5. Скрипты наполнения БД данными;
6. Скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы);
7. Представления (минимум 2);
8. Хранимые процедуры / триггеры;*/

-- 1. ОПИСАНИЕ БД
-- БД содержит в себе данные о комплектующих системы "Умный дом".
-- В таблицах есть индексы, внешние ключи, диаграмма приложена к файлу в архиве.
 
-- 2. СОЗДАНИЕ СТРУКТУРЫ БД
	DROP DATABASE IF EXISTS smarthome;
	CREATE DATABASE smarthome;
	USE smarthome;
	
	-- ТАБЛИЦА №1: Категории товаров (датчики, контролеры, кондиционеры, очистители...)
		DROP TABLE IF EXISTS `category`;
		CREATE TABLE `category` (
		`id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
		`name_categoty` VARCHAR(50) UNIQUE
		) COMMENT = 'Категории комплектующих smarthome';
			
			INSERT INTO `category` (`name_categoty`) 
			VALUES 
				('Котролер (ПЛК)'),
				('Датчик движения'),
				('Датчик света'),
				('Датчик дыма'),
				('Датчик открытия'),
				('Датчик потребления'),
				('Очиститель воздуха'),
				('Умная розетка'),
				('Умный выключатель'),
				('Сенсорная панель');
	
	-- ТАБЛИЦА №2: Страна-производитель
		DROP TABLE IF EXISTS `manufacturing_firm`;
		CREATE TABLE `manufacturing_firm` (
		`id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
		`country_name` VARCHAR(50) NOT NULL UNIQUE
		) COMMENT = 'Страна-производитель';
			
			INSERT INTO `manufacturing_firm` (`country_name`) 
			VALUES 
				('Россия'),
				('КИтай'),
				('Тайвань'),
				('Япония'),
				('США'),
				('Германия'),
				('Южная Корея');
			
		-- ТАБЛИЦА №3: Фирма
		DROP TABLE IF EXISTS `company_name`;
		CREATE TABLE `company_name` (
		`id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
		`name` VARCHAR(50) NOT NULL UNIQUE
		) COMMENT = 'Фирма';
			
			INSERT INTO `company_name` (`name`) 
			VALUES 
				('Xiaomi'),
				('Digma'),
				('HIPER'),
				('TP-Link'),
				('Эра'),
				('Philio'),
				('Триколор'),
				('Даджет'),
				('Redmond'),
				('Rexant');
			
		-- ТАБЛИЦА №4: Готовый комплект (3 вида: комфорт, защита, экономный)
		DROP TABLE IF EXISTS `sets`;
		CREATE TABLE `sets` (
		`id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
		`name_set` enum('Комфорт', 'Защита', 'Экономия') NOT NULL,
		`description_set` TEXT DEFAULT NULL,
		`price` DECIMAL (10,2) DEFAULT 0 -- цена на комплет суммируется из комплектующих
		) COMMENT = 'Готовые комплекты';
	
			INSERT INTO `sets` (`name_set`, `description_set`) 
			VALUES 
				('Комфорт', 'Набор датчиков и систем упревления для вашего комфорта'),
				('Защита', 'Набор датчиков для защиты вашего дома'),
				('Экономия', 'Набор датчиков для экономии в вашем доме');
	
	-- ТАБЛИЦА №5: Комплетующие системы smarthome (товары)
		DROP TABLE IF EXISTS `products`;
		CREATE TABLE `products` (
		`id` BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
		`name` VARCHAR(100) NOT NULL,
		`manufacturing_firm_id` INT UNSIGNED NOT NULL,
		`company_name_id` INT UNSIGNED NOT NULL,
		`description` TEXT DEFAULT NULL,
		`price` DECIMAL (10,2) DEFAULT 0,
		`category_id` INT UNSIGNED NOT NULL,
		`sets_id` INT NOT NULL,
		KEY index_name_id (`id`, `name`),
		CONSTRAINT `fk_id_manufacturing_firm` FOREIGN KEY (`manufacturing_firm_id`) REFERENCES `manufacturing_firm` (`id`),
		CONSTRAINT `fk_category_id` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`),
		CONSTRAINT `fk_company_name_id` FOREIGN KEY (`company_name_id`) REFERENCES `company_name` (`id`),
		CONSTRAINT `fk_sets_id` FOREIGN KEY (`sets_id`) REFERENCES `sets` (`id`)
		) COMMENT = 'Комплекты';
	
			INSERT INTO `products` (
				`name`, 
				`manufacturing_firm_id`, 
				`company_name_id`, 
				`description`, 
				`price`, 
				`category_id`, 
				`sets_id`) 
			VALUES 
				('Smart Sensor Set', '1', '1', 'Комплект умного дома Xiaomi Mi Smart Sensor Set', '6990', '1', '1'),
				('PS-1206', '1', '2', 'Комплект SetОхрана и Видеонаблюдение PS-1206', '14500', '2', '2'),
				('Bedroom Set', '2', '2', 'Комплект умного дома Xiaomi Aqara Smart Bedroom Set', '7200', '2', '2'),
				('Rubetek', '2', '3', 'Комплект умного дома Rubetek Управление и безопасность', '5560', '4', '3'),
				('Rubetek', '2', '4', 'Комплект умного дома Rubetek Защита от протечки и пожара', '6100', '5', '3'),
				('AJAX', '6', '5', 'Комплект умного дома AJAX StarterKit white', '9990', '6', '1'),
				('AJAX', '6', '6', 'Комплект умного дома AJAX StarterKit Plus white', '10900', '8', '3'),
				('ACS-1000R', '1', '6', 'ACS-1000R комплект дистанционного управления GSN', '24000', '3', '1'),
				('Bedroom Set', '2', '9', 'Комплект умного дома Xiaomi Mi Smart Sensor Set', '4750', '3', '2'),
				('ACS-1000R', '5', '9', 'Комплект умного дома Xiaomi Mi Smart Sensor Set', '8250', '9', '1');
			
		-- ТАБЛИЦА №6: Тип медиаданых 
		DROP TABLE IF EXISTS `media_types`;
		CREATE TABLE `media_types` (
		`id` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
		`name_type` VARCHAR(10) NOT NULL
		) COMMENT = 'Тип медиаданных';
	
			INSERT INTO `media_types` (`name_type`) 
			VALUES 
				('Video'),
				('Photo'),
				('Text');
	
	-- ТАБЛИЦА №7: Изображения комплектующих
		DROP TABLE IF EXISTS `images`;
		CREATE TABLE `images` (
		`id` BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
		`product_id` BIGINT UNSIGNED NOT NULL,
		`media_types_id` INT NOT NULL,
		CONSTRAINT `fk1_product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
		CONSTRAINT `fk1_media_types_id` FOREIGN KEY (`media_types_id`) REFERENCES `media_types` (`id`)
		) COMMENT = 'Изображения комплектующих';
	
			INSERT INTO `images` (`product_id`, `media_types_id`) 
			VALUES 
				('9', '2'),
				('4', '2'),
				('4', '2'),
				('3', '2'),
				('5', '2'),
				('6', '2'),
				('7', '2'),
				('4', '2'),
				('9', '2'),
				('1', '2');
	
	-- ТАБЛИЦА №8: Видеообзор комплетующих
		DROP TABLE IF EXISTS `video_review`;
		CREATE TABLE `video_review` (
		`id` BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
		`product_id` BIGINT UNSIGNED DEFAULT NULL,
		`media_types_id` INT NOT NULL,
		CONSTRAINT `fk2_product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
		CONSTRAINT `fk2_media_types_id` FOREIGN KEY (`media_types_id`) REFERENCES `media_types` (`id`)
		) COMMENT = 'Видеообзор комплектующих';
			
			INSERT INTO `video_review` (`product_id`, `media_types_id`) 
			VALUES 
				('2', '1'),
				('2', '1'),
				('4', '1'),
				('3', '1'),
				('6', '1'),
				('6', '1'),
				('7', '1'),
				('8', '1'),
				('9', '1'),
				('1', '1');
	
	-- ТАБЛИЦА №9: Пользователи\покупатели
		DROP TABLE IF EXISTS `users`;
		CREATE TABLE `users` (
		`id` BIGINT NOT NULL PRIMARY KEY AUTO_INCREMENT,
		`name` VARCHAR(50) NOT NULL,
		`lastname` VARCHAR(50) NOT NULL,
		`birthday` DATETIME NOT NULL, 
		`email` VARCHAR(50) NOT NULL UNIQUE,
		`phone` BIGINT UNSIGNED DEFAULT NULL UNIQUE, 
		`create_at` DATETIME DEFAULT NOW(),
		KEY index_users_id (`id`, `name`, `lastname`)
		) COMMENT = 'Пользователи';
			
			INSERT INTO `users` (`name`, `lastname`, `birthday`, `email`, `phone`, `create_at`) 
			VALUES 
				('Максим', 'Губанов', '1984-11-01', 'm_gubanov@bk.ru', '89200241951', NOW()),
				('Александр', 'Савельев', '1981-01-11', 'a.savelev@mail.ru', '89034561298', NOW()),
				('Андрей', 'Пешков', '1999-07-21', 'a.peshkov@inbox.ru', '89664568217', NOW()),
				('Антон', 'Климов', '2000-09-30', 'ant.klimov@bk.ru', '89201235692', NOW()),
				('Ольга', 'Сидягина', '1973-03-12', 'o.sidyagina@bk.ru', '89109631278', NOW()),
				('Егор', 'Попов', '1989-02-23', 'popov.e@bk.ru', '89221923687', NOW()),
				('Алексей', 'Воробьев', '2007-10-17', 'a.vorobey@bk.ru', '89041237861', NOW()),
				('Вероника', 'Андреева', '2002-08-29', 'v_andreeva@bk.ru', '89063697035', NOW()),
				('Оксана', 'Власова', '1978-06-09', 'oxy_vlasova@mail.ru', '89201592387', NOW()),
				('Сергей', 'Федин', '1989-11-19', 'fedin_serj@mail.ru', '89207891133', NOW());
	
	-- ТАБЛИЦА №10: онлайн-магазин (заказ товаров)
		DROP TABLE IF EXISTS `online_store`;
		CREATE TABLE `online_store` (
		`id` BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
		`user_id` BIGINT NOT NULL,
		`product_id` BIGINT UNSIGNED NOT NULL,
		`order_at` DATETIME DEFAULT NOW(),
		`total` INT UNSIGNED NOT NULL DEFAULT 0,
		CONSTRAINT `fk3_product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
		CONSTRAINT `fk1_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
		) COMMENT = 'Онлайн магазин';		
	-- Эта таблица заолняется после триггера sold_log, чтобы проверить работу триггера
	-- после выполнения основного скрипта
	
	-- ТАБЛИЦА №11: Отзывы покупателей
		DROP TABLE IF EXISTS `customer_reviews`;
		CREATE TABLE `customer_reviews` (
		`id` BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
		`product_id` BIGINT UNSIGNED NOT NULL,
		`message` TEXT DEFAULT NULL,
		`user_id` BIGINT NOT NULL,
		`likes` BIGINT UNSIGNED DEFAULT 0,
		CONSTRAINT `fk4_product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
		CONSTRAINT `fk2_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
		) COMMENT = 'Отзывы покупателей';
	
			INSERT INTO customer_reviews (`product_id`, `user_id`, `likes`)
			VALUES
				(2, 1, 1),
				(1, 2, 1),
				(9, 3, 1),
				(1, 2, 0),
				(7, 1, 1),
				(7, 1, 1),
				(1, 7, 1),
				(6, 5, 1),
				(5, 4, 0);
			
	-- ТАБЛИЦА №12: Логирование продаж (то что продали)
		DROP TABLE IF EXISTS `sold_out_log`;
		CREATE TABLE `sold_out_log` (
			id BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
			product VARCHAR(50),
			sold ENUM('Есть на складе', 'Нет в наличии')
		);
	
-- 4. ERDiagram приложена к скрипту в архиве.

-- 6. СКРИПТЫ ВЫБОРОК
-- Нахождение пользователей, которые поставили 'dislike', 
-- выводиться имя польз-ля и наименование продукта с ценой.
SELECT 
	u.name `Имя`,
	u.lastname `Фамилия`,
	p.name `Продукт`,
	p.price `Цена`,
	cr.likes `dislike`
FROM customer_reviews cr 
JOIN users u on u.id = cr.id 
JOIN products p on p.id = cr.id 
WHERE likes = 0;

-- Пользователь, который больше всех поставил лайков
SELECT 
	COUNT(*) AS `likes`, 
	u.name, 
	u.lastname
FROM customer_reviews cr
JOIN users u on cr.user_id = u.id 
WHERE likes = 1
GROUP BY user_id 
ORDER BY likes DESC
LIMIT 1;

-- 7. ПРЕДСТАВЛЕНИЯ
-- для проверки этого задания нужно исполнить функцию sum_price_f(n) из 8 задания,
-- так как sum_price_f(n) используется в этом задании.

-- I. Пред-ие выводит наименование комплектующих и цену пакета, входящих в пакет "Комфорт".
DROP VIEW IF EXISTS set_package_comfort;

CREATE VIEW set_package_comfort AS
SELECT 
	p.name AS `Наименование`, 
	p.price AS `Цена комплектующего`,
	s.name_set AS `Пакет`, 
	(select sum_price_f(1)) AS `Стоимость пакета` -- Здесь использовал функцию из задания 8
FROM products p 
JOIN `sets` s 
ON p.sets_id = s.id 
WHERE s.id = 1;

SELECT * FROM set_package_comfort; -- проверка

-- II. Пред-ие выводит наименование комплектующих и цену пакета, входящих в пакет "Защита".
DROP VIEW IF EXISTS set_package_protection;

CREATE VIEW set_package_protection AS
SELECT 
	p.name AS`Наименование`, 
	p.price AS `Цена комплектующего`,
	s.name_set AS `Пакет`, 
	(select sum_price_f(2)) AS `Стоимость пакета` -- Здесь использовал функцию из задания 8
FROM products p 
JOIN `sets` s 
ON p.sets_id = s.id 
WHERE s.id = 2;

SELECT * FROM set_package_protection; -- проверка

-- III. Пред-ие выводит наименование комплектующих и цену пакета, входящих в пакет "Экономия".
DROP VIEW IF EXISTS set_package_economy;

CREATE VIEW set_package_economy AS
SELECT 
	p.name AS `Наименование`, 
	p.price AS `Цена комплектующего`,
	s.name_set AS `Пакет`, 
	(select sum_price_f(3)) AS `Стоимость пакета` -- Здесь использовал функцию из задания 8
FROM products p 
JOIN `sets` s 
ON p.sets_id = s.id 
WHERE s.id = 3;

SELECT * FROM set_package_economy; -- проверка


-- 8. ПРОЦЕДУРЫ И ТРИГГЕРЫ
-- ФУНКЦИЯ написана для 7ого задания.
-- ф-я подсчитывает общую сумму комплектующих, входящих в 1 из 3х пакетов услуг.
DROP FUNCTION IF EXISTS sum_price_f;

DELIMITER //
CREATE FUNCTION sum_price_f(set_id INT)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE i BIGINT DEFAULT 0; -- счетчик
	DECLARE sum_price BIGINT DEFAULT 0; -- сумма цен входящих в определенный 1 из N пакетов

	IF set_id > 0 AND set_id < 4 THEN
		SET @sum_price = (SELECT SUM(price) FROM products WHERE sets_id = set_id);
	ELSE
		SET @sum_price = 'Error: Нет пакета с таким номером.';
	END IF;
	RETURN @sum_price;
END
DELIMITER ;

SELECT sum_price_f(3); -- принимает параметры 1, 2, 3 - это номера пакетов услуг


-- ТРИГГЕР - срабатывает на вставку в таб. online_store и вставляет запись в таблицу 
-- sold_out_log о состоянии продуктов на складе: есть в наличии или нет.
DROP TRIGGER IF EXISTS sold_log;
DELIMITER //
CREATE TRIGGER sold_log AFTER INSERT ON online_store
FOR EACH ROW 
BEGIN
	SET @last_id = (SELECT id FROM online_store ORDER BY id DESC LIMIT 1);
	IF NEW.total > 0 THEN
		INSERT INTO sold_out_log (product, sold) 
		VALUES((SELECT p.name
				FROM products p
				JOIN online_store os 
				ON p.id = os.product_id 
				WHERE os.id = @last_id), 'Есть на складе');
	ELSE
		INSERT INTO sold_out_log (product, sold) 
		VALUES((SELECT p.name
				FROM products p
				JOIN online_store os 
				ON p.id = os.product_id 
				WHERE os.id = (SELECT id FROM online_store ORDER BY id DESC LIMIT 1)), 
					'Нет в наличии');
	END IF;
END//
DELIMITER ;
			
		-- Заполнение таблиый № 10
			INSERT INTO online_store (`user_id`, `product_id`, `total`)
			VALUES
				(2, 1, 23),
				(1, 2, 0),
				(9, 3, 17),
				(3, 2, 11),
				(4, 1, 0),
				(4, 1, 11),
				(1, 7, 24),
				(6, 5, 0),
				(5, 4, 12);
