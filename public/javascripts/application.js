// landing page
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
    $("#user_username").bind({
        focusin: function() {
            $(this).css("color","black");
            $(this).val("");
            $(this).unbind("focusin");
        }
    });
});

$(window).load(function () {
	
	$(".sign_up_input").bind({
		focusin: function(){
            $(this).css("border", "1px solid black");
        },
        focusout: function(){
            $(this).css("border", "1px solid #9a9a9a");
        }
	});
	
	$(".submit_button").bind({
		mouseover: function(){
            $(this).css("border", "1px solid black");
        },
        mouseout: function(){
			$(this).css("border", "1px solid #d7d7d7");
		}
	});
});

$(window).load(function () {
    $('#comments textarea').autoResize();
    
    $("#comments .submit").hide();
    var comment_hint = "share a comment..."
    $("#comments textarea").
        val(comment_hint).bind({
            focusin: function(){
                if($(this).data("changed") == undefined)
                    $(this).val("");
                $(this).parent("form").find(".submit").show();
            },
            change: function() {
                $(this).data("changed",true);
            },
            focusout: function(){
                if($(this).val() == "") {
                    $(this).val(comment_hint);
                    $(this).parent("form").find(".submit").hide();
                    $(this).removeData("changed");
                }
            },
        });
});
