<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="Database.UIAccessObject"%>
<%@ page import="Payment.Payment"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.DecimalFormat"%>

<%
    String clientId = (String) session.getAttribute("userId");
    
    if (clientId == null || clientId.trim().isEmpty()) {
        response.sendRedirect("login.jsp");
        return;
    }

    UIAccessObject uiAccessObject = new UIAccessObject();
    // Get all payments from all clients
    List<Payment> allPayments = uiAccessObject.getPaymentDetailsByClientID(clientId);

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat timeSdf = new SimpleDateFormat("hh:mm a z");
    String currentDateTime = sdf.format(new Date()) + " " + timeSdf.format(new Date());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment History - CarRent</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #3498db;
            --success-color: #27ae60;
            --warning-color: #f1c40f;
            --danger-color: #e74c3c;
            --light-bg: #f8f9fa;
            --card-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        body {
            background-color: var(--light-bg);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .payment-history-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }

        .page-header {
            background-color: white;
            padding: 1.5rem;
            border-radius: 10px;
            box-shadow: var(--card-shadow);
            margin-bottom: 2rem;
        }

        .page-header h1 {
            color: var(--primary-color);
            margin: 0;
            font-size: 1.8rem;
        }

        .filter-section {
            background-color: white;
            padding: 1rem;
            border-radius: 10px;
            box-shadow: var(--card-shadow);
            margin-bottom: 1.5rem;
        }

        .filter-btn {
            padding: 0.5rem 1.5rem;
            border: none;
            border-radius: 5px;
            margin-right: 0.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .filter-btn.active {
            background-color: var(--secondary-color);
            color: white;
        }

        .payment-card {
            background-color: white;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: var(--card-shadow);
            transition: transform 0.2s ease;
            cursor: pointer;
        }

        .payment-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }

        .payment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .payment-id {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--primary-color);
        }

        .payment-amount {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--success-color);
        }

        .payment-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }

        .detail-item {
            margin-bottom: 0.5rem;
        }

        .detail-label {
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 0.2rem;
        }

        .detail-value {
            font-weight: 500;
            color: var(--primary-color);
        }

        .status-badge {
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .status-completed {
            background-color: #d4edda;
            color: #155724;
        }

        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }

        .status-cancelled {
            background-color: #f8d7da;
            color: #721c24;
        }

        .no-payments {
            text-align: center;
            padding: 3rem;
            background-color: white;
            border-radius: 10px;
            box-shadow: var(--card-shadow);
        }

        .timestamp {
            text-align: right;
            color: #666;
            font-size: 0.9rem;
            margin-top: 1rem;
        }

        @media (max-width: 768px) {
            .payment-details {
                grid-template-columns: 1fr;
            }
            
            .filter-btn {
                margin-bottom: 0.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="payment-history-container">
        <div class="page-header">
            <h1>Payment History</h1>
        </div>

        <div class="filter-section">
            <button class="filter-btn active" data-status="all">All Payments</button>
            <button class="filter-btn" data-status="Completed">Completed</button>
            <button class="filter-btn" data-status="Pending">Pending</button>
            <button class="filter-btn" data-status="Cancelled">Cancelled</button>
        </div>

        <% if (allPayments == null || allPayments.isEmpty()) { %>
            <div class="no-payments">
                <i class="fas fa-receipt fa-3x mb-3" style="color: #ccc;"></i>
                <h3>No Payment Records Found</h3>
                <p class="text-muted">You haven't made any payments yet.</p>
            </div>
        <% } else { %>
            <div id="paymentList">
                <% for (Payment payment : allPayments) { %>
                    <div class="payment-card" data-status="<%= payment.getPaymentStatus() != null ? payment.getPaymentStatus() : ""%>" 
                         onclick="window.location='payment-details.jsp?paymentId=<%= payment.getPaymentID()%>'">
                        <div class="payment-header">
                            <span class="payment-id">Payment #<%= payment.getPaymentID()%></span>
                            <span class="payment-amount">RM <%= String.format("%.2f", payment.getAmount())%></span>
                        </div>
                        <div class="payment-details">
                            <div class="detail-item">
                                <div class="detail-label">Booking ID</div>
                                <div class="detail-value">#<%= payment.getBookingID()%></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Payment Type</div>
                                <div class="detail-value"><%= payment.getPaymentType() != null ? payment.getPaymentType() : "N/A"%></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Payment Date</div>
                                <div class="detail-value"><%= payment.getPaymentDate() != null ? payment.getPaymentDate() : "N/A"%></div>
                            </div>
                            <div class="detail-item">
                                <div class="detail-label">Status</div>
                                <div class="detail-value">
                                    <span class="status-badge status-<%= payment.getPaymentStatus() != null ? payment.getPaymentStatus().toLowerCase() : ""%>">
                                        <%= payment.getPaymentStatus() != null ? payment.getPaymentStatus() : "N/A"%>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>

        <div class="timestamp">
            Last updated: <%= currentDateTime%>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const filterButtons = document.querySelectorAll('.filter-btn');
            const paymentCards = document.querySelectorAll('.payment-card');
            const noPayments = document.querySelector('.no-payments');

            function filterPayments(status) {
                let visibleCount = 0;
                
                paymentCards.forEach(card => {
                    const cardStatus = card.getAttribute('data-status');
                    if (status === 'all' || cardStatus === status) {
                        card.style.display = 'block';
                        visibleCount++;
                    } else {
                        card.style.display = 'none';
                    }
                });

                if (visibleCount === 0 && noPayments) {
                    noPayments.style.display = 'block';
                } else if (noPayments) {
                    noPayments.style.display = 'none';
                }
            }

            filterButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const status = this.getAttribute('data-status');
                    
                    filterButtons.forEach(btn => btn.classList.remove('active'));
                    this.classList.add('active');
                    
                    filterPayments(status);
                });
            });

            // Initial filter
            filterPayments('all');
        });
    </script>
</body>
</html>