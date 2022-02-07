$(document).ready(function (e) {
  const offset = 20;
  // If a user clicks on any anchor element (a) within a list item tag (li) on our sidebar with the class sidebarNav (.sidebarNav), execute this function
  $('body.sola-sessions .nav-link').click(function(event) {
    // Prevent the normal scroll behavior
    event.preventDefault();

    // Grab the clicked element's href tag, scroll that element into view
    // $($(this).attr('href'))[0].scrollIntoView();
    // Scroll 0 pixels horizontally and -60 (really negative offset) vertically
    // scrollBy(0, -offset);
    const value = $($(this).attr('href'))[0].offsetTop - offset;
    scrollTo({ top: value, behavior: 'smooth' });
  });
})