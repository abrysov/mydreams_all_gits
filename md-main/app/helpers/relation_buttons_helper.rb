module RelationButtonsHelper
  def subscription_button(sender, receiver)
    if !sender.friends_with?(receiver) && !sender.follows?(receiver)
      subscribe_button(receiver)
    elsif sender.friends_with?(receiver) || sender.wants_to_friend?(receiver)
      unsubscribe_disabled_button
    else
      unsubscribe_button(receiver)
    end
  end

  def friend_button(sender, receiver)
    friended_each_other = !receiver.wants_to_friend?(sender) &&
      !receiver.friends_with?(sender) &&
      !sender.wants_to_friend?(receiver)

    if friended_each_other
      add_to_friends_button(receiver)
    elsif sender.friends_with? receiver
      unfriend_button(receiver)
    elsif sender.wants_to_friend? receiver
      deny_request_button(receiver)
    else
      accept_request_button(receiver) +
      decline_request_button(receiver)
    end
  end

  def button_type_for(dreamer)
    dreamer.is_vip? ? 'button-w-bordered' : 'button-gray'
  end

  def subscribe_button(receiver)
    link_to [:subscribe, receiver], class: "button #{button_type_for receiver}" do
      content_tag :span, t('flybook.subscribe')
    end
  end

  def unsubscribe_button(receiver)
    link_to [:unsubscribe, receiver], class: "button #{button_type_for receiver}" do
      content_tag(:span, t('actions.unsubscribe')) +
      content_tag(:span, '', class: 'tick')
    end
  end

  def unsubscribe_disabled_button
    content_tag :div, class: 'button button-w-bordered disabled' do
      content_tag :span, t('actions.unsubscribe')
    end
  end

  def add_to_friends_button(receiver)
    link_to request_friendship_dreamer_path(receiver), class: "button #{button_type_for receiver}" do
      content_tag :span, t('flybook.add_to_friends')
    end
  end

  def unfriend_button(receiver)
    link_to receiver, method: :delete, class: "button #{button_type_for receiver}" do
      content_tag(:span, t('actions.unfriend')) +
      content_tag(:span, '', class: 'tick')
    end
  end

  def deny_request_button(receiver)
    link_to [:deny_request, receiver], class: "button #{button_type_for receiver}" do
      content_tag :span, t('actions.deny_request')
    end
  end

  def accept_request_button(receiver)
    link_to [:accept_request, receiver], class: "button #{button_type_for receiver}" do
      content_tag :span, t('actions.accept_request')
    end
  end

  def decline_request_button(receiver)
    link_to [:deny_request, receiver], class: "button #{button_type_for receiver}" do
      content_tag :span, t('actions.decline_request')
    end
  end
end
