i18n = {
  fetch: function(keys) {
    var lookup = {};
    $.each(keys, function() {
      lookup['i18n_' + this] = chrome.i18n.getMessage(this.toString());
    });
    return lookup;
  },

  settings: function() {
    return i18n.fetch([
      'settings_title',
      'clearing_history_section_title',
      'clear_history_button',
      'visit_grouping_section_title',
      'group_visits_by_label',
      '60_minutes_option',
      '30_minutes_option',
      '15_minutes_option',
      'time_format_label',
      '24_hours_option',
      '12_hours_option',
      'group_visits_by_domain_label',
      'right_click_options_section_title',
      'search_by_text_selection_label',
      'search_by_domain_label',
      'whats_new_section_title',
      'view_release_announcement_link',
      'current_version_label',
      'credits',
      'feedback_section_title',
      'voice_your_thoughts_on',
      'i_will_respond',
      'spread_the_word',
      'leave_a_review'
    ]);
  },

  sidebar: function() {
    return i18n.fetch([
      'search_input_placeholder_text',
      'settings_link'
    ]);
  },

  filter: function() {
    return i18n.fetch([
      'collapse_button',
      'expand_button',
      'delete_all_visits_for_filter_button',
      'no_visits_found'
    ]);
  },

  app: function() {
    return i18n.fetch([
      'history_title'
    ]);
  },

  timeVisit: function() {
    return i18n.fetch([
      'visits_label'
    ]);
  },

  groupedVisits: function() {
    return i18n.fetch([
      'collapse_button',
      'expand_button'
    ]);
  },

  prompt: function() {
    return i18n.fetch([
      'prompt_delete_button',
      'prompt_cancel_button',
      'prompt_title'
    ]);
  },

  credits: function() {
    return i18n.fetch([
      'credits_title',
      'developed_by',
      'translators_heading',
      'spanish',
      'swedish',
      'german',
      'french',
      'italian',
      'hungarian',
      'chinese_simplified',
      'arabic',
      'polish',
      'portuguese',
      'russian',
      'translation_help_heading',
      'translation_instructions',
      'close_button'
    ]);
  },

  version: function() {
    return i18n.fetch([
      'version_title',
      'version_description',
      'version_items',
      'close_button',
      'whats_new'
    ]);
  },

  search: function() {
    return i18n.fetch([
      'search_time_frame'
    ]);
  }
};
