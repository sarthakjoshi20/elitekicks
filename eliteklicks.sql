-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 20, 2025 at 07:48 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `eliteklicks`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `admin_id` int(11) NOT NULL,
  `admin_name` varchar(100) NOT NULL,
  `admin_mobile` varchar(15) NOT NULL,
  `admin_password` varchar(255) NOT NULL,
  `status` enum('active','deleted') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`admin_id`, `admin_name`, `admin_mobile`, `admin_password`, `status`) VALUES
(1, 'Sarthak Joshi', '9322231899', 'Admin@123', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `carts`
--

CREATE TABLE `carts` (
  `cart_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `qty` int(11) DEFAULT 1,
  `size` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `carts`
--

INSERT INTO `carts` (`cart_id`, `customer_id`, `product_id`, `qty`, `size`) VALUES
(3, 1, 1, 5, 'Mens: 9'),
(31, 3, 1, 5, 'Mens: 9'),
(32, 3, 7, 5, 'Kids: 14'),
(37, 1, 8, 5, 'Womens: 8');

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `customer_id` int(11) NOT NULL,
  `customer_name` varchar(100) NOT NULL,
  `customer_mobile` varchar(15) NOT NULL,
  `customer_email` varchar(100) DEFAULT NULL,
  `status` enum('active','inactive','deleted') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`customer_id`, `customer_name`, `customer_mobile`, `customer_email`, `status`) VALUES
(1, '', '', 'sarthakjoshi1899@gmail.com', 'active'),
(2, '', '', 'sarthakjoshi4856@gmail.com', 'active'),
(3, '', '', 'vaghamay5@gmail.com', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `customer_address`
--

CREATE TABLE `customer_address` (
  `customer_address_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `country` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `area` varchar(100) DEFAULT NULL,
  `landmark` varchar(255) DEFAULT NULL,
  `pincode` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `fullname` varchar(100) NOT NULL,
  `mobile` varchar(15) NOT NULL,
  `country` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `area` varchar(100) DEFAULT NULL,
  `landmark` varchar(255) DEFAULT NULL,
  `pincode` varchar(10) DEFAULT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `payment_status` enum('pending','paid','failed') DEFAULT 'pending',
  `transaction_id` varchar(100) DEFAULT NULL,
  `order_date` datetime DEFAULT current_timestamp(),
  `dispatch_date` datetime DEFAULT NULL,
  `deliver_date` datetime DEFAULT NULL,
  `return_date` datetime DEFAULT NULL,
  `refund_date` datetime DEFAULT NULL,
  `cancel_date` datetime DEFAULT NULL,
  `order_status` enum('placed','dispatched','delivered','returned','cancelled') DEFAULT 'placed'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `customer_id`, `fullname`, `mobile`, `country`, `state`, `city`, `area`, `landmark`, `pincode`, `total_amount`, `payment_method`, `payment_status`, `transaction_id`, `order_date`, `dispatch_date`, `deliver_date`, `return_date`, `refund_date`, `cancel_date`, `order_status`) VALUES
(37, 2, 'Sarthak Haribhau Joshi', '7588540180', 'India', 'Maharashtra', 'Ahmednagar', 'AT Post Yeli, Taluka Pathardi, District Ahmednagar', NULL, '414003', 1000.00, 'Online', 'paid', 'pay_RId0b8VLbbn2YO', '2025-09-17 00:00:00', '2025-09-17 17:00:50', '2025-09-17 17:22:54', NULL, NULL, '2025-09-17 17:45:17', 'cancelled'),
(38, 2, 'Amay Wagh', '9322231899', 'India', 'Maharashtra', 'Pathardi', 'AT Post Yeli, Taluka Pathardi, District Ahmednagar - 414113', NULL, '414113', 11000.00, 'Online', 'paid', 'pay_RIds61X27sMzFV', '2025-09-17 00:00:00', '2025-09-17 17:50:45', '2025-09-17 17:28:56', NULL, NULL, '2025-09-17 17:51:07', 'placed'),
(39, 2, 'Haribhau Joshi', '9021791596', 'India', 'Maharashtra', 'Ahmednagar', 'Sairaj Ahmednagar 414003', NULL, '414003', 3000.00, 'Online', 'paid', 'pay_RIdvbIBzIJNHjq', '2025-09-17 00:00:00', '2025-09-17 17:30:11', '2025-09-17 17:35:22', NULL, NULL, NULL, 'delivered'),
(40, 1, 'Ram Dhole', '8786090570', '', '', '', 'AT Post Yeli, Taluka Pathardi, District Ahmednagar - 414113', NULL, '414113', 5400.00, 'Online', 'paid', 'pay_RImXqx4QkwGbDN', '2025-09-17 00:00:00', '2025-09-18 06:47:30', NULL, NULL, NULL, NULL, 'dispatched');

-- --------------------------------------------------------

--
-- Table structure for table `order_products`
--

CREATE TABLE `order_products` (
  `order_product_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_name` varchar(150) DEFAULT NULL,
  `product_size` varchar(50) DEFAULT NULL,
  `product_market_price` decimal(10,2) DEFAULT NULL,
  `product_discount` decimal(5,2) DEFAULT NULL,
  `product_price` decimal(10,2) DEFAULT NULL,
  `product_qty` int(11) DEFAULT 1,
  `product_total` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_products`
--

INSERT INTO `order_products` (`order_product_id`, `order_id`, `customer_id`, `product_id`, `product_name`, `product_size`, `product_market_price`, `product_discount`, `product_price`, `product_qty`, `product_total`) VALUES
(49, 37, 2, 1, 'Puma x21', 'Mens: 8', 1200.00, 16.67, 1000.00, 1, 1000.00),
(50, 38, 2, 1, 'Puma x21', 'Mens: 9', 1200.00, 16.67, 1000.00, 5, 5000.00),
(51, 38, 2, 1, 'Puma x21', 'Mens: 9', 1200.00, 16.67, 1000.00, 5, 5000.00),
(52, 39, 2, 8, 'Adidas Storm Runner', 'Womens: 6', 2000.00, 25.00, 1500.00, 2, 3000.00),
(53, 40, 1, 7, 'Sparx Ace Cricket Pro', 'Kids: 12', 1200.00, 20.00, 1080.00, 5, 5400.00);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `product_name` varchar(150) NOT NULL,
  `product_market_price` decimal(10,2) NOT NULL,
  `apply_discount_percent` decimal(5,2) DEFAULT 0.00,
  `product_price` decimal(10,2) NOT NULL,
  `product_description` text DEFAULT NULL,
  `product_main_image` text DEFAULT NULL,
  `product_rating` decimal(2,1) DEFAULT 0.0,
  `product_is_trending` enum('yes','no') DEFAULT 'no',
  `product_brand_id` int(11) DEFAULT NULL,
  `product_style_id` int(11) DEFAULT NULL,
  `product_for` enum('Male','Female','Kids') DEFAULT NULL,
  `product_kid_type` enum('Boys','Girls') DEFAULT NULL,
  `product_type_id` int(11) DEFAULT NULL,
  `offer_expiry_date` date DEFAULT NULL,
  `product_added_date` datetime DEFAULT current_timestamp(),
  `product_stock` int(11) DEFAULT 0,
  `product_color` varchar(50) DEFAULT NULL,
  `status` enum('active','deleted') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `product_name`, `product_market_price`, `apply_discount_percent`, `product_price`, `product_description`, `product_main_image`, `product_rating`, `product_is_trending`, `product_brand_id`, `product_style_id`, `product_for`, `product_kid_type`, `product_type_id`, `offer_expiry_date`, `product_added_date`, `product_stock`, `product_color`, `status`) VALUES
(1, 'Puma x21', 1200.00, 16.67, 1000.00, '<p><strong>PRODUCT STORY</strong></p><p>Step up your sneaker game with the Smashic Women\'s Sneakers from PUMA. The contrast PUMA formstrip adds a touch of style, while the Softfoam sockliner ensures maximum comfort. The rubber outsole provides superior traction, making these sneakers perfect for any occasion.</p><p><strong>Details</strong></p><ul><li>Synthetic upper</li><li>Rubber outsole</li><li>Heel type: Flat</li><li>Shoe width: Regular fit</li><li>Shoe pronation: Neutral</li><li>Heel-to-toe-drop: 0 mm</li><li>PUMA Cat logo on heel</li></ul>', '17527705890981752691084318TB9024FGP_1-ANGLE_3f604063-9331-4755-8b9e-be709ecf7f7a[1].png', 0.0, 'yes', 3, 3, 'Male', NULL, 2, NULL, '2025-07-14 00:09:54', 80, 'Red', 'active'),
(7, 'Sparx Ace Cricket Pro', 1200.00, 20.00, 1080.00, '<p><strong>PRODUCT STORY</strong></p><p>Step up your sneaker game with the Smashic Women\'s Sneakers from PUMA. The contrast PUMA formstrip adds a touch of style, while the Softfoam sockliner ensures maximum comfort. The rubber outsole provides superior traction, making these sneakers perfect for any occasion.</p><p><strong>Details</strong></p><ul><li>Synthetic upper</li><li>Rubber outsole</li><li>Heel type: Flat</li><li>Shoe width: Regular fit</li><li>Shoe pronation: Neutral</li><li>Heel-to-toe-drop: 0 mm</li><li>PUMA Cat logo on heel</li></ul>', '17527705468831752691056286TB9053FLG_01-ANGLE_e0465b6a-67c9-403f-88ac-52b39066a0a5_600x600[1].png', 0.0, 'yes', 4, 1, 'Kids', 'Boys', 2, NULL, '2025-07-14 01:00:54', 100, 'Black and Green', 'active'),
(8, 'Adidas Storm Runner', 2000.00, 25.00, 1500.00, '<p><strong>PRODUCT STORY</strong></p><p>Step up your sneaker game with the Smashic Women\'s Sneakers from PUMA. The contrast PUMA formstrip adds a touch of style, while the Softfoam sockliner ensures maximum comfort. The rubber outsole provides superior traction, making these sneakers perfect for any occasion.</p><p><strong>Details</strong></p><ul><li>Synthetic upper</li><li>Rubber outsole</li><li>Heel type: Flat</li><li>Shoe width: Regular fit</li><li>Shoe pronation: Neutral</li><li>Heel-to-toe-drop: 0 mm</li><li>PUMA Cat logo on heel</li></ul>', '17527705572361752691036008TB9054FGR_01-ANGLE_3c30df4d-f3ba-444d-87f0-0cc19f61e1bf_600x600[1].png', 0.0, 'no', 5, 2, 'Female', NULL, 5, NULL, '2025-07-14 01:05:51', 50, 'White', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `product_brands`
--

CREATE TABLE `product_brands` (
  `product_brand_id` int(11) NOT NULL,
  `product_brand_name` varchar(100) NOT NULL,
  `product_brand_image` text NOT NULL,
  `status` enum('active','deleted') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_brands`
--

INSERT INTO `product_brands` (`product_brand_id`, `product_brand_name`, `product_brand_image`, `status`) VALUES
(3, 'Puma', '1752772825586OIP (1).jpg', 'active'),
(4, 'Sparx', '1752773856793OIP (4).jpg', 'active'),
(5, 'Adidas', '1752773885176OIP (5).jpg', 'active'),
(6, 'Skechers', '1752773931615OIP (6).jpg', 'active'),
(7, 'Nike', '1752773967734OIP (7).jpg', 'active'),
(8, 'Reebok', '1752773993536OIP.jpg', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `product_images`
--

CREATE TABLE `product_images` (
  `product_image_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_image` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_styles`
--

CREATE TABLE `product_styles` (
  `product_style_id` int(11) NOT NULL,
  `product_style_name` varchar(100) NOT NULL,
  `product_style_image` text NOT NULL,
  `status` enum('active','deleted') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_styles`
--

INSERT INTO `product_styles` (`product_style_id`, `product_style_name`, `product_style_image`, `status`) VALUES
(1, 'Formal', '1752773110911OIP.jpg', 'active'),
(2, 'Sport', '1752773645191OIP (1).jpg', 'active'),
(3, 'Casual', '1752773682709OIP (2).jpg', 'active'),
(4, 'Sneaker', '1752773723980OIP (3).jpg', 'active'),
(9, 'Heels', '1753525619726OIP.jpg', 'active'),
(10, 'Loafere', '1753525670707OIP (1).jpg', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `product_types`
--

CREATE TABLE `product_types` (
  `product_type_id` int(11) NOT NULL,
  `product_type_name` varchar(100) NOT NULL,
  `product_type_image` text NOT NULL,
  `status` enum('active','deleted') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_types`
--

INSERT INTO `product_types` (`product_type_id`, `product_type_name`, `product_type_image`, `status`) VALUES
(2, 'Cricket', '1752773320512OIP (2).jpg', 'active'),
(3, 'Football', '1752773384635OIP (3).jpg', 'active'),
(5, 'Trekking/Hiking', '1752773422041OIP (4).jpg', 'active'),
(6, 'Training/Gym', '1752773473061OIP (5).jpg', 'active'),
(32, 'Hocky', '1752773548849OIP.jpg', 'active'),
(35, 'Tennis / Court Sports', '1753525859841OIP (2).jpg', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `promotional_banner`
--

CREATE TABLE `promotional_banner` (
  `banner_id` int(11) NOT NULL,
  `banner_title` varchar(150) DEFAULT NULL,
  `banner_button_text` varchar(50) DEFAULT NULL,
  `banner_button_link` varchar(255) DEFAULT NULL,
  `banner_image` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sliders`
--

CREATE TABLE `sliders` (
  `slider_id` int(11) NOT NULL,
  `slider_title` varchar(255) DEFAULT NULL,
  `slider_image` text DEFAULT NULL,
  `slider_button_text` varchar(50) DEFAULT NULL,
  `slider_button_link` text DEFAULT NULL,
  `slider_description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sliders`
--

INSERT INTO `sliders` (`slider_id`, `slider_title`, `slider_image`, `slider_button_text`, `slider_button_link`, `slider_description`) VALUES
(7, 'NEW COLLECTION', '1752686633441photo-1460353581641-37baddab0fa2[1]', 'Shop Now', 'http://localhost:1000/', '<p>Discover our latest designs for the season</p>'),
(8, 'LIMITED EDITION', '1752686735525photo-1542291026-7eec264c27ff[1]', 'VIEW COLLECTION', 'http://localhost:1000/', '<p>Exclusive designs available for a short time</p>'),
(10, 'SUMMER SALE', '1752686880940photo-1600269452121-4f2416e55c28[1]', 'SHOP SALE', 'http://localhost:1000/', '<p>Up to <i><strong>50%</strong></i><strong> off</strong> selected styles</p>');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`admin_id`),
  ADD UNIQUE KEY `admin_mobile` (`admin_mobile`);

--
-- Indexes for table `carts`
--
ALTER TABLE `carts`
  ADD PRIMARY KEY (`cart_id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`customer_id`),
  ADD UNIQUE KEY `customer_email` (`customer_email`);

--
-- Indexes for table `customer_address`
--
ALTER TABLE `customer_address`
  ADD PRIMARY KEY (`customer_address_id`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Indexes for table `order_products`
--
ALTER TABLE `order_products`
  ADD PRIMARY KEY (`order_product_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `product_brand_id` (`product_brand_id`),
  ADD KEY `product_style_id` (`product_style_id`),
  ADD KEY `product_type_id` (`product_type_id`);

--
-- Indexes for table `product_brands`
--
ALTER TABLE `product_brands`
  ADD PRIMARY KEY (`product_brand_id`),
  ADD UNIQUE KEY `product_brand_name` (`product_brand_name`);

--
-- Indexes for table `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`product_image_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `product_styles`
--
ALTER TABLE `product_styles`
  ADD PRIMARY KEY (`product_style_id`),
  ADD UNIQUE KEY `product_style_name` (`product_style_name`);

--
-- Indexes for table `product_types`
--
ALTER TABLE `product_types`
  ADD PRIMARY KEY (`product_type_id`),
  ADD UNIQUE KEY `product_type_name` (`product_type_name`);

--
-- Indexes for table `promotional_banner`
--
ALTER TABLE `promotional_banner`
  ADD PRIMARY KEY (`banner_id`);

--
-- Indexes for table `sliders`
--
ALTER TABLE `sliders`
  ADD PRIMARY KEY (`slider_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `admin_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `carts`
--
ALTER TABLE `carts`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `customer_address`
--
ALTER TABLE `customer_address`
  MODIFY `customer_address_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `order_products`
--
ALTER TABLE `order_products`
  MODIFY `order_product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `product_brands`
--
ALTER TABLE `product_brands`
  MODIFY `product_brand_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `product_images`
--
ALTER TABLE `product_images`
  MODIFY `product_image_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_styles`
--
ALTER TABLE `product_styles`
  MODIFY `product_style_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `product_types`
--
ALTER TABLE `product_types`
  MODIFY `product_type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `promotional_banner`
--
ALTER TABLE `promotional_banner`
  MODIFY `banner_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sliders`
--
ALTER TABLE `sliders`
  MODIFY `slider_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `carts`
--
ALTER TABLE `carts`
  ADD CONSTRAINT `carts_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `carts_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;

--
-- Constraints for table `customer_address`
--
ALTER TABLE `customer_address`
  ADD CONSTRAINT `customer_address_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE;

--
-- Constraints for table `order_products`
--
ALTER TABLE `order_products`
  ADD CONSTRAINT `order_products_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_products_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`customer_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_products_ibfk_3` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`product_brand_id`) REFERENCES `product_brands` (`product_brand_id`),
  ADD CONSTRAINT `products_ibfk_2` FOREIGN KEY (`product_style_id`) REFERENCES `product_styles` (`product_style_id`),
  ADD CONSTRAINT `products_ibfk_3` FOREIGN KEY (`product_type_id`) REFERENCES `product_types` (`product_type_id`);

--
-- Constraints for table `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
