module ContentHelpers
  def have_flash_notice(text)
    have_css '.flash.notice', text: text
  end

  def have_flash_alert(text)
    have_css '.flash.alert', text: text
  end
end
