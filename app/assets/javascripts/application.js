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
//= require bootstrap
//= require turbolinks
//= require_tree .

function MemberDashboardListener() {
  $('#member-dash select').on('change', function() {
    var value = this.value;

    console.log(value);

    if (value == "all") {
      $('#member-dash ul').show();
    } else {
      $('#member-dash ul').hide();
      $('.' + value).show();
    }
  });
}

var ready;
ready = function() {
  $(".statistics li").tooltip();

  $(".slack_set_member").on('change', function() {
    var github = this.dataset.github;

    $.post(window.location + '/slack_github', { github: github, slack: this.value }).done(function() {
      location.reload();
    });
  });

  $('.collapsor').on('click', function(e) {
    $(e.currentTarget).children('i').toggleClass("fa-caret-down").toggleClass("fa-caret-right");
  });

  MemberDashboardListener();

  $(document).on('shown.bs.tab', 'a[data-toggle="tab"]', function (e) {
    $('#member-dash select').val('all').change();
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
