
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 cc=80;

# @package    jquery.textinplace
# @copyright  2012 Rector and Board of Visitors, University of Virginia
# @license    http://www.apache.org/licenses/LICENSE-2.0.html
# @author     Eric Rochester <err8n@eservices.virginia.edu>

describe 'The TextInPlace widget', ->

  todel = []
  n = 0

  createDiv = (text='', options={}, setup=null) ->
    div = $ "<div id='tip#{n}'>#{text}</div>"

    $('body').append(div)
    todel.push div

    setup(div) if setup?
    $(div).textinplace(options)

  getTextNodes = (el) ->
    $(el).contents().filter( ->
      this.nodeType == 3
    )

  triggerEditing = (div) ->
    val = div.find 'span.value'
    val.each ->
      $(this).click()
    val

  editBlur = (div, text) ->
    input = div.find ':text'
    input.val text
    input.each -> $(this).blur()
    input

  beforeEach ->
    n += 1

  afterEach ->
    $(id).remove() for id in todel
    todel.length = 0

  describe 'the container div', ->

    it 'should have no contents', ->
      div = createDiv("initial text #{n}")
      texts = (n.nodeValue for n in getTextNodes(div)).join('')
      expect(texts).toBe('')

    it 'should add a .textinplace class to the container div', ->
      div = createDiv()
      expect(div.hasClass('textinplace')).toBeTruthy()

    it 'should maintain existing classes on the container div', ->
      div = createDiv('', {}, (d) -> d.addClass('something'))
      expect(div.hasClass('something')).toBeTruthy()

  describe 'the hidden input element', ->

    it 'should be created', ->
      div = createDiv()
      expect(div.find('input[type="hidden"]').size()).toBe(1)

    it 'should have a default name', ->
      div = createDiv()
      expect(div.find('input[type="hidden"]').attr('name')).toBe(div.attr('id'))

    it 'should use a custom name', ->
      div = createDiv('', { form_name: 'customname' })
      expect(div.find('input[type="hidden"]').attr('name')).toBe('customname')

    it 'should have the value of the initial div', ->
      div = createDiv("initial text #{n}")
      expect(div.find('input[type="hidden"]').val()).toBe("initial text #{n}")

    it 'should trim the value', ->
      div = createDiv(" initial text #{n} ")
      expect(div.find('input[type="hidden"]').val()).toBe("initial text #{n}")

    it 'should preserve single quotes', ->
      div = createDiv("'initial text'")
      expect(div.find('input[type="hidden"]').val()).toBe("'initial text'")

    it 'should preserve double quotes', ->
      div = createDiv('"initial text"')
      expect(div.find('input[type="hidden"]').val()).toBe('"initial text"')

  describe 'the visible div', ->

    it 'should wrap the initial value', ->
      div = createDiv("initial text #{n}")
      expect(div.find('span.value').html()).toBe("initial text #{n}")

  describe 'the text input', ->

    it 'should hide the value div', ->
      div = createDiv("initial text #{n}")
      text = triggerEditing div
      expect(text.is ':visible').toBeFalsy()

    it 'should make a visible text input when the value div is clicked on', ->
      div = createDiv("initial text #{n}")
      triggerEditing div
      text = div.find(':text')
      expect(text.size()).toBe 1
      expect(text.val()).toBe "initial text #{n}"

    it 'should hide the text input when it loses focus', ->
      div = createDiv("initial text #{n}")
      triggerEditing div
      text = editBlur div, ''
      expect(text.is(':visible')).toBeFalsy()

    it 'should update the hidden input when the text input loses focus', ->
      div = createDiv("initial text #{n}")
      triggerEditing div
      editBlur div, "updated text #{n}"
      expect(div.find('input[type="hidden"]').attr('value')).toBe("updated text #{n}")

    it 'should update the visible div when the text input loses focus', ->
      div = createDiv("initial text #{n}")
      triggerEditing div
      editBlur div, "updated text #{n}"
      expect(div.find('span.value').html()).toBe("updated text #{n}")

    it 'should show the value div when the text input loses focus', ->
      div = createDiv("initial text #{n}")
      triggerEditing div
      editBlur div, "updated text #{n}"
      expect(div.find('span.value').is(':visible')).toBeTruthy()
