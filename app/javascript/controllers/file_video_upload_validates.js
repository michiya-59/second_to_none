document.addEventListener('DOMContentLoaded', function() {
  document.querySelector('.document_file').addEventListener('change', function(e) {
    // ファイルタイプを取得（フォームのaccept属性から）
    var allowedFileTypes = this.getAttribute('accept').split(',');
    // 許容される最大ファイルサイズを取得（データ属性から）
    var maxFileSize = parseInt(this.getAttribute('data-max-file-size'));
    // ファイルタイプのラベルを取得（データ属性から）
    var fileTypeLabel = this.getAttribute('data-file-type');
    // 許可されているファイルタイプの表示用文字列を取得（データ属性から）
    var allowedTypesDisplay = this.getAttribute('data-allowed-types-display');

    validateFile(this, allowedFileTypes, maxFileSize, fileTypeLabel, allowedTypesDisplay);
  });

  document.querySelector('.video_file').addEventListener('change', function(e) {
    var allowedFileTypes = this.getAttribute('accept').split(',');
    var maxFileSize = parseInt(this.getAttribute('data-max-file-size'));
    var fileTypeLabel = this.getAttribute('data-file-type');
    var allowedTypesDisplay = this.getAttribute('data-allowed-types-display');

    validateFile(this, allowedFileTypes, maxFileSize, fileTypeLabel, allowedTypesDisplay);
  });

  function validateFile(input, allowedTypes, maxFileSize, fileTypeLabel, allowedTypesDisplay) {
    // ユーザーによって選択されたファイルを取得
    var file = input.files[0];
    // ファイルが選択されていなければ、以降のバリデーションを行わない
    if (!file) return; 

    // ファイルのサイズをMB単位で計算
    var fileSizeInMB = file.size / (1024 * 1024); 
    var maxFileSize = maxFileSize / (1024 * 1024); 
    // ファイルの拡張子を取得（小文字に変換して比較に使用）
    var fileExtension = '.' + file.name.split('.').pop().toLowerCase();
    
    // 選択されたファイルのタイプまたは拡張子が許可されていない場合は警告を表示
    if (!allowedTypes.includes(file.type) && !allowedTypes.includes(fileExtension)) {
      alert(`${fileTypeLabel}のファイルは許可されていないフォーマットです。許可されているフォーマット: ${allowedTypesDisplay}`);
      input.value = '';
    } else if (fileSizeInMB > maxFileSize) {
      // ファイルのサイズが最大許容サイズを超えている場合は警告を表示
      alert(`${fileTypeLabel}のファイルサイズが大きすぎます。許容される最大サイズ: ${maxFileSize}MB`);
      input.value = '';
    }
  }
});
