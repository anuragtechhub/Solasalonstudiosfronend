admin = Admin.find_or_create_by(:email => 'admin@solasalonstudios.com')
admin.password = 'stylists'
admin.password_confirmation = 'stylists'
admin.save