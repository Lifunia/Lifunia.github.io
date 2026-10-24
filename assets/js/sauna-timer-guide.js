const guidePicker = document.querySelector('#guide-device');
const guidePanels = document.querySelectorAll('.sauna-device-guide');

function guideTarget(hash) {
  if (!hash || hash === '#') return null;
  try {
    return document.getElementById(decodeURIComponent(hash.slice(1)));
  } catch {
    return null;
  }
}

function showGuide(id) {
  if (!guidePicker || !Array.from(guidePanels).some((panel) => panel.id === id)) return;
  guidePicker.value = id;
  for (const panel of guidePanels) panel.hidden = panel.id !== id;
}

// A direct link must also select the series containing its target.
function revealGuide(hash) {
  const target = guideTarget(hash);
  if (!target) return;
  const panel = target.closest('.sauna-device-guide');
  if (panel) showGuide(panel.id);
  target.scrollIntoView();
}

if (guidePicker && guidePanels.length) {
  showGuide(guidePicker.value);
  guidePicker.hidden = false;
  document.querySelector('label[for="guide-device"]').hidden = false;
  guidePicker.addEventListener('change', () => {
    const previousTarget = guideTarget(window.location.hash);
    showGuide(guidePicker.value);
    // Keep reloads on the selected series after leaving a deep-linked guide.
    if (previousTarget?.closest('.sauna-device-guide')) {
      history.replaceState(null, '', `#${guidePicker.value}`);
    }
  });
}

document.addEventListener('click', (event) => {
  const link = event.target.closest('a[href^="#"]');
  if (link) revealGuide(link.hash);
});
window.addEventListener('hashchange', () => revealGuide(window.location.hash));
revealGuide(window.location.hash);
