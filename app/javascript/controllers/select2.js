import TomSelect from "tom-select";

document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll("#select2").forEach(selectElement => {
    new TomSelect(selectElement, {
      plugins: ['dropdown_input'],
      placeholder: "選択してください",
      loadingMore: "さらに読み込む…",
      noResults: "結果が見つかりません"
    });
  });
});
