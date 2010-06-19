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
    $('#share_prompt textarea').data("hint","Say something or ask a question...");
    $('.comments textarea').data("hint","share something...");
    $("#share_prompt, .comments").find(".submit").hide();

    var inputs = $("#share_prompt, .comments").find("textarea");
    inputs.autoResize().css("color","#9a9a9a");

    inputs.each(function () {
        $(this).val($(this).data("hint"));
        $.extend(this,{
            "show_hint":function(){
                $(this).val($(this).data("hint")).css("color","#9a9a9a");
                $(this).parent("form").find(".submit").hide();
                $(this).removeData("changed");
            },
            "for_input":function(){
                $(this).css("color","#000");
                $(this).parent("form").find(".submit").show();
            },
            "no_input":function(){
                return $(this).data("changed") == undefined || $.trim($(this).val()) == ""
            }
            
        });
    }).bind({
        focusin: function(){
            if(this.no_input()) { $(this).val("") }
            this.for_input();
        },
        keypress: function() {
            $(this).data("changed",true);
        },
        focusout: function(){
            if(this.no_input()) { this.show_hint(); }
        },
    });

    $("#thoughts .comments form").bind({
        "ajax:success":function(e,data,status,xhr) {
            var input = $(this).find("textarea[name]").each(function(){this.show_hint()});
        },
        "ajax:failure":function(e,xhr,status,error) {
            alert("oops, something went wrong");
        }
    });
});
