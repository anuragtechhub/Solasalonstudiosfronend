# frozen_string_literal: true

namespace :view do
  task update: :environment do
    Video.find_each do |v|
      v.update_attribute(:views, Event.where(video_id: v.id, action: 'view').last_month.count)
    end

    SolaClass.find_each do |sc|
      sc.update_attribute(:views, Event.where(sola_class_id: sc.id, action: 'view').last_month.count)
    end

    Deal.find_each do |d|
      d.update_attribute(:views, Event.where(deal_id: d.id, action: 'view').last_month.count)
    end

    Tool.find_each do |t|
      t.update_attribute(:views, Event.where(tool_id: t.id, action: 'view').last_month.count)
    end
  end
end
