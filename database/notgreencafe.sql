-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 13, 2023 at 06:39 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `notgreencafe`
--

-- --------------------------------------------------------

--
-- Table structure for table `menu_items`
--

CREATE TABLE `menu_items` (
  `item_id` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `category` enum('Curry','Snacks','Drinks','Set Menu','Rice','Combo') DEFAULT NULL,
  `image_url` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `menu_items`
--

INSERT INTO `menu_items` (`item_id`, `name`, `description`, `price`, `category`, `image_url`) VALUES
('101', 'Chicken Curry', 'Delicious chicken curry with spices', 12, 'Curry', 'http://example.com/chicken_curry.jpg'),
('102', 'Vegetable Spring Rolls', 'Crispy spring rolls with assorted veggies', 8, 'Snacks', 'http://example.com/spring_rolls.jpg'),
('103', 'Iced Tea', 'Refreshing iced tea with lemon', 3, 'Drinks', 'http://example.com/iced_tea.jpg'),
('104', 'Chef Special Combo', 'A combination of our best dishes', 20, 'Combo', 'http://example.com/chef_special.jpg'),
('105', 'Shrimp Fried Rice', 'Tasty fried rice with shrimp', 15, 'Rice', 'http://example.com/shrimp_fried_rice.jpg'),
('106', 'Chocolate Cake', 'Decadent chocolate cake for dessert', 7, 'Combo', 'http://example.com/chocolate_cake.jpg'),
('107', 'Beef Tacos', 'Spicy beef tacos with fresh salsa', 10, 'Snacks', 'http://example.com/beef_tacos.jpg'),
('108', 'Soda', 'Assorted sodas and soft drinks', 2, 'Drinks', 'http://example.com/soda.jpg'),
('109', 'Vegetarian Set Menu', 'A variety of vegetarian dishes', 18, 'Set Menu', 'http://example.com/vegetarian_set_menu.jpg'),
('110', 'Mango Lassi', 'Refreshing mango-flavored yogurt drink', 5, 'Drinks', 'http://example.com/mango_lassi.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` varchar(255) NOT NULL,
  `customer_id` varchar(255) DEFAULT NULL,
  `item_id` varchar(255) DEFAULT NULL,
  `order_date` datetime DEFAULT current_timestamp(),
  `quantity` int(11) DEFAULT NULL,
  `total_price` int(11) DEFAULT NULL,
  `status` enum('Processing','Confirmed','Delivered') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `customer_id`, `item_id`, `order_date`, `quantity`, `total_price`, `status`) VALUES
('201', '1', '101', '2023-12-13 23:35:45', 2, 24, 'Confirmed'),
('202', '2', '102', '2023-12-13 23:35:45', 3, 24, 'Processing'),
('203', '3', '103', '2023-12-13 23:35:45', 1, 3, 'Delivered'),
('204', '4', '104', '2023-12-13 23:35:45', 1, 20, 'Processing'),
('205', '5', '105', '2023-12-13 23:35:45', 2, 30, 'Confirmed'),
('206', '6', '106', '2023-12-13 23:35:45', 1, 7, 'Delivered'),
('207', '7', '107', '2023-12-13 23:35:45', 2, 20, 'Confirmed'),
('208', '8', '108', '2023-12-13 23:35:45', 4, 8, 'Delivered'),
('209', '9', '109', '2023-12-13 23:35:45', 1, 18, 'Processing'),
('210', '10', '110', '2023-12-13 23:35:45', 3, 15, 'Confirmed');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `sex` enum('Male','Female','Other') DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `birthdate` datetime DEFAULT NULL,
  `profile_picture_url` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `name`, `email`, `password`, `sex`, `address`, `birthdate`, `profile_picture_url`) VALUES
('1', 'John Doe', 'john.doe@example.com', 'password123', 'Male', '123 Main St', '1990-01-15 00:00:00', 'http://example.com/john.jpg'),
('10', 'Olivia Wilson', 'olivia.wilson@example.com', 'pass212223', 'Female', '505 Pine St', '1994-06-28 00:00:00', 'http://example.com/olivia.jpg'),
('2', 'Jane Smith', 'jane.smith@example.com', 'pass456', 'Female', '456 Oak St', '1985-05-20 00:00:00', 'http://example.com/jane.jpg'),
('3', 'Bob Johnson', 'bob.johnson@example.com', 'pass789', 'Male', '789 Elm St', '1978-09-10 00:00:00', 'http://example.com/bob.jpg'),
('4', 'Alice Brown', 'alice.brown@example.com', 'pass1234', 'Female', '456 Pine St', '1992-03-25 00:00:00', 'http://example.com/alice.jpg'),
('5', 'Charlie Wilson', 'charlie.wilson@example.com', 'pass5678', 'Other', '789 Oak St', '1980-12-18 00:00:00', 'http://example.com/charlie.jpg'),
('6', 'Eva Martinez', 'eva.martinez@example.com', 'pass91011', 'Female', '101 Maple St', '1995-07-08 00:00:00', 'http://example.com/eva.jpg'),
('7', 'David Kim', 'david.kim@example.com', 'pass121314', 'Male', '202 Cedar St', '1983-09-30 00:00:00', 'http://example.com/david.jpg'),
('8', 'Sophia Lee', 'sophia.lee@example.com', 'pass151617', 'Female', '303 Birch St', '1998-11-12 00:00:00', 'http://example.com/sophia.jpg'),
('9', 'Michael Brown', 'michael.brown@example.com', 'pass181920', 'Male', '404 Oak St', '1987-04-05 00:00:00', 'http://example.com/michael.jpg');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `menu_items`
--
ALTER TABLE `menu_items`
  ADD PRIMARY KEY (`item_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `item_id` (`item_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `menu_items` (`item_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
