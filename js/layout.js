document.addEventListener('DOMContentLoaded', function () {
    const root = window.siteRoot || '';
    fetch(root + '_header.html')
        .then(response => response.text())
        .then(data => {
            document.getElementById('header-placeholder').innerHTML = data;
            // Initialize all navigation and header components
            initializeSidebarNavigation();
            initializeThemeToggle();
            initializeLanguageToggle();
            initializeGoogleTranslate();
        })
        .catch(error => console.error('Error loading header:', error));

    fetch(root + '_footer.html')
        .then(response => response.text())
        .then(data => {
            document.getElementById('footer-placeholder').innerHTML = data;
        })
        .catch(error => console.error('Error loading footer:', error));

    // Initialize other components that don't depend on header/footer loading
    initializeCarousels();
    initializeScrollButton();
});

// Function to handle sidebar interactions
function initializeSidebarNavigation() {
    const sidebarToggle = document.getElementById('sidebar-toggle');
    const sidebar = document.getElementById('sidebar');
    const body = document.body;

    if (sidebarToggle && sidebar && body) {
        sidebarToggle.addEventListener('click', (e) => {
            e.stopPropagation();
            sidebar.classList.toggle('sidebar-visible');
            body.classList.toggle('sidebar-active');

            // Toggle Icon
            if (sidebar.classList.contains('sidebar-visible')) {
                sidebarToggle.setAttribute('aria-expanded', 'true');
                sidebarToggle.innerHTML = '<i class="fas fa-times"></i>';
            } else {
                sidebarToggle.setAttribute('aria-expanded', 'false');
                sidebarToggle.innerHTML = '<i class="fas fa-bars"></i>';
            }
        });

        // Close sidebar when clicking outside
        document.addEventListener('click', (e) => {
            if (sidebar.classList.contains('sidebar-visible') &&
                !sidebar.contains(e.target) &&
                !sidebarToggle.contains(e.target)) {

                sidebar.classList.remove('sidebar-visible');
                body.classList.remove('sidebar-active');
                sidebarToggle.setAttribute('aria-expanded', 'false');
                sidebarToggle.innerHTML = '<i class="fas fa-bars"></i>';
            }
        });
    }
}

function initializeThemeToggle() {
    const themeToggle = document.getElementById('theme-toggle');
    const body = document.body;
    const icon = themeToggle ? themeToggle.querySelector('i') : null;

    // Check saved preference
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme === 'dark') {
        body.classList.add('dark-mode');
        if (icon) icon.classList.replace('fa-moon', 'fa-sun');
    }

    if (themeToggle) {
        themeToggle.addEventListener('click', () => {
            body.classList.toggle('dark-mode');
            const isDark = body.classList.contains('dark-mode');

            // Update Icon
            if (isDark) {
                if (icon) icon.classList.replace('fa-moon', 'fa-sun');
                localStorage.setItem('theme', 'dark');
            } else {
                if (icon) icon.classList.replace('fa-sun', 'fa-moon');
                localStorage.setItem('theme', 'light');
            }
        });
    }
}

function initializeLanguageToggle() {
    const langToggle = document.getElementById('lang-toggle');
    const langBar = document.getElementById('language-bar');
    const closeLangBar = document.getElementById('close-lang-bar');

    if (langToggle && langBar) {
        langToggle.addEventListener('click', (e) => {
            e.stopPropagation();
            langBar.classList.toggle('active');
        });

        if (closeLangBar) {
            closeLangBar.addEventListener('click', (e) => {
                e.stopPropagation();
                langBar.classList.remove('active');
            });
        }

        // Close when clicking outside
        document.addEventListener('click', (e) => {
            if (langBar.classList.contains('active') &&
                !langBar.contains(e.target) &&
                !langToggle.contains(e.target)) {
                langBar.classList.remove('active');
            }
        });
    }
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

// Scroll to Top Button functionality
function initializeScrollButton() {
    const scrollBtn = document.getElementById('scrollToTopBtn');

    if (!scrollBtn) return;

    // Show button when user scrolls down 300px
    window.addEventListener('scroll', () => {
        if (document.body.scrollTop > 300 || document.documentElement.scrollTop > 300) {
            scrollBtn.style.display = 'flex';
        } else {
            scrollBtn.style.display = 'none';
        }
    });

    // Scroll to top when clicked
    scrollBtn.addEventListener('click', () => {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });
}

// Google Translate initialization
function initializeGoogleTranslate() {
    // Check if script is already added
    if (document.querySelector('script[src*="translate.google.com"]')) return;

    // Add Google Translate script
    const script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = '//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit';
    document.head.appendChild(script);
}

// Google Translate callback
function googleTranslateElementInit() {
    new google.translate.TranslateElement({
        pageLanguage: 'es',
        includedLanguages: 'en,fr,de,it,pt,ca,eu,gl',
        layout: google.translate.TranslateElement.InlineLayout.SIMPLE
    }, 'google_translate_element');
}
