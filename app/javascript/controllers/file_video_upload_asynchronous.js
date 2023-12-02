import { DirectUpload } from "@rails/activestorage"

document.addEventListener("DOMContentLoaded", () => {
  const inputElement = document.querySelector('.video_file');
  const formElement = inputElement.closest('form'); // 親フォーム要素を取得

  inputElement.addEventListener("change", (event) => {
    Array.from(event.target.files).forEach(file => {
      const upload = new DirectUpload(file, inputElement.dataset.directUploadUrl);

      upload.create((error, blob) => {
        if (error) {
          console.error(error);
        } else {
          // アップロード成功時の処理
          const hiddenField = document.createElement('input');
          hiddenField.type = 'hidden';
          hiddenField.value = blob.signed_id;
          hiddenField.name = inputElement.name;
          formElement.appendChild(hiddenField);
          formElement.submit(); // フォームをサブミット
        }
      });
    });
  });
});
