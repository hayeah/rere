// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(window).load(function () {
    $('.sayText').focus();

    $('.sayText').keydown(function(event) {
        if (event.keyCode == '13') {
            $(this).parentsUntil("form").submit();
            $(this).blur();
            $('.saySubmit').focus().click();
            event.preventDefault();
        }
    });

});