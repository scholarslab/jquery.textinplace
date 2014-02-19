
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 cc=80;

# @package    jquery.textinplace
# @copyright  2012 Rector and Board of Visitors, University of Virginia
# @license    http://www.apache.org/licenses/LICENSE-2.0.html
# @author     Eric Rochester <err8n@eservices.virginia.edu>

(($) ->

  $.widget 'solrsearch.textinplace',

    options: {
      form_name : null
      revert_to : null
    }

    _create: ->

      @element.addClass('textinplace')
      form_name  = this._initFormName()
      text       = $.trim @element.text()
      revert_to  = @options.revert_to
      revert_to ?= text

      @element.html ''

      @hidden = $("""
        <input type="hidden" name="#{form_name}"
          data-revertto="#{revert_to}" />
      """)

      @hidden.val text

      @div = $("""
        <div class="valuewrap">
          <span class="value">#{text}</span>
          <span class="icons">
            <i class="icon-pencil"></i>
            <i class="icon-repeat"></i>
          </span>
        </div>
      """)

      @text = null

      @element.append @hidden
      @element.append @div

      this._bindEvents()

    _setOption: (key, val) ->
      switch key
        when 'revert_to' then @hidden.attr 'data-revertto', val

      # For jQuery UI <= 1.8
      $.Widget.prototype._setOption.apply this, arguments
      # For jQuery UI >= 1.9
      # this._super '_setOption', key, val

    destroy: ->
      this._destroy()
      # For jQuery UI <= 1.8
      $.Widget.prototype.destroy.call this

    # For jQuery UI >= 1.9
    _destroy: ->

    _initFormName: ->
      @options.form_name ?= @element.attr('id')

    # This escapes the input by replacing all non-alphanumeric characters with
    # underscores and by normalizing sequences of underscores.
    _escape: (input) ->
      input.replace(/\W/, '_').replace(/_+/, '_')

    _bindEvents: ->
      @div
        .on('click', (ev) => this._click(ev))
        .find('.icon-repeat')
        .click((ev) =>
          this._revert()
          ev.stopPropagation()
        )

    _click: ->
      @div.hide()
      @text ?= this._createTextInput()
      @text.show()
      @text.focus()

    _revert: ->
      value = @hidden.attr 'data-revertto'
      this._setValue value

    _createTextInput: ->

      name  = @options.form_name + "_text"
      value = @hidden.val()

      text = $("""
        <input type="text" name="#{name}" form="" />
      """)

      text.val value

      @element.append text

      text.blur (ev) =>
        this._textDone()

      text.keyup (ev) =>
        if ev.key == 'Enter' || ev.keyCode == 13
          this._textDone()
          ev.preventDefault()
          ev.stopImmediatePropagation()
          ev.stopPropagation()

      text

    _textDone: ->
      @text.hide()
      this._setValue @text.val()
      @div.show()

    _setValue: (value) ->
      $('.value', @div).html value
      @text.val value
      @hidden.val value

)(jQuery)
