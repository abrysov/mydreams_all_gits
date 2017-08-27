class Admin::EntityControl::DashboardController < Admin::EntityControl::ApplicationController
  def statistic_for_period
    @message = "#{find_count_from_date} " + request_entity.class_name + 's created'
  end

  private

  def find_count_from_date
    date_start = parse_date(params[:date_start])
    date_end = parse_date(params[:date_end])
    request_entity.where('? < created_at AND created_at < ?', date_start, date_end).count
  end

  def parse_date(date)
    Time.zone.parse(date)
  end

  def request_entity
    case params[:entity_type]
    when /^dream$/i      then Dream
    when /^dreamer$/i    then Dreamer
    when /^post$/i       then Post
    end.unscoped
  end
end
