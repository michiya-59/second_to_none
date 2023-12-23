document.addEventListener('DOMContentLoaded', function() {
  const videos = document.querySelectorAll('.play-video');

  videos.forEach(function(video) {
    video.addEventListener('click', function(event) {
      event.preventDefault();
      const videoUrl = video.dataset.videoUrl;
      const videoPlayer = document.getElementById('videoPlayer');

      // ロードが完了したら再生を試みます。
      videoPlayer.onloadeddata = function() {
        videoPlayer.play().then(() => {
          console.log('ビデオの再生が開始しました');
        }).catch(error => {
          console.error('動画の再生に失敗しました:', error);
        });
      };

      // 動画の再生が終了した際の処理を設定します。
      videoPlayer.onended = function() {
        const videoId = video.dataset.videoId;
        const userId = video.dataset.userId;

        fetch(`/video_views`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          },
          body: JSON.stringify({ learn_id: videoId, user_id: userId })
        });
      };
    });
  });
});
