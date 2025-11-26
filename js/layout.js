document.addEventListener('DOMContentLoaded', function () {
    const root = window.siteRoot || '';
    console.log('Initializing layout with root:', root);

    // Load Header
    fetch(root + '_header.html')
        .then(response => {
            if (!response.ok) throw new Error('Header load failed');
            return response.text();
        })
        .then(data => {
            const headerPlaceholder = document.getElementById('header-placeholder');
            if (headerPlaceholder) {
                headerPlaceholder.innerHTML = data;
                console.log('Header loaded successfully');

                // Initialize components with a slight delay to ensure DOM is ready
                setTimeout(() => {
                    initializeSidebarNavigation();
                    initializeThemeToggle();
                    initializeLanguageToggle();
                    initializeGoogleTranslate();
                }, 50);
            } else {
                console.error('Header placeholder not found');
            }
        })
        .catch(error => console.error('Error loading header:', error));

    // Load Footer
    fetch(root + '_footer.html')
        .then(response => {
            if (!response.ok) throw new Error('Footer load failed');
            return response.text();
        })
        .then(data => {
            const footerPlaceholder = document.getElementById('footer-placeholder');
            if (footerPlaceholder) {
                footerPlaceholder.innerHTML = data;
                console.log('Footer loaded successfully');
            }
        })
        .catch(error => console.error('Error loading footer:', error));

    // Initialize independent components
    initializeCarousels();
    initializeScrollButton();
    initializeScrollReveal();
    initializeCardHoverEffects();
});

// Sidebar Navigation
function initializeSidebarNavigation() {
    const sidebarToggle = document.getElementById('sidebar-toggle');
    const sidebar = document.getElementById('sidebar');

    if (!sidebarToggle || !sidebar) {
        console.warn('Sidebar elements not found');
        return;
    }

    // Toggle click
    sidebarToggle.addEventListener('click', (e) => {
        e.stopPropagation();
        sidebar.classList.toggle('sidebar-visible');

        // Update icon
        const icon = sidebarToggle.querySelector('i');
        if (sidebar.classList.contains('sidebar-visible')) {
            if (icon) icon.className = 'fas fa-times';
        } else {
            if (icon) icon.className = 'fas fa-bars';
        }
    });

    // Close when clicking outside
    document.addEventListener('click', (e) => {
        if (sidebar.classList.contains('sidebar-visible') &&
            !sidebar.contains(e.target) &&
            !sidebarToggle.contains(e.target)) {

            sidebar.classList.remove('sidebar-visible');
            const icon = sidebarToggle.querySelector('i');
            if (icon) icon.className = 'fas fa-bars';
        }
    });
}

// Theme Toggle
function initializeThemeToggle() {
    const themeToggle = document.getElementById('theme-toggle');
    const body = document.body;

    if (!themeToggle) {
        console.warn('Theme toggle not found');
        return;
    }

    const icon = themeToggle.querySelector('i');

    // Check saved preference
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme === 'dark') {
        body.classList.add('dark-mode');
        if (icon) icon.className = 'fas fa-sun';
    }

    themeToggle.addEventListener('click', () => {
        body.classList.toggle('dark-mode');
        const isDark = body.classList.contains('dark-mode');

        if (isDark) {
            if (icon) icon.className = 'fas fa-sun';
            localStorage.setItem('theme', 'dark');
        } else {
            if (icon) icon.className = 'fas fa-moon';
            localStorage.setItem('theme', 'light');
        }
    });
}

// Language Toggle
function initializeLanguageToggle() {
    const langToggle = document.getElementById('lang-toggle');
    const langBar = document.getElementById('language-bar');
    const closeLangBar = document.getElementById('close-lang-bar');

    if (!langToggle || !langBar) {
        console.warn('Language elements not found');
        return;
    }

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

    document.addEventListener('click', (e) => {
        if (langBar.classList.contains('active') &&
            !langBar.contains(e.target) &&
            !langToggle.contains(e.target)) {
            langBar.classList.remove('active');
        }
    });
}

// Google Translate
function initializeGoogleTranslate() {
    if (document.querySelector('script[src*="translate.google.com"]')) return;

    const script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = '//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit';
    document.head.appendChild(script);
}

function googleTranslateElementInit() {
    new google.translate.TranslateElement({
        pageLanguage: 'es',
        includedLanguages: 'en,fr,de,it,pt,ca,eu,gl',
        layout: google.translate.TranslateElement.InlineLayout.SIMPLE
    }, 'google_translate_element');
}

// Carousels
function initializeCarousels() {
    const carousels = document.querySelectorAll('.carousel-container');

    carousels.forEach(carousel => {
        const track = carousel.querySelector('.carousel-track');
        const nextBtn = carousel.querySelector('.carousel-button.next');
        const prevBtn = carousel.querySelector('.carousel-button.prev');

        if (!track || !nextBtn || !prevBtn) return;

        let index = 0;
        const slides = track.children;

        const update = () => {
            const slideWidth = slides[0].getBoundingClientRect().width;
            const gap = 20; // Matches CSS gap
            track.style.transform = `translateX(-${index * (slideWidth + gap)}px)`;

            // Simple boundary checks
            prevBtn.style.opacity = index === 0 ? '0.5' : '1';
            const maxIndex = slides.length - (window.innerWidth > 768 ? 3 : 1);
            nextBtn.style.opacity = index >= maxIndex ? '0.5' : '1';
        };

        nextBtn.addEventListener('click', () => {
            const maxIndex = slides.length - (window.innerWidth > 768 ? 3 : 1);
            if (index < maxIndex) {
                index++;
                update();
            }
        });

        prevBtn.addEventListener('click', () => {
            if (index > 0) {
                index--;
                update();
            }
        });

        window.addEventListener('resize', () => {
            index = 0;
            update();
        });

        // Initial call to set state
        update();
    });
}

// Scroll to Top
function initializeScrollButton() {
    const btn = document.getElementById('scrollToTopBtn');
    if (!btn) return;

    window.addEventListener('scroll', () => {
        if (window.scrollY > 300) {
            btn.style.display = 'flex';
        } else {
            btn.style.display = 'none';
        }
    });

    btn.addEventListener('click', () => {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });
}

// Scroll Reveal
function initializeScrollReveal() {
    const sections = document.querySelectorAll('.section');

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
            }
        });
    }, { threshold: 0.1 });

    sections.forEach(section => observer.observe(section));
}

// Card Hover Effects
function initializeCardHoverEffects() {
    // CSS handles most of this now, but we can keep mouse tracking if needed
    // For now, relying on CSS :hover for better performance and simplicity
}
