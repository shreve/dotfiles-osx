/* Toggl.com
 *
 * I have 2 problems to solve with Toggl:
 *
 *  1. I keep going to toggl.com, which doesn't redirect to new.toggl.com
 *  2. Toggl doesn't allow login autofilling
 *
 * The redirect is pretty easy to deal with, but I'm still not too sure
 * about autofilling. I put my email backwards in the file to prevent scrapers,
 * but I don't have a solution for my password :/
 */

if (window.location.host == "www.toggl.com") {
  window.location = "https://new.toggl.com";
}

String.prototype.reverse = function() {
  return this.split('').reverse().join('');
}

$(document).ready(function() {
  setTimeout(function() {
    if ($('#logoutId').is(':visible')) {
      window.location = $('#logoutId a').attr('href');
    } else {
      $('button.login').click();
      var email = 'yl.everhs@bocaj'; // you can never be too careful
      $('#login_email').val(email.reverse());
      $('#remember_me').click();
      $('#login_password').focus();
    }
  }, 1000);
});
