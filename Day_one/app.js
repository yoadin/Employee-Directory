const searchInput = document.getElementById('search-input');
const employeeCards = document.querySelectorAll('.empolyees-card');

searchInput.addEventListener('input', event => {
    const query = event.target.value.trim().toLowerCase();

    employeeCards.forEach(card => {
        const name = card.querySelector('h3')?.textContent.toLowerCase() || '';
        const matches = name.includes(query);
        card.style.display = matches ? '' : 'none';
    });
});


