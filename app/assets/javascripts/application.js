// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap/alert
//= require bootstrap/dropdown
//= require_tree .



(function() {

  //生成订单
  $('.create-order-form').submit(function() {
    var addressID = $('input[name="address_id"]:checked').val(),
        $form = $(this);

    if (!addressID) {
      alert("请选择收货地址!");
      return false;
    } else {
      $form.find('input[name="address_id"]').val(addressID);
      return true;
    }
  })

  //收货地址
  $(document).on('click', '.new-address-btn', function() {
    $.get('/addresses/new', function(data) {
      if ($('#address_form_modal').length > 0) {
        $('#address_form_modal').remove();
      }

      $('body').append(data);
      $('#address_form_modal').modal();
    })

    return false;
  })
  .on('ajax:success', '.address-form', function(e, data) {
    if (data.status == 'ok') {
      $('#address_form_modal').modal('hide');
      $('#address_list').html(data.data);
    } else {
      $('#address_form_modal').html($(data.data).html());
    }
  })
  .on('ajax:success', '.edit-address-btn', function(e, data) {
    if ($('#address_form_modal').length > 0) {
      $('#address_form_modal').remove();
    }

    $('body').append(data);
    $('#address_form_modal').modal();
  })
  .on('ajax:success', '.set-default-address-btn, .remove-address-btn', function(e, data) {
    $('#address_list').html(data.data);
  })

  // 购物车
  $('.add-to-cart-btn').on('click', function() {
    var $this = $(this),
        $amount = $('input[name="amount"]'),
        $prog = $this.find('i');

    if ($amount.length > 0 && parseInt($amount.val()) <= 0) {
      alert("购买数量至少为 1");
      return false;
    }

    $.ajax({
      url: $this.attr('href'),
      method: 'post',
      data: { product_id: $this.data('product-id'), amount: $amount.val() },
      beforeSend: function() {
        if (!$prog.hasClass('fa-spin')) {
          $prog.addClass('fa-spin');
        }
        $prog.show();
      },
      success: function(data) {
        if ($('#shopping_cart_modal').length > 0) {
          $('#shopping_cart_modal').remove();
        }

        $('body').append(data);
        $('#shopping_cart_modal').modal();
      },
      complete: function() {
        $prog.hide();
      }
    })

    return false;
  })

})()
