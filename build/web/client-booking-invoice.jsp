<%@ page import="Booking.Booking"%>
<%@ page import="Database.UIAccessObject"%>
<%@ page import="Vehicle.Vehicle"%>
<%@ page import="User.Client"%>
<%@ page import="Payment.Payment"%>
<%@ page import="User.Admin"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.util.logging.Logger"%>
<%@ page import="java.util.logging.Level"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRent - Booking Invoice</title>
        <%@ include file="include/client-css.html" %>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f8f9fa;
                margin: 0;
                padding: 20px;
            }

            .invoice-container {
                max-width: 900px;
                margin: 0 auto;
                background-color: #fff;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                max-height: 280mm;
                page-break-inside: avoid;
            }

            /* Make invoice full width for print/PDF */
            @media print {
                .invoice-container {
                    max-width: none !important;
                    width: 100vw !important;
                    margin: 0 !important;
                    border-radius: 0 !important;
                    box-shadow: none !important;
                }
                body {
                    margin: 0 !important;
                }
                .invoice-header {
                    border-radius: 0 !important;
                    margin: 0 !important;
                    width: 100vw !important;
                }
            }
            @media screen {
                .invoice-container {
                    max-width: 900px;
                }
            }

            .invoice-header {
                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
                color: white;
                padding: 1.2rem;
                text-align: center;
                width: 100%;
                border-radius: 12px 12px 0 0;
            }

            .invoice-header h1 {
                margin: 0;
                font-size: 1.85rem;
                font-weight: 700;
                margin-bottom: 0.2rem;
            }

            .invoice-header p {
                margin: 0;
                font-size: 0.95rem;
                opacity: 0.9;
            }

            .invoice-number {
                background-color: rgba(255, 255, 255, 0.1);
                padding: 0.35rem 0.7rem;
                border-radius: 15px;
                display: inline-block;
                margin-top: 0.5rem;
                font-weight: 600;
                font-size: 0.85rem;
            }

            .invoice-body {
                padding: 1.2rem;
            }

            .invoice-section {
                margin-bottom: 1.1rem;
                padding-bottom: 0.8rem;
                border-bottom: 1px solid #e9ecef;
            }

            .invoice-section:last-child {
                border-bottom: none;
                margin-bottom: 0;
            }

            .section-title {
                font-size: 1.05rem;
                font-weight: 600;
                color: #333;
                margin-bottom: 0.5rem;
                display: flex;
                align-items: center;
            }

            .section-title i {
                margin-right: 0.4rem;
                color: #007bff;
                font-size: 0.95rem;
            }

            .info-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 0.4rem;
            }

            .info-item {
                display: flex;
                justify-content: space-between;
                padding: 0.3rem 0;
                border-bottom: 1px solid #f8f9fa;
                font-size: 0.9rem;
            }

            .info-item:last-child {
                border-bottom: none;
            }

            .info-label {
                font-weight: 600;
                color: #555;
            }

            .info-value {
                color: #333;
                text-align: right;
            }

            .status-badge {
                display: inline-block;
                padding: 0.25rem 0.5rem;
                border-radius: 12px;
                font-size: 0.75rem;
                font-weight: 600;
                text-transform: uppercase;
            }

            .status-Confirmed {
                background-color: #d4edda;
                color: #155724;
            }

            .status-Pending {
                background-color: #fff3cd;
                color: #856404;
            }

            .status-Cancelled {
                background-color: #f8d7da;
                color: #721c24;
            }

            .status-Completed {
                background-color: #cce5ff;
                color: #004085;
            }

            .amount-section {
                background-color: #f8f9fa;
                padding: 0.9rem;
                border-radius: 6px;
                margin-top: 0.5rem;
            }

            .total-amount {
                font-size: 1.2rem;
                font-weight: 700;
                color: #007bff;
                text-align: center;
                margin: 0;
            }

            .vehicle-image {
                max-width: 140px;
                height: auto;
                border-radius: 4px;
                box-shadow: 0 1px 4px rgba(0, 0, 0, 0.1);
            }

            .no-image {
                width: 140px;
                height: 90px;
                background-color: #f8f9fa;
                border-radius: 4px;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                color: #6c757d;
                font-size: 0.75rem;
            }

            .invoice-footer {
                background-color: #f8f9fa;
                padding: 0.9rem 1.2rem;
                text-align: center;
                border-top: 1px solid #e9ecef;
            }

            .footer-text {
                color: #6c757d;
                font-size: 0.8rem;
                margin: 0.2rem 0;
            }

            .action-buttons {
                position: fixed;
                top: 20px;
                right: 20px;
                display: flex;
                gap: 1rem;
                z-index: 1000;
            }

            .action-btn {
                padding: 0.75rem 1.5rem;
                border: none;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 0.5rem;
                text-decoration: none;
                color: white;
            }

            .action-btn.back {
                background-color: #6c757d;
            }

            .action-btn.back:hover {
                background-color: #5a6268;
            }

            .action-btn.print {
                background-color: #007bff;
            }

            .action-btn.print:hover {
                background-color: #0056b3;
            }

            .action-btn.pdf {
                background-color: #dc3545;
            }

            .action-btn.pdf:hover {
                background-color: #c82333;
            }

            /* Print and PDF optimization */
            @media print {
                body {
                    background-color: white;
                    padding: 0;
                    margin: 0;
                }
                
                .action-buttons {
                    display: none;
                }
                
                .invoice-container {
                    box-shadow: none;
                    border-radius: 0;
                    max-height: none;
                    page-break-inside: avoid;
                }

                .invoice-header {
                    padding: 0.5rem;
                }

                .invoice-header h1 {
                    font-size: 1.25rem;
                    margin-bottom: 0.1rem;
                }

                .invoice-header p {
                    font-size: 0.8rem;
                }

                .invoice-number {
                    padding: 0.2rem 0.4rem;
                    font-size: 0.7rem;
                    margin-top: 0.3rem;
                }

                .invoice-body {
                    padding: 0.5rem;
                }

                .invoice-section {
                    margin-bottom: 0.5rem;
                    padding-bottom: 0.3rem;
                }

                .section-title {
                    font-size: 0.8rem;
                    margin-bottom: 0.3rem;
                }

                .section-title i {
                    font-size: 0.7rem;
                    margin-right: 0.3rem;
                }

                .info-grid {
                    grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
                    gap: 0.15rem;
                }

                .info-item {
                    padding: 0.15rem 0;
                    font-size: 0.7rem;
                }

                .status-badge {
                    padding: 0.1rem 0.3rem;
                    font-size: 0.6rem;
                    border-radius: 8px;
                }

                .amount-section {
                    padding: 0.5rem;
                    margin-top: 0.3rem;
                }

                .total-amount {
                    font-size: 0.9rem;
                }

                .vehicle-image {
                    max-width: 80px;
                }

                .no-image {
                    width: 80px;
                    height: 50px;
                    font-size: 0.6rem;
                }

                .invoice-footer {
                    padding: 0.5rem 0.75rem;
                }

                .footer-text {
                    font-size: 0.65rem;
                    margin: 0.1rem 0;
                }
            }

            /* PDF export optimization */
            @media screen {
                .invoice-container {
                    /* Ensure it fits within A4 dimensions */
                    max-width: 210mm;
                    max-height: 280mm;
                }
            }

            @media (max-width: 768px) {
                .invoice-container {
                    margin: 0;
                    border-radius: 0;
                }
                
                .invoice-header {
                    padding: 0.75rem;
                }
                
                .invoice-header h1 {
                    font-size: 1.4rem;
                }
                
                .invoice-body {
                    padding: 0.75rem;
                }
                
                .action-buttons {
                    position: static;
                    margin-bottom: 1rem;
                    justify-content: center;
                }
                
                .action-btn {
                    padding: 0.5rem 1rem;
                    font-size: 0.9rem;
                }

                .info-grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    
    <body>
        <div class="action-buttons">
            <button class="action-btn back" onclick="closeTab()">
                <i class="fas fa-times"></i> Close Tab
            </button>
            <button class="action-btn print" onclick="window.print()">
                <i class="fas fa-print"></i> Print
            </button>
            <button class="action-btn pdf" onclick="exportToPDF()">
                <i class="fas fa-file-pdf"></i> Export PDF
            </button>
        </div>

        <%
            Logger logger = Logger.getLogger("client-booking-invoice.jsp");
            String bookingId = request.getParameter("bookingId");
            Booking booking = null;
            Vehicle vehicle = null;
            Client client = null;
            Payment payment = null;
            String errorMessage = null;

            if (bookingId != null && !bookingId.trim().isEmpty()) {
                UIAccessObject uiAccessObject = new UIAccessObject();
                try {
                    booking = uiAccessObject.getBookingByBookingId(bookingId);
                    if (booking != null) {
                        if (booking.getVehicleId() != null && !booking.getVehicleId().isEmpty()) {
                            vehicle = uiAccessObject.getVehicleById(Integer.parseInt(booking.getVehicleId()));
                        }
                        if (booking.getClientId() != null && !booking.getClientId().isEmpty()) {
                            client = uiAccessObject.getClientDataByClientID(booking.getClientId());
                        }
                        payment = uiAccessObject.getPaymentByBookingId(bookingId);
                    } else {
                        errorMessage = "Booking with ID " + bookingId + " not found.";
                    }
                } catch (Exception e) {
                    errorMessage = "Error fetching booking details: " + e.getMessage();
                    logger.log(Level.SEVERE, "Error fetching booking details", e);
                }
            } else {
                errorMessage = "Booking ID not provided.";
            }

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            DecimalFormat df = new DecimalFormat("#,##0.00");
        %>

        <% if (errorMessage != null) {%>
        <div style="color: #721c24; background-color: #f8d7da; padding: 15px; border-radius: 5px; margin-bottom: 20px; border: 1px solid #f5c6cb;">
            <i class="fas fa-exclamation-triangle me-2"></i>
            <strong>Error:</strong> <%= errorMessage%>
        </div>
        <% } %>

        <% if (booking != null) {%>
        <div class="invoice-container" id="invoiceContent">
            <div class="invoice-header">
                <h1><i class="fas fa-receipt"></i> CarRent</h1>
                <p>Professional Car Rental Services</p>
                <div class="invoice-number">
                    Invoice #<%= booking.getBookingId() %>
                </div>
            </div>

            <div class="invoice-body">
                <div class="invoice-section">
                    <h3 class="section-title">
                        <i class="fas fa-calendar-check"></i> Booking Information
                    </h3>
                    <div class="info-grid">
                        <div class="info-item">
                            <span class="info-label">Booking ID:</span>
                            <span class="info-value"><%= booking.getBookingId() %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Booking Date:</span>
                            <span class="info-value"><%= booking.getBookingDate() %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Start Date:</span>
                            <span class="info-value"><%= booking.getBookingStartDate() %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">End Date:</span>
                            <span class="info-value"><%= booking.getBookingEndDate() %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Duration:</span>
                            <span class="info-value">
                                <%
                                    if (booking.getBookingStartDate() != null && booking.getBookingEndDate() != null) {
                                        try {
                                            Date startDate = sdf.parse(booking.getBookingStartDate());
                                            Date endDate = sdf.parse(booking.getBookingEndDate());
                                            long diff = endDate.getTime() - startDate.getTime();
                                            long days = diff / (24 * 60 * 60 * 1000) + 1;
                                            out.print(days + (days == 1 ? " day" : " days"));
                                        } catch (Exception e) {
                                            out.print("N/A");
                                        }
                                    } else {
                                        out.print("N/A");
                                    }
                                %>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Status:</span>
                            <span class="info-value"><%= booking.getBookingStatus() %></span>
                        </div>
                    </div>
                </div>

                <div class="invoice-section">
                    <h3 class="section-title">
                        <i class="fas fa-user"></i> Client Information
                    </h3>
                    <% if (client != null) {%>
                    <div class="info-grid">
                        <div class="info-item">
                            <span class="info-label">Client ID:</span>
                            <span class="info-value"><%= client.getClientID() %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Name:</span>
                            <span class="info-value"><%= client.getName() %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Email:</span>
                            <span class="info-value"><%= client.getEmail() %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Phone:</span>
                            <span class="info-value"><%= client.getPhoneNumber() %></span>
                        </div>
                    </div>
                    <% } else { %>
                    <p style="color: #6c757d; font-style: italic;">Client information not available.</p>
                    <% } %>
                </div>

                <div class="invoice-section">
                    <h3 class="section-title">
                        <i class="fas fa-car"></i> Vehicle Information
                    </h3>
                    <% if (vehicle != null) {%>
                    <div style="display: grid; grid-template-columns: 1fr auto; gap: 2rem; align-items: start;">
                        <div class="info-grid">
                            <div class="info-item">
                                <span class="info-label">Vehicle ID:</span>
                                <span class="info-value"><%= vehicle.getVehicleId() %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Brand:</span>
                                <span class="info-value"><%= vehicle.getVehicleBrand() %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Model:</span>
                                <span class="info-value"><%= vehicle.getVehicleModel() %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Year:</span>
                                <span class="info-value"><%= vehicle.getVehicleYear() %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Type:</span>
                                <span class="info-value"><%= vehicle.getVehicleCategory() %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">License Plate:</span>
                                <span class="info-value"><%= vehicle.getVehicleRegistrationNo() %></span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Daily Rate:</span>
                                <span class="info-value">RM <%= df.format(Double.parseDouble(vehicle.getVehicleRatePerDay())) %></span>
                            </div>
                        </div>
                        <div>
                            <% if (vehicle.getVehicleImagePath() != null && !vehicle.getVehicleImagePath().isEmpty()) { %>
                                <img src="${pageContext.request.contextPath}/<%= vehicle.getVehicleImagePath() %>" 
                                     alt="<%= vehicle.getVehicleBrand() %> <%= vehicle.getVehicleModel() %>" 
                                     class="vehicle-image">
                            <% } else { %>
                                <div class="no-image">
                                    <i class="fas fa-car fa-2x mb-2"></i>
                                    <p>No image</p>
                                </div>
                            <% } %>
                        </div>
                    </div>
                    <% } else { %>
                    <p style="color: #6c757d; font-style: italic;">Vehicle information not available.</p>
                    <% } %>
                </div>

                <% if (payment != null) {%>
                <div class="invoice-section">
                    <h3 class="section-title">
                        <i class="fas fa-credit-card"></i> Payment Information
                    </h3>
                    <div class="info-grid">
                        <div class="info-item">
                            <span class="info-label">Payment ID:</span>
                            <span class="info-value"><%= payment.getPaymentID() %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Payment Type:</span>
                            <span class="info-value"><%= payment.getPaymentType() != null ? payment.getPaymentType() : "N/A" %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Payment Date:</span>
                            <span class="info-value"><%= payment.getPaymentDate() != null ? payment.getPaymentDate() : "N/A" %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Payment Status:</span>
                            <span class="info-value">
                                <span class="status-badge status-<%= payment.getPaymentStatus() != null ? payment.getPaymentStatus().replace(" ", "") : ""%>">
                                    <%= payment.getPaymentStatus() != null ? payment.getPaymentStatus() : "N/A"%>
                                </span>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Invoice Number:</span>
                            <span class="info-value"><%= payment.getInvoiceNumber() != null ? payment.getInvoiceNumber() : "N/A" %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Handled By:</span>
                            <span class="info-value"><%= payment.getHandledBy() != null ? payment.getHandledBy() : "N/A" %></span>
                        </div>
                    </div>
                </div>
                <% } %>

                <div class="amount-section">
                    <p class="total-amount">
                        Total Amount: RM <%= booking.getTotalCost() != null ? df.format(Double.parseDouble(booking.getTotalCost())) : "N/A" %>
                    </p>
                </div>
            </div>

            <div class="invoice-footer">
                <p class="footer-text">
                    <i class="fas fa-info-circle"></i> 
                    Thank you for choosing CarRent. For any inquiries, please contact our customer service.
                </p>
                <p class="footer-text">
                    Generated on: <%= new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date()) %>
                </p>
            </div>
        </div>
        <% } else { %>
        <div style="text-align: center; padding: 3rem; color: #6c757d;">
            <i class="fas fa-exclamation-triangle fa-3x mb-3"></i>
            <h3>No booking details to display.</h3>
        </div>
        <% }%>

        <script>
            function closeTab() {
                // Try to close the tab/window
                if (window.opener) {
                    // If opened from another window, close this one
                    window.close();
                } else {
                    // If not opened from another window, try to close anyway
                    // Note: This may not work in all browsers due to security restrictions
                    window.close();
                    
                    // Fallback: show message if window.close() doesn't work
                    setTimeout(() => {
                        if (!window.closed) {
                            alert('Please close this tab manually. Some browsers prevent automatic tab closing for security reasons.');
                        }
                    }, 100);
                }
            }

            function exportToPDF() {
                const element = document.getElementById('invoiceContent');
                const opt = {
                    margin: [0.2, 0.2, 0.2, 0.2], // [top, right, bottom, left] margins in inches - smaller for full width
                    filename: 'booking-invoice-<%= booking != null ? booking.getBookingId() : "unknown" %>.pdf',
                    image: { type: 'jpeg', quality: 0.97 },
                    html2canvas: { 
                        scale: 2, // High quality
                        useCORS: true,
                        allowTaint: true,
                        scrollX: 0,
                        scrollY: 0,
                        width: 794, // A4 width at 96dpi
                        height: 1123 // A4 height at 96dpi
                    },
                    jsPDF: { 
                        unit: 'in', 
                        format: 'a4', 
                        orientation: 'portrait',
                        compress: true
                    },
                    pagebreak: { mode: 'avoid-all' }
                };

                // Hide action buttons temporarily
                const actionButtons = document.querySelector('.action-buttons');
                actionButtons.style.display = 'none';

                // Add a small delay to ensure DOM is ready
                setTimeout(() => {
                    html2pdf().set(opt).from(element).save().then(() => {
                        // Show action buttons again
                        actionButtons.style.display = 'flex';
                    }).catch(error => {
                        console.error('PDF generation error:', error);
                        actionButtons.style.display = 'flex';
                        alert('Error generating PDF. Please try again.');
                    });
                }, 100);
            }

            // Auto-hide action buttons when printing
            window.addEventListener('beforeprint', function() {
                document.querySelector('.action-buttons').style.display = 'none';
            });

            window.addEventListener('afterprint', function() {
                document.querySelector('.action-buttons').style.display = 'flex';
            });

            // Ensure content fits on page when page loads
            window.addEventListener('load', function() {
                const container = document.getElementById('invoiceContent');
                if (container) {
                    // Check if content might overflow and adjust if needed
                    const containerHeight = container.scrollHeight;
                    const maxHeight = 280; // A4 height in mm
                    
                    if (containerHeight > maxHeight) {
                        console.log('Content might overflow, consider reducing content or font sizes');
                    }
                }
            });
        </script>
    </body>
</html> 