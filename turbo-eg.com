script>
    /*$(window).on("load", function () {
        var s = '';
        $.ajax({ 
           data: {s: s, action:'send_form'},
           type: 'post',
           url: 'https://turbo-eg.com/wp-admin/admin-ajax.php',
           success: function(data) {
            $('.suggest-search').html(data)
        }
    });
});*/

$('#input-suggest').on('keyup paste change',function(e){
    var s = $(this).val();
    $.ajax({ 
     data: {s: s, action:'send_form'},
     type: 'post',
     url: 'https://turbo-eg.com/wp-admin/admin-ajax.php',
     success: function(data) {
        if (data != '') {
            $('.suggest-search').html(data).show();
        } else {
            $('.suggest-search').html("لا يوجد بحث").show();
        }
    }
});
});

$('.client_name,.client_phone,.client_email,.client_category_type,.orders_volume,.how_did_hear_about_us,.address,.company_name').on('keyup change',function(e){
    if ($(this).val()) {
        $(this).removeClass('error');
    }

});
$('.service_type').on('click',function(e){
    if ($('.service_type:checked').length) {
        $('.service_type_container').removeClass('error');
    }
});
$("#create-client").click(function(e){
    var $this = $(this);
    var form  = $this.attr('data-form');
    var name  = $('.client_name').val();
    var company_name  = $('.company_name').val();
    var address  = $('.address').val();
    var city  = $('.city').val();
    var phone = $('.client_phone').val();
    var website_url = $('.website_url').val();
    var how_did_hear_about_us = $('.how_did_hear_about_us').val();
    var category_type = $('.client_category_type').val();
    var orders_volume = $('.orders_volume').val();
    var service_type = $(".service_type:checked").map(function() {
                return this.value;
            }).get().join(', ');

    $('.error1').html('').hide();

    var error = false;
    if (!name) {
        $('.client_name').addClass('error');
        $('.client_name_error_msg').html("هذا الحقل مطلوب").show();
        error = true;
    } else if(name.length < 3) {
        $('.client_name').addClass('error');
        $('.client_name_error_msg').html("برجاء ادخال 3 حروف عالاقل").show();
        error = true;        
    }
    if (!company_name) {
        $('.company_name').addClass('error');
        $('.company_name_error_msg').html("هذا الحقل مطلوب").show();
        error = true;
    } else if(name.length < 3) {
        $('.company_name').addClass('error');
        $('.company_name_error_msg').html("برجاء ادخال 3 حروف عالاقل").show();
        error = true;        
    }
    /*if (!website_url) {
        $('.website_url').addClass('error');
        $('.website_url_error_msg').html("هذا الحقل مطلوب").show();
        error = true;
    }*/
    /*if (!address) {
        $('.address').addClass('error');
        $('.address_error_msg').html("هذا الحقل مطلوب").show();
        error = true;
    } else if(address.length < 3) {
        $('.address').addClass('error');
        $('.address_error_msg').html("برجاء ادخال 3 حروف عالاقل").show();
        error = true;        
    }*/
    /*if (email != '' && !isEmail(email)) {
        $('.email').addClass('error');
        $('.email_error_msg').html("برجاء ادخال بريد الكترونى صحيح").show();
        error = true;
    }*/
    if (!phone) {
        $('.client_phone').addClass('error');
        $('.client_phone_error_msg').html("هذا الحقل مطلوب").show();
        error = true;
    } else if (!phone.startsWith("01")) {
        $('.client_phone').addClass('error');
        $('.client_phone_error_msg').html("برجاء ادخال رقم تليفون صحيح").show();
        error = true;
    }
    if (!how_did_hear_about_us && form != 'contact') {
        $('.how_did_hear_about_us').addClass('error');
        $('.how_did_hear_about_us_error_msg').html("هذا الحقل مطلوب").show();
        error = true;
    }
    if (!category_type && form != 'contact') {
        $('.client_category_type').addClass('error');
        $('.client_category_type_error_msg').html("هذا الحقل مطلوب").show();
        error = true;
    }
    if (!orders_volume) {
        $('.orders_volume').addClass('error');
        $('.orders_volume_error_msg').html("هذا الحقل مطلوب").show();
        error = true;
    }
    if (!service_type && form != 'contact') {
        $('.service_type_container').addClass('error');
        $('.service_type_error_msg').html("هذا الحقل مطلوب").show();
        error = true;
    }
    if (error) {
        $('.error-msg').html("برجاء ادخال البيانات الناقصة").show();
        return;
    }
    $.ajax({ 
        data: {
            name:name,
            company_name:company_name,
            phone:phone,
            address:address,
            city:city,
            website_url:website_url, 
            category_type:category_type,
            how_did_hear_about_us:how_did_hear_about_us,
            orders_volume:orders_volume,
            service_type:service_type,
            action:'create_client'
        },
       type: 'post',
       dataType: 'json',
       url: 'https://turbo-eg.com/wp-admin/admin-ajax.php',
       beforeSend: function(data) {
            $('.success-msg').hide();
            $('.error-msg').hide();
            $('.error1').hide();
            $('#create-client').hide();
            $('#create-client-loading').show();
       },
       success: function(data) {
            if (data.success) {
                $('.client_name').val('');
                $('.company_name').val('');
                $('.address').val('');
                $('.client_phone').val('');
                $('.client_website_url').val('');
                $('.how_did_hear_about_us').val('');
                $('.client_category_type').val('');
                $('.orders_volume').val('');
                $(".service_type").prop('checked', false);
                $('.success-msg').show()
                $('.error-msg').hide();
                $('.sub-header-register').hide();
                $('.form-container').hide();
                $('.success-msg').show().html(data.msg);
            } else {
                $('.error-msg').show().html(data.msg);
                $('.success-msg').hide();
            }
        },
        complete: function() {
            $('#create-client').show();
            $('#create-client-loading').hide();
        },
    });
});

function isEmail(email) {
  var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
  return regex.test(email);
}
