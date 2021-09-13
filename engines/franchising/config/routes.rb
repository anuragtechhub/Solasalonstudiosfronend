Franchising::Engine.routes.draw do
  root to: 'website#index'

  get 'privacy-policy', to: 'website#privacy_policy', :as => :privacy_policy
  get 'ada', to: 'website#ada', :as => :ada
  get 'thank-you', to: 'website#thank_you', :as => :thank_you
  get 'learn-more', to: 'website#learn_more', :as => :learn_more
  get 'our-story', to: 'website#our_story', :as => :our_story
  get 'why-sola', to: 'website#why_sola', :as => :why_sola
	get 'in-the-news', to: 'website#in_the_news', :as => :in_the_news

  resources :franchising_form, only: [:create]
  resources :franchise_articles, only: %i[index show]
end
