$(window).load(function () {
	$("#sign_up input").bind({
		  focusin: function(){
          $(this).css("border", "1px solid black");
      },
      focusout: function(){
          $(this).css("border", "1px solid #9a9a9a");
      }
	});
});

// Stream page
$(window).load(function () {
    $('#share_prompt #content').autoResize();
    
    // behaviour for comment input
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
