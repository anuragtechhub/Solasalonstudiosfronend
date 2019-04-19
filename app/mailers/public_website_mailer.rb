class PublicWebsiteMailer < ActionMailer::Base
  default :from => "Sola Salon Studios <inquiry@solasalonstudios.com>"

  def sejasola(nome, email, telefone, area_de_atuacao)
    @nome = nome
    @email = email
    @telefone = telefone
    @area_de_atuacao = area_de_atuacao
    mail(to: 'sejasola@solasalons.com', bcc: 'jeff@jeffbail.com', from: "Sola Salon Studios <sejasola@solasalons.com>", subject: 'Seja Sola - Submissão de Formulário')
  end

  def request_a_tour(requestTourInquiry)
    # headers['X-SMTPAPI'] = `{
    #   "category": "Request a Tour",
    #   "filters" : {
    #     "clicktrack" : {
    #       "settings" : {
    #         "enable" : 1
    #       }
    #     },
    #     "opentrack" : {
    #       "settings" : {
    #         "enable" : 1
    #       }
    #     }
    #   }
    # }`
    headers['X-SMTPAPI'] = '{"category": "Request a Tour"}'

    if requestTourInquiry && requestTourInquiry.location && requestTourInquiry.location.email_address_for_inquiries && requestTourInquiry.location.email_address_for_inquiries.present?
      @inquiry = requestTourInquiry
      mail(to: requestTourInquiry.location.email_address_for_inquiries, from: ("Sola Salon Studios <inquiry@solasalonstudios.com>"), subject: @inquiry.message.present? ? 'Sola Contact Us Inquiry' : 'Sola Rent a Studio Inquiry') #requestTourInquiry.location.email_address_for_inquiries
    end
  end

  def stylist_message(stylistMessage)
    # headers['X-SMTPAPI'] = `{
    #   "category": "Stylist Message",
    #   "filters" : {
    #     "clicktrack" : {
    #       "settings" : {
    #         "enable" : 1
    #       }
    #     },
    #     "opentrack" : {
    #       "settings" : {
    #         "enable" : 1
    #       }
    #     }
    #   }
    # }`
    headers['X-SMTPAPI'] = '{"category": "Stylist Message"}'

    if stylistMessage && stylistMessage.stylist && stylistMessage.stylist.email_address && stylistMessage.stylist.email_address.present?
      @message = stylistMessage
      mail(to: stylistMessage.stylist.website_email_address.present? ? stylistMessage.stylist.website_email_address : stylistMessage.stylist.email_address, from: "Sola Salon Studios <inquiry@solasalonstudios.com>", subject: 'Sola Website Inquiry') #stylistMessage.stylist.email_address
    end
  end

  def franchising_request(franchisingRequest)
    # headers['X-SMTPAPI'] = `{
    #   "category": "Franchising Request",
    #   "filters" : {
    #     "clicktrack" : {
    #       "settings" : {
    #         "enable" : 1
    #       }
    #     },
    #     "opentrack" : {
    #       "settings" : {
    #         "enable" : 1
    #       }
    #     }
    #   }
    # }`
    if franchisingRequest && franchisingRequest.request_type.present?
        headers['X-SMTPAPI'] = '{"category": "#{franchisingRequest.request_type} Franchising Request"}'
    else 
        headers['X-SMTPAPI'] = '{"category": "Franchising Request"}'
    end
    
    if franchisingRequest
      @message = franchisingRequest
      ##{franchisingRequest.request_type.present? ? franchisingRequest.request_type : ''} 
      mail(to: 'ben@solasalonstudios.com', from: "Sola Salon Studios <inquiry@solasalonstudios.com>", subject: "Franchising Request")
    end
  end

  def partner_inquiry(partnerInquiry)
    # headers['X-SMTPAPI'] = `{
    #   "category": "Partner Inquiry",
    #   "filters" : {
    #     "clicktrack" : {
    #       "settings" : {
    #         "enable" : 1
    #       }
    #     },
    #     "opentrack" : {
    #       "settings" : {
    #         "enable" : 1
    #       }
    #     }
    #   }
    # }`

    headers['X-SMTPAPI'] = '{"category": "Partner Inquiry"}'

    if partnerInquiry
      @inquiry = partnerInquiry
      mail(to: 'info@solasalonstudios.com', from: "Sola Salon Studios <inquiry@solasalonstudios.com>", subject: 'Sola Partner Inquiry')
    end
  end

  def forgot_password(admin)
    # headers['X-SMTPAPI'] = `{
    #   "category": "Forgot Password",
    #   "filters" : {
    #     "clicktrack" : {
    #       "settings" : {
    #         "enable" : 1
    #       }
    #     },
    #     "opentrack" : {
    #       "settings" : {
    #         "enable" : 1
    #       }
    #     }
    #   }
    # }`

    headers['X-SMTPAPI'] = '{"category": "Forgot Password"}'

    if admin
      @key = admin.forgot_password_key
      @username = admin.email
      mail(to: admin.email_address, from: "Sola Salon Studios <inquiry@solasalonstudios.com>", subject: 'Forgot Password Reset')
    end
  end

  def stylist_website_is_updated(update_my_sola_website)
    # headers['X-SMTPAPI'] = `{
    #   "category": "Update My Sola Website",
    #   "filters" : {
    #     "clicktrack" : {
    #       "settings" : {
    #         "enable" : 1
    #       }
    #     },
    #     "opentrack" : {
    #       "settings" : {
    #         "enable" : 1
    #       }
    #     }
    #   }
    # }`

    headers['X-SMTPAPI'] = '{"category": "Update My Sola Website"}'

    if update_my_sola_website
      @update_my_sola_website = update_my_sola_website
      if @update_my_sola_website && @update_my_sola_website.stylist && @update_my_sola_website.stylist.email_address
        mail(to: @update_my_sola_website.stylist.email_address, from: "Sola Salon Studios <inquiry@solasalonstudios.com>", subject: 'Your Sola Website Has Been Updated!')
      end
    end
  end

  def update_my_sola_website_reminder(update_my_sola_website)
    # headers['X-SMTPAPI'] = `{
    #   "category": "Update My Sola Website Reminder",
    #   "filters" : {
    #     "clicktrack" : {
    #       "settings" : {
    #         "enable" : 1
    #       }
    #     },
    #     "opentrack" : {
    #       "settings" : {
    #         "enable" : 1
    #       }
    #     }
    #   }
    # }`

    headers['X-SMTPAPI'] = '{"category": "Update My Sola Website Reminder"}'

    if update_my_sola_website
      @update_my_sola_website = update_my_sola_website
      if @update_my_sola_website && @update_my_sola_website.stylist && @update_my_sola_website.stylist.email_address
        mail(to: @update_my_sola_website.location.admin.email_address, from: "Sola Salon Studios <inquiry@solasalonstudios.com>", subject: 'Update My Sola Website Reminder for ' + @update_my_sola_website.stylist.name)
      end
    end
  end

  def resend_welcome_email_ca(stylist)
    # headers['X-SMTPAPI'] = `{
    #   "category": "Welcome Email",
    #   "filters" : {
    #     "clicktrack" : {
    #       "settings" : {
    #         "enable" : 1
    #       }
    #     },
    #     "opentrack" : {
    #       "settings" : {
    #         "enable" : 1
    #       }
    #     }
    #   }
    # }`

    headers['X-SMTPAPI'] = '{"category": "Resend Welcome Email"}'

    mail(to: stylist.email_address, from: "Jennie at Sola <jennie@solasalonstudios.com>", subject: 'Welcome to Sola')
  end

  def resend_welcome_email_us(stylist)
    # headers['X-SMTPAPI'] = `{
    #   "category": "Welcome Email",
    #   "filters" : {
    #     "clicktrack" : {
    #       "settings" : {
    #         "enable" : 1
    #       }
    #     },
    #     "opentrack" : {
    #       "settings" : {
    #         "enable" : 1
    #       }
    #     }
    #   }
    # }`

    headers['X-SMTPAPI'] = '{"category": "Resend Welcome Email"}'

    mail(to: stylist.email_address, from: "Jennie at Sola <jennie@solasalonstudios.com>", subject: 'Welcome to Sola')
  end

  def welcome_email_ca(stylist)
    # headers['X-SMTPAPI'] = `{
    #   "category": "Welcome Email",
    #   "filters" : {
    #     "clicktrack" : {
    #       "settings" : {
    #         "enable" : 1
    #       }
    #     },
    #     "opentrack" : {
    #       "settings" : {
    #         "enable" : 1
    #       }
    #     }
    #   }
    # }`

    headers['X-SMTPAPI'] = '{"category": "Welcome Email"}'

    mail(to: stylist.email_address, from: "Jennie at Sola <jennie@solasalonstudios.com>", subject: 'Welcome to Sola')
  end

  def welcome_email_us(stylist)
    # headers['X-SMTPAPI'] = `{
    #   "category": "Welcome Email",
    #   "filters" : {
    #     "clicktrack" : {
    #       "settings" : {
    #         "enable" : 1
    #       }
    #     },
    #     "opentrack" : {
    #       "settings" : {
    #         "enable" : 1
    #       }
    #     }
    #   }
    # }`

    headers['X-SMTPAPI'] = '{"category": "Welcome Email"}'

    mail(to: stylist.email_address, from: "Jennie at Sola <jennie@solasalonstudios.com>", subject: 'Welcome to Sola')
  end

end