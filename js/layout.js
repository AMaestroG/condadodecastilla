document.addEventListener('DOMContentLoaded', function () {
    fetch('_header.html')
        .then(response => response.text())
        .then(data => {
            document.getElementById('header-placeholder').innerHTML = data;
            // NEW: Initialize sidebar navigation after header is loaded
            initializeSidebarNavigation();
        });

    fetch('_footer.html')
        .then(response => response.text())
        .then(data => {
            document.getElementById('footer-placeholder').innerHTML = data;
        });
});

// NEW: Function to handle sidebar interactions
function initializeSidebarNavigation() {
    const sidebarToggle = document.getElementById('sidebar-toggle');
    const sidebar = document.getElementById('sidebar');
    const body = document.body;

    if (sidebarToggle && sidebar && body) { // Added body check
        sidebarToggle.addEventListener('click', () => {
            sidebar.classList.toggle('sidebar-visible');
            body.classList.toggle('sidebar-active'); // For main content shift
            // Optional: Change toggle button text/icon and ARIA attribute
            if (sidebar.classList.contains('sidebar-visible')) {
                sidebarToggle.setAttribute('aria-expanded', 'true');
                // sidebarToggle.textContent = '✕'; // Example: Change to X
            } else {
                sidebarToggle.setAttribute('aria-expanded', 'false');
                // sidebarToggle.textContent = '☰'; // Example: Change back to burger
            }
        });
    } else {
        console.error("Sidebar toggle, sidebar element, or body not found.");
    }

    // NEW: Initialize Carousels
    initializeCarousels();
}

function initializeCarousels() {
    const carousels = document.querySelectorAll('.carousel-container');

    carousels.forEach(carousel => {
        const track = carousel.querySelector('.carousel-track');
        const slides = Array.from(track.children);
        const nextButton = carousel.querySelector('.carousel-button.next');
        const prevButton = carousel.querySelector('.carousel-button.prev');

        if (!track || !nextButton || !prevButton || slides.length === 0) return;

        let currentIndex = 0;

        // Function to get number of visible slides based on viewport
        const getVisibleSlides = () => window.innerWidth >= 769 ? 3 : 1;

        const updateCarousel = () => {
            const slideWidth = slides[0].getBoundingClientRect().width;
            // Add gap to slide width calculation if it exists in CSS
            const gap = parseFloat(window.getComputedStyle(track).gap) || 0;
            const moveAmount = (slideWidth + gap) * currentIndex;
            track.style.transform = `translateX(-${moveAmount}px)`;

            // Update button states
            prevButton.disabled = currentIndex === 0;
            prevButton.style.opacity = currentIndex === 0 ? '0.5' : '1';

            const visibleSlides = getVisibleSlides();
            const maxIndex = slides.length - visibleSlides;
            nextButton.disabled = currentIndex >= maxIndex;
            nextButton.style.opacity = currentIndex >= maxIndex ? '0.5' : '1';
        };

        nextButton.addEventListener('click', () => {
            const visibleSlides = getVisibleSlides();
            const maxIndex = slides.length - visibleSlides;
            if (currentIndex < maxIndex) {
                currentIndex++;
                updateCarousel();
            }
        });

        prevButton.addEventListener('click', () => {
            if (currentIndex > 0) {
                currentIndex--;
                updateCarousel();
            }
        });

        // Handle resize
        window.addEventListener('resize', () => {
            // Reset index on resize to avoid layout issues
            currentIndex = 0;
            updateCarousel();
        });

        // Initial update
        updateCarousel();
    });
}

/*
// OLD function to be removed or commented out:
function initializeMobileNavigation() {
    // Script para el menú de navegación móvil
    const navToggle = document.querySelector('.nav-toggle');
    const navLinks = document.querySelector('.nav-links');

    // Check if elements exist before adding event listeners
    if (navToggle && navLinks) {
        navToggle.addEventListener('click', () => {
            const isExpanded = navToggle.getAttribute('aria-expanded') === 'true' || false;
            navToggle.setAttribute('aria-expanded', !isExpanded);
            navLinks.classList.toggle('active');
        });

        // Opcional: Cerrar menú al hacer clic en un enlace
        navLinks.querySelectorAll('a').forEach(link => {
            link.addEventListener('click', () => {
                // Check if navLinks is active before trying to remove class and set attribute
                if (navLinks.classList.contains('active')) {
                    navToggle.setAttribute('aria-expanded', 'false');
                    navLinks.classList.remove('active');
                }
            });
        });
    } else {
        console.error("Mobile navigation elements not found. Header might not be loaded correctly.");
    }
}
*/
