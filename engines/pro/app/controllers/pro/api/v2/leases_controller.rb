module Pro
  class Api::V2::LeasesController < ApiController

    require 'rest-client'
    require 'json'

    def save_lease_agreement_file_url
      userable = get_user(params[:email])
      if userable && userable.leases && userable.leases.size > 0
        lease = userable.leases.order(:created_at => :desc).first
        lease.agreement_file_url = params[:agreement_file_url]
        lease.save

        lease.stylist.sync_from_rent_manager if lease.stylist
      end

      render :json => {success: true}
    end

    def studio_agreement

      # p "start studio agreement"
      # sleep 3
      # p "awake after sleeping"
      #render :json => {token: 'denver'}
      # render :json => {agreement_file_url: 'http://decutywx15n1m.cloudfront.net/deals/files/000/000/102/original/SolaDeal_-_August_2017.pdf?1505487505'}
      #render :json => {leases: nil}

      userable = get_user(params[:email])

      if userable.respond_to? :leases
        p "userable knows about leases (must be a Stylist user) #{userable.inspect}"
        if userable.leases && userable.leases.length > 0
          lease = userable.leases.order(:created_at => :desc).first
          if lease && lease.agreement_file_url.present?
            p "lease has agreement_file_url! #{lease.agreement_file_url}"
            render :json => {agreement_file_url: lease.agreement_file_url}
          else
            p "lease has no agreement_file_url, so let's get a token. #{lease.inspect}"

            p "userable.location=#{userable.location.inspect}"

            payload = {
              "FirstName" => userable.first_name,
              "LastName" => userable.last_name,
              "Email" => userable.email_address,
              "CellPhoneNumber" => userable.phone_number,
              "CosmetologyLicenseNumber" => userable.cosmetology_license_number,
              "CosmetologyLicenseIssueDate" => userable.cosmetology_license_date,

              "PrimaryAddress" => {
                "Address" => userable.street_address,
                #{}"Street" => userable.street_address,
                #{}"Street": "sample string 4",
                "City" => userable.city,
                "State" => userable.state_province,
                "PostalCode" => userable.postal_code,
              },

              "TenantID" => userable.rent_manager_id,
              "LocationID" => userable.location.rent_manager_location_id,
              "PropertyID" => userable.location.rent_manager_property_id,
              "UnitID" => lease.studio.rent_manager_id,

              "LeaseStartDate" => lease.start_date,
              "LeaseEndDate" => lease.end_date,
              "MoveInDate" => lease.move_in_date,

              "SpecialTerms" => lease.special_terms.present? ? lease.special_terms : '',

              "SecurityDepositAmount" => lease.damage_deposit_amount.present? ? lease.damage_deposit_amount.to_f / 100.0 : nil,
              # "RecurringCharges" => [
              #   {
              #     "FromDate" => lease.fee_start_date,
              #     "ToDate" => (lease.fee_start_date + 1.year),
              #     "Amount" => lease.weekly_fee_year_1
              #   },
              #   {
              #     "FromDate" => (lease.fee_start_date + 1 year),
              #     "ToDate" => (lease.fee_start_date + 2.years),
              #     "Amount" => lease.weekly_fee_year_2
              #   }
              # ]
            }

            # NSF fee
            if lease.nsf_fee_amount.present?
              payload["NSFFee"] = lease.nsf_fee_amount.to_f / 100.0
            end

            # Date of Birth
            if userable.date_of_birth.present?
              payload["BirthDate"] = userable.date_of_birth
            end

            # insurance
            if lease.insurance_amount.present? && lease.insurance
              payload["Insurance"] = lease.insurance
              payload["InsuranceAmount"] = lease.insurance_amount.present? ? lease.insurance_amount.to_f / 100.0 : nil
              payload["InsurancePaymentStartDate"] = lease.insurance_start_date

              if lease.insurance_frequency == 'weekly'
                payload["InsuranceFrequency"] = 1
              elsif lease.insurance_frequency == 'monthly'
                payload["InsuranceFrequency"] = 2
              elsif lease.insurance_frequency == 'annually'
                payload["InsuranceFrequency"] = 3
              else
                payload["InsuranceFrequency"] = 0
              end
            end

            # move-in bonus
            if lease.move_in_bonus #&& lease.move_in_bonus_payee.present?
              payload["MoveInBonus"] = true#lease.move_in_bonus_amount / 100
              payload["MoveInBonusPayee"] = lease.move_in_bonus_payee.present? ? lease.move_in_bonus_payee : ''
            end

            # recurring charges

            # rent
            if lease.rent_recurring_charges && lease.rent_recurring_charges.length > 0
              payload["RentRecurringCharges"] = []
              lease.rent_recurring_charges.each do |recurring_charge|
                payload["RentRecurringCharges"] << {
                  "Amount" => recurring_charge.amount.present? ? recurring_charge.amount.to_f / 100.0 : nil,
                  "FromDate" => recurring_charge.start_date,
                  "ToDate" => recurring_charge.end_date,
                }
              end
            end

            # tax
            if lease.tax_recurring_charges && lease.tax_recurring_charges.length > 0
              payload["TaxRecurringCharges"] = []
              lease.tax_recurring_charges.each do |recurring_charge|
                payload["TaxRecurringCharges"] << {
                  "Amount" => recurring_charge.amount.present? ? recurring_charge.amount.to_f / 100.0 : nil,
                  "FromDate" => recurring_charge.start_date,
                  "ToDate" => recurring_charge.end_date,
                }
              end
            end

            # parking
            if lease.parking_recurring_charges && lease.parking_recurring_charges.length > 0
              payload["ParkingRecurringCharges"] = []
              lease.parking_recurring_charges.each do |recurring_charge|
                payload["ParkingRecurringCharges"] << {
                  "Amount" => recurring_charge.amount.present? ? recurring_charge.amount.to_f / 100.0 : nil,
                  "FromDate" => recurring_charge.start_date,
                  "ToDate" => recurring_charge.end_date,
                }
              end
            end

            # cable
            if lease.cable_recurring_charges && lease.cable_recurring_charges.length > 0
              payload["CableRecurringCharges"] = []
              lease.cable_recurring_charges.each do |recurring_charge|
                payload["CableRecurringCharges"] << {
                  "Amount" => recurring_charge.amount.present? ? recurring_charge.amount.to_f / 100.0 : nil,
                  "FromDate" => recurring_charge.start_date,
                  "ToDate" => recurring_charge.end_date,
                }
              end
            end

            # if lease.recurring_charge_1.present?
            #   payload["RecurringCharges"] << {
            #     "Amount" => lease.recurring_charge_1.amount.present? ? lease.recurring_charge_1.amount.to_f / 100.0 : nil,
            #     "FromDate" => lease.recurring_charge_1.start_date,
            #     "ToDate" => lease.recurring_charge_1.end_date,
            #   }
            # end

            # if lease.recurring_charge_2.present?
            #   payload["RecurringCharges"] << {
            #     "Amount" => lease.recurring_charge_2.amount.present? ? lease.recurring_charge_2.amount.to_f / 100.0 : nil,
            #     "FromDate" => lease.recurring_charge_2.start_date,
            #     "ToDate" => lease.recurring_charge_2.end_date,
            #   }
            # end

            # if lease.recurring_charge_3.present?
            #   payload["RecurringCharges"] << {
            #     "Amount" => lease.recurring_charge_3.amount.present? ? lease.recurring_charge_3.amount.to_f / 100.0 : nil,
            #     "FromDate" => lease.recurring_charge_3.start_date,
            #     "ToDate" => lease.recurring_charge_3.end_date,
            #   }
            # end

            # if lease.recurring_charge_4.present?
            #   payload["RecurringCharges"] << {
            #     "Amount" => lease.recurring_charge_4.amount.present? ? lease.recurring_charge_4.amount.to_f / 100.0 : nil,
            #     "FromDate" => lease.recurring_charge_4.start_date,
            #     "ToDate" => lease.recurring_charge_4.end_date,
            #   }
            # end
            # year_1 = {"Amount" => lease.weekly_fee_year_1 / 100}
            # year_1["FromDate"] = lease.fee_start_date
            # year_1["ToDate"] = (lease.fee_start_date - 1.day + 1.year)

            # year_2 = {"Amount" => lease.weekly_fee_year_2 / 100}
            # year_2["FromDate"] = (lease.fee_start_date + 1.year)
            # year_2["ToDate"] = (lease.fee_start_date - 1.day + 2.years)

            # payload["RecurringCharges"] = [year_1, year_2]

            # permitted uses
            if lease.hair_styling_permitted || lease.manicure_pedicure_permitted || lease.waxing_permitted || lease.massage_permitted || lease.facial_permitted
              payload["PermittedUses"] = [];
              payload["PermittedUses"] << {"Name" => "Hair Styling", "Selected" => true} if lease.hair_styling_permitted
              payload["PermittedUses"] << {"Name" => "Manicure Pedicure", "Selected" => true} if lease.manicure_pedicure_permitted
              payload["PermittedUses"] << {"Name" => "Waxing", "Selected" => true} if lease.waxing_permitted
              payload["PermittedUses"] << {"Name" => "Massage", "Selected" => true} if lease.massage_permitted
              payload["PermittedUses"] << {"Name" => "Facial", "Selected" => true} if lease.facial_permitted
            end

            if lease.other_service.present?
              payload["OtherPermittedUse"] = lease.other_service
            end

            p "payload=#{payload.to_json}"
            p "userable.location=#{userable.location.inspect}"
            p "https://solasalon.apiservices.rentmanager.com/api/#{userable.location.rent_manager_location_id}/FillAgreementTokens"

            fill_agreement_tokens_response = RestClient::Request.execute({
              :headers => {"Content-Type" => "application/json"},
              :method => :post,
              #:content_type => 'application/json',
              :url => "https://solasalon.apiservices.rentmanager.com/api/#{userable.location.rent_manager_location_id}/FillAgreementTokens",
              :user => 'solapro',
              :password => '20FCEF93-AD4D-4C7D-9B78-BA2492098481',
              :payload => [payload].to_json
            })
            p "fill_agreement_tokens_response=#{fill_agreement_tokens_response}"
            fill_agreement_tokens_json = JSON.parse(fill_agreement_tokens_response)
            p "fill_agreement_tokens_json=#{fill_agreement_tokens_json}"
            token = fill_agreement_tokens_json[0]["Token"] if fill_agreement_tokens_json && fill_agreement_tokens_json.length > 0
            p "token=#{token}"
            #token = 'denver'

            render :json => {token: token}
          end
        else
          p "userable knows about leases, but doesnt have any"
          render :json => {leases: nil}
        end
      else
        p "userable does not know about leases (must be an Admin user) #{userable.inspect}"
        render :json => {leases: nil}
      end
    end

  end
end