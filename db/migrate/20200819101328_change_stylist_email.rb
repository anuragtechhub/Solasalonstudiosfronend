class ChangeStylistEmail < ActiveRecord::Migration
  def change
    Stylist.pluck(:email_address).each do |email|
      email.downcase!
      next if Stylist.where('lower(email_address) = ?', email).count <= 1

      puts "Processing: #{email}\n"
      active = Stylist.where('lower(email_address) = ?', email).where(status: 'open').order(:created_at).first ||
        Stylist.where('lower(email_address) = ?', email).order(:created_at).first
      Stylist.where('lower(email_address) = ?', email).where.not(id: active.id).destroy_all
    end

    Admin.pluck(:email_address).each do |email|
      next if email.nil?
      email.downcase!
      next if Admin.where('lower(email_address) = ?', email).count <= 1

      puts "Processing: #{email}\n"
      active = Admin.where('lower(email_address) = ?', email).order(:created_at).first
      Admin.where('lower(email_address) = ?', email).where.not(id: active.id).destroy_all
    end

    Admin.where('lower(email_address) = ?', '').destroy_all
    Admin.where(email_address: nil).destroy_all

    enable_extension 'citext'

    change_column :stylists, :email_address, :citext, null: false
    add_index :stylists, :email_address, unique: true

    change_column :admins, :email_address, :citext, null: false
    add_index :admins, :email_address, unique: true
  end
end
