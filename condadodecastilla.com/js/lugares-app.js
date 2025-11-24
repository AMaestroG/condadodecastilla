document.addEventListener('DOMContentLoaded', function () {
    // Check if alfozPlaces data is loaded
    if (typeof alfozPlaces !== 'undefined') {
        initializeAtlas(alfozPlaces);
    } else {
        console.error('Error: lugares-data.js not loaded.');
        document.getElementById('atlas-grid').innerHTML = '<p class="error-msg">Error cargando los datos del Atlas.</p>';
    }
});

function initializeAtlas(places) {
    const grid = document.getElementById('atlas-grid');
    const searchInput = document.getElementById('atlas-search');
    const countDisplay = document.getElementById('atlas-count');

    // Initial Render
    renderPlaces(places, grid);
    updateCount(places.length, countDisplay);

    // Search Listener
    searchInput.addEventListener('input', (e) => {
        const query = e.target.value.toLowerCase();
        const filteredPlaces = places.filter(place =>
            place.name.toLowerCase().includes(query) ||
            (place.description && place.description.toLowerCase().includes(query))
        );
        renderPlaces(filteredPlaces, grid);
        updateCount(filteredPlaces.length, countDisplay);
    });
}

function renderPlaces(places, container) {
    container.innerHTML = ''; // Clear current

    if (places.length === 0) {
        container.innerHTML = '<p class="no-results">No se encontraron lugares en el Atlas.</p>';
        return;
    }

    places.forEach((place, index) => {
        const card = document.createElement('div');
        card.className = 'card scroll-reveal';
        card.style.animationDelay = `${index * 0.05}s`; // Staggered animation

        // Use a default image if none provided (or try to guess based on name if we had a map)
        // For now, we'll use a placeholder or a generic one
        const imgSrc = place.image || '/assets/img/escudo.jpg';

        card.innerHTML = `
            <div class="card-img-wrapper">
                <img src="${imgSrc}" alt="${place.name}" class="card-img" loading="lazy">
            </div>
            <div class="card-content">
                <h3>${place.name}</h3>
                <p>${place.description || 'Un lugar histórico del Alfoz.'}</p>
                <a href="${place.path}" class="btn btn-secondary btn-sm">Explorar</a>
            </div>
        `;
        container.appendChild(card);
    });

    // Re-trigger scroll animations for new elements
    if (window.initializeScrollAnimations) {
        // Small delay to ensure DOM is ready
        setTimeout(() => {
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('visible');
                    }
                });
            }, { threshold: 0.1 });

            container.querySelectorAll('.scroll-reveal').forEach(el => observer.observe(el));
        }, 100);
    }
}

function updateCount(count, element) {
    if (element) {
        element.textContent = `${count} Lugares Encontrados`;
    }
}
