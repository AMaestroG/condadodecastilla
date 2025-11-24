document.addEventListener('DOMContentLoaded', function () {
    // Load Header & Footer
    loadComponent('/_header.html', 'header-placeholder', initializeNavigation);
    loadComponent('/_footer.html', 'footer-placeholder');
});

function loadComponent(url, placeholderId, callback) {
    fetch(url)
        .then(response => response.text())
        .then(data => {
            const placeholder = document.getElementById(placeholderId);
            if (placeholder) {
                placeholder.innerHTML = data;
                if (callback) callback();
            }
        })
        .catch(error => console.error('Error loading component:', error));
}

function initializeNavigation() {
    const toggle = document.getElementById('mobile-toggle');
    const menu = document.getElementById('nav-menu');

    if (toggle && menu) {
        toggle.addEventListener('click', () => {
            menu.classList.toggle('active');
            const overlay = document.getElementById('menu-overlay');
            if (overlay) overlay.classList.toggle('active');

            const icon = toggle.querySelector('i');
            if (menu.classList.contains('active')) {
                icon.classList.remove('fa-bars');
                icon.classList.add('fa-times');
            } else {
                icon.classList.remove('fa-times');
                icon.classList.add('fa-bars');
            }
        });

        // Close menu when clicking overlay
        const overlay = document.getElementById('menu-overlay');
        if (overlay) {
            overlay.addEventListener('click', () => {
                menu.classList.remove('active');
                overlay.classList.remove('active');
                const icon = toggle.querySelector('i');
                icon.classList.remove('fa-times');
                icon.classList.add('fa-bars');
            });
        }
    }
}
