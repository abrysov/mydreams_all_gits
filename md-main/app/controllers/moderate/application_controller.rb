class Moderate::ApplicationController < ActionController::Base
  layout 'moderate'
  before_filter :authenticate_dreamer!
  before_filter :authenticate_moderator
  before_filter :set_menu

  def delete
    request_entity_object.mark_deleted
    log_and_approve_object
  end

  def recovery
    request_entity_object.mark_undeleted
    log_and_approve_object
  end

  def approve
    log_and_approve_object
  end

  def remove_approve
    request_entity_object.remove_approve
    log_moderator_action!
  end

  def approve_ios
    log_and_approve_object(ios_safe: true)
  end

  def remove_ios_safe
    log_and_approve_object(ios_safe: false)
  end

  def approve_all
    mass_approve_objects_and_log
  end

  def approve_ios_all
    mass_approve_objects_and_log(ios_safe: true)
  end

  def remove_ios_safe_all
    mass_approve_objects_and_log(ios_safe: false)
  end

  protected

  def log_and_approve_object(ios_safe: nil)
    obj = request_entity_object
    obj.approve
    unless ios_safe.nil?
      ios_safe ? obj.approve_ios : obj.remove_ios_safe
    end
    log_moderator_action!
  end

  def mass_approve_objects_and_log(ios_safe: nil)
    ModeratorLog.transaction do
      request_entity_objects.each do |obj|
        obj.approve
        unless ios_safe.nil?
          ios_safe ? obj.approve_ios : obj.remove_ios_safe
        end
        log_moderator_action!(logable: obj)
      end
    end
  end

  def authenticate_moderator
    unless %w(moderator admin).include? current_dreamer.role
      redirect_to new_dreamer_session_path
    end
  end

  def set_menu
    @menu ||= I18n.t('moderate.menu').map do |model_name, title|
      { name: title, path: path(model_name) }
    end
  end

  def path(object)
    send("moderate_#{object}_path".to_sym)
  end

  def default_url_options(options = {})
    options.merge! locale: I18n.locale
  end

  def log_moderator_action!(action: action_name, logable: request_entity_object)
    LogAction::Moderation.call(action, logable, current_dreamer)
  end

  def request_entity_object
    @req_ent_obj ||= params[:entity_type].camelize.constantize.
                     unscoped.
                     find(params[:entity_id])
  end

  def request_entity_objects
    @req_ent_objs ||= params[:entity_type].camelize.constantize.
                      unscoped.
                      find(params[:entity_ids])
  end

  def find_entity_object(type, id)
    type.camelize.constantize.find(id)
  end

  def search_hash(dreamer_assoc: true)
    hash = { search_str(dreamer_assoc: dreamer_assoc) => params[:search] }
    if dreamer_assoc
      hash.merge(dreamer_project_dreamer_false: '1')
    else
      hash.merge(project_dreamer_false: '1')
    end
  end

  def search_str(dreamer_assoc: true)
    search_attrs = %w(status email first_name last_name)
    search_attrs.map! { |attr| 'dreamer_' + attr } if dreamer_assoc
    search_attrs.join('_or_') + '_cont_any'
  end
end
