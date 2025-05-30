document.querySelectorAll('.accordion-button').forEach(button => {
    button.addEventListener('click', () => {
        const collapse = button.parentElement.nextElementSibling;
        const isOpen = collapse.classList.contains('open');

        // Close all panels
        document.querySelectorAll('.accordion-collapse.open').forEach(openCollapse => {
            openCollapse.style.maxHeight = openCollapse.scrollHeight + 'px'; // Set current height to trigger transition
            setTimeout(() => {
                openCollapse.style.maxHeight = '0px';
                openCollapse.classList.remove('open');
            }, 10); // Slight delay allows CSS to transition from scrollHeight to 0
        });

        if (!isOpen) {
            collapse.classList.add('open');
            collapse.style.maxHeight = collapse.scrollHeight + 'px';
        }
    });
});
