function openLinkedDetails(hash) {
  const target = document.getElementById(hash.slice(1));
  if (!(target instanceof HTMLDetailsElement)) {
    return;
  }

  // Open before scrolling so the linked guide is visible below the sticky header.
  target.open = true;
  target.scrollIntoView({ block: 'start' });
}

for (const link of document.querySelectorAll('a[href^="#"]')) {
  link.addEventListener('click', (event) => {
    if (event.ctrlKey || event.metaKey || event.shiftKey || event.altKey) {
      return;
    }

    // Also reopen a manually closed guide when the URL already has its hash.
    openLinkedDetails(link.getAttribute('href'));
  });
}

window.addEventListener('hashchange', () => {
  openLinkedDetails(window.location.hash);
});

openLinkedDetails(window.location.hash);

// Mobile navigation uses the same section IDs and details-opening behavior.
for (const menu of document.querySelectorAll('.section-select')) {
  menu.addEventListener('change', () => {
    const hash = menu.value;
    const target = document.getElementById(hash.slice(1));
    if (!hash.startsWith('#') || !target) {
      return;
    }
    openLinkedDetails(hash);
    window.location.hash = hash;
    // Also jump when the user chooses the section already in the URL.
    target.scrollIntoView({ block: 'start' });
  });

  function updateSelectedSection() {
    for (const option of menu.options) {
      if (option.value === window.location.hash) {
        menu.value = option.value;
        return;
      }
    }
    menu.value = '';
  }

  window.addEventListener('hashchange', updateSelectedSection);
  updateSelectedSection();
}
