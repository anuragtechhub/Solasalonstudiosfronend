module Ability
  class Admin
    include CanCan::Ability

    attr_reader :admin

    def initialize(admin)
      return unless admin

      @admin = admin

      if admin.franchisee != true
        can :access, :rails_admin   # grant access to rails_admin
        can :dashboard
        #can :history
        can :manage, :all
        cannot :new, ::UpdateMySolaWebsite
        cannot :export, ::UpdateMySolaWebsite
      else
        can :access, :rails_admin   # grant access to rails_admin
        can :dashboard

        # Sola
        can [:read, :update], ::Admin, id: admin.id
        can [:new, :read, :update], ::Testimonial
        can [:new], ::Article
        can [:new, :read, :update, :export, :destroy], ::Article, location: { admin_id: admin.id }
        can [:new], ::Lease
        can [:new, :read, :update, :export, :destroy], ::Lease, location: { admin_id: admin.id }
        can [:new], ::Stylist
        can [:read, :update, :export, :custom_export], ::Stylist, location: { admin_id: admin.id }
        can [:read, :update, :export, :destroy], ::Location, admin_id: admin.id
        can :read, ::Studio, location: { admin_id: admin.id }
        can :manage, ::RequestTourInquiry, location: { admin_id: admin.id }
        can [:index, :update, :destroy], ::UpdateMySolaWebsite, stylist: {location: { admin_id: admin.id }}

        # Pro
        can :read, ::SolaClassCategory
        #can :read, Brand
        can :new, ::Brand
        can :manage, ::Brand, id: Brand.joins(:brand_countries, :countries).where('countries.code = ?', admin.sola_pro_country_admin).uniq.map{|b| b.id}
        can [:new, :read], ::Deal
        can :manage, ::Deal, id: Deal.joins(:deal_countries, :countries).where('countries.code = ?', admin.sola_pro_country_admin).uniq.map{|d| d.id}
        can :new, ::HomeButton
        can :manage, ::HomeButton, id: HomeButton.joins(:home_button_countries, :countries).where('countries.code = ?', admin.sola_pro_country_admin).uniq.map{|b| b.id}
        can :new, ::HomeHeroImage
        can :manage, ::HomeHeroImage, id: HomeHeroImage.joins(:home_hero_image_countries, :countries).where('countries.code = ?', admin.sola_pro_country_admin).uniq.map{|b| b.id}
        can :new, ::SideMenuItem
        can :manage, ::SideMenuItem, id: SideMenuItem.joins(:side_menu_item_countries, :countries).where('countries.code = ?', admin.sola_pro_country_admin).uniq.map{|b| b.id}
        can [:new, :read], ::SolaClass
        can :manage, ::SolaClass, id: SolaClass.where(admin_id: admin.id).pluck(:id)
        can :manage, ::SolaClassRegion#, id: SolaClassRegion.joins(:sola_class_region_countries, :countries).where('countries.code = ?', admin.sola_pro_country_admin).uniq.map{|c| c.id}
        can :new, ::Tool
        can :manage, ::Tool, id: Tool.joins(:tool_countries, :countries).where('countries.code = ?', admin.sola_pro_country_admin).uniq.map{|t| t.id}
        can [:new, :read], ::Video
        can :manage, ::Video, id: Video.joins(:video_countries, :countries).where('countries.code = ?', admin.sola_pro_country_admin).uniq.map{|v| v.id}
        can [:read], ::Category
        can [:read], ::Blog
        can [:read], ::Tool
        can [:read, :manage], ::SavedItem
        can [:read, :manage], ::SavedSearch
        can [:create, :show], ::Event
        can [:read], ::EducationHeroImage
      end

      cannot :destroy, ::Stylist
    end
  end
end
