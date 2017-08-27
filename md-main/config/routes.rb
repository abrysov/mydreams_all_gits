require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :dreamer, lambda { |u| u.role == :admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :dreamers, controllers: { passwords: 'passwords',
                                       sessions: 'sessions',
                                       confirmations: 'confirmations' }

  use_doorkeeper do
    skip_controllers :tokens, :token_info
  end

  scope :api do
    scope :v1 do
      use_doorkeeper do
        skip_controllers :applications, :authorized_applications
      end
    end
  end

  namespace :api do
    namespace :v1 do
      namespace :payments do
        resource :gateway, only: [:create]
      end
      resources :purchases, only: [:index]
      namespace :purchases do
        resources :certificates, only: [:create, :update]
        resources :vip_statuses, only: [:create, :update]
      end
      resources :products, only: [:index] do
        get :inapp, on: :collection
      end
      resources :banners, param: :route, only: [:show]
      resources :countries, only: [:index] do
        scope module: :countries do
          resources :cities, only: [:index, :create]
        end
      end
      namespace :feed do
        resources :comments, only: [:index]
        resources :recommendations, only: [:index]
        resources :updates, only: [:index]
      end
      resource :feed, only: [:show]
      resources :feedbacks, only: [:index]
      resources :dreams, only: [:index, :create, :show, :update, :destroy]
      namespace :top do
        resources :dreams, only: [:index]
      end
      resources :dreamers, only: [:index, :create, :show] do
        scope module: :dreamers do
          resources :photos, only: [:index]
          resources :friends, only: [:index]
          resources :followers, only: [:index]
          resources :dreams, only: [:index]
          resources :feeds, only: [:index]
          resources :certificates, only: [:index]
        end
      end
      resource :me, only: [:show]
      resource :profile, only: [:update, :destroy] do
        post :restore, on: :collection
      end
      namespace :profile, only: [:update] do
        resources :conversations, only: [:index]
        resource :status, only: [:show]
        resource :restore, only: [:create]
        resource :avatar, only: [:create, :destroy]
        resource :dreambook_bg, only: [:create]
        resources :dreams, only: [:index]
        resources :photos, only: [:index, :create, :destroy]
        resources :certificates, only: [:index]
        resources :followees, only: [:index]
        resources :friends, only: [:index, :destroy]
        resources :friendship_requests, only: [:index, :create, :destroy] do
          collection do
            post :accept
            post :reject
          end
        end
        resource :settings do
          collection do
            post :change_email
            post :change_password
          end
        end
      end
      resources :passwords, only: [] do
        collection do
          post :reset
        end
      end
      resource :static, only: [] do
        collection do
          get :terms
        end
      end
      resources :likes, only: [:index, :create, :destroy]
      resources :posts, only: [:index, :create, :show, :update, :destroy]
      resources :post_photos, only: [:create, :destroy]
      namespace :payments do
        resource :gateway, only: [:create]
      end
      resources :purchases, only: [:index]
      namespace :purchases do
        resources :certificates, only: [:create, :update]
        resources :vip_statuses, only: [:create, :update]
      end
      resources :products, only: [:index]
      get :search, to: 'search#index'
    end

    namespace :web do
      resources :banners, param: :route, only: [:show]
      namespace :feed do
        resources :updates, only: [:index]
        resources :comments, only: [:index]
        resources :recommendations, only: [:index]
      end
      resource :feed, only: [:show]
      resources :feedbacks, only: [:index]
      namespace :payments do
        resource :gateway, only: [:create]
      end
      resources :dreamers, only: [:index, :show] do
        scope module: :dreamers do
          resources :photos, only: [:index]
          resources :friends, only: [:index]
          resources :followers, only: [:index]
          resources :dreams, only: [:index]
          resources :feeds, only: [:index]
          resources :certificates, only: [:index]
        end
        collection do
          get :leaders
          get :celebrities
        end
      end
      resources :purchases, only: [:index]
      namespace :purchases do
        resources :certificates, only: [:create, :update]
        resources :vip_statuses, only: [:create, :update]
      end
      resources :products, only: [:index]
      resource :profile, only: [:update, :destroy] do
        post :restore, on: :collection
      end
      namespace :profile do
        resources :conversations, only: [:index, :create]
        resources :attachments, only: [:create]
        resource :status
        resource :avatar, only: [:create, :destroy]
        resource :dreambook_bg, only: [:create]
        resources :dreams, only: [:index]
        resources :photos, only: [:index, :create, :destroy]
        resources :certificates, only: [:index]
        resources :friends, only: [:index, :destroy]
        resources :followees, only: [:index]
        resources :friendship_requests, only: [:index, :create, :destroy] do
          collection do
            post :accept
            post :reject
          end
        end
        resource :settings do
          collection do
            post :change_email
            post :change_password
          end
        end
      end
      resources :leaders, only: [:index, :create]
      resources :dreams, only: [:index, :create, :show, :update, :destroy]
      resource :me, only: [:show]
      resources :countries, only: [:index] do
        scope module: :countries do
          resources :cities, only: [:index, :create]
        end
      end
      namespace :project do
        resources :posts, only: [:index]
      end
      namespace :top do
        resources :dreams, only: [:index]
      end
      resources :likes, only: [:index, :create, :destroy]
      resources :posts, only: [:index, :create, :show, :update, :destroy]
      resources :post_photos, only: [:create, :destroy]
      get :search, to: 'search#index'
    end
  end

  resources :markup, only: [:show]

  # DEPRECATED
  get :custom_pinterest_callback, to: 'dreamers#pinterest'

  # DEPRECATED
  get '/:entity_type/:entity_id/like', to: 'account/likes#like', as: :like
  # DEPRECATED
  get '/:entity_type/:entity_id/liked', to: 'account/likes#liked', as: :liked
  # DEPRECATED
  get '/:entity_type/:entity_id/unlike', to: 'account/likes#unlike', as: :unlike
  match '/cropper(.:format)' => 'croppers#new', via: :get, as: :cropper
  # DEPRECATED
  match '/cropper(.:format)' => 'croppers#create', via: :post, as: :save_cropper

  # DEPRECATED
  resources :comments, only: [:update, :destroy] do
    collection do
      match '/:entity_type/:entity_id', to: 'comments#create', via: :post, as: :create
      match '/:entity_type/:entity_id', to: 'comments#index', via: :get, as: :index
    end
  end

  # DEPRECATED
  post '/payment/paid', to: 'robokassa#paid'
  # DEPRECATED
  post '/payment/success', to: 'robokassa#success'
  # DEPRECATED
  post '/payment/fail', to: 'robokassa#fail'

  scope '(:locale)', locale: /en|ru/ do
    ###################################################################
    # Public section
    ###################################################################
    get '/d:id', to: 'dreamers#show', constraints: { id: /\d+/ }, as: :d

    scope '/d:dreamer_id', constraints: { dreamer_id: /\d+/ }, module: :dreamers, as: :d do
      resources :certificates
      resources :dreams, only: [:index, :show]
      resources :fulfilled_dreams, only: [:index]
      resources :friends, only: [:index]
      resources :friendships, only: [:index]
      resources :followers, only: [:index]
      resources :followees, only: [:index]
      resources :photos, only: [:index]
    end

    resources :settings, only: [] do
      collection do
        get :profile
        get :account
      end
    end

    resource :feed, only: [:show] do
      collection do
        get :comments
        get :my_comments
        get :recommendations
        get :my_recommendations
        get :updates
      end
    end

    resources :events, only: [:index]
    resource :account, only: [] do
      member do
        get :buy
        get :history
      end
    end
    resources :fulfilled_dreams

    resources :search, only: [:index]

    get :about,     to: 'static_pages#about'
    get :agreement, to: 'static_pages#agreement'

    ###################################################################
    # ADMIN SECTION
    ###################################################################
    namespace :admin do
      namespace :advertisement do
        resources :ad_pages, :advertisers, :banners
        root to: 'banners#index', as: :root
      end

      namespace :entity_control do
        resources :dreamers, :dreams, :comments, :posts, :photos, :top_dreams
        post 'statistic_for_period', to: 'dashboard#statistic_for_period'
        root to: 'dashboard#index', as: :root
      end

      namespace :mailing_list do
        resources :come_true_dreams do
          get :search, on: :collection
          get :send_mail, on: :collection
        end
        root to: redirect('admin/mailing_list/come_true_dreams'), as: :root
      end

      namespace :management do
        resources :products
        resources :lockeds, only: [:index]
        resources :purchases, only: [:index, :show]
        resources :transactions, only: [:index, :show]
        root to: 'products#index', as: :root
      end

      namespace :tags do
        resources :tags do
          post :add_parent_or_child, on: :member
        end
        get :search_tags, to: 'application#search_tags'
        resources :ad_banners, :ad_links, :dreams
        root to: 'tags#index', as: :root
      end
      root to: 'entity_control/dashboard#index', as: :root
    end

    ###################################################################
    # MODERATE SECTION
    ###################################################################

    namespace :moderate do
      resources :abuses, :dreams, :posts, :comments, :photos, :complains do
        get :search,  on: :collection
      end
      resources :dreamers do
        get :block,   on: :member
        get :unblock, on: :member
        get :search,  on: :collection
      end
      get :approve, to: 'application#approve'
      get :remove_approve, to: 'application#remove_approve'
      get :approve_ios, to: 'application#approve_ios'
      get :remove_ios_safe, to: 'application#remove_ios_safe'
      get :approve_all, to: 'application#approve_all'
      get :approve_ios_all, to: 'application#approve_ios_all'
      get :remove_ios_safe_all, to: 'application#remove_ios_safe_all'
      put :recovery, to: 'application#recovery'
      delete :delete, to: 'application#delete'
      root to: 'dreamers#index', as: :root
    end

    ###################################################################
    # System routes
    ###################################################################
    resource :payment, only: [] do
      collection do
        get :success
        get :fail
      end
    end

    get 'away/:link_hash', to: 'away#away', as: :away

    ###################################################################
    # DEPRECATED
    ###################################################################
    namespace 'account' do
      get 'recommend'
      resources :dreamers, only: [:show, :edit, :update] do
        member do
          get :remove_profile
          get :restore_profile
          patch :upload_crop_dreambook_bg
          patch :upload_crop_avatar
          patch :update_page_bg
          delete :page_background_destroy
          delete :dreambook_background_destroy
        end

        get :show

        resources :dreams, only: [:index, :show] do
          collection do
            post :index
            get :index
            get :sort
            get :show_suggested_dreams
          end
        end
        match 'friends_dreams', to: 'dreams#friends_dreams', via: [:get, :post]

        resources :posts, only: [:index, :show] do
          post :index, on: :collection
          get :show_suggested_posts, on: :collection
        end

        resources :friends, only: [:index] do
          collection do
            get :search
            post :index
            get :show_received_friends
          end
        end
        resources :certificates

        resources :subscriptions, only: [:index] do
          get :show_received_followers, on: :collection
        end
      end

      resources :certificates, only: [:index, :create] do
        get :show_gifted_certificates, on: :collection
        get :accept
      end
      resources :suggested_dreams, only: :none do
        member do
          get :accept
          get :reject
        end
      end
      resources :suggested_posts, only: :none do
        member do
          get :accept
          get :reject
        end
      end
      resources :fulfill_dreams, only: :none, path: '/dreams' do
        collection do
          get :fulfill, to: 'fulfill_dreams#new'
          post :fulfill, to: 'fulfill_dreams#create'
          get :success_fulfill
        end
      end
      resources :belive_in_dream, only: :none, path: '/dreams' do
        collection do
          get :belive_in_dream, to: 'belive_in_dream#new'
        end
      end
      resources :dreams, except: [:index] do
        member do
          get :take
          get '/suggest/:dreamer_id', to: 'dreams#suggest', as: :suggest
          post '/suggest_multiple/', to: 'dreams#suggest_multiple', as: :suggest_multiple
        end
      end
      resources :top_dreams, only: [:show], controller: :dreams
      resources :posts, except: [:index] do
        member do
          get '/suggest/:dreamer_id', to: 'posts#suggest', as: :suggest
          post '/suggest_multiple/', to: 'posts#suggest_multiple', as: :suggest_multiple
        end
      end
      resources :activities, only: [:index]
      resources :friends, only: [:index]
      match :mail, to: 'mail#index', as: :mail, via: [:get, :post]
    end

    # === OUT ACCOUNT
    # DEPRECATED
    resources :invoices do
      collection do
        post :buy_vip
        post :gift_vip
        get :certificate_self
      end
    end

    resources :top_dreams, only: [:show], controller: :dreams

    resources :top_dreams, only: [:index], controller: :dreams, action: :top

    # DEPRECATED
    resources :dreamer_cities, only: [:index]

    resources :dreamers, only: [:index, :create] do
      # DEPRECATED
      resources :messages, only: [:index, :create]
      # DEPRECATED
      resources :photos
    end

    # DEPRECATED
    resources :extra_dreamers, as: :dreamers, only: [:destroy], path: '/dreamers' do
      member do
        get :request_friendship # TODO: change method to post
        get :remove_inverse_subscription # TODO: change method to post
        get :remove_subscription # TODO: change method to post
        get :deny_request # TODO: change method to post
        get :subscribe # TODO: change method to post
        get :unsubscribe # TODO: change method to post
        get :accept_request # TODO: change method to post
        get :share_flybook
      end
    end

    resources :dreams, only: [:index, :show] do
      collection do
        # DEPRECATED
        post :create_preview
      end
    end

    # DEPRECATED
    resources :posts, only: [:index]

    # DEPRECATED
    post '/photos/upload', to: 'photos#upload', as: :upload
    # DEPRECATED
    post '/photobar/add', to: 'photobar#add', as: :add

    # DEPRECATED
    get 'ajax_modal/authorization', to: 'ajax_modal#authorization', as: :modal_authorization
    # DEPRECATED
    get 'ajax_modal/registration', to: 'ajax_modal#registration', as: :modal_registration
    # DEPRECATED
    get 'ajax_modal/edit_profile', to: 'ajax_modal#edit_profile', as: :modal_edit_profile
    # DEPRECATED
    get 'ajax_modal/new_password', to: 'ajax_modal#new_password', as: :modal_new_password
    # DEPRECATED
    get 'ajax_modal/edit_password', to: 'ajax_modal#edit_password', as: :modal_edit_password
    # DEPRECATED
    get 'ajax_modal/search', to: 'ajax_modal#search', as: :modal_search
    # DEPRECATED
    get 'ajax_modal/suggest_dream', to: 'ajax_modal#suggest_dream', as: :modal_suggest_dream
    # DEPRECATED
    get 'ajax_modal/suggest_post', to: 'ajax_modal#suggest_post', as: :modal_suggest_post
    # DEPRECATED
    get 'ajax_modal/commentators', to: 'ajax_modal#commentators', as: :modal_commentators
    # DEPRECATED
    get 'ajax_modal/liked_list', to: 'ajax_modal#liked_list', as: :modal_liked_list
    # DEPRECATED
    get 'ajax_modal/certificates', to: 'ajax_modal#certificates', as: :modal_certificates
    # DEPRECATED
    get 'ajax_modal/buy_certificates', to: 'ajax_modal#buy_certificates', as: :modal_buy_certificates
    # DEPRECATED
    get 'ajax_modal/take_dream', to: 'ajax_modal#take_dream', as: :modal_take_dream
    # DEPRECATED
    get 'ajax_modal/take_post', to: 'ajax_modal#take_post', as: :modal_take_post
    # DEPRECATED
    get 'ajax_modal/set_private', to: 'ajax_modal#set_private', as: :modal_set_private
    # DEPRECATED
    get 'ajax_modal/avatar', to: 'ajax_modal#avatar', as: :modal_avatar
    # DEPRECATED
    get 'ajax_modal/send_msg', to: 'ajax_modal#send_msg', as: :modal_send_msg
    # DEPRECATED
    get 'ajax_modal/share', to: 'ajax_modal#share', as: :modal_share
    # DEPRECATED
    get 'ajax_modal/fulfill_dream', to: 'ajax_modal#fulfill_dream', as: :modal_fulfill_dream
    # DEPRECATED
    get 'ajax_modal/create_fulfilled_dream', to: 'ajax_modal#create_fulfilled_dream', as: :modal_create_fulfilled_dream
    # DEPRECATED
    get 'ajax_modal/bad_image', to: 'ajax_modal#bad_image', as: :modal_bad_image
    # DEPRECATED
    get 'ajax_modal/add_to_feed', to: 'ajax_modal#add_to_feed', as: :modal_add_to_feed
    # DEPRECATED
    get 'ajax_modal/update_dreambook_bg', to: 'ajax_modal#update_dreambook_bg', as: :modal_update_dreambook_bg
    # DEPRECATED
    get 'ajax_modal/unviewed_news', to: 'ajax_modal#unviewed_news', as: :modal_unviewed_news

    root to: 'welcome#index', as: :root2
  end

  resources :yandexkassa, only: [] do
    collection do
      post :check
      post :aviso
      get :success
      get :failed
    end
  end

  controller 'dreamers', action: 'social_login' do
    get :facebook_callback
    get :twitter_callback
    get :instagram_callback
    get :vkontakte_callback
    get :odnoklassniki_callback
    get :google_plus_callback
  end

  resource :mailgun_webhook, only: [] do
    collection do
      post :complain
      post :unsubscribe
      post :bounce
    end
  end

  root to: 'welcome#index'
  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#server_error'
  get '/500', to: 'errors#server_error'
end
