# Car Rental Management System

## Project Description
A web-based Car Rental Management System developed for Universiti Malaysia Terengganu. This system provides a comprehensive solution for managing car rentals, bookings, and customer information.

## Group Members & Responsibilities

### Group Members
- [MUHAMMAD NAIM NAJMI BIN HAZRE] - [S70224]
- [NIK MUHAMMAD KHAIRUL AMIN BIN MOHD ARIF] - [S70253]
- [NADHIRAH ALIEYA BINTI NAJAMUDIN] - [S72452]

### Module Responsibilities
- **Module 1: User Management**
  - [S70253] - User registration and authentication system
  - Profile management and user information updates
  - Role-based access control (Admin, Client)
  - Password management and security features
  - User session handling
  - User dashboard and account settings
  - User activity logging and tracking

- **Module 2: Car Management**
  - [S72452] - Car listing and catalog management
  - Detailed car information and specifications
  - Car availability tracking and status updates
  - Car category and type management
  - Car image and media management
  - Car maintenance records
  - Car pricing and rate management
  - Search and filter functionality for cars

- **Module 3: Booking System**
  - [S70224] - Reservation management and booking process
  - Payment processing and transaction handling
  - Booking confirmation and notifications
  - Rental period management
  - Booking history and records
  - Cancellation and modification handling
  - Invoice generation
  - Payment gateway integration
  - Booking status tracking


## Live Demo
[Add your live demo link here]

## Installation Instructions

### Prerequisites
- **Development Environment**
  - Java Development Kit (JDK) 8 or higher
  - Apache NetBeans IDE 21.0 or higher
  - Apache Tomcat Server 9.0 or higher
  - MySQL Server 8.0 or higher
  - Git for version control

- **Required Software**
  - MySQL Workbench (recommended for database management)
  - Web browser (Chrome, Firefox, or Edge) for testing
  - Text editor (VS Code, Sublime Text, or similar) for additional editing

- **Development Tools**
  - MySQL Connector/J
  - JSTL (JavaServer Pages Standard Tag Library)
  - Bootstrap 5.x
  - jQuery 3.x
  - Font Awesome 6.x

### Setup Steps
1. Clone the repository
   ```bash
   git clone [repository-url]
   ```

2. Import the database
   - Use the provided `carrentalms.sql` file
   - Import it into your MySQL server

3. Configure the database connection
   - Update the database credentials in the configuration file

4. Deploy the project
   - Open the project in NetBeans
   - Clean and build the project
   - Run the project on Tomcat server

## Features

### User Management
- **User Registration and Authentication**
  - Secure user registration with email verification
  - Multi-factor authentication support
  - Password recovery and reset functionality
  - Session management and security
  - Role-based access control (Admin, Staff, Customer)

### Car Management
- **Car Browsing and Searching**
  - Advanced search with multiple filters (price, type, availability)
  - Detailed car specifications and features
  - High-quality image gallery
  - Real-time availability checking
  - Car comparison tool
  - Category-based browsing

### Booking System
- **Booking Management**
  - Online reservation system
  - Real-time availability calendar
  - Flexible booking periods
  - Booking modification and cancellation
  - Booking history and status tracking
  - Email notifications and confirmations

## Tech Stack Used
- Java
- JSP (JavaServer Pages)
- MySQL
- HTML5
- CSS3
- JavaScript
- Bootstrap
- Font Awesome

## Project Structure
```
CarRentalMS/
├── src/           # Source files
├── web/           # Web resources
├── lib/           # Libraries
├── test/          # Test files
└── nbproject/     # NetBeans project files
```

### Server Configuration
- Java Development Kit (JDK) 8 or higher
- Apache Tomcat Server
- NetBeans IDE (recommended)

### Project Structure
The project follows a standard Java web application structure:
- `src/` - Contains all Java source files
  - `Database/` - Database connection and CRUD operations
  - `Vehicle/` - Vehicle management classes
  - `Booking/` - Booking management classes
  - `User/` - User management classes
  - `Payment/` - Payment processing classes
- `web/` - Web resources
  - `WEB-INF/` - Web application configuration
  - `include/` - Reusable JSP components
- `lib/` - External libraries
- `test/` - Test files
- `nbproject/` - NetBeans project configuration

## License
[Add your license information here]
