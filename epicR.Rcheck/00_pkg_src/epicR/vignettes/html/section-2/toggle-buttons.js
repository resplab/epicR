document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.btn-primary').forEach(button => {
    button.addEventListener('click', () => {
      const target = document.querySelector(button.getAttribute('data-target'));
      if (target) {
        target.classList.toggle('show');
      }
    });
  });
});
