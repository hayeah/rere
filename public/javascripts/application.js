$(window).load(function () {
    var password_field_hint = "<input id='user_password' name='user[password]' size='30' type='text' value='password'/>";
    var password_field = "<input id='user_password' name='user[password]' size='30' type='password' value=''/>";
    $("#user_password").replaceWith(password_field_hint);
    $("#user_password").bind({
        focusin: function() {
            $(this).replaceWith(password_field);
        }
    });
    $("#login input").bind({
        focusin: function() {
            $(this).val("");
        }
    });
});
