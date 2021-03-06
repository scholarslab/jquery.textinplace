(function() {
  (function($) {
    return $.widget('solrsearch.textinplace', {
      options: {
        form_name: null,
        revert_to: null
      },
      _create: function() {
        var form_name, revert_to, text;
        this.element.addClass('textinplace');
        form_name = this._initFormName();
        text = $.trim(this.element.text());
        revert_to = this.options.revert_to;
        if (revert_to == null) {
          revert_to = text;
        }
        this.element.html('');
        this.hidden = $("<input type=\"hidden\" name=\"" + form_name + "\"\n  data-revertto=\"" + revert_to + "\" />");
        this.hidden.val(text);
        this.div = $("<div class=\"valuewrap\">\n  <span class=\"value\">" + text + "</span>\n  <span class=\"icons\">\n    <i class=\"icon-pencil\"></i>\n    <i class=\"icon-repeat\"></i>\n  </span>\n</div>");
        this.text = null;
        this.element.append(this.hidden);
        this.element.append(this.div);
        return this._bindEvents();
      },
      _setOption: function(key, val) {
        switch (key) {
          case 'revert_to':
            this.hidden.attr('data-revertto', val);
        }
        return $.Widget.prototype._setOption.apply(this, arguments);
      },
      destroy: function() {
        this._destroy();
        return $.Widget.prototype.destroy.call(this);
      },
      _destroy: function() {},
      _initFormName: function() {
        var _base;
        return (_base = this.options).form_name != null ? _base.form_name : _base.form_name = this.element.attr('id');
      },
      _escape: function(input) {
        return input.replace(/\W/, '_').replace(/_+/, '_');
      },
      _bindEvents: function() {
        return this.div.on('click', (function(_this) {
          return function(ev) {
            return _this._click(ev);
          };
        })(this)).find('.icon-repeat').click((function(_this) {
          return function(ev) {
            _this._revert();
            return ev.stopPropagation();
          };
        })(this));
      },
      _click: function() {
        this.div.hide();
        if (this.text == null) {
          this.text = this._createTextInput();
        }
        this.text.show();
        return this.text.focus();
      },
      _revert: function() {
        var value;
        value = this.hidden.attr('data-revertto');
        return this._setValue(value);
      },
      _createTextInput: function() {
        var name, text, value;
        name = this.options.form_name + "_text";
        value = this.hidden.val();
        text = $("<input type=\"text\" name=\"" + name + "\" form=\"\" />");
        text.val(value);
        this.element.append(text);
        text.blur((function(_this) {
          return function(ev) {
            return _this._textDone();
          };
        })(this));
        text.keyup((function(_this) {
          return function(ev) {
            if (ev.key === 'Enter' || ev.keyCode === 13) {
              _this._textDone();
              ev.preventDefault();
              ev.stopImmediatePropagation();
              return ev.stopPropagation();
            }
          };
        })(this));
        return text;
      },
      _textDone: function() {
        this.text.hide();
        this._setValue(this.text.val());
        return this.div.show();
      },
      _setValue: function(value) {
        $('.value', this.div).html(value);
        this.text.val(value);
        return this.hidden.val(value);
      }
    });
  })(jQuery);

}).call(this);
