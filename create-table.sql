-- SELECT * FROM `tdcache`.`cache`;
-- select count(*) from cache;

select now();delimiter $$

CREATE TABLE `cache` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` mediumblob NOT NULL,
  `thekey` varchar(1024) NOT NULL,
  `sha2hash` varchar(100) NOT NULL,
  `creation_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  UNIQUE KEY `sha2hash_UNIQUE` (`sha2hash`),
  KEY `key_index` (`thekey`(255))
) ENGINE=InnoDB AUTO_INCREMENT=15850 DEFAULT CHARSET=utf8$$

