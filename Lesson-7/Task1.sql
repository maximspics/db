DROP DATABASE `social_network`;
CREATE DATABASE `social_network`;
USE `social_network`;
CREATE TABLE `social_network`.`users` (
    `id_user` MEDIUMINT NOT NULL AUTO_INCREMENT,
    `first_name` VARCHAR(100) NOT NULL,
    `last_name` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`id_user`)
);

INSERT INTO `social_network`.`users` (`id_user`, `first_name`, `last_name`) VALUES ('1', 'Max', 'Maximov'), ('2', 'Andrey', 'Andreev'), ('3', 'Ivan', 'Ivanov'), ('4', 'Peter', 'Peterson');

CREATE TABLE `social_network`.`likes` (
   `from_user` MEDIUMINT NOT NULL,
   `to_user` MEDIUMINT NOT NULL,
   PRIMARY KEY (`from_user`, `to_user`),
   INDEX `fk_to_user_idx` (`to_user` ASC) VISIBLE,
   CONSTRAINT `fk_from_user`
     FOREIGN KEY (`from_user`)
     REFERENCES `social_network`.`users` (`id_user`)
     ON DELETE NO ACTION
     ON UPDATE NO ACTION,
   CONSTRAINT `fk_to_user`
     FOREIGN KEY (`to_user`)
     REFERENCES `social_network`.`users` (`id_user`)
     ON DELETE NO ACTION
     ON UPDATE NO ACTION);

INSERT INTO `social_network`.`likes` (`from_user`, `to_user`) VALUES (1, 2), (1, 3), (1, 4), (2, 1), (2, 3), (3, 1), (3, 4), (4, 1), (4, 2), (4, 3);

-- Задача 1. У вас есть социальная сеть, где пользователи (id, имя) могут ставить друг другу лайки. 
-- Создайте необходимые таблицы для хранения данной информации. 
-- Создайте запрос, который выведет информацию:
-- id пользователя;
-- имя;
-- лайков получено;
-- лайков поставлено;
-- взаимные лайки.

SELECT 
    users.id_user,
    users.first_name AS `first name`,
    users.last_name AS `last name`,
    COUNT(DISTINCT l2.from_user) AS `like get`,
    COUNT(DISTINCT l1.to_user) AS `like sent`,
    SUM(IF(l1.to_user = l2.from_user, 1, 0)) AS `croos like`
FROM
    users
        JOIN
    likes AS l1 ON users.id_user = l1.from_user
        JOIN
    likes AS l2 ON users.id_user = l2.to_user
GROUP BY users.id_user;
 ;
 
-- Задача 2. Для структуры из задачи 1 выведите список всех пользователей, 
-- которые поставили лайк пользователям A и B (id задайте произвольно), 
-- но при этом не поставили лайк пользователю C.

SELECT 
    from_user,
    SUM(IF(to_user = 1, 1, 0)) AS t1,
    SUM(IF(to_user = 2, 1, 0)) AS t2,
    SUM(IF(to_user = 3, 1, 0)) AS t3
FROM
    likes
GROUP BY from_user
HAVING (t1 = 1 AND t2 = 1 AND t3 = 0)
;

-- Задача 3. Добавим сущности «Фотография» и «Комментарии к фотографии». 
-- Нужно создать функционал для пользователей, который позволяет ставить лайки не только пользователям, 
-- но и фото или комментариям к фото. Учитывайте следующие ограничения:
-- пользователь не может дважды лайкнуть одну и ту же сущность;
-- пользователь имеет право отозвать лайк;
-- необходимо иметь возможность считать число полученных сущностью лайков и выводить список пользователей, поставивших лайки;
-- в будущем могут появиться новые виды сущностей, которые можно лайкать.

 CREATE TABLE `social_network`.`photo` (
   `id_photo` MEDIUMINT NOT NULL AUTO_INCREMENT,
   `url` VARCHAR(500) NULL,
   `id_user` MEDIUMINT NOT NULL,
   PRIMARY KEY (`id_photo`),
   INDEX `fk_id_user_photo_idx` (`id_user` ASC) VISIBLE,
   CONSTRAINT `fk_id_user_photo`
     FOREIGN KEY (`id_user`)
     REFERENCES `social_network`.`users` (`id_user`)
     ON DELETE NO ACTION
     ON UPDATE NO ACTION);

 CREATE TABLE `social_network`.`comment_photo` (
   `id_comment` MEDIUMINT NOT NULL AUTO_INCREMENT,
   `comment` VARCHAR(500) NULL,
   `id_user` MEDIUMINT NOT NULL,
   `id_photo` MEDIUMINT NOT NULL,
   UNIQUE INDEX `id_photo_UNIQUE` (`id_photo` ASC) VISIBLE,
   PRIMARY KEY (`id_comment`),
   INDEX `fk_id_user_comment_idx` (`id_user` ASC) VISIBLE,
   CONSTRAINT `fk_id_user_comment`
     FOREIGN KEY (`id_user`)
     REFERENCES `social_network`.`users` (`id_user`)
     ON DELETE NO ACTION
     ON UPDATE NO ACTION,
   CONSTRAINT `fk_id_photo_comment`
     FOREIGN KEY (`id_photo`)
     REFERENCES `social_network`.`photo` (`id_photo`)
     ON DELETE NO ACTION
     ON UPDATE NO ACTION);
;
 insert into `social_network`.`photo` (`id_user`) values (1), (2), (3);
;
 drop table likes;
;
CREATE TABLE `likes` (
    id_user MEDIUMINT,
    like_to_user MEDIUMINT,
    like_to_photo MEDIUMINT,
    like_to_comment MEDIUMINT,
    UNIQUE KEY `user_id_photo` (`id_user` , `like_to_photo`),
    UNIQUE KEY `user_id_comment` (`id_user` , `like_to_comment`),
    UNIQUE KEY `user_id_user` (`id_user` , `like_to_user`),
    CONSTRAINT `fk_id_like_to_user` FOREIGN KEY (`like_to_user`)
        REFERENCES `social_network`.`users` (`id_user`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_id_like_to_photo` FOREIGN KEY (`like_to_photo`)
        REFERENCES `social_network`.`photo` (`id_photo`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_id_like_to_comment` FOREIGN KEY (`like_to_comment`)
        REFERENCES `social_network`.`comment_photo` (`id_comment`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

INSERT INTO `social_network`.`likes` (`id_user`, `like_to_user`) VALUES (1, 2), (1, 3), (1, 4), (2, 1), (2, 3), (3, 1), (3, 4), (4, 1), (4, 2), (4, 3);

INSERT INTO `social_network`.`likes` (`id_user`, `like_to_photo`) VALUES (1, 2), (2, 2), (2, 3), (3, 3);

SELECT 
    users.id_user,
    users.first_name AS `first name`,
    users.last_name AS `last name`,
    COUNT(DISTINCT l1.id_user) likes_get,
    COUNT(DISTINCT l2.like_to_user) likes_sent,
    SUM(IF(l1.id_user = l2.like_to_user, 1, 0)) cross_like
FROM
    users
        LEFT JOIN
    likes l1 ON users.id_user = l1.like_to_user
        LEFT JOIN
    likes l2 ON users.id_user = l2.id_user
GROUP BY users.id_user;

SELECT 
    id_user,
    SUM(IF(like_to_user = 1, 1, 0)) t1,
    SUM(IF(like_to_user = 2, 1, 0)) t2,
    SUM(IF(like_to_user = 3, 1, 0)) t3
FROM
    likes
GROUP BY id_user
HAVING (t1 = 1 AND t2 = 1 AND t3 = 0);