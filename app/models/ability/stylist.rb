# frozen_string_literal: true

module Ability
  class Stylist
    include CanCan::Ability

    attr_reader :user, :options

    def initialize(user, options = {})
      return unless user

      @user = user
      @options = OpenStruct.new(options)

      cannot :manage, :all

      can [:read], ::Blog
      can [:read], ::Brand
      can [:read], ::Category
      can [:read], ::Video
      can [:read], ::Deal
      can [:read], ::SolaClass
      can [:read], ::Tool
      can [:read], ::EducationHeroImage
      can %i[create read show update], ::Device, userable_id: user.id, userable_type: 'Stylist'
      can %i[read manage], ::SavedItem, stylist_id: user.id
      can %i[read manage], ::SavedSearch, stylist_id: user.id
      can %i[create show], ::Event
    end
  end
end
