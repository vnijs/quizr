// from http://stackoverflow.com/a/31078774/1974918
$(function(){
  $("body").on('hidden.bs.modal', function (e) {
    var $iframe = $(e.target).find("iframe");
    $iframe.attr("src", $iframe.attr("src"));
  });
});

// $(function(){
//   $("body").on('hidden.bs.modal', function (e) {
//     var $iframes = $(e.target).find("iframe");
//     $iframes.each(function(iframe){
//       $(iframe).attr("src", $(iframe).attr("src"));
//     };
//   });
// });
