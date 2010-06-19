$(window).load(function () {
	$("#sign_up input").bind({
		  focusin: function(){
          $(this).css("border", "1px solid black");
      },
      focusout: function(){
          $(this).css("border", "1px solid #9a9a9a");
      }
	});
    $("#sign_up code").toggle(
        function () {
            $(this).css("height","15em");
        },
        function () {
            $(this).css("height","");
        }
    );
});


// Stream page
$(window).load(function () {
    // hinting, and autoresize, and hiding submit button
    $('#share_prompt textarea').autoResize().data("hint","Say something or ask a question...").css("color","#9a9a9a");
    $('.comments textarea').autoResize().data("hint","share something...").css("color","#9a9a9a");
    $("#share_prompt, .comments").find(".submit").hide();

    $("#share_prompt, .comments").find("textarea").each(function () {
        $(this).val($(this).data("hint"));
    }).bind({
        focusin: function(){
            if($(this).data("changed") == undefined) {
                $(this).val("").css("color","#000");
            }
            $(this).parent("form").find(".submit").show();
        },
        change: function() {
            $(this).data("changed",true);
        },
        focusout: function(){
            if($(this).val() == "") {
                $(this).val($(this).data("hint")).css("color","#9a9a9a");
                $(this).parent("form").find(".submit").hide();
                $(this).removeData("changed");
            }
        },
    });
});
