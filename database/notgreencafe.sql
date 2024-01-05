CREATE DATABASE IF NOT EXISTS `notgreencafe`;
USE `notgreencafe`;
-- --------------------------------------------------------
CREATE TABLE `users` (
  `user_id` varchar(255) NOT NULL PRIMARY KEY,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `sex` enum('Male','Female','Other') DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `birthdate` datetime DEFAULT NULL,
  `profile_picture_url` text DEFAULT NULL,
  UNIQUE KEY `email` (`email`)
);

CREATE TABLE `menu_items` (
  `item_id` varchar(255) NOT NULL PRIMARY KEY,
  `name` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `category` enum('Curry','Snacks','Drinks','Set Menu','Rice','Combo') DEFAULT NULL,
  `image_url` text DEFAULT NULL
);

CREATE TABLE `orders` (
  `order_id` varchar(255) NOT NULL PRIMARY KEY,
  `customer_id` varchar(255) NOT NULL,
  `item_id` varchar(255) NOT NULL,
  `order_date` datetime DEFAULT current_timestamp(),
  `quantity` int(11) DEFAULT NULL,
  `total_price` int(11) DEFAULT NULL,
  `status` enum('Processing','Confirmed','Delivered') DEFAULT NULL,
  FOREIGN KEY (`customer_id`) REFERENCES `users`(`user_id`),
  FOREIGN KEY (`item_id`) REFERENCES `menu_items`(`item_id`)
);