# frozen_string_literal: true

module WhySolaHelper
  def why_sola_sections
    result = %i[why_sola sola_pro]
    result << :solagenius if english_locale?
    result << :booknow if english_locale?
    result << :education
    result << :beauty_hive if english_locale?
    result << :the_sola_store if english_locale?
    result
  end
end
