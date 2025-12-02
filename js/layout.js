document.addEventListener('DOMContentLoaded', function () {
    const root = window.siteRoot || '';
    console.log('Initializing layout with root:', root);

    // Helper to load HTML fragments
    const loadFragment = async (url, elementId) => {
        try {
            const response = await fetch(url);
            if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
            const html = await response.text();
            const element = document.getElementById(elementId);
            if (element) {
                element.innerHTML = html;

                // Fix relative paths in the loaded fragment
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');
                // (Optional: logic to fix paths if needed, but usually siteRoot handles it)

                // Re-initialize scripts/components for the fragment
                if (elementId === 'header-placeholder') {
                    initializeSidebarNavigation();
                    initializeThemeToggle();
                    initializeLanguageToggle();
                    initializeGoogleTranslate();
                }
            }
        } catch (error) {
            console.error(`Error loading ${url}:`, error);
            if (window.location.protocol === 'file:') {
                console.warn('NOTE: Fetching external HTML fragments (header/footer) often fails on "file://" protocol due to browser security (CORS). Please use a local server (e.g., VS Code Live Server) to view the full site experience.');
                const el = document.getElementById(elementId);
                if (el) el.innerHTML = `<div style="padding: 20px; text-align: center; background: #fff3cd; color: #856404; border: 1px solid #ffeeba;">⚠️ Component could not load on local file system. Please use a local server.</div>`;
            }
        }
    };

    // Load Header and Footer
    const headerPath = `${root}fragments/header.html`; // Assuming fragments are in a 'fragments' folder or similar, but based on previous code it was _header.html
    // Wait, previous code used root + '_header.html'. Let's stick to that to avoid breaking paths.
    const headerUrl = `${root}_header.html`;
    const footerUrl = `${root}_footer.html`;

    Promise.all([
        loadFragment(headerUrl, 'header-placeholder'),
        loadFragment(footerUrl, 'footer-placeholder')
    ]).then(() => {
        // Initialize other components after DOM is ready
        initializeScrollReveal();
        initializeScrollButton();
        initializeCarousels();

        // Project 2026 Initializations
        initializeSmoothScroll();
        initializeScrollProgress();
        initialize3DTilt();
    });
});

// --- Component Initializers ---

function initializeSidebarNavigation() {
    const sidebarToggle = document.getElementById('sidebar-toggle');
    const sidebar = document.getElementById('sidebar');

    if (!sidebarToggle || !sidebar) return;

    sidebarToggle.addEventListener('click', (e) => {
        e.stopPropagation();
        sidebar.classList.toggle('sidebar-visible');
        const icon = sidebarToggle.querySelector('i');
        if (icon) icon.className = sidebar.classList.contains('sidebar-visible') ? 'fas fa-times' : 'fas fa-bars';
    });

    document.addEventListener('click', (e) => {
        if (sidebar.classList.contains('sidebar-visible') && !sidebar.contains(e.target) && !sidebarToggle.contains(e.target)) {
            sidebar.classList.remove('sidebar-visible');
            const icon = sidebarToggle.querySelector('i');
            if (icon) icon.className = 'fas fa-bars';
        }
    });
}

function initializeThemeToggle() {
    const themeToggle = document.getElementById('theme-toggle');
    const body = document.body;
    if (!themeToggle) return;

    const icon = themeToggle.querySelector('i');
    const savedTheme = localStorage.getItem('theme');
    if (savedTheme === 'dark') {
        body.classList.add('dark-mode');
        if (icon) icon.className = 'fas fa-sun';
    }

    themeToggle.addEventListener('click', () => {
        body.classList.toggle('dark-mode');
        const isDark = body.classList.contains('dark-mode');
        if (icon) icon.className = isDark ? 'fas fa-sun' : 'fas fa-moon';
        localStorage.setItem('theme', isDark ? 'dark' : 'light');
    });
}

function initializeLanguageToggle() {
    const langToggle = document.getElementById('lang-toggle');
    const langBar = document.getElementById('language-bar');
    const closeLangBar = document.getElementById('close-lang-bar');

    if (!langToggle || !langBar) return;

    langToggle.addEventListener('click', (e) => {
        e.stopPropagation();
        document.body.classList.toggle('lang-open');
        langBar.classList.toggle('active');
    });

    if (closeLangBar) {
        closeLangBar.addEventListener('click', (e) => {
            e.stopPropagation();
            document.body.classList.remove('lang-open');
            langBar.classList.remove('active');
        });
    }
}

function initializeGoogleTranslate() {
    if (document.querySelector('script[src*="translate.google.com"]')) return;
    const script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = '//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit';
    document.head.appendChild(script);
}

window.googleTranslateElementInit = function () {
    if (window.location.protocol === 'file:') {
        console.log('Google Translate disabled on file:// protocol to prevent CORS errors.');
        return;
    }
    new google.translate.TranslateElement({
        pageLanguage: 'es',
        includedLanguages: 'en,fr,de,it,pt,ca,eu,gl',
        layout: google.translate.TranslateElement.InlineLayout.SIMPLE,
        autoDisplay: false
    }, 'google_translate_element');
};

function initializeCarousels() {
    const carousels = document.querySelectorAll('.carousel-container');
    carousels.forEach(carousel => {
        const track = carousel.querySelector('.carousel-track');
        const nextBtn = carousel.querySelector('.carousel-button.next');
        const prevBtn = carousel.querySelector('.carousel-button.prev');
        if (!track || !nextBtn || !prevBtn) return;

        let index = 0;
        const update = () => {
            const slides = track.children;
            if (slides.length === 0) return;
            const slideWidth = slides[0].getBoundingClientRect().width;
            const gap = 20;
            track.style.transform = `translateX(-${index * (slideWidth + gap)}px)`;
            prevBtn.style.opacity = index === 0 ? '0.5' : '1';
            const maxIndex = slides.length - (window.innerWidth > 768 ? 3 : 1);
            nextBtn.style.opacity = index >= maxIndex ? '0.5' : '1';
        };

        nextBtn.addEventListener('click', () => {
            const slides = track.children;
            const maxIndex = slides.length - (window.innerWidth > 768 ? 3 : 1);
            if (index < maxIndex) { index++; update(); }
        });

        prevBtn.addEventListener('click', () => {
            if (index > 0) { index--; update(); }
        });

        window.addEventListener('resize', () => { index = 0; update(); });
        // Initial update with a small delay to ensure layout is ready
        setTimeout(update, 100);
    });
}

function initializeScrollButton() {
    const btn = document.getElementById('scrollToTopBtn');
    if (!btn) return;
    window.addEventListener('scroll', () => {
        btn.style.display = window.scrollY > 300 ? 'flex' : 'none';
    });
    btn.addEventListener('click', () => window.scrollTo({ top: 0, behavior: 'smooth' }));
}

function initializeScrollReveal() {
    const elements = document.querySelectorAll('.section, .scroll-reveal');
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) entry.target.classList.add('visible');
        });
    }, { threshold: 0.1 });
    elements.forEach(el => observer.observe(el));
}

// --- Project 2026 Functions ---

function initializeSmoothScroll() {
    if (window.innerWidth > 768) {
        document.documentElement.style.scrollBehavior = 'smooth';
        window.addEventListener('scroll', () => {
            const scrolled = window.scrollY;
            const heroBg = document.querySelector('.hero');
            if (heroBg) {
                heroBg.style.backgroundSize = `${100 + (scrolled * 0.05)}%`;
                heroBg.style.backgroundPosition = `center ${scrolled * 0.5}px`;
            }
        });
    }
}

function initializeScrollProgress() {
    const progressBar = document.createElement('div');
    progressBar.className = 'scroll-progress-bar';
    Object.assign(progressBar.style, {
        position: 'fixed', top: '0', left: '0', height: '4px',
        background: 'var(--condado-gold-gradient)', zIndex: '10000',
        width: '0%', transition: 'width 0.1s ease-out'
    });
    document.body.appendChild(progressBar);
    window.addEventListener('scroll', () => {
        const winScroll = document.body.scrollTop || document.documentElement.scrollTop;
        const height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
        const scrolled = (winScroll / height) * 100;
        progressBar.style.width = scrolled + "%";
    });
}

function initialize3DTilt() {
    const cards = document.querySelectorAll('.imperial-card, .chrono-card');
    cards.forEach(card => {
        card.addEventListener('mousemove', (e) => {
            const rect = card.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;
            const centerX = rect.width / 2;
            const centerY = rect.height / 2;
            const rotateX = ((y - centerY) / centerY) * -5;
            const rotateY = ((x - centerX) / centerX) * 5;
            card.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale3d(1.02, 1.02, 1.02)`;
        });
        card.addEventListener('mouseleave', () => {
            card.style.transform = 'perspective(1000px) rotateX(0) rotateY(0) scale3d(1, 1, 1)';
        });
    });
}
