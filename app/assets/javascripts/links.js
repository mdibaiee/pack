$(function() {
  $('a.delete').click(function(e) {
    e.preventDefault();

    var key = $('[name="csrf-param"]').attr('content');
    var value = $('[name="csrf-token"]').attr('content');
    var data = {};
    data[key] = value;

    $.ajax({
      url: this.href,
      method: 'delete',
      data: data,
      complete: location.reload.bind(location)
    });
  })
})
