$(document).ready(function() {
  $("[data-timer]").each(function() {
    var cTime = $(this).attr('data-timer');
    cTime = Date.parse(cTime);
    $(this).countdown({
      until: new Date(cTime),
      compact: true,
      layout: '{d<}{dn} DAY(S) {d>}{hnn}{sep}{mnn}{sep}{snn}',
      onExpiry: removeActiveSaleEventFromDom
    });
  });
});

function removeActiveSaleEventFromDom() {
  $(this).closest('li').remove();
}