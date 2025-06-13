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
  - [S70253] - User registration, authentication, and profile management

- **Module 2: Car Management**
  - [S72452] - Car listing, details, availability, and maintenance records

- **Module 3: Booking System**
  - [S70224] - Reservation management, booking process, and payment handling


## Live Demo
[Add your live demo link here]

## Installation Instructions

### Prerequisites
- Java Development Kit (JDK) 8 or higher
- Apache Tomcat Server
- MySQL Database
- NetBeans IDE (recommended)

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
- User registration and authentication
- Car browsing and searching
- Booking management
- Payment processing
- Admin dashboard
- Report generation
- Customer feedback system

## Technologies Used
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

## Configuration

### Required Libraries
The project requires the following external libraries:
- MySQL Connector/J (version 9.2.0)
- Gson (version 2.13.1)

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

### Security Configuration
- Password hashing is implemented for user authentication
- Session management for user login
- Role-based access control (Admin, Client)

## License
[Add your license information here]
