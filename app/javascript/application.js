// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener('DOMContentLoaded', () => {
    const searchInput = document.getElementById('pokemon-search');
    const searchResults = document.getElementById('search-results');
    let debounceTimer;
    
    if (searchInput) {
        searchInput.addEventListener('input', (e) => {
            const query = e.target.value.trim();

            // Clear previous timer
            clearTimeout(debounceTimer);

            // Hide results if query is empty
            if (query.length === 0) {
                searchResults.style.display = "none";
                return;
            }

            // Debounce: wait 500ms/half a second after user stops typing
            debounceTimer = setTimeout(() => {
                searchPokemons(query);
            }, 500);
        });

            // CLosedropdown when the outside is clicked
        document.addEventListener('click', (e) => {
            if (!searchInput.contains(e.target) && !searchResults.contains(e.target)) {
                searchResults.style.display = "none";
            }
        });
    }

    async function searchPokemons(query) {
        try {
            const response = await fetch(`/pokemons/search?query=${encodeURIComponent(query)}`);
            const pokemons = await response.json();

            displayResults(pokemons);
        } catch (error) {
            console.error("Search error:", error);
        }
    }

    function displayResults(pokemons) {
        const resultsContainer = searchResults.querySelector('.dropdown-content');

        if (pokemons.length === 0) {
            resultsContainer.innerHTML = '<div class="dropdown-item" style="font-size: 18px; color:black;">No pokemon Found</div>';
            searchResults.style.display = "block";
            return;
        }

        resultsContainer.innerHTML = pokemons.map(pokemon => `
            <a href="/pokemons/${pokemon.id}" class="dropdown-item" style="display: flex; align-items: center; padding: 0.2rem 1rem;">
            <img src="${pokemon.sprite_url}" alt="${pokemon.name}" style="width: 70px; height: 70px; margin: 0 3rem 0 2rem;">
            <span style="font-size: 18px; color:black;">${pokemon.name}</span></a>`).join('');
        
        searchResults.style.display = "block";
    }
});    
