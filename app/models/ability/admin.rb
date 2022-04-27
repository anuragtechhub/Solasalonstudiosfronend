# frozen_string_literal: true

module Ability
  class Admin
    include CanCan::Ability

    attr_reader :admin

    def initialize(admin)
      return unless admin

      @admin = admin

      can :access, :rails_admin
      can :dashboard
      if admin.franchisee == true

        # Sola
        can %i[read update], ::Admin, id: admin.id
        can %i[new read update], ::Testimonial
        can [:new], ::Article
        can %i[new read update export destroy], ::Article, location: { admin_id: admin.id }
        can [:new], ::Lease
        can %i[new read update export destroy], ::Lease, location: { admin_id: admin.id }
        can [:new], ::Stylist
        can %i[read update export custom_export], ::Stylist, location: { admin_id: admin.id }
        can %i[read update export destroy], ::Location, admin_id: admin.id
        can :read, ::Studio, location: { admin_id: admin.id }
        can :manage, ::RequestTourInquiry, location: { admin_id: admin.id }
        can %i[index update destroy], ::UpdateMySolaWebsite, stylist: { location: { admin_id: admin.id } }

        # Pro
        can :read, ::SolaClassCategory
        # can :read, Brand
        can :new, ::Brand
        can :manage, ::Brand, id: Brand.joins(:brand_countries, :countries).where(countries: { code: admin.sola_pro_country_admin }).uniq.map(&:id)
        can %i[new read], ::Deal
        can :manage, ::Deal, id: Deal.joins(:deal_countries, :countries).where(countries: { code: admin.sola_pro_country_admin }).uniq.map(&:id)
        can :new, ::HomeButton
        can :manage, ::HomeButton, id: HomeButton.joins(:home_button_countries, :countries).where(countries: { code: admin.sola_pro_country_admin }).uniq.map(&:id)
        can :new, ::HomeHeroImage
        can :manage, ::HomeHeroImage, id: HomeHeroImage.joins(:home_hero_image_countries, :countries).where(countries: { code: admin.sola_pro_country_admin }).uniq.map(&:id)
        can :new, ::SideMenuItem
        can :manage, ::SideMenuItem, id: SideMenuItem.joins(:side_menu_item_countries, :countries).where(countries: { code: admin.sola_pro_country_admin }).uniq.map(&:id)
        can %i[new read], ::SolaClass
        can :manage, ::SolaClass, id: SolaClass.where(admin_id: admin.id).ids
        can :manage, ::SolaClassRegion # , id: SolaClassRegion.joins(:sola_class_region_countries, :countries).where('countries.code = ?', admin.sola_pro_country_admin).uniq.map{|c| c.id}
        can :new, ::Tool
        can :manage, ::Tool, id: Tool.joins(:tool_countries, :countries).where(countries: { code: admin.sola_pro_country_admin }).uniq.map(&:id)
        can %i[new read], ::Video
        can :manage, ::Video, id: Video.joins(:video_countries, :countries).where(countries: { code: admin.sola_pro_country_admin }).uniq.map(&:id)
        can [:read], ::Category
        can [:read], ::Blog
        can [:read], ::Tool
        can %i[read manage], ::SavedItem
        can %i[read manage], ::SavedSearch
        can %i[create show], ::Event
        can [:read], ::EducationHeroImage
      else
        # can :history
        can :manage, :all
        cannot :new, ::UpdateMySolaWebsite
        cannot :export, ::UpdateMySolaWebsite
      end

      cannot :destroy, ::Stylist
    end
  end
end
