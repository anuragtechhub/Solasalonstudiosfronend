module Pro
  class Api::V1::UsersController < ApiController

    # used by Gloss Genius
    def find
      stylist = Stylist.where('id = ?', params[:org_user_id]).order(:created_at => :asc).first if params[:org_user_id]
      stylist ||= get_user(params[:email_address], user_only: true)

      if stylist
        render :json => {:org_user_id => stylist.id, :stylist => true, :location_id => (stylist.location ? stylist.location.id : nil), :location_name => (stylist.location ? stylist.location.name : nil), :created_at => stylist.created_at}
      else
        render :nothing => true, :status => 404
      end
    end

    # used by Gloss Genius
    def page_url
      stylist = Stylist.find_by(id: params[:id])

      if stylist
        stylist.booking_url = params[:page_url] if params.key?(:page_url)
        if stylist.booking_url.blank? && params.key?(:sg_booking_url) && stylist.solagenius_account_created_at.blank?
          p "set solagenius_account_created_at to now! v1 #{DateTime.now}"
          stylist.solagenius_account_created_at = DateTime.now
        end
        if params.key?(:sg_booking_url) && !params[:sg_booking_url].blank?
          stylist.booking_url = params[:sg_booking_url]
        end
        #stylist.has_sola_genius_account = params[:page_url] && params[:page_url].present?
        stylist.save(:validate => false)

        render :json => {:org_user_id => stylist.id}
      else
        render :nothing => true, :status => 404
      end
    end

    # used by Gloss Genius
    def active_check
      ids = params[:ids][1...-1].split(",").map(&:to_i).uniq if params[:ids]
      active_sylists = Stylist.where('id IN (?) AND LOWER(status) != ?', ids, 'closed').pluck(:id).to_a
      churned_ids = ids.reject{|id| active_sylists.include? id}

      if ids && churned_ids
        render :json => {:churned_ids => churned_ids}
      else
        render :nothing => true, :status => 404
      end
    end

    def platform_version
      userable = get_user(params[:email])

      if userable && userable.respond_to?(:sola_pro_version) && userable.respond_to?(:sola_pro_platform)
        userable.sola_pro_version = params[:version]
        userable.sola_pro_platform = params[:platform]
        userable.save(:validate => false)
      end

      render :json => {:success => true}
    end

  end
end