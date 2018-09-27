require "administrate/base_dashboard"

class RaceDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    entrants: Field::HasMany,
    category: Field::BelongsTo,
    game: Field::HasOne,
    users: Field::HasMany,
    chat_room: Field::HasOne,
    chat_messages: Field::HasMany,
    creator: Field::BelongsTo.with_options(class_name: "User"),
    id: Field::Number,
    status_text: Field::String,
    start_time: Field::DateTime,
    finish_time: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    creator_id: Field::Number,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :entrants,
    :category,
    :game,
    :start_time,
    :finish_time
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :entrants,
    :category,
    :game,
    :users,
    :chat_room,
    :chat_messages,
    :creator,
    :id,
    :status_text,
    :start_time,
    :finish_time,
    :created_at,
    :updated_at,
    :creator_id,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :entrants,
    :category,
    :game,
    :users,
    :chat_room,
    :chat_messages,
    :creator,
    :status_text,
    :start_time,
    :finish_time,
    :creator_id,
  ].freeze

  # Overwrite this method to customize how races are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(race)
  #   "Race ##{race.id}"
  # end
end
