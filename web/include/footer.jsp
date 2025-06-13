<%-- footer.jsp --%>
<footer class="bg-dark text-light py-5">
    <div class="container">
        <div class="row g-4">
            <!-- Contact Info -->
            <div class="col-lg-4 col-md-6">
                <h3 class="h5 fw-semibold text-white mb-3">Contact Us</h3>
                <ul class="list-unstyled small">
                    <li class="mb-2">
                        <i class="fas fa-map-marker-alt me-2"></i>
                        Universiti Malaysia Terengganu,<br>
                        21030 Kuala Nerus,<br>
                        Terengganu, Malaysia
                    </li>
                    <li class="mb-2">
                        <i class="fas fa-phone me-2"></i>
                        +60 9-668 4100
                    </li>
                    <li class="mb-2">
                        <i class="fas fa-envelope me-2"></i>
                        contact@carrental.com
                    </li>
                    <li class="mb-2">
                        <i class="fas fa-clock me-2"></i>
                        Mon - Fri: 8:00 AM - 5:00 PM
                    </li>
                </ul>
            </div>

            <!-- Quick Links -->
            <div class="col-lg-2 col-md-6">
                <h3 class="h5 fw-semibold text-white mb-3">Quick Links</h3>
                <ul class="list-unstyled small">
                    <li class="mb-2"><a href="main.jsp" class="text-light-emphasis text-decoration-none">Home</a></li>
                    <li class="mb-2"><a href="cars.jsp" class="text-light-emphasis text-decoration-none">Cars</a></li>
                    <li class="mb-2"><a href="about.jsp" class="text-light-emphasis text-decoration-none">About Us</a></li>
                    <li class="mb-2"><a href="contact.jsp" class="text-light-emphasis text-decoration-none">Contact</a></li>
                </ul>
            </div>

            <!-- Company Info -->
            <div class="col-lg-4 col-md-6">
                <h3 class="h5 fw-semibold text-white mb-3">CarRent</h3>
                <p class="small text-light-emphasis mb-4">Your trusted partner for premium car rentals. Experience luxury and comfort with our extensive fleet of vehicles.</p>
                <div class="social-links">
                    <a href="#" class="text-light me-3" title="Facebook"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="text-light me-3" title="Twitter"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="text-light me-3" title="Instagram"><i class="fab fa-instagram"></i></a>
                    <a href="#" class="text-light" title="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
        </div>

        <!-- Bottom Bar -->
        <div class="border-top border-secondary pt-4 mt-4">
            <div class="row align-items-center">
                <div class="col-md-6 text-center text-md-start small">
                    <p class="mb-0">© <script>document.write(new Date().getFullYear());</script> CarRent. All rights reserved.</p>
                </div>
                <div class="col-md-6 text-center text-md-end small">
                    <a href="privacy-policy.jsp" class="text-light-emphasis text-decoration-none me-3">Privacy Policy</a>
                    <a href="terms.jsp" class="text-light-emphasis text-decoration-none">Terms of Service</a>
                </div>
            </div>
        </div>
    </div>
</footer>

<style>
    footer {
        margin-top: auto;
    }
    footer .social-links a {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 32px;
        height: 32px;
        border-radius: 50%;
        background-color: rgba(255, 255, 255, 0.1);
        transition: all 0.3s ease;
    }
    footer .social-links a:hover {
        background-color: rgba(255, 255, 255, 0.2);
        transform: translateY(-2px);
    }
    footer .text-light-emphasis {
        color: rgba(255, 255, 255, 0.7) !important;
    }
    footer .text-light-emphasis:hover {
        color: #fff !important;
    }
    footer ul li a {
        transition: all 0.3s ease;
    }
    footer ul li a:hover {
        padding-left: 5px;
    }
</style>