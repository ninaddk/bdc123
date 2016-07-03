$(window).on('shown.bs.modal', function() {
    $("form .form-control").eq(0).focus();
});

function showTosterMsg(type, msg){
    //type = success, info, warning, error
    toastr.options = {
        "closeButton": false,
        "debug": false,
        "progressBar": false,
        "preventDuplicates": false,
        "positionClass": "toast-top-right",
        "showDuration": "400",
        "hideDuration": "1000",
        "timeOut": "7000",
        "extendedTimeOut": "1000",
        "showEasing": "swing",
        "hideEasing": "linear",
        "showMethod": "fadeIn",
        "hideMethod": "fadeOut"
    }

    toastr[type](msg)
}

function validateAge(age) {
    if (age === "") {
        return true;
    }

    // convert age to a number
    age = parseInt(age, 10);

    //check if age is a number or less than or greater than 130
    if (isNaN(age) || age < 1 || age > 130) {
        return false;
    }

    return true;
}

function isMobileNumber(mobile) {
    var mob = /^[1-9]{1}[0-9]{9}$/;
    if (mob.test(mobile) == false) {
        return false;
    }
    return true;
}

function isErrorResponce(response){
    if(response.status=='error'){
        return true;
    }
    return false;
}

function getErrorMessage(response){
    return (response.message);
}

function showFormError(id, message){
    jQuery("#"+id).html('<div class="alert alert-danger">'+ message +'</div>').fadeIn();
    setTimeout(function(){ jQuery("#"+id).slideUp(); }, 4000)
}

function getDateFormat(date){
    var newDate = '';
    if(date != null && date != ''){
        var d = new Date(date.replace(/-/g, "/"));
        newDate = d.getDate()+' '+monthNames[d.getMonth()].substr(0, 3)+', '+d.getFullYear();
    }
    return newDate;
}

function getDateTimeFormat(date){
    var newDate = '';
    if(date != null && date != ''){
        var d = new Date(date.replace(/-/g, "/"));
        newDate = getDateLeadingZero(d.getDate())+' '+monthNames[d.getMonth()].substr(0, 3)+', '+d.getFullYear()+' '+ d.getHours()+':'+ d.getMinutes()+':'+ d.getSeconds();
    }
    return newDate;
}

function getTimeFormat(date){
    var newDate = '';
    if(date != null && date != ''){
        var d = new Date(date.replace(/-/g, "/"));
        newDate = d.getHours()+':'+ d.getMinutes()+':'+ d.getSeconds();
    }
    return newDate;
}

function getDateFormatHHMMSS(date){
    var newDate = '';
    if(date != null && date != ''){
        var d = new Date(date.replace(/-/g, "/"));
        newDate = d.getHours()+':'+ d.getMinutes()+':'+ d.getSeconds();
    }
    return newDate;
}

function getDateFormatDDMMYY(date){
    var newDate = '';
    if(date != null && date != ''){
        var d = new Date(date.replace(/-/g, "/"));
        newDate = d.getDate()+'/'+ (d.getMonth()+1) +'/'+d.getFullYear();
    }
    return newDate;
}

function getDateLeadingZero(date){
    return ("0" + date).slice(-2)
}

var monthNames = new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
var monthDays = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
var dayArr = new Array('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday','Sunday');

function gerRowHtml(str){
    if(str!=null){
        return str;
    }else{
        return '';
    }
}