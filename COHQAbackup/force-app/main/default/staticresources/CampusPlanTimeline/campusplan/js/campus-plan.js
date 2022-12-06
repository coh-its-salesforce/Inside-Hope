$(function () {
    $('.timeline-wrapper ul li').on('click', function () {
        $('.timeline-wrapper ul li').removeClass('active');

        $(this).addClass('active');
    });
});