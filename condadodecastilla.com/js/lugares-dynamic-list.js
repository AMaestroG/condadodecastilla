document.addEventListener('DOMContentLoaded', function() {
    // Ensure alfozPlaces is loaded (from lugares-data.js)
    if (typeof alfozPlaces !== 'undefined' && alfozPlaces.length > 0) {
        displayPlaces(alfozPlaces, 'dynamic-alfoz-list-container');
    } else {
        console.error('Error: alfozPlaces data not found or is empty. Make sure lugares-data.js is loaded correctly.');
        // Optionally, display a message to the user in the container
        const container = document.getElementById('dynamic-alfoz-list-container');
        if (container) {
            container.innerHTML = '<p>No se pudieron cargar los lugares. Inténtalo de nuevo más tarde.</p>';
        }
    }
});

function displayPlaces(placesArray, containerId) {
    const container = document.getElementById(containerId);

    if (!container) {
        console.error(`Error: Container element with ID "${containerId}" not found.`);
        return;
    }

    // Clear any existing content
    container.innerHTML = '';

    // Create a document fragment to append elements efficiently
    const fragment = document.createDocumentFragment();

    placesArray.forEach(place => {
        const placeDiv = document.createElement('div');
        placeDiv.className = 'emblematic-place-summary'; // Using the class from the example

        const heading = document.createElement('h3');
        const link = document.createElement('a');
        link.href = place.path;
        link.textContent = place.name;
        heading.appendChild(link);

        const descriptionPara = document.createElement('p');
        descriptionPara.textContent = place.description;

        placeDiv.appendChild(heading);
        placeDiv.appendChild(descriptionPara);
        
        fragment.appendChild(placeDiv);
    });

    // Append all new elements to the container at once
    container.appendChild(fragment);
}
