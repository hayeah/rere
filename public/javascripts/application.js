$(window).load(function () {
    $("#login input").bind({
        focusin: function() {
            $(this).val("");
        }
    });
});
