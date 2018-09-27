require "administrate/base_dashboard"

class EntrantDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    race: Field::BelongsTo,
    user: Field::BelongsTo,
    id: Field::Number,
    place: Field::Number,
    finish_time: Field::DateTime,
    ready: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :race,
    :user,
    :id,
    :place
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :race,
    :user,
    :id,
    :place,
    :finish_time,
    :ready,
    :created_at,
    :updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :race,
    :user,
    :place,
    :finish_time,
    :ready
  ].freeze

  # Overwrite this method to customize how entrants are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(entrant)
  #   "Entrant ##{entrant.id}"
  # end
end
