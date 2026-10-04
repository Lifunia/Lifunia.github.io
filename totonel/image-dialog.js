const imageDialog = document.getElementById('totonel-image-dialog');
const enlargedViewport = imageDialog.querySelector('.totonel-image-dialog-viewport');
const enlargedImage = enlargedViewport.querySelector('img');

for (const button of document.querySelectorAll('.totonel-image-zoom')) {
  button.addEventListener('click', () => {
    const sourceImage = button.querySelector('img');
    enlargedImage.src = sourceImage.currentSrc || sourceImage.src;
    enlargedImage.alt = sourceImage.alt;
    // Preserve the original proportions when screenshot dimensions differ.
    enlargedViewport.style.aspectRatio = sourceImage.getAttribute('width') + ' / ' + sourceImage.getAttribute('height');
    imageDialog.showModal();
  });
}

imageDialog.addEventListener('click', (event) => {
  if (event.target === imageDialog) {
    imageDialog.close();
  }
});
