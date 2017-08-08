$(function () {
  $('.select-a-state .option').click();
  //$('.select-a-location .option').click();

  //contact us thank you handler for canada...
  window.contactUsFormSuccessHandler = function (data) {
    window.location.href = '/contact-us-thank-you';
  }
});