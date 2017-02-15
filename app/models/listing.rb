class Listing
  include Mongoid::Document
  include Mongoid::Timestamps

  field :url, type: String
  field :text, type: String
  field :search, type: String
  field :search_page, type: String
  field :region, type: String
  field :state, type: String
  field :location, type: String
  field :seen, type: Boolean, default: false
  field :visited, type: Boolean, default: false
  field :hood, type: String
end
