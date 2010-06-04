$(window).load(function () {
    var password_field_hint = "<input id='user_password' name='user[password]' size='30' type='text' value='password' tabindex='2'/>";
    var password_field = "<input id='user_password' name='user[password]' size='30' type='password' value='' tabindex='2'/>";
    $("#user_password").replaceWith(password_field_hint);
    $("#user_password").bind({
        focusin: function() {
            var replacement = $(password_field);
            replacement.css("color","#000");
            $(this).replaceWith(replacement);
            replacement.focus();
            $(this).unbind("focusin");
        }
    });
    $("#user_email").bind({
        focusin: function() {
            $(this).css("color","black");
            $(this).val("");
            $(this).unbind("focusin");
        }
    });
});
