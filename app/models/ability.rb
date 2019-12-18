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

      can :new, [Article, Lease, Stylist, Testimonial] 

      can :read, Testimonial
      can :read, Article, :location => { :admin_id => admin.id }
      can :read, Lease, :location => { :admin_id => admin.id }
      can :read, Location, :admin_id => admin.id 
      can :read, Stylist, :location => { :admin_id => admin.id }
      can :read, Studio, :location => { :admin_id => admin.id }
      can :read, Admin, :id => admin.id
      
      can :update, Article, :location => { :admin_id => admin.id }  
      can :update, Testimonial
      can :update, Lease, :location => { :admin_id => admin.id }
      can :update, Location, :admin_id => admin.id 
      can :update, Stylist, :location => { :admin_id => admin.id }
      can :update, Admin, :id => admin.id

      can :export, Article, :location => { :admin_id => admin.id }
      can :export, Lease, :location => { :admin_id => admin.id }
      can :export, Location, :admin_id => admin.id 
      can :export, Stylist, :location => { :admin_id => admin.id }

      can :destroy, Article, :location => { :admin_id => admin.id }
      can :destroy, Lease, :location => { :admin_id => admin.id }
      can :destroy, Location, :admin_id => admin.id 
      can :destroy, Stylist, :location => { :admin_id => admin.id }

      can :manage, RequestTourInquiry, :location => { :admin_id => admin.id }
      # can :export, RequestTourInquiry, :location => { :admin_id => admin.id }

      can :read, UpdateMySolaWebsite, :location => { :admin_id => admin.id }
      can :update, UpdateMySolaWebsite, :location => { :admin_id => admin.id }

      # can :update, [Location, Stylist]       # included in :create
      # can :export, [Location, Stylist]
      # can :destroy, [Location, Stylist]
    end
  end
end
