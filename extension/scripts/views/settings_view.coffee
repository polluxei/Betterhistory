class BH.Views.SettingsView extends BH.Views.MainView
  @include BH.Modules.I18n

  className: 'settings_view'

  template: BH.Templates['settings']

  events:
    'click .clear_history': 'clickedClearHistory'
    'click .credits': 'clickedCredits'
    'change #time_grouping': 'changedTimeGrouping'
    'change #time_format': 'changedTimeFormat'
    'click #search_by_domain': 'clickedSearchByDomain'
    'click #search_by_selection': 'clickedSearchBySelection'

  initialize: ->
    @chromeAPI = chrome
    @tracker = analyticsTracker
    @model.off 'change'
    @model.on 'change', (() => @model.save()), @model
    @on 'selected', @activateSocialLinks, @

  pageTitle: ->
    @t('settings_title')

  activateSocialLinks: ->
    !((d,s,id) ->
      js
      fjs=d.getElementsByTagName(s)[0];
      if !d.getElementById(id)
        js=d.createElement(s);
        js.id=id;
        js.src="https://platform.twitter.com/widgets.js";
        fjs.parentNode.insertBefore(js,fjs);
    )(document,"script","twitter-wjs");
    window.___gcfg = {lang: @t('google_plus_language')}
    (->
      po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
      po.src = 'https://apis.google.com/js/plusone.js';
      s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
    )()

  render: ->
    presenter = new BH.Presenters.SettingsPresenter(@model)
    properties = _.extend {}, @getI18nValues(), presenter.settings()
    html = Mustache.to_html @template, properties
    @$el.append html
    @populateFields()
    @

  populateFields: ->
    @$('#search_by_domain').prop 'checked', @model.get('searchByDomain')
    @$('#search_by_selection').prop 'checked', @model.get('searchBySelection')

  clickedSearchByDomain: (ev) ->
    @model.set searchByDomain: $(ev.currentTarget).is(':checked')

    backgroundPage = @chromeAPI.extension.getBackgroundPage()
    method = if @model.get('searchByDomain') then 'create' else 'remove'

    backgroundPage.pageContextMenu[method]()

  clickedSearchBySelection: (ev) ->
    @model.set searchBySelection: $(ev.currentTarget).prop('checked')

    backgroundPage = @chromeAPI.extension.getBackgroundPage()
    method = if @model.get('searchBySelection') then 'create' else 'remove'

    backgroundPage.selectionContextMenu[method]()

  clickedClearHistory: (ev) ->
    ev.preventDefault()
    @chromeAPI.tabs.create url:'chrome://settings/clearBrowserData'

  clickedCredits: (ev) ->
    ev.preventDefault()
    creditsModal = new BH.Modals.CreditsModal()
    $('body').append(creditsModal.render().el)
    creditsModal.open()

  getI18nValues: ->
    properties = @t([
      'settings_title',
      'clearing_history_section_title',
      'clear_history_button',
      'right_click_options_section_title',
      'search_by_text_selection_label',
      'search_by_domain_label',
      'whats_new_section_title',
      'feedback_section_title',
      'spread_the_word_section_title',
      'leave_a_review',
      'twitter_template',
      'twitter_language',
      'mailing_list_link',
      'syncing_settings_title',
      'manually_sync_local_link'
    ])
    properties['i18n_syncing_settings_login'] = @t('syncing_settings_login', [
      '<a style="text-decoration: underline;" href="#" id="sign_in">',
      '</a>'
    ])
    properties['i18n_credits_link'] = @t('credits_link', [
      '<strong>',
      '</strong>'
    ])
    properties['i18n_permissions_details'] = @t('permissions_details', [
      '<a href="http://www.better-history.com/permissions">',
      '</a>'
    ])
    properties['i18n_suggestions_bugs_comments'] = @t('suggestions_bugs_comments', [
      '<a href="http://twitter.com/Better_History">',
      '</a>'
    ])
    properties
