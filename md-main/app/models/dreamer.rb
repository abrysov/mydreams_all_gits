class Dreamer < ActiveRecord::Base
  include Dreamerable

  enumerize :gender, in: [:male, :female], default: :male, scope: :by_gender
  enumerize :role, in: [:user, :admin, :moderator], default: :user
  AVATAR_SIZE_MB = 32
  AVATAR_SIZE = AVATAR_SIZE_MB.megabytes
  AVATAR_FORMATS = %w{png jpg jpeg}

  devise :database_authenticatable, :registerable, :token_authenticatable, :recoverable,
    :rememberable, :trackable, :omniauthable, :validatable, :confirmable,
    omniauth_providers: [:facebook, :vkontakte, :instagram, :twitter]

  multisearchable against: [:email, :first_name, :last_name, :phone, :created_at, :updated_at, :id]
  pg_search_scope :fulltext_search,
    against: [:email, :first_name, :last_name],
    using: { :tsearch => { prefix: true } }

  mount_uploader :avatar, AvatarUploader
  mount_base64_uploader :avatar, AvatarUploader
  mount_uploader :page_bg, PageBackgroundUploader
  mount_uploader :dreambook_bg, DreambookBackgroundUploader
  mount_base64_uploader :dreambook_bg, DreambookBackgroundUploader

  belongs_to :dream_country
  belongs_to :dream_city

  has_one :photobar_photo, primary_key: :photobar_added_photo_id, foreign_key: :id, class_name: Photo
  has_one :current_avatar, class_name: Avatar
  has_one :account, dependent: :destroy

  has_many :avatars
  has_many :activities, as: :owner, dependent: :destroy, class_name: Activity, foreign_key: :owner_id
  has_many :comments
  has_many :dreams, -> { not_deleted }, dependent: :destroy
  has_many :dream_comments, through: :dreams, class_name: 'Comment', source: :comments
  has_many :gifts, foreign_key: :giver_id
  has_many :likes
  has_many :logs, class_name: ModeratorLog
  has_many :photos, dependent: :destroy
  has_many :post_comments, through: :posts, class_name: 'Comment', source: :comments
  has_many :posts, dependent: :destroy
  has_many :suggested_dreams, foreign_key: :receiver_id
  has_many :suggested_posts, foreign_key: :receiver_id
  has_many :emails, dependent: :destroy
  has_many :sended_mails

  has_many :providers, dependent: :destroy

  has_many :friend_requests, foreign_key: :receiver_id
  has_many :outgoing_friend_requests, foreign_key: :sender_id, class_name: FriendRequest
  has_many :friend_applicants, through: :friend_requests, source: :sender

  has_many :active_followings, -> { order(created_at: :desc) }, class_name: Following, foreign_key: :follower_id, dependent: :destroy
  has_many :passive_followings, -> { order(created_at: :desc) }, class_name: Following, foreign_key: :followee_id, dependent: :destroy
  has_many :followers, through: :passive_followings, source: :follower
  has_many :followees, through: :active_followings, source: :followee
  has_many :subscriptions, foreign_key: :dreamer_id, dependent: :destroy
  has_many :subscribers, through: :subscriptions, class_name: Dreamer, foreign_key: :dreamer_id
  has_many :subscriptions_to_dreamer, foreign_key: :subscriber_id, class_name: Subscription
  has_many :speakers, through: :subscriptions_to_dreamer, class_name: Dreamer, source: :dreamer

  has_many :purchases
  has_many :vip_statuses

  has_many :feedbacks
  has_many :notifications

  has_many :post_photos

  delegate :name, to: :dream_city, prefix: :city, allow_nil: true
  delegate :name, to: :dream_country, prefix: :country, allow_nil: true

  # Выпилил валидацию страны и города пока(:dreamer_city_id, :dreamer_country_id, :birthday)
  validates :first_name, presence: true
  validates :email, uniqueness: true, allow_blank: true
  validates :phone, phone: true, allow_blank: true
  # validates :terms_of_service, acceptance: true

  attr_accessor :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h, :dreambook_bg_crop_x,
    :dreambook_bg_crop_y, :dreambook_bg_crop_w, :dreambook_bg_crop_h, :login, :gift_comment,
    :old_password, :skip_password, :terms_of_service

  before_validation :generate_new_password, on: :create
  before_save :ensure_authentication_token
  after_update :crop_avatar, if: :cropping_avatar?
  after_update :crop_dreambook_bg, if: :cropping_dreambook_bg?

  serialize :crop_meta

  # TODO: replace with `scope :online, -> { where(online: true) }`
  # when messenger will be released. See MYD-385
  scope :online, -> { where(self.arel_table[:last_reload_at].gteq(5.minutes.ago)) }
  scope :without, -> (dreamer) { where.not(id: dreamer.id) }
  scope :by_visits_count, -> { order(visits_count: :desc) }
  scope :by_vip, -> (value) { where(is_vip: value) }
  scope :celebrities, -> { where(celebrity: true) }
  scope :not_deleted, -> { where(deleted_at: nil) }
  scope :not_blocked, -> { where(blocked_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }
  scope :for_photobar, -> { preload(:dream_country, :dream_city).where.not(photobar_added_at: nil).order(photobar_added_at: :desc) }
  scope :with_authentication_token, -> { where.not(authentication_token: nil) }

  scope :filter_by_gender, ->(gender) {
    by_gender(gender) unless gender.in? [nil, '', 'any']
  }

  scope :filter_by_country_id, ->(country_id) {
    where(dream_country_id: country_id) unless country_id.in? [nil, '', 'any']
  }

  scope :filter_by_city_id, ->(city_id) {
    where(dream_city_id: city_id) unless city_id.in? [nil, '', 'any']
  }

  scope :by_birthday, -> (birthday) { where(birthday: Date.parse(birthday)) }

  scope :by_age, ->(from = 0, to = 100) {
    # TODO: unless?
    where(birthday: to.years.ago.to_date..from.years.ago.to_date)
  }

  # TODO: for old frontend, remove this @#_^&
  scope :filter_by_age, ->(age) {
    range = case age.to_i
            when 1 then [18, 25]
            when 2 then [25, 32]
            when 3 then [32, 39]
            when 4 then [39, 46]
            when 5 then [46, 53]
            else
              [0, 100]
            end
    by_age(*range) unless age.in? [nil, '', 'any']
  }

  def account
    Account.where(dreamer: self).first_or_create(dreamer: self)
  end

  def vip_end
    vip_statuses.maximum(:completed_at)
  end

  def friends
    table = self.class.arel_table
    friendships = Friendship.arel_table

    self.class.joins(
      table.join(friendships)
        .on("dreamers.id = ANY(friendships.member_ids) AND friendships.member_ids @> ARRAY[#{id}]")
        .join_sources
    ).where.not(id: id)
  end

  def latest_friends
    friends.order('friendships.created_at DESC')
  end

  def follows?(dreamer)
    followees.exists? dreamer.id
  end

  def has_follower?(dreamer)
    followers.exists? dreamer.id
  end

  def friends_with?(dreamer)
    friends.include? dreamer
  end

  def wants_to_friend?(dreamer)
    outgoing_friend_requests.exists? receiver: dreamer
  end

  def subscribed_to?(dreamer)
    subscribers.exists? dreamer.id
  end

  def subscribe_to(dreamer)
    dreamer.add_to_subscribers(self)
  end

  def add_to_subscribers(dreamer)
    followers << dreamer unless has_follower?(dreamer)
    subscribers << dreamer unless subscribed_to?(dreamer)
  end

  def unsubscribe(dreamer)
    dreamer.remove_from_subscribers self
  end

  def remove_from_subscribers(dreamer)
    followers.destroy dreamer
    subscribers.destroy dreamer
  end

  def new_followers
    followers.merge Following.unviewed
  end

  def viewed_followers
    followers.merge Following.viewed
  end

  # TODO: remove when new frontend will be ready
  def reset_followers_count!
    self.class.update_counters id, followers_count: -followers_count
    self[:followers_count] -= followers_count
  end

  def online?
    self.last_reload_at.to_i >= 5.minutes.ago.to_i
  end

  def age
    return 0 unless birthday

    age = Date.today.year - birthday.year
    age -= 1 if Date.today < birthday + age.years
    age < 0 ? 0 : age
  end

  def conversations
    Conversation.where('member_ids @> ARRAY[?]', id)
  end

  # NOTE: devise requires email. fucking devise!
  def email_required?
    false
  end

  def is_project_dreamer?
    self.project_dreamer == true
  end

  def visit!(dreamer)
    unless dreamer.nil? || dreamer == self
      Visit.find_or_create_by(visitor: dreamer, visited: self)
    end
  end

  def restore!
    update_column(:deleted_at, nil)
  end

  class << self
    def project_dreamer
      find_by(project_dreamer: true)
    end

    def project_moderator
      order(:id).find_by(role: :moderator)
    end

    def for_select
      all.collect { |i| [i.full_name.presence || i.email, i.id] }
    end

    def find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      login = conditions.delete(:login)
      email = conditions.delete(:email)
      confirmation_token = conditions.delete(:confirmation_token)
      reset_password_token = conditions.delete(:reset_password_token)
      unconfirmed_email = conditions.delete(:unconfirmed_email)

      if login
        match_by_login(login, conditions)
      elsif email
        where(email: email.downcase)
      elsif reset_password_token
        match_by_token(reset_password_token)
      elsif confirmation_token
        where(confirmation_token: confirmation_token)
      elsif unconfirmed_email
        where(unconfirmed_email: unconfirmed_email)
      end.first
    end

    def match_by_login(login, conditions)
      if login.match(/@/).present?
        where(conditions).where('lower(email) = ?', login.downcase)
      else
        where(conditions).where("REGEXP_REPLACE(phone, '[^0-9]', '', 'g') = ?", login.gsub(/[^\d]/, ''))
      end
    end

    def match_by_token(reset_password_token)
      where(reset_password_token: reset_password_token).update_all(reset_password_sent_at: Time.zone.now)
      where(reset_password_token: reset_password_token)
    end
  end

  def not_friends_followees
    followees.where.not(id: friends.pluck(:id))
  end

  private

  def generate_new_password
    self.password ||= SecureRandom.hex
  end

  def cropping_avatar?
    avatar_crop_x && avatar_crop_y && avatar_crop_h && avatar_crop_w
  end

  def crop_dreambook_bg
    dreambook_bg.recreate_versions!
  end

  def cropping_dreambook_bg?
    dreambook_bg_crop_x && dreambook_bg_crop_y && dreambook_bg_crop_h && dreambook_bg_crop_w
  end

  def crop_avatar
    avatar.recreate_versions!
  end
end
