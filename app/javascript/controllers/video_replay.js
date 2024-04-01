document.addEventListener("DOMContentLoaded", () => {
  const videoLinks = document.querySelectorAll('.play-video');
  const videoModal = document.getElementById('videoModal');
  const videoPlayer = document.getElementById('videoPlayer');
  const closeModal = document.querySelector('.modal .close');
  
  document.querySelectorAll('video[class="common_box_beige common_size16"]').forEach(function(video) {
    video.addEventListener('play', function() {
      if (video.requestFullscreen) {
        video.requestFullscreen();
      } else if (video.webkitRequestFullscreen) { /* Safari */
        video.webkitRequestFullscreen();
      } else if (video.msRequestFullscreen) { /* IE11 */
        video.msRequestFullscreen();
      }
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
