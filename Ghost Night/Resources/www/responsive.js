jQuery(function($) {
    var isNeedResize = $('iframe[width][height]').length > 0;
    $('iframe[width][height]').each(function() {
        var w = $(this).parent().width();
        var w2 = $(this).width();
        var h = $(this).height();
                                    
        if (h > w2) {
            h = w * (h/w2);
        } else {
            h = w * 0.5625;
        }
        $(this).removeAttr('width').removeAttr('height').css({
            width : w + 'px',
            height : h + 'px'
        });
    });

    if (isNeedResize && (typeof IOS !== 'undefined')) {
        IOS.reloadWithActualSize('<html>' + $('html').html() + '</html>');
    }
});
