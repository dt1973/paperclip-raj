// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require forem
//= require_tree .

$.mediaPoller = {
  poll: function() {
    console.log('Ran `poll`');

    setTimeout(this.request, 5000);
  },
  request: function(photo_id) {
    console.log('Ran `request`');

    $.ajax({
      url: "/check_photo_status/#{ photo_id }.js",
      type: "GET",
      success: function(html, textStatus, xhr){
        $.mediaPoller.addMedia(html);
      },
      error: function(xhr, textStatus, errorThrown) {
        console.log(textStatus, errorThrown);

        // Start again

        $.mediaPoller.poll();
      }
    });
  },
  addMedia: function(html) {
    console.log('Ran `addMedia`');

    $(html).prependTo($('.photos'));

    console.log('New media was added');
  }
};

$(function() {
  if($('.photos .processing').length) {
    console.log('Ran `poll`');

    $.mediaPoller.poll();
  }
});

