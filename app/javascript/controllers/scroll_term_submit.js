document.addEventListener('DOMContentLoaded', function() {
  var el = document.getElementById('terms-scroll');
  var checkbox = document.getElementById('agree-checkbox');
  var link = document.getElementById('registration-link');

  function checkScroll() {
    if (el.scrollHeight <= el.clientHeight || el.scrollHeight - el.scrollTop <= el.clientHeight + 1) {
      checkbox.disabled = false;
    } else {
      checkbox.disabled = true;
      checkbox.checked = false;
      link.classList.remove('enabled');
    }
  }

  el.addEventListener('scroll', checkScroll);
  checkScroll(); // Call on initial load

  checkbox.addEventListener('change', function() {
    if (this.checked) {
      link.classList.add('enabled');
    } else {
      link.classList.remove('enabled');
    }
  });
});