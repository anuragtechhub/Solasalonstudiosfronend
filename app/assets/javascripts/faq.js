$(function () {

  $('.faq-question').click(function () {
    var $question = $(this);
    var $answer = $question.next('.faq-answer')

    $('.faq-answer').not($answer).slideUp('fast');
    $answer.slideDown('fast');
  });

});