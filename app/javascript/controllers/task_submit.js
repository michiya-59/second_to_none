document.addEventListener("DOMContentLoaded", function() {
  var form = document.getElementById("task_form");

  form.addEventListener("submit", function(event) {
    var message = "本当に提出しますか？\n一度提出すると再提出はできませんのでご了承ください。";
    if (!confirm(message)) {
      event.preventDefault();
    }
  });
});