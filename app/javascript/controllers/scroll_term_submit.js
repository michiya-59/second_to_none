document.addEventListener('DOMContentLoaded', function() {
  var termsEl = document.getElementById('terms-scroll');
  var agreeCheckbox = document.getElementById('agree-checkbox');
  var businessOwnerCheckbox = document.getElementById('business-owner-checkbox');
  var registrationLink = document.getElementById('registration-link');

  function checkScroll() {
    if (termsEl.scrollHeight <= termsEl.clientHeight || termsEl.scrollHeight - termsEl.scrollTop <= termsEl.clientHeight + 1) {
      agreeCheckbox.disabled = false;
    } else {
      agreeCheckbox.disabled = true;
      agreeCheckbox.checked = false;
      businessOwnerCheckbox.checked = false;
      businessOwnerCheckbox.disabled = true;
      registrationLink.classList.remove('enabled');
    }
  }

  termsEl.addEventListener('scroll', checkScroll);
  checkScroll(); // Call on initial load

  agreeCheckbox.addEventListener('change', function() {
    if (this.checked) {
      businessOwnerCheckbox.disabled = false;
    } else {
      businessOwnerCheckbox.checked = false;
      businessOwnerCheckbox.disabled = true;
      registrationLink.classList.remove('enabled');
    }
    enableRegistrationLink();
  });

  businessOwnerCheckbox.addEventListener('change', function() {
    enableRegistrationLink();
  });

  function enableRegistrationLink() {
    if (agreeCheckbox.checked && businessOwnerCheckbox.checked) {
      registrationLink.classList.add('enabled');
    } else {
      registrationLink.classList.remove('enabled');
    }
  }
});
