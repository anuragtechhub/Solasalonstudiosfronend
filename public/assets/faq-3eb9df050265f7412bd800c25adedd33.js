$(function () {

  $('.faq-question').click(function () {
    var $question = $(this);
    var $answer = $question.next('.faq-answer')

    $('.faq-question').not($question).removeClass('active');
    $('.faq-answer').not($answer).slideUp('fast');

    $question.addClass('active');
    $answer.slideDown('fast');
  });

});
