module WhySolaHelper
  def why_sola_sections
    result = %i[why_sola sola_pro]
    result << :solagenius unless canadian_locale?
    result << :booknow unless canadian_locale?
    result << :education
    result << :beauty_hive unless canadian_locale?
    result << :the_sola_store
    result
  end
end