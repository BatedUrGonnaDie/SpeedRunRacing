class Race < ApplicationRecord
  has_many :entrants, dependent: :destroy
  belongs_to :category
  has_one :game, through: :category
  has_many :users, through: :entrants
  has_one :chat_room
  has_many :chat_messages, through: :chat_room

  OPEN = 'Open Entry'.freeze
  PROGRESS = 'In Progress'.freeze
  ENDED = 'Ended'.freeze
  ACTIVE_RACES = [Race::OPEN, Race::PROGRESS].freeze

  scope :active, -> { includes(:game, :category, :entrants).where(status_text: Race::ACTIVE_RACES) }
  scope :completed, -> { includes(:game, :category, :entrants).where(status_text: Race::ENDED) }
  scope :newest, -> { order(finish_time: :desc) }

  def in_progress?
    status_text == Race::PROGRESS
  end

  def contains_user?(user)
    return nil if user.nil?
    users.map(&:id).include?(user.id)
  end

  def entrant_for_user(user)
    return nil if user.nil?
    entrants.where(user_id: user.id).try(:[], 0)
  end

  def user_twitch_ids
    users.map(&:twitch_id)
  end

  def started?
    start_time.present?
  end

  def finished?
    finish_time.present?
  end

  def recalculate_places
    # TODO: needs testing to make sure this acutally works correctly
    finished_entrants = entrants.where.not(finish_time: nil).order('entrants.finish_time ASC')
    finished_entrants.each_with_index { |e, i| e.update(place: (i + 1)) }
  end

  def start
    return if started?
    update(
      start_time: Time.now.utc + 15.seconds,
      status_text: Race::PROGRESS
    )
    RaceBroadcastJob.perform_later(self, 'race_started')
    MainBroadcastJob.perform_later('race_started', self)
  end

  def start_if_possible
    start if entrants.count == entrants.readied.count && entrants.readied.count >= 2
  end

  def finish
    return if finished?
    update(
      finish_time: entrants.order('entrants.place DESC').limit(1).first.finish_time,
      status_text: Race::ENDED
    )
    recalculate_places
    RaceBroadcastJob.perform_later(self, 'race_completed')
    MainBroadcastJob.perform_later('race_completed', self)
  end

  def finish_if_possible
    return unless entrants.count >= 2 && entrants.count == entrants.finished.count
    if entrants.completed.count > 0
      finish
    else
      # If everyone forfeit the race or were disqualified, delete the race from history
      destroy
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
        elsif y.place < 0
          -1
        else
          1
        end
      elsif y.place.nil?
        if x.place.nil?
          0
        elsif x.place < 0
          1
        else
          -1
        end
      elsif x.place < 0
        1
      elsif y.place < 0
        -1
      else
        x.place <=> y.place
      end
    end
  end
end
