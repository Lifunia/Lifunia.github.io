const devicePicker = document.querySelector('[data-quick-device]');
const devicePanels = document.querySelectorAll('[data-quick-panel]');

if (devicePicker && devicePanels.length) {
  const showDevice = () => {
    for (const panel of devicePanels) {
      panel.hidden = panel.dataset.quickPanel !== devicePicker.value;
    }
  };
  devicePicker.addEventListener('change', showDevice);
  showDevice();
  devicePicker.hidden = false;
  document.querySelector('[data-quick-device-label]').hidden = false;
}
