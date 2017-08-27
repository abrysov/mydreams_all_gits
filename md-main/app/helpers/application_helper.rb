module ApplicationHelper
  include ActionView::Helpers::DateHelper

  def social_abbrev(provider)
    case provider
    when :facebook
      'fb'
    when :odnoklassniki
      'ok'
    else
      provider[0..1]
    end
  end

  def get_dreamer
    if @dreamer.present?
      @dreamer
    elsif params[:dreamer_id].present?
      current_dreamer_id?(params[:dreamer_id]) ? current_dreamer : Dreamer.find(params[:dreamer_id])
    else
      nil
    end
  end

  def home_page?
    ['/', '/ru', '/en'].include? request.path
  end

  def body_class
    return unless home_page?

    'homepage'
  end

  def check_notification(notifications)
    "active" if notifications.compact.reduce(:+) > 0
  end

  def page_bg_style(dreamer)
    return if home_page?

    if dreamer && dreamer.is_vip? && dreamer.page_bg.present?
      "background: url(#{dreamer.page_bg.url(:large)}) no-repeat center; background-size: cover; background-attachment: fixed;"
    end
  end

  def dreambook_bg_url(dreamer)
    if dreamer && dreamer.dreambook_bg.present?
      dreamer.dreambook_bg.url(:cropped)
    else
      image_url('flybook_default_bg.jpg')
    end
  end

  def navigation_link(text, path, auth = false, special_class = false)
    if auth
      link_to text, path, { class: "navigation__item #{'active' if current_page?(path)} #{special_class if special_class}"}
    else
      link_to text, modal_authorization_path, { remote: true, data: {'modal-type' => 'authorization'}, class: "navigation__item jmod-btn #{special_class if special_class}"}
    end
  end

  def flybook_menu_link(path, html_options = {}, &block)
    html_options = {data: {push: true, target: '#js-ajax-content'}, class: 'item js-flybook-link'}.deep_merge(html_options)
    if current_page?(path)
      html_options[:class].present? ? html_options[:class] << ' active' : 'active'
    end

    link_to(path, html_options, &block)
  end

  def like_link(entity)
    if current_dreamer
      like_action = current_dreamer.liked?(entity) ? :unlike : :like
      link_to I18n.t("actions.#{like_action}"), [like_action, entity_type: entity.class.name.underscore, entity_id: entity.id], class: 'btn btn-default'
    end
  end

  def pretty_date(date)
    return date_in_words(date) if fresh_day?(date)
    pretty_month = I18n.t('date.many_month_names')[date.strftime('%m').to_i]
    date_format = "%d #{pretty_month}"
    date_format += ' %Y' unless fresh_year?(date)
    date.strftime(date_format).mb_chars.downcase.to_s
  rescue
    nil
  end

  def date_in_words(date)
    date = case date.to_date
           when Date.today
             I18n.t('date.today')
           when Date.yesterday
             I18n.t('date.yesterday')
           end
    date.mb_chars.downcase.to_s
  end

  def pretty_date_with_time(date)
    if fresh_time?(date)
      time_ago_in_words(date) + ' ' + I18n.t('date.ago')
    else
      datejoin = " #{I18n.t('date.datajoin')} "
      [pretty_date(date), pretty_time(date)].join(datejoin)
    end
  end

  def pretty_time(date)
    date.strftime("%H:%M")
  end

  def fresh_time?(time)
    time + 3.hours > Time.now
  end

  def fresh_day?(date)
    date + 1.day > Date.today
  end

  def fresh_year?(date)
    date.year == Date.today.year
  end

  def custom_pluralize(n, type)
    Russian.p(n, *I18n.t("pluralize.#{type}"))
  end

  def full_current_url
    url_for only_path: false
  end

  def avatar_or_default(object, version = :large)
    if object.avatar.present?
      object.avatar.url(version)
    else
      default_avatar(version, object.gender)
    end
  rescue
    default_avatar(version, true)
  end

  def whom_is(type, dreamer, friends = false)
    if friends
      if current_dreamer_id?(params[:dreamer_id])
        I18n.t("misc.my_friends_#{type}")
      elsif dreamer
        I18n.t("misc.dreamer_friends_#{type}", dreamer: dreamer.full_name)
      end
    elsif current_dreamer_id?(params[:dreamer_id])
      [I18n.t('misc.my_many'), custom_pluralize(2, type)].join(' ')
    elsif dreamer
      [custom_pluralize(2, type).mb_chars.capitalize.to_s, I18n.t('misc.of_dreamer'), dreamer.full_name].join(' ')
    end
  end

  def strig_tags(html)
    Rails::Html::FullSanitizer.new.sanitize(html)
  end

  def fix_collection(collection, count)
    elements_count = collection.count
    if elements_count % count != 0 || elements_count == 0
      @full_obj = collection += [nil]*(count - elements_count % count)
    else
      @full_obj = collection
    end
  end

  def capitalize_words(words)
    return unless words
    words.split.map { |word| word.mb_chars.capitalize }.join(' ')
  end

  def container
    DreamContainer.instance
  end

  def dreamer_has_unviewed_news?
    dreamer_signed_in? && current_dreamer.unviewed_news.any?
  end

  def cutted_post_body(text)
    text.to_s.split("\r\n")[0..2].join("\r\n")[0..200] + '...'
  end

  def post_details_link(post)
    @last_post_ids ||= Dreamer.project_dreamer.posts.
                       order(created_at: :desc).select(:id).limit(5).map(&:id)
    if @last_post_ids.include? post.id
      root_url(anchor: post.id)
    else
      account_dreamer_post_path(Dreamer.project_dreamer.id, post.id, anchor: 'post')
    end
  end

  private

  def default_avatar(version, gender)
    path = "defaults/avatars/#{gender}_#{version}.png"
    ActionController::Base.helpers.asset_url(path)
  end

  def link_to_current(title, url, params = {})
    params = params.merge(class: "#{params[:class]} #{ 'active' if current_page?(url) }", alt: title)

    if block_given?
      link_to url, params do
        yield
      end
    else
      link_to title, url, params
    end
  end

  def hidden_email(email)
    name, domain = email.split('@')
    name[0] + '***@' + domain
  end
end
