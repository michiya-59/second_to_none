document.addEventListener('DOMContentLoaded', function() {
  var fileInput = document.getElementById('file_field');

  fileInput.addEventListener('change', function() {
    if (fileInput.files.length > 3) {
      alert('ファイルは3つまでです。');
      fileInput.value = ''; // 選択されたファイルをクリア
    }
  });
});
