-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Jun 13, 2025 at 09:47 AM
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
-- Database: `carrentalms`
--

-- --------------------------------------------------------

--
-- Table structure for table `administrator`
--

CREATE TABLE `administrator` (
  `adminID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phoneNumber` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `isDeleted` tinyint(1) DEFAULT 0,
  `profileImagePath` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `administrator`
--

INSERT INTO `administrator` (`adminID`, `userID`, `name`, `email`, `phoneNumber`, `status`, `isDeleted`, `profileImagePath`) VALUES
(3000, 1014, 'Ali bin Ismail Ahmad', 'ali.admin@carrental.com.my', '0123456789', 'active', 0, 'images/profilepic/1749788265132_WhatsApp Image 2025-04-22 at 21.47.36_2b947486.jpg'),
(3001, 1015, 'Tan Mei Ling', 'tan.admin@carrental.com.my', '0137890123', 'active', 0, NULL),
(3002, 1016, 'Kavitha Rajan', 'kavitha.admin@carrental.com.my', '0191234567', 'active', 0, NULL),
(3003, 1017, 'Raj Kumar', 'raj.admin@carrental.com.my', '0165432109', 'active', 0, NULL),
(3004, 1018, 'Lee Chin', 'lee.admin@carrental.com.my', '0179876543', 'active', 0, NULL),
(3005, 1030, 'Haikal Danial', 'haikal.danial@email.com', '0176543215', NULL, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `booking`
--

CREATE TABLE `booking` (
  `bookingID` int(11) NOT NULL,
  `clientID` int(11) NOT NULL,
  `bookingDate` date NOT NULL,
  `startDate` date NOT NULL,
  `endDate` date NOT NULL,
  `actualReturnDate` date DEFAULT NULL,
  `totalCost` decimal(10,2) DEFAULT NULL,
  `bookingStatus` varchar(50) DEFAULT NULL,
  `createdBy` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `booking`
--

INSERT INTO `booking` (`bookingID`, `clientID`, `bookingDate`, `startDate`, `endDate`, `actualReturnDate`, `totalCost`, `bookingStatus`, `createdBy`) VALUES
(1, 2000, '2024-05-15', '2025-05-20', '2025-05-25', NULL, 600.00, 'Completed', 3000),
(2, 2001, '2024-03-17', '2024-03-22', '2024-03-27', NULL, 900.00, 'Completed', 3001),
(3, 2002, '2024-03-18', '2024-03-23', '2024-03-26', NULL, 750.00, 'Completed', 3002),
(4, 2003, '2024-04-01', '2024-04-10', '2024-04-15', NULL, 1000.00, 'Completed', 3000),
(5, 2004, '2024-04-02', '2024-04-09', '2024-04-16', NULL, 1400.00, 'Completed', 3001),
(6, 2005, '2024-05-25', '2024-06-01', '2024-06-07', NULL, 1140.00, 'Pending', NULL),
(7, 2006, '2024-05-26', '2024-06-02', '2024-06-05', NULL, 570.00, 'Completed', NULL),
(8, 2000, '2024-08-15', '2024-08-29', '2024-09-02', NULL, 800.00, 'Pending', NULL),
(9, 2002, '2024-04-05', '2024-04-20', '2024-04-22', NULL, 460.00, 'Cancelled', 3002),
(10, 2007, '2024-03-20', '2024-03-25', '2024-03-30', NULL, 650.00, 'Completed', 3003),
(11, 2008, '2024-03-22', '2024-03-27', '2024-04-01', NULL, 950.00, 'Completed', 3004),
(12, 2009, '2024-04-03', '2024-04-12', '2024-04-17', NULL, 1100.00, 'Completed', 3000),
(13, 2010, '2024-04-04', '2024-04-11', '2024-04-18', NULL, 1500.00, 'Completed', 3001),
(14, 2011, '2024-05-27', '2024-06-03', '2024-06-08', NULL, 1200.00, 'Pending', NULL),
(15, 2012, '2024-05-28', '2024-06-04', '2024-06-06', NULL, 600.00, 'Pending', NULL),
(16, 2007, '2024-08-16', '2024-08-30', '2024-09-03', NULL, 850.00, 'Pending', NULL),
(17, 2008, '2024-04-06', '2024-04-21', '2024-04-23', NULL, 500.00, 'Cancelled', 3002),
(47, 2000, '2025-05-16', '2025-05-26', '2025-05-28', NULL, 360.00, 'Pending', NULL),
(48, 2000, '2025-05-18', '2025-05-29', '2025-05-30', NULL, 240.00, 'Pending', NULL),
(49, 2000, '2025-05-19', '2025-05-31', '2025-05-31', NULL, 120.00, 'Pending', NULL),
(50, 2000, '2025-05-27', '2025-05-27', '2025-05-29', NULL, 750.00, 'Completed', NULL),
(51, 2019, '2025-06-12', '2025-06-12', '2025-06-14', NULL, 360.00, 'Pending', NULL),
(52, 2019, '2025-06-13', '2025-06-15', '2025-06-18', NULL, 480.00, 'Pending', NULL),
(53, 2019, '2025-06-13', '2025-06-15', '2025-06-15', NULL, 200.00, 'Completed', NULL),
(55, 2019, '2025-06-13', '2025-06-13', '2025-06-13', NULL, 200.00, 'Completed', NULL),
(56, 2019, '2025-06-13', '2025-06-24', '2025-06-25', NULL, 200.00, 'Pending', NULL),
(57, 2019, '2025-06-13', '2025-06-29', '2025-06-30', NULL, 200.00, 'Pending', NULL),
(58, 2000, '2025-06-13', '2025-06-25', '2025-06-25', NULL, 200.00, 'Confirmed', 3000);

-- --------------------------------------------------------

--
-- Table structure for table `bookingvehicle`
--

CREATE TABLE `bookingvehicle` (
  `bookingID` int(11) NOT NULL,
  `vehicleID` int(11) NOT NULL,
  `assignedDate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bookingvehicle`
--

INSERT INTO `bookingvehicle` (`bookingID`, `vehicleID`, `assignedDate`) VALUES
(1, 1, NULL),
(2, 3, NULL),
(3, 5, NULL),
(4, 7, NULL),
(5, 6, NULL),
(6, 9, NULL),
(7, 8, NULL),
(8, 2, NULL),
(9, 4, NULL),
(10, 11, NULL),
(11, 13, NULL),
(12, 15, NULL),
(13, 17, NULL),
(14, 16, NULL),
(15, 19, NULL),
(16, 18, NULL),
(17, 12, NULL),
(47, 1, '2025-05-16'),
(48, 1, '2025-05-18'),
(49, 1, '2025-05-19'),
(50, 3, '2025-05-27'),
(51, 1, '2025-06-12'),
(52, 1, '2025-06-13'),
(53, 23, '2025-06-13'),
(55, 23, '2025-06-13'),
(56, 5, '2025-06-13'),
(57, 23, '2025-06-13'),
(58, 23, '2025-06-13');

-- --------------------------------------------------------

--
-- Table structure for table `client`
--

CREATE TABLE `client` (
  `clientID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phoneNumber` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `isDeleted` tinyint(1) DEFAULT 0,
  `profileImagePath` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `client`
--

INSERT INTO `client` (`clientID`, `userID`, `name`, `address`, `phoneNumber`, `email`, `isDeleted`, `profileImagePath`) VALUES
(2000, 1000, 'Ahmad Zulkifli Abidin Hassan', 'No. 15, Jalan Setiawangsa 8, Taman Setiawangsa, 54200 Kuala Lumpur', '0123456788', 'ahmad.z@gmail.com', 0, 'images/profilepic/default_profile.jpg'),
(2001, 1001, 'Nurul Huda Binti Hassan', 'A-12-3, Vista Komanwel, Bukit Jalil, 57000 Kuala Lumpur', '0176543210', 'nurul.h@yahoo.com', 0, NULL),
(2002, 1002, 'Rajesh Kumar', '72, Jalan SS2/75, 47300 Petaling Jaya, Selangor', '0193847566', 'rajesh.k@hotmail.com', 0, NULL),
(2003, 1003, 'Lee Ming Han', '25, Lorong Macalister, 10400 Georgetown, Penang', '0123456789', 'lee.mh@gmail.com', 0, NULL),
(2004, 1004, 'Sarah Tan Abdullah', 'No. 8, Jalan Puteri 5/7, Bandar Puteri, 47100 Puchong, Selangor', '0187654321', 'sarah.t@gmail.com', 0, NULL),
(2005, 1005, 'Aisyah Razak', 'Block C-5-12, Pantai Panorama, 59200 Kuala Lumpur', '0132657898', 'aisyah.r@yahoo.com', 0, NULL),
(2006, 1006, 'John Lim', '123, Jalan Ampang, 50450 Kuala Lumpur', '0167890123', 'john.l@gmail.com', 0, NULL),
(2007, 1010, 'Farah Abdullah', 'Lot 5, Jalan Bukit Bintang, 55100 Kuala Lumpur', '0123456780', 'farah.a@gmail.com', 0, NULL),
(2008, 1011, 'Khalid Mohd', 'No. 10, Jalan Tun Razak, 50400 Kuala Lumpur', '0176543211', 'khalid.m@yahoo.com', 0, NULL),
(2009, 1012, 'Mei Ling', '15, Jalan Ipoh, 51200 Kuala Lumpur', '0193847567', 'mei.l@hotmail.com', 0, NULL),
(2010, 1013, 'Ravi Shankar', '20, Jalan Petaling, 50000 Kuala Lumpur', '0123456781', 'ravi.s@gmail.com', 0, NULL),
(2011, 1014, 'Siti Nor', '25, Jalan Ampang, 50450 Kuala Lumpur', '0187654322', 'siti.n@gmail.com', 0, NULL),
(2012, 1015, 'Tan Wei', '30, Jalan Tun Perak, 50050 Kuala Lumpur', '0132657899', 'tan.w@yahoo.com', 0, NULL),
(2019, 1024, 'Muhammad Naim Najmi', 'No. 18, Jalan Setiawangsa 8, Taman Setiawangsa, 54200 Kuala Lumpur', '01125696678', 'najmi_n@gmail.com', 0, 'uploads/profile_pics/1749782785609_830.jpg'),
(2021, 1027, 'Naim Najmi', 'No. 20, Jalan Setiawangsa 8, Taman Setiawangsa, 54200 Kuala Lumpur', '01125696679', 'naim.najmi@email.com.my', 0, NULL),
(2022, 1028, 'Haris Farhan', 'No. 20, Jalan Setiawangsa 8, Taman Setiawangsa, 54200 Kuala Lumpur', '0123456777', 'haris_farhan@email.com', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `paymentID` int(11) NOT NULL,
  `bookingID` int(11) NOT NULL,
  `paymentType` varchar(50) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `paymentStatus` varchar(50) DEFAULT NULL,
  `referenceNo` varchar(100) DEFAULT NULL,
  `paymentDate` date DEFAULT NULL,
  `invoiceNumber` varchar(100) DEFAULT NULL,
  `handledBy` int(11) DEFAULT NULL,
  `proofOfPayment` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payment`
--

INSERT INTO `payment` (`paymentID`, `bookingID`, `paymentType`, `amount`, `paymentStatus`, `referenceNo`, `paymentDate`, `invoiceNumber`, `handledBy`, `proofOfPayment`) VALUES
(1, 1, 'Card', 600.00, 'Completed', 'REF123456789', '2024-03-15', 'INV-2024-001', NULL, NULL),
(2, 2, 'Card', 900.00, 'Completed', 'REF234567890', '2024-03-17', 'INV-2024-002', NULL, NULL),
(3, 3, 'Cash', 750.00, 'Completed', 'REF345678901', '2024-03-18', 'INV-2024-003', NULL, NULL),
(4, 4, 'Card', 1000.00, 'Completed', 'REF456789012', '2024-04-01', 'INV-2024-004', NULL, NULL),
(5, 5, 'Card', 1400.00, 'Completed', 'REF567890123', '2024-04-02', 'INV-2024-005', NULL, NULL),
(6, 6, 'Card', 1140.00, 'Pending', 'REF678901234', NULL, 'INV-2024-006', NULL, NULL),
(7, 7, 'Cash', 570.00, 'Completed', 'REF789012345', NULL, 'INV-2024-007', NULL, NULL),
(8, 8, 'Card', 800.00, 'Pending', 'REF890123456', NULL, 'INV-2024-008', NULL, NULL),
(9, 9, 'Card', 460.00, 'Failed', 'REF901234567', '2024-04-05', 'INV-2024-009', NULL, NULL),
(10, 10, 'Card', 650.00, 'Completed', 'REF123456790', '2024-03-20', 'INV-2024-010', NULL, NULL),
(11, 11, 'Card', 950.00, 'Completed', 'REF234567891', '2024-03-22', 'INV-2024-011', NULL, NULL),
(12, 12, 'Cash', 1100.00, 'Completed', 'REF345678902', '2024-04-03', 'INV-2024-012', NULL, NULL),
(13, 13, 'Card', 1500.00, 'Completed', 'REF456789013', '2024-04-04', 'INV-2024-013', NULL, NULL),
(14, 14, 'Card', 1200.00, 'Pending', 'REF567890124', NULL, 'INV-2024-014', NULL, NULL),
(15, 15, 'Cash', 600.00, 'Cancelled', 'REF678901235', NULL, 'INV-2024-015', NULL, NULL),
(16, 16, 'Card', 850.00, 'Pending', 'REF789012346', NULL, 'INV-2024-016', NULL, NULL),
(17, 17, 'Card', 500.00, 'Failed', 'REF890123457', '2024-04-06', 'INV-2024-017', NULL, NULL),
(19, 47, 'Bank Transfer', 360.00, 'Cancelled', NULL, '2025-05-18', 'INV-47-1747561252974', NULL, NULL),
(20, 48, 'Bank Transfer', 240.00, 'Cancelled', NULL, '2025-05-18', 'INV-48-1747576374125', NULL, NULL),
(21, 49, 'Bank Transfer', 120.00, 'Cancelled', NULL, '2025-05-19', 'INV-49-1747661197398', NULL, NULL),
(22, 50, 'Bank Transfer', 750.00, 'Completed', NULL, '2025-05-27', 'INV-50-1748331338701', NULL, NULL),
(23, 51, 'Bank Transfer', 360.00, 'Pending', NULL, '2025-06-13', 'INV-51-1749778655199', 3000, '/user-upload/payments/51_1749778655177.pdf'),
(24, 52, NULL, 480.00, 'Pending', NULL, NULL, NULL, 3000, NULL),
(25, 53, 'Bank Transfer', 200.00, 'Completed', NULL, '2025-06-13', 'INV-53-1749780950864', 3000, '/user-upload/payments/53_1749780950823.pdf'),
(27, 55, NULL, 200.00, 'Pending', NULL, NULL, NULL, NULL, NULL),
(28, 56, NULL, 200.00, 'Pending', NULL, NULL, NULL, NULL, NULL),
(29, 57, NULL, 200.00, 'Pending', NULL, NULL, NULL, NULL, NULL),
(30, 58, 'Cash', 200.00, 'Completed', NULL, '2025-06-13', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `userID` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(50) NOT NULL,
  `createdAt` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`userID`, `username`, `password`, `role`, `createdAt`) VALUES
(1000, 'ahmad_z', 'user', 'Client', NULL),
(1001, 'nurul_h', 'user', 'Client', NULL),
(1002, 'rajesh_k', 'user', 'Client', NULL),
(1003, 'lee_mh', 'user', 'Client', NULL),
(1004, 'sarah_t', 'user', 'Client', NULL),
(1005, 'aisyah_r', 'user', 'Client', NULL),
(1006, 'john_l', 'user', 'Client', NULL),
(1007, 'farah_a', 'user', 'Client', NULL),
(1008, 'khalid_m', 'user', 'Client', NULL),
(1009, 'mei_l', 'user', 'Client', NULL),
(1010, 'ravi_s', 'user', 'Client', NULL),
(1011, 'siti_n', 'user', 'Client', NULL),
(1012, 'tan_w', 'user', 'Client', NULL),
(1013, 'zulfiqar_h', 'user', 'Client', NULL),
(1014, 'admin_ali', 'user', 'Administrator', NULL),
(1015, 'admin_tan', 'user', 'Administrator', NULL),
(1016, 'admin_kavitha', 'user', 'Administrator', NULL),
(1017, 'admin_raj', 'user', 'Administrator', NULL),
(1018, 'admin_lee', 'user', 'Administrator', NULL),
(1024, 'najmi_n', 'user', 'Client', NULL),
(1025, 'najmi_naim', 'user', 'Client', NULL),
(1027, 'najmi_hazre', 'user', 'Client', NULL),
(1028, 'haris_farhan', 'Temp123!', 'Client', NULL),
(1030, 'haikal_danial', 'Temp123!', 'Administrator', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE `vehicles` (
  `vehicleID` int(11) NOT NULL,
  `model` varchar(100) DEFAULT NULL,
  `brand` varchar(100) DEFAULT NULL,
  `manufacturingYear` int(11) DEFAULT NULL,
  `availability` tinyint(1) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `fuelType` varchar(255) DEFAULT NULL,
  `transmissionType` varchar(255) DEFAULT NULL,
  `mileage` int(11) DEFAULT NULL,
  `ratePerDay` decimal(10,2) DEFAULT NULL,
  `registrationNo` varchar(100) DEFAULT NULL,
  `vehicleImagePath` varchar(255) DEFAULT NULL,
  `isDeleted` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vehicles`
--

INSERT INTO `vehicles` (`vehicleID`, `model`, `brand`, `manufacturingYear`, `availability`, `category`, `fuelType`, `transmissionType`, `mileage`, `ratePerDay`, `registrationNo`, `vehicleImagePath`, `isDeleted`) VALUES
(1, 'Myvi', 'Perodua', 2022, 1, 'Hatchback', 'Petrol', 'Manual', 15000, 120.00, 'WUX 5812', 'images/vehicles/car.jpg', 0),
(2, 'Saga', 'Proton', 2021, 1, 'Sedan', 'Petrol', 'Automatic', 25000, 110.00, 'VGD 3329', 'images/vehicles/car.jpg', 0),
(3, 'X70', 'Proton', 2023, 1, 'SUV', 'Petrol', 'Automatic', 8000, 250.00, 'WYB 7421', 'images/vehicles/car.jpg', 0),
(4, 'Alza', 'Perodua', 2020, 1, 'Van', 'Petrol', 'Automatic', 35000, 150.00, 'VEP 6538', 'images/vehicles/car.jpg', 0),
(5, 'Hilux', 'Toyota', 2021, 1, 'Truck', 'Diesel', 'Automatic', 30000, 200.00, 'WVS 1247', 'images/vehicles/car.jpg', 0),
(6, 'City', 'Honda', 2022, 1, 'Sedan', 'Petrol', 'Automatic', 20000, 180.00, 'WBF 9035', 'images/vehicles/car.jpg', 0),
(7, 'HR-V', 'Honda', 2023, 1, 'SUV', 'Petrol', 'Automatic', 10000, 230.00, 'WRF 6210', 'images/vehicles/car.jpg', 0),
(8, 'Axia', 'Perodua', 2021, 1, 'Hatchback', 'Petrol', 'Manual', 28000, 100.00, 'VVT 8712', 'images/vehicles/car.jpg', 0),
(9, 'Persona', 'Proton', 2022, 1, 'Sedan', 'Petrol', 'Automatic', 22000, 130.00, 'WUD 3345', 'images/vehicles/car.jpg', 0),
(10, 'Innova', 'Toyota', 2020, 1, 'Van', 'Petrol', 'Automatic', 40000, 190.00, 'VEG 5674', 'images/vehicles/car.jpg', 0),
(11, 'Aruz', 'Perodua', 2023, 1, 'SUV', 'Petrol', 'Automatic', 5000, 220.00, 'WYX 1234', 'images/vehicles/car.jpg', 0),
(12, 'Bezza', 'Perodua', 2022, 1, 'Sedan', 'Petrol', 'Automatic', 18000, 130.00, 'VGD 5678', 'images/vehicles/car.jpg', 0),
(13, 'Vios', 'Toyota', 2021, 1, 'Sedan', 'Petrol', 'Automatic', 25000, 160.00, 'WYB 9012', 'images/vehicles/car.jpg', 0),
(14, 'Fortuner', 'Toyota', 2020, 1, 'SUV', 'Petrol', 'Automatic', 35000, 280.00, 'VEP 3456', 'images/vehicles/car.jpg', 0),
(15, 'Ranger', 'Ford', 2022, 1, 'Truck', 'Diesel', 'Automatic', 20000, 240.00, 'WVS 7890', 'images/vehicles/car.jpg', 0),
(16, 'Accord', 'Honda', 2023, 1, 'Sedan', 'Petrol', 'Automatic', 10000, 200.00, 'WBF 2345', 'images/vehicles/car.jpg', 0),
(17, 'CR-V', 'Honda', 2021, 1, 'SUV', 'Petrol', 'Automatic', 30000, 250.00, 'WRF 6789', 'images/vehicles/car.jpg', 0),
(18, 'Nissan Navara', 'Nissan', 2022, 1, 'Truck', 'Diesel', 'Automatic', 15000, 230.00, 'VVT 0123', 'images/vehicles/car.jpg', 0),
(19, 'Mazda CX-5', 'Mazda', 2023, 1, 'SUV', 'Petrol', 'Automatic', 8000, 260.00, 'WUD 4567', 'images/vehicles/car.jpg', 0),
(20, 'Kia Sorento', 'Kia', 2020, 1, 'SUV', 'Petrol', 'Automatic', 40000, 240.00, 'VEG 8901', 'images/vehicles/car.jpg', 0),
(21, 'Alza', 'Perodua', 2020, 1, 'Hatchback', 'Petrol', 'Auto', 10000, 120.00, 'STV 8990', 'images/vehicles/car.jpg', 0),
(22, 'Avanza', 'Perodua', 2009, 1, 'SUV', 'Petrol', 'Auto', 90000, 150.00, 'ERC 8990', 'images/vehicles/car.jpg', 0),
(23, 'Avanza', 'Perodua', 2014, 1, 'SUV', 'Petrol', 'Manual', 12000, 200.00, 'ERC 2311', 'images/vehicles/1749046797678_510.jpeg', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `administrator`
--
ALTER TABLE `administrator`
  ADD PRIMARY KEY (`adminID`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `phoneNumber` (`phoneNumber`),
  ADD KEY `userID` (`userID`);

--
-- Indexes for table `booking`
--
ALTER TABLE `booking`
  ADD PRIMARY KEY (`bookingID`),
  ADD KEY `createdBy` (`createdBy`),
  ADD KEY `clientID` (`clientID`);

--
-- Indexes for table `bookingvehicle`
--
ALTER TABLE `bookingvehicle`
  ADD PRIMARY KEY (`bookingID`,`vehicleID`),
  ADD KEY `vehicleID` (`vehicleID`);

--
-- Indexes for table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`clientID`),
  ADD UNIQUE KEY `phoneNumber` (`phoneNumber`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `userID` (`userID`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`paymentID`),
  ADD KEY `bookingID` (`bookingID`),
  ADD KEY `payment_admin_handledby` (`handledBy`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`userID`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`vehicleID`),
  ADD UNIQUE KEY `registrationNo` (`registrationNo`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `administrator`
--
ALTER TABLE `administrator`
  MODIFY `adminID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3006;

--
-- AUTO_INCREMENT for table `booking`
--
ALTER TABLE `booking`
  MODIFY `bookingID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT for table `client`
--
ALTER TABLE `client`
  MODIFY `clientID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2023;

--
-- AUTO_INCREMENT for table `payment`
--
ALTER TABLE `payment`
  MODIFY `paymentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `userID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1031;

--
-- AUTO_INCREMENT for table `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `vehicleID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `administrator`
--
ALTER TABLE `administrator`
  ADD CONSTRAINT `administrator_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `booking`
--
ALTER TABLE `booking`
  ADD CONSTRAINT `booking_ibfk_2` FOREIGN KEY (`clientID`) REFERENCES `client` (`clientID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `bookingvehicle`
--
ALTER TABLE `bookingvehicle`
  ADD CONSTRAINT `bookingvehicle_ibfk_1` FOREIGN KEY (`bookingID`) REFERENCES `booking` (`bookingID`),
  ADD CONSTRAINT `bookingvehicle_ibfk_2` FOREIGN KEY (`vehicleID`) REFERENCES `vehicles` (`vehicleID`);

--
-- Constraints for table `client`
--
ALTER TABLE `client`
  ADD CONSTRAINT `client_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `payment`
--
ALTER TABLE `payment`
  ADD CONSTRAINT `payment_admin_handledby` FOREIGN KEY (`handledBy`) REFERENCES `administrator` (`adminID`),
  ADD CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`bookingID`) REFERENCES `booking` (`bookingID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
