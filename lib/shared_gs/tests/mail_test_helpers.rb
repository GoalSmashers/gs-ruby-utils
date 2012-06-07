module MailTestHelpers
  def body_has?(email, text)
    assert_equal(true, email.text_part.body.include?(text), text)
    assert_equal(true, email.html_part.body.include?(text), text)
  end

  def body_has_no?(email, text)
    assert_equal(false, email.text_part.body.include?(text), text)
    assert_equal(false, email.html_part.body.include?(text), text)
  end
end