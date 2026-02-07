// Theme toggle with localStorage persistence
(function() {
  const toggle = document.getElementById('theme-toggle');
  const root = document.documentElement;

  function setTheme(dark) {
    root.setAttribute('data-theme', dark ? 'dark' : 'light');
    localStorage.setItem('theme', dark ? 'dark' : 'light');
  }

  // Initialize from localStorage or system preference
  const saved = localStorage.getItem('theme');
  if (saved) {
    setTheme(saved === 'dark');
  } else if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
    setTheme(true);
  }

  // Click toggle
  if (toggle) {
    toggle.addEventListener('click', function() {
      const isDark = root.getAttribute('data-theme') === 'dark';
      setTheme(!isDark);
    });
  }

  // Keyboard shortcut: press 'd' to toggle (not in inputs)
  document.addEventListener('keydown', function(e) {
    if (e.key === 'd' && !['INPUT', 'TEXTAREA', 'SELECT'].includes(e.target.tagName)) {
      const isDark = root.getAttribute('data-theme') === 'dark';
      setTheme(!isDark);
    }
  });
})();
