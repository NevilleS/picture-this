(function() {

  $(document).ready(function() {
    var $window, colorChange, sections;
    $(".navigation td").fitText(0.2, {
      minFontSize: '30px',
      maxFontSize: '40px'
    });
    $('#top span, .home').click(function() {
      return $('.navigation td').each(function(index) {
        var _this = this;
        return setTimeout((function() {
          return $(_this).addClass('active');
        }), index * 50);
      });
    });
    $('td a').click(function() {
      return $('.navigation td').each(function(index) {
        var _this = this;
        return setTimeout((function() {
          return $(_this).removeClass('active');
        }), index * 50);
      });
    });
    $window = $(window);
    colorChange = $('.color-change');
    sections = $('.layout-full').get().reverse();
    return $window.scroll(function() {
      var section, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = sections.length; _i < _len; _i++) {
        section = sections[_i];
        if ($window.scrollTop() - $(section).offset().top > -100) {
          colorChange.css({
            'background-color': '#' + $(section).attr('id')
          });
          break;
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    });
	$.localScroll();
  });

}).call(this);