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
