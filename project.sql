-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 08, 2026 at 09:20 PM
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
-- Database: `project`
--

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `booking_date` date NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `status` enum('pending','approved','rejected','cancel','cancel_by_admin') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `sync_version` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`id`, `room_id`, `booking_date`, `start_time`, `end_time`, `status`, `created_at`, `updated_at`, `sync_version`) VALUES
(1, 1, '2026-08-26', '2026-08-26 11:05:00', '2026-08-26 11:30:00', 'approved', '2026-08-26 04:04:44', '2026-08-26 04:04:44', 1),
(2, 1, '2026-08-26', '2026-08-26 16:23:00', '2026-08-26 16:24:00', 'approved', '2026-08-26 09:21:34', '2026-08-26 09:21:34', 1),
(3, 1, '2026-08-26', '2026-08-26 16:37:00', '2026-08-26 16:38:00', 'approved', '2026-08-26 09:35:50', '2026-08-26 09:35:50', 1),
(4, 1, '2026-08-26', '2026-08-26 16:41:00', '2026-08-26 16:42:00', 'approved', '2026-08-26 09:39:21', '2026-08-26 09:39:21', 1),
(5, 1, '2026-08-26', '2026-08-26 16:45:00', '2026-08-26 16:47:00', 'approved', '2026-08-26 09:43:20', '2026-08-26 09:43:20', 1),
(6, 1, '2026-08-26', '2026-08-26 16:49:00', '2026-08-26 16:50:00', 'approved', '2026-08-26 09:48:42', '2026-08-26 09:48:42', 1),
(7, 1, '2026-08-26', '2026-08-26 16:53:00', '2026-08-26 16:54:00', 'cancel_by_admin', '2026-08-26 09:51:41', '2026-08-26 09:51:52', 2),
(8, 1, '2026-08-26', '2026-08-26 16:53:00', '2026-08-26 16:55:00', 'approved', '2026-08-26 09:52:28', '2026-08-26 09:52:28', 1),
(9, 1, '2026-08-26', '2026-08-26 17:11:00', '2026-08-26 17:13:00', 'approved', '2026-08-26 10:09:58', '2026-08-26 10:09:58', 1),
(10, 1, '2026-08-26', '2026-08-26 17:14:00', '2026-08-26 17:15:00', 'approved', '2026-08-26 10:12:16', '2026-08-26 10:12:16', 1),
(11, 1, '2026-08-26', '2026-08-26 19:37:00', '2026-08-26 19:38:00', 'approved', '2026-08-26 12:35:27', '2026-08-26 12:35:27', 1),
(12, 1, '2026-08-26', '2026-08-26 19:40:00', '2026-08-26 19:41:00', 'approved', '2026-08-26 12:36:36', '2026-08-26 12:36:36', 1),
(13, 1, '2026-08-26', '2026-08-26 19:42:00', '2026-08-26 19:43:00', 'approved', '2026-08-26 12:37:20', '2026-08-26 12:37:20', 1),
(14, 1, '2026-08-27', '2026-08-27 09:06:00', '2026-08-27 09:07:00', 'approved', '2026-08-27 02:05:06', '2026-08-27 02:05:06', 1),
(15, 1, '2026-08-27', '2026-08-27 09:11:00', '2026-08-27 09:12:00', 'approved', '2026-08-27 02:10:33', '2026-08-27 02:10:33', 1),
(16, 1, '2026-08-27', '2026-08-27 09:22:00', '2026-08-27 09:23:00', 'approved', '2026-08-27 02:21:11', '2026-08-27 02:21:11', 1),
(17, 1, '2026-08-27', '2026-08-27 17:20:00', '2026-08-27 17:30:00', 'cancel_by_admin', '2026-08-27 02:26:57', '2026-08-27 03:50:09', 2),
(18, 1, '2026-08-27', '2026-08-27 09:31:00', '2026-08-27 09:32:00', 'approved', '2026-08-27 02:30:54', '2026-08-27 02:30:54', 1),
(19, 1, '2026-08-27', '2026-08-27 10:42:00', '2026-08-27 10:43:00', 'approved', '2026-08-27 03:41:08', '2026-08-27 03:41:08', 1),
(20, 1, '2026-08-27', '2026-08-27 10:47:00', '2026-08-27 10:48:00', 'approved', '2026-08-27 03:46:53', '2026-08-27 03:46:53', 1),
(21, 1, '2026-08-27', '2026-08-27 10:50:00', '2026-08-27 10:53:00', 'approved', '2026-08-27 03:49:27', '2026-08-27 03:49:27', 1),
(22, 1, '2026-08-27', '2026-08-27 10:56:00', '2026-08-27 10:58:00', 'approved', '2026-08-27 03:55:14', '2026-08-27 03:55:14', 1),
(23, 1, '2026-08-27', '2026-08-27 11:41:00', '2026-08-27 11:43:00', 'approved', '2026-08-27 04:39:46', '2026-08-27 04:39:46', 1),
(24, 1, '2026-09-04', '2026-09-04 00:01:00', '2026-09-04 00:03:00', 'approved', '2026-09-03 16:57:19', '2026-09-03 16:57:19', 1),
(25, 1, '2026-09-04', '2026-09-04 00:04:00', '2026-09-04 00:05:00', 'approved', '2026-09-03 16:59:11', '2026-09-03 16:59:11', 1),
(26, 1, '2026-09-21', '2026-09-21 14:35:00', '2026-09-21 14:36:00', 'approved', '2026-09-21 07:34:43', '2026-09-21 07:34:43', 1),
(27, 1, '2026-09-21', '2026-09-21 14:44:00', '2026-09-21 14:45:00', 'approved', '2026-09-21 07:43:28', '2026-09-21 07:43:28', 1),
(28, 1, '2026-09-21', '2026-09-21 14:46:00', '2026-09-21 14:47:00', 'approved', '2026-09-21 07:45:57', '2026-09-21 07:45:57', 1),
(29, 1, '2026-09-21', '2026-09-21 15:24:00', '2026-09-21 15:25:00', 'approved', '2026-09-21 08:24:02', '2026-09-21 08:24:02', 1),
(30, 1, '2026-09-21', '2026-09-21 15:25:00', '2026-09-21 15:26:00', 'approved', '2026-09-21 08:24:51', '2026-09-21 08:24:51', 1),
(31, 1, '2026-09-21', '2026-09-21 15:26:00', '2026-09-21 15:27:00', 'approved', '2026-09-21 08:26:08', '2026-09-21 08:26:08', 1),
(32, 1, '2026-09-21', '2026-09-21 15:37:00', '2026-09-21 15:38:00', 'approved', '2026-09-21 08:36:19', '2026-09-21 08:36:19', 1),
(33, 1, '2026-09-28', '2026-09-28 17:37:00', '2026-09-28 17:38:00', 'cancel_by_admin', '2026-09-28 10:35:40', '2026-09-28 10:36:37', 2),
(34, 2, '2026-09-28', '2026-09-28 17:40:00', '2026-09-28 17:41:00', 'cancel_by_admin', '2026-09-28 10:36:08', '2026-09-28 10:36:39', 2),
(35, 1, '2026-09-28', '2026-09-28 17:38:00', '2026-09-28 17:39:00', 'cancel_by_admin', '2026-09-28 10:37:01', '2026-09-28 10:37:06', 2),
(36, 1, '2026-09-28', '2026-09-28 17:40:00', '2026-09-28 17:41:00', 'cancel_by_admin', '2026-09-28 10:37:41', '2026-09-28 10:38:54', 2),
(37, 1, '2026-09-28', '2026-09-28 17:54:00', '2026-09-28 17:55:00', 'cancel_by_admin', '2026-09-28 10:53:27', '2026-09-28 10:54:58', 2),
(38, 1, '2026-09-28', '2026-09-28 18:03:00', '2026-09-28 18:05:00', 'approved', '2026-09-28 11:01:36', '2026-09-28 11:01:36', 1),
(39, 1, '2026-09-28', '2026-09-28 18:09:00', '2026-09-28 18:11:00', 'approved', '2026-09-28 11:07:38', '2026-09-28 11:07:38', 1),
(40, 1, '2026-09-28', '2026-09-28 18:17:00', '2026-09-28 18:19:00', 'cancel_by_admin', '2026-09-28 11:15:22', '2026-09-28 11:15:59', 2),
(41, 1, '2026-09-28', '2026-09-28 18:19:00', '2026-09-28 18:21:00', 'approved', '2026-09-28 11:17:22', '2026-09-28 11:17:22', 1),
(42, 2, '2026-09-28', '2026-09-28 18:52:00', '2026-09-28 18:53:00', 'approved', '2026-09-28 11:50:35', '2026-09-28 11:50:35', 1),
(43, 2, '2026-09-28', '2026-09-28 18:57:00', '2026-09-28 18:58:00', 'approved', '2026-09-28 11:55:58', '2026-09-28 11:55:58', 1),
(44, 2, '2026-09-28', '2026-09-28 18:59:00', '2026-09-28 19:00:00', 'cancel_by_admin', '2026-09-28 11:58:32', '2026-09-28 11:59:41', 2),
(45, 2, '2026-09-28', '2026-09-28 19:20:00', '2026-09-28 19:21:00', 'approved', '2026-09-28 12:18:23', '2026-09-28 12:18:23', 1);

--
-- Triggers `bookings`
--
DELIMITER $$
CREATE TRIGGER `trg_booking_update` BEFORE UPDATE ON `bookings` FOR EACH ROW BEGIN
  SET NEW.sync_version = OLD.sync_version + 1;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `booking_led_channel`
--

CREATE TABLE `booking_led_channel` (
  `id` int(11) NOT NULL,
  `booking_id` int(11) NOT NULL,
  `node_id` int(11) NOT NULL,
  `channel_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `sync_version` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `building`
--

CREATE TABLE `building` (
  `building_id` int(11) NOT NULL,
  `building_name` varchar(255) NOT NULL,
  `location` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `sync_version` int(11) NOT NULL DEFAULT 1,
  `status` enum('active','inactive') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `building`
--

INSERT INTO `building` (`building_id`, `building_name`, `location`, `created_at`, `updated_at`, `sync_version`, `status`) VALUES
(1, 'CP09', 'KKU', '2026-08-25 12:23:38', '2026-08-25 12:23:38', 1, 'active');

--
-- Triggers `building`
--
DELIMITER $$
CREATE TRIGGER `trg_building_update` BEFORE UPDATE ON `building` FOR EACH ROW BEGIN
  SET NEW.sync_version = OLD.sync_version + 1;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `building_detail`
--

CREATE TABLE `building_detail` (
  `building_id` int(11) NOT NULL,
  `cluster_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `sync_version` int(11) NOT NULL DEFAULT 1,
  `status` enum('active','inactive') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `building_detail`
--

INSERT INTO `building_detail` (`building_id`, `cluster_id`, `created_at`, `updated_at`, `sync_version`, `status`) VALUES
(1, 1, '2026-08-25 12:23:46', '2026-08-25 12:23:46', 1, 'active');

--
-- Triggers `building_detail`
--
DELIMITER $$
CREATE TRIGGER `trg_building_detail_update` BEFORE UPDATE ON `building_detail` FOR EACH ROW BEGIN
  SET NEW.sync_version = OLD.sync_version + 1;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cluster`
--

CREATE TABLE `cluster` (
  `cluster_id` int(11) NOT NULL,
  `cluster_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `sync_version` int(11) NOT NULL DEFAULT 1,
  `status` enum('active','inactive') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cluster`
--

INSERT INTO `cluster` (`cluster_id`, `cluster_name`, `created_at`, `updated_at`, `sync_version`, `status`) VALUES
(1, 'Cluster 6', '2026-08-25 12:23:46', '2026-08-25 12:23:46', 1, 'active');

--
-- Triggers `cluster`
--
DELIMITER $$
CREATE TRIGGER `trg_cluster_update` BEFORE UPDATE ON `cluster` FOR EACH ROW BEGIN
  SET NEW.sync_version = OLD.sync_version + 1;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cluster_booking_node_map`
--

CREATE TABLE `cluster_booking_node_map` (
  `booking_id` int(11) NOT NULL,
  `node_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `sync_version` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cluster_booking_node_map`
--

INSERT INTO `cluster_booking_node_map` (`booking_id`, `node_id`, `created_at`, `updated_at`, `sync_version`) VALUES
(1, 1, '2026-08-26 04:04:44', '2026-08-26 04:04:44', 1),
(1, 2, '2026-08-26 04:04:44', '2026-08-26 04:04:44', 1),
(1, 3, '2026-08-26 04:04:44', '2026-08-26 04:04:44', 1),
(1, 4, '2026-08-26 04:04:44', '2026-08-26 04:04:44', 1),
(1, 5, '2026-08-26 04:04:44', '2026-08-26 04:04:44', 1),
(1, 7, '2026-08-26 04:04:44', '2026-08-26 04:04:44', 1),
(1, 8, '2026-08-26 04:04:44', '2026-08-26 04:04:44', 1),
(1, 9, '2026-08-26 04:04:44', '2026-08-26 04:04:44', 1),
(2, 1, '2026-08-26 09:21:34', '2026-08-26 09:21:34', 1),
(2, 2, '2026-08-26 09:21:34', '2026-08-26 09:21:34', 1),
(2, 3, '2026-08-26 09:21:34', '2026-08-26 09:21:34', 1),
(2, 4, '2026-08-26 09:21:34', '2026-08-26 09:21:34', 1),
(2, 5, '2026-08-26 09:21:34', '2026-08-26 09:21:34', 1),
(2, 7, '2026-08-26 09:21:34', '2026-08-26 09:21:34', 1),
(2, 8, '2026-08-26 09:21:34', '2026-08-26 09:21:34', 1),
(2, 9, '2026-08-26 09:21:34', '2026-08-26 09:21:34', 1),
(3, 1, '2026-08-26 09:35:50', '2026-08-26 09:35:50', 1),
(3, 2, '2026-08-26 09:35:50', '2026-08-26 09:35:50', 1),
(3, 3, '2026-08-26 09:35:50', '2026-08-26 09:35:50', 1),
(3, 4, '2026-08-26 09:35:50', '2026-08-26 09:35:50', 1),
(3, 5, '2026-08-26 09:35:50', '2026-08-26 09:35:50', 1),
(3, 7, '2026-08-26 09:35:50', '2026-08-26 09:35:50', 1),
(3, 8, '2026-08-26 09:35:50', '2026-08-26 09:35:50', 1),
(3, 9, '2026-08-26 09:35:50', '2026-08-26 09:35:50', 1),
(4, 1, '2026-08-26 09:39:21', '2026-08-26 09:39:21', 1),
(4, 2, '2026-08-26 09:39:21', '2026-08-26 09:39:21', 1),
(4, 3, '2026-08-26 09:39:21', '2026-08-26 09:39:21', 1),
(4, 4, '2026-08-26 09:39:21', '2026-08-26 09:39:21', 1),
(4, 5, '2026-08-26 09:39:21', '2026-08-26 09:39:21', 1),
(4, 7, '2026-08-26 09:39:21', '2026-08-26 09:39:21', 1),
(4, 8, '2026-08-26 09:39:21', '2026-08-26 09:39:21', 1),
(4, 9, '2026-08-26 09:39:21', '2026-08-26 09:39:21', 1),
(5, 1, '2026-08-26 09:43:20', '2026-08-26 09:43:20', 1),
(5, 2, '2026-08-26 09:43:20', '2026-08-26 09:43:20', 1),
(5, 3, '2026-08-26 09:43:20', '2026-08-26 09:43:20', 1),
(5, 4, '2026-08-26 09:43:20', '2026-08-26 09:43:20', 1),
(5, 5, '2026-08-26 09:43:20', '2026-08-26 09:43:20', 1),
(5, 7, '2026-08-26 09:43:20', '2026-08-26 09:43:20', 1),
(5, 8, '2026-08-26 09:43:20', '2026-08-26 09:43:20', 1),
(5, 9, '2026-08-26 09:43:20', '2026-08-26 09:43:20', 1),
(6, 7, '2026-08-26 09:48:42', '2026-08-26 09:48:42', 1),
(8, 1, '2026-08-26 09:52:28', '2026-08-26 09:52:28', 1),
(8, 2, '2026-08-26 09:52:28', '2026-08-26 09:52:28', 1),
(8, 3, '2026-08-26 09:52:28', '2026-08-26 09:52:28', 1),
(8, 4, '2026-08-26 09:52:28', '2026-08-26 09:52:28', 1),
(8, 5, '2026-08-26 09:52:28', '2026-08-26 09:52:28', 1),
(8, 7, '2026-08-26 09:52:28', '2026-08-26 09:52:28', 1),
(8, 8, '2026-08-26 09:52:28', '2026-08-26 09:52:28', 1),
(8, 9, '2026-08-26 09:52:28', '2026-08-26 09:52:28', 1),
(9, 1, '2026-08-26 10:09:58', '2026-08-26 10:09:58', 1),
(9, 2, '2026-08-26 10:09:58', '2026-08-26 10:09:58', 1),
(9, 3, '2026-08-26 10:09:58', '2026-08-26 10:09:58', 1),
(9, 4, '2026-08-26 10:09:58', '2026-08-26 10:09:58', 1),
(9, 5, '2026-08-26 10:09:58', '2026-08-26 10:09:58', 1),
(9, 7, '2026-08-26 10:09:58', '2026-08-26 10:09:58', 1),
(9, 8, '2026-08-26 10:09:58', '2026-08-26 10:09:58', 1),
(9, 9, '2026-08-26 10:09:58', '2026-08-26 10:09:58', 1),
(10, 2, '2026-08-26 10:12:16', '2026-08-26 10:12:16', 1),
(10, 3, '2026-08-26 10:12:16', '2026-08-26 10:12:16', 1),
(10, 7, '2026-08-26 10:12:16', '2026-08-26 10:12:16', 1),
(10, 8, '2026-08-26 10:12:16', '2026-08-26 10:12:16', 1),
(10, 9, '2026-08-26 10:12:16', '2026-08-26 10:12:16', 1),
(11, 4, '2026-08-26 12:35:27', '2026-08-26 12:35:27', 1),
(12, 2, '2026-08-26 12:36:36', '2026-08-26 12:36:36', 1),
(13, 1, '2026-08-26 12:37:20', '2026-08-26 12:37:20', 1),
(13, 3, '2026-08-26 12:37:20', '2026-08-26 12:37:20', 1),
(14, 4, '2026-08-27 02:05:06', '2026-08-27 02:05:06', 1),
(15, 7, '2026-08-27 02:10:33', '2026-08-27 02:10:33', 1),
(16, 1, '2026-08-27 02:21:11', '2026-08-27 02:21:11', 1),
(18, 1, '2026-08-27 02:30:54', '2026-08-27 02:30:54', 1),
(18, 2, '2026-08-27 02:30:54', '2026-08-27 02:30:54', 1),
(18, 3, '2026-08-27 02:30:54', '2026-08-27 02:30:54', 1),
(18, 4, '2026-08-27 02:30:54', '2026-08-27 02:30:54', 1),
(18, 5, '2026-08-27 02:30:54', '2026-08-27 02:30:54', 1),
(18, 7, '2026-08-27 02:30:54', '2026-08-27 02:30:54', 1),
(18, 8, '2026-08-27 02:30:54', '2026-08-27 02:30:54', 1),
(18, 9, '2026-08-27 02:30:54', '2026-08-27 02:30:54', 1),
(19, 1, '2026-08-27 03:41:08', '2026-08-27 03:41:08', 1),
(19, 2, '2026-08-27 03:41:08', '2026-08-27 03:41:08', 1),
(19, 3, '2026-08-27 03:41:08', '2026-08-27 03:41:08', 1),
(19, 4, '2026-08-27 03:41:08', '2026-08-27 03:41:08', 1),
(19, 5, '2026-08-27 03:41:08', '2026-08-27 03:41:08', 1),
(19, 7, '2026-08-27 03:41:08', '2026-08-27 03:41:08', 1),
(19, 8, '2026-08-27 03:41:08', '2026-08-27 03:41:08', 1),
(19, 9, '2026-08-27 03:41:08', '2026-08-27 03:41:08', 1),
(20, 2, '2026-08-27 03:46:53', '2026-08-27 03:46:53', 1),
(20, 8, '2026-08-27 03:46:53', '2026-08-27 03:46:53', 1),
(21, 5, '2026-08-27 03:49:27', '2026-08-27 03:49:27', 1),
(22, 1, '2026-08-27 03:55:14', '2026-08-27 03:55:14', 1),
(22, 2, '2026-08-27 03:55:14', '2026-08-27 03:55:14', 1),
(22, 3, '2026-08-27 03:55:14', '2026-08-27 03:55:14', 1),
(22, 4, '2026-08-27 03:55:14', '2026-08-27 03:55:14', 1),
(22, 5, '2026-08-27 03:55:14', '2026-08-27 03:55:14', 1),
(22, 7, '2026-08-27 03:55:14', '2026-08-27 03:55:14', 1),
(22, 8, '2026-08-27 03:55:14', '2026-08-27 03:55:14', 1),
(22, 9, '2026-08-27 03:55:14', '2026-08-27 03:55:14', 1),
(23, 1, '2026-08-27 04:39:46', '2026-08-27 04:39:46', 1),
(23, 2, '2026-08-27 04:39:46', '2026-08-27 04:39:46', 1),
(23, 3, '2026-08-27 04:39:46', '2026-08-27 04:39:46', 1),
(23, 4, '2026-08-27 04:39:46', '2026-08-27 04:39:46', 1),
(23, 5, '2026-08-27 04:39:46', '2026-08-27 04:39:46', 1),
(23, 7, '2026-08-27 04:39:46', '2026-08-27 04:39:46', 1),
(23, 8, '2026-08-27 04:39:46', '2026-08-27 04:39:46', 1),
(23, 9, '2026-08-27 04:39:46', '2026-08-27 04:39:46', 1),
(24, 1, '2026-09-03 16:57:19', '2026-09-03 16:57:19', 1),
(26, 1, '2026-09-21 07:34:43', '2026-09-21 07:34:43', 1),
(26, 7, '2026-09-21 07:34:43', '2026-09-21 07:34:43', 1),
(27, 1, '2026-09-21 07:43:28', '2026-09-21 07:43:28', 1),
(28, 1, '2026-09-21 07:45:57', '2026-09-21 07:45:57', 1),
(29, 1, '2026-09-21 08:24:02', '2026-09-21 08:24:02', 1),
(29, 3, '2026-09-21 08:24:02', '2026-09-21 08:24:02', 1),
(30, 1, '2026-09-21 08:24:51', '2026-09-21 08:24:51', 1),
(31, 1, '2026-09-21 08:26:08', '2026-09-21 08:26:08', 1),
(32, 1, '2026-09-21 08:36:19', '2026-09-21 08:36:19', 1),
(32, 7, '2026-09-21 08:36:19', '2026-09-21 08:36:19', 1),
(38, 2, '2026-09-28 11:01:36', '2026-09-28 11:01:36', 1),
(38, 3, '2026-09-28 11:01:36', '2026-09-28 11:01:36', 1),
(38, 4, '2026-09-28 11:01:36', '2026-09-28 11:01:36', 1),
(38, 5, '2026-09-28 11:01:36', '2026-09-28 11:01:36', 1),
(39, 2, '2026-09-28 11:07:38', '2026-09-28 11:07:38', 1),
(39, 3, '2026-09-28 11:07:38', '2026-09-28 11:07:38', 1),
(39, 4, '2026-09-28 11:07:38', '2026-09-28 11:07:38', 1),
(39, 5, '2026-09-28 11:07:38', '2026-09-28 11:07:38', 1),
(41, 2, '2026-09-28 11:17:22', '2026-09-28 11:17:22', 1),
(41, 3, '2026-09-28 11:17:22', '2026-09-28 11:17:22', 1),
(41, 4, '2026-09-28 11:17:22', '2026-09-28 11:17:22', 1),
(41, 5, '2026-09-28 11:17:22', '2026-09-28 11:17:22', 1),
(42, 1, '2026-09-28 11:50:35', '2026-09-28 11:50:35', 1),
(42, 7, '2026-09-28 11:50:35', '2026-09-28 11:50:35', 1),
(43, 1, '2026-09-28 11:55:58', '2026-09-28 11:55:58', 1),
(43, 7, '2026-09-28 11:55:58', '2026-09-28 11:55:58', 1),
(45, 1, '2026-09-28 12:18:23', '2026-09-28 12:18:23', 1),
(45, 7, '2026-09-28 12:18:23', '2026-09-28 12:18:23', 1);

--
-- Triggers `cluster_booking_node_map`
--
DELIMITER $$
CREATE TRIGGER `trg_cluster_booking_node_map_update` BEFORE UPDATE ON `cluster_booking_node_map` FOR EACH ROW BEGIN
    SET NEW.sync_version = OLD.sync_version + 1;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cluster_detail`
--

CREATE TABLE `cluster_detail` (
  `cluster_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `sync_version` int(11) NOT NULL DEFAULT 1,
  `status` enum('active','inactive') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cluster_detail`
--

INSERT INTO `cluster_detail` (`cluster_id`, `room_id`, `created_at`, `updated_at`, `sync_version`, `status`) VALUES
(1, 1, '2026-08-25 12:24:03', '2026-08-25 12:24:03', 1, 'active'),
(1, 2, '2026-09-28 09:32:11', '2026-09-28 09:32:11', 1, 'active');

--
-- Triggers `cluster_detail`
--
DELIMITER $$
CREATE TRIGGER `trg_cluster_detail_update` BEFORE UPDATE ON `cluster_detail` FOR EACH ROW BEGIN
    SET NEW.sync_version = OLD.sync_version + 1;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `config_air`
--

CREATE TABLE `config_air` (
  `config_air_id` int(11) NOT NULL,
  `node_id` int(11) NOT NULL,
  `rm_air_ip` varchar(255) NOT NULL,
  `rm_air_mac` varchar(17) NOT NULL,
  `ir_command_air_on` text NOT NULL,
  `ir_command_air_off` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `sync_version` int(11) NOT NULL DEFAULT 1,
  `status` enum('active','inactive') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `config_air`
--

INSERT INTO `config_air` (`config_air_id`, `node_id`, `rm_air_ip`, `rm_air_mac`, `ir_command_air_on`, `ir_command_air_off`, `created_at`, `updated_at`, `sync_version`, `status`) VALUES
(1, 3, '192.168.1.103', '34EA34B50B56', '26006c01a7450e390e160d160e160d3a0d160e160d160e160d390e160e390e390e150e390e390e390e390e390e160d390e160e160d160e160d160e150e390e390e160e150e160e150e160d3a0d160e160d160e160d160e160d160e160d160e160d160e150e160e150e390e390e390e390e160d160e160d0003c5a8450d3a0e150e160d160e390e160d160e160d160e390e150e390e390e160e390e390d3a0d3a0d3a0d160e390e160d160e160d160e150e160e390e390e150e160e150e160d160e160d160e160d160e160d160e390e390e160d160e390e390e390e150e160e150e160d160e160d160e160d160e390e160d160e160d160e390e160d160e150e160e150e160e150e160e150e160e150e160d160e160d160e160d160e160d160e160d160e390e390e150e160e150e160e390e390e150e390e160d3a0d160e160d160e160d160e160d160e150e160e150e160e150e160e150e390e160d160e160d160e390e390e390e390e160d160e000d05000000000000000000000000', '26006c01a6460e390e160d160d170d3a0d160e160d160e160d3a0d160d3a0e390e160d390d3a0e390e390e390e160d3a0d160e160d160d170d160d170c3b0c3b0d160d170c170d170c170e390d160d170d160d170d160d170c170e160c170e160c170e160d160d170d3a0d390e390e390e160d160e160d0003c5a7460e390e150e160e150e390e160c170d170d160e390e160d3a0d3a0d160d3a0e390e390e390d3a0d160d3a0e160d160e160c170d170c170e390e390e160d160e160c170d170d160e160d160e150e160d160d3a0d3a0e160d160e390e390e390e160c170e160d160d170c170e150d170e150e160d160e160d160e160d3a0d160e160c170d170d160e160d160e160d160e160d160d170d160e160d160e150e160d160e160d160e160d3a0d3a0d160e160d160e160d3a0d3a0d160e390d170d390e160d160e160d160e160d160e160c170e160d160e160d160e160d160e390e160d160d3a0e390e150e390e390e390e160d160e000d05000000000000000000000000', '2026-08-25 12:32:10', '2026-08-25 12:32:10', 1, 'active'),
(2, 9, '192.168.1.104', '34ea34431193', '26006c01a7450e390e160d160e160d3a0d160e160d160e160d390e160e390e390e150e390e390e390e390e390e160d390e160e160d160e160d160e150e390e390e160e150e160e150e160d3a0d160e160d160e160d160e160d160e160d160e160d160e150e160e150e390e390e390e390e160d160e160d0003c5a8450d3a0e150e160d160e390e160d160e160d160e390e150e390e390e160e390e390d3a0d3a0d3a0d160e390e160d160e160d160e150e160e390e390e150e160e150e160d160e160d160e160d160e160d160e390e390e160d160e390e390e390e150e160e150e160d160e160d160e160d160e390e160d160e160d160e390e160d160e150e160e150e160e150e160e150e160e150e160d160e160d160e160d160e160d160e160d160e390e390e150e160e150e160e390e390e150e390e160d3a0d160e160d160e160d160e160d160e150e160e150e160e150e160e150e390e160d160e160d160e390e390e390e390e160d160e000d05000000000000000000000000', '26006c01a6460e390e160d160d170d3a0d160e160d160e160d3a0d160d3a0e390e160d390d3a0e390e390e390e160d3a0d160e160d160d170d160d170c3b0c3b0d160d170c170d170c170e390d160d170d160d170d160d170c170e160c170e160c170e160d160d170d3a0d390e390e390e160d160e160d0003c5a7460e390e150e160e150e390e160c170d170d160e390e160d3a0d3a0d160d3a0e390e390e390d3a0d160d3a0e160d160e160c170d170c170e390e390e160d160e160c170d170d160e160d160e150e160d160d3a0d3a0e160d160e390e390e390e160c170e160d160d170c170e150d170e150e160d160e160d160e160d3a0d160e160c170d170d160e160d160e160d160e160d160d170d160e160d160e150e160d160e160d160e160d3a0d3a0d160e160d160e160d3a0d3a0d160e390d170d390e160d160e160d160e160d160e160c170e160d160e160d160e160d160e390e160d160d3a0e390e150e390e390e390e160d160e000d05000000000000000000000000', '2026-08-25 12:35:12', '2026-09-28 09:30:39', 2, 'inactive');

--
-- Triggers `config_air`
--
DELIMITER $$
CREATE TRIGGER `trg_config_air_update` BEFORE UPDATE ON `config_air` FOR EACH ROW BEGIN
  SET NEW.sync_version = OLD.sync_version + 1;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `config_audio_equipment`
--

CREATE TABLE `config_audio_equipment` (
  `config_audio_id` int(11) NOT NULL,
  `node_id` int(11) NOT NULL,
  `command_audio_on` text NOT NULL,
  `command_audio_off` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `mqtt_broker` varchar(255) NOT NULL,
  `mqtt_port` int(11) NOT NULL,
  `sync_version` int(11) NOT NULL DEFAULT 1,
  `status` enum('active','inactive') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `config_audio_equipment`
--

INSERT INTO `config_audio_equipment` (`config_audio_id`, `node_id`, `command_audio_on`, `command_audio_off`, `created_at`, `updated_at`, `mqtt_broker`, `mqtt_port`, `sync_version`, `status`) VALUES
(1, 4, 'on', 'off', '2026-08-25 12:32:27', '2026-08-25 12:32:27', '192.168.1.101', 1883, 1, 'active');

--
-- Triggers `config_audio_equipment`
--
DELIMITER $$
CREATE TRIGGER `trg_config_audio_equipment_update` BEFORE UPDATE ON `config_audio_equipment` FOR EACH ROW BEGIN
  SET NEW.sync_version = OLD.sync_version + 1;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `config_computer`
--

CREATE TABLE `config_computer` (
  `config_com_id` int(11) NOT NULL,
  `node_id` int(11) NOT NULL,
  `ip_address` varchar(255) NOT NULL,
  `port_on` int(11) NOT NULL DEFAULT 0,
  `port_off` int(11) NOT NULL DEFAULT 0,
  `command_com_on` text DEFAULT NULL,
  `command_com_off` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `mqtt_broker` varchar(255) DEFAULT NULL,
  `mqtt_port` int(11) DEFAULT NULL,
  `sync_version` int(11) NOT NULL DEFAULT 1,
  `status` enum('active','inactive') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `config_computer`
--

INSERT INTO `config_computer` (`config_com_id`, `node_id`, `ip_address`, `port_on`, `port_off`, `command_com_on`, `command_com_off`, `created_at`, `updated_at`, `mqtt_broker`, `mqtt_port`, `sync_version`, `status`) VALUES
(1, 5, '192.168.1.109', 0, 5000, 'on', 'shutdown', '2026-08-25 12:33:05', '2026-08-25 12:33:05', '192.168.1.101', 1883, 1, 'active'),
(2, 6, '192.168.1.108', 0, 5000, NULL, 'shutdown', '2026-08-25 12:33:23', '2026-08-25 12:33:23', NULL, NULL, 1, 'active');

--
-- Triggers `config_computer`
--
DELIMITER $$
CREATE TRIGGER `trg_config_computer_update` BEFORE UPDATE ON `config_computer` FOR EACH ROW BEGIN
  SET NEW.sync_version = OLD.sync_version + 1;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `config_door`
--

CREATE TABLE `config_door` (
  `node_id` int(11) NOT NULL,
  `mqtt_broker` varchar(255) NOT NULL,
  `mqtt_port` int(11) NOT NULL,
  `command_door_open` varchar(255) NOT NULL,
  `command_door_close` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `sync_version` int(11) NOT NULL DEFAULT 1,
  `status` enum('active','inactive') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `config_door`
--

INSERT INTO `config_door` (`node_id`, `mqtt_broker`, `mqtt_port`, `command_door_open`, `command_door_close`, `created_at`, `updated_at`, `sync_version`, `status`) VALUES
(7, '192.168.1.101', 1883, 'on', 'off', '2026-09-28 10:51:20', '2026-09-28 10:51:20', 1, 'active');

--
-- Triggers `config_door`
--
DELIMITER $$
CREATE TRIGGER `trg_config_door_update` BEFORE UPDATE ON `config_door` FOR EACH ROW BEGIN
  SET NEW.sync_version = OLD.sync_version + 1;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `config_led`
--

CREATE TABLE `config_led` (
  `config_led_id` int(11) NOT NULL,
  `node_id` int(11) NOT NULL,
  `mqtt_broker` varchar(255) NOT NULL,
  `mqtt_port` int(11) NOT NULL,
  `command_led_on` text NOT NULL,
  `command_led_off` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `sync_version` int(11) NOT NULL DEFAULT 1,
  `status` enum('active','inactive') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `config_led`
--

INSERT INTO `config_led` (`config_led_id`, `node_id`, `mqtt_broker`, `mqtt_port`, `command_led_on`, `command_led_off`, `created_at`, `updated_at`, `sync_version`, `status`) VALUES
(2, 10, '192.168.1.101', 1883, 'on', 'off', '2026-09-21 07:54:06', '2026-09-21 07:54:06', 1, 'active'),
(4, 1, '192.168.1.101', 1883, 'on', 'off', '2026-09-28 10:50:24', '2026-09-28 10:50:24', 1, 'active');

--
-- Triggers `config_led`
--
DELIMITER $$
CREATE TRIGGER `trg_config_led_update` BEFORE UPDATE ON `config_led` FOR EACH ROW BEGIN
  SET NEW.sync_version = OLD.sync_version + 1;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `config_projector`
--

CREATE TABLE `config_projector` (
  `config_pro_id` int(11) NOT NULL,
  `node_id` int(11) NOT NULL,
  `rm_pro_ip` varchar(255) NOT NULL,
  `rm_pro_mac` varchar(17) NOT NULL,
  `ir_command_pro_on` text NOT NULL,
  `ir_command_pro_off` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `sync_version` int(11) NOT NULL DEFAULT 1,
  `status` enum('active','inactive') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `config_projector`
--

INSERT INTO `config_projector` (`config_pro_id`, `node_id`, `rm_pro_ip`, `rm_pro_mac`, `ir_command_pro_on`, `ir_command_pro_off`, `created_at`, `updated_at`, `sync_version`, `status`) VALUES
(1, 2, '192.168.1.103', '34EA34B50B56', '2600d800000128951213121312391213121412131213123912131213123912131239123812391238123912381213123912131213131312131213121412381213123912381239123813000548000127961213121312391213121312141213123812141213123912131238123912381239123812391213123812141213121312141312121312391213123912381437133712000548000128951412121312381214121312131214123812131214133712131239123812391238123912381214123812131214121312131214121312381214123812391238123912000d05', '26009000000128951213121412381213121412131213123912131213123912131239123812391238123912381214123812131214121312131214111412381214123812391238123912000548000128951411121412381411121412131213143712131213123914111239123812391238123912381213123914111213121412131213121412381213143712381239123812000d050000000000000000', '2026-08-25 12:31:39', '2026-08-25 12:31:39', 1, 'active'),
(2, 8, '192.168.1.104', '34ea34431193', '2600d800000128951213121312391213121412131213123912131213123912131239123812391238123912381213123912131213131312131213121412381213123912381239123813000548000127961213121312391213121312141213123812141213123912131238123912381239123812391213123812141213121312141312121312391213123912381437133712000548000128951412121312381214121312131214123812131214133712131239123812391238123912381214123812131214121312131214121312381214123812391238123912000d05', '26009000000128951213121412381213121412131213123912131213123912131239123812391238123912381214123812131214121312131214111412381214123812391238123912000548000128951411121412381411121412131213143712131213123914111239123812391238123912381213123914111213121412131213121412381213143712381239123812000d050000000000000000', '2026-08-25 12:34:44', '2026-09-28 09:31:00', 2, 'inactive');

--
-- Triggers `config_projector`
--
DELIMITER $$
CREATE TRIGGER `trg_config_projector_update` BEFORE UPDATE ON `config_projector` FOR EACH ROW BEGIN
  SET NEW.sync_version = OLD.sync_version + 1;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `device_channel`
--

CREATE TABLE `device_channel` (
  `id` int(11) NOT NULL,
  `node_id` int(11) NOT NULL,
  `device_type` varchar(50) NOT NULL,
  `gpio` varchar(20) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `device_channel`
--

INSERT INTO `device_channel` (`id`, `node_id`, `device_type`, `gpio`, `name`, `is_active`, `created_at`, `updated_at`) VALUES
(5, 10, 'led', '0', 'ไฟห้อง 9425', 0, '2026-09-21 08:01:57', '2026-09-21 08:20:06');

--
-- Triggers `device_channel`
--
DELIMITER $$
CREATE TRIGGER `auto_create_channel_status` AFTER INSERT ON `device_channel` FOR EACH ROW BEGIN
    INSERT INTO device_channel_status(channel_id,status,updated_at)
    VALUES (NEW.id,'off',NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `auto_create_device_status` AFTER INSERT ON `device_channel` FOR EACH ROW INSERT INTO device_status (node_id, channel, status, updated_at)
VALUES (NEW.node_id, NEW.id, 'off', NOW())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `device_channel_status`
--

CREATE TABLE `device_channel_status` (
  `id` int(11) NOT NULL,
  `channel_id` int(11) NOT NULL,
  `status` enum('on','off') DEFAULT 'off',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `device_channel_status`
--

INSERT INTO `device_channel_status` (`id`, `channel_id`, `status`, `updated_at`) VALUES
(5, 5, 'off', '2026-09-21 08:01:57');

-- --------------------------------------------------------

--
-- Table structure for table `device_status`
--

CREATE TABLE `device_status` (
  `id` int(11) NOT NULL,
  `node_id` int(11) NOT NULL,
  `channel` int(11) NOT NULL DEFAULT 0,
  `status` enum('on','off') DEFAULT 'off',
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `device_status`
--

INSERT INTO `device_status` (`id`, `node_id`, `channel`, `status`, `updated_at`) VALUES
(2, 2, 0, 'off', '2026-09-28 18:21:00'),
(3, 3, 0, 'off', '2026-09-28 18:21:00'),
(4, 4, 0, 'off', '2026-09-28 18:21:00'),
(5, 5, 0, 'off', '2026-09-28 18:21:55'),
(6, 6, 0, 'off', '2026-09-28 18:21:03'),
(760, 1, 2, 'off', '2026-09-28 17:04:34'),
(764, 7, 0, 'off', '2026-09-28 19:20:59'),
(809, 1, 0, 'off', '2026-09-28 19:20:59');

-- --------------------------------------------------------

--
-- Table structure for table `installation_node`
--

CREATE TABLE `installation_node` (
  `room_id` int(11) NOT NULL,
  `node_id` int(11) NOT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `sync_version` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `installation_node`
--

INSERT INTO `installation_node` (`room_id`, `node_id`, `status`, `created_at`, `updated_at`, `sync_version`) VALUES
(1, 2, 'active', '2026-08-25 12:25:39', '2026-08-25 12:25:39', 1),
(1, 3, 'active', '2026-08-25 12:26:20', '2026-08-25 12:26:20', 1),
(1, 4, 'active', '2026-08-25 12:26:51', '2026-08-25 12:26:51', 1),
(1, 5, 'active', '2026-08-25 12:27:25', '2026-08-25 12:27:25', 1),
(1, 6, 'active', '2026-08-25 12:27:57', '2026-08-25 12:27:57', 1),
(1, 8, 'inactive', '2026-08-25 12:28:54', '2026-09-28 09:31:00', 2),
(1, 9, 'inactive', '2026-08-25 12:29:31', '2026-09-28 09:30:39', 2),
(1, 10, 'active', '2026-09-21 07:53:44', '2026-09-21 07:53:44', 1),
(2, 1, 'active', '2026-09-28 09:32:59', '2026-09-28 10:00:51', 2),
(2, 7, 'active', '2026-09-28 09:33:58', '2026-09-28 10:00:51', 2);

--
-- Triggers `installation_node`
--
DELIMITER $$
CREATE TRIGGER `trg_installation_node_update` BEFORE UPDATE ON `installation_node` FOR EACH ROW BEGIN
  SET NEW.sync_version = OLD.sync_version + 1;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `node`
--

CREATE TABLE `node` (
  `node_id` int(11) NOT NULL,
  `node_type` enum('led','projector','air_conditioner','audio_equipment','computer','door') NOT NULL,
  `detail` varchar(255) DEFAULT NULL,
  `node_name` varchar(255) NOT NULL,
  `node_status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `sync_version` int(11) NOT NULL DEFAULT 1,
  `computer_role` enum('teacher','student') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `node`
--

INSERT INTO `node` (`node_id`, `node_type`, `detail`, `node_name`, `node_status`, `created_at`, `updated_at`, `sync_version`, `computer_role`) VALUES
(1, 'led', 'ไฟห้องCP9425', 'led', 'active', '2026-09-28 09:32:59', '2026-09-28 09:32:59', 1, NULL),
(2, 'projector', 'โปรเจคเตอร์9604', 'Projector9604', 'active', '2026-08-25 12:25:39', '2026-09-28 11:05:55', 4, ''),
(3, 'air_conditioner', 'เครื่องปรับอากาศ9604', 'Air_conditioner_9604', 'active', '2026-08-25 12:26:20', '2026-09-28 11:05:41', 5, ''),
(4, 'audio_equipment', 'ปลั๊กสำหรับเครื่องเสียงcp9604', 'AudioEquipment9604', 'active', '2026-08-25 12:26:51', '2026-09-28 11:06:23', 6, ''),
(5, 'computer', 'คอมพิวเตอร์อาจารย์ตัวที่ 1', 'Computer9604_tch', 'active', '2026-08-25 12:27:25', '2026-09-28 11:05:28', 3, 'teacher'),
(6, 'computer', 'คอมพิวเตอร์นักศึกษาตัวที่ 1', 'Computer9604_st', 'active', '2026-08-25 12:27:57', '2026-09-28 11:06:10', 3, 'student'),
(7, 'door', 'ประตูห้อง9425', 'Door9425', 'active', '2026-09-28 09:33:58', '2026-09-28 09:33:58', 1, NULL),
(8, 'projector', 'โปรเจคเตอร์9425_2', 'Projector9425_2', 'inactive', '2026-08-25 12:28:54', '2026-09-28 09:31:00', 4, NULL),
(9, 'air_conditioner', 'เครื่องปรับอากาศ9425_2', 'Air_conditioner_9425_2', 'inactive', '2026-08-25 12:29:31', '2026-09-28 09:30:39', 4, NULL),
(10, 'led', 'ไฟห้อง9425', 'LED9425', 'inactive', '2026-09-21 07:53:44', '2026-09-21 08:19:45', 2, NULL);

--
-- Triggers `node`
--
DELIMITER $$
CREATE TRIGGER `trg_node_update` BEFORE UPDATE ON `node` FOR EACH ROW BEGIN
  SET NEW.sync_version = OLD.sync_version + 1;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `room`
--

CREATE TABLE `room` (
  `room_id` int(11) NOT NULL,
  `room_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `floor_number` int(11) DEFAULT NULL,
  `room_type` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `sync_version` int(11) NOT NULL DEFAULT 1,
  `status` enum('active','inactive') DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `room`
--

INSERT INTO `room` (`room_id`, `room_name`, `floor_number`, `room_type`, `created_at`, `sync_version`, `status`) VALUES
(1, 'CP9604', 6, 'LAB', '2026-08-25 12:24:03', 1, 'active'),
(2, 'CP9425', 4, 'LAB', '2026-09-28 09:32:11', 1, 'active');

-- --------------------------------------------------------

--
-- Table structure for table `room_mapping`
--

CREATE TABLE `room_mapping` (
  `booking_room_id` int(11) NOT NULL,
  `project_room_id` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `sync_version` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `room_mapping`
--
DELIMITER $$
CREATE TRIGGER `trg_room_mapping_update` BEFORE UPDATE ON `room_mapping` FOR EACH ROW BEGIN
    SET NEW.sync_version = OLD.sync_version + 1;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_room_time` (`room_id`,`start_time`,`end_time`);

--
-- Indexes for table `booking_led_channel`
--
ALTER TABLE `booking_led_channel`
  ADD PRIMARY KEY (`id`),
  ADD KEY `booking_id` (`booking_id`),
  ADD KEY `node_id` (`node_id`),
  ADD KEY `channel_id` (`channel_id`);

--
-- Indexes for table `building`
--
ALTER TABLE `building`
  ADD PRIMARY KEY (`building_id`);

--
-- Indexes for table `building_detail`
--
ALTER TABLE `building_detail`
  ADD PRIMARY KEY (`building_id`,`cluster_id`),
  ADD KEY `cluster_id` (`cluster_id`);

--
-- Indexes for table `cluster`
--
ALTER TABLE `cluster`
  ADD PRIMARY KEY (`cluster_id`);

--
-- Indexes for table `cluster_booking_node_map`
--
ALTER TABLE `cluster_booking_node_map`
  ADD PRIMARY KEY (`booking_id`,`node_id`);

--
-- Indexes for table `cluster_detail`
--
ALTER TABLE `cluster_detail`
  ADD PRIMARY KEY (`cluster_id`,`room_id`),
  ADD KEY `room_id` (`room_id`);

--
-- Indexes for table `config_air`
--
ALTER TABLE `config_air`
  ADD PRIMARY KEY (`config_air_id`),
  ADD KEY `node_id` (`node_id`);

--
-- Indexes for table `config_audio_equipment`
--
ALTER TABLE `config_audio_equipment`
  ADD PRIMARY KEY (`config_audio_id`),
  ADD KEY `node_id` (`node_id`);

--
-- Indexes for table `config_computer`
--
ALTER TABLE `config_computer`
  ADD PRIMARY KEY (`config_com_id`),
  ADD KEY `node_id` (`node_id`);

--
-- Indexes for table `config_door`
--
ALTER TABLE `config_door`
  ADD PRIMARY KEY (`node_id`);

--
-- Indexes for table `config_led`
--
ALTER TABLE `config_led`
  ADD PRIMARY KEY (`config_led_id`),
  ADD KEY `node_id` (`node_id`);

--
-- Indexes for table `config_projector`
--
ALTER TABLE `config_projector`
  ADD PRIMARY KEY (`config_pro_id`),
  ADD KEY `node_id` (`node_id`);

--
-- Indexes for table `device_channel`
--
ALTER TABLE `device_channel`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_node_channel` (`node_id`,`gpio`);

--
-- Indexes for table `device_channel_status`
--
ALTER TABLE `device_channel_status`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `channel_id` (`channel_id`);

--
-- Indexes for table `device_status`
--
ALTER TABLE `device_status`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_node_channel` (`node_id`,`channel`),
  ADD KEY `fk_device_status_channel` (`channel`),
  ADD KEY `idx_device_status_node_channel` (`node_id`,`channel`),
  ADD KEY `idx_device_status_node` (`node_id`);

--
-- Indexes for table `installation_node`
--
ALTER TABLE `installation_node`
  ADD PRIMARY KEY (`room_id`,`node_id`),
  ADD KEY `node_id` (`node_id`);

--
-- Indexes for table `node`
--
ALTER TABLE `node`
  ADD PRIMARY KEY (`node_id`);

--
-- Indexes for table `room`
--
ALTER TABLE `room`
  ADD PRIMARY KEY (`room_id`);

--
-- Indexes for table `room_mapping`
--
ALTER TABLE `room_mapping`
  ADD PRIMARY KEY (`booking_room_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `booking_led_channel`
--
ALTER TABLE `booking_led_channel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--
-- AUTO_INCREMENT for table `building`
--
ALTER TABLE `building`
  MODIFY `building_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cluster`
--
ALTER TABLE `cluster`
  MODIFY `cluster_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `config_air`
--
ALTER TABLE `config_air`
  MODIFY `config_air_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `config_audio_equipment`
--
ALTER TABLE `config_audio_equipment`
  MODIFY `config_audio_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `config_computer`
--
ALTER TABLE `config_computer`
  MODIFY `config_com_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `config_led`
--
ALTER TABLE `config_led`
  MODIFY `config_led_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `config_projector`
--
ALTER TABLE `config_projector`
  MODIFY `config_pro_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `device_channel`
--
ALTER TABLE `device_channel`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `device_channel_status`
--
ALTER TABLE `device_channel_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `device_status`
--
ALTER TABLE `device_status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=833;

--
-- AUTO_INCREMENT for table `node`
--
ALTER TABLE `node`
  MODIFY `node_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `room`
--
ALTER TABLE `room`
  MODIFY `room_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `booking_led_channel`
--
ALTER TABLE `booking_led_channel`
  ADD CONSTRAINT `booking_led_channel_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `booking_led_channel_ibfk_2` FOREIGN KEY (`node_id`) REFERENCES `node` (`node_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `booking_led_channel_ibfk_3` FOREIGN KEY (`channel_id`) REFERENCES `device_channel` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `building_detail`
--
ALTER TABLE `building_detail`
  ADD CONSTRAINT `building_detail_ibfk_1` FOREIGN KEY (`building_id`) REFERENCES `building` (`building_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `building_detail_ibfk_2` FOREIGN KEY (`cluster_id`) REFERENCES `cluster` (`cluster_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `cluster_detail`
--
ALTER TABLE `cluster_detail`
  ADD CONSTRAINT `cluster_detail_ibfk_1` FOREIGN KEY (`cluster_id`) REFERENCES `cluster` (`cluster_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cluster_detail_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `room` (`room_id`) ON DELETE CASCADE;

--
-- Constraints for table `config_air`
--
ALTER TABLE `config_air`
  ADD CONSTRAINT `config_air_ibfk_1` FOREIGN KEY (`node_id`) REFERENCES `node` (`node_id`) ON DELETE CASCADE;

--
-- Constraints for table `config_audio_equipment`
--
ALTER TABLE `config_audio_equipment`
  ADD CONSTRAINT `config_audio_equipment_ibfk_1` FOREIGN KEY (`node_id`) REFERENCES `node` (`node_id`) ON DELETE CASCADE;

--
-- Constraints for table `config_computer`
--
ALTER TABLE `config_computer`
  ADD CONSTRAINT `config_computer_ibfk_1` FOREIGN KEY (`node_id`) REFERENCES `node` (`node_id`) ON DELETE CASCADE;

--
-- Constraints for table `config_door`
--
ALTER TABLE `config_door`
  ADD CONSTRAINT `config_door_ibfk_1` FOREIGN KEY (`node_id`) REFERENCES `node` (`node_id`) ON DELETE CASCADE;

--
-- Constraints for table `config_led`
--
ALTER TABLE `config_led`
  ADD CONSTRAINT `config_led_ibfk_1` FOREIGN KEY (`node_id`) REFERENCES `node` (`node_id`) ON DELETE CASCADE;

--
-- Constraints for table `config_projector`
--
ALTER TABLE `config_projector`
  ADD CONSTRAINT `config_projector_ibfk_1` FOREIGN KEY (`node_id`) REFERENCES `node` (`node_id`) ON DELETE CASCADE;

--
-- Constraints for table `device_channel`
--
ALTER TABLE `device_channel`
  ADD CONSTRAINT `fk_device_channel_node` FOREIGN KEY (`node_id`) REFERENCES `node` (`node_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `device_channel_status`
--
ALTER TABLE `device_channel_status`
  ADD CONSTRAINT `fk_device_channel_status` FOREIGN KEY (`channel_id`) REFERENCES `device_channel` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `device_status`
--
ALTER TABLE `device_status`
  ADD CONSTRAINT `fk_device_status_node` FOREIGN KEY (`node_id`) REFERENCES `node` (`node_id`);

--
-- Constraints for table `installation_node`
--
ALTER TABLE `installation_node`
  ADD CONSTRAINT `installation_node_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `room` (`room_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `installation_node_ibfk_2` FOREIGN KEY (`node_id`) REFERENCES `node` (`node_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
