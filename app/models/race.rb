class Race < ApplicationRecord
  has_many :entrants, dependent: :destroy
  belongs_to :category
  has_one :game, through: :category
  has_many :users, through: :entrants
  has_one :chat_room, dependent: :destroy
  has_many :chat_messages, through: :chat_room
  belongs_to :creator, class_name: 'User', foreign_key: :creator_id, inverse_of: :created_races

  OPEN = 'Open Entry'.freeze
  PROGRESS = 'In Progress'.freeze
  ENDED = 'Ended'.freeze
  FORFEITED = 'All Forfeit'.freeze
  INACTIVE = 'Inactivity Closure'.freeze
  ACTIVE_RACES = [Race::OPEN, Race::PROGRESS].freeze
  CLOSED_RACES = [Race::FORFEITED, Race::INACTIVE].freeze
  VALID_API_PARAMS = %w[completed active combined].freeze

  scope :active, -> { where(status_text: Race::ACTIVE_RACES) }
  scope :completed, -> { where(status_text: Race::ENDED) }
  scope :closed, -> { where(status_text: Race::CLOSED_RACES) }
  scope :newest, -> { order(finish_time: :desc) }

  scope :by_game, ->(g) { joins(:category).where(categories: {game: g}) }

  def in_progress?
    status_text == Race::PROGRESS
  end

  def closed?
    CLOSED_RACES.include?(status_text)
  end

  def contains_user?(user)
    return nil if user.nil?
    users.pluck(:id).include?(user.id)
  end

  def entrant_for_user(user)
    return nil if user.nil?
    entrants.find_by(user_id: user.id)
  end

  def creator?(user)
    return false if user.nil?
    creator_id == user.id
  end

  def finished_entrants
    entrants.where.not(place: nil).count
  end

  def user_twitch_ids
    users.pluck(:twitch_id)
  end

  def started?
    start_time.present?
  end

  def finished?
    started? && finish_time.present?
  end

  def recalculate_places
    finished_entrants = entrants.where.not(finish_time: nil).order('entrants.finish_time ASC')
    finished_entrants.each_with_index { |e, i| e.update(place: (i + 1)) }
  end

  def start
    return if started?
    update(
      start_time: Time.now.utc + 15.seconds,
      status_text: Race::PROGRESS
    )
    RaceBroadcastJob.perform_now(self, 'race_started')
    MainBroadcastJob.perform_later('race_started', self)
  end

  def start_if_possible
    start if entrants.count == entrants.readied.count && entrants.readied.count >= 2
  end

  def finish
    return unless in_progress?
    update(
      finish_time: entrants.order('entrants.place DESC').limit(1).first.finish_time,
      status_text: Race::ENDED
    )
    recalculate_places
    RaceBroadcastJob.perform_now(self, 'race_completed')
    MainBroadcastJob.perform_later('race_completed', self)
    LockChatRoomJob.set(wait: 1.hour).perform_later(chat_room)
  end

  def finish_if_possible
    return unless entrants.count >= 2 && entrants.count == entrants.finished.count
    if entrants.completed.count.positive?
      finish
    else
      # If everyone forfeit the race or were disqualified, delete the race from history
      update(
        finish_time: Time.now.utc,
        status_text: Race::FORFEITED
      )
      queue_deletion!
    end
  end

  def duration
    return nil unless started?
    if finished?
      (finish_time - start_time)
    else
      (Time.now.utc - start_time)
    end
  end

  def sorted_entrants
    entrants.sort do |x, y|
      if x.place.nil?
        if y.place.nil?
          0
        elsif y.place.negative?
          -1
        else
          1
        end
      elsif y.place.nil?
        if x.place.nil?
          0
        elsif x.place.negative?
          1
        else
          -1
        end
      elsif x.place.negative?
        1
      elsif y.place.negative?
        -1
      else
        x.place <=> y.place
      end
    end
  end

  def queue_deletion!
    RemoveRaceJob.set(wait: 15.minutes).perform_later(self)
    RaceBroadcastJob.perform_later(self, 'race_deletion_queued')
    MainBroadcastJob.perform_later('race_completed', self)
  end
end
