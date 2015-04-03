class Ability
  include CanCan::Ability

  def initialize(admin)
    admin ||= Admin.new # guest user (not logged in)
    if admin.franchisee != true
      can :access, :rails_admin   # grant access to rails_admin
      can :dashboard
      #can :history
      can :manage, :all
    else
      can :access, :rails_admin   # grant access to rails_admin
      can :dashboard

      can :new, [Stylist] 
      can :read, [Location, Stylist]         # included in :read
      can :update, [Location, Stylist]       # included in :create
      can :export, [Location, Stylist]
      can :destroy, [Location, Stylist]
    end
  end
end
