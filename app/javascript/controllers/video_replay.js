document.addEventListener("DOMContentLoaded", () => {
  const videoLinks = document.querySelectorAll('.play-video');
  const videoModal = document.getElementById('videoModal');
  const videoPlayer = document.getElementById('videoPlayer');
  const closeModal = document.querySelector('.modal .close');

  videoLinks.forEach(link => {
    link.addEventListener('click', function(event) {
      event.preventDefault();
      videoPlayer.src = this.dataset.videoUrl;
      videoModal.style.display = 'block';
      videoPlayer.play();
    });
  });

  // モーダルを閉じる
  const closeModalFunction = () => {
    videoModal.style.display = 'none';
    videoPlayer.pause();
    videoPlayer.currentTime = 0;
  }

  if (closeModal) {
    closeModal.addEventListener('click', closeModalFunction);
  }

  // モーダルの外側をクリックしたときに閉じる
  window.addEventListener('click', (event) => {
    if (event.target == videoModal) {
      closeModalFunction();
    }
  });
});
