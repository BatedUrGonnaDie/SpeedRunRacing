require "administrate/base_dashboard"

class GameDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    categories: Field::HasMany,
    races: Field::HasMany,
    entrants: Field::HasMany,
    id: Field::Number,
    srdc_id: Field::String,
    name: Field::String,
    shortname: Field::String,
    cover_large: Field::String,
    cover_small: Field::String,
    weblink: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :categories,
    :races,
    :entrants,
    :id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :categories,
    :races,
    :entrants,
    :id,
    :srdc_id,
    :name,
    :shortname,
    :cover_large,
    :cover_small,
    :weblink,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :categories,
    :races,
    :entrants,
    :srdc_id,
    :name,
    :shortname,
    :cover_large,
    :cover_small,
    :weblink,
  ].freeze

  # Overwrite this method to customize how games are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(game)
    "Game: #{game.shortname}"
  end
end
