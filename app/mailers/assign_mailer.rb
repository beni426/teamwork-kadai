class AssignMailer < ApplicationMailer
  default from: 'from@example.com'

  def assign_mail(email, password)
    @email = email
    @password = password
    mail to: @email, subject: I18n.t('views.messages.complete_registration')
  end
  def delete_agenda(email_list)
    @email_list = email_list
    mail to: @email_list, subject: "アジェンダの削除"
  end
  def assign_owner_mail(email)
    @email = email
    mail to: @email, subject: 'team owner　になりました！'
  end
end